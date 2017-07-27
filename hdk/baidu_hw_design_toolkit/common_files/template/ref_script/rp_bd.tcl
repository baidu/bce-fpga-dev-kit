
################################################################
# This is a generated script based on design: rp_bd
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2016.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   common::send_msg_id "BD_TCL-1002" "WARNING" "This script was generated using Vivado <$scripts_vivado_version> without IP versions in the create_bd_cell commands, but is now being run in <$current_vivado_version> of Vivado. There may have been major IP version changes between Vivado <$scripts_vivado_version> and <$current_vivado_version>, which could impact the parameter settings of the IPs."

}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source rp_bd_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcku115-flvf1924-2-e
}


# CHANGE DESIGN NAME HERE
set design_name rp_bd

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  source ./scripts/step_00_setup.tcl

  set S_AXI [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI ]
  set_property -dict [ list \
     CONFIG.ADDR_WIDTH {64} \
     CONFIG.ARUSER_WIDTH {0} \
     CONFIG.AWUSER_WIDTH {0} \
     CONFIG.BUSER_WIDTH {0} \
     CONFIG.CLK_DOMAIN {rp_bd_axi_pcie3_0_0_axi_aclk} \
     CONFIG.DATA_WIDTH {256} \
     CONFIG.FREQ_HZ {250000000} \
     CONFIG.HAS_BRESP {1} \
     CONFIG.HAS_BURST {0} \
     CONFIG.HAS_CACHE {1} \
     CONFIG.HAS_LOCK {1} \
     CONFIG.HAS_PROT {1} \
     CONFIG.HAS_QOS {0} \
     CONFIG.HAS_REGION {0} \
     CONFIG.HAS_RRESP {1} \
     CONFIG.HAS_WSTRB {1} \
     CONFIG.ID_WIDTH {4} \
     CONFIG.MAX_BURST_LENGTH {256} \
     CONFIG.NUM_READ_OUTSTANDING {16} \
     CONFIG.NUM_READ_THREADS {1} \
     CONFIG.NUM_WRITE_OUTSTANDING {16} \
     CONFIG.NUM_WRITE_THREADS {1} \
     CONFIG.PROTOCOL {AXI4} \
     CONFIG.READ_WRITE_MODE {READ_WRITE} \
     CONFIG.RUSER_BITS_PER_BYTE {0} \
     CONFIG.RUSER_WIDTH {0} \
     CONFIG.SUPPORTS_NARROW_BURST {0} \
     CONFIG.WUSER_BITS_PER_BYTE {0} \
     CONFIG.WUSER_WIDTH {0} \
  ] $S_AXI

  set S_AXI_LITE [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE ]
  set_property -dict [ list \
     CONFIG.ADDR_WIDTH {16} \
     CONFIG.ARUSER_WIDTH {0} \
     CONFIG.AWUSER_WIDTH {0} \
     CONFIG.BUSER_WIDTH {0} \
     CONFIG.CLK_DOMAIN {rp_bd_axi_pcie3_0_0_axi_aclk} \
     CONFIG.DATA_WIDTH {32} \
     CONFIG.FREQ_HZ {250000000} \
     CONFIG.HAS_BRESP {1} \
     CONFIG.HAS_BURST {1} \
     CONFIG.HAS_CACHE {1} \
     CONFIG.HAS_LOCK {1} \
     CONFIG.HAS_PROT {1} \
     CONFIG.HAS_QOS {0} \
     CONFIG.HAS_REGION {0} \
     CONFIG.HAS_RRESP {1} \
     CONFIG.HAS_WSTRB {1} \
     CONFIG.ID_WIDTH {0} \
     CONFIG.MAX_BURST_LENGTH {1} \
     CONFIG.NUM_READ_OUTSTANDING {8} \
     CONFIG.NUM_READ_THREADS {1} \
     CONFIG.NUM_WRITE_OUTSTANDING {8} \
     CONFIG.NUM_WRITE_THREADS {1} \
     CONFIG.PROTOCOL {AXI4LITE} \
     CONFIG.READ_WRITE_MODE {READ_WRITE} \
     CONFIG.RUSER_BITS_PER_BYTE {0} \
     CONFIG.RUSER_WIDTH {0} \
     CONFIG.SUPPORTS_NARROW_BURST {0} \
     CONFIG.WUSER_BITS_PER_BYTE {0} \
     CONFIG.WUSER_WIDTH {0} \
  ] $S_AXI_LITE

  set i_soft_rst_n [ create_bd_port -dir I -type rst i_soft_rst_n ]
  set s_axi_aclk [ create_bd_port -dir I -type clk s_axi_aclk ]
  set_property -dict [ list \
     CONFIG.ASSOCIATED_BUSIF {S_AXI:S_AXI_LITE} \
     CONFIG.ASSOCIATED_RESET {s_axi_aresetn:s_axi_aresetn} \
     CONFIG.CLK_DOMAIN {rp_bd_axi_pcie3_0_0_axi_aclk} \
     CONFIG.FREQ_HZ {250000000} \
  ] $s_axi_aclk
  set s_axi_aresetn [ create_bd_port -dir I -type rst s_axi_aresetn ]
  set usr_clk [ create_bd_port -dir I -type clk usr_clk ]
  set_property -dict [ list \
     CONFIG.ASSOCIATED_RESET {usr_clk_rst} \
     CONFIG.FREQ_HZ {100000000} \
  ] $usr_clk
  set usr_clk_rst [ create_bd_port -dir I -type rst usr_clk_rst ]
  set_property -dict [ list \
     CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $usr_clk_rst
  set usr_irq_ack [ create_bd_port -dir I -from 15 -to 0 -type data usr_irq_ack ]
  set usr_irq_req [ create_bd_port -dir O -from 15 -to 0 usr_irq_req ]

  if {$USE_DDR4_C0 == 1} {
     # Create interface ports
     set C0_DDR4_M_AXI [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 C0_DDR4_M_AXI ]
     set_property -dict [ list \
        CONFIG.ADDR_WIDTH {31} \
        CONFIG.DATA_WIDTH {512} \
        CONFIG.FREQ_HZ {300000000} \
        CONFIG.NUM_READ_OUTSTANDING {2} \
        CONFIG.NUM_WRITE_OUTSTANDING {2} \
        CONFIG.PROTOCOL {AXI4} \
     ] $C0_DDR4_M_AXI
     # Create ports
     set c0_ddr4_ui_clk [ create_bd_port -dir I -type clk c0_ddr4_ui_clk ]
     set_property -dict [ list \
        CONFIG.ASSOCIATED_BUSIF {C0_DDR4_M_AXI} \
        CONFIG.ASSOCIATED_RESET {c0_ddr4_ui_clk_sync_rst} \
        CONFIG.FREQ_HZ {300000000} \
     ] $c0_ddr4_ui_clk
     set c0_ddr4_ui_clk_sync_rst [ create_bd_port -dir I -type rst c0_ddr4_ui_clk_sync_rst ]
     set_property -dict [ list \
        CONFIG.POLARITY {ACTIVE_HIGH} \
     ] $c0_ddr4_ui_clk_sync_rst
     # Create address segments
     #create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces S_AXI] [get_bd_addr_segs C0_DDR4_M_AXI/Reg] SEG_C0_DDR4_M_AXI_Reg
  }


  if {$USE_DDR4_C1 == 1} {
     # Create interface ports
     set C1_DDR4_M_AXI [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 C1_DDR4_M_AXI ]
     set_property -dict [ list \
        CONFIG.ADDR_WIDTH {31} \
        CONFIG.DATA_WIDTH {512} \
        CONFIG.FREQ_HZ {300000000} \
        CONFIG.NUM_READ_OUTSTANDING {2} \
        CONFIG.NUM_WRITE_OUTSTANDING {2} \
        CONFIG.PROTOCOL {AXI4} \
     ] $C1_DDR4_M_AXI
     # Create ports
     set c1_ddr4_ui_clk [ create_bd_port -dir I -type clk c1_ddr4_ui_clk ]
     set_property -dict [ list \
        CONFIG.ASSOCIATED_BUSIF {C1_DDR4_M_AXI} \
        CONFIG.ASSOCIATED_RESET {c1_ddr4_ui_clk_sync_rst} \
        CONFIG.FREQ_HZ {300000000} \
     ] $c1_ddr4_ui_clk
     set c1_ddr4_ui_clk_sync_rst [ create_bd_port -dir I -type rst c1_ddr4_ui_clk_sync_rst ]
     set_property -dict [ list \
        CONFIG.POLARITY {ACTIVE_HIGH} \
     ] $c1_ddr4_ui_clk_sync_rst
     # Create address segments
     #create_bd_addr_seg -range 0x80000000 -offset 0x80000000 [get_bd_addr_spaces S_AXI] [get_bd_addr_segs C1_DDR4_M_AXI/Reg] SEG_C1_DDR4_M_AXI_Reg
  }

  if {$USE_DDR4_C2 == 1} {
     # Create interface ports
     set C2_DDR4_M_AXI [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 C2_DDR4_M_AXI ]
     set_property -dict [ list \
        CONFIG.ADDR_WIDTH {31} \
        CONFIG.DATA_WIDTH {512} \
        CONFIG.FREQ_HZ {300000000} \
        CONFIG.NUM_READ_OUTSTANDING {2} \
        CONFIG.NUM_WRITE_OUTSTANDING {2} \
        CONFIG.PROTOCOL {AXI4} \
     ] $C2_DDR4_M_AXI
     # Create ports
     set c2_ddr4_ui_clk [ create_bd_port -dir I -type clk c2_ddr4_ui_clk ]
     set_property -dict [ list \
        CONFIG.ASSOCIATED_BUSIF {C2_DDR4_M_AXI} \
        CONFIG.ASSOCIATED_RESET {c2_ddr4_ui_clk_sync_rst} \
        CONFIG.FREQ_HZ {300000000} \
     ] $c2_ddr4_ui_clk
     set c2_ddr4_ui_clk_sync_rst [ create_bd_port -dir I -type rst c2_ddr4_ui_clk_sync_rst ]
     set_property -dict [ list \
        CONFIG.POLARITY {ACTIVE_HIGH} \
     ] $c2_ddr4_ui_clk_sync_rst
     # Create address segments
     #create_bd_addr_seg -range 0x80000000 -offset 0x000100000000 [get_bd_addr_spaces S_AXI] [get_bd_addr_segs C2_DDR4_M_AXI/Reg] SEG_C2_DDR4_M_AXI_Reg
  }


  if {$USE_DDR4_C3 == 1} {
     # Create interface ports
     set C3_DDR4_M_AXI [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 C3_DDR4_M_AXI ]
     set_property -dict [ list \
        CONFIG.ADDR_WIDTH {31} \
        CONFIG.DATA_WIDTH {512} \
        CONFIG.FREQ_HZ {300000000} \
        CONFIG.NUM_READ_OUTSTANDING {16} \
        CONFIG.NUM_WRITE_OUTSTANDING {16} \
        CONFIG.PROTOCOL {AXI4} \
     ] $C3_DDR4_M_AXI
     # Create ports
     set c3_ddr4_ui_clk [ create_bd_port -dir I -type clk c3_ddr4_ui_clk ]
     set_property -dict [ list \
        CONFIG.ASSOCIATED_BUSIF {C3_DDR4_M_AXI} \
        CONFIG.ASSOCIATED_RESET {c3_ddr4_ui_clk_sync_rst} \
        CONFIG.FREQ_HZ {300000000} \
     ] $c3_ddr4_ui_clk
     set c3_ddr4_ui_clk_sync_rst [ create_bd_port -dir I -type rst c3_ddr4_ui_clk_sync_rst ]
     set_property -dict [ list \
        CONFIG.POLARITY {ACTIVE_HIGH} \
     ] $c3_ddr4_ui_clk_sync_rst
     # Create address segments
     #create_bd_addr_seg -range 0x80000000 -offset 0x000180000000 [get_bd_addr_spaces S_AXI] [get_bd_addr_segs C3_DDR4_M_AXI/Reg] SEG_C3_DDR4_M_AXI_Reg
  }

  if {$USE_RP_AXI_MASTER == 1} {
     set M_AXI [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI ]
     set_property -dict [ list \
        CONFIG.ADDR_WIDTH {64} \
        CONFIG.CLK_DOMAIN {rp_bd_axi_pcie3_0_0_axi_aclk} \
        CONFIG.DATA_WIDTH {256} \
        CONFIG.FREQ_HZ {250000000} \
        CONFIG.NUM_READ_OUTSTANDING {2} \
        CONFIG.NUM_WRITE_OUTSTANDING {2} \
        CONFIG.PROTOCOL {AXI4} \
     ] $M_AXI
     set_property -dict [ list \
        CONFIG.ASSOCIATED_BUSIF {S_AXI:S_AXI_LITE:M_AXI} \
     ] $s_axi_aclk
  }

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.6.5b  2016-09-06 bk=1.3687 VDI=39 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port S_AXI -pg 1 -y 570 -defaultsOSRD
preplace port S_AXI_LITE -pg 1 -y 100 -defaultsOSRD
preplace port s_axi_aclk -pg 1 -y 610 -defaultsOSRD
preplace port s_axi_aresetn -pg 1 -y 590 -defaultsOSRD
preplace port usr_clk -pg 1 -y 470 -defaultsOSRD
preplace port usr_clk_rst -pg 1 -y 10 -defaultsOSRD
preplace port c0_ddr4_ui_clk -pg 1 -y 630 -defaultsOSRD
preplace port c1_ddr4_ui_clk -pg 1 -y 730 -defaultsOSRD
preplace port c2_ddr4_ui_clk -pg 1 -y 830 -defaultsOSRD
preplace port c3_ddr4_ui_clk -pg 1 -y 930 -defaultsOSRD
preplace port c0_ddr4_ui_clk_sync_rst -pg 1 -y 680 -defaultsOSRD
preplace port c1_ddr4_ui_clk_sync_rst -pg 1 -y 780 -defaultsOSRD
preplace port c2_ddr4_ui_clk_sync_rst -pg 1 -y 880 -defaultsOSRD
preplace port c3_ddr4_ui_clk_sync_rst -pg 1 -y 980 -defaultsOSRD
preplace port M_AXI -pg 1 -y 190 -defaultsOSRD
preplace port C0_DDR4_M_AXI -pg 1 -y 690 -defaultsOSRD
preplace port C1_DDR4_M_AXI -pg 1 -y 710 -defaultsOSRD
preplace port C2_DDR4_M_AXI -pg 1 -y 780 -defaultsOSRD
preplace port C3_DDR4_M_AXI -pg 1 -y 900 -defaultsOSRD
preplace port i_soft_rst_n -pg 1 -y 390 -defaultsOSRD
preplace portBus usr_irq_req -pg 1 -y 10 -defaultsOSRD
preplace portBus usr_irq_ack -pg 1 -y 530 -defaultsOSRD
levelinfo -pg 1 -40 330 650 1070 1400 1690 1820 -top -120 -bot 1020
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


common::send_msg_id "BD_TCL-1000" "WARNING" "This Tcl script was generated from a block design that has not been validated. It is possible that design <$design_name> may result in errors during validation."

