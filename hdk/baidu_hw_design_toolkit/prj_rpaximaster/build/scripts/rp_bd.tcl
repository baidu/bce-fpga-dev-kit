
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


# The design that will be created by this Tcl script contains the following 
# module references:
# card_addr_translate

# Please add the sources of those modules before sourcing this Tcl script.

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
  set C1_DDR4_M_AXI [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 C1_DDR4_M_AXI ]
  set_property -dict [ list \
CONFIG.ADDR_WIDTH {31} \
CONFIG.DATA_WIDTH {512} \
CONFIG.FREQ_HZ {300000000} \
CONFIG.NUM_READ_OUTSTANDING {2} \
CONFIG.NUM_WRITE_OUTSTANDING {2} \
CONFIG.PROTOCOL {AXI4} \
 ] $C1_DDR4_M_AXI
  set C2_DDR4_M_AXI [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 C2_DDR4_M_AXI ]
  set_property -dict [ list \
CONFIG.ADDR_WIDTH {31} \
CONFIG.DATA_WIDTH {512} \
CONFIG.FREQ_HZ {300000000} \
CONFIG.NUM_READ_OUTSTANDING {2} \
CONFIG.NUM_WRITE_OUTSTANDING {2} \
CONFIG.PROTOCOL {AXI4} \
 ] $C2_DDR4_M_AXI
  set C3_DDR4_M_AXI [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 C3_DDR4_M_AXI ]
  set_property -dict [ list \
CONFIG.ADDR_WIDTH {31} \
CONFIG.DATA_WIDTH {512} \
CONFIG.FREQ_HZ {300000000} \
CONFIG.NUM_READ_OUTSTANDING {2} \
CONFIG.NUM_WRITE_OUTSTANDING {2} \
CONFIG.PROTOCOL {AXI4} \
 ] $C3_DDR4_M_AXI
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
CONFIG.ID_WIDTH {3} \
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
  set i_soft_rst_n [ create_bd_port -dir I -type rst i_soft_rst_n ]
  set s_axi_aclk [ create_bd_port -dir I -type clk s_axi_aclk ]
  set_property -dict [ list \
CONFIG.ASSOCIATED_BUSIF {S_AXI:S_AXI_LITE:M_AXI} \
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

  # Create instance: axi_cdma_0, and set properties
  set axi_cdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_cdma axi_cdma_0 ]
  set_property -dict [ list \
CONFIG.C_ADDR_WIDTH {64} \
CONFIG.C_INCLUDE_SF {1} \
CONFIG.C_INCLUDE_SG {0} \
CONFIG.C_M_AXI_DATA_WIDTH {256} \
CONFIG.C_M_AXI_MAX_BURST_LEN {128} \
CONFIG.C_USE_DATAMOVER_LITE {0} \
 ] $axi_cdma_0

  # Create instance: axi_interconnect_1, and set properties
  set axi_interconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect axi_interconnect_1 ]
  set_property -dict [ list \
CONFIG.M00_HAS_DATA_FIFO {1} \
CONFIG.M00_HAS_REGSLICE {4} \
CONFIG.M01_HAS_DATA_FIFO {1} \
CONFIG.M01_HAS_REGSLICE {4} \
CONFIG.M02_HAS_DATA_FIFO {1} \
CONFIG.M02_HAS_REGSLICE {4} \
CONFIG.M03_HAS_DATA_FIFO {1} \
CONFIG.M03_HAS_REGSLICE {4} \
CONFIG.M04_HAS_DATA_FIFO {1} \
CONFIG.M04_HAS_REGSLICE {4} \
CONFIG.NUM_MI {5} \
CONFIG.NUM_SI {2} \
CONFIG.S00_HAS_DATA_FIFO {0} \
CONFIG.S00_HAS_REGSLICE {4} \
CONFIG.S01_HAS_DATA_FIFO {0} \
CONFIG.S01_HAS_REGSLICE {4} \
 ] $axi_interconnect_1

  # Create instance: axi_register_slice_0, and set properties
  set axi_register_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice axi_register_slice_0 ]

  # Create instance: axi_register_slice_1, and set properties
  set axi_register_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice axi_register_slice_1 ]

  # Create instance: axi_register_slice_2, and set properties
  set axi_register_slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice axi_register_slice_2 ]

  # Create instance: axi_register_slice_3, and set properties
  set axi_register_slice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice axi_register_slice_3 ]

  # Create instance: axi_register_slice_4, and set properties
  set axi_register_slice_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice axi_register_slice_4 ]
  set_property -dict [ list \
CONFIG.ID_WIDTH {4} \
 ] $axi_register_slice_4

  # Create instance: card_addr_translate_0, and set properties
  set block_name card_addr_translate
  set block_cell_name card_addr_translate_0
  if { [catch {set card_addr_translate_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $card_addr_translate_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.ID_WIDTH {3} \
 ] $card_addr_translate_0

  # Create instance: ila_0, and set properties
  set ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila ila_0 ]
  set_property -dict [ list \
CONFIG.C_ENABLE_ILA_AXI_MON {false} \
CONFIG.C_MONITOR_TYPE {Native} \
CONFIG.C_NUM_OF_PROBES {1} \
CONFIG.C_PROBE0_WIDTH {9} \
 ] $ila_0

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic util_vector_logic_0 ]
  set_property -dict [ list \
CONFIG.C_SIZE {1} \
 ] $util_vector_logic_0

  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic util_vector_logic_1 ]
  set_property -dict [ list \
CONFIG.C_OPERATION {not} \
CONFIG.C_SIZE {1} \
CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_1

  # Create instance: util_vector_logic_2, and set properties
  set util_vector_logic_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic util_vector_logic_2 ]
  set_property -dict [ list \
CONFIG.C_OPERATION {not} \
CONFIG.C_SIZE {1} \
CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_2

  # Create instance: util_vector_logic_3, and set properties
  set util_vector_logic_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic util_vector_logic_3 ]
  set_property -dict [ list \
CONFIG.C_OPERATION {not} \
CONFIG.C_SIZE {1} \
CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_3

  # Create instance: util_vector_logic_4, and set properties
  set util_vector_logic_4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic util_vector_logic_4 ]
  set_property -dict [ list \
CONFIG.C_OPERATION {not} \
CONFIG.C_SIZE {1} \
CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_4

  # Create instance: util_vector_logic_5, and set properties
  set util_vector_logic_5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic util_vector_logic_5 ]
  set_property -dict [ list \
CONFIG.C_OPERATION {not} \
CONFIG.C_SIZE {1} \
CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_5

  # Create interface connections
  connect_bd_intf_net -intf_net S_AXI_1 [get_bd_intf_ports S_AXI] [get_bd_intf_pins axi_register_slice_1/S_AXI]
  connect_bd_intf_net -intf_net S_AXI_LITE_1 [get_bd_intf_ports S_AXI_LITE] [get_bd_intf_pins axi_register_slice_0/S_AXI]
  connect_bd_intf_net -intf_net axi_cdma_0_M_AXI [get_bd_intf_pins axi_cdma_0/M_AXI] [get_bd_intf_pins axi_interconnect_1/S01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M00_AXI [get_bd_intf_ports C0_DDR4_M_AXI] [get_bd_intf_pins axi_interconnect_1/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M01_AXI [get_bd_intf_ports C1_DDR4_M_AXI] [get_bd_intf_pins axi_interconnect_1/M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M02_AXI [get_bd_intf_pins axi_interconnect_1/M02_AXI] [get_bd_intf_pins axi_register_slice_2/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M03_AXI [get_bd_intf_pins axi_interconnect_1/M03_AXI] [get_bd_intf_pins axi_register_slice_3/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M04_AXI [get_bd_intf_pins axi_interconnect_1/M04_AXI] [get_bd_intf_pins axi_register_slice_4/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI [get_bd_intf_pins axi_register_slice_0/M_AXI] [get_bd_intf_pins card_addr_translate_0/s_axi_lite]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI [get_bd_intf_pins axi_register_slice_1/M_AXI] [get_bd_intf_pins card_addr_translate_0/s_axi]
  connect_bd_intf_net -intf_net axi_register_slice_2_M_AXI [get_bd_intf_ports C2_DDR4_M_AXI] [get_bd_intf_pins axi_register_slice_2/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_3_M_AXI [get_bd_intf_ports C3_DDR4_M_AXI] [get_bd_intf_pins axi_register_slice_3/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_4_M_AXI [get_bd_intf_ports M_AXI] [get_bd_intf_pins axi_register_slice_4/M_AXI]
  connect_bd_intf_net -intf_net card_addr_translate_0_m_axi [get_bd_intf_pins axi_interconnect_1/S00_AXI] [get_bd_intf_pins card_addr_translate_0/m_axi]
  connect_bd_intf_net -intf_net card_addr_translate_0_m_axi_lite [get_bd_intf_pins axi_cdma_0/S_AXI_LITE] [get_bd_intf_pins card_addr_translate_0/m_axi_lite]

  # Create port connections
  connect_bd_net -net axi_cdma_0_cdma_introut [get_bd_pins axi_cdma_0/cdma_introut] [get_bd_pins card_addr_translate_0/axi_cdma_interrupt]
  connect_bd_net -net c0_ddr4_ui_clk_1 [get_bd_ports c0_ddr4_ui_clk] [get_bd_pins axi_interconnect_1/M00_ACLK]
  connect_bd_net -net c0_ddr4_ui_clk_sync_rst_1 [get_bd_ports c0_ddr4_ui_clk_sync_rst] [get_bd_pins util_vector_logic_2/Op1]
  connect_bd_net -net c1_ddr4_ui_clk_1 [get_bd_ports c1_ddr4_ui_clk] [get_bd_pins axi_interconnect_1/M01_ACLK]
  connect_bd_net -net c1_ddr4_ui_clk_sync_rst_1 [get_bd_ports c1_ddr4_ui_clk_sync_rst] [get_bd_pins util_vector_logic_3/Op1]
  connect_bd_net -net c2_ddr4_ui_clk_1 [get_bd_ports c2_ddr4_ui_clk] [get_bd_pins axi_interconnect_1/M02_ACLK] [get_bd_pins axi_register_slice_2/aclk]
  connect_bd_net -net c2_ddr4_ui_clk_sync_rst_1 [get_bd_ports c2_ddr4_ui_clk_sync_rst] [get_bd_pins util_vector_logic_4/Op1]
  connect_bd_net -net c3_ddr4_ui_clk_1 [get_bd_ports c3_ddr4_ui_clk] [get_bd_pins axi_interconnect_1/M03_ACLK] [get_bd_pins axi_register_slice_3/aclk]
  connect_bd_net -net c3_ddr4_ui_clk_sync_rst_1 [get_bd_ports c3_ddr4_ui_clk_sync_rst] [get_bd_pins util_vector_logic_5/Op1]
  connect_bd_net -net card_addr_translate_0_dbg_bus [get_bd_pins card_addr_translate_0/dbg_bus] [get_bd_pins ila_0/probe0]
  connect_bd_net -net card_addr_translate_0_usr_irq_req [get_bd_ports usr_irq_req] [get_bd_pins card_addr_translate_0/usr_irq_req]
  connect_bd_net -net i_soft_rst_n_1 [get_bd_ports i_soft_rst_n] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net s_axi_aclk_1 [get_bd_ports s_axi_aclk] [get_bd_pins axi_cdma_0/m_axi_aclk] [get_bd_pins axi_cdma_0/s_axi_lite_aclk] [get_bd_pins axi_interconnect_1/ACLK] [get_bd_pins axi_interconnect_1/M04_ACLK] [get_bd_pins axi_interconnect_1/S00_ACLK] [get_bd_pins axi_interconnect_1/S01_ACLK] [get_bd_pins axi_register_slice_0/aclk] [get_bd_pins axi_register_slice_1/aclk] [get_bd_pins axi_register_slice_4/aclk] [get_bd_pins card_addr_translate_0/clk] [get_bd_pins ila_0/clk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_ports s_axi_aresetn] [get_bd_pins axi_interconnect_1/ARESETN] [get_bd_pins axi_interconnect_1/M04_ARESETN] [get_bd_pins axi_interconnect_1/S00_ARESETN] [get_bd_pins axi_interconnect_1/S01_ARESETN] [get_bd_pins axi_register_slice_0/aresetn] [get_bd_pins axi_register_slice_1/aresetn] [get_bd_pins axi_register_slice_4/aresetn] [get_bd_pins util_vector_logic_0/Op2]
  connect_bd_net -net usr_irq_ack_1 [get_bd_ports usr_irq_ack] [get_bd_pins card_addr_translate_0/usr_irq_ack]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins axi_cdma_0/s_axi_lite_aresetn] [get_bd_pins util_vector_logic_0/Res] [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins card_addr_translate_0/rst] [get_bd_pins util_vector_logic_1/Res]
  connect_bd_net -net util_vector_logic_2_Res [get_bd_pins axi_interconnect_1/M00_ARESETN] [get_bd_pins util_vector_logic_2/Res]
  connect_bd_net -net util_vector_logic_3_Res [get_bd_pins axi_interconnect_1/M01_ARESETN] [get_bd_pins util_vector_logic_3/Res]
  connect_bd_net -net util_vector_logic_4_Res [get_bd_pins axi_interconnect_1/M02_ARESETN] [get_bd_pins axi_register_slice_2/aresetn] [get_bd_pins util_vector_logic_4/Res]
  connect_bd_net -net util_vector_logic_5_Res [get_bd_pins axi_interconnect_1/M03_ARESETN] [get_bd_pins axi_register_slice_3/aresetn] [get_bd_pins util_vector_logic_5/Res]

  # Create address segments
  create_bd_addr_seg -range 0x80000000 -offset 0x010000000000 [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs C0_DDR4_M_AXI/Reg] SEG_C0_DDR4_M_AXI_Reg
  create_bd_addr_seg -range 0x80000000 -offset 0x010080000000 [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs C1_DDR4_M_AXI/Reg] SEG_C1_DDR4_M_AXI_Reg
  create_bd_addr_seg -range 0x80000000 -offset 0x010100000000 [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs C2_DDR4_M_AXI/Reg] SEG_C2_DDR4_M_AXI_Reg
  create_bd_addr_seg -range 0x80000000 -offset 0x010180000000 [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs C3_DDR4_M_AXI/Reg] SEG_C3_DDR4_M_AXI_Reg
  create_bd_addr_seg -range 0x010000000000 -offset 0x00000000 [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs M_AXI/Reg] SEG_M_AXI_Reg
  create_bd_addr_seg -range 0x80000000 -offset 0x010000000000 [get_bd_addr_spaces card_addr_translate_0/m_axi] [get_bd_addr_segs C0_DDR4_M_AXI/Reg] SEG_C0_DDR4_M_AXI_Reg
  create_bd_addr_seg -range 0x80000000 -offset 0x010080000000 [get_bd_addr_spaces card_addr_translate_0/m_axi] [get_bd_addr_segs C1_DDR4_M_AXI/Reg] SEG_C1_DDR4_M_AXI_Reg
  create_bd_addr_seg -range 0x80000000 -offset 0x010100000000 [get_bd_addr_spaces card_addr_translate_0/m_axi] [get_bd_addr_segs C2_DDR4_M_AXI/Reg] SEG_C2_DDR4_M_AXI_Reg
  create_bd_addr_seg -range 0x80000000 -offset 0x010180000000 [get_bd_addr_spaces card_addr_translate_0/m_axi] [get_bd_addr_segs C3_DDR4_M_AXI/Reg] SEG_C3_DDR4_M_AXI_Reg
  create_bd_addr_seg -range 0x010000000000 -offset 0x00000000 [get_bd_addr_spaces card_addr_translate_0/m_axi] [get_bd_addr_segs M_AXI/Reg] SEG_M_AXI_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x00000000 [get_bd_addr_spaces card_addr_translate_0/m_axi_lite] [get_bd_addr_segs axi_cdma_0/S_AXI_LITE/Reg] SEG_axi_cdma_0_Reg
  create_bd_addr_seg -range 0x000200000000 -offset 0x00000000 [get_bd_addr_spaces S_AXI] [get_bd_addr_segs card_addr_translate_0/s_axi/reg0] SEG_card_addr_translate_0_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x00000000 [get_bd_addr_spaces S_AXI_LITE] [get_bd_addr_segs card_addr_translate_0/s_axi_lite/reg0] SEG_card_addr_translate_0_reg0

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.6.5b  2016-09-06 bk=1.3687 VDI=39 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port s_axi_aclk -pg 1 -y 790 -defaultsOSRD
preplace port c2_ddr4_ui_clk -pg 1 -y 530 -defaultsOSRD
preplace port S_AXI_LITE -pg 1 -y 580 -defaultsOSRD
preplace port C2_DDR4_M_AXI -pg 1 -y 430 -defaultsOSRD
preplace port c1_ddr4_ui_clk_sync_rst -pg 1 -y 170 -defaultsOSRD
preplace port C1_DDR4_M_AXI -pg 1 -y 360 -defaultsOSRD
preplace port c3_ddr4_ui_clk -pg 1 -y 510 -defaultsOSRD
preplace port c1_ddr4_ui_clk -pg 1 -y -10 -defaultsOSRD
preplace port c0_ddr4_ui_clk -pg 1 -y 420 -defaultsOSRD
preplace port c2_ddr4_ui_clk_sync_rst -pg 1 -y 220 -defaultsOSRD
preplace port S_AXI -pg 1 -y 260 -defaultsOSRD
preplace port usr_clk_rst -pg 1 -y 30 -defaultsOSRD
preplace port c3_ddr4_ui_clk_sync_rst -pg 1 -y 240 -defaultsOSRD
preplace port M_AXI -pg 1 -y 670 -defaultsOSRD
preplace port C0_DDR4_M_AXI -pg 1 -y 340 -defaultsOSRD
preplace port s_axi_aresetn -pg 1 -y 200 -defaultsOSRD
preplace port C3_DDR4_M_AXI -pg 1 -y 550 -defaultsOSRD
preplace port i_soft_rst_n -pg 1 -y 350 -defaultsOSRD
preplace port usr_clk -pg 1 -y 10 -defaultsOSRD
preplace port c0_ddr4_ui_clk_sync_rst -pg 1 -y 70 -defaultsOSRD
preplace portBus usr_irq_req -pg 1 -y 740 -defaultsOSRD
preplace portBus usr_irq_ack -pg 1 -y 670 -defaultsOSRD
preplace inst card_addr_translate_0 -pg 1 -lvl 3 -y 490 -defaultsOSRD
preplace inst axi_cdma_0 -pg 1 -lvl 4 -y 510 -defaultsOSRD
preplace inst util_vector_logic_0 -pg 1 -lvl 1 -y 360 -defaultsOSRD
preplace inst system_ila -pg 1 -lvl 4 -y 670 -defaultsOSRD
preplace inst axi_register_slice_0 -pg 1 -lvl 2 -y 600 -defaultsOSRD
preplace inst util_vector_logic_1 -pg 1 -lvl 2 -y 320 -defaultsOSRD
preplace inst axi_register_slice_1 -pg 1 -lvl 2 -y 440 -defaultsOSRD
preplace inst util_vector_logic_2 -pg 1 -lvl 4 -y 70 -defaultsOSRD
preplace inst axi_register_slice_2 -pg 1 -lvl 6 -y 430 -defaultsOSRD
preplace inst util_vector_logic_3 -pg 1 -lvl 4 -y 170 -defaultsOSRD
preplace inst ila_0 -pg 1 -lvl 4 -y 810 -defaultsOSRD
preplace inst axi_register_slice_3 -pg 1 -lvl 6 -y 550 -defaultsOSRD
preplace inst axi_register_slice_4 -pg 1 -lvl 6 -y 740 -defaultsOSRD
preplace inst util_vector_logic_4 -pg 1 -lvl 4 -y 270 -defaultsOSRD
preplace inst util_vector_logic_5 -pg 1 -lvl 4 -y 370 -defaultsOSRD
preplace inst axi_interconnect_1 -pg 1 -lvl 5 -y 380 -defaultsOSRD
preplace netloc S_AXI_LITE_1 1 0 2 NJ 580 NJ
preplace netloc S_AXI_1 1 0 2 NJ 260 260J
preplace netloc i_soft_rst_n_1 1 0 1 NJ
preplace netloc card_addr_translate_0_dbg_bus 1 3 1 920
preplace netloc card_addr_translate_0_m_axi_lite 1 3 1 970
preplace netloc axi_register_slice_0_M_AXI 1 2 1 530
preplace netloc axi_cdma_0_M_AXI 1 4 1 1320
preplace netloc s_axi_aclk_1 1 0 6 NJ 790 280 750 560 750 990 750 1330 750 1680J
preplace netloc card_addr_translate_0_usr_irq_req 1 3 4 960J 430 1290J 650 NJ 650 1960J
preplace netloc axi_interconnect_1_M01_AXI 1 5 2 NJ 360 NJ
preplace netloc s_axi_aresetn_1 1 0 6 0 200 270 200 NJ 200 960J 320 1350 760 NJ
preplace netloc c1_ddr4_ui_clk_1 1 0 5 NJ -10 NJ -10 NJ -10 NJ -10 1380J
preplace netloc axi_interconnect_1_M04_AXI 1 5 1 1670
preplace netloc util_vector_logic_4_Res 1 4 2 1310 640 1690J
preplace netloc util_vector_logic_3_Res 1 4 1 1340J
preplace netloc usr_irq_ack_1 1 0 3 NJ 670 NJ 670 570J
preplace netloc card_addr_translate_0_m_axi 1 3 2 930J 220 1320
preplace netloc util_vector_logic_0_Res 1 1 3 280 370 NJ 370 940
preplace netloc axi_interconnect_1_M02_AXI 1 5 1 1690
preplace netloc c3_ddr4_ui_clk_1 1 0 6 NJ 510 NJ 510 550J 610 980J 590 1380 620 1680J
preplace netloc c1_ddr4_ui_clk_sync_rst_1 1 0 4 NJ 170 NJ 170 NJ 170 NJ
preplace netloc axi_cdma_0_cdma_introut 1 2 3 580 590 950J 420 1280
preplace netloc axi_register_slice_4_M_AXI 1 3 4 1000 740 1380J 670 NJ 670 1950J
preplace netloc axi_register_slice_3_M_AXI 1 6 1 NJ
preplace netloc c3_ddr4_ui_clk_sync_rst_1 1 0 4 NJ 240 NJ 240 NJ 240 950J
preplace netloc axi_interconnect_1_M03_AXI 1 5 1 1680
preplace netloc util_vector_logic_2_Res 1 4 1 1370J
preplace netloc util_vector_logic_1_Res 1 2 1 580
preplace netloc c2_ddr4_ui_clk_1 1 0 6 NJ 530 NJ 530 540J 600 NJ 600 1370 610 1660J
preplace netloc axi_interconnect_1_M00_AXI 1 5 2 NJ 340 NJ
preplace netloc axi_register_slice_1_M_AXI 1 2 1 N
preplace netloc util_vector_logic_5_Res 1 4 2 1300 630 1700J
preplace netloc c2_ddr4_ui_clk_sync_rst_1 1 0 4 NJ 220 NJ 220 NJ 220 920J
preplace netloc c0_ddr4_ui_clk_1 1 0 5 10J 120 NJ 120 NJ 120 NJ 120 1360J
preplace netloc axi_register_slice_2_M_AXI 1 6 1 NJ
preplace netloc c0_ddr4_ui_clk_sync_rst_1 1 0 4 NJ 70 NJ 70 NJ 70 NJ
levelinfo -pg 1 -20 140 410 740 1150 1520 1820 2000 -top -30 -bot 860
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


