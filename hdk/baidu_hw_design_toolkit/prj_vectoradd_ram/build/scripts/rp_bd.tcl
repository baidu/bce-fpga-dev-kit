
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
  set i_soft_rst_n [ create_bd_port -dir I -type rst i_soft_rst_n ]
  set s_axi_aclk [ create_bd_port -dir I -type clk s_axi_aclk ]
  set_property -dict [ list \
CONFIG.ASSOCIATED_BUSIF {S_AXI:S_AXI_LITE} \
CONFIG.CLK_DOMAIN {rp_bd_axi_pcie3_0_0_axi_aclk} \
CONFIG.FREQ_HZ {250000000} \
 ] $s_axi_aclk
  set s_axi_aresetn [ create_bd_port -dir I -type rst s_axi_aresetn ]
  set usr_clk [ create_bd_port -dir I -type clk usr_clk ]
  set_property -dict [ list \
CONFIG.FREQ_HZ {100000000} \
 ] $usr_clk
  set usr_irq_ack [ create_bd_port -dir I -from 15 -to 0 -type data usr_irq_ack ]
  set usr_irq_req [ create_bd_port -dir O -from 15 -to 0 usr_irq_req ]

  # Create instance: axi_bram_ctrl_0, and set properties
  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl axi_bram_ctrl_0 ]
  set_property -dict [ list \
CONFIG.DATA_WIDTH {256} \
CONFIG.ECC_TYPE {0} \
 ] $axi_bram_ctrl_0

  # Create instance: axi_bram_ctrl_0_bram, and set properties
  set axi_bram_ctrl_0_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen axi_bram_ctrl_0_bram ]
  set_property -dict [ list \
CONFIG.Byte_Size {8} \
CONFIG.Enable_32bit_Address {true} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Read_Width_A {256} \
CONFIG.Read_Width_B {256} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
CONFIG.Register_PortB_Output_of_Memory_Primitives {false} \
CONFIG.Use_Byte_Write_Enable {true} \
CONFIG.Use_RSTA_Pin {true} \
CONFIG.Use_RSTB_Pin {true} \
CONFIG.Write_Width_A {256} \
CONFIG.Write_Width_B {256} \
CONFIG.use_bram_block {BRAM_Controller} \
 ] $axi_bram_ctrl_0_bram

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
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {2} \
CONFIG.S00_HAS_REGSLICE {4} \
CONFIG.S01_HAS_REGSLICE {4} \
 ] $axi_interconnect_1

  # Create instance: axislave_cu_apctrl_v1_0_0, and set properties
  set axislave_cu_apctrl_v1_0_0 [ create_bd_cell -type ip -vlnv baidu.com:user:axislave_cu_apctrl_v1_0 axislave_cu_apctrl_v1_0_0 ]

  set_property -dict [ list \
CONFIG.NUM_READ_OUTSTANDING {1} \
CONFIG.NUM_WRITE_OUTSTANDING {1} \
 ] [get_bd_intf_pins /axislave_cu_apctrl_v1_0_0/s00_axi]

  # Create instance: example_0, and set properties
  set example_0 [ create_bd_cell -type ip -vlnv xilinx.com:hls:example example_0 ]

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic util_vector_logic_0 ]
  set_property -dict [ list \
CONFIG.C_SIZE {1} \
 ] $util_vector_logic_0

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_ports S_AXI] [get_bd_intf_pins axi_interconnect_1/S00_AXI]
  connect_bd_intf_net -intf_net S_AXI_LITE_1 [get_bd_intf_ports S_AXI_LITE] [get_bd_intf_pins axislave_cu_apctrl_v1_0_0/s00_axi]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins axi_bram_ctrl_0_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTB [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTB] [get_bd_intf_pins axi_bram_ctrl_0_bram/BRAM_PORTB]
  connect_bd_intf_net -intf_net axi_interconnect_1_M00_AXI [get_bd_intf_pins axi_bram_ctrl_0/S_AXI] [get_bd_intf_pins axi_interconnect_1/M00_AXI]
  connect_bd_intf_net -intf_net example_0_m_axi_a_V [get_bd_intf_pins axi_interconnect_1/S01_AXI] [get_bd_intf_pins example_0/m_axi_a_V]

  # Create port connections
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
  connect_bd_net -net example_0_ap_done [get_bd_pins axislave_cu_apctrl_v1_0_0/ap_done] [get_bd_pins example_0/ap_done]
  connect_bd_net -net example_0_ap_idle [get_bd_pins axislave_cu_apctrl_v1_0_0/ap_idle] [get_bd_pins example_0/ap_idle]
  connect_bd_net -net example_0_ap_ready [get_bd_pins axislave_cu_apctrl_v1_0_0/ap_ready] [get_bd_pins example_0/ap_ready]
  connect_bd_net -net i_soft_rst_n_1 [get_bd_ports i_soft_rst_n] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net s_axi_aclk_1 [get_bd_ports s_axi_aclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins axi_interconnect_1/ACLK] [get_bd_pins axi_interconnect_1/M00_ACLK] [get_bd_pins axi_interconnect_1/S00_ACLK] [get_bd_pins axi_interconnect_1/S01_ACLK] [get_bd_pins axislave_cu_apctrl_v1_0_0/s00_axi_aclk] [get_bd_pins example_0/ap_clk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_ports s_axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] [get_bd_pins axi_interconnect_1/ARESETN] [get_bd_pins axi_interconnect_1/M00_ARESETN] [get_bd_pins axi_interconnect_1/S00_ARESETN] [get_bd_pins axi_interconnect_1/S01_ARESETN] [get_bd_pins axislave_cu_apctrl_v1_0_0/s00_axi_aresetn] [get_bd_pins util_vector_logic_0/Op2]
  connect_bd_net -net usr_irq_ack_1 [get_bd_ports usr_irq_ack] [get_bd_pins axislave_cu_apctrl_v1_0_0/i_interrpt_done]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins example_0/ap_rst_n] [get_bd_pins util_vector_logic_0/Res]

  # Create address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x00000000 [get_bd_addr_spaces example_0/Data_m_axi_a_V] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] SEG_axi_bram_ctrl_0_Mem0
  create_bd_addr_seg -range 0x00010000 -offset 0x00000000 [get_bd_addr_spaces S_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] SEG_axi_bram_ctrl_0_Mem0
  create_bd_addr_seg -range 0x00010000 -offset 0x00000000 [get_bd_addr_spaces S_AXI_LITE] [get_bd_addr_segs axislave_cu_apctrl_v1_0_0/s00_axi/reg0] SEG_axislave_cu_apctrl_v1_0_0_reg0

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.6.5b  2016-09-06 bk=1.3687 VDI=39 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port s_axi_aclk -pg 1 -y 730 -defaultsOSRD
preplace port S_AXI_LITE -pg 1 -y 340 -defaultsOSRD
preplace port S_AXI -pg 1 -y 690 -defaultsOSRD
preplace port s_axi_aresetn -pg 1 -y 750 -defaultsOSRD
preplace port i_soft_rst_n -pg 1 -y 620 -defaultsOSRD
preplace port usr_clk -pg 1 -y 460 -defaultsOSRD
preplace portBus usr_irq_req -pg 1 -y 370 -defaultsOSRD
preplace portBus usr_irq_ack -pg 1 -y 360 -defaultsOSRD
preplace inst axi_bram_ctrl_0_bram -pg 1 -lvl 5 -y 800 -defaultsOSRD
preplace inst util_vector_logic_0 -pg 1 -lvl 1 -y 630 -defaultsOSRD
preplace inst example_0 -pg 1 -lvl 2 -y 180 -defaultsOSRD
preplace inst axi_interconnect_1 -pg 1 -lvl 3 -y 780 -defaultsOSRD
preplace inst axislave_cu_apctrl_v1_0_0 -pg 1 -lvl 1 -y 400 -defaultsOSRD
preplace inst axi_bram_ctrl_0 -pg 1 -lvl 4 -y 800 -defaultsOSRD
preplace netloc S_AXI_LITE_1 1 0 1 NJ
preplace netloc i_soft_rst_n_1 1 0 1 NJ
preplace netloc axislave_cu_apctrl_0_arrayu_len_vld 1 1 1 400
preplace netloc s_axi_aclk_1 1 0 4 0J 730 480 730 830 930 1130
preplace netloc s_axi_aresetn_1 1 0 4 10 750 NJ 750 820 940 1140
preplace netloc axislave_cu_apctrl_v1_0_0_o_interrpt_rdy 1 1 5 430J 370 NJ 370 NJ 370 NJ 370 N
preplace netloc axi_bram_ctrl_0_BRAM_PORTA 1 4 1 N
preplace netloc usr_irq_ack_1 1 0 1 NJ
preplace netloc example_0_ap_done 1 0 2 20 80 N
preplace netloc axislave_cu_apctrl_0_ap_start 1 1 1 380
preplace netloc axi_bram_ctrl_0_BRAM_PORTB 1 4 1 N
preplace netloc util_vector_logic_0_Res 1 1 1 490
preplace netloc example_0_m_axi_a_V 1 2 1 830
preplace netloc axislave_cu_apctrl_0_A_array_baseaddr 1 1 1 420
preplace netloc S00_AXI_1 1 0 3 NJ 690 NJ 690 NJ
preplace netloc example_0_ap_idle 1 0 2 30J 100 NJ
preplace netloc example_0_ap_ready 1 0 2 40 120 N
preplace netloc axislave_cu_apctrl_0_array_len 1 1 1 450
preplace netloc axislave_cu_apctrl_0_C_array_baseaddr_vld 1 1 1 440
preplace netloc axislave_cu_apctrl_0_B_array_baseaddr 1 1 1 460
preplace netloc axi_interconnect_1_M00_AXI 1 3 1 N
preplace netloc axislave_cu_apctrl_0_C_array_baseaddr 1 1 1 470
preplace netloc axislave_cu_apctrl_0_B_array_baseaddr_vld 1 1 1 410
preplace netloc axislave_cu_apctrl_0_A_array_baseaddr_vld 1 1 1 390
levelinfo -pg 1 -20 210 670 990 1270 1510 1630 -top -10 -bot 1560
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


