/*
 * Copyright (C) 2017 Baidu, Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
`timescale 1ns / 1ps
module axi_master_bfm #(
   parameter DMA_NUM    = 4,
   parameter DATA_WIDTH = 512,
   parameter ADDR_WIDTH = 64,
   parameter MASK_WIDTH = DATA_WIDTH/8,
   parameter ID_WIDTH   = 4
)(
   input                            clk,
   input                            rst,

   // AXI Master AW channel
   output [ADDR_WIDTH-1:0]          araddr,
   output [1:0]                     arburst,
   output [3:0]                     arcache,
   output [ID_WIDTH-1:0]            arid,
   output [7:0]                     arlen,
   output                           arlock,
   output [2:0]                     arprot,
   output [3:0]                     arqos,
   output [3:0]                     arregion,
   input                            arready,
   output [2:0]                     arsize,
   output                           arvalid,
   // AXI Master AR channel
   output [ADDR_WIDTH-1:0]          awaddr,
   output [1:0]                     awburst,
   output [3:0]                     awcache,
   output [ID_WIDTH-1:0]            awid,
   output [7:0]                     awlen,
   output                           awlock,
   output [2:0]                     awprot,
   output [3:0]                     awqos,
   output [3:0]                     awregion,
   input                            awready,
   output [2:0]                     awsize,
   output                           awvalid,
   // AXI Master B channel
   input  [ID_WIDTH-1:0]            bid,
   output                           bready,
   input  [1:0]                     bresp,
   input                            bvalid,
   // AXI Master R channel
   input  [DATA_WIDTH-1:0]          rdata,
   input  [ID_WIDTH-1:0]            rid,
   input                            rlast,
   output                           rready,
   input  [1:0]                     rresp,
   input                            rvalid,
   // AXI Master W channel
   output [DATA_WIDTH-1:0]          wdata,
   output                           wlast,
   input                            wready,
   output [MASK_WIDTH-1:0]          wstrb,
   output                           wvalid,

   // Host Memory Interface
   input                            mem_wr_cmd_rdy,
   output [DATA_WIDTH-1:0]          mem_wr_data,
   output [MASK_WIDTH-1:0]          mem_wr_datastrb,
   output [ADDR_WIDTH-1:0]          mem_wr_addr,
   input                            mem_rd_cmd_rdy,
   input  [DATA_WIDTH-1:0]          mem_rd_data,
   input                            mem_rd_data_vld,
   output                           mem_rd_en,
   output [ADDR_WIDTH-1:0]          mem_rd_addr,

   // Receive DMA req
   input  [DMA_NUM*ADDR_WIDTH-1:0]  dma_src_addr,
   input  [DMA_NUM*ADDR_WIDTH-1:0]  dma_dst_addr,
   input  [DMA_NUM*32-1:0]          dma_len,
   input  [DMA_NUM-1:0]             dma_direction,
   input  [DMA_NUM-1:0]             dma_start,
   output [DMA_NUM-1:0]             dma_status,

   // Receive normal req
   input  [ADDR_WIDTH-1:0]          normal_rd_addr,
   input                            normal_rd_en,
   output                           normal_rd_data_vld,
   output [DATA_WIDTH-1:0]          normal_rd_data,
   input  [ADDR_WIDTH-1:0]          normal_wr_addr,
   input  [DATA_WIDTH-1:0]          normal_wr_data,
   input  [MASK_WIDTH-1:0]          normal_wr_datastrb
);

   wire   [ADDR_WIDTH-1:0]          c0_axi_l_araddr;
   wire   [2:0]                     c0_axi_l_arprot;
   wire                             c0_axi_l_arready;
   wire                             c0_axi_l_arvalid;
   wire   [7:0]                     c0_axi_l_arlen;
   wire   [ADDR_WIDTH-1:0]          c0_axi_l_awaddr;
   wire   [2:0]                     c0_axi_l_awprot;
   wire                             c0_axi_l_awready;
   wire                             c0_axi_l_awvalid;
   wire   [7:0]                     c0_axi_l_awlen;
   wire                             c0_axi_l_bready;
   wire   [1:0]                     c0_axi_l_bresp;
   wire                             c0_axi_l_bvalid;
   wire   [DATA_WIDTH-1:0]          c0_axi_l_rdata;
   wire                             c0_axi_l_rlast;
   wire                             c0_axi_l_rready;
   wire   [1:0]                     c0_axi_l_rresp;
   wire                             c0_axi_l_rvalid;
   wire   [DATA_WIDTH-1:0]          c0_axi_l_wdata;
   wire                             c0_axi_l_wready;
   wire                             c0_axi_l_wlast;
   wire   [MASK_WIDTH-1:0]          c0_axi_l_wstrb;
   wire                             c0_axi_l_wvalid;

   assign c0_axi_l_bresp = 2'b0;
   assign c0_axi_l_rresp = 2'b0;
   assign c0_axi_l_arlen = 8'd0;
   assign c0_axi_l_awlen = 8'd0;
   assign c0_axi_l_wlast = 1'b1;

   axi_l_master_bfm #(
      .DATA_WIDTH(DATA_WIDTH),
      .ADDR_WIDTH(ADDR_WIDTH)
   )normal_req_processor(
      .clk(clk),
      .rst(rst),

      .normal_rd_cmd_rdy(),
      .normal_rd_addr(normal_rd_addr),
      .normal_rd_en(normal_rd_en),
      .normal_rd_data_vld(normal_rd_data_vld),
      .normal_rd_data(normal_rd_data),
      .normal_wr_cmd_rdy(),
      .normal_wr_addr(normal_wr_addr),
      .normal_wr_data(normal_wr_data),
      .normal_wr_datastrb(normal_wr_datastrb),

      .araddr(c0_axi_l_araddr),
      .arprot(c0_axi_l_arprot),
      .arready(c0_axi_l_arready),
      .arvalid(c0_axi_l_arvalid),
      .awaddr(c0_axi_l_awaddr),
      .awprot(c0_axi_l_awprot),
      .awready(c0_axi_l_awready),
      .awvalid(c0_axi_l_awvalid),
      .bready(c0_axi_l_bready),
      .bresp(c0_axi_l_bresp),
      .bvalid(c0_axi_l_bvalid),
      .rdata(c0_axi_l_rdata),
      .rready(c0_axi_l_rready),
      .rresp(c0_axi_l_rresp),
      .rvalid(c0_axi_l_rvalid),
      .wdata(c0_axi_l_wdata),
      .wready(c0_axi_l_wready),
      .wstrb(c0_axi_l_wstrb),
      .wvalid(c0_axi_l_wvalid)
   );

   wire   [DMA_NUM*ADDR_WIDTH-1:0]  dma_axi_araddr;
   wire   [DMA_NUM*8-1:0]           dma_axi_arlen;
   wire   [DMA_NUM-1:0]             dma_axi_arready;
   wire   [DMA_NUM-1:0]             dma_axi_arvalid;
   wire   [DMA_NUM*ADDR_WIDTH-1:0]  dma_axi_awaddr;
   wire   [DMA_NUM*8-1:0]           dma_axi_awlen;
   wire   [DMA_NUM-1:0]             dma_axi_awready;
   wire   [DMA_NUM-1:0]             dma_axi_awvalid;
   wire   [DMA_NUM-1:0]             dma_axi_bready;
   wire   [DMA_NUM-1:0]             dma_axi_bvalid;
   wire   [DMA_NUM*DATA_WIDTH-1:0]  dma_axi_rdata;
   wire   [DMA_NUM-1:0]             dma_axi_rlast;
   wire   [DMA_NUM-1:0]             dma_axi_rready;
   wire   [DMA_NUM-1:0]             dma_axi_rvalid;
   wire   [DMA_NUM*DATA_WIDTH-1:0]  dma_axi_wdata;
   wire   [DMA_NUM-1:0]             dma_axi_wlast;
   wire   [DMA_NUM-1:0]             dma_axi_wready;
   wire   [DMA_NUM*MASK_WIDTH-1:0]  dma_axi_wstrb;
   wire   [DMA_NUM-1:0]             dma_axi_wvalid;

   wire   [DMA_NUM*DATA_WIDTH-1:0]  dma_wr_data;
   wire   [DMA_NUM*MASK_WIDTH-1:0]  dma_wr_datastrb;
   wire   [DMA_NUM*ADDR_WIDTH-1:0]  dma_wr_addr;
   wire   [DMA_NUM-1:0]             dma_wr_cmd_rdy;
   wire   [DMA_NUM*DATA_WIDTH-1:0]  dma_rd_data;
   wire   [DMA_NUM-1:0]             dma_rd_data_vld;
   wire   [DMA_NUM-1:0]             dma_rd_en;
   wire   [DMA_NUM*ADDR_WIDTH-1:0]  dma_rd_addr;
   wire   [DMA_NUM-1:0]             dma_rd_cmd_rdy;

   genvar i;
   generate
   for (i=0;i<DMA_NUM;i=i+1) begin:gen_dma_engine
      dma_engine #(
         .DATA_WIDTH(DATA_WIDTH),
         .ADDR_WIDTH(ADDR_WIDTH)
      )dma_engine_i(
         .clk(clk),
         .rst(rst),

         .src_addr     (dma_src_addr[i*ADDR_WIDTH+ADDR_WIDTH-1:i*ADDR_WIDTH]),
         .dst_addr     (dma_dst_addr[i*ADDR_WIDTH+ADDR_WIDTH-1:i*ADDR_WIDTH]),
         .len          (dma_len[i*32+31:i*32]),
         .direction    (dma_direction[i]),
         .start        (dma_start[i]),
         .status       (dma_status[i]),

         .araddr       (dma_axi_araddr[i*ADDR_WIDTH+ADDR_WIDTH-1:i*ADDR_WIDTH]),
         .arlen        (dma_axi_arlen[i*8+7:i*8]),
         .arready      (dma_axi_arready[i]),
         .arvalid      (dma_axi_arvalid[i]),
         .awaddr       (dma_axi_awaddr[i*ADDR_WIDTH+ADDR_WIDTH-1:i*ADDR_WIDTH]),
         .awlen        (dma_axi_awlen[i*8+7:i*8]),
         .awready      (dma_axi_awready[i]),
         .awvalid      (dma_axi_awvalid[i]),
         .bready       (dma_axi_bready[i]),
         .bvalid       (dma_axi_bvalid[i]),
         .rdata        (dma_axi_rdata[i*DATA_WIDTH+DATA_WIDTH-1:i*DATA_WIDTH]),
         .rlast        (dma_axi_rlast[i]),
         .rready       (dma_axi_rready[i]),
         .rvalid       (dma_axi_rvalid[i]),
         .wdata        (dma_axi_wdata[i*DATA_WIDTH+DATA_WIDTH-1:i*DATA_WIDTH]),
         .wlast        (dma_axi_wlast[i]),
         .wready       (dma_axi_wready[i]),
         .wstrb        (dma_axi_wstrb[i*MASK_WIDTH+MASK_WIDTH-1:i*MASK_WIDTH]),
         .wvalid       (dma_axi_wvalid[i]),

         .rd_cmd_rdy   (dma_rd_cmd_rdy[i]),
         .rd_addr      (dma_rd_addr[i*ADDR_WIDTH+ADDR_WIDTH-1:i*ADDR_WIDTH]),
         .rd_en        (dma_rd_en[i]),
         .rd_data_vld  (dma_rd_data_vld[i]),
         .rd_data      (dma_rd_data[i*DATA_WIDTH+DATA_WIDTH-1:i*DATA_WIDTH]),
         .wr_cmd_rdy   (dma_wr_cmd_rdy[i]),
         .wr_addr      (dma_wr_addr[i*ADDR_WIDTH+ADDR_WIDTH-1:i*ADDR_WIDTH]),
         .wr_data      (dma_wr_data[i*DATA_WIDTH+DATA_WIDTH-1:i*DATA_WIDTH]),
         .wr_datastrb  (dma_wr_datastrb[i*MASK_WIDTH+MASK_WIDTH-1:i*MASK_WIDTH])
      );
   end
   endgenerate

   axi_req_mux1 #(
      .IN_NUM(DMA_NUM+1),
      .DATA_WIDTH(DATA_WIDTH),
      .ADDR_WIDTH(ADDR_WIDTH)
   )axi_req_mux1_i(
      .clk(clk),
      .rst(rst),

      //AXI slave
      .s_araddr  ({dma_axi_araddr   ,c0_axi_l_araddr }),
      .s_arlen   ({dma_axi_arlen    ,c0_axi_l_arlen  }),
      .s_arready ({dma_axi_arready  ,c0_axi_l_arready}),
      .s_arvalid ({dma_axi_arvalid  ,c0_axi_l_arvalid}),
      .s_awaddr  ({dma_axi_awaddr   ,c0_axi_l_awaddr }),
      .s_awlen   ({dma_axi_awlen    ,c0_axi_l_awlen  }),
      .s_awready ({dma_axi_awready  ,c0_axi_l_awready}),
      .s_awvalid ({dma_axi_awvalid  ,c0_axi_l_awvalid}),
      .s_bready  ({dma_axi_bready   ,c0_axi_l_bready }),
      .s_bvalid  ({dma_axi_bvalid   ,c0_axi_l_bvalid }),
      .s_rdata   ({dma_axi_rdata    ,c0_axi_l_rdata  }),
      .s_rlast   ({dma_axi_rlast    ,c0_axi_l_rlast  }),
      .s_rready  ({dma_axi_rready   ,c0_axi_l_rready }),
      .s_rvalid  ({dma_axi_rvalid   ,c0_axi_l_rvalid }),
      .s_wdata   ({dma_axi_wdata    ,c0_axi_l_wdata  }),
      .s_wlast   ({dma_axi_wlast    ,c0_axi_l_wlast  }),
      .s_wready  ({dma_axi_wready   ,c0_axi_l_wready }),
      .s_wstrb   ({dma_axi_wstrb    ,c0_axi_l_wstrb  }),
      .s_wvalid  ({dma_axi_wvalid   ,c0_axi_l_wvalid }),

      // AXI Master
      .araddr(araddr),
      .arburst(arburst),
      .arcache(arcache),
      .arid(arid),
      .arlen(arlen),
      .arlock(arlock),
      .arprot(arprot),
      .arqos(arqos),
      .arregion(arregion),
      .arready(arready),
      .arsize(arsize),
      .arvalid(arvalid),
      .awaddr(awaddr),
      .awburst(awburst),
      .awcache(awcache),
      .awid(awid),
      .awlen(awlen),
      .awlock(awlock),
      .awprot(awprot),
      .awqos(awqos),
      .awregion(awregion),
      .awready(awready),
      .awsize(awsize),
      .awvalid(awvalid),
      .bid(bid),
      .bready(bready),
      .bresp(bresp),
      .bvalid(bvalid),
      .rdata(rdata),
      .rid(rid),
      .rlast(rlast),
      .rready(rready),
      .rresp(rresp),
      .rvalid(rvalid),
      .wdata(wdata),
      .wlast(wlast),
      .wready(wready),
      .wstrb(wstrb),
      .wvalid(wvalid)
   );

   mem_req_mux1 #(
      .DATA_WIDTH(DATA_WIDTH),
      .ADDR_WIDTH(ADDR_WIDTH)
   )mem_req_mux1_i(
      .clk(clk),
      .rst(rst),

      .in_rd_cmd_rdy(dma_rd_cmd_rdy),
      .in_rd_addr(dma_rd_addr),
      .in_rd_en(dma_rd_en),
      .in_rd_data_vld(dma_rd_data_vld),
      .in_rd_data(dma_rd_data),
      .in_wr_cmd_rdy(dma_wr_cmd_rdy),
      .in_wr_addr(dma_wr_addr),
      .in_wr_data(dma_wr_data),
      .in_wr_datastrb(dma_wr_datastrb),

      .rd_cmd_rdy(mem_rd_cmd_rdy),
      .rd_addr(mem_rd_addr),
      .rd_en(mem_rd_en),
      .rd_data_vld(mem_rd_data_vld),
      .rd_data(mem_rd_data),
      .wr_cmd_rdy(mem_wr_cmd_rdy),
      .wr_addr(mem_wr_addr),
      .wr_data(mem_wr_data),
      .wr_datastrb(mem_wr_datastrb)
   );

endmodule
