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
module dma_engine #(
   parameter DATA_WIDTH = 512,
   parameter ADDR_WIDTH = 64,
   parameter MASK_WIDTH = DATA_WIDTH/8
)(
   input                    clk,
   input                    rst,

   input  [ADDR_WIDTH-1:0]  src_addr,
   input  [ADDR_WIDTH-1:0]  dst_addr,
   input  [31:0]            len,
   input                    direction,
   input                    start,
   output                   status,

   //axi req
   output [ADDR_WIDTH-1:0]  araddr,
   output [7:0]             arlen,
   input                    arready,
   output                   arvalid,
   output [ADDR_WIDTH-1:0]  awaddr,
   output [7:0]             awlen,
   input                    awready,
   output                   awvalid,
   output                   bready,
   input                    bvalid,
   input                    rlast,
   input  [DATA_WIDTH-1:0]  rdata,
   output                   rready,
   input                    rvalid,
   output [DATA_WIDTH-1:0]  wdata,
   output                   wlast,
   input                    wready,
   output [MASK_WIDTH-1:0]  wstrb,
   output                   wvalid,

   //mem req
   output [DATA_WIDTH-1:0]  wr_data,
   output [MASK_WIDTH-1:0]  wr_datastrb,
   output [ADDR_WIDTH-1:0]  wr_addr,
   input                    wr_cmd_rdy,
   input  [DATA_WIDTH-1:0]  rd_data,
   input                    rd_data_vld,
   output                   rd_en,
   output [ADDR_WIDTH-1:0]  rd_addr,
   input                    rd_cmd_rdy
);

   localparam ADDR_ALIGN_BITS = $clog2(MASK_WIDTH);
   localparam ADDR_MASK = {{(ADDR_WIDTH-ADDR_ALIGN_BITS){1'b1}},{(ADDR_ALIGN_BITS){1'b0}}};

   localparam AXI_REQ_BOUNDARY   = 4096;
   localparam AXI_BL_MAX         = AXI_REQ_BOUNDARY/MASK_WIDTH -'d1;
   localparam AXI_REQ_ALIGN_BITS = $clog2(AXI_REQ_BOUNDARY);

   // When the start signal is asserted, several parameter for this dma
   // operations will be caculated and registered.

   wire   [ADDR_ALIGN_BITS-1:0] rd_addr_offset;
   wire   [ADDR_ALIGN_BITS:0]   addr_distance_offset;
   wire   [ADDR_WIDTH-1:0]      rd_end_addr;
   wire   [ADDR_WIDTH-1:0]      wr_end_addr;
   wire   [ADDR_WIDTH-1:0]      rd_start_addr_align;
   wire   [ADDR_WIDTH-1:0]      rd_end_addr_align;
   wire   [ADDR_ALIGN_BITS-1:0] rd_last_addr_offset;
   wire   [ADDR_WIDTH-1:0]      wr_start_addr_align;
   wire   [ADDR_WIDTH-1:0]      wr_end_addr_align;
   wire   [MASK_WIDTH-1:0]      rd_data_first_wstrb;
   wire   [MASK_WIDTH-1:0]      rd_data_last_wstrb;
   wire   [ADDR_ALIGN_BITS+3:0] wr_data_idx_msb;
   wire   [ADDR_ALIGN_BITS+3:0] wr_data_idx_lsb;
   wire   [ADDR_ALIGN_BITS:0]   wr_datastrb_idx_msb;
   wire   [ADDR_ALIGN_BITS:0]   wr_datastrb_idx_lsb;

   reg    [ADDR_ALIGN_BITS-1:0] rd_addr_offset_r;
   reg    [ADDR_WIDTH-1:0]      rd_start_addr_align_r;
   reg    [ADDR_WIDTH-1:0]      rd_end_addr_align_r;
   reg    [ADDR_ALIGN_BITS-1:0] rd_last_addr_offset_r;
   reg    [ADDR_WIDTH-1:0]      wr_start_addr_align_r;
   reg    [ADDR_WIDTH-1:0]      wr_end_addr_align_r;
   reg    [MASK_WIDTH-1:0]      rd_data_first_wstrb_r;
   reg    [MASK_WIDTH-1:0]      rd_data_last_wstrb_r;
   reg    [ADDR_ALIGN_BITS+3:0] wr_data_idx_msb_r;
   reg    [ADDR_ALIGN_BITS+3:0] wr_data_idx_lsb_r;
   reg    [ADDR_ALIGN_BITS:0]   wr_datastrb_idx_msb_r;
   reg    [ADDR_ALIGN_BITS:0]   wr_datastrb_idx_lsb_r;

   reg    [31:0]                wr_words_cnt_r;
   reg    [31:0]                rd_words_cnt_r;
   reg    [31:0]                wr_words_total_r;
   reg    [31:0]                rd_words_total_r;
   reg                          c2h_dma_r = 1'b0;
   reg                          h2c_dma_r = 1'b0;

   assign rd_addr_offset       = src_addr[ADDR_ALIGN_BITS-1:0];
   assign addr_distance_offset = src_addr[ADDR_ALIGN_BITS-1:0] - dst_addr[ADDR_ALIGN_BITS-1:0]+ 'd64;
   assign rd_end_addr          = src_addr + len - 'd1;
   assign wr_end_addr          = dst_addr + len - 'd1;
   assign rd_start_addr_align  = src_addr & ADDR_MASK;
   assign rd_end_addr_align    = rd_end_addr & ADDR_MASK;
   assign rd_last_addr_offset  = rd_end_addr[ADDR_ALIGN_BITS-1:0] ;
   assign wr_start_addr_align  = dst_addr & ADDR_MASK;
   assign wr_end_addr_align    = wr_end_addr  & ADDR_MASK;
   assign rd_data_first_wstrb  = {(MASK_WIDTH){1'b1}} << rd_addr_offset;
   assign rd_data_last_wstrb   = {(MASK_WIDTH){1'b1}} >> (MASK_WIDTH-rd_last_addr_offset-'d1);
   assign wr_data_idx_msb      = wr_data_idx_lsb + DATA_WIDTH - 'd1;
   assign wr_data_idx_lsb      = {addr_distance_offset[ADDR_ALIGN_BITS-1:0],3'b0};
   assign wr_datastrb_idx_msb  = wr_datastrb_idx_lsb + MASK_WIDTH - 'd1;
   assign wr_datastrb_idx_lsb  = addr_distance_offset[ADDR_ALIGN_BITS-1:0];

   always @ (posedge clk) begin
      if (rst) begin
         rd_addr_offset_r      <= 'd0;
         rd_start_addr_align_r <= 'd0;
         rd_end_addr_align_r   <= 'd0;
         rd_last_addr_offset_r <= 'd0;
         wr_start_addr_align_r <= 'd0;
         wr_end_addr_align_r   <= 'd0;
         rd_data_first_wstrb_r <= 'd0;
         rd_data_last_wstrb_r  <= 'd0;
         wr_data_idx_msb_r     <= 'd0;
         wr_data_idx_lsb_r     <= 'd0;
         wr_datastrb_idx_msb_r <= 'd0;
         wr_datastrb_idx_lsb_r <= 'd0;
         rd_words_total_r      <= 'd0;
         wr_words_total_r      <= 'd0;
         c2h_dma_r             <= 'd0;
         h2c_dma_r             <= 'd0;
      end
      else if (start) begin
         rd_addr_offset_r      <= rd_addr_offset;
         rd_start_addr_align_r <= rd_start_addr_align;
         rd_end_addr_align_r   <= rd_end_addr_align;
         rd_last_addr_offset_r <= rd_last_addr_offset;
         wr_start_addr_align_r <= wr_start_addr_align;
         wr_end_addr_align_r   <= wr_end_addr_align;
         rd_data_first_wstrb_r <= rd_data_first_wstrb;
         rd_data_last_wstrb_r  <= rd_data_last_wstrb;
         wr_data_idx_msb_r     <= wr_data_idx_msb;
         wr_data_idx_lsb_r     <= wr_data_idx_lsb;
         wr_datastrb_idx_msb_r <= wr_datastrb_idx_msb;
         wr_datastrb_idx_lsb_r <= wr_datastrb_idx_lsb;
         rd_words_total_r      <= ((rd_end_addr_align - rd_start_addr_align) >> ADDR_ALIGN_BITS) + 'd1;
         wr_words_total_r      <= ((wr_end_addr_align - wr_start_addr_align) >> ADDR_ALIGN_BITS) + 'd1;
         c2h_dma_r             <= direction;
         h2c_dma_r             <= ~direction;
      end
   end

   // Get read data and put it into rd2wd data fifo.
   // The fifo wr_en will be assert if wstrb is not zero

   wire                        rd2wr_data_first;
   wire                        rd2wr_data_last;
   wire   [MASK_WIDTH-1:0]     rd2wr_data_strb;

   reg    [31:0]               rd2wr_data_cnt_r;
   reg    [2*DATA_WIDTH-1:0]   rd2wr_data_r;
   reg    [2*MASK_WIDTH-1:0]   rd2wr_data_strb_r;
   reg                         rd2wr_data_vld_r;
   reg                         rd2wr_data_last_r;
   reg                         rd2wr_data_last_r2;

   assign rd2wr_data_first = (rd2wr_data_cnt_r == 'd1);
   assign rd2wr_data_last  = (rd2wr_data_cnt_r == rd_words_total_r);
   assign rd2wr_data_strb  = (rd2wr_data_first && rd2wr_data_last) ? (rd_data_first_wstrb_r & rd_data_last_wstrb_r) :
                                                (rd2wr_data_first) ? rd_data_first_wstrb_r :
                                                 (rd2wr_data_last) ? rd_data_last_wstrb_r  : {(MASK_WIDTH){1'b1}};

   always @ (posedge clk) begin
      rd2wr_data_vld_r   <= rd_data_vld || rvalid;
      rd2wr_data_last_r  <= (rd_data_vld || rvalid) && rd2wr_data_last;
      rd2wr_data_last_r2 <= rd2wr_data_last_r;
   end

   always @ (posedge clk) begin
      if (start) begin
         rd2wr_data_cnt_r <= 'd1;
      end
      else if (rd_data_vld || rvalid) begin
         rd2wr_data_cnt_r <= rd2wr_data_cnt_r + 'd1;
      end
   end

   always @ (posedge clk) begin
      if (start) begin
         rd2wr_data_strb_r <= 'd0;
      end
      else if (rd_data_vld || rvalid) begin
         rd2wr_data_strb_r <= {rd2wr_data_strb,rd2wr_data_strb_r[2*MASK_WIDTH-1:MASK_WIDTH]};
      end
      else if (rd2wr_data_last_r) begin
         rd2wr_data_strb_r <= {{(MASK_WIDTH){1'b0}},rd2wr_data_strb_r[2*MASK_WIDTH-1:MASK_WIDTH]};
      end
   end

   always @ (posedge clk) begin
      if (start) begin
         rd2wr_data_r <= 'd0;
      end
      // h2c dma. read data from mem
      else if (rd_data_vld) begin
         rd2wr_data_r <= {rd_data,rd2wr_data_r[2*DATA_WIDTH-1:DATA_WIDTH]};
      end
      // c2h dma. read data from axi
      else if (rvalid) begin
         rd2wr_data_r <= {rdata,rd2wr_data_r[2*DATA_WIDTH-1:DATA_WIDTH]};
      end
      else if (rd2wr_data_last_r) begin
         rd2wr_data_r <= {{(DATA_WIDTH){1'b0}},rd2wr_data_r[2*DATA_WIDTH-1:DATA_WIDTH]};
      end
   end

   wire [DATA_WIDTH+MASK_WIDTH-1:0] rd2wr_data_fifo_din;
   wire [DATA_WIDTH+MASK_WIDTH-1:0] rd2wr_data_fifo_dout;
   wire rd2wr_data_fifo_wr_en;
   wire rd2wr_data_fifo_rd_en;
   wire rd2wr_data_fifo_full;
   wire rd2wr_data_fifo_prog_full;
   wire rd2wr_data_fifo_prog_empty;
   wire rd2wr_data_fifo_valid;

   //assign rd2wr_data_fifo_din = {rd2wr_data_strb_r[wr_datastrb_idx_msb_r:wr_datastrb_idx_lsb_r],rd2wr_data_r[wr_data_idx_msb_r:wr_data_idx_lsb_r]};
   //assign rd2wr_data_fifo_wr_en = (rd2wr_data_strb_r[wr_datastrb_idx_msb_r:wr_datastrb_idx_lsb_r] != 'd0);
   wire [DATA_WIDTH-1:0] rd2wr_data_validrange;
   wire [MASK_WIDTH-1:0] rd2wr_datastrb_validrange;
   assign rd2wr_data_validrange     = (rd2wr_data_r << (2*DATA_WIDTH-1-wr_data_idx_msb_r)) >> (2*DATA_WIDTH-1-wr_data_idx_msb_r+wr_data_idx_lsb_r);
   assign rd2wr_datastrb_validrange = (rd2wr_data_strb_r << (2*MASK_WIDTH-1-wr_datastrb_idx_msb_r)) >> (2*MASK_WIDTH-1-wr_datastrb_idx_msb_r+wr_datastrb_idx_lsb_r);
   assign rd2wr_data_fifo_din       = {rd2wr_datastrb_validrange,rd2wr_data_validrange};
   assign rd2wr_data_fifo_wr_en     = (rd2wr_datastrb_validrange != 'd0) && (rd2wr_data_vld_r || rd2wr_data_last_r2);
   assign rd2wr_data_fifo_rd_en     = (c2h_dma_r && wr_cmd_rdy) || (h2c_dma_r && wready);

   fifo_sync_blk_fwft_576x512_latency_0 rd2wr_data_fifo(
      .clk(clk),
      .rst(rst),
      .din(rd2wr_data_fifo_din),
      .wr_en(rd2wr_data_fifo_wr_en),
      .rd_en(rd2wr_data_fifo_rd_en),
      .dout(rd2wr_data_fifo_dout),
      .full(rd2wr_data_fifo_full),
      .empty(),
      .prog_empty(rd2wr_data_fifo_prog_empty),
      .prog_full(rd2wr_data_fifo_prog_full),
      .valid(rd2wr_data_fifo_valid)
   );

   localparam IDLE      = 'd0;
   localparam ISSUE_CMD = 'd1;
   localparam CHK_REQ   = 'd2;
   localparam WAIT      = 'd3;

   // generate mem rd cmd
   reg  [1:0]            mem_rd_state;
   reg  [ADDR_WIDTH-1:0] mem_rd_addr_r;

   assign rd_en = (mem_rd_state == ISSUE_CMD);
   assign rd_addr = mem_rd_addr_r;

   always @ (posedge clk) begin
      if (start) begin
         mem_rd_addr_r <= rd_start_addr_align;
      end
      else if ((mem_rd_state == ISSUE_CMD) && rd_cmd_rdy) begin
         mem_rd_addr_r <= mem_rd_addr_r + MASK_WIDTH;
      end
   end

   always @ (posedge clk) begin
      if (rst) begin
         mem_rd_state <= IDLE;
      end
      else begin
         case (mem_rd_state)
            IDLE:begin
               if (start && ~direction) begin
                  mem_rd_state <= ISSUE_CMD;
               end
               else begin
                  mem_rd_state <= IDLE;
               end
            end
            ISSUE_CMD:begin
               if (rd2wr_data_fifo_prog_full) begin  // fifo prog full, need wait some time to get mem data
                  mem_rd_state <= WAIT;
               end
               else if (rd_cmd_rdy && (rd_end_addr_align_r == mem_rd_addr_r)) begin
                  mem_rd_state <= IDLE;
               end
               else begin
                  mem_rd_state <= ISSUE_CMD;
               end
            end
            WAIT:begin
               if (rd2wr_data_fifo_prog_empty) begin
                  mem_rd_state <= ISSUE_CMD;
               end
               else begin
                  mem_rd_state <= WAIT;
               end
            end
         endcase
      end
   end

   // generate mem wr cmd
   reg  [ADDR_WIDTH-1:0] mem_wr_addr_r;

   assign wr_addr     = mem_wr_addr_r;
   assign wr_data     = (c2h_dma_r && rd2wr_data_fifo_valid) ? rd2wr_data_fifo_dout[DATA_WIDTH-1:0] : 'd0;
   assign wr_datastrb = (c2h_dma_r && rd2wr_data_fifo_valid) ? rd2wr_data_fifo_dout[DATA_WIDTH+MASK_WIDTH-1:DATA_WIDTH] : 'd0;

   always @ (posedge clk) begin
      if (start) begin
         mem_wr_addr_r <= wr_start_addr_align;
      end
      else if (rd2wr_data_fifo_valid && c2h_dma_r && wr_cmd_rdy) begin
         mem_wr_addr_r <= mem_wr_addr_r + MASK_WIDTH;
      end
   end

   // generate axi addr & burst len
   reg                   start_r;
   reg                   start_r2;
   always @ (posedge clk) begin
      start_r  <= start;
      start_r2 <= start_r;
   end

   wire                  axi_cmd_rdy;
   wire                  axi_cmd_vld;
   wire [ADDR_WIDTH-1:0] axi_cmd_addr_start;
   wire [ADDR_WIDTH-1:0] axi_cmd_addr_end;
   wire [AXI_REQ_ALIGN_BITS-ADDR_ALIGN_BITS-1:0] axi_cmd_addr_start_offset;
   wire [AXI_REQ_ALIGN_BITS-ADDR_ALIGN_BITS-1:0] axi_cmd_addr_end_offset;
   wire [ADDR_WIDTH-AXI_REQ_ALIGN_BITS-1:0] axi_nxt_cmd_addr_high_part;

   reg  [ADDR_WIDTH-1:0] axi_cmd_addr_r;
   reg  [7:0]            axi_cmd_bl_r;
   reg  [2:0]            axi_cmd_state;

   assign axi_cmd_rdy                = c2h_dma_r ? arready : h2c_dma_r  ? awready : 1'b0;
   assign axi_cmd_addr_start         = c2h_dma_r ? rd_start_addr_align_r
                                                 : wr_start_addr_align_r;
   assign axi_cmd_addr_end           = c2h_dma_r ? rd_end_addr_align_r
                                                 : wr_end_addr_align_r;
   assign axi_cmd_addr_start_offset  = c2h_dma_r ? rd_start_addr_align_r[AXI_REQ_ALIGN_BITS-1:ADDR_ALIGN_BITS]
                                                 : wr_start_addr_align_r[AXI_REQ_ALIGN_BITS-1:ADDR_ALIGN_BITS];
   assign axi_cmd_addr_end_offset    = c2h_dma_r ? rd_end_addr_align_r[AXI_REQ_ALIGN_BITS-1:ADDR_ALIGN_BITS]
                                                 : wr_end_addr_align_r[AXI_REQ_ALIGN_BITS-1:ADDR_ALIGN_BITS];
   assign axi_cmd_vld                = (axi_cmd_state == ISSUE_CMD);
   assign axi_nxt_cmd_addr_high_part = axi_cmd_addr_r[ADDR_WIDTH-1:AXI_REQ_ALIGN_BITS] + 'd1;

   always @ (posedge clk) begin
      if (rst) begin
         axi_cmd_addr_r <= 'd0;
      end
      else if (start_r) begin
         axi_cmd_addr_r <= axi_cmd_addr_start;
      end
      else if ((axi_cmd_state == ISSUE_CMD) && axi_cmd_rdy) begin
         axi_cmd_addr_r <= {axi_nxt_cmd_addr_high_part,{(AXI_REQ_ALIGN_BITS){1'b0}}};
      end
   end

   always @ (posedge clk) begin
      if (rst) begin
         axi_cmd_bl_r <= 'd0;
      end
      else if (start_r) begin
         axi_cmd_bl_r <= (axi_cmd_addr_start[ADDR_WIDTH-1:AXI_REQ_ALIGN_BITS] == axi_cmd_addr_end[ADDR_WIDTH-1:AXI_REQ_ALIGN_BITS]) ?
                         (axi_cmd_addr_end_offset - axi_cmd_addr_start_offset) :  //DMA op needs only one axi cmd.
                         (AXI_BL_MAX - axi_cmd_addr_start_offset);                //DMA op needs more than one axi cmd.
      end
      else if ((axi_cmd_state == CHK_REQ) && (axi_cmd_addr_end[ADDR_WIDTH-1:AXI_REQ_ALIGN_BITS] == axi_cmd_addr_r[ADDR_WIDTH-1:AXI_REQ_ALIGN_BITS])) begin
         axi_cmd_bl_r <= axi_cmd_addr_end_offset;
      end
      else if (axi_cmd_state == CHK_REQ) begin
         axi_cmd_bl_r <= AXI_BL_MAX;
      end
   end

   always @ (posedge clk) begin
      if (rst) begin
         axi_cmd_state <= IDLE;
      end
      else begin
         case (axi_cmd_state)
            IDLE:begin
               if (start_r2) begin
                  axi_cmd_state <= ISSUE_CMD;
               end
               else begin
                  axi_cmd_state <= IDLE;
               end
            end
            ISSUE_CMD:begin
               if (axi_cmd_rdy) begin
                  axi_cmd_state <= CHK_REQ;
               end
               else begin
                  axi_cmd_state <= ISSUE_CMD;
               end
            end
            CHK_REQ:begin
               if (axi_cmd_addr_end < axi_cmd_addr_r) begin
                  axi_cmd_state <= IDLE;
               end
               else begin
                  axi_cmd_state <= ISSUE_CMD;
               end
            end
         endcase
      end
   end

   // generate axi rd cmd
   assign arvalid = (axi_cmd_state == ISSUE_CMD) && c2h_dma_r;
   assign araddr  = axi_cmd_addr_r;
   assign arlen   = axi_cmd_bl_r;
   assign rready  = 1'b1;

   // generate axi wr cmd
   assign awvalid = (axi_cmd_state == ISSUE_CMD) && h2c_dma_r;
   assign awaddr  = axi_cmd_addr_r;
   assign awlen   = axi_cmd_bl_r;
   assign bready  = 1'b1;

   // generate axi wr data
   reg [ADDR_WIDTH-1:0] axi_wr_true_addr_r;

   always @ (posedge clk) begin
      if (rst) begin
         axi_wr_true_addr_r <= 'd0;
      end
      else if (start_r) begin
         axi_wr_true_addr_r <= wr_start_addr_align_r;
      end
      else if (wready && wvalid) begin
         axi_wr_true_addr_r <= axi_wr_true_addr_r + MASK_WIDTH;
      end
   end

   assign wdata   = rd2wr_data_fifo_dout[DATA_WIDTH-1:0];
   assign wstrb   = rd2wr_data_fifo_dout[DATA_WIDTH+MASK_WIDTH-1:DATA_WIDTH];
   assign wvalid  = h2c_dma_r && rd2wr_data_fifo_valid;
   assign wlast   = (axi_wr_true_addr_r == wr_end_addr_align_r) ||
                    (axi_wr_true_addr_r[AXI_REQ_ALIGN_BITS-1:ADDR_ALIGN_BITS] == {(AXI_REQ_ALIGN_BITS-ADDR_ALIGN_BITS){1'b1}});

   //  status
   reg dma_status_r;
   always @ (posedge clk) begin
      if (rst) begin
         dma_status_r <= 'b0;
      end
      else if (start_r) begin
         dma_status_r <= 1'b1;
      end
      else if (c2h_dma_r && (mem_wr_addr_r == wr_end_addr_align_r)) begin
         dma_status_r <= 1'b0;
      end
      else if (h2c_dma_r && (axi_wr_true_addr_r == wr_end_addr_align_r)) begin
         dma_status_r <= 1'b0;
      end
   end
   assign status = dma_status_r;

endmodule
