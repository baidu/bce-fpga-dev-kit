//Confidential and proprietary information of Baidu, Inc
//////////////////////////////////////////////////////
//
//
//    Version:1.0
//    FileName: mem_2ports.v
//    Data last Modified:
//    Data Created:June. 6th, 2017
//
//
//
//    Device:xcku115-flvf1924-2-e
//    Purpose:simulate memory with register array
//
//    Reference:
//    Revision History:
//    Rev 1.0 - First created, ruanyuan,
//    email: ruanyuan@baidu.com
//////////////////////////////////////////////////////
`timescale 1ns / 1ps
module mem_2ports #(
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
   input  [MASK_WIDTH-1:0]      c1_wr_datamask,
   input  [ADDR_WIDTH-1:0]      c1_wr_addr,
   output reg [DATA_WIDTH-1:0]  c1_rd_data,
   output reg                   c1_rd_data_vld,
   input                        c1_rd_en,
   input  [ADDR_WIDTH-1:0]      c1_rd_addr,

   input  [DATA_WIDTH-1:0]      c2_wr_data,
   input  [MASK_WIDTH-1:0]      c2_wr_datamask,
   input  [ADDR_WIDTH-1:0]      c2_wr_addr,
   output reg [DATA_WIDTH-1:0]  c2_rd_data,
   output reg                   c2_rd_data_vld,
   input                        c2_rd_en,
   input  [ADDR_WIDTH-1:0]      c2_rd_addr
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
            if (c1_wr_datamask[mask_idx]) begin
               host_memory[c1_wr_addr[ADDR_WIDTH-1:ADDR_ALIGN_BITS]][8*mask_idx+7:8*mask_idx] <= c1_wr_data[8*mask_idx+7:8*mask_idx];
            end
            else if (c2_wr_datamask[mask_idx]) begin
               host_memory[c2_wr_addr[ADDR_WIDTH-1:ADDR_ALIGN_BITS]][8*mask_idx+7:8*mask_idx] <= c2_wr_data[8*mask_idx+7:8*mask_idx];
            end
         end
      end
   endgenerate

   always @ (posedge clk) begin
      c1_rd_data <= host_memory[c1_rd_addr[ADDR_WIDTH-1:ADDR_ALIGN_BITS]];
      c1_rd_data_vld <= c1_rd_en;
      c2_rd_data <= host_memory[c2_rd_addr[ADDR_WIDTH-1:ADDR_ALIGN_BITS]];
      c2_rd_data_vld <= c2_rd_en;
   end

endmodule
