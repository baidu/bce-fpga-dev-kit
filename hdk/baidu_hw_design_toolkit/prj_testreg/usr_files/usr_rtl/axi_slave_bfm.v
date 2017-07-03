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
module axi_slave_bfm #(
   parameter DATA_WIDTH = 512,
   parameter ADDR_WIDTH = 64,
   parameter MASK_WIDTH = DATA_WIDTH/8,
   parameter ID_WIDTH   = 4
)(
   input                    clk,
   input                    rst,

   // AXI Master AW channel
   input  [ADDR_WIDTH-1:0]  araddr,
   input  [1:0]             arburst,
   input  [3:0]             arcache,
   input  [ID_WIDTH-1:0]    arid,
   input  [7:0]             arlen,
   input                    arlock,
   input  [2:0]             arprot,
   input  [3:0]             arqos,
   input  [3:0]             arregion,
   output                   arready,
   input  [2:0]             arsize,
   input                    arvalid,
   // AXI Master AR channel
   input  [ADDR_WIDTH-1:0]  awaddr,
   input  [1:0]             awburst,
   input  [3:0]             awcache,
   input  [ID_WIDTH-1:0]    awid,
   input  [7:0]             awlen,
   input                    awlock,
   input  [2:0]             awprot,
   input  [3:0]             awqos,
   input  [3:0]             awregion,
   output                   awready,
   input  [2:0]             awsize,
   input                    awvalid,
   // AXI Master B channel
   output [ID_WIDTH-1:0]    bid,
   input                    bready,
   output [1:0]             bresp,
   output                   bvalid,
   // AXI Master R channel
   output [DATA_WIDTH-1:0]  rdata,
   output [ID_WIDTH-1:0]    rid,
   output                   rlast,
   input                    rready,
   output [1:0]             rresp,
   output                   rvalid,
   // AXI Master W channel
   input  [DATA_WIDTH-1:0]  wdata,
   input                    wlast,
   output                   wready,
   input  [MASK_WIDTH-1:0]  wstrb,
   input                    wvalid,

   // Memory Interface
   input                    mem_wr_cmd_rdy,
   output [DATA_WIDTH-1:0]  mem_wr_data,
   output [MASK_WIDTH-1:0]  mem_wr_datastrb,
   output [ADDR_WIDTH-1:0]  mem_wr_addr,
   input                    mem_rd_cmd_rdy,
   input  [DATA_WIDTH-1:0]  mem_rd_data,
   input                    mem_rd_data_vld,
   output                   mem_rd_en,
   output [ADDR_WIDTH-1:0]  mem_rd_addr
);

   assign rresp = 2'b0;
   assign bresp = 2'b0;

   // generate mem rd & axi ar ack
   wire [ADDR_WIDTH+ID_WIDTH+7:0] ar_fifo_din;
   wire [ADDR_WIDTH+ID_WIDTH+7:0] ar_fifo_dout;
   wire                           ar_fifo_full;
   wire                           ar_fifo_valid;
   wire                           ar_fifo_rd_en;
   wire                           rd_fifo_prog_full;

   reg  [7:0]                     rd_cmd_cnt_r;
   reg  [7:0]                     rd_data_cnt_r;
   reg  [ADDR_WIDTH-1:0]          rd_cmd_addr_r;

   assign   arready       = ~ar_fifo_full;
   assign   ar_fifo_rd_en = (rd_data_cnt_r == ar_fifo_dout[ADDR_WIDTH+ID_WIDTH+7:ADDR_WIDTH+ID_WIDTH]) && mem_rd_data_vld;
   assign   ar_fifo_din   = {arlen,arid,araddr};
   assign   mem_rd_en     = ~(rd_cmd_cnt_r > ar_fifo_dout[ADDR_WIDTH+ID_WIDTH+7:ADDR_WIDTH+ID_WIDTH]) && ~rd_fifo_prog_full && ar_fifo_valid;
   assign   mem_rd_addr   = (rd_cmd_cnt_r == 'd0) ? ar_fifo_dout[ADDR_WIDTH-1:0] : rd_cmd_addr_r;

   always @ (posedge clk) begin
      if (rd_cmd_cnt_r == 'd0) begin
         rd_cmd_addr_r <= ar_fifo_dout[ADDR_WIDTH-1:0] + MASK_WIDTH;
      end
      else if (mem_rd_cmd_rdy && mem_rd_en) begin
         rd_cmd_addr_r <= rd_cmd_addr_r + MASK_WIDTH;
      end
   end

   always @ (posedge clk) begin
      if (rst) begin
         rd_cmd_cnt_r <= 'b0;
      end
      else if (ar_fifo_rd_en) begin
         rd_cmd_cnt_r <= 'b0;
      end
      else if (mem_rd_cmd_rdy && mem_rd_en) begin
         rd_cmd_cnt_r <= rd_cmd_cnt_r + 'd1;
      end
   end

   always @ (posedge clk) begin
      if (rst) begin
         rd_data_cnt_r <= 'b0;
      end
      else if (ar_fifo_rd_en) begin
         rd_data_cnt_r <= 'b0;
      end
      else if (mem_rd_data_vld) begin
         rd_data_cnt_r <= rd_data_cnt_r + 'd1;
      end
   end

   fifo_sync_dist_fwft_80x16_latency_0 ar_fifo(
      .clk(clk),
      .rst(rst),
      .din(ar_fifo_din),
      .wr_en(arvalid),
      .rd_en(ar_fifo_rd_en),
      .dout(ar_fifo_dout),
      .full(ar_fifo_full),
      .empty(),
      .valid(ar_fifo_valid)
   );

   // generate axi rdata
   wire [DATA_WIDTH+ID_WIDTH:0] rd_fifo_din;
   wire [DATA_WIDTH+ID_WIDTH:0] rd_fifo_dout;
   wire [ID_WIDTH-1:0]          rd_id;
   wire                         rd_last;

   assign   rd_id       = ar_fifo_dout[ADDR_WIDTH+ID_WIDTH-1:ADDR_WIDTH];
   assign   rd_last     = ar_fifo_rd_en;
   assign   rd_fifo_din = {rd_last,rd_id,mem_rd_data};
   assign   rlast       = rd_fifo_dout[DATA_WIDTH+ID_WIDTH];
   assign   rdata       = rd_fifo_dout[DATA_WIDTH-1:0];
   assign   rid         = rd_fifo_dout[DATA_WIDTH+ID_WIDTH-1:DATA_WIDTH];

   fifo_sync_blk_fwft_576x512_latency_0 rd_fifo(
      .clk(clk),
      .rst(rst),
      .din(rd_fifo_din),
      .wr_en(mem_rd_data_vld),
      .rd_en(rready),
      .dout(rd_fifo_dout),
      .full(),
      .prog_full(rd_fifo_prog_full),
      .prog_empty(),
      .empty(),
      .valid(rvalid)
   );

   // generate mem wr & axi aw ack;
   localparam  IDLE  = 'd0;
   localparam  WRITE = 'd1;
   localparam  W_END = 'd2;

   wire  [ADDR_WIDTH+ID_WIDTH+7:0] aw_fifo_din;
   wire  [ADDR_WIDTH+ID_WIDTH+7:0] aw_fifo_dout;
   wire                            aw_fifo_full;
   wire                            aw_fifo_valid;
   wire                            aw_fifo_rd_en;

   reg   [1:0]                     w_state;
   reg   [7:0]                     wr_data_cnt_r;
   reg   [ADDR_WIDTH-1:0]          wr_cmd_addr_r;

   assign   awready         = ~aw_fifo_full;
   assign   aw_fifo_din     = {awlen,awid,awaddr};
   assign   aw_fifo_rd_en   = (w_state == W_END) && bready;

   assign   wready          = (w_state == WRITE) && mem_wr_cmd_rdy;
   assign   mem_wr_addr     = wr_cmd_addr_r;
   assign   mem_wr_data     = wdata;
   assign   mem_wr_datastrb = ((w_state == WRITE) && wvalid) ? wstrb : {(MASK_WIDTH){1'b0}};

   assign   bvalid          = (w_state == W_END);
   assign   bid             = aw_fifo_dout[ADDR_WIDTH+ID_WIDTH-1:ADDR_WIDTH];


   always @ (posedge clk) begin
      if (rst) begin
         w_state <= IDLE;
      end
      else begin
         case (w_state)
            IDLE:begin
               if (aw_fifo_valid) begin
                  w_state <= WRITE;
               end
               else begin
                  w_state <= IDLE;
               end
            end
            WRITE:begin
               if ((wr_data_cnt_r == aw_fifo_dout[ADDR_WIDTH+ID_WIDTH+7:ADDR_WIDTH+ID_WIDTH]) && wvalid && wready) begin
                  w_state <= W_END;
               end
               else begin
                  w_state <= WRITE;
               end
            end
            W_END:begin
               if (bready) begin
                  w_state <= IDLE;
               end
               else begin
                  w_state <= W_END;
               end
            end
         endcase
      end
   end

   always @ (posedge clk) begin
      if (w_state == IDLE) begin
         wr_cmd_addr_r <= aw_fifo_dout[ADDR_WIDTH-1:0];
      end
      else if (wvalid && wready) begin
         wr_cmd_addr_r <= wr_cmd_addr_r + MASK_WIDTH;
      end
   end

   always @ (posedge clk) begin
      if (rst) begin
         wr_data_cnt_r <= 'b0;
      end
      else if (aw_fifo_rd_en) begin
         wr_data_cnt_r <= 'b0;
      end
      else if (wvalid && wready) begin
         wr_data_cnt_r <= wr_data_cnt_r + 'd1;
      end
   end

   fifo_sync_dist_fwft_80x16_latency_0 aw_fifo(
      .clk(clk),
      .rst(rst),
      .din(aw_fifo_din),
      .wr_en(awvalid),
      .rd_en(aw_fifo_rd_en),
      .dout(aw_fifo_dout),
      .full(aw_fifo_full),
      .empty(),
      .valid(aw_fifo_valid)
   );

endmodule
