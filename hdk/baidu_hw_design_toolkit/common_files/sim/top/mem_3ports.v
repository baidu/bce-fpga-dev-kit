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
module mem_3ports #(
   parameter DATA_WIDTH      = 512,
   parameter ADDR_WIDTH      = 64,
   parameter MASK_WIDTH      = DATA_WIDTH/8,
   parameter HOST_MEM_SIZE   = 1 * 1024 * 1024,
   parameter ADDR_ALIGN_BITS = $clog2(MASK_WIDTH),
   parameter HOST_MEM_DEPTH  = HOST_MEM_SIZE/MASK_WIDTH
)(
   input                    clk,
   input                    rst,

   input  [DATA_WIDTH-1:0]      c1_wr_data,
   input  [MASK_WIDTH-1:0]      c1_wr_datastrb,
   input  [ADDR_WIDTH-1:0]      c1_wr_addr,
   output reg [DATA_WIDTH-1:0]  c1_rd_data,
   output reg                   c1_rd_data_vld,
   input                        c1_rd_en,
   input  [ADDR_WIDTH-1:0]      c1_rd_addr,

   input  [DATA_WIDTH-1:0]      c2_wr_data,
   input  [MASK_WIDTH-1:0]      c2_wr_datastrb,
   input  [ADDR_WIDTH-1:0]      c2_wr_addr,
   output reg [DATA_WIDTH-1:0]  c2_rd_data,
   output reg                   c2_rd_data_vld,
   input                        c2_rd_en,
   input  [ADDR_WIDTH-1:0]      c2_rd_addr,

   input  [DATA_WIDTH-1:0]      c3_wr_data,
   input  [MASK_WIDTH-1:0]      c3_wr_datastrb,
   input  [ADDR_WIDTH-1:0]      c3_wr_addr,
   output reg [DATA_WIDTH-1:0]  c3_rd_data,
   output reg                   c3_rd_data_vld,
   input                        c3_rd_en,
   input  [ADDR_WIDTH-1:0]      c3_rd_addr

);

   reg [DATA_WIDTH-1:0] host_memory[HOST_MEM_DEPTH-1:0];
   /*
   genvar host_mem_idx;
   generate
      for (host_mem_idx = 0; host_mem_idx < HOST_MEM_DEPTH; host_mem_idx = host_mem_idx + 1) begin: host_memory1
         always @ (posedge clk) begin
            if (rst) begin
               host_memory[host_mem_idx] <= 'd0;
            end
         end
      end
   endgenerate
   */
   genvar mask_idx;
   generate
      for (mask_idx = 0; mask_idx < MASK_WIDTH; mask_idx = mask_idx + 1) begin: host_memory_wr
         always @ (posedge clk) begin
            if (c1_wr_datastrb[mask_idx]) begin
               host_memory[c1_wr_addr[ADDR_WIDTH-1:ADDR_ALIGN_BITS]][8*mask_idx+7:8*mask_idx] <= c1_wr_data[8*mask_idx+7:8*mask_idx];
            end
            if (c2_wr_datastrb[mask_idx]) begin
               host_memory[c2_wr_addr[ADDR_WIDTH-1:ADDR_ALIGN_BITS]][8*mask_idx+7:8*mask_idx] <= c2_wr_data[8*mask_idx+7:8*mask_idx];
            end
            if (c3_wr_datastrb[mask_idx]) begin
               host_memory[c3_wr_addr[ADDR_WIDTH-1:ADDR_ALIGN_BITS]][8*mask_idx+7:8*mask_idx] <= c3_wr_data[8*mask_idx+7:8*mask_idx];
            end
         end
      end
   endgenerate

   always @ (posedge clk) begin
      c1_rd_data <= host_memory[c1_rd_addr[ADDR_WIDTH-1:ADDR_ALIGN_BITS]];
      c1_rd_data_vld <= c1_rd_en;
      c2_rd_data <= host_memory[c2_rd_addr[ADDR_WIDTH-1:ADDR_ALIGN_BITS]];
      c2_rd_data_vld <= c2_rd_en;
      c3_rd_data <= host_memory[c3_rd_addr[ADDR_WIDTH-1:ADDR_ALIGN_BITS]];
      c3_rd_data_vld <= c3_rd_en;
   end

endmodule
