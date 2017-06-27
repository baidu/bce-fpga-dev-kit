
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
CONFIG.NUM_READ_OUTSTANDING {16} \
CONFIG.NUM_WRITE_OUTSTANDING {16} \
CONFIG.PROTOCOL {AXI4} \
 ] $C3_DDR4_M_AXI
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
CONFIG.NUM_MI {4} \
CONFIG.NUM_SI {2} \
CONFIG.S00_HAS_REGSLICE {4} \
CONFIG.S01_HAS_REGSLICE {4} \
 ] $axi_interconnect_1

  # Create instance: axi_register_slice_0, and set properties
  set axi_register_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice axi_register_slice_0 ]

  # Create instance: axi_register_slice_1, and set properties
  set axi_register_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice axi_register_slice_1 ]

  # Create instance: axislave_cu_apctrl_v1_0_0, and set properties
  set axislave_cu_apctrl_v1_0_0 [ create_bd_cell -type ip -vlnv baidu.com:user:axislave_cu_apctrl_v1_0 axislave_cu_apctrl_v1_0_0 ]

  # Create instance: example_0, and set properties
  set example_0 [ create_bd_cell -type ip -vlnv xilinx.com:hls:example example_0 ]

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

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_ports S_AXI] [get_bd_intf_pins axi_interconnect_1/S00_AXI]
  connect_bd_intf_net -intf_net S_AXI_LITE_1 [get_bd_intf_ports S_AXI_LITE] [get_bd_intf_pins axislave_cu_apctrl_v1_0_0/s00_axi]
  connect_bd_intf_net -intf_net axi_interconnect_1_M00_AXI [get_bd_intf_ports C0_DDR4_M_AXI] [get_bd_intf_pins axi_interconnect_1/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M01_AXI [get_bd_intf_ports C1_DDR4_M_AXI] [get_bd_intf_pins axi_interconnect_1/M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M02_AXI [get_bd_intf_pins axi_interconnect_1/M02_AXI] [get_bd_intf_pins axi_register_slice_0/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_1_M03_AXI [get_bd_intf_pins axi_interconnect_1/M03_AXI] [get_bd_intf_pins axi_register_slice_1/S_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_0_M_AXI [get_bd_intf_ports C2_DDR4_M_AXI] [get_bd_intf_pins axi_register_slice_0/M_AXI]
  connect_bd_intf_net -intf_net axi_register_slice_1_M_AXI [get_bd_intf_ports C3_DDR4_M_AXI] [get_bd_intf_pins axi_register_slice_1/M_AXI]
  connect_bd_intf_net -intf_net example_0_m_axi_a_V [get_bd_intf_pins axi_interconnect_1/S01_AXI] [get_bd_intf_pins example_0/m_axi_a_V]

  # Create port connections
  connect_bd_net -net M00_ARESETN_1 [get_bd_pins axi_interconnect_1/M00_ARESETN] [get_bd_pins util_vector_logic_1/Res]
  connect_bd_net -net M01_ARESETN_1 [get_bd_pins axi_interconnect_1/M01_ARESETN] [get_bd_pins util_vector_logic_2/Res]
  connect_bd_net -net M02_ARESETN_1 [get_bd_pins axi_interconnect_1/M02_ARESETN] [get_bd_pins axi_register_slice_0/aresetn] [get_bd_pins util_vector_logic_3/Res]
  connect_bd_net -net M03_ARESETN_1 [get_bd_pins axi_interconnect_1/M03_ARESETN] [get_bd_pins axi_register_slice_1/aresetn] [get_bd_pins util_vector_logic_4/Res]
  connect_bd_net -net axislave_cu_apctrl_0_A_array_baseaddr [get_bd_pins axislave_cu_apctrl_v1_0_0/A_array_baseaddr] [get_bd_pins example_0/a_addr]
  connect_bd_net -net axislave_cu_apctrl_0_A_array_baseaddr_vld [get_bd_pins axislave_cu_apctrl_v1_0_0/A_array_baseaddr_vld] [get_bd_pins example_0/a_addr_ap_vld]
  connect_bd_net -net axislave_cu_apctrl_0_B_array_baseaddr [get_bd_pins axislave_cu_apctrl_v1_0_0/B_array_baseaddr] [get_bd_pins example_0/b_addr]
  connect_bd_net -net axislave_cu_apctrl_0_B_array_baseaddr_vld [get_bd_pins axislave_cu_apctrl_v1_0_0/B_array_baseaddr_vld] [get_bd_pins example_0/b_addr_ap_vld]
  connect_bd_net -net axislave_cu_apctrl_0_C_array_baseaddr [get_bd_pins axislave_cu_apctrl_v1_0_0/C_array_baseaddr] [get_bd_pins example_0/c_addr]
  connect_bd_net -net axislave_cu_apctrl_0_C_array_baseaddr_vld [get_bd_pins axislave_cu_apctrl_v1_0_0/C_array_baseaddr_vld] [get_bd_pins example_0/c_addr_ap_vld]
  connect_bd_net -net axislave_cu_apctrl_0_ap_start [get_bd_pins axislave_cu_apctrl_v1_0_0/ap_start] [get_bd_pins example_0/ap_start]
  connect_bd_net -net axislave_cu_apctrl_0_array_len [get_bd_pins axislave_cu_apctrl_v1_0_0/array_len] [get_bd_pins example_0/n_V]
  connect_bd_net -net axislave_cu_apctrl_0_arrayu_len_vld [get_bd_pins axislave_cu_apctrl_v1_0_0/arrayu_len_vld] [get_bd_pins example_0/n_V_ap_vld]
  connect_bd_net -net axislave_cu_apctrl_v1_0_0_o_interrpt_rdy [get_bd_ports usr_irq_req] [get_bd_pins axislave_cu_apctrl_v1_0_0/o_interrpt_rdy]
  connect_bd_net -net c0_ddr4_ui_clk_sync_rst_1 [get_bd_ports c0_ddr4_ui_clk_sync_rst] [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net c1_ddr4_ui_clk1_1 [get_bd_ports c0_ddr4_ui_clk] [get_bd_pins axi_interconnect_1/M00_ACLK]
  connect_bd_net -net c1_ddr4_ui_clk_1 [get_bd_ports c1_ddr4_ui_clk] [get_bd_pins axi_interconnect_1/M01_ACLK]
  connect_bd_net -net c1_ddr4_ui_clk_sync_rst_1 [get_bd_ports c1_ddr4_ui_clk_sync_rst] [get_bd_pins util_vector_logic_2/Op1]
  connect_bd_net -net c2_ddr4_ui_clk_sync_rst_1 [get_bd_ports c2_ddr4_ui_clk_sync_rst] [get_bd_pins util_vector_logic_3/Op1]
  connect_bd_net -net c3_ddr4_ui_clk1_1 [get_bd_ports c2_ddr4_ui_clk] [get_bd_pins axi_interconnect_1/M02_ACLK] [get_bd_pins axi_register_slice_0/aclk]
  connect_bd_net -net c3_ddr4_ui_clk_1 [get_bd_ports c3_ddr4_ui_clk] [get_bd_pins axi_interconnect_1/M03_ACLK] [get_bd_pins axi_register_slice_1/aclk]
  connect_bd_net -net c3_ddr4_ui_clk_sync_rst_1 [get_bd_ports c3_ddr4_ui_clk_sync_rst] [get_bd_pins util_vector_logic_4/Op1]
  connect_bd_net -net example_0_ap_done [get_bd_pins axislave_cu_apctrl_v1_0_0/ap_done] [get_bd_pins example_0/ap_done]
  connect_bd_net -net example_0_ap_idle [get_bd_pins axislave_cu_apctrl_v1_0_0/ap_idle] [get_bd_pins example_0/ap_idle]
  connect_bd_net -net example_0_ap_ready [get_bd_pins axislave_cu_apctrl_v1_0_0/ap_ready] [get_bd_pins example_0/ap_ready]
  connect_bd_net -net i_soft_rst_n_1 [get_bd_ports i_soft_rst_n] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net s_axi_aclk_1 [get_bd_ports s_axi_aclk] [get_bd_pins axi_interconnect_1/ACLK] [get_bd_pins axi_interconnect_1/S00_ACLK] [get_bd_pins axi_interconnect_1/S01_ACLK] [get_bd_pins axislave_cu_apctrl_v1_0_0/s00_axi_aclk] [get_bd_pins example_0/ap_clk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_ports s_axi_aresetn] [get_bd_pins axi_interconnect_1/ARESETN] [get_bd_pins axi_interconnect_1/S00_ARESETN] [get_bd_pins axi_interconnect_1/S01_ARESETN] [get_bd_pins axislave_cu_apctrl_v1_0_0/s00_axi_aresetn] [get_bd_pins util_vector_logic_0/Op2]
  connect_bd_net -net usr_irq_ack_1 [get_bd_ports usr_irq_ack] [get_bd_pins axislave_cu_apctrl_v1_0_0/i_interrpt_done]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins example_0/ap_rst_n] [get_bd_pins util_vector_logic_0/Res]

  # Create address segments
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces example_0/Data_m_axi_a_V] [get_bd_addr_segs C0_DDR4_M_AXI/Reg] SEG_C0_DDR4_M_AXI_Reg
  create_bd_addr_seg -range 0x80000000 -offset 0x80000000 [get_bd_addr_spaces example_0/Data_m_axi_a_V] [get_bd_addr_segs C1_DDR4_M_AXI/Reg] SEG_C1_DDR4_M_AXI_Reg
  create_bd_addr_seg -range 0x80000000 -offset 0x000100000000 [get_bd_addr_spaces example_0/Data_m_axi_a_V] [get_bd_addr_segs C2_DDR4_M_AXI/Reg] SEG_C2_DDR4_M_AXI_Reg
  create_bd_addr_seg -range 0x80000000 -offset 0x000180000000 [get_bd_addr_spaces example_0/Data_m_axi_a_V] [get_bd_addr_segs C3_DDR4_M_AXI/Reg] SEG_C3_DDR4_M_AXI_Reg
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces S_AXI] [get_bd_addr_segs C0_DDR4_M_AXI/Reg] SEG_C0_DDR4_M_AXI_Reg
  create_bd_addr_seg -range 0x80000000 -offset 0x80000000 [get_bd_addr_spaces S_AXI] [get_bd_addr_segs C1_DDR4_M_AXI/Reg] SEG_C1_DDR4_M_AXI_Reg
  create_bd_addr_seg -range 0x80000000 -offset 0x000100000000 [get_bd_addr_spaces S_AXI] [get_bd_addr_segs C2_DDR4_M_AXI/Reg] SEG_C2_DDR4_M_AXI_Reg
  create_bd_addr_seg -range 0x80000000 -offset 0x000180000000 [get_bd_addr_spaces S_AXI] [get_bd_addr_segs C3_DDR4_M_AXI/Reg] SEG_C3_DDR4_M_AXI_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x00000000 [get_bd_addr_spaces S_AXI_LITE] [get_bd_addr_segs axislave_cu_apctrl_v1_0_0/s00_axi/reg0] SEG_axislave_cu_apctrl_v1_0_0_reg0

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.6.5b  2016-09-06 bk=1.3687 VDI=39 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port s_axi_aclk -pg 1 -y 610 -defaultsOSRD
preplace port c2_ddr4_ui_clk -pg 1 -y 830 -defaultsOSRD
preplace port S_AXI_LITE -pg 1 -y 100 -defaultsOSRD
preplace port C2_DDR4_M_AXI -pg 1 -y 780 -defaultsOSRD
preplace port c1_ddr4_ui_clk_sync_rst -pg 1 -y 780 -defaultsOSRD
preplace port C1_DDR4_M_AXI -pg 1 -y 710 -defaultsOSRD
preplace port c3_ddr4_ui_clk -pg 1 -y 930 -defaultsOSRD
preplace port c1_ddr4_ui_clk -pg 1 -y 730 -defaultsOSRD
preplace port c0_ddr4_ui_clk -pg 1 -y 630 -defaultsOSRD
preplace port c2_ddr4_ui_clk_sync_rst -pg 1 -y 880 -defaultsOSRD
preplace port S_AXI -pg 1 -y 570 -defaultsOSRD
preplace port c3_ddr4_ui_clk_sync_rst -pg 1 -y 980 -defaultsOSRD
preplace port C0_DDR4_M_AXI -pg 1 -y 690 -defaultsOSRD
preplace port s_axi_aresetn -pg 1 -y 590 -defaultsOSRD
preplace port C3_DDR4_M_AXI -pg 1 -y 900 -defaultsOSRD
preplace port i_soft_rst_n -pg 1 -y 390 -defaultsOSRD
preplace port usr_clk -pg 1 -y 470 -defaultsOSRD
preplace port c0_ddr4_ui_clk_sync_rst -pg 1 -y 680 -defaultsOSRD
preplace portBus usr_irq_req -pg 1 -y 10 -defaultsOSRD
preplace portBus usr_irq_ack -pg 1 -y 530 -defaultsOSRD
preplace inst util_vector_logic_0 -pg 1 -lvl 1 -y 400 -defaultsOSRD
preplace inst axi_register_slice_0 -pg 1 -lvl 4 -y 780 -defaultsOSRD
preplace inst util_vector_logic_1 -pg 1 -lvl 2 -y 680 -defaultsOSRD
preplace inst example_0 -pg 1 -lvl 2 -y 200 -defaultsOSRD
preplace inst axi_register_slice_1 -pg 1 -lvl 4 -y 900 -defaultsOSRD
preplace inst util_vector_logic_2 -pg 1 -lvl 2 -y 780 -defaultsOSRD
preplace inst util_vector_logic_3 -pg 1 -lvl 2 -y 880 -defaultsOSRD
preplace inst util_vector_logic_4 -pg 1 -lvl 2 -y 980 -defaultsOSRD
preplace inst axi_interconnect_1 -pg 1 -lvl 3 -y 720 -defaultsOSRD
preplace inst axislave_cu_apctrl_v1_0_0 -pg 1 -lvl 1 -y 160 -defaultsOSRD
preplace netloc S_AXI_LITE_1 1 0 1 NJ
preplace netloc i_soft_rst_n_1 1 0 1 NJ
preplace netloc axislave_cu_apctrl_0_arrayu_len_vld 1 1 1 450
preplace netloc M03_ARESETN_1 1 2 2 860 980 1200J
preplace netloc axi_register_slice_0_M_AXI 1 4 1 NJ
preplace netloc s_axi_aclk_1 1 0 3 20 610 470 610 870
preplace netloc axi_interconnect_1_M01_AXI 1 3 2 NJ 710 NJ
preplace netloc s_axi_aresetn_1 1 0 3 30 590 NJ 590 860
preplace netloc c3_ddr4_ui_clk1_1 1 0 4 NJ 830 NJ 830 840 940 1170J
preplace netloc c1_ddr4_ui_clk_1 1 0 3 NJ 730 NJ 730 NJ
preplace netloc axislave_cu_apctrl_v1_0_0_o_interrpt_rdy 1 1 4 480J 10 NJ 10 N 10 NJ
preplace netloc usr_irq_ack_1 1 0 1 10
preplace netloc example_0_ap_done 1 0 2 40 0 490
preplace netloc axislave_cu_apctrl_0_ap_start 1 1 1 N
preplace netloc util_vector_logic_0_Res 1 1 1 490
preplace netloc example_0_m_axi_a_V 1 2 1 870
preplace netloc axislave_cu_apctrl_0_A_array_baseaddr 1 1 1 460
preplace netloc axi_interconnect_1_M02_AXI 1 3 1 1200
preplace netloc c3_ddr4_ui_clk_1 1 0 4 NJ 930 NJ 930 850 950 1190J
preplace netloc c1_ddr4_ui_clk_sync_rst_1 1 0 2 NJ 780 NJ
preplace netloc M02_ARESETN_1 1 2 2 870 930 1180J
preplace netloc S00_AXI_1 1 0 3 NJ 570 NJ 570 NJ
preplace netloc example_0_ap_idle 1 0 2 50 10 470J
preplace netloc example_0_ap_ready 1 0 2 50 310 440
preplace netloc c3_ddr4_ui_clk_sync_rst_1 1 0 2 NJ 980 NJ
preplace netloc c1_ddr4_ui_clk1_1 1 0 3 NJ 630 NJ 630 850J
preplace netloc axislave_cu_apctrl_0_array_len 1 1 1 420
preplace netloc axislave_cu_apctrl_0_C_array_baseaddr_vld 1 1 1 N
preplace netloc axislave_cu_apctrl_0_B_array_baseaddr 1 1 1 430
preplace netloc axi_interconnect_1_M03_AXI 1 3 1 1190
preplace netloc M00_ARESETN_1 1 2 1 840J
preplace netloc axi_register_slice_1_M_AXI 1 4 1 NJ
preplace netloc axi_interconnect_1_M00_AXI 1 3 2 NJ 690 NJ
preplace netloc c2_ddr4_ui_clk_sync_rst_1 1 0 2 NJ 880 NJ
preplace netloc axislave_cu_apctrl_0_C_array_baseaddr 1 1 1 410
preplace netloc axislave_cu_apctrl_0_B_array_baseaddr_vld 1 1 1 N
preplace netloc axislave_cu_apctrl_0_A_array_baseaddr_vld 1 1 1 N
preplace netloc c0_ddr4_ui_clk_sync_rst_1 1 0 2 NJ 680 NJ
preplace netloc M01_ARESETN_1 1 2 1 850J
levelinfo -pg 1 -10 240 690 1030 1360 1490 -top -10 -bot 1020
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


