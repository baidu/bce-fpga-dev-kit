source scripts/step_00_setup.tcl
set dbg_bridge [get_debug_cores -filter {NAME=~rp_i/*region_dbg*}]
if {[llength $dbg_bridge]} {
   if {[llength [get_cells -quiet $dbg_bridge/inst/CORE_XSDB.UUT_MASTER/U_ICON_INTERFACE/U_CMD6_RD/U_RD_FIFO/SUBCORE_FIFO.xsdbm_v2_0_2_rdfifo_inst]]} {
      read_xdc $commonDir/constraints/debug_bridge.xdc
   }
   if {[llength [get_cells -quiet rp_i/pr_region_dbg_bridge_i/inst/xsdbm/inst]]} {
      read_xdc -cell rp_i/pr_region_dbg_bridge_i/inst/xsdbm/inst $commonDir/constraints/xsdbm_timing_exception.xdc
   }

   set dbg_cores [get_debug_cores -filter {NAME=~rp_i/*}]
   if {[llength $dbg_cores] > 1} {
      set dbg_hub_cells [list \
         *runtest_i_reg \
         *tms_i_reg \
      ]
   } else {
      set dbg_hub_cells [list \
         *runtest_i_reg \
         *tms_i_reg \
         *update_i_reg \
         *shift_i_reg \
         *sel_i_reg \
         *tdi_i_reg \
         *tms_i_reg \
         *drck_i_reg \
         *reset_i_reg \
         *runtest_i_reg \
         *capture_i_reg \
         *bscanid_en_i_reg \
         *bscanid_i_reg[*] \
      ]
   }
   foreach cell $dbg_hub_cells {
      set dbg_reg [get_cells -quiet -hier -filter NAME=~rp_i/*region_dbg*/$cell]
      if [llength $dbg_reg] {
         foreach reg $dbg_reg {
            puts "Setting false path to dbg register $reg"
            set_false_path -to [get_pins $reg/D]
         }
      }
   }
}
set_false_path -from [get_pins static_bd_i/static_bd_i/debug_bridge_0/inst/axi_jtag/inst/u_jtag_proc/tdi_output_reg[0]/C]
set_false_path -from [get_pins rp_i/pr_region_dbg_bridge_i/inst/xsdbm/inst/CORE_XSDB.UUT_MASTER/U_ICON_INTERFACE/icn_cmd_en_5_reg/C]
set_false_path -from [get_pins rp_i/pr_region_dbg_bridge_i/inst/xsdbm/inst/CORE_XSDB.UUT_MASTER/U_ICON_INTERFACE/icn_cmd_en_reg[5]/C]
set_false_path -from [get_pins rp_i/pr_region_dbg_bridge_i/inst/xsdbm/inst/CORE_XSDB.UUT_MASTER/U_ICON_INTERFACE/U_CMD1/ctl_reg_reg[0]/C]
