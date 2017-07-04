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
`include "usr_ddr4_define.vh"
module card_sim ();

   localparam DATA_WIDTH = 256;
   localparam ADDR_WIDTH = 64;
   localparam MASK_WIDTH = DATA_WIDTH/8;
   localparam ID_WIDTH   = 4;
   localparam ADDR_ALIGN_BITS = $clog2(MASK_WIDTH);

   localparam AXI_CLK_PERIOD = 2;
   localparam PE_CLK_PERIOD  = 5;
   localparam C0_SYS_CLK_PERIOD = 2.5;
   localparam C1_SYS_CLK_PERIOD = 2.5;
   localparam C2_SYS_CLK_PERIOD = 2.5;
   localparam C3_SYS_CLK_PERIOD = 2.5;

   reg rst;
   reg axi_clk;
   reg pe_clk;
   reg C0_SYS_CLK_clk_p;
   reg C0_SYS_CLK_clk_n;
   reg C1_SYS_CLK_clk_p;
   reg C1_SYS_CLK_clk_n;
   reg C2_SYS_CLK_clk_p;
   reg C2_SYS_CLK_clk_n;
   reg C3_SYS_CLK_clk_p;
   reg C3_SYS_CLK_clk_n;

   wire   [ADDR_WIDTH-1:0]  AXI_araddr;
   wire   [1:0]             AXI_arburst;
   wire   [3:0]             AXI_arcache;
   wire   [ID_WIDTH-1:0]    AXI_arid;
   wire   [7:0]             AXI_arlen;
   wire                     AXI_arlock;
   wire   [2:0]             AXI_arprot;
   wire   [3:0]             AXI_arqos;
   wire   [3:0]             AXI_arregion;
   wire                     AXI_arready;
   wire   [2:0]             AXI_arsize;
   wire                     AXI_arvalid;
   // AXI Master AR channel
   wire   [ADDR_WIDTH-1:0]  AXI_awaddr;
   wire   [1:0]             AXI_awburst;
   wire   [3:0]             AXI_awcache;
   wire   [ID_WIDTH-1:0]    AXI_awid;
   wire   [7:0]             AXI_awlen;
   wire                     AXI_awlock;
   wire   [2:0]             AXI_awprot;
   wire   [3:0]             AXI_awqos;
   wire   [3:0]             AXI_awregion;
   wire                     AXI_awready;
   wire   [2:0]             AXI_awsize;
   wire                     AXI_awvalid;
   // AXI Master B channel
   wire   [ID_WIDTH-1:0]    AXI_bid;
   wire                     AXI_bready;
   wire   [1:0]             AXI_bresp;
   wire                     AXI_bvalid;
   // AXI Master R channel
   wire   [DATA_WIDTH-1:0]  AXI_rdata;
   wire   [ID_WIDTH-1:0]    AXI_rid;
   wire                     AXI_rlast;
   wire                     AXI_rready;
   wire   [1:0]             AXI_rresp;
   wire                     AXI_rvalid;
   // AXI Master W channel
   wire   [DATA_WIDTH-1:0]  AXI_wdata;
   wire                     AXI_wlast;
   wire                     AXI_wready;
   wire   [MASK_WIDTH-1:0]  AXI_wstrb;
   wire                     AXI_wvalid;

   // AXI Lite Master AW channel
   wire   [15:0]            AXI_LITE_araddr;
   wire   [2:0]             AXI_LITE_arprot;
   wire                     AXI_LITE_arready;
   wire                     AXI_LITE_arvalid;
   // AXI Lite Master AR channel
   wire   [15:0]            AXI_LITE_awaddr;
   wire   [2:0]             AXI_LITE_awprot;
   wire                     AXI_LITE_awready;
   wire                     AXI_LITE_awvalid;
   // AXI Lite Master B channel
   wire                     AXI_LITE_bready;
   wire   [1:0]             AXI_LITE_bresp;
   wire                     AXI_LITE_bvalid;
   // AXI Lite Master R channel
   wire   [31:0]            AXI_LITE_rdata;
   wire                     AXI_LITE_rready;
   wire   [1:0]             AXI_LITE_rresp;
   wire                     AXI_LITE_rvalid;
   // AXI Lite Master W channel
   wire   [31:0]            AXI_LITE_wdata;
   wire                     AXI_LITE_wready;
   wire   [3:0]             AXI_LITE_wstrb;
   wire                     AXI_LITE_wvalid;

   // interrupt signals
   wire   [15:0]            usr_irq_req;
   wire   [15:0]            usr_irq_ack;

   wire                     C0_DDR4_act_n;
   wire   [16:0]            C0_DDR4_adr;
   wire   [1:0]             C0_DDR4_ba;
   wire   [0:0]             C0_DDR4_bg;
   wire   [0:0]             C0_DDR4_cke;
   wire   [0:0]             C0_DDR4_odt;
   wire   [0:0]             C0_DDR4_cs_n;
   wire   [0:0]             C0_DDR4_ck_t;
   wire   [0:0]             C0_DDR4_ck_c;
   wire                     C0_DDR4_reset_n;
   wire   [8:0]             C0_DDR4_dm_dbi_n;
   wire   [71:0]            C0_DDR4_dq;
   wire   [8:0]             C0_DDR4_dqs_c;
   wire   [8:0]             C0_DDR4_dqs_t;

   wire                     C1_DDR4_act_n;
   wire   [16:0]            C1_DDR4_adr;
   wire   [1:0]             C1_DDR4_ba;
   wire   [0:0]             C1_DDR4_bg;
   wire   [0:0]             C1_DDR4_cke;
   wire   [0:0]             C1_DDR4_odt;
   wire   [0:0]             C1_DDR4_cs_n;
   wire   [0:0]             C1_DDR4_ck_t;
   wire   [0:0]             C1_DDR4_ck_c;
   wire                     C1_DDR4_reset_n;
   wire   [8:0]             C1_DDR4_dm_dbi_n;
   wire   [71:0]            C1_DDR4_dq;
   wire   [8:0]             C1_DDR4_dqs_c;
   wire   [8:0]             C1_DDR4_dqs_t;

   wire                     C2_DDR4_act_n;
   wire   [16:0]            C2_DDR4_adr;
   wire   [1:0]             C2_DDR4_ba;
   wire   [0:0]             C2_DDR4_bg;
   wire   [0:0]             C2_DDR4_cke;
   wire   [0:0]             C2_DDR4_odt;
   wire   [0:0]             C2_DDR4_cs_n;
   wire   [0:0]             C2_DDR4_ck_t;
   wire   [0:0]             C2_DDR4_ck_c;
   wire                     C2_DDR4_reset_n;
   wire   [8:0]             C2_DDR4_dm_dbi_n;
   wire   [71:0]            C2_DDR4_dq;
   wire   [8:0]             C2_DDR4_dqs_c;
   wire   [8:0]             C2_DDR4_dqs_t;

   wire                     C3_DDR4_act_n;
   wire   [16:0]            C3_DDR4_adr;
   wire   [1:0]             C3_DDR4_ba;
   wire   [0:0]             C3_DDR4_bg;
   wire   [0:0]             C3_DDR4_cke;
   wire   [0:0]             C3_DDR4_odt;
   wire   [0:0]             C3_DDR4_cs_n;
   wire   [0:0]             C3_DDR4_ck_t;
   wire   [0:0]             C3_DDR4_ck_c;
   wire                     C3_DDR4_reset_n;
   wire   [8:0]             C3_DDR4_dm_dbi_n;
   wire   [71:0]            C3_DDR4_dq;
   wire   [8:0]             C3_DDR4_dqs_c;
   wire   [8:0]             C3_DDR4_dqs_t;

`ifndef FAST_SIM
   `ifdef USE_DDR4_C0
   dram_wrapper dram_wrapper_c0(
      .c0_ddr4_act_n(C0_DDR4_act_n),
      .c0_ddr4_adr(C0_DDR4_adr),
      .c0_ddr4_ba(C0_DDR4_ba),
      .c0_ddr4_bg(C0_DDR4_bg),
      .c0_ddr4_cke(C0_DDR4_cke),
      .c0_ddr4_odt(C0_DDR4_odt),
      .c0_ddr4_cs_n(C0_DDR4_cs_n),
      .c0_ddr4_ck_t_int(C0_DDR4_ck_t),
      .c0_ddr4_ck_c_int(C0_DDR4_ck_c),
      .c0_ddr4_reset_n(C0_DDR4_reset_n),
      .c0_ddr4_dm_dbi_n(C0_DDR4_dm_dbi_n),
      .c0_ddr4_dq(C0_DDR4_dq),
      .c0_ddr4_dqs_c(C0_DDR4_dqs_c),
      .c0_ddr4_dqs_t(C0_DDR4_dqs_t)
   );
   `endif
   `ifdef USE_DDR4_C1
   dram_wrapper dram_wrapper_c1(
      .c0_ddr4_act_n(C1_DDR4_act_n),
      .c0_ddr4_adr(C1_DDR4_adr),
      .c0_ddr4_ba(C1_DDR4_ba),
      .c0_ddr4_bg(C1_DDR4_bg),
      .c0_ddr4_cke(C1_DDR4_cke),
      .c0_ddr4_odt(C1_DDR4_odt),
      .c0_ddr4_cs_n(C1_DDR4_cs_n),
      .c0_ddr4_ck_t_int(C1_DDR4_ck_t),
      .c0_ddr4_ck_c_int(C1_DDR4_ck_c),
      .c0_ddr4_reset_n(C1_DDR4_reset_n),
      .c0_ddr4_dm_dbi_n(C1_DDR4_dm_dbi_n),
      .c0_ddr4_dq(C1_DDR4_dq),
      .c0_ddr4_dqs_c(C1_DDR4_dqs_c),
      .c0_ddr4_dqs_t(C1_DDR4_dqs_t)
   );
   `endif
   `ifdef USE_DDR4_C2
   dram_wrapper dram_wrapper_c2(
      .c0_ddr4_act_n(C2_DDR4_act_n),
      .c0_ddr4_adr(C2_DDR4_adr),
      .c0_ddr4_ba(C2_DDR4_ba),
      .c0_ddr4_bg(C2_DDR4_bg),
      .c0_ddr4_cke(C2_DDR4_cke),
      .c0_ddr4_odt(C2_DDR4_odt),
      .c0_ddr4_cs_n(C2_DDR4_cs_n),
      .c0_ddr4_ck_t_int(C2_DDR4_ck_t),
      .c0_ddr4_ck_c_int(C2_DDR4_ck_c),
      .c0_ddr4_reset_n(C2_DDR4_reset_n),
      .c0_ddr4_dm_dbi_n(C2_DDR4_dm_dbi_n),
      .c0_ddr4_dq(C2_DDR4_dq),
      .c0_ddr4_dqs_c(C2_DDR4_dqs_c),
      .c0_ddr4_dqs_t(C2_DDR4_dqs_t)
   );
   `endif
   `ifdef USE_DDR4_C3
   dram_wrapper dram_wrapper_c3(
      .c0_ddr4_act_n(C3_DDR4_act_n),
      .c0_ddr4_adr(C3_DDR4_adr),
      .c0_ddr4_ba(C3_DDR4_ba),
      .c0_ddr4_bg(C3_DDR4_bg),
      .c0_ddr4_cke(C3_DDR4_cke),
      .c0_ddr4_odt(C3_DDR4_odt),
      .c0_ddr4_cs_n(C3_DDR4_cs_n),
      .c0_ddr4_ck_t_int(C3_DDR4_ck_t),
      .c0_ddr4_ck_c_int(C3_DDR4_ck_c),
      .c0_ddr4_reset_n(C3_DDR4_reset_n),
      .c0_ddr4_dm_dbi_n(C3_DDR4_dm_dbi_n),
      .c0_ddr4_dq(C3_DDR4_dq),
      .c0_ddr4_dqs_c(C3_DDR4_dqs_c),
      .c0_ddr4_dqs_t(C3_DDR4_dqs_t)
   );
   `endif
`endif

   sp_sim sp_sim(
      .clk(axi_clk),
      .rst(rst),
      // AXI Master AW channel
      .M_AXI_araddr(AXI_araddr),
      .M_AXI_arburst(AXI_arburst),
      .M_AXI_arcache(AXI_arcache),
      .M_AXI_arid(AXI_arid),
      .M_AXI_arlen(AXI_arlen),
      .M_AXI_arlock(AXI_arlock),
      .M_AXI_arprot(AXI_arprot),
      .M_AXI_arqos(AXI_arqos),
      .M_AXI_arregion(AXI_arregion),
      .M_AXI_arready(AXI_arready),
      .M_AXI_arsize(AXI_arsize),
      .M_AXI_arvalid(AXI_arvalid),
      // AXI Master AR channel
      .M_AXI_awaddr(AXI_awaddr),
      .M_AXI_awburst(AXI_awburst),
      .M_AXI_awcache(AXI_awcache),
      .M_AXI_awid(AXI_awid),
      .M_AXI_awlen(AXI_awlen),
      .M_AXI_awlock(AXI_awlock),
      .M_AXI_awprot(AXI_awprot),
      .M_AXI_awqos(AXI_awqos),
      .M_AXI_awregion(AXI_awregion),
      .M_AXI_awready(AXI_awready),
      .M_AXI_awsize(AXI_awsize),
      .M_AXI_awvalid(AXI_awvalid),
      // AXI Master B channel
      .M_AXI_bid(AXI_bid),
      .M_AXI_bready(AXI_bready),
      .M_AXI_bresp(AXI_bresp),
      .M_AXI_bvalid(AXI_bvalid),
      // AXI Master R channel
      .M_AXI_rdata(AXI_rdata),
      .M_AXI_rid(AXI_rid),
      .M_AXI_rlast(AXI_rlast),
      .M_AXI_rready(AXI_rready),
      .M_AXI_rresp(AXI_rresp),
      .M_AXI_rvalid(AXI_rvalid),
      // AXI Master W channel
      .M_AXI_wdata(AXI_wdata),
      .M_AXI_wlast(AXI_wlast),
      .M_AXI_wready(AXI_wready),
      .M_AXI_wstrb(AXI_wstrb),
      .M_AXI_wvalid(AXI_wvalid),

      // AXI Lite Master AW channel
      .M_AXI_LITE_araddr(AXI_LITE_araddr),
      .M_AXI_LITE_arprot(AXI_LITE_arprot),
      .M_AXI_LITE_arready(AXI_LITE_arready),
      .M_AXI_LITE_arvalid(AXI_LITE_arvalid),
      // AXI Lite Master AR channel
      .M_AXI_LITE_awaddr(AXI_LITE_awaddr),
      .M_AXI_LITE_awprot(AXI_LITE_awprot),
      .M_AXI_LITE_awready(AXI_LITE_awready),
      .M_AXI_LITE_awvalid(AXI_LITE_awvalid),
      // AXI Lite Master B channel
      .M_AXI_LITE_bready(AXI_LITE_bready),
      .M_AXI_LITE_bresp(AXI_LITE_bresp),
      .M_AXI_LITE_bvalid(AXI_LITE_bvalid),
      // AXI Lite Master R channel
      .M_AXI_LITE_rdata(AXI_LITE_rdata),
      .M_AXI_LITE_rready(AXI_LITE_rready),
      .M_AXI_LITE_rresp(AXI_LITE_rresp),
      .M_AXI_LITE_rvalid(AXI_LITE_rvalid),
      // AXI Lite Master W channel
      .M_AXI_LITE_wdata(AXI_LITE_wdata),
      .M_AXI_LITE_wready(AXI_LITE_wready),
      .M_AXI_LITE_wstrb(AXI_LITE_wstrb),
      .M_AXI_LITE_wvalid(AXI_LITE_wvalid),
      // interrupt signals
      .usr_irq_req(usr_irq_req),
      .usr_irq_ack(usr_irq_ack)
   );

   rp_sim rp_sim(
      .S_AXI_araddr(AXI_araddr),
      .S_AXI_arburst(AXI_arburst),
      .S_AXI_arcache(AXI_arcache),
      .S_AXI_arid(AXI_arid),
      .S_AXI_arlen(AXI_arlen),
      .S_AXI_arlock(AXI_arlock),
      .S_AXI_arprot(AXI_arprot),
      .S_AXI_arqos(AXI_arqos),
      .S_AXI_arregion(AXI_arregion),
      .S_AXI_arready(AXI_arready),
      .S_AXI_arsize(AXI_arsize),
      .S_AXI_arvalid(AXI_arvalid),
      .S_AXI_awaddr(AXI_awaddr),
      .S_AXI_awburst(AXI_awburst),
      .S_AXI_awcache(AXI_awcache),
      .S_AXI_awid(AXI_awid),
      .S_AXI_awlen(AXI_awlen),
      .S_AXI_awlock(AXI_awlock),
      .S_AXI_awprot(AXI_awprot),
      .S_AXI_awqos(AXI_awqos),
      .S_AXI_awregion(AXI_awregion),
      .S_AXI_awready(AXI_awready),
      .S_AXI_awsize(AXI_awsize),
      .S_AXI_awvalid(AXI_awvalid),
      .S_AXI_bid(AXI_bid),
      .S_AXI_bready(AXI_bready),
      .S_AXI_bresp(AXI_bresp),
      .S_AXI_bvalid(AXI_bvalid),
      .S_AXI_rdata(AXI_rdata),
      .S_AXI_rid(AXI_rid),
      .S_AXI_rlast(AXI_rlast),
      .S_AXI_rready(AXI_rready),
      .S_AXI_rresp(AXI_rresp),
      .S_AXI_rvalid(AXI_rvalid),
      .S_AXI_wdata(AXI_wdata),
      .S_AXI_wlast(AXI_wlast),
      .S_AXI_wready(AXI_wready),
      .S_AXI_wstrb(AXI_wstrb),
      .S_AXI_wvalid(AXI_wvalid),
      .S_AXI_LITE_araddr(AXI_LITE_araddr),
      .S_AXI_LITE_arprot(AXI_LITE_arprot),
      .S_AXI_LITE_arready(AXI_LITE_arready),
      .S_AXI_LITE_arvalid(AXI_LITE_arvalid),
      .S_AXI_LITE_awaddr(AXI_LITE_awaddr),
      .S_AXI_LITE_awprot(AXI_LITE_awprot),
      .S_AXI_LITE_awready(AXI_LITE_awready),
      .S_AXI_LITE_awvalid(AXI_LITE_awvalid),
      .S_AXI_LITE_bready(AXI_LITE_bready),
      .S_AXI_LITE_bresp(AXI_LITE_bresp),
      .S_AXI_LITE_bvalid(AXI_LITE_bvalid),
      .S_AXI_LITE_rdata(AXI_LITE_rdata),
      .S_AXI_LITE_rready(AXI_LITE_rready),
      .S_AXI_LITE_rresp(AXI_LITE_rresp),
      .S_AXI_LITE_rvalid(AXI_LITE_rvalid),
      .S_AXI_LITE_wdata(AXI_LITE_wdata),
      .S_AXI_LITE_wready(AXI_LITE_wready),
      .S_AXI_LITE_wstrb(AXI_LITE_wstrb),
      .S_AXI_LITE_wvalid(AXI_LITE_wvalid),

      .C0_DDR4_act_n(C0_DDR4_act_n),
      .C0_DDR4_adr(C0_DDR4_adr),
      .C0_DDR4_ba(C0_DDR4_ba),
      .C0_DDR4_bg(C0_DDR4_bg),
      .C0_DDR4_ck_c(C0_DDR4_ck_c),
      .C0_DDR4_cke(C0_DDR4_cke),
      .C0_DDR4_cs_n(C0_DDR4_cs_n),
      .C0_DDR4_dm_n(C0_DDR4_dm_dbi_n),
      .C0_DDR4_dq(C0_DDR4_dq),
      .C0_DDR4_dqs_c(C0_DDR4_dqs_c),
      .C0_DDR4_odt(C0_DDR4_odt),
      .C0_DDR4_reset_n(C0_DDR4_reset_n),
      .C0_SYS_CLK_clk_n(C0_SYS_CLK_clk_n),
      .C0_SYS_CLK_clk_p(C0_SYS_CLK_clk_p),
      .C0_DDR4_ck_t(C0_DDR4_ck_t),
      .C0_DDR4_dqs_t(C0_DDR4_dqs_t),

      .C1_DDR4_act_n(C1_DDR4_act_n),
      .C1_DDR4_adr(C1_DDR4_adr),
      .C1_DDR4_ba(C1_DDR4_ba),
      .C1_DDR4_bg(C1_DDR4_bg),
      .C1_DDR4_ck_c(C1_DDR4_ck_c),
      .C1_DDR4_cke(C1_DDR4_cke),
      .C1_DDR4_cs_n(C1_DDR4_cs_n),
      .C1_DDR4_dm_n(C1_DDR4_dm_dbi_n),
      .C1_DDR4_dq(C1_DDR4_dq),
      .C1_DDR4_dqs_c(C1_DDR4_dqs_c),
      .C1_DDR4_odt(C1_DDR4_odt),
      .C1_DDR4_reset_n(C1_DDR4_reset_n),
      .C1_SYS_CLK_clk_n(C1_SYS_CLK_clk_n),
      .C1_SYS_CLK_clk_p(C1_SYS_CLK_clk_p),
      .C1_DDR4_ck_t(C1_DDR4_ck_t),
      .C1_DDR4_dqs_t(C1_DDR4_dqs_t),

      .C2_DDR4_act_n(C2_DDR4_act_n),
      .C2_DDR4_adr(C2_DDR4_adr),
      .C2_DDR4_ba(C2_DDR4_ba),
      .C2_DDR4_bg(C2_DDR4_bg),
      .C2_DDR4_ck_c(C2_DDR4_ck_c),
      .C2_DDR4_cke(C2_DDR4_cke),
      .C2_DDR4_cs_n(C2_DDR4_cs_n),
      .C2_DDR4_dm_n(C2_DDR4_dm_dbi_n),
      .C2_DDR4_dq(C2_DDR4_dq),
      .C2_DDR4_dqs_c(C2_DDR4_dqs_c),
      .C2_DDR4_odt(C2_DDR4_odt),
      .C2_DDR4_reset_n(C2_DDR4_reset_n),
      .C2_SYS_CLK_clk_n(C2_SYS_CLK_clk_n),
      .C2_SYS_CLK_clk_p(C2_SYS_CLK_clk_p),
      .C2_DDR4_ck_t(C2_DDR4_ck_t),
      .C2_DDR4_dqs_t(C2_DDR4_dqs_t),

      .C3_DDR4_act_n(C3_DDR4_act_n),
      .C3_DDR4_adr(C3_DDR4_adr),
      .C3_DDR4_ba(C3_DDR4_ba),
      .C3_DDR4_bg(C3_DDR4_bg),
      .C3_DDR4_ck_c(C3_DDR4_ck_c),
      .C3_DDR4_cke(C3_DDR4_cke),
      .C3_DDR4_cs_n(C3_DDR4_cs_n),
      .C3_DDR4_dm_n(C3_DDR4_dm_dbi_n),
      .C3_DDR4_dq(C3_DDR4_dq),
      .C3_DDR4_dqs_c(C3_DDR4_dqs_c),
      .C3_DDR4_odt(C3_DDR4_odt),
      .C3_DDR4_reset_n(C3_DDR4_reset_n),
      .C3_SYS_CLK_clk_n(C3_SYS_CLK_clk_n),
      .C3_SYS_CLK_clk_p(C3_SYS_CLK_clk_p),
      .C3_DDR4_ck_t(C3_DDR4_ck_t),
      .C3_DDR4_dqs_t(C3_DDR4_dqs_t),

      .s_axi_aclk(axi_clk),
      .pe_clk(pe_clk),
      .i_soft_rst_n(1'b1),
      .s_axi_aresetn(~rst),
      .sys_reset(rst),
      .usr_irq_ack(usr_irq_ack),
      .usr_irq_req(usr_irq_req)
   );

///////////simulation start////////////
initial begin
   axi_clk          = 'd0;
   pe_clk           = 'd0;
   rst              = 'd1;
   C0_SYS_CLK_clk_p = 'd1;
   C0_SYS_CLK_clk_n = 'd0;
   C1_SYS_CLK_clk_p = 'd1;
   C1_SYS_CLK_clk_n = 'd0;
   C2_SYS_CLK_clk_p = 'd1;
   C2_SYS_CLK_clk_n = 'd0;
   C3_SYS_CLK_clk_p = 'd1;
   C3_SYS_CLK_clk_n = 'd0;
   #100;
   rst         = 'd0;
end

always begin
   #AXI_CLK_PERIOD;
   axi_clk = ~axi_clk;
end

always begin
   #PE_CLK_PERIOD;
   pe_clk = ~pe_clk;
end

always begin
   #C0_SYS_CLK_PERIOD;
   C0_SYS_CLK_clk_p = ~C0_SYS_CLK_clk_p;
end

always begin
   #C0_SYS_CLK_PERIOD;
   C0_SYS_CLK_clk_n = ~C0_SYS_CLK_clk_n;
end

always begin
   #C1_SYS_CLK_PERIOD;
   C1_SYS_CLK_clk_p = ~C1_SYS_CLK_clk_p;
end

always begin
   #C1_SYS_CLK_PERIOD;
    C1_SYS_CLK_clk_n = ~C1_SYS_CLK_clk_n;
end

always begin
   #C2_SYS_CLK_PERIOD;
   C2_SYS_CLK_clk_p = ~C2_SYS_CLK_clk_p;
end

always begin
   #C2_SYS_CLK_PERIOD;
   C2_SYS_CLK_clk_n = ~C2_SYS_CLK_clk_n;
end

always begin
   #C3_SYS_CLK_PERIOD;
   C3_SYS_CLK_clk_p = ~C0_SYS_CLK_clk_p;
end

always begin
   #C3_SYS_CLK_PERIOD;
   C3_SYS_CLK_clk_n = ~C0_SYS_CLK_clk_n;
end

endmodule
