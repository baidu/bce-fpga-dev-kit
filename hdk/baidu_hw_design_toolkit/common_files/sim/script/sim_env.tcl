# Setup the variables and settings needed for the project.
source scripts/step_00_setup.tcl

# If there is no project opened, quit.
set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
    return
}

set COMMON_DIR $commonDir
set_property used_in_simulation false [get_files $commonDir/hdl/rp_wrapper.v]

# set elaborate library
set_property -name {xsim.elaborate.xelab.more_options} -value {-L generic_baseblocks_v2_1_0 -L axi_infrastructure_v1_1_0  -L axi_register_slice_v2_1_11 -L axi_crossbar_v2_1_12 -L axi_data_fifo_v2_1_10 -L blk_mem_gen_v8_3_5 -L fifo_generator_v13_1_3  -L axi_dwidth_converter_v2_1_11} -objects [get_filesets sim_1]

add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/axi_crossbar_5s_1m.v
add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/fifo_sync_blk_fwft_576x16_latency_0.v
add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/fifo_sync_blk_fwft_576x512_latency_0.v
add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/fifo_sync_dist_fwft_4x64_latency_0.v
add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/fifo_sync_dist_fwft_64x16_latency_0.v
add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/fifo_sync_dist_fwft_80x16_latency_0.v

add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/bfm/axi_req_mux1.v
add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/bfm/dma_engine.v
add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/bfm/mem_req_mux1.v
add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/bfm/round_robin_4.v
add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/bfm/axi_l_master_bfm.v
add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/bfm/axi_master_bfm.v
add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/bfm/axi_slave_bfm.v

add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/top/card_sim.v
add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/top/rp_sim.v
add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/top/sp_sim.v
add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/top/mem_3ports.v


if {($USE_AXI_DDR == 1) && (($USE_DDR4_C0 == 1) || ($USE_DDR4_C1 == 1) || ($USE_DDR4_C2 == 1) || ($USE_DDR4_C3 == 1))} {	

   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi/ddr4_v2_1_axi_ar_channel.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi/ddr4_v2_1_axi_aw_channel.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi/ddr4_v2_1_axi_b_channel.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi/ddr4_v2_1_axi_cmd_arbiter.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi/ddr4_v2_1_axi_cmd_fsm.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi/ddr4_v2_1_axi_cmd_translator.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi/ddr4_v2_1_axi_fifo.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi/ddr4_v2_1_axi_incr_cmd.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi/ddr4_v2_1_axi_r_channel.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi/ddr4_v2_1_axi_w_channel.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi/ddr4_v2_1_axi_wr_cmd_fsm.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi/ddr4_v2_1_axi_wrap_cmd.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi/ddr4_v2_1_a_upsizer.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi/ddr4_v2_1_axi.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi/ddr4_v2_1_axi_register_slice.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi/ddr4_v2_1_axi_upsizer.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi/ddr4_v2_1_axic_register_slice.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi/ddr4_v2_1_carry_and.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi/ddr4_v2_1_carry_latch_and.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi/ddr4_v2_1_carry_latch_or.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi/ddr4_v2_1_carry_or.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi/ddr4_v2_1_command_fifo.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi/ddr4_v2_1_comparator.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi/ddr4_v2_1_comparator_sel.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi/ddr4_v2_1_comparator_sel_static.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi/ddr4_v2_1_r_upsizer.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi/ddr4_v2_1_w_upsizer.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi_ctrl/ddr4_v2_1_axi_ctrl_addr_decode.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi_ctrl/ddr4_v2_1_axi_ctrl_read.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi_ctrl/ddr4_v2_1_axi_ctrl_reg_bank.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi_ctrl/ddr4_v2_1_axi_ctrl_reg.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi_ctrl/ddr4_v2_1_axi_ctrl_top.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/axi_ctrl/ddr4_v2_1_axi_ctrl_write.sv
}
if {($USE_AXI_DDR == 0) && (($USE_DDR4_C0 == 1) || ($USE_DDR4_C1 == 1) || ($USE_DDR4_C2 == 1) || ($USE_DDR4_C3 == 1))} {
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/ip_top/appddr/ddr4_0.sv	
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/ip_top/appddr/ddr4_0_ddr4.sv	
}
if {($USE_DDR4_C0 == 1) || ($USE_DDR4_C1 == 1) || ($USE_DDR4_C2 == 1) || ($USE_DDR4_C3 == 1)} {
   set_property used_in_simulation false [get_files $commonDir/hdl/mig_wrapper.v]
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/top/mem_2ports.v
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/top/ddr_sim.v
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/top/mig_dummy.v

   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/ip_1/rtl/phy/ddr4_phy_v2_1_xiphy_behav.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/ip_1/rtl/phy/ddr4_phy_v2_1_xiphy.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/ip_1/rtl/iob/ddr4_phy_v2_1_iob_byte.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/ip_1/rtl/iob/ddr4_phy_v2_1_iob.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/ip_1/rtl/clocking/ddr4_phy_v2_1_pll.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/ip_1/rtl/xiphy_files/ddr4_phy_v2_1_xiphy_tristate_wrapper.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/ip_1/rtl/xiphy_files/ddr4_phy_v2_1_xiphy_riuor_wrapper.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/ip_1/rtl/xiphy_files/ddr4_phy_v2_1_xiphy_control_wrapper.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/ip_1/rtl/xiphy_files/ddr4_phy_v2_1_xiphy_byte_wrapper.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/ip_1/rtl/xiphy_files/ddr4_phy_v2_1_xiphy_bitslice_wrapper.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/ip_1/rtl/phy/ddr4_0_phy_ddr4.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/ip_1/rtl/map/ddr4_0_phy_ddrMapDDR4.vh
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/ip_1/rtl/map/ddr4_0_phy_iobMapDDR4.vh
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/ip_1/rtl/map/ddr4_0_phy_riuMap.vh
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/ip_1/rtl/ip_top/ddr4_0_phy.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/controller/ddr4_v2_1_mc_wtr.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/controller/ddr4_v2_1_mc_ref.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/controller/ddr4_v2_1_mc_rd_wr.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/controller/ddr4_v2_1_mc_periodic.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/controller/ddr4_v2_1_mc_group.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/controller/ddr4_v2_1_mc_ecc_merge_enc.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/controller/ddr4_v2_1_mc_ecc_gen.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/controller/ddr4_v2_1_mc_ecc_fi_xor.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/controller/ddr4_v2_1_mc_ecc_dec_fix.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/controller/ddr4_v2_1_mc_ecc_buf.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/controller/ddr4_v2_1_mc_ecc.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/controller/ddr4_v2_1_mc_ctl.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/controller/ddr4_v2_1_mc_cmd_mux_c.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/controller/ddr4_v2_1_mc_cmd_mux_ap.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/controller/ddr4_v2_1_mc_arb_p.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/controller/ddr4_v2_1_mc_arb_mux_p.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/controller/ddr4_v2_1_mc_arb_c.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/controller/ddr4_v2_1_mc_arb_a.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/controller/ddr4_v2_1_mc_act_timer.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/controller/ddr4_v2_1_mc_act_rank.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/controller/ddr4_v2_1_mc.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/ui/ddr4_v2_1_ui_wr_data.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/ui/ddr4_v2_1_ui_rd_data.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/ui/ddr4_v2_1_ui_cmd.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/ui/ddr4_v2_1_ui.sv

   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/clocking/ddr4_v2_1_infrastructure.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/cal/ddr4_v2_1_cal_xsdb_bram.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/cal/ddr4_v2_1_cal_write.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/cal/ddr4_v2_1_cal_wr_byte.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/cal/ddr4_v2_1_cal_wr_bit.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/cal/ddr4_v2_1_cal_sync.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/cal/ddr4_0_ddr4_cal_riu.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/cal/ddr4_v2_1_cal_read.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/cal/ddr4_v2_1_cal_rd_en.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/cal/ddr4_v2_1_cal_pi.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/cal/ddr4_v2_1_cal_mc_odt.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/cal/ddr4_v2_1_cal_debug_microblaze.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/cal/ddr4_v2_1_cal_cplx_data.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/cal/ddr4_v2_1_cal_cplx.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/cal/ddr4_v2_1_cal_config_rom.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/cal/ddr4_v2_1_cal_addr_decode.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/cal/ddr4_v2_1_cal_top.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/cal/ddr4_v2_1_cal_xsdb_arbiter.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/cal/ddr4_v2_1_cal.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/cal/ddr4_v2_1_chipscope_xsdb_slave.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/cal/ddr4_v2_1_dp_AB9.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/ip_top/axiddr/ddr4_0.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/ip_top/axiddr/ddr4_0_ddr4.sv

   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/rtl/ip_top/ddr4_0_ddr4_mem_intfc.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/ddr4/tb/microblaze_mcs_0.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/dram_model/ddr4_sdram_model_wrapper.sv
   add_files -fileset sim_1 -norecurse -scan_for_includes ${COMMON_DIR}/sim/module/dram_model/dram_wrapper.sv
}


add_files -fileset sim_1 -norecurse -scan_for_includes $usrDir/sim/tb/tb.v
set_property top tb [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]
