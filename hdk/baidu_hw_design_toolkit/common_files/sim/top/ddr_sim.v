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
//`define FAST_SIM
module ddr_sim #(
   parameter DATA_WIDTH = 512,
   parameter ADDR_WIDTH = 31,
   parameter ID_WIDTH   = 4,
   parameter MASK_WIDTH = DATA_WIDTH/8,
   parameter HOST_MEM_SIZE_PER_CHANNEL = 256*1024
)(
`ifdef AXI_DDR
   `include "mig_wrapper_port_axi.vh"
`else
   `include "mig_wrapper_port_app.vh"
`endif
   `include "mig_wrapper_port_ddr.vh"
   input                    reset_rtl
);

`ifdef USE_DDR4_C0
   `ifdef FAST_SIM
      `ifdef AXI_DDR
      //AXI fast sim
         wire   [DATA_WIDTH-1:0]  mem0_wr_data;
         wire   [MASK_WIDTH-1:0]  mem0_wr_datastrb;
         wire   [ADDR_WIDTH-1:0]  mem0_wr_addr;
         wire   [DATA_WIDTH-1:0]  mem0_rd_data;
         wire                     mem0_rd_data_vld;
         wire                     mem0_rd_en;
         wire   [ADDR_WIDTH-1:0]  mem0_rd_addr;
         reg                      c0_rst_r;
         reg                      c0_rst_n_r;

         always @ (posedge C0_SYS_CLK_clk_n) begin
            c0_rst_r   <= reset_rtl || ~c0_ddr4_aresetn;
            c0_rst_n_r <= ~reset_rtl && c0_ddr4_aresetn;
         end

         assign c0_ddr4_ui_clk             = C0_SYS_CLK_clk_n;
         assign c0_ddr4_ui_clk_sync_rst    = c0_rst_r;
         assign c0_init_calib_complete     = c0_rst_n_r;

         assign C0_DDR4_S_AXI_CTRL_arready = 1'b0;
         assign C0_DDR4_S_AXI_CTRL_awready = 1'b0;
         assign C0_DDR4_S_AXI_CTRL_bvalid  = 1'b0;
         assign C0_DDR4_S_AXI_CTRL_rvalid  = 1'b0;
         assign C0_DDR4_S_AXI_CTRL_wready  = 1'b0;

         axi_slave_bfm #(
            .DATA_WIDTH(DATA_WIDTH),
            .ADDR_WIDTH('d31),
            .MASK_WIDTH(MASK_WIDTH),
            .ID_WIDTH(ID_WIDTH)
         )axi_slave_bfm_c0(
            .clk(c0_ddr4_ui_clk),
            .rst(c0_ddr4_ui_clk_sync_rst),

            // AXI Master AW channel
            .araddr(C0_DDR4_S_AXI_araddr),
            .arburst(C0_DDR4_S_AXI_arburst),
            .arcache(C0_DDR4_S_AXI_arcache),
            .arid(C0_DDR4_S_AXI_arid),
            .arlen(C0_DDR4_S_AXI_arlen),
            .arlock(C0_DDR4_S_AXI_arlock),
            .arprot(C0_DDR4_S_AXI_arprot),
            .arqos(C0_DDR4_S_AXI_arqos),
            .arregion(C0_DDR4_S_AXI_arregion),
            .arready(C0_DDR4_S_AXI_arready),
            .arsize(C0_DDR4_S_AXI_arsize),
            .arvalid(C0_DDR4_S_AXI_arvalid),
            // AXI Master AR channel
            .awaddr(C0_DDR4_S_AXI_awaddr),
            .awburst(C0_DDR4_S_AXI_awburst),
            .awcache(C0_DDR4_S_AXI_awcache),
            .awid(C0_DDR4_S_AXI_awid),
            .awlen(C0_DDR4_S_AXI_awlen),
            .awlock(C0_DDR4_S_AXI_awlock),
            .awprot(C0_DDR4_S_AXI_awprot),
            .awqos(C0_DDR4_S_AXI_awqos),
            .awregion(C0_DDR4_S_AXI_awregion),
            .awready(C0_DDR4_S_AXI_awready),
            .awsize(C0_DDR4_S_AXI_awsize),
            .awvalid(C0_DDR4_S_AXI_awvalid),
            // AXI Master B channel
            .bid(C0_DDR4_S_AXI_bid),
            .bready(C0_DDR4_S_AXI_bready),
            .bresp(C0_DDR4_S_AXI_bresp),
            .bvalid(C0_DDR4_S_AXI_bvalid),
            // AXI Master R channel
            .rdata(C0_DDR4_S_AXI_rdata),
            .rid(C0_DDR4_S_AXI_rid),
            .rlast(C0_DDR4_S_AXI_rlast),
            .rready(C0_DDR4_S_AXI_rready),
            .rresp(C0_DDR4_S_AXI_rresp),
            .rvalid(C0_DDR4_S_AXI_rvalid),
            // AXI Master W channel
            .wdata(C0_DDR4_S_AXI_wdata),
            .wlast(C0_DDR4_S_AXI_wlast),
            .wready(C0_DDR4_S_AXI_wready),
            .wstrb(C0_DDR4_S_AXI_wstrb),
            .wvalid(C0_DDR4_S_AXI_wvalid),

            // Card Memory Interface
            .mem_wr_cmd_rdy(1'b1),
            .mem_wr_data(mem0_wr_data),
            .mem_wr_datastrb(mem0_wr_datastrb),
            .mem_wr_addr(mem0_wr_addr),
            .mem_rd_cmd_rdy(1'b1),
            .mem_rd_data(mem0_rd_data),
            .mem_rd_data_vld(mem0_rd_data_vld),
            .mem_rd_en(mem0_rd_en),
            .mem_rd_addr(mem0_rd_addr)
         );

         //card memory
         mem_2ports #(
            .DATA_WIDTH(DATA_WIDTH),
            .ADDR_WIDTH(ADDR_WIDTH),
            .HOST_MEM_SIZE(HOST_MEM_SIZE_PER_CHANNEL)
         )card_mem_0(
            .clk(c0_ddr4_ui_clk),
            .rst(c0_ddr4_ui_clk_sync_rst),

            .c1_wr_data(mem0_wr_data),
            .c1_wr_datastrb(mem0_wr_datastrb),
            .c1_wr_addr(mem0_wr_addr),
            .c1_rd_data(mem0_rd_data),
            .c1_rd_data_vld(mem0_rd_data_vld),
            .c1_rd_en(mem0_rd_en),
            .c1_rd_addr(mem0_rd_addr),

            .c2_wr_data(),
            .c2_wr_datastrb(64'd0),
            .c2_wr_addr(),
            .c2_rd_data(),
            .c2_rd_data_vld(),
            .c2_rd_en(1'b0),
            .c2_rd_addr()
         );
      `else
      //APP fast sim
         mig_dummy mig_dummy_0(
            .c0_init_calib_complete     (c0_init_calib_complete),
            .c0_ddr4_app_correct_en_i   (c0_ddr4_app_correct_en_i),
            .c0_ddr4_ecc_err_addr       (c0_ddr4_ecc_err_addr),
            .c0_ddr4_ecc_single         (c0_ddr4_ecc_single),
            .c0_ddr4_ecc_multiple       (c0_ddr4_ecc_multiple),
            .c0_ddr4_ui_clk             (c0_ddr4_ui_clk),
            .c0_ddr4_ui_clk_sync_rst    (c0_ddr4_ui_clk_sync_rst),
            .dbg_clk                    (c0_dbg_clk),
            .c0_ddr4_app_addr           (c0_ddr4_app_addr),
            .c0_ddr4_app_cmd            (c0_ddr4_app_cmd),
            .c0_ddr4_app_en             (c0_ddr4_app_en),
            .c0_ddr4_app_hi_pri         (c0_ddr4_app_hi_pri),
            .c0_ddr4_app_wdf_data       (c0_ddr4_app_wdf_data),
            .c0_ddr4_app_wdf_end        (c0_ddr4_app_wdf_end),
            .c0_ddr4_app_wdf_mask       (c0_ddr4_app_wdf_mask),
            .c0_ddr4_app_wdf_wren       (c0_ddr4_app_wdf_wren),
            .c0_ddr4_app_rd_data        (c0_ddr4_app_rd_data),
            .c0_ddr4_app_rd_data_end    (c0_ddr4_app_rd_data_end),
            .c0_ddr4_app_rd_data_valid  (c0_ddr4_app_rd_data_valid),
            .c0_ddr4_app_rdy            (c0_ddr4_app_rdy),
            .c0_ddr4_app_wdf_rdy        (c0_ddr4_app_wdf_rdy),
            // Debug Port
            .dbg_bus                    (c0_dbg_bus)
         );
      `endif
   `else
      `ifdef AXI_DDR
      // AXI_DDR_MIG
         ddr4_0 u_ddr4_0
           (
            .sys_rst                          (reset_rtl),

            .c0_sys_clk_p                     (C0_SYS_CLK_clk_p),
            .c0_sys_clk_n                     (C0_SYS_CLK_clk_n),
            .c0_init_calib_complete           (c0_init_calib_complete),
            .c0_ddr4_act_n                    (C0_DDR4_act_n),
            .c0_ddr4_adr                      (C0_DDR4_adr),
            .c0_ddr4_ba                       (C0_DDR4_ba),
            .c0_ddr4_bg                       (C0_DDR4_bg),
            .c0_ddr4_cke                      (C0_DDR4_cke),
            .c0_ddr4_odt                      (C0_DDR4_odt),
            .c0_ddr4_cs_n                     (C0_DDR4_cs_n),
            .c0_ddr4_ck_t                     (C0_DDR4_ck_t),
            .c0_ddr4_ck_c                     (C0_DDR4_ck_c),
            .c0_ddr4_reset_n                  (C0_DDR4_reset_n),

            .c0_ddr4_dm_dbi_n                 (C0_DDR4_dm_n),
            .c0_ddr4_dq                       (C0_DDR4_dq),
            .c0_ddr4_dqs_c                    (C0_DDR4_dqs_c),
            .c0_ddr4_dqs_t                    (C0_DDR4_dqs_t),

            .c0_ddr4_ui_clk                   (c0_ddr4_ui_clk),
            .c0_ddr4_ui_clk_sync_rst          (c0_ddr4_ui_clk_sync_rst),
            .dbg_clk                          (),
            // AXI CTRL port
            .c0_ddr4_s_axi_ctrl_awvalid       (1'b0),
            .c0_ddr4_s_axi_ctrl_awready       (),
            .c0_ddr4_s_axi_ctrl_awaddr        (32'b0),
            // Slave Interface Write Data Ports
            .c0_ddr4_s_axi_ctrl_wvalid        (1'b0),
            .c0_ddr4_s_axi_ctrl_wready        (),
            .c0_ddr4_s_axi_ctrl_wdata         (32'b0),
            // Slave Interface Write Response Ports
            .c0_ddr4_s_axi_ctrl_bvalid        (),
            .c0_ddr4_s_axi_ctrl_bready        (1'b1),
            .c0_ddr4_s_axi_ctrl_bresp         (),
            // Slave Interface Read Address Ports
            .c0_ddr4_s_axi_ctrl_arvalid       (1'b0),
            .c0_ddr4_s_axi_ctrl_arready       (),
            .c0_ddr4_s_axi_ctrl_araddr        (32'b0),
            // Slave Interface Read Data Ports
            .c0_ddr4_s_axi_ctrl_rvalid        (),
            .c0_ddr4_s_axi_ctrl_rready        (1'b1),
            .c0_ddr4_s_axi_ctrl_rdata         (),
            .c0_ddr4_s_axi_ctrl_rresp         (),
            // Interrupt output
            .c0_ddr4_interrupt                (),
            // Slave Interface Write Address Ports
            .c0_ddr4_aresetn                  (c0_ddr4_aresetn),
            .c0_ddr4_s_axi_awid               (C0_DDR4_S_AXI_awid),
            .c0_ddr4_s_axi_awaddr             (C0_DDR4_S_AXI_awaddr),
            .c0_ddr4_s_axi_awlen              (C0_DDR4_S_AXI_awlen),
            .c0_ddr4_s_axi_awsize             (C0_DDR4_S_AXI_awsize),
            .c0_ddr4_s_axi_awburst            (C0_DDR4_S_AXI_awburst),
            .c0_ddr4_s_axi_awlock             (C0_DDR4_S_AXI_awlock),
            .c0_ddr4_s_axi_awcache            (C0_DDR4_S_AXI_awcache),
            .c0_ddr4_s_axi_awprot             (C0_DDR4_S_AXI_awprot),
            .c0_ddr4_s_axi_awqos              (C0_DDR4_S_AXI_awqos),
            .c0_ddr4_s_axi_awvalid            (C0_DDR4_S_AXI_awvalid),
            .c0_ddr4_s_axi_awready            (C0_DDR4_S_AXI_awready),
            // Slave Interface Write Data Ports
            .c0_ddr4_s_axi_wdata              (C0_DDR4_S_AXI_wdata),
            .c0_ddr4_s_axi_wstrb              (C0_DDR4_S_AXI_wstrb),
            .c0_ddr4_s_axi_wlast              (C0_DDR4_S_AXI_wlast),
            .c0_ddr4_s_axi_wvalid             (C0_DDR4_S_AXI_wvalid),
            .c0_ddr4_s_axi_wready             (C0_DDR4_S_AXI_wready),
            // Slave Interface Write Response Ports
            .c0_ddr4_s_axi_bid                (C0_DDR4_S_AXI_bid),
            .c0_ddr4_s_axi_bresp              (C0_DDR4_S_AXI_bresp),
            .c0_ddr4_s_axi_bvalid             (C0_DDR4_S_AXI_bvalid),
            .c0_ddr4_s_axi_bready             (C0_DDR4_S_AXI_bready),
            // Slave Interface Read Address Ports
            .c0_ddr4_s_axi_arid               (C0_DDR4_S_AXI_arid),
            .c0_ddr4_s_axi_araddr             (C0_DDR4_S_AXI_araddr),
            .c0_ddr4_s_axi_arlen              (C0_DDR4_S_AXI_arlen),
            .c0_ddr4_s_axi_arsize             (C0_DDR4_S_AXI_arsize),
            .c0_ddr4_s_axi_arburst            (C0_DDR4_S_AXI_arburst),
            .c0_ddr4_s_axi_arlock             (C0_DDR4_S_AXI_arlock),
            .c0_ddr4_s_axi_arcache            (C0_DDR4_S_AXI_arcache),
            .c0_ddr4_s_axi_arprot             (C0_DDR4_S_AXI_arprot),
            .c0_ddr4_s_axi_arqos              (C0_DDR4_S_AXI_arqos),
            .c0_ddr4_s_axi_arvalid            (C0_DDR4_S_AXI_arvalid),
            .c0_ddr4_s_axi_arready            (C0_DDR4_S_AXI_arready),
            // Slave Interface Read Data Ports
            .c0_ddr4_s_axi_rid                (C0_DDR4_S_AXI_rid),
            .c0_ddr4_s_axi_rdata              (C0_DDR4_S_AXI_rdata),
            .c0_ddr4_s_axi_rresp              (C0_DDR4_S_AXI_rresp),
            .c0_ddr4_s_axi_rlast              (C0_DDR4_S_AXI_rlast),
            .c0_ddr4_s_axi_rvalid             (C0_DDR4_S_AXI_rvalid),
            .c0_ddr4_s_axi_rready             (C0_DDR4_S_AXI_rready),

            // Debug Port
            .dbg_bus                          ()
         );
      `else
      //APP_DDR_MIG
         ddr4_0 u_ddr4_0(
            .sys_rst                    (reset_rtl),
            .c0_sys_clk_p               (C0_SYS_CLK_clk_p),
            .c0_sys_clk_n               (C0_SYS_CLK_clk_n),
            .c0_ddr4_act_n              (C0_DDR4_act_n),
            .c0_ddr4_adr                (C0_DDR4_adr),
            .c0_ddr4_ba                 (C0_DDR4_ba),
            .c0_ddr4_bg                 (C0_DDR4_bg),
            .c0_ddr4_cke                (C0_DDR4_cke),
            .c0_ddr4_odt                (C0_DDR4_odt),
            .c0_ddr4_cs_n               (C0_DDR4_cs_n),
            .c0_ddr4_ck_t               (C0_DDR4_ck_t),
            .c0_ddr4_ck_c               (C0_DDR4_ck_c),
            .c0_ddr4_reset_n            (C0_DDR4_reset_n),
            .c0_ddr4_dm_dbi_n           (C0_DDR4_dm_n),
            .c0_ddr4_dq                 (C0_DDR4_dq),
            .c0_ddr4_dqs_c              (C0_DDR4_dqs_c),
            .c0_ddr4_dqs_t              (C0_DDR4_dqs_t),

            .c0_init_calib_complete     (c0_init_calib_complete),
            .c0_ddr4_app_correct_en_i   (c0_ddr4_app_correct_en_i),
            .c0_ddr4_ecc_err_addr       (c0_ddr4_ecc_err_addr),
            .c0_ddr4_ecc_single         (c0_ddr4_ecc_single),
            .c0_ddr4_ecc_multiple       (c0_ddr4_ecc_multiple),
            .c0_ddr4_ui_clk             (c0_ddr4_ui_clk),
            .c0_ddr4_ui_clk_sync_rst    (c0_ddr4_ui_clk_sync_rst),
            .dbg_clk                    (c0_dbg_clk),
            .c0_ddr4_app_addr           (c0_ddr4_app_addr),
            .c0_ddr4_app_cmd            (c0_ddr4_app_cmd),
            .c0_ddr4_app_en             (c0_ddr4_app_en),
            .c0_ddr4_app_hi_pri         (c0_ddr4_app_hi_pri),
            .c0_ddr4_app_wdf_data       (c0_ddr4_app_wdf_data),
            .c0_ddr4_app_wdf_end        (c0_ddr4_app_wdf_end),
            .c0_ddr4_app_wdf_mask       (c0_ddr4_app_wdf_mask),
            .c0_ddr4_app_wdf_wren       (c0_ddr4_app_wdf_wren),
            .c0_ddr4_app_rd_data        (c0_ddr4_app_rd_data),
            .c0_ddr4_app_rd_data_end    (c0_ddr4_app_rd_data_end),
            .c0_ddr4_app_rd_data_valid  (c0_ddr4_app_rd_data_valid),
            .c0_ddr4_app_rdy            (c0_ddr4_app_rdy),
            .c0_ddr4_app_wdf_rdy        (c0_ddr4_app_wdf_rdy),
            // Debug Port
            .dbg_bus                    (c0_dbg_bus)
          );
      `endif
   `endif
`endif  // USE_DDR4_C0


`ifdef USE_DDR4_C1
   `ifdef FAST_SIM
      `ifdef AXI_DDR
      //AXI fast sim
         wire   [DATA_WIDTH-1:0]  mem1_wr_data;
         wire   [MASK_WIDTH-1:0]  mem1_wr_datastrb;
         wire   [ADDR_WIDTH-1:0]  mem1_wr_addr;
         wire   [DATA_WIDTH-1:0]  mem1_rd_data;
         wire                     mem1_rd_data_vld;
         wire                     mem1_rd_en;
         wire   [ADDR_WIDTH-1:0]  mem1_rd_addr;
         reg                      c1_rst_r;
         reg                      c1_rst_n_r;

         always @ (posedge C1_SYS_CLK_clk_n) begin
            c1_rst_r   <= reset_rtl || ~c1_ddr4_aresetn;
            c1_rst_n_r <= ~reset_rtl && c1_ddr4_aresetn;
         end

         assign c1_ddr4_ui_clk             = C1_SYS_CLK_clk_n;
         assign c1_ddr4_ui_clk_sync_rst    = c1_rst_r;
         assign c1_init_calib_complete     = c1_rst_n_r;

         assign C1_DDR4_S_AXI_CTRL_arready = 1'b0;
         assign C1_DDR4_S_AXI_CTRL_awready = 1'b0;
         assign C1_DDR4_S_AXI_CTRL_bvalid  = 1'b0;
         assign C1_DDR4_S_AXI_CTRL_rvalid  = 1'b0;
         assign C1_DDR4_S_AXI_CTRL_wready  = 1'b0;

         axi_slave_bfm #(
            .DATA_WIDTH(DATA_WIDTH),
            .ADDR_WIDTH('d31),
            .MASK_WIDTH(MASK_WIDTH),
            .ID_WIDTH(ID_WIDTH)
         )axi_slave_bfm_c1(
            .clk(c1_ddr4_ui_clk),
            .rst(c1_ddr4_ui_clk_sync_rst),

            // AXI Master AW channel
            .araddr(C1_DDR4_S_AXI_araddr),
            .arburst(C1_DDR4_S_AXI_arburst),
            .arcache(C1_DDR4_S_AXI_arcache),
            .arid(C1_DDR4_S_AXI_arid),
            .arlen(C1_DDR4_S_AXI_arlen),
            .arlock(C1_DDR4_S_AXI_arlock),
            .arprot(C1_DDR4_S_AXI_arprot),
            .arqos(C1_DDR4_S_AXI_arqos),
            .arregion(C1_DDR4_S_AXI_arregion),
            .arready(C1_DDR4_S_AXI_arready),
            .arsize(C1_DDR4_S_AXI_arsize),
            .arvalid(C1_DDR4_S_AXI_arvalid),
            // AXI Master AR channel
            .awaddr(C1_DDR4_S_AXI_awaddr),
            .awburst(C1_DDR4_S_AXI_awburst),
            .awcache(C1_DDR4_S_AXI_awcache),
            .awid(C1_DDR4_S_AXI_awid),
            .awlen(C1_DDR4_S_AXI_awlen),
            .awlock(C1_DDR4_S_AXI_awlock),
            .awprot(C1_DDR4_S_AXI_awprot),
            .awqos(C1_DDR4_S_AXI_awqos),
            .awregion(C1_DDR4_S_AXI_awregion),
            .awready(C1_DDR4_S_AXI_awready),
            .awsize(C1_DDR4_S_AXI_awsize),
            .awvalid(C1_DDR4_S_AXI_awvalid),
            // AXI Master B channel
            .bid(C1_DDR4_S_AXI_bid),
            .bready(C1_DDR4_S_AXI_bready),
            .bresp(C1_DDR4_S_AXI_bresp),
            .bvalid(C1_DDR4_S_AXI_bvalid),
            // AXI Master R channel
            .rdata(C1_DDR4_S_AXI_rdata),
            .rid(C1_DDR4_S_AXI_rid),
            .rlast(C1_DDR4_S_AXI_rlast),
            .rready(C1_DDR4_S_AXI_rready),
            .rresp(C1_DDR4_S_AXI_rresp),
            .rvalid(C1_DDR4_S_AXI_rvalid),
            // AXI Master W channel
            .wdata(C1_DDR4_S_AXI_wdata),
            .wlast(C1_DDR4_S_AXI_wlast),
            .wready(C1_DDR4_S_AXI_wready),
            .wstrb(C1_DDR4_S_AXI_wstrb),
            .wvalid(C1_DDR4_S_AXI_wvalid),

            // Card Memory Interface
            .mem_wr_cmd_rdy(1'b1),
            .mem_wr_data(mem1_wr_data),
            .mem_wr_datastrb(mem1_wr_datastrb),
            .mem_wr_addr(mem1_wr_addr),
            .mem_rd_cmd_rdy(1'b1),
            .mem_rd_data(mem1_rd_data),
            .mem_rd_data_vld(mem1_rd_data_vld),
            .mem_rd_en(mem1_rd_en),
            .mem_rd_addr(mem1_rd_addr)
         );

         //card memory
         mem_2ports #(
            .DATA_WIDTH(DATA_WIDTH),
            .ADDR_WIDTH(ADDR_WIDTH),
            .HOST_MEM_SIZE(HOST_MEM_SIZE_PER_CHANNEL)
         )card_mem_1(
            .clk(c1_ddr4_ui_clk),
            .rst(c1_ddr4_ui_clk_sync_rst),

            .c1_wr_data(mem1_wr_data),
            .c1_wr_datastrb(mem1_wr_datastrb),
            .c1_wr_addr(mem1_wr_addr),
            .c1_rd_data(mem1_rd_data),
            .c1_rd_data_vld(mem1_rd_data_vld),
            .c1_rd_en(mem1_rd_en),
            .c1_rd_addr(mem1_rd_addr),

            .c2_wr_data(),
            .c2_wr_datastrb(64'd0),
            .c2_wr_addr(),
            .c2_rd_data(),
            .c2_rd_data_vld(),
            .c2_rd_en(1'b0),
            .c2_rd_addr()
         );
      `else
      //APP fast sim
         mig_dummy mig_dummy_1(
            .c0_init_calib_complete     (c1_init_calib_complete),
            .c0_ddr4_app_correct_en_i   (c1_ddr4_app_correct_en_i),
            .c0_ddr4_ecc_err_addr       (c1_ddr4_ecc_err_addr),
            .c0_ddr4_ecc_single         (c1_ddr4_ecc_single),
            .c0_ddr4_ecc_multiple       (c1_ddr4_ecc_multiple),
            .c0_ddr4_ui_clk             (c1_ddr4_ui_clk),
            .c0_ddr4_ui_clk_sync_rst    (c1_ddr4_ui_clk_sync_rst),
            .dbg_clk                    (c1_dbg_clk),
            .c0_ddr4_app_addr           (c1_ddr4_app_addr),
            .c0_ddr4_app_cmd            (c1_ddr4_app_cmd),
            .c0_ddr4_app_en             (c1_ddr4_app_en),
            .c0_ddr4_app_hi_pri         (c1_ddr4_app_hi_pri),
            .c0_ddr4_app_wdf_data       (c1_ddr4_app_wdf_data),
            .c0_ddr4_app_wdf_end        (c1_ddr4_app_wdf_end),
            .c0_ddr4_app_wdf_mask       (c1_ddr4_app_wdf_mask),
            .c0_ddr4_app_wdf_wren       (c1_ddr4_app_wdf_wren),
            .c0_ddr4_app_rd_data        (c1_ddr4_app_rd_data),
            .c0_ddr4_app_rd_data_end    (c1_ddr4_app_rd_data_end),
            .c0_ddr4_app_rd_data_valid  (c1_ddr4_app_rd_data_valid),
            .c0_ddr4_app_rdy            (c1_ddr4_app_rdy),
            .c0_ddr4_app_wdf_rdy        (c1_ddr4_app_wdf_rdy),
            // Debug Port
            .dbg_bus                    (c1_dbg_bus)
         );
      `endif
   `else
      `ifdef AXI_DDR
      // AXI_DDR_MIG
         ddr4_0 u_ddr4_1
           (
            .sys_rst                          (reset_rtl),

            .c0_sys_clk_p                     (C1_SYS_CLK_clk_p),
            .c0_sys_clk_n                     (C1_SYS_CLK_clk_n),
            .c0_init_calib_complete           (c1_init_calib_complete),
            .c0_ddr4_act_n                    (C1_DDR4_act_n),
            .c0_ddr4_adr                      (C1_DDR4_adr),
            .c0_ddr4_ba                       (C1_DDR4_ba),
            .c0_ddr4_bg                       (C1_DDR4_bg),
            .c0_ddr4_cke                      (C1_DDR4_cke),
            .c0_ddr4_odt                      (C1_DDR4_odt),
            .c0_ddr4_cs_n                     (C1_DDR4_cs_n),
            .c0_ddr4_ck_t                     (C1_DDR4_ck_t),
            .c0_ddr4_ck_c                     (C1_DDR4_ck_c),
            .c0_ddr4_reset_n                  (C1_DDR4_reset_n),

            .c0_ddr4_dm_dbi_n                 (C1_DDR4_dm_n),
            .c0_ddr4_dq                       (C1_DDR4_dq),
            .c0_ddr4_dqs_c                    (C1_DDR4_dqs_c),
            .c0_ddr4_dqs_t                    (C1_DDR4_dqs_t),

            .c0_ddr4_ui_clk                   (c1_ddr4_ui_clk),
            .c0_ddr4_ui_clk_sync_rst          (c1_ddr4_ui_clk_sync_rst),
            .dbg_clk                          (),
            // AXI CTRL port
            .c0_ddr4_s_axi_ctrl_awvalid       (1'b0),
            .c0_ddr4_s_axi_ctrl_awready       (),
            .c0_ddr4_s_axi_ctrl_awaddr        (32'b0),
            // Slave Interface Write Data Ports
            .c0_ddr4_s_axi_ctrl_wvalid        (1'b0),
            .c0_ddr4_s_axi_ctrl_wready        (),
            .c0_ddr4_s_axi_ctrl_wdata         (32'b0),
            // Slave Interface Write Response Ports
            .c0_ddr4_s_axi_ctrl_bvalid        (),
            .c0_ddr4_s_axi_ctrl_bready        (1'b1),
            .c0_ddr4_s_axi_ctrl_bresp         (),
            // Slave Interface Read Address Ports
            .c0_ddr4_s_axi_ctrl_arvalid       (1'b0),
            .c0_ddr4_s_axi_ctrl_arready       (),
            .c0_ddr4_s_axi_ctrl_araddr        (32'b0),
            // Slave Interface Read Data Ports
            .c0_ddr4_s_axi_ctrl_rvalid        (),
            .c0_ddr4_s_axi_ctrl_rready        (1'b1),
            .c0_ddr4_s_axi_ctrl_rdata         (),
            .c0_ddr4_s_axi_ctrl_rresp         (),
            // Interrupt output
            .c0_ddr4_interrupt                (),
            // Slave Interface Write Address Ports
            .c0_ddr4_aresetn                  (c1_ddr4_aresetn),
            .c0_ddr4_s_axi_awid               (C1_DDR4_S_AXI_awid),
            .c0_ddr4_s_axi_awaddr             (C1_DDR4_S_AXI_awaddr),
            .c0_ddr4_s_axi_awlen              (C1_DDR4_S_AXI_awlen),
            .c0_ddr4_s_axi_awsize             (C1_DDR4_S_AXI_awsize),
            .c0_ddr4_s_axi_awburst            (C1_DDR4_S_AXI_awburst),
            .c0_ddr4_s_axi_awlock             (C1_DDR4_S_AXI_awlock),
            .c0_ddr4_s_axi_awcache            (C1_DDR4_S_AXI_awcache),
            .c0_ddr4_s_axi_awprot             (C1_DDR4_S_AXI_awprot),
            .c0_ddr4_s_axi_awqos              (C1_DDR4_S_AXI_awqos),
            .c0_ddr4_s_axi_awvalid            (C1_DDR4_S_AXI_awvalid),
            .c0_ddr4_s_axi_awready            (C1_DDR4_S_AXI_awready),
            // Slave Interface Write Data Ports
            .c0_ddr4_s_axi_wdata              (C1_DDR4_S_AXI_wdata),
            .c0_ddr4_s_axi_wstrb              (C1_DDR4_S_AXI_wstrb),
            .c0_ddr4_s_axi_wlast              (C1_DDR4_S_AXI_wlast),
            .c0_ddr4_s_axi_wvalid             (C1_DDR4_S_AXI_wvalid),
            .c0_ddr4_s_axi_wready             (C1_DDR4_S_AXI_wready),
            // Slave Interface Write Response Po1ts
            .c0_ddr4_s_axi_bid                (C1_DDR4_S_AXI_bid),
            .c0_ddr4_s_axi_bresp              (C1_DDR4_S_AXI_bresp),
            .c0_ddr4_s_axi_bvalid             (C1_DDR4_S_AXI_bvalid),
            .c0_ddr4_s_axi_bready             (C1_DDR4_S_AXI_bready),
            // Slave Interface Read Address Port1
            .c0_ddr4_s_axi_arid               (C1_DDR4_S_AXI_arid),
            .c0_ddr4_s_axi_araddr             (C1_DDR4_S_AXI_araddr),
            .c0_ddr4_s_axi_arlen              (C1_DDR4_S_AXI_arlen),
            .c0_ddr4_s_axi_arsize             (C1_DDR4_S_AXI_arsize),
            .c0_ddr4_s_axi_arburst            (C1_DDR4_S_AXI_arburst),
            .c0_ddr4_s_axi_arlock             (C1_DDR4_S_AXI_arlock),
            .c0_ddr4_s_axi_arcache            (C1_DDR4_S_AXI_arcache),
            .c0_ddr4_s_axi_arprot             (C1_DDR4_S_AXI_arprot),
            .c0_ddr4_s_axi_arqos              (C1_DDR4_S_AXI_arqos),
            .c0_ddr4_s_axi_arvalid            (C1_DDR4_S_AXI_arvalid),
            .c0_ddr4_s_axi_arready            (C1_DDR4_S_AXI_arready),
            // Slave Interface Read Data Ports
            .c0_ddr4_s_axi_rid                (C1_DDR4_S_AXI_rid),
            .c0_ddr4_s_axi_rdata              (C1_DDR4_S_AXI_rdata),
            .c0_ddr4_s_axi_rresp              (C1_DDR4_S_AXI_rresp),
            .c0_ddr4_s_axi_rlast              (C1_DDR4_S_AXI_rlast),
            .c0_ddr4_s_axi_rvalid             (C1_DDR4_S_AXI_rvalid),
            .c0_ddr4_s_axi_rready             (C1_DDR4_S_AXI_rready),

            // Debug Port
            .dbg_bus                          ()
         );
      `else
      //APP_DDR_MIG
         ddr4_0 u_ddr4_1(
            .sys_rst                    (reset_rtl),
            .c0_sys_clk_p               (C1_SYS_CLK_clk_p),
            .c0_sys_clk_n               (C1_SYS_CLK_clk_n),
            .c0_ddr4_act_n              (C1_DDR4_act_n),
            .c0_ddr4_adr                (C1_DDR4_adr),
            .c0_ddr4_ba                 (C1_DDR4_ba),
            .c0_ddr4_bg                 (C1_DDR4_bg),
            .c0_ddr4_cke                (C1_DDR4_cke),
            .c0_ddr4_odt                (C1_DDR4_odt),
            .c0_ddr4_cs_n               (C1_DDR4_cs_n),
            .c0_ddr4_ck_t               (C1_DDR4_ck_t),
            .c0_ddr4_ck_c               (C1_DDR4_ck_c),
            .c0_ddr4_reset_n            (C1_DDR4_reset_n),
            .c0_ddr4_dm_dbi_n           (C1_DDR4_dm_n),
            .c0_ddr4_dq                 (C1_DDR4_dq),
            .c0_ddr4_dqs_c              (C1_DDR4_dqs_c),
            .c0_ddr4_dqs_t              (C1_DDR4_dqs_t),

            .c0_init_calib_complete     (c1_init_calib_complete),
            .c0_ddr4_app_correct_en_i   (c1_ddr4_app_correct_en_i),
            .c0_ddr4_ecc_err_addr       (c1_ddr4_ecc_err_addr),
            .c0_ddr4_ecc_single         (c1_ddr4_ecc_single),
            .c0_ddr4_ecc_multiple       (c1_ddr4_ecc_multiple),
            .c0_ddr4_ui_clk             (c1_ddr4_ui_clk),
            .c0_ddr4_ui_clk_sync_rst    (c1_ddr4_ui_clk_sync_rst),
            .dbg_clk                    (c1_dbg_clk),
            .c0_ddr4_app_addr           (c1_ddr4_app_addr),
            .c0_ddr4_app_cmd            (c1_ddr4_app_cmd),
            .c0_ddr4_app_en             (c1_ddr4_app_en),
            .c0_ddr4_app_hi_pri         (c1_ddr4_app_hi_pri),
            .c0_ddr4_app_wdf_data       (c1_ddr4_app_wdf_data),
            .c0_ddr4_app_wdf_end        (c1_ddr4_app_wdf_end),
            .c0_ddr4_app_wdf_mask       (c1_ddr4_app_wdf_mask),
            .c0_ddr4_app_wdf_wren       (c1_ddr4_app_wdf_wren),
            .c0_ddr4_app_rd_data        (c1_ddr4_app_rd_data),
            .c0_ddr4_app_rd_data_end    (c1_ddr4_app_rd_data_end),
            .c0_ddr4_app_rd_data_valid  (c1_ddr4_app_rd_data_valid),
            .c0_ddr4_app_rdy            (c1_ddr4_app_rdy),
            .c0_ddr4_app_wdf_rdy        (c1_ddr4_app_wdf_rdy),
            // Debug Port
            .dbg_bus                    (c1_dbg_bus)
          );
       `endif
   `endif
`endif  // USE_DDR4_C1

`ifdef USE_DDR4_C2
   `ifdef FAST_SIM
      `ifdef AXI_DDR
      //AXI fast sim
         wire   [DATA_WIDTH-1:0]  mem2_wr_data;
         wire   [MASK_WIDTH-1:0]  mem2_wr_datastrb;
         wire   [ADDR_WIDTH-1:0]  mem2_wr_addr;
         wire   [DATA_WIDTH-1:0]  mem2_rd_data;
         wire                     mem2_rd_data_vld;
         wire                     mem2_rd_en;
         wire   [ADDR_WIDTH-1:0]  mem2_rd_addr;
         reg                      c2_rst_r;
         reg                      c2_rst_n_r;

         always @ (posedge C2_SYS_CLK_clk_n) begin
            c2_rst_r   <= reset_rtl || ~c2_ddr4_aresetn;
            c2_rst_n_r <= ~reset_rtl && c2_ddr4_aresetn;
         end

         assign c2_ddr4_ui_clk             = C2_SYS_CLK_clk_n;
         assign c2_ddr4_ui_clk_sync_rst    = c2_rst_r;
         assign c2_init_calib_complete     = c2_rst_n_r;

         assign C2_DDR4_S_AXI_CTRL_arready = 1'b0;
         assign C2_DDR4_S_AXI_CTRL_awready = 1'b0;
         assign C2_DDR4_S_AXI_CTRL_bvalid  = 1'b0;
         assign C2_DDR4_S_AXI_CTRL_rvalid  = 1'b0;
         assign C2_DDR4_S_AXI_CTRL_wready  = 1'b0;

         axi_slave_bfm #(
            .DATA_WIDTH(DATA_WIDTH),
            .ADDR_WIDTH('d31),
            .MASK_WIDTH(MASK_WIDTH),
            .ID_WIDTH(ID_WIDTH)
         )axi_slave_bfm_c2(
            .clk(c2_ddr4_ui_clk),
            .rst(c2_ddr4_ui_clk_sync_rst),

            // AXI Master AW channel
            .araddr(C2_DDR4_S_AXI_araddr),
            .arburst(C2_DDR4_S_AXI_arburst),
            .arcache(C2_DDR4_S_AXI_arcache),
            .arid(C2_DDR4_S_AXI_arid),
            .arlen(C2_DDR4_S_AXI_arlen),
            .arlock(C2_DDR4_S_AXI_arlock),
            .arprot(C2_DDR4_S_AXI_arprot),
            .arqos(C2_DDR4_S_AXI_arqos),
            .arregion(C2_DDR4_S_AXI_arregion),
            .arready(C2_DDR4_S_AXI_arready),
            .arsize(C2_DDR4_S_AXI_arsize),
            .arvalid(C2_DDR4_S_AXI_arvalid),
            // AXI Master AR channel
            .awaddr(C2_DDR4_S_AXI_awaddr),
            .awburst(C2_DDR4_S_AXI_awburst),
            .awcache(C2_DDR4_S_AXI_awcache),
            .awid(C2_DDR4_S_AXI_awid),
            .awlen(C2_DDR4_S_AXI_awlen),
            .awlock(C2_DDR4_S_AXI_awlock),
            .awprot(C2_DDR4_S_AXI_awprot),
            .awqos(C2_DDR4_S_AXI_awqos),
            .awregion(C2_DDR4_S_AXI_awregion),
            .awready(C2_DDR4_S_AXI_awready),
            .awsize(C2_DDR4_S_AXI_awsize),
            .awvalid(C2_DDR4_S_AXI_awvalid),
            // AXI Master B channel
            .bid(C2_DDR4_S_AXI_bid),
            .bready(C2_DDR4_S_AXI_bready),
            .bresp(C2_DDR4_S_AXI_bresp),
            .bvalid(C2_DDR4_S_AXI_bvalid),
            // AXI Master R channel
            .rdata(C2_DDR4_S_AXI_rdata),
            .rid(C2_DDR4_S_AXI_rid),
            .rlast(C2_DDR4_S_AXI_rlast),
            .rready(C2_DDR4_S_AXI_rready),
            .rresp(C2_DDR4_S_AXI_rresp),
            .rvalid(C2_DDR4_S_AXI_rvalid),
            // AXI Master W channel
            .wdata(C2_DDR4_S_AXI_wdata),
            .wlast(C2_DDR4_S_AXI_wlast),
            .wready(C2_DDR4_S_AXI_wready),
            .wstrb(C2_DDR4_S_AXI_wstrb),
            .wvalid(C2_DDR4_S_AXI_wvalid),

            // Card Memory Interface
            .mem_wr_cmd_rdy(1'b1),
            .mem_wr_data(mem2_wr_data),
            .mem_wr_datastrb(mem2_wr_datastrb),
            .mem_wr_addr(mem2_wr_addr),
            .mem_rd_cmd_rdy(1'b1),
            .mem_rd_data(mem2_rd_data),
            .mem_rd_data_vld(mem2_rd_data_vld),
            .mem_rd_en(mem2_rd_en),
            .mem_rd_addr(mem2_rd_addr)
         );

         //card memory
         mem_2ports #(
            .DATA_WIDTH(DATA_WIDTH),
            .ADDR_WIDTH(ADDR_WIDTH),
            .HOST_MEM_SIZE(HOST_MEM_SIZE_PER_CHANNEL)
         )card_mem_2(
            .clk(c2_ddr4_ui_clk),
            .rst(c2_ddr4_ui_clk_sync_rst),

            .c1_wr_data(mem2_wr_data),
            .c1_wr_datastrb(mem2_wr_datastrb),
            .c1_wr_addr(mem2_wr_addr),
            .c1_rd_data(mem2_rd_data),
            .c1_rd_data_vld(mem2_rd_data_vld),
            .c1_rd_en(mem2_rd_en),
            .c1_rd_addr(mem2_rd_addr),

            .c2_wr_data(),
            .c2_wr_datastrb(64'd0),
            .c2_wr_addr(),
            .c2_rd_data(),
            .c2_rd_data_vld(),
            .c2_rd_en(1'b0),
            .c2_rd_addr()
         );
      `else
      //APP fast sim
         mig_dummy mig_dummy_2(
            .c0_init_calib_complete     (c2_init_calib_complete),
            .c0_ddr4_app_correct_en_i   (c2_ddr4_app_correct_en_i),
            .c0_ddr4_ecc_err_addr       (c2_ddr4_ecc_err_addr),
            .c0_ddr4_ecc_single         (c2_ddr4_ecc_single),
            .c0_ddr4_ecc_multiple       (c2_ddr4_ecc_multiple),
            .c0_ddr4_ui_clk             (c2_ddr4_ui_clk),
            .c0_ddr4_ui_clk_sync_rst    (c2_ddr4_ui_clk_sync_rst),
            .dbg_clk                    (c2_dbg_clk),
            .c0_ddr4_app_addr           (c2_ddr4_app_addr),
            .c0_ddr4_app_cmd            (c2_ddr4_app_cmd),
            .c0_ddr4_app_en             (c2_ddr4_app_en),
            .c0_ddr4_app_hi_pri         (c2_ddr4_app_hi_pri),
            .c0_ddr4_app_wdf_data       (c2_ddr4_app_wdf_data),
            .c0_ddr4_app_wdf_end        (c2_ddr4_app_wdf_end),
            .c0_ddr4_app_wdf_mask       (c2_ddr4_app_wdf_mask),
            .c0_ddr4_app_wdf_wren       (c2_ddr4_app_wdf_wren),
            .c0_ddr4_app_rd_data        (c2_ddr4_app_rd_data),
            .c0_ddr4_app_rd_data_end    (c2_ddr4_app_rd_data_end),
            .c0_ddr4_app_rd_data_valid  (c2_ddr4_app_rd_data_valid),
            .c0_ddr4_app_rdy            (c2_ddr4_app_rdy),
            .c0_ddr4_app_wdf_rdy        (c2_ddr4_app_wdf_rdy),
            // Debug Port
            .dbg_bus                    (c2_dbg_bus)
         );
      `endif
   `else
      `ifdef AXI_DDR
      // AXI_DDR_MIG
         ddr4_0 u_ddr4_2
           (
            .sys_rst                          (reset_rtl),

            .c0_sys_clk_p                     (C2_SYS_CLK_clk_p),
            .c0_sys_clk_n                     (C2_SYS_CLK_clk_n),
            .c0_init_calib_complete           (c2_init_calib_complete),
            .c0_ddr4_act_n                    (C2_DDR4_act_n),
            .c0_ddr4_adr                      (C2_DDR4_adr),
            .c0_ddr4_ba                       (C2_DDR4_ba),
            .c0_ddr4_bg                       (C2_DDR4_bg),
            .c0_ddr4_cke                      (C2_DDR4_cke),
            .c0_ddr4_odt                      (C2_DDR4_odt),
            .c0_ddr4_cs_n                     (C2_DDR4_cs_n),
            .c0_ddr4_ck_t                     (C2_DDR4_ck_t),
            .c0_ddr4_ck_c                     (C2_DDR4_ck_c),
            .c0_ddr4_reset_n                  (C2_DDR4_reset_n),

            .c0_ddr4_dm_dbi_n                 (C2_DDR4_dm_n),
            .c0_ddr4_dq                       (C2_DDR4_dq),
            .c0_ddr4_dqs_c                    (C2_DDR4_dqs_c),
            .c0_ddr4_dqs_t                    (C2_DDR4_dqs_t),

            .c0_ddr4_ui_clk                   (c2_ddr4_ui_clk),
            .c0_ddr4_ui_clk_sync_rst          (c2_ddr4_ui_clk_sync_rst),
            .dbg_clk                          (),
            // AXI CTRL port
            .c0_ddr4_s_axi_ctrl_awvalid       (1'b0),
            .c0_ddr4_s_axi_ctrl_awready       (),
            .c0_ddr4_s_axi_ctrl_awaddr        (32'b0),
            // Slave Interface Write Data Ports
            .c0_ddr4_s_axi_ctrl_wvalid        (1'b0),
            .c0_ddr4_s_axi_ctrl_wready        (),
            .c0_ddr4_s_axi_ctrl_wdata         (32'b0),
            // Slave Interface Write Response Ports
            .c0_ddr4_s_axi_ctrl_bvalid        (),
            .c0_ddr4_s_axi_ctrl_bready        (1'b1),
            .c0_ddr4_s_axi_ctrl_bresp         (),
            // Slave Interface Read Address Ports
            .c0_ddr4_s_axi_ctrl_arvalid       (1'b0),
            .c0_ddr4_s_axi_ctrl_arready       (),
            .c0_ddr4_s_axi_ctrl_araddr        (32'b0),
            // Slave Interface Read Data Ports
            .c0_ddr4_s_axi_ctrl_rvalid        (),
            .c0_ddr4_s_axi_ctrl_rready        (1'b1),
            .c0_ddr4_s_axi_ctrl_rdata         (),
            .c0_ddr4_s_axi_ctrl_rresp         (),
            // Interrupt output
            .c0_ddr4_interrupt                (),
            // Slave Interface Write Address Ports
            .c0_ddr4_aresetn                  (c2_ddr4_aresetn),
            .c0_ddr4_s_axi_awid               (C2_DDR4_S_AXI_awid),
            .c0_ddr4_s_axi_awaddr             (C2_DDR4_S_AXI_awaddr),
            .c0_ddr4_s_axi_awlen              (C2_DDR4_S_AXI_awlen),
            .c0_ddr4_s_axi_awsize             (C2_DDR4_S_AXI_awsize),
            .c0_ddr4_s_axi_awburst            (C2_DDR4_S_AXI_awburst),
            .c0_ddr4_s_axi_awlock             (C2_DDR4_S_AXI_awlock),
            .c0_ddr4_s_axi_awcache            (C2_DDR4_S_AXI_awcache),
            .c0_ddr4_s_axi_awprot             (C2_DDR4_S_AXI_awprot),
            .c0_ddr4_s_axi_awqos              (C2_DDR4_S_AXI_awqos),
            .c0_ddr4_s_axi_awvalid            (C2_DDR4_S_AXI_awvalid),
            .c0_ddr4_s_axi_awready            (C2_DDR4_S_AXI_awready),
            // Slave Interface Write Data Ports
            .c0_ddr4_s_axi_wdata              (C2_DDR4_S_AXI_wdata),
            .c0_ddr4_s_axi_wstrb              (C2_DDR4_S_AXI_wstrb),
            .c0_ddr4_s_axi_wlast              (C2_DDR4_S_AXI_wlast),
            .c0_ddr4_s_axi_wvalid             (C2_DDR4_S_AXI_wvalid),
            .c0_ddr4_s_axi_wready             (C2_DDR4_S_AXI_wready),
            // Slave Interface Write Response Po2ts
            .c0_ddr4_s_axi_bid                (C2_DDR4_S_AXI_bid),
            .c0_ddr4_s_axi_bresp              (C2_DDR4_S_AXI_bresp),
            .c0_ddr4_s_axi_bvalid             (C2_DDR4_S_AXI_bvalid),
            .c0_ddr4_s_axi_bready             (C2_DDR4_S_AXI_bready),
            // Slave Interface Read Address Port2
            .c0_ddr4_s_axi_arid               (C2_DDR4_S_AXI_arid),
            .c0_ddr4_s_axi_araddr             (C2_DDR4_S_AXI_araddr),
            .c0_ddr4_s_axi_arlen              (C2_DDR4_S_AXI_arlen),
            .c0_ddr4_s_axi_arsize             (C2_DDR4_S_AXI_arsize),
            .c0_ddr4_s_axi_arburst            (C2_DDR4_S_AXI_arburst),
            .c0_ddr4_s_axi_arlock             (C2_DDR4_S_AXI_arlock),
            .c0_ddr4_s_axi_arcache            (C2_DDR4_S_AXI_arcache),
            .c0_ddr4_s_axi_arprot             (C2_DDR4_S_AXI_arprot),
            .c0_ddr4_s_axi_arqos              (C2_DDR4_S_AXI_arqos),
            .c0_ddr4_s_axi_arvalid            (C2_DDR4_S_AXI_arvalid),
            .c0_ddr4_s_axi_arready            (C2_DDR4_S_AXI_arready),
            // Slave Interface Read Data Ports
            .c0_ddr4_s_axi_rid                (C2_DDR4_S_AXI_rid),
            .c0_ddr4_s_axi_rdata              (C2_DDR4_S_AXI_rdata),
            .c0_ddr4_s_axi_rresp              (C2_DDR4_S_AXI_rresp),
            .c0_ddr4_s_axi_rlast              (C2_DDR4_S_AXI_rlast),
            .c0_ddr4_s_axi_rvalid             (C2_DDR4_S_AXI_rvalid),
            .c0_ddr4_s_axi_rready             (C2_DDR4_S_AXI_rready),

            // Debug Port
            .dbg_bus                          ()
         );
      `else
      //APP_DDR_MIG
         ddr4_0 u_ddr4_2(
            .sys_rst                    (reset_rtl),
            .c0_sys_clk_p               (C2_SYS_CLK_clk_p),
            .c0_sys_clk_n               (C2_SYS_CLK_clk_n),
            .c0_ddr4_act_n              (C2_DDR4_act_n),
            .c0_ddr4_adr                (C2_DDR4_adr),
            .c0_ddr4_ba                 (C2_DDR4_ba),
            .c0_ddr4_bg                 (C2_DDR4_bg),
            .c0_ddr4_cke                (C2_DDR4_cke),
            .c0_ddr4_odt                (C2_DDR4_odt),
            .c0_ddr4_cs_n               (C2_DDR4_cs_n),
            .c0_ddr4_ck_t               (C2_DDR4_ck_t),
            .c0_ddr4_ck_c               (C2_DDR4_ck_c),
            .c0_ddr4_reset_n            (C2_DDR4_reset_n),
            .c0_ddr4_dm_dbi_n           (C2_DDR4_dm_n),
            .c0_ddr4_dq                 (C2_DDR4_dq),
            .c0_ddr4_dqs_c              (C2_DDR4_dqs_c),
            .c0_ddr4_dqs_t              (C2_DDR4_dqs_t),

            .c0_init_calib_complete     (c2_init_calib_complete),
            .c0_ddr4_app_correct_en_i   (c2_ddr4_app_correct_en_i),
            .c0_ddr4_ecc_err_addr       (c2_ddr4_ecc_err_addr),
            .c0_ddr4_ecc_single         (c2_ddr4_ecc_single),
            .c0_ddr4_ecc_multiple       (c2_ddr4_ecc_multiple),
            .c0_ddr4_ui_clk             (c2_ddr4_ui_clk),
            .c0_ddr4_ui_clk_sync_rst    (c2_ddr4_ui_clk_sync_rst),
            .dbg_clk                    (c2_dbg_clk),
            .c0_ddr4_app_addr           (c2_ddr4_app_addr),
            .c0_ddr4_app_cmd            (c2_ddr4_app_cmd),
            .c0_ddr4_app_en             (c2_ddr4_app_en),
            .c0_ddr4_app_hi_pri         (c2_ddr4_app_hi_pri),
            .c0_ddr4_app_wdf_data       (c2_ddr4_app_wdf_data),
            .c0_ddr4_app_wdf_end        (c2_ddr4_app_wdf_end),
            .c0_ddr4_app_wdf_mask       (c2_ddr4_app_wdf_mask),
            .c0_ddr4_app_wdf_wren       (c2_ddr4_app_wdf_wren),
            .c0_ddr4_app_rd_data        (c2_ddr4_app_rd_data),
            .c0_ddr4_app_rd_data_end    (c2_ddr4_app_rd_data_end),
            .c0_ddr4_app_rd_data_valid  (c2_ddr4_app_rd_data_valid),
            .c0_ddr4_app_rdy            (c2_ddr4_app_rdy),
            .c0_ddr4_app_wdf_rdy        (c2_ddr4_app_wdf_rdy),
            // Debug Port
            .dbg_bus                    (c2_dbg_bus)
          );
      `endif
   `endif
`endif  // USE_DDR4_C2

`ifdef USE_DDR4_C3
   `ifdef FAST_SIM
      `ifdef AXI_DDR
      //AXI fast sim
         wire   [DATA_WIDTH-1:0]  mem3_wr_data;
         wire   [MASK_WIDTH-1:0]  mem3_wr_datastrb;
         wire   [ADDR_WIDTH-1:0]  mem3_wr_addr;
         wire   [DATA_WIDTH-1:0]  mem3_rd_data;
         wire                     mem3_rd_data_vld;
         wire                     mem3_rd_en;
         wire   [ADDR_WIDTH-1:0]  mem3_rd_addr;
         reg                      c3_rst_r;
         reg                      c3_rst_n_r;

         always @ (posedge C3_SYS_CLK_clk_n) begin
            c3_rst_r   <= reset_rtl || ~c3_ddr4_aresetn;
            c3_rst_n_r <= ~reset_rtl && c3_ddr4_aresetn;
         end

         assign c3_ddr4_ui_clk             = C3_SYS_CLK_clk_n;
         assign c3_ddr4_ui_clk_sync_rst    = c3_rst_r;
         assign c3_init_calib_complete     = c3_rst_n_r;

         assign C3_DDR4_S_AXI_CTRL_arready = 1'b0;
         assign C3_DDR4_S_AXI_CTRL_awready = 1'b0;
         assign C3_DDR4_S_AXI_CTRL_bvalid  = 1'b0;
         assign C3_DDR4_S_AXI_CTRL_rvalid  = 1'b0;
         assign C3_DDR4_S_AXI_CTRL_wready  = 1'b0;

         axi_slave_bfm #(
            .DATA_WIDTH(DATA_WIDTH),
            .ADDR_WIDTH('d31),
            .MASK_WIDTH(MASK_WIDTH),
            .ID_WIDTH(ID_WIDTH)
         )axi_slave_bfm_c3(
            .clk(c3_ddr4_ui_clk),
            .rst(c3_ddr4_ui_clk_sync_rst),

            // AXI Master AW channel
            .araddr(C3_DDR4_S_AXI_araddr),
            .arburst(C3_DDR4_S_AXI_arburst),
            .arcache(C3_DDR4_S_AXI_arcache),
            .arid(C3_DDR4_S_AXI_arid),
            .arlen(C3_DDR4_S_AXI_arlen),
            .arlock(C3_DDR4_S_AXI_arlock),
            .arprot(C3_DDR4_S_AXI_arprot),
            .arqos(C3_DDR4_S_AXI_arqos),
            .arregion(C3_DDR4_S_AXI_arregion),
            .arready(C3_DDR4_S_AXI_arready),
            .arsize(C3_DDR4_S_AXI_arsize),
            .arvalid(C3_DDR4_S_AXI_arvalid),
            // AXI Master AR channel
            .awaddr(C3_DDR4_S_AXI_awaddr),
            .awburst(C3_DDR4_S_AXI_awburst),
            .awcache(C3_DDR4_S_AXI_awcache),
            .awid(C3_DDR4_S_AXI_awid),
            .awlen(C3_DDR4_S_AXI_awlen),
            .awlock(C3_DDR4_S_AXI_awlock),
            .awprot(C3_DDR4_S_AXI_awprot),
            .awqos(C3_DDR4_S_AXI_awqos),
            .awregion(C3_DDR4_S_AXI_awregion),
            .awready(C3_DDR4_S_AXI_awready),
            .awsize(C3_DDR4_S_AXI_awsize),
            .awvalid(C3_DDR4_S_AXI_awvalid),
            // AXI Master B channel
            .bid(C3_DDR4_S_AXI_bid),
            .bready(C3_DDR4_S_AXI_bready),
            .bresp(C3_DDR4_S_AXI_bresp),
            .bvalid(C3_DDR4_S_AXI_bvalid),
            // AXI Master R channel
            .rdata(C3_DDR4_S_AXI_rdata),
            .rid(C3_DDR4_S_AXI_rid),
            .rlast(C3_DDR4_S_AXI_rlast),
            .rready(C3_DDR4_S_AXI_rready),
            .rresp(C3_DDR4_S_AXI_rresp),
            .rvalid(C3_DDR4_S_AXI_rvalid),
            // AXI Master W channel
            .wdata(C3_DDR4_S_AXI_wdata),
            .wlast(C3_DDR4_S_AXI_wlast),
            .wready(C3_DDR4_S_AXI_wready),
            .wstrb(C3_DDR4_S_AXI_wstrb),
            .wvalid(C3_DDR4_S_AXI_wvalid),

            // Card Memory Interface
            .mem_wr_cmd_rdy(1'b1),
            .mem_wr_data(mem3_wr_data),
            .mem_wr_datastrb(mem3_wr_datastrb),
            .mem_wr_addr(mem3_wr_addr),
            .mem_rd_cmd_rdy(1'b1),
            .mem_rd_data(mem3_rd_data),
            .mem_rd_data_vld(mem3_rd_data_vld),
            .mem_rd_en(mem3_rd_en),
            .mem_rd_addr(mem3_rd_addr)
         );

         //card memory
         mem_2ports #(
            .DATA_WIDTH(DATA_WIDTH),
            .ADDR_WIDTH(ADDR_WIDTH),
            .HOST_MEM_SIZE(HOST_MEM_SIZE_PER_CHANNEL)
         )card_mem_3(
            .clk(c3_ddr4_ui_clk),
            .rst(c3_ddr4_ui_clk_sync_rst),

            .c1_wr_data(mem3_wr_data),
            .c1_wr_datastrb(mem3_wr_datastrb),
            .c1_wr_addr(mem3_wr_addr),
            .c1_rd_data(mem3_rd_data),
            .c1_rd_data_vld(mem3_rd_data_vld),
            .c1_rd_en(mem3_rd_en),
            .c1_rd_addr(mem3_rd_addr),

            .c2_wr_data(),
            .c2_wr_datastrb(64'd0),
            .c2_wr_addr(),
            .c2_rd_data(),
            .c2_rd_data_vld(),
            .c2_rd_en(1'b0),
            .c2_rd_addr()
         );
      `else
      //APP fast sim
         mig_dummy mig_dummy_3(
            .c0_init_calib_complete     (c3_init_calib_complete),
            .c0_ddr4_app_correct_en_i   (c3_ddr4_app_correct_en_i),
            .c0_ddr4_ecc_err_addr       (c3_ddr4_ecc_err_addr),
            .c0_ddr4_ecc_single         (c3_ddr4_ecc_single),
            .c0_ddr4_ecc_multiple       (c3_ddr4_ecc_multiple),
            .c0_ddr4_ui_clk             (c3_ddr4_ui_clk),
            .c0_ddr4_ui_clk_sync_rst    (c3_ddr4_ui_clk_sync_rst),
            .dbg_clk                    (c3_dbg_clk),
            .c0_ddr4_app_addr           (c3_ddr4_app_addr),
            .c0_ddr4_app_cmd            (c3_ddr4_app_cmd),
            .c0_ddr4_app_en             (c3_ddr4_app_en),
            .c0_ddr4_app_hi_pri         (c3_ddr4_app_hi_pri),
            .c0_ddr4_app_wdf_data       (c3_ddr4_app_wdf_data),
            .c0_ddr4_app_wdf_end        (c3_ddr4_app_wdf_end),
            .c0_ddr4_app_wdf_mask       (c3_ddr4_app_wdf_mask),
            .c0_ddr4_app_wdf_wren       (c3_ddr4_app_wdf_wren),
            .c0_ddr4_app_rd_data        (c3_ddr4_app_rd_data),
            .c0_ddr4_app_rd_data_end    (c3_ddr4_app_rd_data_end),
            .c0_ddr4_app_rd_data_valid  (c3_ddr4_app_rd_data_valid),
            .c0_ddr4_app_rdy            (c3_ddr4_app_rdy),
            .c0_ddr4_app_wdf_rdy        (c3_ddr4_app_wdf_rdy),
            // Debug Port
            .dbg_bus                    (c3_dbg_bus)
         );
      `endif
   `else
      `ifdef AXI_DDR
      // AXI_DDR_MIG
         ddr4_0 u_ddr4_3
           (
            .sys_rst                          (reset_rtl),

            .c0_sys_clk_p                     (C3_SYS_CLK_clk_p),
            .c0_sys_clk_n                     (C3_SYS_CLK_clk_n),
            .c0_init_calib_complete           (c3_init_calib_complete),
            .c0_ddr4_act_n                    (C3_DDR4_act_n),
            .c0_ddr4_adr                      (C3_DDR4_adr),
            .c0_ddr4_ba                       (C3_DDR4_ba),
            .c0_ddr4_bg                       (C3_DDR4_bg),
            .c0_ddr4_cke                      (C3_DDR4_cke),
            .c0_ddr4_odt                      (C3_DDR4_odt),
            .c0_ddr4_cs_n                     (C3_DDR4_cs_n),
            .c0_ddr4_ck_t                     (C3_DDR4_ck_t),
            .c0_ddr4_ck_c                     (C3_DDR4_ck_c),
            .c0_ddr4_reset_n                  (C3_DDR4_reset_n),

            .c0_ddr4_dm_dbi_n                 (C3_DDR4_dm_n),
            .c0_ddr4_dq                       (C3_DDR4_dq),
            .c0_ddr4_dqs_c                    (C3_DDR4_dqs_c),
            .c0_ddr4_dqs_t                    (C3_DDR4_dqs_t),

            .c0_ddr4_ui_clk                   (c3_ddr4_ui_clk),
            .c0_ddr4_ui_clk_sync_rst          (c3_ddr4_ui_clk_sync_rst),
            .dbg_clk                          (),
            // AXI CTRL port
            .c0_ddr4_s_axi_ctrl_awvalid       (1'b0),
            .c0_ddr4_s_axi_ctrl_awready       (),
            .c0_ddr4_s_axi_ctrl_awaddr        (32'b0),
            // Slave Interface Write Data Ports
            .c0_ddr4_s_axi_ctrl_wvalid        (1'b0),
            .c0_ddr4_s_axi_ctrl_wready        (),
            .c0_ddr4_s_axi_ctrl_wdata         (32'b0),
            // Slave Interface Write Response Ports
            .c0_ddr4_s_axi_ctrl_bvalid        (),
            .c0_ddr4_s_axi_ctrl_bready        (1'b1),
            .c0_ddr4_s_axi_ctrl_bresp         (),
            // Slave Interface Read Address Ports
            .c0_ddr4_s_axi_ctrl_arvalid       (1'b0),
            .c0_ddr4_s_axi_ctrl_arready       (),
            .c0_ddr4_s_axi_ctrl_araddr        (32'b0),
            // Slave Interface Read Data Ports
            .c0_ddr4_s_axi_ctrl_rvalid        (),
            .c0_ddr4_s_axi_ctrl_rready        (1'b1),
            .c0_ddr4_s_axi_ctrl_rdata         (),
            .c0_ddr4_s_axi_ctrl_rresp         (),
            // Interrupt output
            .c0_ddr4_interrupt                (),
            // Slave Interface Write Address Ports
            .c0_ddr4_aresetn                  (c3_ddr4_aresetn),
            .c0_ddr4_s_axi_awid               (C3_DDR4_S_AXI_awid),
            .c0_ddr4_s_axi_awaddr             (C3_DDR4_S_AXI_awaddr),
            .c0_ddr4_s_axi_awlen              (C3_DDR4_S_AXI_awlen),
            .c0_ddr4_s_axi_awsize             (C3_DDR4_S_AXI_awsize),
            .c0_ddr4_s_axi_awburst            (C3_DDR4_S_AXI_awburst),
            .c0_ddr4_s_axi_awlock             (C3_DDR4_S_AXI_awlock),
            .c0_ddr4_s_axi_awcache            (C3_DDR4_S_AXI_awcache),
            .c0_ddr4_s_axi_awprot             (C3_DDR4_S_AXI_awprot),
            .c0_ddr4_s_axi_awqos              (C3_DDR4_S_AXI_awqos),
            .c0_ddr4_s_axi_awvalid            (C3_DDR4_S_AXI_awvalid),
            .c0_ddr4_s_axi_awready            (C3_DDR4_S_AXI_awready),
            // Slave Interface Write Data Ports
            .c0_ddr4_s_axi_wdata              (C3_DDR4_S_AXI_wdata),
            .c0_ddr4_s_axi_wstrb              (C3_DDR4_S_AXI_wstrb),
            .c0_ddr4_s_axi_wlast              (C3_DDR4_S_AXI_wlast),
            .c0_ddr4_s_axi_wvalid             (C3_DDR4_S_AXI_wvalid),
            .c0_ddr4_s_axi_wready             (C3_DDR4_S_AXI_wready),
            // Slave Interface Write Response Po3ts
            .c0_ddr4_s_axi_bid                (C3_DDR4_S_AXI_bid),
            .c0_ddr4_s_axi_bresp              (C3_DDR4_S_AXI_bresp),
            .c0_ddr4_s_axi_bvalid             (C3_DDR4_S_AXI_bvalid),
            .c0_ddr4_s_axi_bready             (C3_DDR4_S_AXI_bready),
            // Slave Interface Read Address Port3
            .c0_ddr4_s_axi_arid               (C3_DDR4_S_AXI_arid),
            .c0_ddr4_s_axi_araddr             (C3_DDR4_S_AXI_araddr),
            .c0_ddr4_s_axi_arlen              (C3_DDR4_S_AXI_arlen),
            .c0_ddr4_s_axi_arsize             (C3_DDR4_S_AXI_arsize),
            .c0_ddr4_s_axi_arburst            (C3_DDR4_S_AXI_arburst),
            .c0_ddr4_s_axi_arlock             (C3_DDR4_S_AXI_arlock),
            .c0_ddr4_s_axi_arcache            (C3_DDR4_S_AXI_arcache),
            .c0_ddr4_s_axi_arprot             (C3_DDR4_S_AXI_arprot),
            .c0_ddr4_s_axi_arqos              (C3_DDR4_S_AXI_arqos),
            .c0_ddr4_s_axi_arvalid            (C3_DDR4_S_AXI_arvalid),
            .c0_ddr4_s_axi_arready            (C3_DDR4_S_AXI_arready),
            // Slave Interface Read Data Ports
            .c0_ddr4_s_axi_rid                (C3_DDR4_S_AXI_rid),
            .c0_ddr4_s_axi_rdata              (C3_DDR4_S_AXI_rdata),
            .c0_ddr4_s_axi_rresp              (C3_DDR4_S_AXI_rresp),
            .c0_ddr4_s_axi_rlast              (C3_DDR4_S_AXI_rlast),
            .c0_ddr4_s_axi_rvalid             (C3_DDR4_S_AXI_rvalid),
            .c0_ddr4_s_axi_rready             (C3_DDR4_S_AXI_rready),

            // Debug Port
            .dbg_bus                          ()
         );
      `else
      //APP_DDR_MIG
         ddr4_0 u_ddr4_3(
            .sys_rst                    (reset_rtl),
            .c0_sys_clk_p               (C3_SYS_CLK_clk_p),
            .c0_sys_clk_n               (C3_SYS_CLK_clk_n),
            .c0_ddr4_act_n              (C3_DDR4_act_n),
            .c0_ddr4_adr                (C3_DDR4_adr),
            .c0_ddr4_ba                 (C3_DDR4_ba),
            .c0_ddr4_bg                 (C3_DDR4_bg),
            .c0_ddr4_cke                (C3_DDR4_cke),
            .c0_ddr4_odt                (C3_DDR4_odt),
            .c0_ddr4_cs_n               (C3_DDR4_cs_n),
            .c0_ddr4_ck_t               (C3_DDR4_ck_t),
            .c0_ddr4_ck_c               (C3_DDR4_ck_c),
            .c0_ddr4_reset_n            (C3_DDR4_reset_n),
            .c0_ddr4_dm_dbi_n           (C3_DDR4_dm_n),
            .c0_ddr4_dq                 (C3_DDR4_dq),
            .c0_ddr4_dqs_c              (C3_DDR4_dqs_c),
            .c0_ddr4_dqs_t              (C3_DDR4_dqs_t),

            .c0_init_calib_complete     (c3_init_calib_complete),
            .c0_ddr4_app_correct_en_i   (c3_ddr4_app_correct_en_i),
            .c0_ddr4_ecc_err_addr       (c3_ddr4_ecc_err_addr),
            .c0_ddr4_ecc_single         (c3_ddr4_ecc_single),
            .c0_ddr4_ecc_multiple       (c3_ddr4_ecc_multiple),
            .c0_ddr4_ui_clk             (c3_ddr4_ui_clk),
            .c0_ddr4_ui_clk_sync_rst    (c3_ddr4_ui_clk_sync_rst),
            .dbg_clk                    (c3_dbg_clk),
            .c0_ddr4_app_addr           (c3_ddr4_app_addr),
            .c0_ddr4_app_cmd            (c3_ddr4_app_cmd),
            .c0_ddr4_app_en             (c3_ddr4_app_en),
            .c0_ddr4_app_hi_pri         (c3_ddr4_app_hi_pri),
            .c0_ddr4_app_wdf_data       (c3_ddr4_app_wdf_data),
            .c0_ddr4_app_wdf_end        (c3_ddr4_app_wdf_end),
            .c0_ddr4_app_wdf_mask       (c3_ddr4_app_wdf_mask),
            .c0_ddr4_app_wdf_wren       (c3_ddr4_app_wdf_wren),
            .c0_ddr4_app_rd_data        (c3_ddr4_app_rd_data),
            .c0_ddr4_app_rd_data_end    (c3_ddr4_app_rd_data_end),
            .c0_ddr4_app_rd_data_valid  (c3_ddr4_app_rd_data_valid),
            .c0_ddr4_app_rdy            (c3_ddr4_app_rdy),
            .c0_ddr4_app_wdf_rdy        (c3_ddr4_app_wdf_rdy),
            // Debug Port
            .dbg_bus                    (c3_dbg_bus)
          );
      `endif
   `endif
`endif  // USE_DDR4_C3

endmodule
