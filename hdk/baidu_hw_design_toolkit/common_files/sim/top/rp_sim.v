//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.4 (lin64) Build 1733598 Wed Dec 14 22:35:42 MST 2016
//Date        : Tue Mar 21 19:09:45 2017
//Host        : bb-mco-cloud-storage2.bb01.baidu.com running 64-bit CentOS release 6.3 (Final)
//Command     : generate_target rp_bd_wrapper.bd
//Design      : rp_bd_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps
`include "usr_ddr4_define.vh"

module rp_sim
   (S_AXI_araddr,
    S_AXI_arburst,
    S_AXI_arcache,
    S_AXI_arid,
    S_AXI_arlen,
    S_AXI_arlock,
    S_AXI_arprot,
    S_AXI_arqos,
    S_AXI_arregion,
    S_AXI_arready,
    S_AXI_arsize,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awburst,
    S_AXI_awcache,
    S_AXI_awid,
    S_AXI_awlen,
    S_AXI_awlock,
    S_AXI_awprot,
    S_AXI_awqos,
    S_AXI_awregion,
    S_AXI_awready,
    S_AXI_awsize,
    S_AXI_awvalid,
    S_AXI_bid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rid,
    S_AXI_rlast,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wlast,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid,
    S_AXI_LITE_araddr,
    S_AXI_LITE_arprot,
    S_AXI_LITE_arready,
    S_AXI_LITE_arvalid,
    S_AXI_LITE_awaddr,
    S_AXI_LITE_awprot,
    S_AXI_LITE_awready,
    S_AXI_LITE_awvalid,
    S_AXI_LITE_bready,
    S_AXI_LITE_bresp,
    S_AXI_LITE_bvalid,
    S_AXI_LITE_rdata,
    S_AXI_LITE_rready,
    S_AXI_LITE_rresp,
    S_AXI_LITE_rvalid,
    S_AXI_LITE_wdata,
    S_AXI_LITE_wready,
    S_AXI_LITE_wstrb,
    S_AXI_LITE_wvalid,

    C0_DDR4_act_n,
    C0_DDR4_adr,
    C0_DDR4_ba,
    C0_DDR4_bg,
    C0_DDR4_ck_c,
    C0_DDR4_cke,
    C0_DDR4_cs_n,
    C0_DDR4_dm_n,
    C0_DDR4_dq,
    C0_DDR4_dqs_c,
    C0_DDR4_odt,
    C0_DDR4_reset_n,
    C0_SYS_CLK_clk_n,
    C0_SYS_CLK_clk_p,
    C0_DDR4_ck_t,
    C0_DDR4_dqs_t,

    C1_DDR4_act_n,
    C1_DDR4_adr,
    C1_DDR4_ba,
    C1_DDR4_bg,
    C1_DDR4_ck_c,
    C1_DDR4_cke,
    C1_DDR4_cs_n,
    C1_DDR4_dm_n,
    C1_DDR4_dq,
    C1_DDR4_dqs_c,
    C1_DDR4_odt,
    C1_DDR4_reset_n,
    C1_SYS_CLK_clk_n,
    C1_SYS_CLK_clk_p,
    C1_DDR4_ck_t,
    C1_DDR4_dqs_t,

    C2_DDR4_act_n,
    C2_DDR4_adr,
    C2_DDR4_ba,
    C2_DDR4_bg,
    C2_DDR4_ck_c,
    C2_DDR4_cke,
    C2_DDR4_cs_n,
    C2_DDR4_dm_n,
    C2_DDR4_dq,
    C2_DDR4_dqs_c,
    C2_DDR4_odt,
    C2_DDR4_reset_n,
    C2_SYS_CLK_clk_n,
    C2_SYS_CLK_clk_p,
    C2_DDR4_ck_t,
    C2_DDR4_dqs_t,

    C3_DDR4_act_n,
    C3_DDR4_adr,
    C3_DDR4_ba,
    C3_DDR4_bg,
    C3_DDR4_ck_c,
    C3_DDR4_cke,
    C3_DDR4_cs_n,
    C3_DDR4_dm_n,
    C3_DDR4_dq,
    C3_DDR4_dqs_c,
    C3_DDR4_odt,
    C3_DDR4_reset_n,
    C3_SYS_CLK_clk_n,
    C3_SYS_CLK_clk_p,
    C3_DDR4_ck_t,
    C3_DDR4_dqs_t,

    s_axi_aclk,
    pe_clk,
    i_soft_rst_n,
    s_axi_aresetn,
    sys_reset,
    usr_irq_ack,
    usr_irq_req,
  );
  input [63:0]S_AXI_araddr;
  input [1:0]S_AXI_arburst;
  input [3:0]S_AXI_arcache;
  input [3:0]S_AXI_arid;
  input [7:0]S_AXI_arlen;
  input [0:0]S_AXI_arlock;
  input [2:0]S_AXI_arprot;
  input [3:0]S_AXI_arqos;
  input [3:0]S_AXI_arregion;
  output [0:0]S_AXI_arready;
  input [2:0]S_AXI_arsize;
  input [0:0]S_AXI_arvalid;
  input [63:0]S_AXI_awaddr;
  input [1:0]S_AXI_awburst;
  input [3:0]S_AXI_awcache;
  input [3:0]S_AXI_awid;
  input [7:0]S_AXI_awlen;
  input [0:0]S_AXI_awlock;
  input [2:0]S_AXI_awprot;
  input [3:0]S_AXI_awqos;
  input [3:0]S_AXI_awregion;
  output [0:0]S_AXI_awready;
  input [2:0]S_AXI_awsize;
  input [0:0]S_AXI_awvalid;
  output [3:0]S_AXI_bid;
  input [0:0]S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output [0:0]S_AXI_bvalid;
  output [255:0]S_AXI_rdata;
  output [3:0]S_AXI_rid;
  output [0:0]S_AXI_rlast;
  input [0:0]S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output [0:0]S_AXI_rvalid;
  input [255:0]S_AXI_wdata;
  input [0:0]S_AXI_wlast;
  output [0:0]S_AXI_wready;
  input [31:0]S_AXI_wstrb;
  input [0:0]S_AXI_wvalid;
  input [15:0]S_AXI_LITE_araddr;
  input [2:0]S_AXI_LITE_arprot;
  output S_AXI_LITE_arready;
  input S_AXI_LITE_arvalid;
  input [15:0]S_AXI_LITE_awaddr;
  input [2:0]S_AXI_LITE_awprot;
  output S_AXI_LITE_awready;
  input S_AXI_LITE_awvalid;
  input S_AXI_LITE_bready;
  output [1:0]S_AXI_LITE_bresp;
  output S_AXI_LITE_bvalid;
  output [31:0]S_AXI_LITE_rdata;
  input S_AXI_LITE_rready;
  output [1:0]S_AXI_LITE_rresp;
  output S_AXI_LITE_rvalid;
  input [31:0]S_AXI_LITE_wdata;
  output S_AXI_LITE_wready;
  input [3:0]S_AXI_LITE_wstrb;
  input S_AXI_LITE_wvalid;

  output C0_DDR4_act_n;
  output [16:0]C0_DDR4_adr;
  output [1:0]C0_DDR4_ba;
  output [0:0]C0_DDR4_bg;
  output [0:0]C0_DDR4_ck_c;
  output [0:0]C0_DDR4_cke;
  output [0:0]C0_DDR4_cs_n;
  inout [8:0]C0_DDR4_dm_n;
  inout [71:0]C0_DDR4_dq;
  inout [8:0]C0_DDR4_dqs_c;
  output [0:0]C0_DDR4_odt;
  output C0_DDR4_reset_n;
  input C0_SYS_CLK_clk_n;
  input C0_SYS_CLK_clk_p;
  output [0:0]C0_DDR4_ck_t;
  inout [8:0]C0_DDR4_dqs_t;

  output C1_DDR4_act_n;
  output [16:0]C1_DDR4_adr;
  output [1:0]C1_DDR4_ba;
  output [0:0]C1_DDR4_bg;
  output [0:0]C1_DDR4_ck_c;
  output [0:0]C1_DDR4_cke;
  output [0:0]C1_DDR4_cs_n;
  inout [8:0]C1_DDR4_dm_n;
  inout [71:0]C1_DDR4_dq;
  inout [8:0]C1_DDR4_dqs_c;
  output [0:0]C1_DDR4_odt;
  output C1_DDR4_reset_n;
  input C1_SYS_CLK_clk_n;
  input C1_SYS_CLK_clk_p;
  output [0:0]C1_DDR4_ck_t;
  inout [8:0]C1_DDR4_dqs_t;

  output C2_DDR4_act_n;
  output [16:0]C2_DDR4_adr;
  output [1:0]C2_DDR4_ba;
  output [0:0]C2_DDR4_bg;
  output [0:0]C2_DDR4_ck_c;
  output [0:0]C2_DDR4_cke;
  output [0:0]C2_DDR4_cs_n;
  inout [8:0]C2_DDR4_dm_n;
  inout [71:0]C2_DDR4_dq;
  inout [8:0]C2_DDR4_dqs_c;
  output [0:0]C2_DDR4_odt;
  output C2_DDR4_reset_n;
  input C2_SYS_CLK_clk_n;
  input C2_SYS_CLK_clk_p;
  output [0:0]C2_DDR4_ck_t;
  inout [8:0]C2_DDR4_dqs_t;

  output C3_DDR4_act_n;
  output [16:0]C3_DDR4_adr;
  output [1:0]C3_DDR4_ba;
  output [0:0]C3_DDR4_bg;
  output [0:0]C3_DDR4_ck_c;
  output [0:0]C3_DDR4_cke;
  output [0:0]C3_DDR4_cs_n;
  inout [8:0]C3_DDR4_dm_n;
  inout [71:0]C3_DDR4_dq;
  inout [8:0]C3_DDR4_dqs_c;
  output [0:0]C3_DDR4_odt;
  output C3_DDR4_reset_n;
  input C3_SYS_CLK_clk_n;
  input C3_SYS_CLK_clk_p;
  output [0:0]C3_DDR4_ck_t;
  inout [8:0]C3_DDR4_dqs_t;

  input s_axi_aclk;
  input s_axi_aresetn;
  input pe_clk;
  input i_soft_rst_n;
  input sys_reset;
  input [15:0]usr_irq_ack;
  output [15:0]usr_irq_req;

  wire [63:0]S_AXI_araddr;
  wire [1:0]S_AXI_arburst;
  wire [3:0]S_AXI_arcache;
  wire [3:0]S_AXI_arid;
  wire [7:0]S_AXI_arlen;
  wire [0:0]S_AXI_arlock;
  wire [2:0]S_AXI_arprot;
  wire [3:0]S_AXI_arqos;
  wire [3:0]S_AXI_arregion;
  wire [0:0]S_AXI_arready;
  wire [2:0]S_AXI_arsize;
  wire [0:0]S_AXI_arvalid;
  wire [63:0]S_AXI_awaddr;
  wire [1:0]S_AXI_awburst;
  wire [3:0]S_AXI_awcache;
  wire [3:0]S_AXI_awid;
  wire [7:0]S_AXI_awlen;
  wire [0:0]S_AXI_awlock;
  wire [2:0]S_AXI_awprot;
  wire [3:0]S_AXI_awqos;
  wire [3:0]S_AXI_awregion;
  wire [0:0]S_AXI_awready;
  wire [2:0]S_AXI_awsize;
  wire [0:0]S_AXI_awvalid;
  wire [3:0]S_AXI_bid;
  wire [0:0]S_AXI_bready;
  wire [1:0]S_AXI_bresp;
  wire [0:0]S_AXI_bvalid;
  wire [255:0]S_AXI_rdata;
  wire [3:0]S_AXI_rid;
  wire [0:0]S_AXI_rlast;
  wire [0:0]S_AXI_rready;
  wire [1:0]S_AXI_rresp;
  wire [0:0]S_AXI_rvalid;
  wire [255:0]S_AXI_wdata;
  wire [0:0]S_AXI_wlast;
  wire [0:0]S_AXI_wready;
  wire [31:0]S_AXI_wstrb;
  wire [0:0]S_AXI_wvalid;
  wire [15:0]S_AXI_LITE_araddr;
  wire [2:0]S_AXI_LITE_arprot;
  wire S_AXI_LITE_arready;
  wire S_AXI_LITE_arvalid;
  wire [15:0]S_AXI_LITE_awaddr;
  wire [2:0]S_AXI_LITE_awprot;
  wire S_AXI_LITE_awready;
  wire S_AXI_LITE_awvalid;
  wire S_AXI_LITE_bready;
  wire [1:0]S_AXI_LITE_bresp;
  wire S_AXI_LITE_bvalid;
  wire [31:0]S_AXI_LITE_rdata;
  wire S_AXI_LITE_rready;
  wire [1:0]S_AXI_LITE_rresp;
  wire S_AXI_LITE_rvalid;
  wire [31:0]S_AXI_LITE_wdata;
  wire S_AXI_LITE_wready;
  wire [3:0]S_AXI_LITE_wstrb;
  wire S_AXI_LITE_wvalid;

  wire s_axi_aclk;
  wire s_axi_aresetn;
  wire pe_clk;
  wire i_soft_rst_n;
  wire sys_reset;
  wire [15:0]usr_irq_ack;
  wire [15:0]usr_irq_req;

  wire [31:0]C0_DDR4_S_AXI_CTRL_araddr;
  wire C0_DDR4_S_AXI_CTRL_arready;
  wire C0_DDR4_S_AXI_CTRL_arvalid;
  wire [31:0]C0_DDR4_S_AXI_CTRL_awaddr;
  wire C0_DDR4_S_AXI_CTRL_awready;
  wire C0_DDR4_S_AXI_CTRL_awvalid;
  wire C0_DDR4_S_AXI_CTRL_bready;
  wire [1:0]C0_DDR4_S_AXI_CTRL_bresp;
  wire C0_DDR4_S_AXI_CTRL_bvalid;
  wire [31:0]C0_DDR4_S_AXI_CTRL_rdata;
  wire C0_DDR4_S_AXI_CTRL_rready;
  wire [1:0]C0_DDR4_S_AXI_CTRL_rresp;
  wire C0_DDR4_S_AXI_CTRL_rvalid;
  wire [31:0]C0_DDR4_S_AXI_CTRL_wdata;
  wire C0_DDR4_S_AXI_CTRL_wready;
  wire C0_DDR4_S_AXI_CTRL_wvalid;
  wire [30:0]C0_DDR4_S_AXI_araddr;
  wire [1:0]C0_DDR4_S_AXI_arburst;
  wire [3:0]C0_DDR4_S_AXI_arcache;
  wire [0:0]C0_DDR4_S_AXI_arid;
  wire [7:0]C0_DDR4_S_AXI_arlen;
  wire [0:0]C0_DDR4_S_AXI_arlock;
  wire [2:0]C0_DDR4_S_AXI_arprot;
  wire [3:0]C0_DDR4_S_AXI_arqos;
  wire C0_DDR4_S_AXI_arready;
  wire [2:0]C0_DDR4_S_AXI_arsize;
  wire C0_DDR4_S_AXI_arvalid;
  wire [30:0]C0_DDR4_S_AXI_awaddr;
  wire [1:0]C0_DDR4_S_AXI_awburst;
  wire [3:0]C0_DDR4_S_AXI_awcache;
  wire [0:0]C0_DDR4_S_AXI_awid;
  wire [7:0]C0_DDR4_S_AXI_awlen;
  wire [0:0]C0_DDR4_S_AXI_awlock;
  wire [2:0]C0_DDR4_S_AXI_awprot;
  wire [3:0]C0_DDR4_S_AXI_awqos;
  wire C0_DDR4_S_AXI_awready;
  wire [2:0]C0_DDR4_S_AXI_awsize;
  wire C0_DDR4_S_AXI_awvalid;
  wire [0:0]C0_DDR4_S_AXI_bid;
  wire C0_DDR4_S_AXI_bready;
  wire [1:0]C0_DDR4_S_AXI_bresp;
  wire C0_DDR4_S_AXI_bvalid;
  wire [511:0]C0_DDR4_S_AXI_rdata;
  wire [0:0]C0_DDR4_S_AXI_rid;
  wire C0_DDR4_S_AXI_rlast;
  wire C0_DDR4_S_AXI_rready;
  wire [1:0]C0_DDR4_S_AXI_rresp;
  wire C0_DDR4_S_AXI_rvalid;
  wire [511:0]C0_DDR4_S_AXI_wdata;
  wire C0_DDR4_S_AXI_wlast;
  wire C0_DDR4_S_AXI_wready;
  wire [63:0]C0_DDR4_S_AXI_wstrb;
  wire C0_DDR4_S_AXI_wvalid;
  wire C0_DDR4_act_n;
  wire [16:0]C0_DDR4_adr;
  wire [1:0]C0_DDR4_ba;
  wire [0:0]C0_DDR4_bg;
  wire [0:0]C0_DDR4_ck_c;
  wire [0:0]C0_DDR4_cke;
  wire [0:0]C0_DDR4_cs_n;
  wire [8:0]C0_DDR4_dm_n;
  wire [71:0]C0_DDR4_dq;
  wire [8:0]C0_DDR4_dqs_c;
  wire [0:0]C0_DDR4_odt;
  wire C0_DDR4_reset_n;
  wire C0_SYS_CLK_clk_n;
  wire C0_SYS_CLK_clk_p;
  wire [31:0]C1_DDR4_S_AXI_CTRL_araddr;
  wire C1_DDR4_S_AXI_CTRL_arready;
  wire C1_DDR4_S_AXI_CTRL_arvalid;
  wire [31:0]C1_DDR4_S_AXI_CTRL_awaddr;
  wire C1_DDR4_S_AXI_CTRL_awready;
  wire C1_DDR4_S_AXI_CTRL_awvalid;
  wire C1_DDR4_S_AXI_CTRL_bready;
  wire [1:0]C1_DDR4_S_AXI_CTRL_bresp;
  wire C1_DDR4_S_AXI_CTRL_bvalid;
  wire [31:0]C1_DDR4_S_AXI_CTRL_rdata;
  wire C1_DDR4_S_AXI_CTRL_rready;
  wire [1:0]C1_DDR4_S_AXI_CTRL_rresp;
  wire C1_DDR4_S_AXI_CTRL_rvalid;
  wire [31:0]C1_DDR4_S_AXI_CTRL_wdata;
  wire C1_DDR4_S_AXI_CTRL_wready;
  wire C1_DDR4_S_AXI_CTRL_wvalid;
  wire [30:0]C1_DDR4_S_AXI_araddr;
  wire [1:0]C1_DDR4_S_AXI_arburst;
  wire [3:0]C1_DDR4_S_AXI_arcache;
  wire [0:0]C1_DDR4_S_AXI_arid;
  wire [7:0]C1_DDR4_S_AXI_arlen;
  wire [0:0]C1_DDR4_S_AXI_arlock;
  wire [2:0]C1_DDR4_S_AXI_arprot;
  wire [3:0]C1_DDR4_S_AXI_arqos;
  wire C1_DDR4_S_AXI_arready;
  wire [2:0]C1_DDR4_S_AXI_arsize;
  wire C1_DDR4_S_AXI_arvalid;
  wire [30:0]C1_DDR4_S_AXI_awaddr;
  wire [1:0]C1_DDR4_S_AXI_awburst;
  wire [3:0]C1_DDR4_S_AXI_awcache;
  wire [0:0]C1_DDR4_S_AXI_awid;
  wire [7:0]C1_DDR4_S_AXI_awlen;
  wire [0:0]C1_DDR4_S_AXI_awlock;
  wire [2:0]C1_DDR4_S_AXI_awprot;
  wire [3:0]C1_DDR4_S_AXI_awqos;
  wire C1_DDR4_S_AXI_awready;
  wire [2:0]C1_DDR4_S_AXI_awsize;
  wire C1_DDR4_S_AXI_awvalid;
  wire [0:0]C1_DDR4_S_AXI_bid;
  wire C1_DDR4_S_AXI_bready;
  wire [1:0]C1_DDR4_S_AXI_bresp;
  wire C1_DDR4_S_AXI_bvalid;
  wire [511:0]C1_DDR4_S_AXI_rdata;
  wire [0:0]C1_DDR4_S_AXI_rid;
  wire C1_DDR4_S_AXI_rlast;
  wire C1_DDR4_S_AXI_rready;
  wire [1:0]C1_DDR4_S_AXI_rresp;
  wire C1_DDR4_S_AXI_rvalid;
  wire [511:0]C1_DDR4_S_AXI_wdata;
  wire C1_DDR4_S_AXI_wlast;
  wire C1_DDR4_S_AXI_wready;
  wire [63:0]C1_DDR4_S_AXI_wstrb;
  wire C1_DDR4_S_AXI_wvalid;
  wire C1_DDR4_act_n;
  wire [16:0]C1_DDR4_adr;
  wire [1:0]C1_DDR4_ba;
  wire [0:0]C1_DDR4_bg;
  wire [0:0]C1_DDR4_ck_c;
  wire [0:0]C1_DDR4_cke;
  wire [0:0]C1_DDR4_cs_n;
  wire [8:0]C1_DDR4_dm_n;
  wire [71:0]C1_DDR4_dq;
  wire [8:0]C1_DDR4_dqs_c;
  wire [0:0]C1_DDR4_odt;
  wire C1_DDR4_reset_n;
  wire C1_SYS_CLK_clk_n;
  wire C1_SYS_CLK_clk_p;
  wire [31:0]C2_DDR4_S_AXI_CTRL_araddr;
  wire C2_DDR4_S_AXI_CTRL_arready;
  wire C2_DDR4_S_AXI_CTRL_arvalid;
  wire [31:0]C2_DDR4_S_AXI_CTRL_awaddr;
  wire C2_DDR4_S_AXI_CTRL_awready;
  wire C2_DDR4_S_AXI_CTRL_awvalid;
  wire C2_DDR4_S_AXI_CTRL_bready;
  wire [1:0]C2_DDR4_S_AXI_CTRL_bresp;
  wire C2_DDR4_S_AXI_CTRL_bvalid;
  wire [31:0]C2_DDR4_S_AXI_CTRL_rdata;
  wire C2_DDR4_S_AXI_CTRL_rready;
  wire [1:0]C2_DDR4_S_AXI_CTRL_rresp;
  wire C2_DDR4_S_AXI_CTRL_rvalid;
  wire [31:0]C2_DDR4_S_AXI_CTRL_wdata;
  wire C2_DDR4_S_AXI_CTRL_wready;
  wire C2_DDR4_S_AXI_CTRL_wvalid;
  wire [30:0]C2_DDR4_S_AXI_araddr;
  wire [1:0]C2_DDR4_S_AXI_arburst;
  wire [3:0]C2_DDR4_S_AXI_arcache;
  wire [0:0]C2_DDR4_S_AXI_arid;
  wire [7:0]C2_DDR4_S_AXI_arlen;
  wire [0:0]C2_DDR4_S_AXI_arlock;
  wire [2:0]C2_DDR4_S_AXI_arprot;
  wire [3:0]C2_DDR4_S_AXI_arqos;
  wire C2_DDR4_S_AXI_arready;
  wire [2:0]C2_DDR4_S_AXI_arsize;
  wire C2_DDR4_S_AXI_arvalid;
  wire [30:0]C2_DDR4_S_AXI_awaddr;
  wire [1:0]C2_DDR4_S_AXI_awburst;
  wire [3:0]C2_DDR4_S_AXI_awcache;
  wire [0:0]C2_DDR4_S_AXI_awid;
  wire [7:0]C2_DDR4_S_AXI_awlen;
  wire [0:0]C2_DDR4_S_AXI_awlock;
  wire [2:0]C2_DDR4_S_AXI_awprot;
  wire [3:0]C2_DDR4_S_AXI_awqos;
  wire C2_DDR4_S_AXI_awready;
  wire [2:0]C2_DDR4_S_AXI_awsize;
  wire C2_DDR4_S_AXI_awvalid;
  wire [0:0]C2_DDR4_S_AXI_bid;
  wire C2_DDR4_S_AXI_bready;
  wire [1:0]C2_DDR4_S_AXI_bresp;
  wire C2_DDR4_S_AXI_bvalid;
  wire [511:0]C2_DDR4_S_AXI_rdata;
  wire [0:0]C2_DDR4_S_AXI_rid;
  wire C2_DDR4_S_AXI_rlast;
  wire C2_DDR4_S_AXI_rready;
  wire [1:0]C2_DDR4_S_AXI_rresp;
  wire C2_DDR4_S_AXI_rvalid;
  wire [511:0]C2_DDR4_S_AXI_wdata;
  wire C2_DDR4_S_AXI_wlast;
  wire C2_DDR4_S_AXI_wready;
  wire [63:0]C2_DDR4_S_AXI_wstrb;
  wire C2_DDR4_S_AXI_wvalid;
  wire C2_DDR4_act_n;
  wire [16:0]C2_DDR4_adr;
  wire [1:0]C2_DDR4_ba;
  wire [0:0]C2_DDR4_bg;
  wire [0:0]C2_DDR4_ck_c;
  wire [0:0]C2_DDR4_cke;
  wire [0:0]C2_DDR4_cs_n;
  wire [8:0]C2_DDR4_dm_n;
  wire [71:0]C2_DDR4_dq;
  wire [8:0]C2_DDR4_dqs_c;
  wire [0:0]C2_DDR4_odt;
  wire C2_DDR4_reset_n;
  wire C2_SYS_CLK_clk_n;
  wire C2_SYS_CLK_clk_p;
  wire [31:0]C3_DDR4_S_AXI_CTRL_araddr;
  wire C3_DDR4_S_AXI_CTRL_arready;
  wire C3_DDR4_S_AXI_CTRL_arvalid;
  wire [31:0]C3_DDR4_S_AXI_CTRL_awaddr;
  wire C3_DDR4_S_AXI_CTRL_awready;
  wire C3_DDR4_S_AXI_CTRL_awvalid;
  wire C3_DDR4_S_AXI_CTRL_bready;
  wire [1:0]C3_DDR4_S_AXI_CTRL_bresp;
  wire C3_DDR4_S_AXI_CTRL_bvalid;
  wire [31:0]C3_DDR4_S_AXI_CTRL_rdata;
  wire C3_DDR4_S_AXI_CTRL_rready;
  wire [1:0]C3_DDR4_S_AXI_CTRL_rresp;
  wire C3_DDR4_S_AXI_CTRL_rvalid;
  wire [31:0]C3_DDR4_S_AXI_CTRL_wdata;
  wire C3_DDR4_S_AXI_CTRL_wready;
  wire C3_DDR4_S_AXI_CTRL_wvalid;
  wire [30:0]C3_DDR4_S_AXI_araddr;
  wire [1:0]C3_DDR4_S_AXI_arburst;
  wire [3:0]C3_DDR4_S_AXI_arcache;
  wire [0:0]C3_DDR4_S_AXI_arid;
  wire [7:0]C3_DDR4_S_AXI_arlen;
  wire [0:0]C3_DDR4_S_AXI_arlock;
  wire [2:0]C3_DDR4_S_AXI_arprot;
  wire [3:0]C3_DDR4_S_AXI_arqos;
  wire C3_DDR4_S_AXI_arready;
  wire [2:0]C3_DDR4_S_AXI_arsize;
  wire C3_DDR4_S_AXI_arvalid;
  wire [30:0]C3_DDR4_S_AXI_awaddr;
  wire [1:0]C3_DDR4_S_AXI_awburst;
  wire [3:0]C3_DDR4_S_AXI_awcache;
  wire [0:0]C3_DDR4_S_AXI_awid;
  wire [7:0]C3_DDR4_S_AXI_awlen;
  wire [0:0]C3_DDR4_S_AXI_awlock;
  wire [2:0]C3_DDR4_S_AXI_awprot;
  wire [3:0]C3_DDR4_S_AXI_awqos;
  wire C3_DDR4_S_AXI_awready;
  wire [2:0]C3_DDR4_S_AXI_awsize;
  wire C3_DDR4_S_AXI_awvalid;
  wire [0:0]C3_DDR4_S_AXI_bid;
  wire C3_DDR4_S_AXI_bready;
  wire [1:0]C3_DDR4_S_AXI_bresp;
  wire C3_DDR4_S_AXI_bvalid;
  wire [511:0]C3_DDR4_S_AXI_rdata;
  wire [0:0]C3_DDR4_S_AXI_rid;
  wire C3_DDR4_S_AXI_rlast;
  wire C3_DDR4_S_AXI_rready;
  wire [1:0]C3_DDR4_S_AXI_rresp;
  wire C3_DDR4_S_AXI_rvalid;
  wire [511:0]C3_DDR4_S_AXI_wdata;
  wire C3_DDR4_S_AXI_wlast;
  wire C3_DDR4_S_AXI_wready;
  wire [63:0]C3_DDR4_S_AXI_wstrb;
  wire C3_DDR4_S_AXI_wvalid;
  wire C3_DDR4_act_n;
  wire [16:0]C3_DDR4_adr;
  wire [1:0]C3_DDR4_ba;
  wire [0:0]C3_DDR4_bg;
  wire [0:0]C3_DDR4_ck_c;
  wire [0:0]C3_DDR4_cke;
  wire [0:0]C3_DDR4_cs_n;
  wire [8:0]C3_DDR4_dm_n;
  wire [71:0]C3_DDR4_dq;
  wire [8:0]C3_DDR4_dqs_c;
  wire [0:0]C3_DDR4_odt;
  wire C3_DDR4_reset_n;
  wire C3_SYS_CLK_clk_n;
  wire C3_SYS_CLK_clk_p;
  wire [0:0]C0_DDR4_ck_t;
  wire [8:0]C0_DDR4_dqs_t;
  wire c0_ddr4_ui_clk;
  wire c0_ddr4_ui_clk_sync_rst;
  wire c0_ddr4_interrupt;
  wire [0:0]C1_DDR4_ck_t;
  wire [8:0]C1_DDR4_dqs_t;
  wire c1_ddr4_ui_clk;
  wire c1_ddr4_ui_clk_sync_rst;
  wire c1_ddr4_interrupt;
  wire [0:0]C2_DDR4_ck_t;
  wire [8:0]C2_DDR4_dqs_t;
  wire c2_ddr4_ui_clk;
  wire c2_ddr4_ui_clk_sync_rst;
  wire c2_ddr4_interrupt;
  wire [0:0]C3_DDR4_ck_t;
  wire [8:0]C3_DDR4_dqs_t;
  wire c3_ddr4_ui_clk;
  wire c3_ddr4_ui_clk_sync_rst;
  wire c3_ddr4_interrupt;

  // Debug core signals.
      wire drck;
      wire shift;
      wire tdi;
      wire update;
      wire sel;
      wire tdo;
      wire tms;
      wire tck;
      wire runtest;
      wire reset;
      wire capture;
      wire [31 : 0] bscanid;



  rp_bd rp_bd_i
       (.S_AXI_araddr(S_AXI_araddr),
        .S_AXI_arburst(S_AXI_arburst),
        .S_AXI_arcache(S_AXI_arcache),
        .S_AXI_arid(S_AXI_arid),
        .S_AXI_arlen(S_AXI_arlen),
        .S_AXI_arlock(S_AXI_arlock),
        .S_AXI_arprot(S_AXI_arprot),
        .S_AXI_arqos(S_AXI_arqos),
        .S_AXI_arregion(S_AXI_arregion),
        .S_AXI_arready(S_AXI_arready),
        .S_AXI_arsize(S_AXI_arsize),
        .S_AXI_arvalid(S_AXI_arvalid),
        .S_AXI_awaddr(S_AXI_awaddr),
        .S_AXI_awburst(S_AXI_awburst),
        .S_AXI_awcache(S_AXI_awcache),
        .S_AXI_awid(S_AXI_awid),
        .S_AXI_awlen(S_AXI_awlen),
        .S_AXI_awlock(S_AXI_awlock),
        .S_AXI_awprot(S_AXI_awprot),
        .S_AXI_awqos(S_AXI_awqos),
        .S_AXI_awregion(S_AXI_awregion),
        .S_AXI_awready(S_AXI_awready),
        .S_AXI_awsize(S_AXI_awsize),
        .S_AXI_awvalid(S_AXI_awvalid),
        .S_AXI_bid(S_AXI_bid),
        .S_AXI_bready(S_AXI_bready),
        .S_AXI_bresp(S_AXI_bresp),
        .S_AXI_bvalid(S_AXI_bvalid),
        .S_AXI_rdata(S_AXI_rdata),
        .S_AXI_rid(S_AXI_rid),
        .S_AXI_rlast(S_AXI_rlast),
        .S_AXI_rready(S_AXI_rready),
        .S_AXI_rresp(S_AXI_rresp),
        .S_AXI_rvalid(S_AXI_rvalid),
        .S_AXI_wdata(S_AXI_wdata),
        .S_AXI_wlast(S_AXI_wlast),
        .S_AXI_wready(S_AXI_wready),
        .S_AXI_wstrb(S_AXI_wstrb),
        .S_AXI_wvalid(S_AXI_wvalid),
        .S_AXI_LITE_araddr(S_AXI_LITE_araddr),
        .S_AXI_LITE_arprot(S_AXI_LITE_arprot),
        .S_AXI_LITE_arready(S_AXI_LITE_arready),
        .S_AXI_LITE_arvalid(S_AXI_LITE_arvalid),
        .S_AXI_LITE_awaddr(S_AXI_LITE_awaddr),
        .S_AXI_LITE_awprot(S_AXI_LITE_awprot),
        .S_AXI_LITE_awready(S_AXI_LITE_awready),
        .S_AXI_LITE_awvalid(S_AXI_LITE_awvalid),
        .S_AXI_LITE_bready(S_AXI_LITE_bready),
        .S_AXI_LITE_bresp(S_AXI_LITE_bresp),
        .S_AXI_LITE_bvalid(S_AXI_LITE_bvalid),
        .S_AXI_LITE_rdata(S_AXI_LITE_rdata),
        .S_AXI_LITE_rready(S_AXI_LITE_rready),
        .S_AXI_LITE_rresp(S_AXI_LITE_rresp),
        .S_AXI_LITE_rvalid(S_AXI_LITE_rvalid),
        .S_AXI_LITE_wdata(S_AXI_LITE_wdata),
        .S_AXI_LITE_wready(S_AXI_LITE_wready),
        .S_AXI_LITE_wstrb(S_AXI_LITE_wstrb),
        .S_AXI_LITE_wvalid(S_AXI_LITE_wvalid),

        `ifdef USE_DDR4_C0
        .C0_DDR4_M_AXI_araddr             (C0_DDR4_S_AXI_araddr),
        .C0_DDR4_M_AXI_arburst            (C0_DDR4_S_AXI_arburst),
        .C0_DDR4_M_AXI_arcache            (C0_DDR4_S_AXI_arcache),
        .C0_DDR4_M_AXI_arid               (C0_DDR4_S_AXI_arid),
        .C0_DDR4_M_AXI_arlen              (C0_DDR4_S_AXI_arlen),
        .C0_DDR4_M_AXI_arlock             (C0_DDR4_S_AXI_arlock),
        .C0_DDR4_M_AXI_arprot             (C0_DDR4_S_AXI_arprot),
        .C0_DDR4_M_AXI_arqos              (C0_DDR4_S_AXI_arqos),
        .C0_DDR4_M_AXI_arready            (C0_DDR4_S_AXI_arready),
        .C0_DDR4_M_AXI_arregion           (C0_DDR4_S_AXI_arregion),
        .C0_DDR4_M_AXI_arsize             (C0_DDR4_S_AXI_arsize),
        .C0_DDR4_M_AXI_arvalid            (C0_DDR4_S_AXI_arvalid),
        .C0_DDR4_M_AXI_awaddr             (C0_DDR4_S_AXI_awaddr),
        .C0_DDR4_M_AXI_awburst            (C0_DDR4_S_AXI_awburst),
        .C0_DDR4_M_AXI_awcache            (C0_DDR4_S_AXI_awcache),
        .C0_DDR4_M_AXI_awid               (C0_DDR4_S_AXI_awid),
        .C0_DDR4_M_AXI_awlen              (C0_DDR4_S_AXI_awlen),
        .C0_DDR4_M_AXI_awlock             (C0_DDR4_S_AXI_awlock),
        .C0_DDR4_M_AXI_awprot             (C0_DDR4_S_AXI_awprot),
        .C0_DDR4_M_AXI_awqos              (C0_DDR4_S_AXI_awqos),
        .C0_DDR4_M_AXI_awready            (C0_DDR4_S_AXI_awready),
        .C0_DDR4_M_AXI_awregion           (),
        .C0_DDR4_M_AXI_awsize             (C0_DDR4_S_AXI_awsize),
        .C0_DDR4_M_AXI_awvalid            (C0_DDR4_S_AXI_awvalid),
        .C0_DDR4_M_AXI_bid                (C0_DDR4_S_AXI_bid),
        .C0_DDR4_M_AXI_bready             (C0_DDR4_S_AXI_bready),
        .C0_DDR4_M_AXI_bresp              (C0_DDR4_S_AXI_bresp),
        .C0_DDR4_M_AXI_bvalid             (C0_DDR4_S_AXI_bvalid),
        .C0_DDR4_M_AXI_rdata              (C0_DDR4_S_AXI_rdata),
        .C0_DDR4_M_AXI_rid                (C0_DDR4_S_AXI_rid),
        .C0_DDR4_M_AXI_rlast              (C0_DDR4_S_AXI_rlast),
        .C0_DDR4_M_AXI_rready             (C0_DDR4_S_AXI_rready),
        .C0_DDR4_M_AXI_rresp              (C0_DDR4_S_AXI_rresp),
        .C0_DDR4_M_AXI_rvalid             (C0_DDR4_S_AXI_rvalid),
        .C0_DDR4_M_AXI_wdata              (C0_DDR4_S_AXI_wdata),
        .C0_DDR4_M_AXI_wlast              (C0_DDR4_S_AXI_wlast),
        .C0_DDR4_M_AXI_wready             (C0_DDR4_S_AXI_wready),
        .C0_DDR4_M_AXI_wstrb              (C0_DDR4_S_AXI_wstrb),
        .C0_DDR4_M_AXI_wvalid             (C0_DDR4_S_AXI_wvalid),
        .c0_ddr4_ui_clk                   (c0_ddr4_ui_clk),
        .c0_ddr4_ui_clk_sync_rst          (c0_ddr4_ui_clk_sync_rst),
        `endif

        `ifdef USE_DDR4_C1
        .C1_DDR4_M_AXI_araddr             (C1_DDR4_S_AXI_araddr),
        .C1_DDR4_M_AXI_arburst            (C1_DDR4_S_AXI_arburst),
        .C1_DDR4_M_AXI_arcache            (C1_DDR4_S_AXI_arcache),
        .C1_DDR4_M_AXI_arid               (C1_DDR4_S_AXI_arid),
        .C1_DDR4_M_AXI_arlen              (C1_DDR4_S_AXI_arlen),
        .C1_DDR4_M_AXI_arlock             (C1_DDR4_S_AXI_arlock),
        .C1_DDR4_M_AXI_arprot             (C1_DDR4_S_AXI_arprot),
        .C1_DDR4_M_AXI_arqos              (C1_DDR4_S_AXI_arqos),
        .C1_DDR4_M_AXI_arready            (C1_DDR4_S_AXI_arready),
        .C1_DDR4_M_AXI_arregion           (C1_DDR4_S_AXI_arregion),
        .C1_DDR4_M_AXI_arsize             (C1_DDR4_S_AXI_arsize),
        .C1_DDR4_M_AXI_arvalid            (C1_DDR4_S_AXI_arvalid),
        .C1_DDR4_M_AXI_awaddr             (C1_DDR4_S_AXI_awaddr),
        .C1_DDR4_M_AXI_awburst            (C1_DDR4_S_AXI_awburst),
        .C1_DDR4_M_AXI_awcache            (C1_DDR4_S_AXI_awcache),
        .C1_DDR4_M_AXI_awid               (C1_DDR4_S_AXI_awid),
        .C1_DDR4_M_AXI_awlen              (C1_DDR4_S_AXI_awlen),
        .C1_DDR4_M_AXI_awlock             (C1_DDR4_S_AXI_awlock),
        .C1_DDR4_M_AXI_awprot             (C1_DDR4_S_AXI_awprot),
        .C1_DDR4_M_AXI_awqos              (C1_DDR4_S_AXI_awqos),
        .C1_DDR4_M_AXI_awready            (C1_DDR4_S_AXI_awready),
        .C1_DDR4_M_AXI_awregion           (),
        .C1_DDR4_M_AXI_awsize             (C1_DDR4_S_AXI_awsize),
        .C1_DDR4_M_AXI_awvalid            (C1_DDR4_S_AXI_awvalid),
        .C1_DDR4_M_AXI_bid                (C1_DDR4_S_AXI_bid),
        .C1_DDR4_M_AXI_bready             (C1_DDR4_S_AXI_bready),
        .C1_DDR4_M_AXI_bresp              (C1_DDR4_S_AXI_bresp),
        .C1_DDR4_M_AXI_bvalid             (C1_DDR4_S_AXI_bvalid),
        .C1_DDR4_M_AXI_rdata              (C1_DDR4_S_AXI_rdata),
        .C1_DDR4_M_AXI_rid                (C1_DDR4_S_AXI_rid),
        .C1_DDR4_M_AXI_rlast              (C1_DDR4_S_AXI_rlast),
        .C1_DDR4_M_AXI_rready             (C1_DDR4_S_AXI_rready),
        .C1_DDR4_M_AXI_rresp              (C1_DDR4_S_AXI_rresp),
        .C1_DDR4_M_AXI_rvalid             (C1_DDR4_S_AXI_rvalid),
        .C1_DDR4_M_AXI_wdata              (C1_DDR4_S_AXI_wdata),
        .C1_DDR4_M_AXI_wlast              (C1_DDR4_S_AXI_wlast),
        .C1_DDR4_M_AXI_wready             (C1_DDR4_S_AXI_wready),
        .C1_DDR4_M_AXI_wstrb              (C1_DDR4_S_AXI_wstrb),
        .C1_DDR4_M_AXI_wvalid             (C1_DDR4_S_AXI_wvalid),
        .c1_ddr4_ui_clk                   (c1_ddr4_ui_clk),
        .c1_ddr4_ui_clk_sync_rst          (c1_ddr4_ui_clk_sync_rst),
        `endif

        `ifdef USE_DDR4_C2
        .C2_DDR4_M_AXI_araddr             (C2_DDR4_S_AXI_araddr),
        .C2_DDR4_M_AXI_arburst            (C2_DDR4_S_AXI_arburst),
        .C2_DDR4_M_AXI_arcache            (C2_DDR4_S_AXI_arcache),
        .C2_DDR4_M_AXI_arid               (C2_DDR4_S_AXI_arid),
        .C2_DDR4_M_AXI_arlen              (C2_DDR4_S_AXI_arlen),
        .C2_DDR4_M_AXI_arlock             (C2_DDR4_S_AXI_arlock),
        .C2_DDR4_M_AXI_arprot             (C2_DDR4_S_AXI_arprot),
        .C2_DDR4_M_AXI_arqos              (C2_DDR4_S_AXI_arqos),
        .C2_DDR4_M_AXI_arready            (C2_DDR4_S_AXI_arready),
        .C2_DDR4_M_AXI_arregion           (C2_DDR4_S_AXI_arregion),
        .C2_DDR4_M_AXI_arsize             (C2_DDR4_S_AXI_arsize),
        .C2_DDR4_M_AXI_arvalid            (C2_DDR4_S_AXI_arvalid),
        .C2_DDR4_M_AXI_awaddr             (C2_DDR4_S_AXI_awaddr),
        .C2_DDR4_M_AXI_awburst            (C2_DDR4_S_AXI_awburst),
        .C2_DDR4_M_AXI_awcache            (C2_DDR4_S_AXI_awcache),
        .C2_DDR4_M_AXI_awid               (C2_DDR4_S_AXI_awid),
        .C2_DDR4_M_AXI_awlen              (C2_DDR4_S_AXI_awlen),
        .C2_DDR4_M_AXI_awlock             (C2_DDR4_S_AXI_awlock),
        .C2_DDR4_M_AXI_awprot             (C2_DDR4_S_AXI_awprot),
        .C2_DDR4_M_AXI_awqos              (C2_DDR4_S_AXI_awqos),
        .C2_DDR4_M_AXI_awready            (C2_DDR4_S_AXI_awready),
        .C2_DDR4_M_AXI_awregion           (),
        .C2_DDR4_M_AXI_awsize             (C2_DDR4_S_AXI_awsize),
        .C2_DDR4_M_AXI_awvalid            (C2_DDR4_S_AXI_awvalid),
        .C2_DDR4_M_AXI_bid                (C2_DDR4_S_AXI_bid),
        .C2_DDR4_M_AXI_bready             (C2_DDR4_S_AXI_bready),
        .C2_DDR4_M_AXI_bresp              (C2_DDR4_S_AXI_bresp),
        .C2_DDR4_M_AXI_bvalid             (C2_DDR4_S_AXI_bvalid),
        .C2_DDR4_M_AXI_rdata              (C2_DDR4_S_AXI_rdata),
        .C2_DDR4_M_AXI_rid                (C2_DDR4_S_AXI_rid),
        .C2_DDR4_M_AXI_rlast              (C2_DDR4_S_AXI_rlast),
        .C2_DDR4_M_AXI_rready             (C2_DDR4_S_AXI_rready),
        .C2_DDR4_M_AXI_rresp              (C2_DDR4_S_AXI_rresp),
        .C2_DDR4_M_AXI_rvalid             (C2_DDR4_S_AXI_rvalid),
        .C2_DDR4_M_AXI_wdata              (C2_DDR4_S_AXI_wdata),
        .C2_DDR4_M_AXI_wlast              (C2_DDR4_S_AXI_wlast),
        .C2_DDR4_M_AXI_wready             (C2_DDR4_S_AXI_wready),
        .C2_DDR4_M_AXI_wstrb              (C2_DDR4_S_AXI_wstrb),
        .C2_DDR4_M_AXI_wvalid             (C2_DDR4_S_AXI_wvalid),
        .c2_ddr4_ui_clk                   (c2_ddr4_ui_clk),
        .c2_ddr4_ui_clk_sync_rst          (c2_ddr4_ui_clk_sync_rst),
        `endif

        `ifdef USE_DDR4_C3
        .C3_DDR4_M_AXI_araddr             (C3_DDR4_S_AXI_araddr),
        .C3_DDR4_M_AXI_arburst            (C3_DDR4_S_AXI_arburst),
        .C3_DDR4_M_AXI_arcache            (C3_DDR4_S_AXI_arcache),
        .C3_DDR4_M_AXI_arid               (C3_DDR4_S_AXI_arid),
        .C3_DDR4_M_AXI_arlen              (C3_DDR4_S_AXI_arlen),
        .C3_DDR4_M_AXI_arlock             (C3_DDR4_S_AXI_arlock),
        .C3_DDR4_M_AXI_arprot             (C3_DDR4_S_AXI_arprot),
        .C3_DDR4_M_AXI_arqos              (C3_DDR4_S_AXI_arqos),
        .C3_DDR4_M_AXI_arready            (C3_DDR4_S_AXI_arready),
        .C3_DDR4_M_AXI_arregion           (C3_DDR4_S_AXI_arregion),
        .C3_DDR4_M_AXI_arsize             (C3_DDR4_S_AXI_arsize),
        .C3_DDR4_M_AXI_arvalid            (C3_DDR4_S_AXI_arvalid),
        .C3_DDR4_M_AXI_awaddr             (C3_DDR4_S_AXI_awaddr),
        .C3_DDR4_M_AXI_awburst            (C3_DDR4_S_AXI_awburst),
        .C3_DDR4_M_AXI_awcache            (C3_DDR4_S_AXI_awcache),
        .C3_DDR4_M_AXI_awid               (C3_DDR4_S_AXI_awid),
        .C3_DDR4_M_AXI_awlen              (C3_DDR4_S_AXI_awlen),
        .C3_DDR4_M_AXI_awlock             (C3_DDR4_S_AXI_awlock),
        .C3_DDR4_M_AXI_awprot             (C3_DDR4_S_AXI_awprot),
        .C3_DDR4_M_AXI_awqos              (C3_DDR4_S_AXI_awqos),
        .C3_DDR4_M_AXI_awready            (C3_DDR4_S_AXI_awready),
        .C3_DDR4_M_AXI_awregion           (),
        .C3_DDR4_M_AXI_awsize             (C3_DDR4_S_AXI_awsize),
        .C3_DDR4_M_AXI_awvalid            (C3_DDR4_S_AXI_awvalid),
        .C3_DDR4_M_AXI_bid                (C3_DDR4_S_AXI_bid),
        .C3_DDR4_M_AXI_bready             (C3_DDR4_S_AXI_bready),
        .C3_DDR4_M_AXI_bresp              (C3_DDR4_S_AXI_bresp),
        .C3_DDR4_M_AXI_bvalid             (C3_DDR4_S_AXI_bvalid),
        .C3_DDR4_M_AXI_rdata              (C3_DDR4_S_AXI_rdata),
        .C3_DDR4_M_AXI_rid                (C3_DDR4_S_AXI_rid),
        .C3_DDR4_M_AXI_rlast              (C3_DDR4_S_AXI_rlast),
        .C3_DDR4_M_AXI_rready             (C3_DDR4_S_AXI_rready),
        .C3_DDR4_M_AXI_rresp              (C3_DDR4_S_AXI_rresp),
        .C3_DDR4_M_AXI_rvalid             (C3_DDR4_S_AXI_rvalid),
        .C3_DDR4_M_AXI_wdata              (C3_DDR4_S_AXI_wdata),
        .C3_DDR4_M_AXI_wlast              (C3_DDR4_S_AXI_wlast),
        .C3_DDR4_M_AXI_wready             (C3_DDR4_S_AXI_wready),
        .C3_DDR4_M_AXI_wstrb              (C3_DDR4_S_AXI_wstrb),
        .C3_DDR4_M_AXI_wvalid             (C3_DDR4_S_AXI_wvalid),
        .c3_ddr4_ui_clk                   (c3_ddr4_ui_clk),
        .c3_ddr4_ui_clk_sync_rst          (c3_ddr4_ui_clk_sync_rst),
        `endif

        .s_axi_aclk(s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn),
        .i_soft_rst_n(i_soft_rst_n),
        .usr_clk(pe_clk),
        .usr_irq_ack(usr_irq_ack),
        .usr_irq_req(usr_irq_req));

`ifndef USE_NO_DDR
 ddr_sim #(
   .DATA_WIDTH(512),
   .ADDR_WIDTH(31),
   .ID_WIDTH(1),
   .MASK_WIDTH(512/8)
 )ddr_sim
   (
    `ifdef USE_DDR4_C0
    .C0_DDR4_S_AXI_CTRL_araddr(C0_DDR4_S_AXI_CTRL_araddr),
    .C0_DDR4_S_AXI_CTRL_arready(C0_DDR4_S_AXI_CTRL_arready),
    .C0_DDR4_S_AXI_CTRL_arvalid(C0_DDR4_S_AXI_CTRL_arvalid),
    .C0_DDR4_S_AXI_CTRL_awaddr(C0_DDR4_S_AXI_CTRL_awaddr),
    .C0_DDR4_S_AXI_CTRL_awready(C0_DDR4_S_AXI_CTRL_awready),
    .C0_DDR4_S_AXI_CTRL_awvalid(C0_DDR4_S_AXI_CTRL_awvalid),
    .C0_DDR4_S_AXI_CTRL_bready(C0_DDR4_S_AXI_CTRL_bready),
    .C0_DDR4_S_AXI_CTRL_bresp(C0_DDR4_S_AXI_CTRL_bresp),
    .C0_DDR4_S_AXI_CTRL_bvalid(C0_DDR4_S_AXI_CTRL_bvalid),
    .C0_DDR4_S_AXI_CTRL_rdata(C0_DDR4_S_AXI_CTRL_rdata),
    .C0_DDR4_S_AXI_CTRL_rready(C0_DDR4_S_AXI_CTRL_rready),
    .C0_DDR4_S_AXI_CTRL_rresp(C0_DDR4_S_AXI_CTRL_rresp),
    .C0_DDR4_S_AXI_CTRL_rvalid(C0_DDR4_S_AXI_CTRL_rvalid),
    .C0_DDR4_S_AXI_CTRL_wdata(C0_DDR4_S_AXI_CTRL_wdata),
    .C0_DDR4_S_AXI_CTRL_wready(C0_DDR4_S_AXI_CTRL_wready),
    .C0_DDR4_S_AXI_CTRL_wvalid(C0_DDR4_S_AXI_CTRL_wvalid),

    .C0_DDR4_S_AXI_araddr(C0_DDR4_S_AXI_araddr),
    .C0_DDR4_S_AXI_arburst(C0_DDR4_S_AXI_arburst),
    .C0_DDR4_S_AXI_arcache(C0_DDR4_S_AXI_arcache),
    .C0_DDR4_S_AXI_arid(C0_DDR4_S_AXI_arid),
    .C0_DDR4_S_AXI_arlen(C0_DDR4_S_AXI_arlen),
    .C0_DDR4_S_AXI_arlock(C0_DDR4_S_AXI_arlock),
    .C0_DDR4_S_AXI_arprot(C0_DDR4_S_AXI_arprot),
    .C0_DDR4_S_AXI_arqos(C0_DDR4_S_AXI_arqos),
    .C0_DDR4_S_AXI_arready(C0_DDR4_S_AXI_arready),
    .C0_DDR4_S_AXI_arsize(C0_DDR4_S_AXI_arsize),
    .C0_DDR4_S_AXI_arvalid(C0_DDR4_S_AXI_arvalid),
    .C0_DDR4_S_AXI_awaddr(C0_DDR4_S_AXI_awaddr),
    .C0_DDR4_S_AXI_awburst(C0_DDR4_S_AXI_awburst),
    .C0_DDR4_S_AXI_awcache(C0_DDR4_S_AXI_awcache),
    .C0_DDR4_S_AXI_awid(C0_DDR4_S_AXI_awid),
    .C0_DDR4_S_AXI_awlen(C0_DDR4_S_AXI_awlen),
    .C0_DDR4_S_AXI_awlock(C0_DDR4_S_AXI_awlock),
    .C0_DDR4_S_AXI_awprot(C0_DDR4_S_AXI_awprot),
    .C0_DDR4_S_AXI_awqos(C0_DDR4_S_AXI_awqos),
    .C0_DDR4_S_AXI_awready(C0_DDR4_S_AXI_awready),
    .C0_DDR4_S_AXI_awsize(C0_DDR4_S_AXI_awsize),
    .C0_DDR4_S_AXI_awvalid(C0_DDR4_S_AXI_awvalid),
    .C0_DDR4_S_AXI_bid(C0_DDR4_S_AXI_bid),
    .C0_DDR4_S_AXI_bready(C0_DDR4_S_AXI_bready),
    .C0_DDR4_S_AXI_bresp(C0_DDR4_S_AXI_bresp),
    .C0_DDR4_S_AXI_bvalid(C0_DDR4_S_AXI_bvalid),
    .C0_DDR4_S_AXI_rdata(C0_DDR4_S_AXI_rdata),
    .C0_DDR4_S_AXI_rid(C0_DDR4_S_AXI_rid),
    .C0_DDR4_S_AXI_rlast(C0_DDR4_S_AXI_rlast),
    .C0_DDR4_S_AXI_rready(C0_DDR4_S_AXI_rready),
    .C0_DDR4_S_AXI_rresp(C0_DDR4_S_AXI_rresp),
    .C0_DDR4_S_AXI_rvalid(C0_DDR4_S_AXI_rvalid),
    .C0_DDR4_S_AXI_wdata(C0_DDR4_S_AXI_wdata),
    .C0_DDR4_S_AXI_wlast(C0_DDR4_S_AXI_wlast),
    .C0_DDR4_S_AXI_wready(C0_DDR4_S_AXI_wready),
    .C0_DDR4_S_AXI_wstrb(C0_DDR4_S_AXI_wstrb),
    .C0_DDR4_S_AXI_wvalid(C0_DDR4_S_AXI_wvalid),
    .C0_DDR4_act_n(C0_DDR4_act_n),
    .C0_DDR4_adr(C0_DDR4_adr),
    .C0_DDR4_ba(C0_DDR4_ba),
    .C0_DDR4_bg(C0_DDR4_bg),
    .C0_DDR4_ck_c(C0_DDR4_ck_c),
    .C0_DDR4_ck_t(C0_DDR4_ck_t),
    .C0_DDR4_cke(C0_DDR4_cke),
    .C0_DDR4_cs_n(C0_DDR4_cs_n),
       `ifdef USE_DDR4_C0_64bit
       .C0_DDR4_dm_n(C0_DDR4_dm_n[7:0]),
       .C0_DDR4_dq(C0_DDR4_dq[63:0]),
       .C0_DDR4_dqs_c(C0_DDR4_dqs_c[7:0]),
       .C0_DDR4_dqs_t(C0_DDR4_dqs_t[7:0]),
       `else
       .C0_DDR4_dm_n(C0_DDR4_dm_n),
       .C0_DDR4_dq(C0_DDR4_dq),
       .C0_DDR4_dqs_c(C0_DDR4_dqs_c),
       .C0_DDR4_dqs_t(C0_DDR4_dqs_t),
       `endif
    .C0_DDR4_odt(C0_DDR4_odt),
    .C0_DDR4_reset_n(C0_DDR4_reset_n),
    .C0_SYS_CLK_clk_n(C0_SYS_CLK_clk_n),
    .C0_SYS_CLK_clk_p(C0_SYS_CLK_clk_p),
    .c0_ddr4_aresetn(1'b1),
    .c0_ddr4_interrupt(c0_ddr4_interrupt),
    .c0_ddr4_ui_clk(c0_ddr4_ui_clk),
    .c0_ddr4_ui_clk_sync_rst(c0_ddr4_ui_clk_sync_rst),
    .c0_init_calib_complete(),
    `endif

    `ifdef USE_DDR4_C1
    .C1_DDR4_S_AXI_CTRL_araddr(C1_DDR4_S_AXI_CTRL_araddr),
    .C1_DDR4_S_AXI_CTRL_arready(C1_DDR4_S_AXI_CTRL_arready),
    .C1_DDR4_S_AXI_CTRL_arvalid(C1_DDR4_S_AXI_CTRL_arvalid),
    .C1_DDR4_S_AXI_CTRL_awaddr(C1_DDR4_S_AXI_CTRL_awaddr),
    .C1_DDR4_S_AXI_CTRL_awready(C1_DDR4_S_AXI_CTRL_awready),
    .C1_DDR4_S_AXI_CTRL_awvalid(C1_DDR4_S_AXI_CTRL_awvalid),
    .C1_DDR4_S_AXI_CTRL_bready(C1_DDR4_S_AXI_CTRL_bready),
    .C1_DDR4_S_AXI_CTRL_bresp(C1_DDR4_S_AXI_CTRL_bresp),
    .C1_DDR4_S_AXI_CTRL_bvalid(C1_DDR4_S_AXI_CTRL_bvalid),
    .C1_DDR4_S_AXI_CTRL_rdata(C1_DDR4_S_AXI_CTRL_rdata),
    .C1_DDR4_S_AXI_CTRL_rready(C1_DDR4_S_AXI_CTRL_rready),
    .C1_DDR4_S_AXI_CTRL_rresp(C1_DDR4_S_AXI_CTRL_rresp),
    .C1_DDR4_S_AXI_CTRL_rvalid(C1_DDR4_S_AXI_CTRL_rvalid),
    .C1_DDR4_S_AXI_CTRL_wdata(C1_DDR4_S_AXI_CTRL_wdata),
    .C1_DDR4_S_AXI_CTRL_wready(C1_DDR4_S_AXI_CTRL_wready),
    .C1_DDR4_S_AXI_CTRL_wvalid(C1_DDR4_S_AXI_CTRL_wvalid),
    .C1_DDR4_S_AXI_araddr(C1_DDR4_S_AXI_araddr),
    .C1_DDR4_S_AXI_arburst(C1_DDR4_S_AXI_arburst),
    .C1_DDR4_S_AXI_arcache(C1_DDR4_S_AXI_arcache),
    .C1_DDR4_S_AXI_arid(C1_DDR4_S_AXI_arid),
    .C1_DDR4_S_AXI_arlen(C1_DDR4_S_AXI_arlen),
    .C1_DDR4_S_AXI_arlock(C1_DDR4_S_AXI_arlock),
    .C1_DDR4_S_AXI_arprot(C1_DDR4_S_AXI_arprot),
    .C1_DDR4_S_AXI_arqos(C1_DDR4_S_AXI_arqos),
    .C1_DDR4_S_AXI_arready(C1_DDR4_S_AXI_arready),
    .C1_DDR4_S_AXI_arsize(C1_DDR4_S_AXI_arsize),
    .C1_DDR4_S_AXI_arvalid(C1_DDR4_S_AXI_arvalid),
    .C1_DDR4_S_AXI_awaddr(C1_DDR4_S_AXI_awaddr),
    .C1_DDR4_S_AXI_awburst(C1_DDR4_S_AXI_awburst),
    .C1_DDR4_S_AXI_awcache(C1_DDR4_S_AXI_awcache),
    .C1_DDR4_S_AXI_awid(C1_DDR4_S_AXI_awid),
    .C1_DDR4_S_AXI_awlen(C1_DDR4_S_AXI_awlen),
    .C1_DDR4_S_AXI_awlock(C1_DDR4_S_AXI_awlock),
    .C1_DDR4_S_AXI_awprot(C1_DDR4_S_AXI_awprot),
    .C1_DDR4_S_AXI_awqos(C1_DDR4_S_AXI_awqos),
    .C1_DDR4_S_AXI_awready(C1_DDR4_S_AXI_awready),
    .C1_DDR4_S_AXI_awsize(C1_DDR4_S_AXI_awsize),
    .C1_DDR4_S_AXI_awvalid(C1_DDR4_S_AXI_awvalid),
    .C1_DDR4_S_AXI_bid(C1_DDR4_S_AXI_bid),
    .C1_DDR4_S_AXI_bready(C1_DDR4_S_AXI_bready),
    .C1_DDR4_S_AXI_bresp(C1_DDR4_S_AXI_bresp),
    .C1_DDR4_S_AXI_bvalid(C1_DDR4_S_AXI_bvalid),
    .C1_DDR4_S_AXI_rdata(C1_DDR4_S_AXI_rdata),
    .C1_DDR4_S_AXI_rid(C1_DDR4_S_AXI_rid),
    .C1_DDR4_S_AXI_rlast(C1_DDR4_S_AXI_rlast),
    .C1_DDR4_S_AXI_rready(C1_DDR4_S_AXI_rready),
    .C1_DDR4_S_AXI_rresp(C1_DDR4_S_AXI_rresp),
    .C1_DDR4_S_AXI_rvalid(C1_DDR4_S_AXI_rvalid),
    .C1_DDR4_S_AXI_wdata(C1_DDR4_S_AXI_wdata),
    .C1_DDR4_S_AXI_wlast(C1_DDR4_S_AXI_wlast),
    .C1_DDR4_S_AXI_wready(C1_DDR4_S_AXI_wready),
    .C1_DDR4_S_AXI_wstrb(C1_DDR4_S_AXI_wstrb),
    .C1_DDR4_S_AXI_wvalid(C1_DDR4_S_AXI_wvalid),
    .C1_DDR4_act_n(C1_DDR4_act_n),
    .C1_DDR4_adr(C1_DDR4_adr),
    .C1_DDR4_ba(C1_DDR4_ba),
    .C1_DDR4_bg(C1_DDR4_bg),
    .C1_DDR4_ck_c(C1_DDR4_ck_c),
    .C1_DDR4_ck_t(C1_DDR4_ck_t),
    .C1_DDR4_cke(C1_DDR4_cke),
    .C1_DDR4_cs_n(C1_DDR4_cs_n),
       `ifdef USE_DDR4_C1_64bit
       .C1_DDR4_dm_n(C1_DDR4_dm_n[7:0]),
       .C1_DDR4_dq(C1_DDR4_dq[63:0]),
       .C1_DDR4_dqs_c(C1_DDR4_dqs_c[7:0]),
       .C1_DDR4_dqs_t(C1_DDR4_dqs_t[7:0]),
       `else
       .C1_DDR4_dm_n(C1_DDR4_dm_n),
       .C1_DDR4_dq(C1_DDR4_dq),
       .C1_DDR4_dqs_c(C1_DDR4_dqs_c),
       .C1_DDR4_dqs_t(C1_DDR4_dqs_t),
       `endif
    .C1_DDR4_odt(C1_DDR4_odt),
    .C1_DDR4_reset_n(C1_DDR4_reset_n),
    .C1_SYS_CLK_clk_n(C1_SYS_CLK_clk_n),
    .C1_SYS_CLK_clk_p(C1_SYS_CLK_clk_p),
    .c1_ddr4_aresetn(1'b1),
    .c1_ddr4_interrupt(c1_ddr4_interrupt),
    .c1_ddr4_ui_clk(c1_ddr4_ui_clk),
    .c1_ddr4_ui_clk_sync_rst(c1_ddr4_ui_clk_sync_rst),
    .c1_init_calib_complete(),
    `endif

    `ifdef USE_DDR4_C2
    .C2_DDR4_S_AXI_CTRL_araddr(C2_DDR4_S_AXI_CTRL_araddr),
    .C2_DDR4_S_AXI_CTRL_arready(C2_DDR4_S_AXI_CTRL_arready),
    .C2_DDR4_S_AXI_CTRL_arvalid(C2_DDR4_S_AXI_CTRL_arvalid),
    .C2_DDR4_S_AXI_CTRL_awaddr(C2_DDR4_S_AXI_CTRL_awaddr),
    .C2_DDR4_S_AXI_CTRL_awready(C2_DDR4_S_AXI_CTRL_awready),
    .C2_DDR4_S_AXI_CTRL_awvalid(C2_DDR4_S_AXI_CTRL_awvalid),
    .C2_DDR4_S_AXI_CTRL_bready(C2_DDR4_S_AXI_CTRL_bready),
    .C2_DDR4_S_AXI_CTRL_bresp(C2_DDR4_S_AXI_CTRL_bresp),
    .C2_DDR4_S_AXI_CTRL_bvalid(C2_DDR4_S_AXI_CTRL_bvalid),
    .C2_DDR4_S_AXI_CTRL_rdata(C2_DDR4_S_AXI_CTRL_rdata),
    .C2_DDR4_S_AXI_CTRL_rready(C2_DDR4_S_AXI_CTRL_rready),
    .C2_DDR4_S_AXI_CTRL_rresp(C2_DDR4_S_AXI_CTRL_rresp),
    .C2_DDR4_S_AXI_CTRL_rvalid(C2_DDR4_S_AXI_CTRL_rvalid),
    .C2_DDR4_S_AXI_CTRL_wdata(C2_DDR4_S_AXI_CTRL_wdata),
    .C2_DDR4_S_AXI_CTRL_wready(C2_DDR4_S_AXI_CTRL_wready),
    .C2_DDR4_S_AXI_CTRL_wvalid(C2_DDR4_S_AXI_CTRL_wvalid),
    .C2_DDR4_S_AXI_araddr(C2_DDR4_S_AXI_araddr),
    .C2_DDR4_S_AXI_arburst(C2_DDR4_S_AXI_arburst),
    .C2_DDR4_S_AXI_arcache(C2_DDR4_S_AXI_arcache),
    .C2_DDR4_S_AXI_arid(C2_DDR4_S_AXI_arid),
    .C2_DDR4_S_AXI_arlen(C2_DDR4_S_AXI_arlen),
    .C2_DDR4_S_AXI_arlock(C2_DDR4_S_AXI_arlock),
    .C2_DDR4_S_AXI_arprot(C2_DDR4_S_AXI_arprot),
    .C2_DDR4_S_AXI_arqos(C2_DDR4_S_AXI_arqos),
    .C2_DDR4_S_AXI_arready(C2_DDR4_S_AXI_arready),
    .C2_DDR4_S_AXI_arsize(C2_DDR4_S_AXI_arsize),
    .C2_DDR4_S_AXI_arvalid(C2_DDR4_S_AXI_arvalid),
    .C2_DDR4_S_AXI_awaddr(C2_DDR4_S_AXI_awaddr),
    .C2_DDR4_S_AXI_awburst(C2_DDR4_S_AXI_awburst),
    .C2_DDR4_S_AXI_awcache(C2_DDR4_S_AXI_awcache),
    .C2_DDR4_S_AXI_awid(C2_DDR4_S_AXI_awid),
    .C2_DDR4_S_AXI_awlen(C2_DDR4_S_AXI_awlen),
    .C2_DDR4_S_AXI_awlock(C2_DDR4_S_AXI_awlock),
    .C2_DDR4_S_AXI_awprot(C2_DDR4_S_AXI_awprot),
    .C2_DDR4_S_AXI_awqos(C2_DDR4_S_AXI_awqos),
    .C2_DDR4_S_AXI_awready(C2_DDR4_S_AXI_awready),
    .C2_DDR4_S_AXI_awsize(C2_DDR4_S_AXI_awsize),
    .C2_DDR4_S_AXI_awvalid(C2_DDR4_S_AXI_awvalid),
    .C2_DDR4_S_AXI_bid(C2_DDR4_S_AXI_bid),
    .C2_DDR4_S_AXI_bready(C2_DDR4_S_AXI_bready),
    .C2_DDR4_S_AXI_bresp(C2_DDR4_S_AXI_bresp),
    .C2_DDR4_S_AXI_bvalid(C2_DDR4_S_AXI_bvalid),
    .C2_DDR4_S_AXI_rdata(C2_DDR4_S_AXI_rdata),
    .C2_DDR4_S_AXI_rid(C2_DDR4_S_AXI_rid),
    .C2_DDR4_S_AXI_rlast(C2_DDR4_S_AXI_rlast),
    .C2_DDR4_S_AXI_rready(C2_DDR4_S_AXI_rready),
    .C2_DDR4_S_AXI_rresp(C2_DDR4_S_AXI_rresp),
    .C2_DDR4_S_AXI_rvalid(C2_DDR4_S_AXI_rvalid),
    .C2_DDR4_S_AXI_wdata(C2_DDR4_S_AXI_wdata),
    .C2_DDR4_S_AXI_wlast(C2_DDR4_S_AXI_wlast),
    .C2_DDR4_S_AXI_wready(C2_DDR4_S_AXI_wready),
    .C2_DDR4_S_AXI_wstrb(C2_DDR4_S_AXI_wstrb),
    .C2_DDR4_S_AXI_wvalid(C2_DDR4_S_AXI_wvalid),
    .C2_DDR4_act_n(C2_DDR4_act_n),
    .C2_DDR4_adr(C2_DDR4_adr),
    .C2_DDR4_ba(C2_DDR4_ba),
    .C2_DDR4_bg(C2_DDR4_bg),
    .C2_DDR4_ck_c(C2_DDR4_ck_c),
    .C2_DDR4_ck_t(C2_DDR4_ck_t),
    .C2_DDR4_cke(C2_DDR4_cke),
    .C2_DDR4_cs_n(C2_DDR4_cs_n),
       `ifdef USE_DDR4_C2_64bit
       .C2_DDR4_dm_n(C2_DDR4_dm_n[7:0]),
       .C2_DDR4_dq(C2_DDR4_dq[63:0]),
       .C2_DDR4_dqs_c(C2_DDR4_dqs_c[7:0]),
       .C2_DDR4_dqs_t(C2_DDR4_dqs_t[7:0]),
       `else
       .C2_DDR4_dm_n(C2_DDR4_dm_n),
       .C2_DDR4_dq(C2_DDR4_dq),
       .C2_DDR4_dqs_c(C2_DDR4_dqs_c),
       .C2_DDR4_dqs_t(C2_DDR4_dqs_t),
       `endif
    .C2_DDR4_odt(C2_DDR4_odt),
    .C2_DDR4_reset_n(C2_DDR4_reset_n),
    .C2_SYS_CLK_clk_n(C2_SYS_CLK_clk_n),
    .C2_SYS_CLK_clk_p(C2_SYS_CLK_clk_p),
    .c2_ddr4_aresetn(1'b1),
    .c2_ddr4_interrupt(c2_ddr4_interrupt),
    .c2_ddr4_ui_clk(c2_ddr4_ui_clk),
    .c2_ddr4_ui_clk_sync_rst(c2_ddr4_ui_clk_sync_rst),
    .c2_init_calib_complete(),
    `endif

    `ifdef USE_DDR4_C3
    .C3_DDR4_S_AXI_CTRL_araddr(C3_DDR4_S_AXI_CTRL_araddr),
    .C3_DDR4_S_AXI_CTRL_arready(C3_DDR4_S_AXI_CTRL_arready),
    .C3_DDR4_S_AXI_CTRL_arvalid(C3_DDR4_S_AXI_CTRL_arvalid),
    .C3_DDR4_S_AXI_CTRL_awaddr(C3_DDR4_S_AXI_CTRL_awaddr),
    .C3_DDR4_S_AXI_CTRL_awready(C3_DDR4_S_AXI_CTRL_awready),
    .C3_DDR4_S_AXI_CTRL_awvalid(C3_DDR4_S_AXI_CTRL_awvalid),
    .C3_DDR4_S_AXI_CTRL_bready(C3_DDR4_S_AXI_CTRL_bready),
    .C3_DDR4_S_AXI_CTRL_bresp(C3_DDR4_S_AXI_CTRL_bresp),
    .C3_DDR4_S_AXI_CTRL_bvalid(C3_DDR4_S_AXI_CTRL_bvalid),
    .C3_DDR4_S_AXI_CTRL_rdata(C3_DDR4_S_AXI_CTRL_rdata),
    .C3_DDR4_S_AXI_CTRL_rready(C3_DDR4_S_AXI_CTRL_rready),
    .C3_DDR4_S_AXI_CTRL_rresp(C3_DDR4_S_AXI_CTRL_rresp),
    .C3_DDR4_S_AXI_CTRL_rvalid(C3_DDR4_S_AXI_CTRL_rvalid),
    .C3_DDR4_S_AXI_CTRL_wdata(C3_DDR4_S_AXI_CTRL_wdata),
    .C3_DDR4_S_AXI_CTRL_wready(C3_DDR4_S_AXI_CTRL_wready),
    .C3_DDR4_S_AXI_CTRL_wvalid(C3_DDR4_S_AXI_CTRL_wvalid),
    .C3_DDR4_S_AXI_araddr(C3_DDR4_S_AXI_araddr),
    .C3_DDR4_S_AXI_arburst(C3_DDR4_S_AXI_arburst),
    .C3_DDR4_S_AXI_arcache(C3_DDR4_S_AXI_arcache),
    .C3_DDR4_S_AXI_arid(C3_DDR4_S_AXI_arid),
    .C3_DDR4_S_AXI_arlen(C3_DDR4_S_AXI_arlen),
    .C3_DDR4_S_AXI_arlock(C3_DDR4_S_AXI_arlock),
    .C3_DDR4_S_AXI_arprot(C3_DDR4_S_AXI_arprot),
    .C3_DDR4_S_AXI_arqos(C3_DDR4_S_AXI_arqos),
    .C3_DDR4_S_AXI_arready(C3_DDR4_S_AXI_arready),
    .C3_DDR4_S_AXI_arsize(C3_DDR4_S_AXI_arsize),
    .C3_DDR4_S_AXI_arvalid(C3_DDR4_S_AXI_arvalid),
    .C3_DDR4_S_AXI_awaddr(C3_DDR4_S_AXI_awaddr),
    .C3_DDR4_S_AXI_awburst(C3_DDR4_S_AXI_awburst),
    .C3_DDR4_S_AXI_awcache(C3_DDR4_S_AXI_awcache),
    .C3_DDR4_S_AXI_awid(C3_DDR4_S_AXI_awid),
    .C3_DDR4_S_AXI_awlen(C3_DDR4_S_AXI_awlen),
    .C3_DDR4_S_AXI_awlock(C3_DDR4_S_AXI_awlock),
    .C3_DDR4_S_AXI_awprot(C3_DDR4_S_AXI_awprot),
    .C3_DDR4_S_AXI_awqos(C3_DDR4_S_AXI_awqos),
    .C3_DDR4_S_AXI_awready(C3_DDR4_S_AXI_awready),
    .C3_DDR4_S_AXI_awsize(C3_DDR4_S_AXI_awsize),
    .C3_DDR4_S_AXI_awvalid(C3_DDR4_S_AXI_awvalid),
    .C3_DDR4_S_AXI_bid(C3_DDR4_S_AXI_bid),
    .C3_DDR4_S_AXI_bready(C3_DDR4_S_AXI_bready),
    .C3_DDR4_S_AXI_bresp(C3_DDR4_S_AXI_bresp),
    .C3_DDR4_S_AXI_bvalid(C3_DDR4_S_AXI_bvalid),
    .C3_DDR4_S_AXI_rdata(C3_DDR4_S_AXI_rdata),
    .C3_DDR4_S_AXI_rid(C3_DDR4_S_AXI_rid),
    .C3_DDR4_S_AXI_rlast(C3_DDR4_S_AXI_rlast),
    .C3_DDR4_S_AXI_rready(C3_DDR4_S_AXI_rready),
    .C3_DDR4_S_AXI_rresp(C3_DDR4_S_AXI_rresp),
    .C3_DDR4_S_AXI_rvalid(C3_DDR4_S_AXI_rvalid),
    .C3_DDR4_S_AXI_wdata(C3_DDR4_S_AXI_wdata),
    .C3_DDR4_S_AXI_wlast(C3_DDR4_S_AXI_wlast),
    .C3_DDR4_S_AXI_wready(C3_DDR4_S_AXI_wready),
    .C3_DDR4_S_AXI_wstrb(C3_DDR4_S_AXI_wstrb),
    .C3_DDR4_S_AXI_wvalid(C3_DDR4_S_AXI_wvalid),
    .C3_DDR4_act_n(C3_DDR4_act_n),
    .C3_DDR4_adr(C3_DDR4_adr),
    .C3_DDR4_ba(C3_DDR4_ba),
    .C3_DDR4_bg(C3_DDR4_bg),
    .C3_DDR4_ck_c(C3_DDR4_ck_c),
    .C3_DDR4_ck_t(C3_DDR4_ck_t),
    .C3_DDR4_cke(C3_DDR4_cke),
    .C3_DDR4_cs_n(C3_DDR4_cs_n),
       `ifdef USE_DDR4_C3_64bit
       .C3_DDR4_dm_n(C3_DDR4_dm_n[7:0]),
       .C3_DDR4_dq(C3_DDR4_dq[63:0]),
       .C3_DDR4_dqs_c(C3_DDR4_dqs_c[7:0]),
       .C3_DDR4_dqs_t(C3_DDR4_dqs_t[7:0]),
       `else
       .C3_DDR4_dm_n(C3_DDR4_dm_n),
       .C3_DDR4_dq(C3_DDR4_dq),
       .C3_DDR4_dqs_c(C3_DDR4_dqs_c),
       .C3_DDR4_dqs_t(C3_DDR4_dqs_t),
       `endif
    .C3_DDR4_odt(C3_DDR4_odt),
    .C3_DDR4_reset_n(C3_DDR4_reset_n),
    .C3_SYS_CLK_clk_n(C3_SYS_CLK_clk_n),
    .C3_SYS_CLK_clk_p(C3_SYS_CLK_clk_p),
    .c3_ddr4_aresetn(1'b1),
    .c3_ddr4_interrupt(c3_ddr4_interrupt),
    .c3_ddr4_ui_clk(c3_ddr4_ui_clk),
    .c3_ddr4_ui_clk_sync_rst(c3_ddr4_ui_clk_sync_rst),
    .c3_init_calib_complete(),
    `endif

    .reset_rtl(sys_reset));
`endif

    assign C0_DDR4_S_AXI_CTRL_arvalid = 1'b0;
    assign C0_DDR4_S_AXI_CTRL_awvalid = 1'b0;
    assign C0_DDR4_S_AXI_CTRL_wvalid  = 1'b0;
    assign C0_DDR4_S_AXI_CTRL_rready  = 1'b1;
    assign C0_DDR4_S_AXI_CTRL_bready  = 1'b1;
    assign C1_DDR4_S_AXI_CTRL_arvalid = 1'b0;
    assign C1_DDR4_S_AXI_CTRL_awvalid = 1'b0;
    assign C1_DDR4_S_AXI_CTRL_wvalid  = 1'b0;
    assign C1_DDR4_S_AXI_CTRL_rready  = 1'b1;
    assign C1_DDR4_S_AXI_CTRL_bready  = 1'b1;
    assign C2_DDR4_S_AXI_CTRL_arvalid = 1'b0;
    assign C2_DDR4_S_AXI_CTRL_awvalid = 1'b0;
    assign C2_DDR4_S_AXI_CTRL_wvalid  = 1'b0;
    assign C2_DDR4_S_AXI_CTRL_rready  = 1'b1;
    assign C2_DDR4_S_AXI_CTRL_bready  = 1'b1;
    assign C3_DDR4_S_AXI_CTRL_arvalid = 1'b0;
    assign C3_DDR4_S_AXI_CTRL_awvalid = 1'b0;
    assign C3_DDR4_S_AXI_CTRL_wvalid  = 1'b0;
    assign C3_DDR4_S_AXI_CTRL_rready  = 1'b1;
    assign C3_DDR4_S_AXI_CTRL_bready  = 1'b1;

endmodule
