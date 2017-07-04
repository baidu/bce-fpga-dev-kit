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
`timescale 1ps/1ps

module mig_dummy
(
   output reg     c0_init_calib_complete,
   input          c0_ddr4_app_correct_en_i,
   output [51:0]  c0_ddr4_ecc_err_addr,
   output [7:0]   c0_ddr4_ecc_single,
   output [7:0]   c0_ddr4_ecc_multiple,

   output reg     c0_ddr4_ui_clk,
   output reg     c0_ddr4_ui_clk_sync_rst,
   output         dbg_clk,

   // user interface ports
   input  [27:0]  c0_ddr4_app_addr,
   input  [2:0]   c0_ddr4_app_cmd,
   input          c0_ddr4_app_en,
   input          c0_ddr4_app_hi_pri,
   input  [511:0] c0_ddr4_app_wdf_data,
   input          c0_ddr4_app_wdf_end,
   input  [63:0]  c0_ddr4_app_wdf_mask,
   input          c0_ddr4_app_wdf_wren,

   output [511:0] c0_ddr4_app_rd_data,
   output         c0_ddr4_app_rd_data_end,
   output         c0_ddr4_app_rd_data_valid,
   output         c0_ddr4_app_rdy,
   output         c0_ddr4_app_wdf_rdy,
   // Debug Port
   output [511:0] dbg_bus
);

initial begin
   c0_ddr4_ui_clk = 1'b0;
   c0_ddr4_ui_clk_sync_rst = 1'b1;
   c0_init_calib_complete = 1'b0;
   #1000;
   c0_ddr4_ui_clk_sync_rst = 1'b0;
   #1000;
   c0_init_calib_complete = 1'b1;
end

always begin
   #1667
   c0_ddr4_ui_clk = ~c0_ddr4_ui_clk;
end 

   wire   [511:0] mem_wr_data;
   wire   [63:0]  mem_wr_datastrb;
   wire   [63:0]  mem_wr_addr;
   wire   [511:0] mem_rd_data;
   wire           mem_rd_data_vld;
   wire           mem_rd_en;
   wire   [63:0]  mem_rd_addr;

assign c0_ddr4_app_rdy = (~c0_ddr4_app_en) ? 1'b0 :
                         (c0_ddr4_app_cmd == 3'b001) ? 1'b1 :
                         (c0_ddr4_app_wdf_wren);
assign c0_ddr4_app_wdf_rdy = c0_ddr4_app_en && (c0_ddr4_app_cmd != 3'b001);

assign  mem_wr_data = c0_ddr4_app_wdf_data;
assign  mem_wr_datastrb = (c0_ddr4_app_wdf_wren && c0_ddr4_app_wdf_rdy) ? ~c0_ddr4_app_wdf_mask :
                          {(64){1'b0}};
assign  mem_wr_addr = {c0_ddr4_app_addr,3'b0};
assign  mem_rd_en = (c0_ddr4_app_cmd == 3'b001) && c0_ddr4_app_en;
assign  mem_rd_addr = {c0_ddr4_app_addr,3'b0};
assign  c0_ddr4_app_rd_data = mem_rd_data;
assign  c0_ddr4_app_rd_data_end = 1'b1;
assign  c0_ddr4_app_rd_data_valid = mem_rd_data_vld;

mem_2ports #(
   .DATA_WIDTH(512),
   .ADDR_WIDTH(31),
   .HOST_MEM_SIZE(256*1024)
)card_mem(
   .clk(c0_ddr4_ui_clk),
   .rst(c0_ddr4_ui_clk_sync_rst),

   .c1_wr_data(mem_wr_data),
   .c1_wr_datastrb(mem_wr_datastrb),
   .c1_wr_addr(mem_wr_addr),
   .c1_rd_data(mem_rd_data),
   .c1_rd_data_vld(mem_rd_data_vld),
   .c1_rd_en(mem_rd_en),
   .c1_rd_addr(mem_rd_addr),

   .c2_wr_data(),
   .c2_wr_datastrb(64'd0),
   .c2_wr_addr(),
   .c2_rd_data(),
   .c2_rd_data_vld(),
   .c2_rd_en(1'b0),
   .c2_rd_addr()
);


endmodule
