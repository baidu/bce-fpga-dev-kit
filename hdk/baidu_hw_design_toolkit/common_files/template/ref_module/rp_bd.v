/*
 *  Copyright (C) 2017 Baidu, Inc. All Rights Reserved.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
`timescale 1 ps / 1 ps
`include "rp_if_define.vh"

module rp_bd #(
   parameter DATA_WIDTH = 256,
   parameter ADDR_WIDTH = 64,
   parameter MASK_WIDTH = DATA_WIDTH/8,
   parameter ID_WIDTH   = 4
)(

   `ifdef APP_DDR
      `include "rp_port_app.vh"
   `endif
   `ifdef AXI_DDR
      `include "rp_port_axiddr.vh"
   `endif
   `ifdef RP_AXI_MASTER 
      `include "rp_axi_master.vh"
   `endif

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
 assign S_AXI_arready = 1'b0;
 assign S_AXI_awready = 1'b0;
 assign S_AXI_wready  = 1'b0;
 assign S_AXI_bvalid  = 1'b0;
 assign S_AXI_rvalid  = 1'b0;
 
endmodule
