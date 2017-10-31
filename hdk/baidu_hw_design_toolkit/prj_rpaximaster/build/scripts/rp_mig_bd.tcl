
################################################################
# This is a generated script based on design: rp_mig_bd
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

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcku115-flvf1924-2-e
}


# CHANGE DESIGN NAME HERE
set design_name rp_mig_bd

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

  if {$USE_DDR4_C0 == 1} {
  # Create interface ports
  set C0_DDR4 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 C0_DDR4 ]
  set C0_DDR4_S_AXI [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 C0_DDR4_S_AXI ]
  set_property -dict [ list \
      CONFIG.ADDR_WIDTH {31} \
      CONFIG.ARUSER_WIDTH {0} \
      CONFIG.AWUSER_WIDTH {0} \
      CONFIG.BUSER_WIDTH {0} \
      CONFIG.DATA_WIDTH {512} \
      CONFIG.HAS_BRESP {1} \
      CONFIG.HAS_BURST {1} \
      CONFIG.HAS_CACHE {1} \
      CONFIG.HAS_LOCK {1} \
      CONFIG.HAS_PROT {1} \
      CONFIG.HAS_QOS {1} \
      CONFIG.HAS_REGION {0} \
      CONFIG.HAS_RRESP {1} \
      CONFIG.HAS_WSTRB {1} \
      CONFIG.MAX_BURST_LENGTH {256} \
      CONFIG.NUM_READ_OUTSTANDING {2} \
      CONFIG.NUM_READ_THREADS {1} \
      CONFIG.NUM_WRITE_OUTSTANDING {2} \
      CONFIG.NUM_WRITE_THREADS {1} \
      CONFIG.PROTOCOL {AXI4} \
      CONFIG.READ_WRITE_MODE {READ_WRITE} \
      CONFIG.RUSER_BITS_PER_BYTE {0} \
      CONFIG.RUSER_WIDTH {0} \
      CONFIG.SUPPORTS_NARROW_BURST {1} \
      CONFIG.WUSER_BITS_PER_BYTE {0} \
      CONFIG.WUSER_WIDTH {0} \
 ] $C0_DDR4_S_AXI
  set_property CONFIG.ID_WIDTH $C0_DDR4_AXIID_WIDTH $C0_DDR4_S_AXI
  set C0_DDR4_S_AXI_CTRL [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 C0_DDR4_S_AXI_CTRL ]
  set_property -dict [ list \
CONFIG.ADDR_WIDTH {32} \
CONFIG.ARUSER_WIDTH {0} \
CONFIG.AWUSER_WIDTH {0} \
CONFIG.BUSER_WIDTH {0} \
CONFIG.DATA_WIDTH {32} \
CONFIG.HAS_BRESP {1} \
CONFIG.HAS_BURST {0} \
CONFIG.HAS_CACHE {0} \
CONFIG.HAS_LOCK {0} \
CONFIG.HAS_PROT {0} \
CONFIG.HAS_QOS {0} \
CONFIG.HAS_REGION {0} \
CONFIG.HAS_RRESP {1} \
CONFIG.HAS_WSTRB {0} \
CONFIG.ID_WIDTH {0} \
CONFIG.MAX_BURST_LENGTH {1} \
CONFIG.NUM_READ_OUTSTANDING {1} \
CONFIG.NUM_READ_THREADS {1} \
CONFIG.NUM_WRITE_OUTSTANDING {1} \
CONFIG.NUM_WRITE_THREADS {1} \
CONFIG.PROTOCOL {AXI4LITE} \
CONFIG.READ_WRITE_MODE {READ_WRITE} \
CONFIG.RUSER_BITS_PER_BYTE {0} \
CONFIG.RUSER_WIDTH {0} \
CONFIG.SUPPORTS_NARROW_BURST {0} \
CONFIG.WUSER_BITS_PER_BYTE {0} \
CONFIG.WUSER_WIDTH {0} \
 ] $C0_DDR4_S_AXI_CTRL
  set C0_SYS_CLK [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 C0_SYS_CLK ]
  set_property -dict [ list \
      CONFIG.FREQ_HZ {200000000} \
 ] $C0_SYS_CLK
  # Create ports
  set c0_ddr4_aresetn [ create_bd_port -dir I -type rst c0_ddr4_aresetn ]
  set c0_ddr4_interrupt [ create_bd_port -dir O c0_ddr4_interrupt ]
  set c0_ddr4_ui_clk [ create_bd_port -dir O -type clk c0_ddr4_ui_clk ]
  set_property -dict [ list \
      CONFIG.ASSOCIATED_BUSIF {C0_DDR4_S_AXI:C0_DDR4_S_AXI_CTRL} \
      CONFIG.ASSOCIATED_RESET {c0_ddr4_ui_clk_sync_rst:c0_ddr4_aresetn} \
 ] $c0_ddr4_ui_clk
  set c0_ddr4_ui_clk_sync_rst [ create_bd_port -dir O -type rst c0_ddr4_ui_clk_sync_rst ]
  set c0_init_calib_complete [ create_bd_port -dir O c0_init_calib_complete ]
  # Create instance: ddr4_0, and set properties
  set ddr4_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4 ddr4_0 ]
  set_property -dict [ list \
      CONFIG.C0.BANK_GROUP_WIDTH {1} \
      CONFIG.C0.DDR4_AxiAddressWidth {31} \
      CONFIG.C0.DDR4_AxiDataWidth {512} \
      CONFIG.C0.DDR4_CLKOUT0_DIVIDE {4} \
      CONFIG.C0.DDR4_CasLatency {17} \
      CONFIG.C0.DDR4_CasWriteLatency {12} \
      CONFIG.C0.DDR4_DataMask {NO_DM_NO_DBI} \
      CONFIG.C0.DDR4_DataWidth {72} \
      CONFIG.C0.DDR4_Ecc {true} \
      CONFIG.C0.DDR4_InputClockPeriod {4998} \
      CONFIG.C0.DDR4_MemoryPart {MT40A256M16GE-075E} \
      CONFIG.C0.DDR4_TimePeriod {833} \
 ] $ddr4_0
 }


  if {$USE_DDR4_C1 == 1} {
  set C1_DDR4 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 C1_DDR4 ]
  set C1_DDR4_S_AXI [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 C1_DDR4_S_AXI ]
  set_property -dict [ list \
      CONFIG.ADDR_WIDTH {31} \
      CONFIG.ARUSER_WIDTH {0} \
      CONFIG.AWUSER_WIDTH {0} \
      CONFIG.BUSER_WIDTH {0} \
      CONFIG.DATA_WIDTH {512} \
      CONFIG.HAS_BRESP {1} \
      CONFIG.HAS_BURST {1} \
      CONFIG.HAS_CACHE {1} \
      CONFIG.HAS_LOCK {1} \
      CONFIG.HAS_PROT {1} \
      CONFIG.HAS_QOS {1} \
      CONFIG.HAS_REGION {0} \
      CONFIG.HAS_RRESP {1} \
      CONFIG.HAS_WSTRB {1} \
      CONFIG.MAX_BURST_LENGTH {256} \
      CONFIG.NUM_READ_OUTSTANDING {2} \
      CONFIG.NUM_READ_THREADS {1} \
      CONFIG.NUM_WRITE_OUTSTANDING {2} \
      CONFIG.NUM_WRITE_THREADS {1} \
      CONFIG.PROTOCOL {AXI4} \
      CONFIG.READ_WRITE_MODE {READ_WRITE} \
      CONFIG.RUSER_BITS_PER_BYTE {0} \
      CONFIG.RUSER_WIDTH {0} \
      CONFIG.SUPPORTS_NARROW_BURST {1} \
      CONFIG.WUSER_BITS_PER_BYTE {0} \
      CONFIG.WUSER_WIDTH {0} \
 ] $C1_DDR4_S_AXI
  set_property CONFIG.ID_WIDTH $C1_DDR4_AXIID_WIDTH $C1_DDR4_S_AXI
  set C1_DDR4_S_AXI_CTRL [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 C1_DDR4_S_AXI_CTRL ]
  set_property -dict [ list \
CONFIG.ADDR_WIDTH {32} \
CONFIG.ARUSER_WIDTH {0} \
CONFIG.AWUSER_WIDTH {0} \
CONFIG.BUSER_WIDTH {0} \
CONFIG.DATA_WIDTH {32} \
CONFIG.HAS_BRESP {1} \
CONFIG.HAS_BURST {1} \
CONFIG.HAS_CACHE {1} \
CONFIG.HAS_LOCK {1} \
CONFIG.HAS_PROT {1} \
CONFIG.HAS_QOS {1} \
CONFIG.HAS_REGION {1} \
CONFIG.HAS_RRESP {1} \
CONFIG.HAS_WSTRB {1} \
CONFIG.ID_WIDTH {0} \
CONFIG.MAX_BURST_LENGTH {1} \
CONFIG.NUM_READ_OUTSTANDING {1} \
CONFIG.NUM_READ_THREADS {1} \
CONFIG.NUM_WRITE_OUTSTANDING {1} \
CONFIG.NUM_WRITE_THREADS {1} \
CONFIG.PROTOCOL {AXI4LITE} \
CONFIG.READ_WRITE_MODE {READ_WRITE} \
CONFIG.RUSER_BITS_PER_BYTE {0} \
CONFIG.RUSER_WIDTH {0} \
CONFIG.SUPPORTS_NARROW_BURST {0} \
CONFIG.WUSER_BITS_PER_BYTE {0} \
CONFIG.WUSER_WIDTH {0} \
 ] $C1_DDR4_S_AXI_CTRL
  set C1_SYS_CLK [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 C1_SYS_CLK ]
  set_property -dict [ list \
      CONFIG.FREQ_HZ {200000000} \
 ] $C1_SYS_CLK
  # Create ports
  set c1_ddr4_aresetn [ create_bd_port -dir I -type rst c1_ddr4_aresetn ]
  set c1_ddr4_interrupt [ create_bd_port -dir O c1_ddr4_interrupt ]
  set c1_ddr4_ui_clk [ create_bd_port -dir O -type clk c1_ddr4_ui_clk ]
  set_property -dict [ list \
      CONFIG.ASSOCIATED_BUSIF {C1_DDR4_S_AXI:C1_DDR4_S_AXI_CTRL} \
      CONFIG.ASSOCIATED_RESET {c1_ddr4_ui_clk_sync_rst:c1_ddr4_aresetn} \
 ] $c1_ddr4_ui_clk
  set c1_ddr4_ui_clk_sync_rst [ create_bd_port -dir O -type rst c1_ddr4_ui_clk_sync_rst ]
  set c1_init_calib_complete [ create_bd_port -dir O c1_init_calib_complete ]
  # Create instance: ddr4_1, and set properties
  set ddr4_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4 ddr4_1 ]
  set_property -dict [ list \
      CONFIG.C0.BANK_GROUP_WIDTH {1} \
      CONFIG.C0.DDR4_AxiAddressWidth {31} \
      CONFIG.C0.DDR4_AxiDataWidth {512} \
      CONFIG.C0.DDR4_CLKOUT0_DIVIDE {4} \
      CONFIG.C0.DDR4_CasLatency {17} \
      CONFIG.C0.DDR4_CasWriteLatency {12} \
      CONFIG.C0.DDR4_DataMask {NO_DM_NO_DBI} \
      CONFIG.C0.DDR4_DataWidth {72} \
      CONFIG.C0.DDR4_Ecc {true} \
      CONFIG.C0.DDR4_InputClockPeriod {4998} \
      CONFIG.C0.DDR4_MemoryPart {MT40A256M16GE-075E} \
      CONFIG.C0.DDR4_TimePeriod {833} \
 ] $ddr4_1
 }


  if {$USE_DDR4_C2 == 1} {
  set C2_DDR4 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 C2_DDR4 ]
  set C2_DDR4_S_AXI [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 C2_DDR4_S_AXI ]
  set_property -dict [ list \
      CONFIG.ADDR_WIDTH {31} \
      CONFIG.ARUSER_WIDTH {0} \
      CONFIG.AWUSER_WIDTH {0} \
      CONFIG.BUSER_WIDTH {0} \
      CONFIG.DATA_WIDTH {512} \
      CONFIG.HAS_BRESP {1} \
      CONFIG.HAS_BURST {1} \
      CONFIG.HAS_CACHE {1} \
      CONFIG.HAS_LOCK {1} \
      CONFIG.HAS_PROT {1} \
      CONFIG.HAS_QOS {1} \
      CONFIG.HAS_REGION {0} \
      CONFIG.HAS_RRESP {1} \
      CONFIG.HAS_WSTRB {1} \
      CONFIG.MAX_BURST_LENGTH {256} \
      CONFIG.NUM_READ_OUTSTANDING {2} \
      CONFIG.NUM_READ_THREADS {1} \
      CONFIG.NUM_WRITE_OUTSTANDING {2} \
      CONFIG.NUM_WRITE_THREADS {1} \
      CONFIG.PROTOCOL {AXI4} \
      CONFIG.READ_WRITE_MODE {READ_WRITE} \
      CONFIG.RUSER_BITS_PER_BYTE {0} \
      CONFIG.RUSER_WIDTH {0} \
      CONFIG.SUPPORTS_NARROW_BURST {1} \
      CONFIG.WUSER_BITS_PER_BYTE {0} \
      CONFIG.WUSER_WIDTH {0} \
 ] $C2_DDR4_S_AXI
  set_property CONFIG.ID_WIDTH $C2_DDR4_AXIID_WIDTH $C2_DDR4_S_AXI
  set C2_DDR4_S_AXI_CTRL [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 C2_DDR4_S_AXI_CTRL ]
  set_property -dict [ list \
CONFIG.ADDR_WIDTH {32} \
CONFIG.ARUSER_WIDTH {0} \
CONFIG.AWUSER_WIDTH {0} \
CONFIG.BUSER_WIDTH {0} \
CONFIG.DATA_WIDTH {32} \
CONFIG.HAS_BRESP {1} \
CONFIG.HAS_BURST {0} \
CONFIG.HAS_CACHE {0} \
CONFIG.HAS_LOCK {0} \
CONFIG.HAS_PROT {0} \
CONFIG.HAS_QOS {0} \
CONFIG.HAS_REGION {0} \
CONFIG.HAS_RRESP {1} \
CONFIG.HAS_WSTRB {0} \
CONFIG.ID_WIDTH {0} \
CONFIG.MAX_BURST_LENGTH {1} \
CONFIG.NUM_READ_OUTSTANDING {1} \
CONFIG.NUM_READ_THREADS {1} \
CONFIG.NUM_WRITE_OUTSTANDING {1} \
CONFIG.NUM_WRITE_THREADS {1} \
CONFIG.PROTOCOL {AXI4LITE} \
CONFIG.READ_WRITE_MODE {READ_WRITE} \
CONFIG.RUSER_BITS_PER_BYTE {0} \
CONFIG.RUSER_WIDTH {0} \
CONFIG.SUPPORTS_NARROW_BURST {0} \
CONFIG.WUSER_BITS_PER_BYTE {0} \
CONFIG.WUSER_WIDTH {0} \
 ] $C2_DDR4_S_AXI_CTRL
  set C2_SYS_CLK [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 C2_SYS_CLK ]
  set_property -dict [ list \
      CONFIG.FREQ_HZ {200000000} \
 ] $C2_SYS_CLK
  # Create ports
  set c2_ddr4_aresetn [ create_bd_port -dir I -type rst c2_ddr4_aresetn ]
  set c2_ddr4_interrupt [ create_bd_port -dir O c2_ddr4_interrupt ]
  set c2_ddr4_ui_clk [ create_bd_port -dir O -type clk c2_ddr4_ui_clk ]
  set_property -dict [ list \
      CONFIG.ASSOCIATED_BUSIF {C2_DDR4_S_AXI:C2_DDR4_S_AXI_CTRL} \
      CONFIG.ASSOCIATED_RESET {c2_ddr4_ui_clk_sync_rst:c2_ddr4_aresetn} \
 ] $c2_ddr4_ui_clk
  set c2_ddr4_ui_clk_sync_rst [ create_bd_port -dir O -type rst c2_ddr4_ui_clk_sync_rst ]
  set c2_init_calib_complete [ create_bd_port -dir O c2_init_calib_complete ]
  # Create instance: ddr4_2, and set properties
  set ddr4_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4 ddr4_2 ]
  set_property -dict [ list \
      CONFIG.C0.BANK_GROUP_WIDTH {1} \
      CONFIG.C0.DDR4_AxiAddressWidth {31} \
      CONFIG.C0.DDR4_AxiDataWidth {512} \
      CONFIG.C0.DDR4_CLKOUT0_DIVIDE {4} \
      CONFIG.C0.DDR4_CasLatency {17} \
      CONFIG.C0.DDR4_CasWriteLatency {12} \
      CONFIG.C0.DDR4_DataMask {NO_DM_NO_DBI} \
      CONFIG.C0.DDR4_DataWidth {72} \
      CONFIG.C0.DDR4_Ecc {true} \
      CONFIG.C0.DDR4_InputClockPeriod {4998} \
      CONFIG.C0.DDR4_MemoryPart {MT40A256M16GE-075E} \
      CONFIG.C0.DDR4_TimePeriod {833} \
 ] $ddr4_2
 }


  if {$USE_DDR4_C3 == 1} {
  set C3_DDR4 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 C3_DDR4 ]
  set C3_DDR4_S_AXI [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 C3_DDR4_S_AXI ]
  set_property -dict [ list \
      CONFIG.ADDR_WIDTH {31} \
      CONFIG.ARUSER_WIDTH {0} \
      CONFIG.AWUSER_WIDTH {0} \
      CONFIG.BUSER_WIDTH {0} \
      CONFIG.DATA_WIDTH {512} \
      CONFIG.HAS_BRESP {1} \
      CONFIG.HAS_BURST {1} \
      CONFIG.HAS_CACHE {1} \
      CONFIG.HAS_LOCK {1} \
      CONFIG.HAS_PROT {1} \
      CONFIG.HAS_QOS {1} \
      CONFIG.HAS_REGION {0} \
      CONFIG.HAS_RRESP {1} \
      CONFIG.HAS_WSTRB {1} \
      CONFIG.MAX_BURST_LENGTH {256} \
      CONFIG.NUM_READ_OUTSTANDING {2} \
      CONFIG.NUM_READ_THREADS {1} \
      CONFIG.NUM_WRITE_OUTSTANDING {2} \
      CONFIG.NUM_WRITE_THREADS {1} \
      CONFIG.PROTOCOL {AXI4} \
      CONFIG.READ_WRITE_MODE {READ_WRITE} \
      CONFIG.RUSER_BITS_PER_BYTE {0} \
      CONFIG.RUSER_WIDTH {0} \
      CONFIG.SUPPORTS_NARROW_BURST {1} \
      CONFIG.WUSER_BITS_PER_BYTE {0} \
      CONFIG.WUSER_WIDTH {0} \
 ] $C3_DDR4_S_AXI
  set_property CONFIG.ID_WIDTH $C3_DDR4_AXIID_WIDTH $C3_DDR4_S_AXI
  set C3_DDR4_S_AXI_CTRL [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 C3_DDR4_S_AXI_CTRL ]
  set_property -dict [ list \
CONFIG.ADDR_WIDTH {32} \
CONFIG.ARUSER_WIDTH {0} \
CONFIG.AWUSER_WIDTH {0} \
CONFIG.BUSER_WIDTH {0} \
CONFIG.DATA_WIDTH {32} \
CONFIG.HAS_BRESP {1} \
CONFIG.HAS_BURST {0} \
CONFIG.HAS_CACHE {0} \
CONFIG.HAS_LOCK {0} \
CONFIG.HAS_PROT {0} \
CONFIG.HAS_QOS {0} \
CONFIG.HAS_REGION {0} \
CONFIG.HAS_RRESP {1} \
CONFIG.HAS_WSTRB {0} \
CONFIG.ID_WIDTH {0} \
CONFIG.MAX_BURST_LENGTH {1} \
CONFIG.NUM_READ_OUTSTANDING {1} \
CONFIG.NUM_READ_THREADS {1} \
CONFIG.NUM_WRITE_OUTSTANDING {1} \
CONFIG.NUM_WRITE_THREADS {1} \
CONFIG.PROTOCOL {AXI4LITE} \
CONFIG.READ_WRITE_MODE {READ_WRITE} \
CONFIG.RUSER_BITS_PER_BYTE {0} \
CONFIG.RUSER_WIDTH {0} \
CONFIG.SUPPORTS_NARROW_BURST {0} \
CONFIG.WUSER_BITS_PER_BYTE {0} \
CONFIG.WUSER_WIDTH {0} \
 ] $C3_DDR4_S_AXI_CTRL
  set C3_SYS_CLK [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 C3_SYS_CLK ]
  set_property -dict [ list \
      CONFIG.FREQ_HZ {200000000} \
 ] $C3_SYS_CLK
  # Create ports
  set c3_ddr4_aresetn [ create_bd_port -dir I -type rst c3_ddr4_aresetn ]
  set c3_ddr4_interrupt [ create_bd_port -dir O c3_ddr4_interrupt ]
  set c3_ddr4_ui_clk [ create_bd_port -dir O -type clk c3_ddr4_ui_clk ]
  set_property -dict [ list \
      CONFIG.ASSOCIATED_BUSIF {C3_DDR4_S_AXI:C3_DDR4_S_AXI_CTRL} \
      CONFIG.ASSOCIATED_RESET {c3_ddr4_ui_clk_sync_rst:c3_ddr4_aresetn} \
 ] $c3_ddr4_ui_clk
  set c3_ddr4_ui_clk_sync_rst [ create_bd_port -dir O -type rst c3_ddr4_ui_clk_sync_rst ]
  set c3_init_calib_complete [ create_bd_port -dir O c3_init_calib_complete ]
  # Create instance: ddr4_3, and set properties
  set ddr4_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4 ddr4_3 ]
  set_property -dict [ list \
      CONFIG.C0.BANK_GROUP_WIDTH {1} \
      CONFIG.C0.DDR4_AxiAddressWidth {31} \
      CONFIG.C0.DDR4_AxiDataWidth {512} \
      CONFIG.C0.DDR4_CLKOUT0_DIVIDE {4} \
      CONFIG.C0.DDR4_CasLatency {17} \
      CONFIG.C0.DDR4_CasWriteLatency {12} \
      CONFIG.C0.DDR4_DataMask {NO_DM_NO_DBI} \
      CONFIG.C0.DDR4_DataWidth {72} \
      CONFIG.C0.DDR4_Ecc {true} \
      CONFIG.C0.DDR4_InputClockPeriod {4998} \
      CONFIG.C0.DDR4_MemoryPart {MT40A256M16GE-075E} \
      CONFIG.C0.DDR4_TimePeriod {833} \
 ] $ddr4_3
 }

  set reset_rtl [ create_bd_port -dir I -type rst reset_rtl ]
  set_property -dict [ list \
      CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset_rtl




  if {$USE_DDR4_C0 == 1} {
  # Create interface connections
  connect_bd_intf_net -intf_net C0_DDR4_S_AXI_1 [get_bd_intf_ports C0_DDR4_S_AXI] [get_bd_intf_pins ddr4_0/C0_DDR4_S_AXI]
  connect_bd_intf_net -intf_net C0_DDR4_S_AXI_CTRL_3 [get_bd_intf_ports C0_DDR4_S_AXI_CTRL] [get_bd_intf_pins ddr4_0/C0_DDR4_S_AXI_CTRL]
  connect_bd_intf_net -intf_net ddr4_0_C0_DDR4 [get_bd_intf_ports C0_DDR4] [get_bd_intf_pins ddr4_0/C0_DDR4]
  connect_bd_intf_net -intf_net diff_clock_rtl_1 [get_bd_intf_ports C0_SYS_CLK] [get_bd_intf_pins ddr4_0/C0_SYS_CLK]
  # Create port connections
  connect_bd_net -net c0_ddr4_aresetn_1_1 [get_bd_ports c0_ddr4_aresetn] [get_bd_pins ddr4_0/c0_ddr4_aresetn]
  connect_bd_net -net ddr4_0_c0_ddr4_interrupt [get_bd_ports c0_ddr4_interrupt] [get_bd_pins ddr4_0/c0_ddr4_interrupt]
  connect_bd_net -net ddr4_0_c0_ddr4_ui_clk [get_bd_ports c0_ddr4_ui_clk] [get_bd_pins ddr4_0/c0_ddr4_ui_clk]
  connect_bd_net -net ddr4_0_c0_ddr4_ui_clk_sync_rst [get_bd_ports c0_ddr4_ui_clk_sync_rst] [get_bd_pins ddr4_0/c0_ddr4_ui_clk_sync_rst]
  connect_bd_net -net ddr4_0_c0_init_calib_complete [get_bd_ports c0_init_calib_complete] [get_bd_pins ddr4_0/c0_init_calib_complete]
  connect_bd_net -net reset_rtl_1 [get_bd_ports reset_rtl] [get_bd_pins ddr4_0/sys_rst]
  # Create address segments
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces C0_DDR4_S_AXI] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] SEG_ddr4_0_C0_DDR4_ADDRESS_BLOCK
  create_bd_addr_seg -range 0x00100000 -offset 0x00000000 [get_bd_addr_spaces C0_DDR4_S_AXI_CTRL] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP_CTRL/C0_REG] SEG_ddr4_0_C0_REG
  }

  if {$USE_DDR4_C1 == 1} {
  # Create interface connections
  connect_bd_intf_net -intf_net C0_DDR4_S_AXI_1_1 [get_bd_intf_ports C1_DDR4_S_AXI] [get_bd_intf_pins ddr4_1/C0_DDR4_S_AXI]
  connect_bd_intf_net -intf_net C0_DDR4_S_AXI_CTRL_1_1 [get_bd_intf_ports C1_DDR4_S_AXI_CTRL] [get_bd_intf_pins ddr4_1/C0_DDR4_S_AXI_CTRL]
  connect_bd_intf_net -intf_net C0_SYS_CLK_1 [get_bd_intf_ports C1_SYS_CLK] [get_bd_intf_pins ddr4_1/C0_SYS_CLK]
  connect_bd_intf_net -intf_net ddr4_1_C0_DDR4 [get_bd_intf_ports C1_DDR4] [get_bd_intf_pins ddr4_1/C0_DDR4]
  # Create port connections
  connect_bd_net -net c0_ddr4_aresetn_1 [get_bd_ports c1_ddr4_aresetn] [get_bd_pins ddr4_1/c0_ddr4_aresetn]
  connect_bd_net -net ddr4_1_c0_ddr4_interrupt [get_bd_ports c1_ddr4_interrupt] [get_bd_pins ddr4_1/c0_ddr4_interrupt]
  connect_bd_net -net ddr4_1_c0_ddr4_ui_clk [get_bd_ports c1_ddr4_ui_clk] [get_bd_pins ddr4_1/c0_ddr4_ui_clk]
  connect_bd_net -net ddr4_1_c0_ddr4_ui_clk_sync_rst [get_bd_ports c1_ddr4_ui_clk_sync_rst] [get_bd_pins ddr4_1/c0_ddr4_ui_clk_sync_rst]
  connect_bd_net -net ddr4_1_c0_init_calib_complete [get_bd_ports c1_init_calib_complete] [get_bd_pins ddr4_1/c0_init_calib_complete]
  connect_bd_net -net reset_rtl_1 [get_bd_ports reset_rtl] [get_bd_pins ddr4_1/sys_rst] 
  # Create address segments
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces C1_DDR4_S_AXI] [get_bd_addr_segs ddr4_1/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] SEG_ddr4_1_C0_DDR4_ADDRESS_BLOCK
  create_bd_addr_seg -range 0x00100000 -offset 0x00000000 [get_bd_addr_spaces C1_DDR4_S_AXI_CTRL] [get_bd_addr_segs ddr4_1/C0_DDR4_MEMORY_MAP_CTRL/C0_REG] SEG_ddr4_1_C0_REG
  }

  if {$USE_DDR4_C2 == 1} {
  # Create interface connections
  connect_bd_intf_net -intf_net C0_DDR4_S_AXI_1_2 [get_bd_intf_ports C2_DDR4_S_AXI] [get_bd_intf_pins ddr4_2/C0_DDR4_S_AXI]
  connect_bd_intf_net -intf_net C0_DDR4_S_AXI_CTRL_2 [get_bd_intf_ports C2_DDR4_S_AXI_CTRL] [get_bd_intf_pins ddr4_2/C0_DDR4_S_AXI_CTRL]
  connect_bd_intf_net -intf_net C0_SYS_CLK_1_1 [get_bd_intf_ports C2_SYS_CLK] [get_bd_intf_pins ddr4_2/C0_SYS_CLK]
  connect_bd_intf_net -intf_net ddr4_2_C0_DDR4 [get_bd_intf_ports C2_DDR4] [get_bd_intf_pins ddr4_2/C0_DDR4]
  # Create port connections
  connect_bd_net -net c0_ddr4_aresetn_2 [get_bd_ports c2_ddr4_aresetn] [get_bd_pins ddr4_2/c0_ddr4_aresetn]
  connect_bd_net -net ddr4_2_c0_ddr4_interrupt [get_bd_ports c2_ddr4_interrupt] [get_bd_pins ddr4_2/c0_ddr4_interrupt]
  connect_bd_net -net ddr4_2_c0_ddr4_ui_clk [get_bd_ports c2_ddr4_ui_clk] [get_bd_pins ddr4_2/c0_ddr4_ui_clk]
  connect_bd_net -net ddr4_2_c0_ddr4_ui_clk_sync_rst [get_bd_ports c2_ddr4_ui_clk_sync_rst] [get_bd_pins ddr4_2/c0_ddr4_ui_clk_sync_rst]
  connect_bd_net -net ddr4_2_c0_init_calib_complete [get_bd_ports c2_init_calib_complete] [get_bd_pins ddr4_2/c0_init_calib_complete]
  connect_bd_net -net reset_rtl_1 [get_bd_ports reset_rtl] [get_bd_pins ddr4_2/sys_rst] 
  # Create address segments
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces C2_DDR4_S_AXI] [get_bd_addr_segs ddr4_2/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] SEG_ddr4_2_C0_DDR4_ADDRESS_BLOCK
  create_bd_addr_seg -range 0x00100000 -offset 0x00000000 [get_bd_addr_spaces C2_DDR4_S_AXI_CTRL] [get_bd_addr_segs ddr4_2/C0_DDR4_MEMORY_MAP_CTRL/C0_REG] SEG_ddr4_2_C0_REG
  }

  if {$USE_DDR4_C3 == 1} {
  # Create interface connections
  connect_bd_intf_net -intf_net C0_DDR4_S_AXI_1_3 [get_bd_intf_ports C3_DDR4_S_AXI] [get_bd_intf_pins ddr4_3/C0_DDR4_S_AXI]
  connect_bd_intf_net -intf_net C0_DDR4_S_AXI_CTRL_1 [get_bd_intf_ports C3_DDR4_S_AXI_CTRL] [get_bd_intf_pins ddr4_3/C0_DDR4_S_AXI_CTRL]
  connect_bd_intf_net -intf_net C0_SYS_CLK_1_2 [get_bd_intf_ports C3_SYS_CLK] [get_bd_intf_pins ddr4_3/C0_SYS_CLK]
  connect_bd_intf_net -intf_net ddr4_3_C0_DDR4 [get_bd_intf_ports C3_DDR4] [get_bd_intf_pins ddr4_3/C0_DDR4]
  # Create port connections
  connect_bd_net -net c0_ddr4_aresetn_2_1 [get_bd_ports c3_ddr4_aresetn] [get_bd_pins ddr4_3/c0_ddr4_aresetn]
  connect_bd_net -net ddr4_3_c0_ddr4_interrupt [get_bd_ports c3_ddr4_interrupt] [get_bd_pins ddr4_3/c0_ddr4_interrupt]
  connect_bd_net -net ddr4_3_c0_ddr4_ui_clk [get_bd_ports c3_ddr4_ui_clk] [get_bd_pins ddr4_3/c0_ddr4_ui_clk]
  connect_bd_net -net ddr4_3_c0_ddr4_ui_clk_sync_rst [get_bd_ports c3_ddr4_ui_clk_sync_rst] [get_bd_pins ddr4_3/c0_ddr4_ui_clk_sync_rst]
  connect_bd_net -net ddr4_3_c0_init_calib_complete [get_bd_ports c3_init_calib_complete] [get_bd_pins ddr4_3/c0_init_calib_complete]
  connect_bd_net -net reset_rtl_1 [get_bd_ports reset_rtl] [get_bd_pins ddr4_3/sys_rst]
  # Create address segments
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces C3_DDR4_S_AXI] [get_bd_addr_segs ddr4_3/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] SEG_ddr4_3_C0_DDR4_ADDRESS_BLOCK
  create_bd_addr_seg -range 0x00100000 -offset 0x00000000 [get_bd_addr_spaces C3_DDR4_S_AXI_CTRL] [get_bd_addr_segs ddr4_3/C0_DDR4_MEMORY_MAP_CTRL/C0_REG] SEG_ddr4_3_C0_REG
  }

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.6.5b  2016-09-06 bk=1.3687 VDI=39 GEI=35 GUI=JA:1.6#  -string -flagsOSRD
      preplace port reset_rtl -pg 1 -y 120 -defaultsOSRD
      preplace netloc reset_rtl_1 1 0 1 0
      levelinfo -pg 1 -20 170 350 -top 0 -bot 720
      ",
   }

  # Perform GUI Layout
  if {$USE_DDR4_C0 == 1} {
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.6.5b  2016-09-06 bk=1.3687 VDI=39 GEI=35 GUI=JA:1.6#  -string -flagsOSRD

      preplace port C0_SYS_CLK -pg 1 -y 240 -defaultsOSRD
      preplace port C0_DDR4_S_AXI -pg 1 -y 260 -defaultsOSRD
      preplace port C0_DDR4_S_AXI_CTRL -pg 1 -y 230 -defaultsOSRD
      preplace port C0_DDR4 -pg 1 -y 220 -defaultsOSRD
      preplace inst ddr4_0 -pg 1 -lvl 1 -y 270 -defaultsOSRD
      preplace port c0_ddr4_aresetn -pg 1 -y 280 -defaultsOSRD
      preplace port c0_ddr4_interrupt -pg 1 -y 310 -defaultsOSRD
      preplace port c0_ddr4_ui_clk -pg 1 -y 300 -defaultsOSRD
      preplace port c0_ddr4_ui_clk_sync_rst -pg 1 -y 320 -defaultsOSRD
      preplace port c0_init_calib_complete -pg 1 -y 240 -defaultsOSRD
      preplace netloc diff_clock_rtl_1 1 0 1 NJ
      preplace netloc ddr4_0_c0_ddr4_ui_clk 1 1 1 NJ
      preplace netloc ddr4_0_c0_ddr4_ui_clk_sync_rst 1 1 1 NJ
      preplace netloc ddr4_0_c0_init_calib_complete 1 1 1 NJ
      preplace netloc ddr4_0_C0_DDR4 1 1 1 NJ
      preplace netloc c0_ddr4_aresetn_1 1 0 1 N
      preplace netloc ddr4_0_c0_ddr4_interrupt 1 1 1 N
      preplace netloc C0_DDR4_S_AXI_1 1 0 1 NJ
      preplace netloc C0_DDR4_S_AXI_CTRL_1 1 0 1 N
      ",
   }
}
  # Perform GUI Layout
  if {$USE_DDR4_C1 == 1} {
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.6.5b  2016-09-06 bk=1.3687 VDI=39 GEI=35 GUI=JA:1.6#  -string -flagsOSRD

      preplace port C1_SYS_CLK -pg 1 -y 60 -defaultsOSRD
      preplace port C1_DDR4_S_AXI -pg 1 -y 80 -defaultsOSRD
      preplace port C1_DDR4 -pg 1 -y 40 -defaultsOSRD
      preplace port C1_DDR4_S_AXI_CTRL -pg 1 -y 30 -defaultsOSRD
      preplace inst ddr4_1 -pg 1 -lvl 1 -y 90 -defaultsOSRD
      preplace port c1_ddr4_aresetn -pg 1 -y 100 -defaultsOSRD
      preplace port c1_ddr4_interrupt -pg 1 -y 110 -defaultsOSRD
      preplace port c1_ddr4_ui_clk -pg 1 -y 120 -defaultsOSRD
      preplace port c1_ddr4_ui_clk_sync_rst -pg 1 -y 140 -defaultsOSRD
      preplace port c1_init_calib_complete -pg 1 -y 60 -defaultsOSRD
      preplace netloc C0_SYS_CLK_1 1 0 1 NJ
      preplace netloc ddr4_1_c0_ddr4_ui_clk 1 1 1 NJ
      preplace netloc ddr4_1_c0_ddr4_ui_clk_sync_rst 1 1 1 NJ
      preplace netloc ddr4_1_c0_init_calib_complete 1 1 1 NJ
      preplace netloc ddr4_1_C0_DDR4 1 1 1 NJ
      preplace netloc c0_ddr4_aresetn_1_1 1 0 1 N
      preplace netloc ddr4_1_c0_ddr4_interrupt 1 1 1 N
      preplace netloc C0_DDR4_S_AXI_1_1 1 0 1 NJ
      preplace netloc C0_DDR4_S_AXI_CTRL_1_1 1 0 1 N
      ",
   }
}

  # Perform GUI Layout
  if {$USE_DDR4_C2 == 1} {
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.6.5b  2016-09-06 bk=1.3687 VDI=39 GEI=35 GUI=JA:1.6#  -string -flagsOSRD

      preplace port C2_SYS_CLK -pg 1 -y 420 -defaultsOSRD
      preplace port C2_DDR4_S_AXI -pg 1 -y 440 -defaultsOSRD
      preplace port C2_DDR4_S_AXI_CTRL -pg 1 -y 430 -defaultsOSRD
      preplace port C2_DDR4 -pg 1 -y 400 -defaultsOSRD
      preplace inst ddr4_2 -pg 1 -lvl 1 -y 450 -defaultsOSRD
      preplace port c2_ddr4_aresetn -pg 1 -y 460 -defaultsOSRD
      preplace port c2_ddr4_interrupt -pg 1 -y 510 -defaultsOSRD
      preplace port c2_ddr4_ui_clk -pg 1 -y 480 -defaultsOSRD
      preplace port c2_ddr4_ui_clk_sync_rst -pg 1 -y 500 -defaultsOSRD
      preplace port c2_init_calib_complete -pg 1 -y 420 -defaultsOSRD
      preplace netloc C0_SYS_CLK_1_1 1 0 1 NJ
      preplace netloc ddr4_2_c0_ddr4_ui_clk 1 1 1 NJ
      preplace netloc ddr4_2_c0_ddr4_ui_clk_sync_rst 1 1 1 NJ
      preplace netloc ddr4_2_c0_init_calib_complete 1 1 1 NJ
      preplace netloc ddr4_2_C0_DDR4 1 1 1 NJ
      preplace netloc c0_ddr4_aresetn_2 1 0 1 N
      preplace netloc C0_DDR4_S_AXI_1_2 1 0 1 NJ
      preplace netloc C0_DDR4_S_AXI_CTRL_2 1 0 1 N
      preplace netloc ddr4_2_c0_ddr4_interrupt 1 1 1 N
      ",
   }
}

  # Perform GUI Layout
  if {$USE_DDR4_C3 == 1} {
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.6.5b  2016-09-06 bk=1.3687 VDI=39 GEI=35 GUI=JA:1.6#  -string -flagsOSRD

      preplace port C3_SYS_CLK -pg 1 -y 590 -defaultsOSRD
      preplace port C3_DDR4_S_AXI -pg 1 -y 630 -defaultsOSRD
      preplace port C3_DDR4_S_AXI_CTRL -pg 1 -y 610 -defaultsOSRD
      preplace port C3_DDR4 -pg 1 -y 570 -defaultsOSRD
      preplace inst ddr4_3 -pg 1 -lvl 1 -y 630 -defaultsOSRD
      preplace port c3_ddr4_aresetn -pg 1 -y 650 -defaultsOSRD
      preplace port c3_ddr4_interrupt -pg 1 -y 690 -defaultsOSRD
      preplace port c3_ddr4_ui_clk -pg 1 -y 650 -defaultsOSRD
      preplace port c3_ddr4_ui_clk_sync_rst -pg 1 -y 670 -defaultsOSRD
      preplace port c3_init_calib_complete -pg 1 -y 590 -defaultsOSRD
      preplace netloc C0_SYS_CLK_1_2 1 0 1 NJ
      preplace netloc ddr4_3_c0_ddr4_ui_clk 1 1 1 NJ
      preplace netloc ddr4_3_c0_ddr4_ui_clk_sync_rst 1 1 1 NJ
      preplace netloc ddr4_3_c0_init_calib_complete 1 1 1 NJ
      preplace netloc ddr4_3_C0_DDR4 1 1 1 NJ
      preplace netloc c0_ddr4_aresetn_2_1 1 0 1 N
      preplace netloc ddr4_3_c0_ddr4_interrupt 1 1 1 N
      preplace netloc C0_DDR4_S_AXI_1_3 1 0 1 NJ
      preplace netloc C0_DDR4_S_AXI_CTRL_3 1 0 1 N
      ",
   }
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


