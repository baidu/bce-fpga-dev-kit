//Confidential and proprietary information of Baidu, Inc
//////////////////////////////////////////////////////
//
//
//    Version:1.0
//    FileName: rp_bd_simple.v
//    Data last Modified:
//    Data Created:June. 15th, 2017
//
//
//
//    Device:xcku115-flvf1924-2-e
//    Purpose: The simple project for FPGA cloud.
//
//
//    Reference:
//    Revision History:
//    Rev 1.0 - First created, ruanyuan,
//    email: ruanyuan@baidu.com
//////////////////////////////////////////////////////
`timescale 1 ps / 1 ps
`include "usr_ddr4_define.vh"

module rp_bd #(
   parameter DATA_WIDTH = 256,
   parameter ADDR_WIDTH = 64,
   parameter MASK_WIDTH = DATA_WIDTH/8,
   parameter ID_WIDTH   = 4
)(

   `include "rp_port_app.vh"
   // AXI Slave AW channel
   input  [ADDR_WIDTH-1:0]  S_AXI_araddr,
   input  [1:0]             S_AXI_arburst,
   input  [3:0]             S_AXI_arcache,
   input  [ID_WIDTH-1:0]    S_AXI_arid,
   input  [7:0]             S_AXI_arlen,
   input                    S_AXI_arlock,
   input  [2:0]             S_AXI_arprot,
   input  [3:0]             S_AXI_arqos,
   input  [3:0]             S_AXI_arregion,
   output                   S_AXI_arready,
   input  [2:0]             S_AXI_arsize,
   input                    S_AXI_arvalid,
   // AXI Slave AR channel
   input  [ADDR_WIDTH-1:0]  S_AXI_awaddr,
   input  [1:0]             S_AXI_awburst,
   input  [3:0]             S_AXI_awcache,
   input  [ID_WIDTH-1:0]    S_AXI_awid,
   input  [7:0]             S_AXI_awlen,
   input                    S_AXI_awlock,
   input  [2:0]             S_AXI_awprot,
   input  [3:0]             S_AXI_awqos,
   input  [3:0]             S_AXI_awregion,
   output                   S_AXI_awready,
   input  [2:0]             S_AXI_awsize,
   input                    S_AXI_awvalid,
   // AXI Slave B channel
   output [ID_WIDTH-1:0]    S_AXI_bid,
   input                    S_AXI_bready,
   output [1:0]             S_AXI_bresp,
   output                   S_AXI_bvalid,
   // AXI Slave R channel
   output [DATA_WIDTH-1:0]  S_AXI_rdata,
   output [ID_WIDTH-1:0]    S_AXI_rid,
   output                   S_AXI_rlast,
   input                    S_AXI_rready,
   output [1:0]             S_AXI_rresp,
   output                   S_AXI_rvalid,
   // AXI Slave W channel
   input  [DATA_WIDTH-1:0]  S_AXI_wdata,
   input                    S_AXI_wlast,
   output                   S_AXI_wready,
   input  [MASK_WIDTH-1:0]  S_AXI_wstrb,
   input                    S_AXI_wvalid,

   // AXI lite Slave AW channel
   input  [15:0]            S_AXI_LITE_araddr,
   input  [2:0]             S_AXI_LITE_arprot,
   output                   S_AXI_LITE_arready,
   input                    S_AXI_LITE_arvalid,
   // AXI lite Slave AR channel
   input  [15:0]            S_AXI_LITE_awaddr,
   input  [2:0]             S_AXI_LITE_awprot,
   output                   S_AXI_LITE_awready,
   input                    S_AXI_LITE_awvalid,
   // AXI lite Slave B channel
   input                    S_AXI_LITE_bready,
   output [1:0]             S_AXI_LITE_bresp,
   output                   S_AXI_LITE_bvalid,
   // AXI lite Slave R channel
   output [31:0]            S_AXI_LITE_rdata,
   input                    S_AXI_LITE_rready,
   output [1:0]             S_AXI_LITE_rresp,
   output                   S_AXI_LITE_rvalid,
   // AXI lite Slave W channel
   input  [31:0]            S_AXI_LITE_wdata,
   output                   S_AXI_LITE_wready,
   input  [3:0]             S_AXI_LITE_wstrb,
   input                    S_AXI_LITE_wvalid,

   input                    s_axi_aclk,
   input                    s_axi_aresetn,
   input                    usr_clk,
   input                    usr_clk_rst,
   input                    i_soft_rst_n,
   input  [15:0]            usr_irq_ack,
   output [15:0]            usr_irq_req
);

   localparam TEST_REG1_ADDR = 16'd0;
   localparam TEST_REG2_ADDR = 16'd4;
   localparam TEST_REG3_ADDR = 16'd8;
   localparam TEST_REG4_ADDR = 16'd12;

   // test reg
   reg  [31:0] test_reg1_r;
   reg  [31:0] test_reg2_r;
   reg  [31:0] test_reg3_r;
   reg  [31:0] test_reg4_r;
   wire [31:0] vio_out;


   // not uesd channel: interrupt

   assign usr_irq_req   = 16'b0;

   // axi lite read channel
   reg [31:0] rd_data_r;
   reg        rd_data_vld_r;

   assign S_AXI_LITE_arready = 1'b1;
   assign S_AXI_LITE_rresp   = 2'b0;
   assign S_AXI_LITE_rvalid  = rd_data_vld_r;
   assign S_AXI_LITE_rdata   = rd_data_r;

   always @(posedge s_axi_aclk) begin
      rd_data_vld_r <= S_AXI_LITE_arvalid;
      rd_data_r     <= (S_AXI_LITE_araddr == TEST_REG1_ADDR) ? test_reg1_r :
                       (S_AXI_LITE_araddr == TEST_REG2_ADDR) ? test_reg2_r :
                       (S_AXI_LITE_araddr == TEST_REG3_ADDR) ? test_reg3_r :
                       (S_AXI_LITE_araddr == TEST_REG4_ADDR) ? test_reg4_r :
                       'd0;
   end

   // axi lite write channel
   reg  w_rdy_r;
   reg  b_vld_r;

   assign S_AXI_LITE_awready = w_rdy_r;
   assign S_AXI_LITE_wready  = w_rdy_r;
   assign S_AXI_LITE_bvalid  = b_vld_r;
   assign S_AXI_LITE_bresp   = 2'b0;

   always @(posedge s_axi_aclk) begin
      if (~s_axi_aresetn) begin
         w_rdy_r <= 1'b0;
      end
      else if (w_rdy_r) begin
         w_rdy_r <= 1'b0;
      end
      else if (~b_vld_r && S_AXI_LITE_awvalid && S_AXI_LITE_wvalid) begin
         w_rdy_r <= 1'b1;
      end
   end

   always @(posedge s_axi_aclk) begin
      if (~s_axi_aresetn) begin
         b_vld_r <= 1'b0;
      end
      else if (b_vld_r && S_AXI_LITE_bready) begin
         b_vld_r <= 1'b0;
      end
      else if (S_AXI_LITE_awvalid && S_AXI_LITE_awready) begin
         b_vld_r <= 1'b1;
      end
   end

   always @(posedge s_axi_aclk) begin
      if (~s_axi_aresetn) begin
         test_reg1_r <= 'd0;
         test_reg2_r <= 'd0;
      end
      else if(S_AXI_LITE_awvalid && S_AXI_LITE_awready) begin
         test_reg1_r <= (S_AXI_LITE_awaddr == TEST_REG1_ADDR) ? S_AXI_LITE_wdata : test_reg1_r;
         test_reg2_r <= (S_AXI_LITE_awaddr == TEST_REG2_ADDR) ? S_AXI_LITE_wdata : test_reg2_r;
      end
   end

   always @(posedge s_axi_aclk) begin
      if (~s_axi_aresetn) begin
         test_reg3_r <= 'd0;
         test_reg4_r <= 'd0;
      end
      else begin
         test_reg3_r <= test_reg1_r + test_reg2_r;
         test_reg4_r <= vio_out;
      end
   end

vio_0 vio_0 (
   .clk(s_axi_aclk),
   .probe_in0(test_reg1_r),
   .probe_in1(test_reg2_r),
   .probe_in2(test_reg3_r),
   .probe_out0(vio_out)
);

axi_lite_ila axi_lite_ila(
   .clk(s_axi_aclk),
   .probe0(S_AXI_LITE_arready),
   .probe1(S_AXI_LITE_araddr),
   .probe2(S_AXI_LITE_bresp),
   .probe3(S_AXI_LITE_arvalid),
   .probe4(S_AXI_LITE_awready),
   .probe5(S_AXI_LITE_awaddr),
   .probe6(S_AXI_LITE_awvalid),
   .probe7(S_AXI_LITE_bready),
   .probe8(S_AXI_LITE_bvalid),
   .probe9(S_AXI_LITE_rready),
   .probe10(S_AXI_LITE_rdata),
   .probe11(S_AXI_LITE_rvalid),
   .probe12(S_AXI_LITE_wready),
   .probe13(S_AXI_LITE_rresp),
   .probe14(S_AXI_LITE_wdata),
   .probe15(S_AXI_LITE_wstrb),
   .probe16(S_AXI_LITE_wvalid),
   .probe17(S_AXI_LITE_awprot),
   .probe18(S_AXI_LITE_arprot)
);

///////////////////////////////////////////////////////////////////////
///
///////////////////////////////////////////////////////////////////////
`ifdef USE_DDR
   // AXI Slave AW channel
   wire   [ADDR_WIDTH-1:0]  axi_512_araddr;
   wire   [1:0]             axi_512_arburst;
   wire   [3:0]             axi_512_arcache;
   wire   [ID_WIDTH-1:0]    axi_512_arid;
   wire   [7:0]             axi_512_arlen;
   wire                     axi_512_arlock;
   wire   [2:0]             axi_512_arprot;
   wire   [3:0]             axi_512_arqos;
   wire   [3:0]             axi_512_arregion;
   wire                     axi_512_arready;
   wire   [2:0]             axi_512_arsize;
   wire                     axi_512_arvalid;
   // AXI Slave AR channel
   wire   [ADDR_WIDTH-1:0]  axi_512_awaddr;
   wire   [1:0]             axi_512_awburst;
   wire   [3:0]             axi_512_awcache;
   wire   [ID_WIDTH-1:0]    axi_512_awid;
   wire   [7:0]             axi_512_awlen;
   wire                     axi_512_awlock;
   wire   [2:0]             axi_512_awprot;
   wire   [3:0]             axi_512_awqos;
   wire   [3:0]             axi_512_awregion;
   wire                     axi_512_awready;
   wire   [2:0]             axi_512_awsize;
   wire                     axi_512_awvalid;
   // AXI Slave B channel
   wire   [ID_WIDTH-1:0]    axi_512_bid;
   wire                     axi_512_bready;
   wire   [1:0]             axi_512_bresp;
   wire                     axi_512_bvalid;
   // AXI Slave R channel
   wire   [512-1:0]         axi_512_rdata;
   wire   [ID_WIDTH-1:0]    axi_512_rid;
   wire                     axi_512_rlast;
   wire                     axi_512_rready;
   wire   [1:0]             axi_512_rresp;
   wire                     axi_512_rvalid;
   // AXI Slave W channel
   wire   [512-1:0]         axi_512_wdata;
   wire                     axi_512_wlast;
   wire                     axi_512_wready;
   wire   [64-1:0]          axi_512_wstrb;
   wire                     axi_512_wvalid;

   wire                     mem_wr_cmd_rdy;
   wire   [512-1:0]         mem_wr_data;
   wire   [64-1:0]          mem_wr_datamask;
   wire   [ADDR_WIDTH-1:0]  mem_wr_addr;
   wire                     mem_rd_cmd_rdy;
   wire   [512-1:0]         mem_rd_data;
   wire                     mem_rd_data_vld;
   wire                     mem_rd_en;
   wire   [ADDR_WIDTH-1:0]  mem_rd_addr;

axi_dwidth_converter_256to512 axi_256to512(
   .s_axi_aclk       (s_axi_aclk),
   .s_axi_aresetn    (s_axi_aresetn),

   .s_axi_awaddr     (S_AXI_awaddr),
   .s_axi_awid       (S_AXI_awid),   
   .s_axi_awlen      (S_AXI_awlen),
   .s_axi_awsize     (S_AXI_awsize),
   .s_axi_awburst    (S_AXI_awburst),
   .s_axi_awlock     (S_AXI_awlock),
   .s_axi_awcache    (S_AXI_awcache),
   .s_axi_awprot     (S_AXI_awprot),
   .s_axi_awregion   (S_AXI_awregion),
   .s_axi_awqos      (S_AXI_awqos),
   .s_axi_awvalid    (S_AXI_awvalid),
   .s_axi_awready    (S_AXI_awready),
   .s_axi_wdata      (S_AXI_wdata),
   .s_axi_wstrb      (S_AXI_wstrb),
   .s_axi_wlast      (S_AXI_wlast),
   .s_axi_wvalid     (S_AXI_wvalid),
   .s_axi_wready     (S_AXI_wready),
   .s_axi_bid        (S_AXI_bid),      
   .s_axi_bresp      (S_AXI_bresp),
   .s_axi_bvalid     (S_AXI_bvalid),
   .s_axi_bready     (S_AXI_bready),
   .s_axi_araddr     (S_AXI_araddr),
   .s_axi_arid       (S_AXI_arid),      
   .s_axi_arlen      (S_AXI_arlen),
   .s_axi_arsize     (S_AXI_arsize),
   .s_axi_arburst    (S_AXI_arburst),
   .s_axi_arlock     (S_AXI_arlock),
   .s_axi_arcache    (S_AXI_arcache),
   .s_axi_arprot     (S_AXI_arprot),
   .s_axi_arregion   (S_AXI_arregion),
   .s_axi_arqos      (S_AXI_arqos),
   .s_axi_arvalid    (S_AXI_arvalid),
   .s_axi_arready    (S_AXI_arready),
   .s_axi_rdata      (S_AXI_rdata),
   .s_axi_rid        (S_AXI_rid),     
   .s_axi_rresp      (S_AXI_rresp),
   .s_axi_rlast      (S_AXI_rlast),
   .s_axi_rvalid     (S_AXI_rvalid),
   .s_axi_rready     (S_AXI_rready),

   .m_axi_awaddr     (axi_512_awaddr),
   .m_axi_awlen      (axi_512_awlen),
   .m_axi_awsize     (axi_512_awsize),
   .m_axi_awburst    (axi_512_awburst),
   .m_axi_awlock     (axi_512_awlock),
   .m_axi_awcache    (axi_512_awcache),
   .m_axi_awprot     (axi_512_awprot),
   .m_axi_awregion   (axi_512_awregion),
   .m_axi_awqos      (axi_512_awqos),
   .m_axi_awvalid    (axi_512_awvalid),
   .m_axi_awready    (axi_512_awready),
   .m_axi_wdata      (axi_512_wdata),
   .m_axi_wstrb      (axi_512_wstrb),
   .m_axi_wlast      (axi_512_wlast),
   .m_axi_wvalid     (axi_512_wvalid),
   .m_axi_wready     (axi_512_wready),
   .m_axi_bresp      (axi_512_bresp),
   .m_axi_bvalid     (axi_512_bvalid),
   .m_axi_bready     (axi_512_bready),
   .m_axi_araddr     (axi_512_araddr),
   .m_axi_arlen      (axi_512_arlen),
   .m_axi_arsize     (axi_512_arsize),
   .m_axi_arburst    (axi_512_arburst),
   .m_axi_arlock     (axi_512_arlock),
   .m_axi_arcache    (axi_512_arcache),
   .m_axi_arprot     (axi_512_arprot),
   .m_axi_arregion   (axi_512_arregion),
   .m_axi_arqos      (axi_512_arqos),
   .m_axi_arvalid    (axi_512_arvalid),
   .m_axi_arready    (axi_512_arready),
   .m_axi_rdata      (axi_512_rdata),
   .m_axi_rresp      (axi_512_rresp),
   .m_axi_rlast      (axi_512_rlast),
   .m_axi_rvalid     (axi_512_rvalid),
   .m_axi_rready     (axi_512_rready)
);

axi_slave_bfm #(
   .DATA_WIDTH(512),
   .ADDR_WIDTH('d64),
   .MASK_WIDTH(64),
   .ID_WIDTH(ID_WIDTH)
)axi_slave_bfm(
   .clk(s_axi_aclk),
   .rst(~s_axi_aresetn),

   // AXI Master AW channel
   .araddr            (axi_512_araddr),
   .arburst           (axi_512_arburst),
   .arcache           (axi_512_arcache),
   .arid              (axi_512_arid),
   .arlen             (axi_512_arlen),
   .arlock            (axi_512_arlock),
   .arprot            (axi_512_arprot),
   .arqos             (axi_512_arqos),
   .arregion          (axi_512_arregion),
   .arready           (axi_512_arready),
   .arsize            (axi_512_arsize),
   .arvalid           (axi_512_arvalid),
   // AXI Master AR channel
   .awaddr            (axi_512_awaddr),
   .awburst           (axi_512_awburst),
   .awcache           (axi_512_awcache),
   .awid              (axi_512_awid),
   .awlen             (axi_512_awlen),
   .awlock            (axi_512_awlock),
   .awprot            (axi_512_awprot),
   .awqos             (axi_512_awqos),
   .awregion          (axi_512_awregion),
   .awready           (axi_512_awready),
   .awsize            (axi_512_awsize),
   .awvalid           (axi_512_awvalid),
   // AXI Master B channel
   .bid               (axi_512_bid),
   .bready            (axi_512_bready),
   .bresp             (axi_512_bresp),
   .bvalid            (axi_512_bvalid),
   // AXI Master R channel
   .rdata             (axi_512_rdata),
   .rid               (axi_512_rid),
   .rlast             (axi_512_rlast),
   .rready            (axi_512_rready),
   .rresp             (axi_512_rresp),
   .rvalid            (axi_512_rvalid),
   // AXI Master W channel
   .wdata             (axi_512_wdata),
   .wlast             (axi_512_wlast),
   .wready            (axi_512_wready),
   .wstrb             (axi_512_wstrb),
   .wvalid            (axi_512_wvalid),

   // Card Memory Interface
   .mem_wr_cmd_rdy    (mem_wr_cmd_rdy),
   .mem_wr_data       (mem_wr_data),
   .mem_wr_datamask   (mem_wr_datamask),
   .mem_wr_addr       (mem_wr_addr),
   .mem_rd_cmd_rdy    (mem_rd_cmd_rdy),
   .mem_rd_data       (mem_rd_data),
   .mem_rd_data_vld   (mem_rd_data_vld),
   .mem_rd_en         (mem_rd_en),
   .mem_rd_addr       (mem_rd_addr)
);

   wire [71:0] r_cmd_fifo_dout;
   wire        r_cmd_fifo_full;
   wire        r_cmd_fifo_rd_en;
   wire        r_cmd_fifo_valid;
   wire        mem_wr_en;
   wire        mem_wr_byte;
   wire [71:0] w_cmd_fifo_dout;
   wire        w_cmd_fifo_full;
   wire        w_cmd_fifo_rd_en;
   wire        w_cmd_fifo_valid;

   assign mem_wr_en      = mem_wr_datamask != 'd0; 
   assign mem_wr_byte    = (mem_wr_datamask != {(64){1'b1}});
   assign mem_wr_cmd_rdy = ~w_cmd_fifo_full && ~w_data_fifo_full;
   assign mem_rd_cmd_rdy = ~r_cmd_fifo_full;
   assign c0_ddr4_app_wdf_end = 1'b1;
   assign c0_ddr4_app_hi_pri = 1'b0;

fifo_async_blk_fwft_576x512_latency_0 r_data_fifo(
   .rst(~s_axi_aresetn),
   .wr_clk(c0_ddr4_ui_clk),
   .rd_clk(s_axi_aclk),
   .din(c0_ddr4_app_rd_data),
   .wr_en(c0_ddr4_app_rd_data_valid),
   .rd_en(1'b1),
   .dout(mem_rd_data),
   .full(),
   .empty(),
   .valid(mem_rd_data_vld)
);

fifo_async_blk_fwft_72x512_latency_0 r_cmd_fifo(
   .rst(~s_axi_aresetn),
   .wr_clk(s_axi_aclk),
   .rd_clk(c0_ddr4_ui_clk),
   .din(mem_rd_addr),
   .wr_en(mem_rd_en),
   .rd_en(r_cmd_fifo_rd_en),
   .dout(r_cmd_fifo_dout),
   .full(r_cmd_fifo_full),
   .empty(),
   .valid(r_cmd_fifo_valid)
);

fifo_async_blk_fwft_576x512_latency_0 w_data_fifo(
   .rst(~s_axi_aresetn),
   .wr_clk(s_axi_aclk),
   .rd_clk(c0_ddr4_ui_clk),
   .din({~mem_wr_datamask,mem_wr_data}),
   .wr_en(mem_wr_en && mem_wr_cmd_rdy),
   .rd_en(c0_ddr4_app_wdf_rdy),
   .dout({c0_ddr4_app_wdf_mask,c0_ddr4_app_wdf_data}),
   .full(w_data_fifo_full),
   .empty(),
   .valid(c0_ddr4_app_wdf_wren)
);

fifo_async_blk_fwft_72x512_latency_0 w_cmd_fifo(
   .rst(~s_axi_aresetn),
   .wr_clk(s_axi_aclk),
   .rd_clk(c0_ddr4_ui_clk),
   .din({mem_wr_byte,mem_wr_addr}),
   .wr_en(mem_wr_en && mem_wr_cmd_rdy),
   .rd_en(w_cmd_fifo_rd_en),
   .dout(w_cmd_fifo_dout),
   .full(w_cmd_fifo_full),
   .empty(),
   .valid(w_cmd_fifo_valid)
);

reg  switch_r = 1'b0;
always @ (posedge c0_ddr4_ui_clk) begin
   if (~switch_r && w_cmd_fifo_valid) begin
      switch_r <= 1'b0;
   end
   else if (~switch_r) begin
      switch_r <= 1'b1;
   end
   else if (switch_r && r_cmd_fifo_valid) begin
      switch_r <= 1'b1;
   end
   else if (switch_r) begin
      switch_r <= 1'b0;
   end
end

assign c0_ddr4_app_addr = (switch_r) ? r_cmd_fifo_dout[30:3] : w_cmd_fifo_dout[30:3];
assign c0_ddr4_app_en   = (switch_r) ? r_cmd_fifo_valid : w_cmd_fifo_valid;  
assign c0_ddr4_app_cmd  = (switch_r) ? 3'b001 :
                          (w_cmd_fifo_dout[64]) ? 3'b011 : 3'b000;
assign r_cmd_fifo_rd_en = (switch_r) ? c0_ddr4_app_rdy : 1'b0;
assign w_cmd_fifo_rd_en = (~switch_r) ? c0_ddr4_app_rdy : 1'b0;
assign c0_ddr4_app_correct_en_i = 1'b0;
`else
   assign S_AXI_arready = 1'b0;
   assign S_AXI_awready = 1'b0;
   assign S_AXI_wready  = 1'b0;
   assign S_AXI_bvalid  = 1'b0;
   assign S_AXI_rvalid  = 1'b0;
`endif
endmodule
