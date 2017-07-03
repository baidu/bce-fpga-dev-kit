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
module axi_l_master_bfm #(
   parameter DATA_WIDTH = 512,
   parameter ADDR_WIDTH = 64,
   parameter MASK_WIDTH = DATA_WIDTH/8
)(
   input                    clk,
   input                    rst,

   // AXI Master AW channel
   output [ADDR_WIDTH-1:0]  araddr,
   output [2:0]             arprot,
   input                    arready,
   output                   arvalid,
   // AXI Master AR channel
   output [ADDR_WIDTH-1:0]  awaddr,
   output [2:0]             awprot,
   input                    awready,
   output                   awvalid,
   // AXI Master B channel
   output                   bready,
   input  [1:0]             bresp,
   input                    bvalid,
   // AXI Master R channel
   input  [DATA_WIDTH-1:0]  rdata,
   output                   rready,
   input  [1:0]             rresp,
   input                    rvalid,
   // AXI Master W channel
   output [DATA_WIDTH-1:0]  wdata,
   input                    wready,
   output [MASK_WIDTH-1:0]  wstrb,
   output                   wvalid,

   // Receive normal req
   output                   normal_rd_cmd_rdy,
   input  [ADDR_WIDTH-1:0]  normal_rd_addr,
   input                    normal_rd_en,
   output                   normal_rd_data_vld,
   output [DATA_WIDTH-1:0]  normal_rd_data,
   output                   normal_wr_cmd_rdy,
   input  [ADDR_WIDTH-1:0]  normal_wr_addr,
   input  [DATA_WIDTH-1:0]  normal_wr_data,
   input  [MASK_WIDTH-1:0]  normal_wr_datastrb
);

   wire ar_fifo_full;
   wire aw_fifo_full;
   assign arprot = 3'd0;
   assign awprot = 3'd0;
   assign bready = 1'b1;
   assign rready = 1'b1;
   assign normal_rd_data     = rdata;
   assign normal_rd_data_vld = rvalid;
   assign normal_rd_cmd_rdy  = ~ar_fifo_full;
   assign normal_wr_cmd_rdy  = ~aw_fifo_full;

   fifo_sync_dist_fwft_64x16_latency_0 ar_fifo(
      .clk(clk),
      .rst(rst),
      .din(normal_rd_addr),
      .wr_en(normal_rd_en),
      .rd_en(arready),
      .dout(araddr),
      .full(ar_fifo_full),
      .empty(),
      .valid(arvalid)
   );

   wire aw_fifo_wr_en;
   assign aw_fifo_wr_en = (normal_wr_datastrb != 0);
   fifo_sync_dist_fwft_64x16_latency_0 aw_fifo(
      .clk(clk),
      .rst(rst),
      .din(normal_wr_addr),
      .wr_en(aw_fifo_wr_en),
      .rd_en(awready),
      .dout(awaddr),
      .full(aw_fifo_full),
      .empty(),
      .valid(awvalid)
   );
   fifo_sync_blk_fwft_576x16_latency_0 w_fifo(
      .clk(clk),
      .rst(rst),
      .din({normal_wr_data,normal_wr_datastrb}),
      .wr_en(aw_fifo_wr_en),
      .rd_en(wready),
      .dout({wdata,wstrb}),
      .full(),
      .empty(),
      .valid(wvalid)
   );

endmodule
