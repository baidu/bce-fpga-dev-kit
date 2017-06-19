//Confidential and proprietary information of Baidu, Inc
//////////////////////////////////////////////////////
//
//
//    Version:1.0
//    FileName: sp_sim.v
//    Data last Modified:
//    Data Created:June. 7th, 2017
//
//
//
//    Device:xcku115-flvf1924-2-e
//    Purpose: simulate for static part of FPGA cloud.
//
//
//    Reference:
//    Revision History:
//    Rev 1.0 - First created, ruanyuan,
//    email: ruanyuan@baidu.com
//////////////////////////////////////////////////////
`timescale 1ns / 1ps

module sp_sim #(
   parameter DMA_NUM    = 4,
   parameter DATA_WIDTH = 256,
   parameter ADDR_WIDTH = 64,
   parameter MASK_WIDTH = DATA_WIDTH/8,
   parameter ID_WIDTH   = 4,
   parameter ADDR_ALIGN_BITS = $clog2(MASK_WIDTH)
)(
   input                    clk,
   input                    rst,

   // AXI Master AW channel
   output [ADDR_WIDTH-1:0]  M_AXI_araddr,
   output [1:0]             M_AXI_arburst,
   output [3:0]             M_AXI_arcache,
   output [ID_WIDTH-1:0]    M_AXI_arid,
   output [7:0]             M_AXI_arlen,
   output                   M_AXI_arlock,
   output [2:0]             M_AXI_arprot,
   output [3:0]             M_AXI_arqos,
   output [3:0]             M_AXI_arregion,
   input                    M_AXI_arready,
   output [2:0]             M_AXI_arsize,
   output                   M_AXI_arvalid,
   // AXI Master AR channel
   output [ADDR_WIDTH-1:0]  M_AXI_awaddr,
   output [1:0]             M_AXI_awburst,
   output [3:0]             M_AXI_awcache,
   output [ID_WIDTH-1:0]    M_AXI_awid,
   output [7:0]             M_AXI_awlen,
   output                   M_AXI_awlock,
   output [2:0]             M_AXI_awprot,
   output [3:0]             M_AXI_awqos,
   output [3:0]             M_AXI_awregion,
   input                    M_AXI_awready,
   output [2:0]             M_AXI_awsize,
   output                   M_AXI_awvalid,
   // AXI Master B channel
   input  [ID_WIDTH-1:0]    M_AXI_bid,
   output                   M_AXI_bready,
   input  [1:0]             M_AXI_bresp,
   input                    M_AXI_bvalid,
   // AXI Master R channel
   input  [DATA_WIDTH-1:0]  M_AXI_rdata,
   input  [ID_WIDTH-1:0]    M_AXI_rid,
   input                    M_AXI_rlast,
   output                   M_AXI_rready,
   input  [1:0]             M_AXI_rresp,
   input                    M_AXI_rvalid,
   // AXI Master W channel
   output [DATA_WIDTH-1:0]  M_AXI_wdata,
   output                   M_AXI_wlast,
   input                    M_AXI_wready,
   output [MASK_WIDTH-1:0]  M_AXI_wstrb,
   output                   M_AXI_wvalid,

   // AXI Lite Master AW channel
   output [15:0]            M_AXI_LITE_araddr,
   output [2:0]             M_AXI_LITE_arprot,
   input                    M_AXI_LITE_arready,
   output                   M_AXI_LITE_arvalid,
   // AXI Lite Master AR channel
   output [15:0]            M_AXI_LITE_awaddr,
   output [2:0]             M_AXI_LITE_awprot,
   input                    M_AXI_LITE_awready,
   output                   M_AXI_LITE_awvalid,
   // AXI Lite Master B channel
   output                   M_AXI_LITE_bready,
   input  [1:0]             M_AXI_LITE_bresp,
   input                    M_AXI_LITE_bvalid,
   // AXI Lite Master R channel
   input  [31:0]            M_AXI_LITE_rdata,
   output                   M_AXI_LITE_rready,
   input  [1:0]             M_AXI_LITE_rresp,
   input                    M_AXI_LITE_rvalid,
   // AXI Lite Master W channel
   output [31:0]            M_AXI_LITE_wdata,
   input                    M_AXI_LITE_wready,
   output [3:0]             M_AXI_LITE_wstrb,
   output                   M_AXI_LITE_wvalid,

   // interrupt signals
   input  [15:0]            usr_irq_req,
   output reg [15:0]        usr_irq_ack
);

   // Host Memory Interface for static
   wire   [DATA_WIDTH-1:0]  hostmem_wr_data;
   wire   [MASK_WIDTH-1:0]  hostmem_wr_datamask;
   wire   [ADDR_WIDTH-1:0]  hostmem_wr_addr;
   wire   [DATA_WIDTH-1:0]  hostmem_rd_data;
   wire                     hostmem_rd_data_vld;
   wire                     hostmem_rd_en;
   wire   [ADDR_WIDTH-1:0]  hostmem_rd_addr;

   // Host Memory Interface for testbench
   reg    [DATA_WIDTH-1:0]  tb_wr_data;
   reg    [MASK_WIDTH-1:0]  tb_wr_datamask;
   reg    [ADDR_WIDTH-1:0]  tb_wr_addr;
   wire   [DATA_WIDTH-1:0]  tb_rd_data;
   wire                     tb_rd_data_vld;
   reg                      tb_rd_en;
   reg    [ADDR_WIDTH-1:0]  tb_rd_addr;

   // Receive DMA req
   reg    [DMA_NUM*ADDR_WIDTH-1:0] dma_src_addr;
   reg    [DMA_NUM*ADDR_WIDTH-1:0] dma_dst_addr;
   reg    [DMA_NUM*32-1:0]         dma_len;
   reg    [DMA_NUM-1:0]            dma_direction;
   reg    [DMA_NUM-1:0]            dma_start;
   wire   [DMA_NUM-1:0]            dma_status;

   // Receive axi normal req
   reg    [ADDR_WIDTH-1:0]  normal_rd_addr;
   reg                      normal_rd_en;
   wire                     normal_rd_data_vld;
   wire   [DATA_WIDTH-1:0]  normal_rd_data;
   reg    [ADDR_WIDTH-1:0]  normal_wr_addr;
   reg    [DATA_WIDTH-1:0]  normal_wr_data;
   reg    [MASK_WIDTH-1:0]  normal_wr_datamask;

   // Receive axi lite normal req
   reg    [15:0]            normal_lite_rd_addr;
   reg                      normal_lite_rd_en;
   wire                     normal_lite_rd_data_vld;
   wire   [31:0]            normal_lite_rd_data;
   reg    [15:0]            normal_lite_wr_addr;
   reg    [31:0]            normal_lite_wr_data;
   reg    [3:0]             normal_lite_wr_datamask;

///////////module instance////////////
axi_master_bfm #(
   .DMA_NUM(DMA_NUM),
   .DATA_WIDTH(DATA_WIDTH),
   .ADDR_WIDTH(ADDR_WIDTH),
   .MASK_WIDTH(MASK_WIDTH),
   .ID_WIDTH(ID_WIDTH)
)axi_master_bfm(
   .clk(clk),
   .rst(rst),

   // AXI Master AW channel
   .araddr(M_AXI_araddr),
   .arburst(M_AXI_arburst),
   .arcache(M_AXI_arcache),
   .arid(M_AXI_arid),
   .arlen(M_AXI_arlen),
   .arlock(M_AXI_arlock),
   .arprot(M_AXI_arprot),
   .arqos(M_AXI_arqos),
   .arregion(M_AXI_arregion),
   .arready(M_AXI_arready),
   .arsize(M_AXI_arsize),
   .arvalid(M_AXI_arvalid),
   // AXI Master AR channel
   .awaddr(M_AXI_awaddr),
   .awburst(M_AXI_awburst),
   .awcache(M_AXI_awcache),
   .awid(M_AXI_awid),
   .awlen(M_AXI_awlen),
   .awlock(M_AXI_awlock),
   .awprot(M_AXI_awprot),
   .awqos(M_AXI_awqos),
   .awregion(M_AXI_awregion),
   .awready(M_AXI_awready),
   .awsize(M_AXI_awsize),
   .awvalid(M_AXI_awvalid),
   // AXI Master B channel
   .bid(M_AXI_bid),
   .bready(M_AXI_bready),
   .bresp(M_AXI_bresp),
   .bvalid(M_AXI_bvalid),
   // AXI Master R channel
   .rdata(M_AXI_rdata),
   .rid(M_AXI_rid),
   .rlast(M_AXI_rlast),
   .rready(M_AXI_rready),
   .rresp(M_AXI_rresp),
   .rvalid(M_AXI_rvalid),
   // AXI Master W channel
   .wdata(M_AXI_wdata),
   .wlast(M_AXI_wlast),
   .wready(M_AXI_wready),
   .wstrb(M_AXI_wstrb),
   .wvalid(M_AXI_wvalid),

   // Host Memory Interface
   .mem_wr_cmd_rdy(1'b1),
   .mem_wr_data(hostmem_wr_data),
   .mem_wr_datamask(hostmem_wr_datamask),
   .mem_wr_addr(hostmem_wr_addr),
   .mem_rd_cmd_rdy(1'b1),
   .mem_rd_data(hostmem_rd_data),
   .mem_rd_data_vld(hostmem_rd_data_vld),
   .mem_rd_en(hostmem_rd_en),
   .mem_rd_addr(hostmem_rd_addr),

   // Receive DMA req
   .dma_src_addr(dma_src_addr),
   .dma_dst_addr(dma_dst_addr),
   .dma_len(dma_len),
   .dma_direction(dma_direction),
   .dma_start(dma_start),
   .dma_status(dma_status),

   // Receive normal req
   .normal_rd_addr(normal_rd_addr),
   .normal_rd_en(normal_rd_en),
   .normal_rd_data_vld(normal_rd_data_vld),
   .normal_rd_data(normal_rd_data),
   .normal_wr_addr(normal_wr_addr),
   .normal_wr_data(normal_wr_data),
   .normal_wr_datamask(normal_wr_datamask)
);

//HOST Memory Simulate

mem_2ports #(
   .DATA_WIDTH(DATA_WIDTH),
   .ADDR_WIDTH(ADDR_WIDTH),
   .HOST_MEM_SIZE(256*1024)
)host_mem(
   .clk(clk),
   .rst(rst),

   .c1_wr_data(hostmem_wr_data),
   .c1_wr_datamask(hostmem_wr_datamask),
   .c1_wr_addr(hostmem_wr_addr),
   .c1_rd_data(hostmem_rd_data),
   .c1_rd_data_vld(hostmem_rd_data_vld),
   .c1_rd_en(hostmem_rd_en),
   .c1_rd_addr(hostmem_rd_addr),

   .c2_wr_data(tb_wr_data),
   .c2_wr_datamask(tb_wr_datamask),
   .c2_wr_addr(tb_wr_addr),
   .c2_rd_data(tb_rd_data),
   .c2_rd_data_vld(tb_rd_data_vld),
   .c2_rd_en(tb_rd_en),
   .c2_rd_addr(tb_rd_addr)
);

   axi_l_master_bfm #(
      .DATA_WIDTH(32),
      .ADDR_WIDTH(16)
   )normal_req_processor(
      .clk(clk),
      .rst(rst),

      .normal_rd_cmd_rdy(),
      .normal_rd_addr(normal_lite_rd_addr),
      .normal_rd_en(normal_lite_rd_en),
      .normal_rd_data_vld(normal_lite_rd_data_vld),
      .normal_rd_data(normal_lite_rd_data),
      .normal_wr_cmd_rdy(),
      .normal_wr_addr(normal_lite_wr_addr),
      .normal_wr_data(normal_lite_wr_data),
      .normal_wr_datamask(normal_lite_wr_datamask),

      .araddr(M_AXI_LITE_araddr),
      .arprot(M_AXI_LITE_arprot),
      .arready(M_AXI_LITE_arready),
      .arvalid(M_AXI_LITE_arvalid),
      .awaddr(M_AXI_LITE_awaddr),
      .awprot(M_AXI_LITE_awprot),
      .awready(M_AXI_LITE_awready),
      .awvalid(M_AXI_LITE_awvalid),
      .bready(M_AXI_LITE_bready),
      .bresp(M_AXI_LITE_bresp),
      .bvalid(M_AXI_LITE_bvalid),
      .rdata(M_AXI_LITE_rdata),
      .rready(M_AXI_LITE_rready),
      .rresp(M_AXI_LITE_rresp),
      .rvalid(M_AXI_LITE_rvalid),
      .wdata(M_AXI_LITE_wdata),
      .wready(M_AXI_LITE_wready),
      .wstrb(M_AXI_LITE_wstrb),
      .wvalid(M_AXI_LITE_wvalid)
   );

///////////task define////////////
task axi_wr;
   input  [ADDR_WIDTH-1:0]                 addr;
   input  [DATA_WIDTH-1:0]                 data;
   input  [3:0]                            size;
   reg    [2*DATA_WIDTH-1:0]               data_buf;
   reg    [2*MASK_WIDTH-1:0]               datamask_buf;
   reg    [ADDR_WIDTH-ADDR_ALIGN_BITS-1:0] addr_nxt;
   begin
      @(posedge clk)
      addr_nxt     = addr[ADDR_WIDTH-1:ADDR_ALIGN_BITS]+'d1;
      data_buf     = data << (8 * addr[ADDR_ALIGN_BITS-1:0]);
      datamask_buf = ({(MASK_WIDTH){1'b1}} >> (MASK_WIDTH-(1'b1 << size))) << addr[ADDR_ALIGN_BITS-1:0];
      #0.1;
      normal_wr_addr     = {addr[ADDR_WIDTH-1:ADDR_ALIGN_BITS],{(ADDR_ALIGN_BITS){1'b0}}};
      normal_wr_data     = data_buf[DATA_WIDTH-1:0];
      normal_wr_datamask = datamask_buf[MASK_WIDTH-1:0];
      @(posedge clk)
      #0.1;
      if (datamask_buf[2*MASK_WIDTH-1:MASK_WIDTH] != 'd0) begin
         normal_wr_addr     = {addr_nxt,{(ADDR_ALIGN_BITS){1'b0}}};
         normal_wr_data     = data_buf[2*DATA_WIDTH-1:DATA_WIDTH];
         normal_wr_datamask = datamask_buf[2*MASK_WIDTH-1:MASK_WIDTH];
         @(posedge clk)
         #0.1;
      end
      normal_wr_datamask = 'd0;
   end
endtask

task axi_rd;
   input  [ADDR_WIDTH-1:0]                 addr;
   output [DATA_WIDTH-1:0]                 data;
   input  [3:0]                            size;
   reg    [2*DATA_WIDTH-1:0]               data_buf;
   reg    [ADDR_WIDTH-ADDR_ALIGN_BITS-1:0] addr_nxt;
   begin
      @(posedge clk)
      addr_nxt       = addr[ADDR_WIDTH-1:ADDR_ALIGN_BITS]+'d1;
      #0.1;
      normal_rd_addr = {addr[ADDR_WIDTH-1:ADDR_ALIGN_BITS],{(ADDR_ALIGN_BITS){1'b0}}};
      normal_rd_en   = 1'b1;
      @(posedge clk)
      #0.1;
      normal_rd_en   = 1'b0;
      wait (normal_rd_data_vld);
      #0.1;
      data_buf[DATA_WIDTH-1:0] = normal_rd_data;
      if (addr[ADDR_ALIGN_BITS-1:0] != 'd0) begin
         @(posedge clk)
         #0.1;
         normal_rd_addr = {addr_nxt,{(ADDR_ALIGN_BITS){1'b0}}};
         normal_rd_en   = 1'b1;
         @(posedge clk)
         #0.1;
         normal_rd_en   = 1'b0;
         wait (normal_rd_data_vld);
         #0.1;
         data_buf[2*DATA_WIDTH-1:DATA_WIDTH] = normal_rd_data;
      end
      data = (data_buf << (2*DATA_WIDTH-8*addr[ADDR_ALIGN_BITS-1:0]-(4'd8 << size))) >> (2*DATA_WIDTH-(4'd8 << size));
      //$display ("%g Card Mem read %h with address %h", $time, data, addr);
   end
endtask

task dma_op_cfg;
   input [1:0]            channel;
   input [ADDR_WIDTH-1:0] src_addr;
   input [ADDR_WIDTH-1:0] dst_addr;
   input [31:0]           len;
   input                  direction;
   reg   [32*DMA_NUM-1:0] len_mask;
   reg   [ADDR_WIDTH*DMA_NUM-1:0] addr_mask;
   begin
      @(posedge clk);
      #0.1;
      len_mask     = {(32){1'b1}} << (channel*32);
      dma_len      = (dma_len & ~len_mask) | ({(DMA_NUM){len}} & len_mask);
      addr_mask    = {(ADDR_WIDTH){1'b1}} << (channel*ADDR_WIDTH);
      dma_src_addr = (dma_src_addr & ~addr_mask) | ({(DMA_NUM){src_addr}} & addr_mask);
      dma_dst_addr = (dma_dst_addr & ~addr_mask) | ({(DMA_NUM){dst_addr}} & addr_mask);
      dma_direction[channel] = direction;
      if (direction == 1'b0) begin
         $display ("%g the operation of DMA channel %h will moves data form host mem %h to card mem %h for %d bytes.", $time, channel, src_addr, dst_addr, len);
      end
      else  begin
         $display ("%g the operation of DMA channel %h will moves data form card mem %h to host mem %h for %d bytes.", $time, channel, src_addr, dst_addr, len);
      end
   end
endtask

task dma_op_start;
   input [1:0]            channel;
   begin
      @(posedge clk);
      #0.1;
      dma_start          = 'd0;
      dma_start[channel] = 1'b1;
      @(posedge clk);
      #0.1;
      dma_start          = 'd0;
      $display ("%g Start the operation of DMA channel %h", $time, channel);
      @(posedge clk);
      @(posedge clk);
   end
endtask

task dma_op_check;
   input [1:0]            channel;
   output                 status;
   begin
      @(posedge clk);
      #0.1;
      status = dma_status[channel];
      //$display ("%g The status of DMA channel %h is %h", $time, channel, status);
   end
endtask

task host_mem_rd;
   input  [ADDR_WIDTH-1:0] addr;
   output [DATA_WIDTH-1:0] data;
   begin
      @(posedge clk);
      #0.1;
      tb_rd_en = 1'b1;
      tb_rd_addr = addr;
      @(posedge clk);
      #0.1;
      tb_rd_en = 1'b0;
      wait (tb_rd_data_vld);
      #0.1;
      data = tb_rd_data;
      //$display ("%g Host Mem read %h with address %h", $time, data, addr);
   end
endtask

task host_mem_rd_char;
   input  [ADDR_WIDTH-1:0] addr;
   output [7:0]            data;
   begin
      @(posedge clk);
      #0.1;
      tb_rd_en = 1'b1;
      tb_rd_addr = {addr[ADDR_WIDTH-1:ADDR_ALIGN_BITS],{(ADDR_ALIGN_BITS){1'b0}}};
      @(posedge clk);
      #0.1;
      tb_rd_en = 1'b0;
      wait (tb_rd_data_vld);
      #0.1;
      data = (tb_rd_data << (DATA_WIDTH-8-addr[ADDR_ALIGN_BITS-1:0]*8)) >> (DATA_WIDTH-8);
      //$display ("%g Host Mem read_char %h with address %h", $time, data, addr);
   end
endtask

task host_mem_wr;
   input  [ADDR_WIDTH-1:0] addr;
   input  [DATA_WIDTH-1:0] data;
   input  [MASK_WIDTH-1:0] datamask;
   begin
      @(posedge clk);
      #0.1;
      tb_wr_addr     = addr;
      tb_wr_data     = data;
      tb_wr_datamask = datamask;
      @(posedge clk);
      #0.1;
      tb_wr_datamask = 'd0;
      //$display ("%g Host Mem write %h with address %h and datamask %h", $time, data, addr, datamask);
   end
endtask

task host_mem_wr_char;
   input  [ADDR_WIDTH-1:0] addr;
   input  [7:0]            data;
   begin
      @(posedge clk);
      #0.1;
      tb_wr_addr     = {addr[ADDR_WIDTH-1:ADDR_ALIGN_BITS],{(ADDR_ALIGN_BITS){1'b0}}};
      tb_wr_data     = data << (8*addr[ADDR_ALIGN_BITS-1:0]);
      tb_wr_datamask = 1'd1 << addr[ADDR_ALIGN_BITS-1:0];
      @(posedge clk);
      #0.1;
      tb_wr_datamask = 'd0;
      $display ("%g Host Mem write_char %h with address %h", $time, data, addr);
   end
endtask

task axi_l_rd;
   input  [15:0] addr;
   output [31:0] data;
   begin
      @(posedge clk);
      #0.1;
      normal_lite_rd_addr     = addr;
      normal_lite_rd_en       = 1'b1;
      @(posedge clk);
      #0.1;
      normal_lite_rd_en       = 1'b0;
      wait (normal_lite_rd_data_vld);
      #0.1;
      data = normal_lite_rd_data;
      $display ("%g AXI lite read %h with address %h", $time, data, addr);
   end
endtask

task axi_l_wr;
   input [15:0] addr;
   input [31:0] data;
   input [3:0]  mask;
   begin
      @(posedge clk);
      #0.1;
      normal_lite_wr_addr     = addr;
      normal_lite_wr_data     = data;
      normal_lite_wr_datamask = mask;
      @(posedge clk);
      #0.1;
      normal_lite_wr_addr     = 'd0;
      normal_lite_wr_data     = 'd0;
      normal_lite_wr_datamask = 'd0;
      $display ("%g AXI lite write %h with address %h", $time, data, addr);
   end
endtask

task interrupt_wait;
   input [3:0] num;
   begin
      wait (usr_irq_req[num]);
      @(posedge clk);
      #0.1;
      usr_irq_ack[num] = 1'b1;
      axi_l_wr(16'hfc00,{16'h1 << num},4'hf);
      wait (~usr_irq_req[num]);
      @(posedge clk);
      #0.1;
      usr_irq_ack[num] = 1'b0;
   end
endtask

///////////simulation start////////////
initial begin
   usr_irq_ack             = 'd0;
   normal_wr_datamask      = 'd0;
   normal_wr_data          = 'd0;
   normal_wr_addr          = 'd0;
   normal_rd_en            = 'd0;
   normal_rd_addr          = 'd0;
   normal_lite_wr_datamask = 'd0;
   normal_lite_wr_data     = 'd0;
   normal_lite_wr_addr     = 'd0;
   normal_lite_rd_en       = 'd0;
   normal_lite_rd_addr     = 'd0;
   dma_src_addr            = 'd0;
   dma_dst_addr            = 'd0;
   dma_len                 = 'd0;
   dma_direction           = 'd0;
   dma_start               = 'd0;
   tb_wr_data              = 'd0;
   tb_wr_datamask          = 'd0;
   tb_wr_addr              = 'd0;
   tb_rd_en                = 'd0;
   tb_rd_addr              = 'd0;
end

endmodule
