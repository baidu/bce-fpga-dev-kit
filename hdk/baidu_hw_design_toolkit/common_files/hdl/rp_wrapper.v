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
`timescale 1 ps / 1 ps
`include "usr_ddr4_define.vh"

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

   pr_region_dbg_bridge pr_region_dbg_bridge_i (
      .clk(s_axi_aclk),  // input wire clk
      .drck(drck),        // input wire drck
      .shift(shift),      // input wire shift
      .tdi(tdi),          // input wire tdi
      .update(update),    // input wire update
      .sel(sel),          // input wire sel
      .tdo(tdo),          // output wire tdo
      .tms(tms),          // input wire tms
      .tck(tck),          // input wire tck
      .runtest(runtest),  // input wire runtest
      .reset(reset),      // input wire reset
      .capture(capture),  // input wire capture
      .bscanid(bscanid)  // output wire [31 : 0] bscanid
   );
endmodule
