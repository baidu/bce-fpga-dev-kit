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
`include "rp_if_define.vh"

module rp_wrapper(
   `include "rp_wrapper_port.vh"
   `ifdef AXI_DDR
      `include "axi_ddr_sig_declare.vh"
   `else
      `include "app_ddr_sig_declare.vh"
   `endif

   wire c0_ddr4_ui_clk;
   wire c0_ddr4_ui_clk_sync_rst;
   wire c0_init_calib_complete;
   wire c1_ddr4_ui_clk;
   wire c1_ddr4_ui_clk_sync_rst;
   wire c1_init_calib_complete;
   wire c2_ddr4_ui_clk;
   wire c2_ddr4_ui_clk_sync_rst;
   wire c2_init_calib_complete;
   wire c3_ddr4_ui_clk;
   wire c3_ddr4_ui_clk_sync_rst;
   wire c3_init_calib_complete;

   rp_bd rp_bd_i(
      .S_AXI_araddr(S_AXI_araddr),
      .S_AXI_arburst(S_AXI_arburst),
      .S_AXI_arcache(S_AXI_arcache),
      .S_AXI_arid(S_AXI_arid),
      .S_AXI_arlen(S_AXI_arlen),
      .S_AXI_arlock(S_AXI_arlock),
      .S_AXI_arprot(S_AXI_arprot),
      .S_AXI_arqos(S_AXI_arqos),
      //.S_AXI_arregion(S_AXI_arregion),
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
      //.S_AXI_awregion(S_AXI_awregion),
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
      `ifdef RP_AXI_MASTER
      .M_AXI_araddr(M_AXI_araddr),
      .M_AXI_arburst(M_AXI_arburst),
      .M_AXI_arcache(M_AXI_arcache),
      .M_AXI_arid(M_AXI_arid),
      .M_AXI_arlen(M_AXI_arlen),
      .M_AXI_arlock(M_AXI_arlock),
      .M_AXI_arprot(M_AXI_arprot),
      .M_AXI_arqos(M_AXI_arqos),
      .M_AXI_arregion(M_AXI_arregion),
      .M_AXI_arready(M_AXI_arready),
      .M_AXI_arsize(M_AXI_arsize),
      .M_AXI_arvalid(M_AXI_arvalid),
      .M_AXI_awaddr(M_AXI_awaddr),
      .M_AXI_awburst(M_AXI_awburst),
      .M_AXI_awcache(M_AXI_awcache),
      .M_AXI_awid(M_AXI_awid),
      .M_AXI_awlen(M_AXI_awlen),
      .M_AXI_awlock(M_AXI_awlock),
      .M_AXI_awprot(M_AXI_awprot),
      .M_AXI_awqos(M_AXI_awqos),
      .M_AXI_awregion(M_AXI_awregion),
      .M_AXI_awready(M_AXI_awready),
      .M_AXI_awsize(M_AXI_awsize),
      .M_AXI_awvalid(M_AXI_awvalid),
      .M_AXI_bid(M_AXI_bid),
      .M_AXI_bready(M_AXI_bready),
      .M_AXI_bresp(M_AXI_bresp),
      .M_AXI_bvalid(M_AXI_bvalid),
      .M_AXI_rdata(M_AXI_rdata),
      .M_AXI_rid(M_AXI_rid),
      .M_AXI_rlast(M_AXI_rlast),
      .M_AXI_rready(M_AXI_rready),
      .M_AXI_rresp(M_AXI_rresp),
      .M_AXI_rvalid(M_AXI_rvalid),
      .M_AXI_wdata(M_AXI_wdata),
      .M_AXI_wlast(M_AXI_wlast),
      .M_AXI_wready(M_AXI_wready),
      .M_AXI_wstrb(M_AXI_wstrb),
      .M_AXI_wvalid(M_AXI_wvalid),
      `endif
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

      `ifdef AXI_DDR
         `include "rp_if_axiddr.vh"
      `else
         `include "mig_wrapper_if_app.vh"
      `endif

      .s_axi_aclk(s_axi_aclk),
      .s_axi_aresetn(s_axi_aresetn),
      .i_soft_rst_n(i_soft_rst_n),
      .usr_clk(pe_clk),
      .usr_clk_rst(pe_clk_rst),
      .usr_irq_ack(usr_irq_ack),
      .usr_irq_req(usr_irq_req)
   );

`ifdef USE_DDR
   mig_wrapper mig_wrapper_i(
      `ifdef AXI_DDR
         `include "mig_wrapper_if_axi.vh"
      `else
         `include "mig_wrapper_if_app.vh"
      `endif
      `include "mig_wrapper_if_ddr.vh"
      .reset_rtl(sys_reset)
   );

`else
   `ifdef AXI_DDR
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
   `endif
`endif

`ifdef USE_DDR4_C0
   assign ddr_status[0] = 1'b1;
   assign ddr_status[4] = c0_init_calib_complete;
`else
   assign ddr_status[0] = 1'b0;
   assign ddr_status[4] = 1'b0;
`endif
`ifdef USE_DDR4_C1
   assign ddr_status[1] = 1'b1;
   assign ddr_status[5] = c1_init_calib_complete;
`else
   assign ddr_status[1] = 1'b0;
   assign ddr_status[5] = 1'b0;
`endif
`ifdef USE_DDR4_C2
   assign ddr_status[2] = 1'b1;
   assign ddr_status[6] = c2_init_calib_complete;
`else
   assign ddr_status[2] = 1'b0;
   assign ddr_status[6] = 1'b0;
`endif
`ifdef USE_DDR4_C3
   assign ddr_status[3] = 1'b1;
   assign ddr_status[7] = c3_init_calib_complete;
`else
   assign ddr_status[3] = 1'b0;
   assign ddr_status[7] = 1'b0;
`endif

`ifndef RP_AXI_MASTER
   assign M_AXI_arvalid = 1'b0;
   assign M_AXI_awvalid = 1'b0;
   assign M_AXI_wvalid  = 1'b0;
   assign M_AXI_bready  = 1'b0;
   assign M_AXI_rready  = 1'b0;
`endif

   pr_region_dbg_bridge pr_region_dbg_bridge_i (
      .clk(s_axi_aclk),  // input wire clk
      .S_BSCAN_capture(S_BSCAN_capture),  // input wire capture
      .S_BSCAN_drck(S_BSCAN_drck),        // input wire drck
      .S_BSCAN_reset(S_BSCAN_reset),      // input wire reset
      .S_BSCAN_runtest(S_BSCAN_runtest),  // input wire runtest
      .S_BSCAN_sel(S_BSCAN_sel),          // input wire sel
      .S_BSCAN_shift(S_BSCAN_shift),      // input wire shift
      .S_BSCAN_tck(S_BSCAN_tck),          // input wire tck
      .S_BSCAN_tdi(S_BSCAN_tdi),          // input wire tdi
      .S_BSCAN_tdo(S_BSCAN_tdo),          // output wire tdo
      .S_BSCAN_tms(S_BSCAN_tms),          // input wire tms
      .S_BSCAN_update(S_BSCAN_update),    // input wire update
      .S_BSCAN_bscanid_en(S_BSCAN_bscanid_en)  // input wire bscanid_en
   );
endmodule
