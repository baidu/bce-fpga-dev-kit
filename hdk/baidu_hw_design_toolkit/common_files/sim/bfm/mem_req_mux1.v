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
module mem_req_mux1 #(
   parameter IN_NUM     = 4,
   parameter DATA_WIDTH = 512,
   parameter ADDR_WIDTH = 64,
   parameter MASK_WIDTH = DATA_WIDTH/8
)(
   input                           clk,
   input                           rst,

   input  [IN_NUM*DATA_WIDTH-1:0]  in_wr_data,
   input  [IN_NUM*MASK_WIDTH-1:0]  in_wr_datastrb,
   input  [IN_NUM*ADDR_WIDTH-1:0]  in_wr_addr,
   output [IN_NUM*1-1:0]           in_wr_cmd_rdy,
   output [IN_NUM*DATA_WIDTH-1:0]  in_rd_data,
   output [IN_NUM*1-1:0]           in_rd_data_vld,
   input  [IN_NUM*1-1:0]           in_rd_en,
   input  [IN_NUM*ADDR_WIDTH-1:0]  in_rd_addr,
   output [IN_NUM*1-1:0]           in_rd_cmd_rdy,

   // Host Memory Interface
   input                           wr_cmd_rdy,
   output [DATA_WIDTH-1:0]         wr_data,
   output [MASK_WIDTH-1:0]         wr_datastrb,
   output [ADDR_WIDTH-1:0]         wr_addr,
   input                           rd_cmd_rdy,
   input  [DATA_WIDTH-1:0]         rd_data,
   input                           rd_data_vld,
   output                          rd_en,
   output [ADDR_WIDTH-1:0]         rd_addr
);

   localparam SWITCH_BITS = $clog2(IN_NUM);

   wire [IN_NUM-1:0]      wr_req;
   wire [IN_NUM-1:0]      rd_req;
   wire [SWITCH_BITS-1:0] wr_switch;
   wire [SWITCH_BITS-1:0] rd_switch;

   genvar i;
   generate
   for (i=0; i<IN_NUM; i=i+1) begin:gen_wr_req
      assign wr_req[i] = (in_wr_datastrb[i*MASK_WIDTH+MASK_WIDTH-1:i*MASK_WIDTH] != 'd0);
   end
   endgenerate

   round_robin_4 wr_sel(
      .clk(clk),
      .rst(rst),
      .req(wr_req),
      .sel(wr_switch)
   );

   assign rd_req = in_rd_en;
   round_robin_4 rd_sel(
      .clk(clk),
      .rst(rst),
      .req(rd_req),
      .sel(rd_switch)
   );

   assign wr_data     = in_wr_data     >> (wr_switch * DATA_WIDTH);
   assign wr_addr     = in_wr_addr     >> (wr_switch * ADDR_WIDTH);
   assign wr_datastrb = in_wr_datastrb >> (wr_switch * MASK_WIDTH);
   assign rd_en       = in_rd_en       >> rd_switch;
   assign rd_addr     = in_rd_addr     >> (rd_switch*ADDR_WIDTH);

   generate
   for (i=0; i<IN_NUM; i=i+1) begin:gen_cmd_rdy
      assign in_wr_cmd_rdy[i] = (wr_switch == i) && wr_cmd_rdy;
      assign in_rd_cmd_rdy[i] = (rd_switch == i) && rd_cmd_rdy;
   end
   endgenerate

   wire [IN_NUM-1:0]    rd_issue_din;
   wire [IN_NUM-1:0]    rd_issue_dout;
   wire                 rd_issue_wr_en;
   wire                 rd_issue_rd_en;
   reg                  rd_data_vld_r1;
   reg                  rd_data_vld_r2;
   reg [DATA_WIDTH-1:0] rd_data_r1;
   reg [DATA_WIDTH-1:0] rd_data_r2;

   //add rd data latency to insure the rd_issue_fifo.valid assert when the rd
   //data come back.
   always @ (posedge clk) begin
      rd_data_r1     <= rd_data;
      rd_data_r2     <= rd_data_r1;
      rd_data_vld_r1 <= rd_data_vld;
      rd_data_vld_r2 <= rd_data_vld_r1;
   end

   fifo_sync_dist_fwft_4x64_latency_0 rd_issue(
      .clk(clk),
      .rst(rst),
      .din(rd_issue_din),
      .wr_en(rd_issue_wr_en),
      .rd_en(rd_issue_rd_en),
      .dout(rd_issue_dout),
      .full(),
      .empty(),
      .valid()
   );

   assign rd_issue_rd_en  = rd_data_vld_r2;
   assign rd_issue_wr_en  = (rd_issue_din != 'd0);

   generate
   for (i=0; i<IN_NUM; i=i+1) begin:gen_rd_data
      assign in_rd_data[i*DATA_WIDTH+DATA_WIDTH-1:i*DATA_WIDTH] = (rd_issue_dout[i]) ? rd_data_r2 : 'd0;
      assign in_rd_data_vld[i]  = rd_issue_dout[i] && rd_data_vld_r2;
      assign rd_issue_din[i] = (in_rd_en[i] && in_rd_cmd_rdy[i]);
   end
   endgenerate

endmodule
