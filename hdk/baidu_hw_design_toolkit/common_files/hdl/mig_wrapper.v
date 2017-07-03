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

module mig_wrapper (
`ifdef AXI_DDR
   `include "mig_wrapper_port_axi.vh"
`else
   `include "mig_wrapper_port_app.vh"
`endif
   `include "mig_wrapper_port_ddr.vh"
   input reset_rtl
);

`ifdef AXI_DDR
   rp_mig_bd rp_mig_bd_i(
      `include "mig_wrapper_if_axi.vh"
      `include "mig_wrapper_if_ddr.vh"
      .reset_rtl(reset_rtl)
   );
`else

   `ifdef USE_DDR4_C0
      ddr4_0 ddr4_c0_i(
         .sys_rst                           (reset_rtl),
         .c0_sys_clk_p                      (C0_SYS_CLK_clk_p),
         .c0_sys_clk_n                      (C0_SYS_CLK_clk_n),
         .c0_ddr4_act_n                     (C0_DDR4_act_n),
         .c0_ddr4_adr                       (C0_DDR4_adr),
         .c0_ddr4_ba                        (C0_DDR4_ba),
         .c0_ddr4_bg                        (C0_DDR4_bg),
         .c0_ddr4_cke                       (C0_DDR4_cke),
         .c0_ddr4_odt                       (C0_DDR4_odt),
         .c0_ddr4_cs_n                      (C0_DDR4_cs_n),
         .c0_ddr4_ck_t                      (C0_DDR4_ck_t),
         .c0_ddr4_ck_c                      (C0_DDR4_ck_c),
         .c0_ddr4_reset_n                   (C0_DDR4_reset_n),
         .c0_ddr4_dm_dbi_n                  (C0_DDR4_dm_n),
         .c0_ddr4_dq                        (C0_DDR4_dq),
         .c0_ddr4_dqs_c                     (C0_DDR4_dqs_c),
         .c0_ddr4_dqs_t                     (C0_DDR4_dqs_t),
         .c0_ddr4_ui_clk                    (c0_ddr4_ui_clk),
         .c0_ddr4_ui_clk_sync_rst           (c0_ddr4_ui_clk_sync_rst),
         .c0_init_calib_complete            (c0_init_calib_complete),

         .c0_ddr4_app_correct_en_i          (c0_ddr4_app_correct_en_i),
         .c0_ddr4_ecc_err_addr              (c0_ddr4_ecc_err_addr),
         .c0_ddr4_ecc_single                (c0_ddr4_ecc_single),
         .c0_ddr4_ecc_multiple              (c0_ddr4_ecc_multiple),
         .c0_ddr4_app_addr                  (c0_ddr4_app_addr),
         .c0_ddr4_app_cmd                   (c0_ddr4_app_cmd),
         .c0_ddr4_app_en                    (c0_ddr4_app_en),
         .c0_ddr4_app_hi_pri                (c0_ddr4_app_hi_pri),
         .c0_ddr4_app_wdf_data              (c0_ddr4_app_wdf_data),
         .c0_ddr4_app_wdf_end               (c0_ddr4_app_wdf_end),
         .c0_ddr4_app_wdf_mask              (c0_ddr4_app_wdf_mask),
         .c0_ddr4_app_wdf_wren              (c0_ddr4_app_wdf_wren),
         .c0_ddr4_app_rd_data               (c0_ddr4_app_rd_data),
         .c0_ddr4_app_rd_data_end           (c0_ddr4_app_rd_data_end),
         .c0_ddr4_app_rd_data_valid         (c0_ddr4_app_rd_data_valid),
         .c0_ddr4_app_rdy                   (c0_ddr4_app_rdy),
         .c0_ddr4_app_wdf_rdy               (c0_ddr4_app_wdf_rdy),
         .dbg_clk                           (c0_dbg_clk),
         .dbg_bus                           (c0_dbg_bus)
      );
   `endif

   `ifdef USE_DDR4_C1
      ddr4_0 ddr4_c1_i(
         .sys_rst                           (reset_rtl),
         .c0_sys_clk_p                      (C1_SYS_CLK_clk_p),
         .c0_sys_clk_n                      (C1_SYS_CLK_clk_n),
         .c0_ddr4_act_n                     (C1_DDR4_act_n),
         .c0_ddr4_adr                       (C1_DDR4_adr),
         .c0_ddr4_ba                        (C1_DDR4_ba),
         .c0_ddr4_bg                        (C1_DDR4_bg),
         .c0_ddr4_cke                       (C1_DDR4_cke),
         .c0_ddr4_odt                       (C1_DDR4_odt),
         .c0_ddr4_cs_n                      (C1_DDR4_cs_n),
         .c0_ddr4_ck_t                      (C1_DDR4_ck_t),
         .c0_ddr4_ck_c                      (C1_DDR4_ck_c),
         .c0_ddr4_reset_n                   (C1_DDR4_reset_n),
         .c0_ddr4_dm_dbi_n                  (C1_DDR4_dm_n),
         .c0_ddr4_dq                        (C1_DDR4_dq),
         .c0_ddr4_dqs_c                     (C1_DDR4_dqs_c),
         .c0_ddr4_dqs_t                     (C1_DDR4_dqs_t),
         .c0_ddr4_ui_clk                    (c1_ddr4_ui_clk),
         .c0_ddr4_ui_clk_sync_rst           (c1_ddr4_ui_clk_sync_rst),
         .c0_init_calib_complete            (c1_init_calib_complete),

         .c0_ddr4_app_correct_en_i          (c1_ddr4_app_correct_en_i),
         .c0_ddr4_ecc_err_addr              (c1_ddr4_ecc_err_addr),
         .c0_ddr4_ecc_single                (c1_ddr4_ecc_single),
         .c0_ddr4_ecc_multiple              (c1_ddr4_ecc_multiple),
         .c0_ddr4_app_addr                  (c1_ddr4_app_addr),
         .c0_ddr4_app_cmd                   (c1_ddr4_app_cmd),
         .c0_ddr4_app_en                    (c1_ddr4_app_en),
         .c0_ddr4_app_hi_pri                (c1_ddr4_app_hi_pri),
         .c0_ddr4_app_wdf_data              (c1_ddr4_app_wdf_data),
         .c0_ddr4_app_wdf_end               (c1_ddr4_app_wdf_end),
         .c0_ddr4_app_wdf_mask              (c1_ddr4_app_wdf_mask),
         .c0_ddr4_app_wdf_wren              (c1_ddr4_app_wdf_wren),
         .c0_ddr4_app_rd_data               (c1_ddr4_app_rd_data),
         .c0_ddr4_app_rd_data_end           (c1_ddr4_app_rd_data_end),
         .c0_ddr4_app_rd_data_valid         (c1_ddr4_app_rd_data_valid),
         .c0_ddr4_app_rdy                   (c1_ddr4_app_rdy),
         .c0_ddr4_app_wdf_rdy               (c1_ddr4_app_wdf_rdy),
         .dbg_clk                           (c1_dbg_clk),
         .dbg_bus                           (c1_dbg_bus)
      );
   `endif

   `ifdef USE_DDR4_C2
      ddr4_0 ddr4_c2_i(
         .sys_rst                           (reset_rtl),
         .c0_sys_clk_p                      (C2_SYS_CLK_clk_p),
         .c0_sys_clk_n                      (C2_SYS_CLK_clk_n),
         .c0_ddr4_act_n                     (C2_DDR4_act_n),
         .c0_ddr4_adr                       (C2_DDR4_adr),
         .c0_ddr4_ba                        (C2_DDR4_ba),
         .c0_ddr4_bg                        (C2_DDR4_bg),
         .c0_ddr4_cke                       (C2_DDR4_cke),
         .c0_ddr4_odt                       (C2_DDR4_odt),
         .c0_ddr4_cs_n                      (C2_DDR4_cs_n),
         .c0_ddr4_ck_t                      (C2_DDR4_ck_t),
         .c0_ddr4_ck_c                      (C2_DDR4_ck_c),
         .c0_ddr4_reset_n                   (C2_DDR4_reset_n),
         .c0_ddr4_dm_dbi_n                  (C2_DDR4_dm_n),
         .c0_ddr4_dq                        (C2_DDR4_dq),
         .c0_ddr4_dqs_c                     (C2_DDR4_dqs_c),
         .c0_ddr4_dqs_t                     (C2_DDR4_dqs_t),
         .c0_ddr4_ui_clk                    (c2_ddr4_ui_clk),
         .c0_ddr4_ui_clk_sync_rst           (c2_ddr4_ui_clk_sync_rst),
         .c0_init_calib_complete            (c2_init_calib_complete),

         .c0_ddr4_app_correct_en_i          (c2_ddr4_app_correct_en_i),
         .c0_ddr4_ecc_err_addr              (c2_ddr4_ecc_err_addr),
         .c0_ddr4_ecc_single                (c2_ddr4_ecc_single),
         .c0_ddr4_ecc_multiple              (c2_ddr4_ecc_multiple),
         .c0_ddr4_app_addr                  (c2_ddr4_app_addr),
         .c0_ddr4_app_cmd                   (c2_ddr4_app_cmd),
         .c0_ddr4_app_en                    (c2_ddr4_app_en),
         .c0_ddr4_app_hi_pri                (c2_ddr4_app_hi_pri),
         .c0_ddr4_app_wdf_data              (c2_ddr4_app_wdf_data),
         .c0_ddr4_app_wdf_end               (c2_ddr4_app_wdf_end),
         .c0_ddr4_app_wdf_mask              (c2_ddr4_app_wdf_mask),
         .c0_ddr4_app_wdf_wren              (c2_ddr4_app_wdf_wren),
         .c0_ddr4_app_rd_data               (c2_ddr4_app_rd_data),
         .c0_ddr4_app_rd_data_end           (c2_ddr4_app_rd_data_end),
         .c0_ddr4_app_rd_data_valid         (c2_ddr4_app_rd_data_valid),
         .c0_ddr4_app_rdy                   (c2_ddr4_app_rdy),
         .c0_ddr4_app_wdf_rdy               (c2_ddr4_app_wdf_rdy),
         .dbg_clk                           (c2_dbg_clk),
         .dbg_bus                           (c2_dbg_bus)
      );
   `endif

   `ifdef USE_DDR4_C3
      ddr4_0 ddr4_c3_i(
         .sys_rst                           (reset_rtl),
         .c0_sys_clk_p                      (C3_SYS_CLK_clk_p),
         .c0_sys_clk_n                      (C3_SYS_CLK_clk_n),
         .c0_ddr4_act_n                     (C3_DDR4_act_n),
         .c0_ddr4_adr                       (C3_DDR4_adr),
         .c0_ddr4_ba                        (C3_DDR4_ba),
         .c0_ddr4_bg                        (C3_DDR4_bg),
         .c0_ddr4_cke                       (C3_DDR4_cke),
         .c0_ddr4_odt                       (C3_DDR4_odt),
         .c0_ddr4_cs_n                      (C3_DDR4_cs_n),
         .c0_ddr4_ck_t                      (C3_DDR4_ck_t),
         .c0_ddr4_ck_c                      (C3_DDR4_ck_c),
         .c0_ddr4_reset_n                   (C3_DDR4_reset_n),
         .c0_ddr4_dm_dbi_n                  (C3_DDR4_dm_n),
         .c0_ddr4_dq                        (C3_DDR4_dq),
         .c0_ddr4_dqs_c                     (C3_DDR4_dqs_c),
         .c0_ddr4_dqs_t                     (C3_DDR4_dqs_t),
         .c0_ddr4_ui_clk                    (c3_ddr4_ui_clk),
         .c0_ddr4_ui_clk_sync_rst           (c3_ddr4_ui_clk_sync_rst),
         .c0_init_calib_complete            (c3_init_calib_complete),

         .c0_ddr4_app_correct_en_i          (c3_ddr4_app_correct_en_i),
         .c0_ddr4_ecc_err_addr              (c3_ddr4_ecc_err_addr),
         .c0_ddr4_ecc_single                (c3_ddr4_ecc_single),
         .c0_ddr4_ecc_multiple              (c3_ddr4_ecc_multiple),
         .c0_ddr4_app_addr                  (c3_ddr4_app_addr),
         .c0_ddr4_app_cmd                   (c3_ddr4_app_cmd),
         .c0_ddr4_app_en                    (c3_ddr4_app_en),
         .c0_ddr4_app_hi_pri                (c3_ddr4_app_hi_pri),
         .c0_ddr4_app_wdf_data              (c3_ddr4_app_wdf_data),
         .c0_ddr4_app_wdf_end               (c3_ddr4_app_wdf_end),
         .c0_ddr4_app_wdf_mask              (c3_ddr4_app_wdf_mask),
         .c0_ddr4_app_wdf_wren              (c3_ddr4_app_wdf_wren),
         .c0_ddr4_app_rd_data               (c3_ddr4_app_rd_data),
         .c0_ddr4_app_rd_data_end           (c3_ddr4_app_rd_data_end),
         .c0_ddr4_app_rd_data_valid         (c3_ddr4_app_rd_data_valid),
         .c0_ddr4_app_rdy                   (c3_ddr4_app_rdy),
         .c0_ddr4_app_wdf_rdy               (c3_ddr4_app_wdf_rdy),
         .dbg_clk                           (c3_dbg_clk),
         .dbg_bus                           (c3_dbg_bus)
      );
   `endif
`endif
endmodule
