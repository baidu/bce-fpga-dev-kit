

/******************************************************************************
// (c) Copyright 2013 - 2014 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
******************************************************************************/
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor             : Xilinx
// \   \   \/     Version            : 1.0
//  \   \         Application        : DDR4
//  /   /         Filename           : ddr4_0.v
// /___/   /\     Date Last Modified : $Date: 2014/09/03 $
// \   \  /  \    Date Created       : Thu Apr 18 2013
//  \___\/\___\
//
// Device           : UltraScale
// Design Name      : DDR4_SDRAM
// Purpose          :
//   Wrapper module for the user design top level file. This module can be 
//   instantiated in the system and interconnect as shown in example design 
//   (example_top module).
// Reference        :
// Revision History :
//*****************************************************************************

`timescale 1ns/1ps
(* CORE_GENERATION_INFO = "DDR4_SDRAM, DDR4_SDRAM,{x_ipProduct=Vivado 2017.1.0,x_ipVendor=xilinx.com,x_ipLibrary=ip,x_ipName=DDR4_SDRAM,x_ipVersion=2.2, Controller_Type = DDR4_SDRAM, Time_Period = 833, Input_Clock_Period = 4998, Memory_Type = Components, Memory_Part = MT40A256M16GE-075E, Ecc = true, Cas_Latency = 17, Cas_Write_Latency = 12, DQ_Width = 72, Chip_Select = true, Data_Mask = NO_DM_NO_DBI, MEM_ADDR_ORDER = ROW_COLUMN_BANK,  Is_AXI_Enabled = false , Slot_cofiguration =  Single , Clamshell_cofiguration =  false ,IS_FASTER_SPEED_RAM = No, Is_custom_part = false, Memory_Voltage = 1.2V, Phy_Only = Complete_Memory_Controller, Debug_Port = Disable, Burst_Length = 8, System_Clock = Differential, AXI_Selection = false, AXI_Data_Width = 64,  AXI_ArbitrationScheme = RD_PRI_REG, AXI_Narrow_Burst = false, Simulation_Mode = BFM, Debug_Mode = Disable, Example_TG = SIMPLE_TG, Self_Refresh = false, Save_Restore = false, MicroBlaze_ECC = false,  Specify_MandD = false, CLKBOUT_MULT = 6, DIVCLK_DIVIDE = 1, CLKOUT0_DIVIDE = 4}" *) 
(* X_CORE_INFO = "ddr4_v2_2_0,Vivado 2017.1" *)
module ddr4_0
   (
   input  sys_rst,

   input                 c0_sys_clk_p,
   input                 c0_sys_clk_n,


   output                c0_ddr4_act_n,
   output [16:0]          c0_ddr4_adr,
   output [1:0]          c0_ddr4_ba,
   output [0:0]          c0_ddr4_bg,
   output [0:0]          c0_ddr4_cke,
   output [0:0]          c0_ddr4_odt,
   output [0:0]          c0_ddr4_cs_n,
   output [0:0]               c0_ddr4_ck_t,
   output [0:0]               c0_ddr4_ck_c,
   output                c0_ddr4_reset_n,
   inout  [8:0]          c0_ddr4_dm_dbi_n,
   inout  [71:0]          c0_ddr4_dq,
   inout  [8:0]         c0_ddr4_dqs_c,
   inout  [8:0]         c0_ddr4_dqs_t,

   output                c0_init_calib_complete,
   input                               c0_ddr4_app_correct_en_i,
   output [51:0]  c0_ddr4_ecc_err_addr,
   output [7:0]    c0_ddr4_ecc_single,
   output [7:0]    c0_ddr4_ecc_multiple,
   
   output                c0_ddr4_ui_clk,
   output                c0_ddr4_ui_clk_sync_rst,
   output               dbg_clk,

   // user interface ports
   input  [27:0]          c0_ddr4_app_addr,
   input  [2:0]          c0_ddr4_app_cmd,
   input                 c0_ddr4_app_en,
   input                 c0_ddr4_app_hi_pri,
   input  [511:0]          c0_ddr4_app_wdf_data,
   input                 c0_ddr4_app_wdf_end,
   input  [63:0]          c0_ddr4_app_wdf_mask,
   input                 c0_ddr4_app_wdf_wren,

   output [511:0]          c0_ddr4_app_rd_data,
   output                c0_ddr4_app_rd_data_end,
   output                c0_ddr4_app_rd_data_valid,
   output                c0_ddr4_app_rdy,
   output                c0_ddr4_app_wdf_rdy,
   // Debug Port
   output wire [511:0]             dbg_bus
   );


ddr4_0_ddr4
   inst (
   .sys_rst           (sys_rst),

   .c0_sys_clk_p                   (c0_sys_clk_p),
   .c0_sys_clk_n                   (c0_sys_clk_n),

   .c0_init_calib_complete (c0_init_calib_complete),
   .c0_ddr4_act_n          (c0_ddr4_act_n),
   .c0_ddr4_adr            (c0_ddr4_adr),
   .c0_ddr4_ba             (c0_ddr4_ba),
   .c0_ddr4_bg             (c0_ddr4_bg),
   .c0_ddr4_cke            (c0_ddr4_cke),
   .c0_ddr4_odt            (c0_ddr4_odt),
   .c0_ddr4_cs_n           (c0_ddr4_cs_n),
   .c0_ddr4_ck_t           (c0_ddr4_ck_t),
   .c0_ddr4_ck_c           (c0_ddr4_ck_c),
   .c0_ddr4_reset_n        (c0_ddr4_reset_n),
   .c0_ddr4_dm_dbi_n       (c0_ddr4_dm_dbi_n),
   .c0_ddr4_dq             (c0_ddr4_dq),
   .c0_ddr4_dqs_c          (c0_ddr4_dqs_c),
   .c0_ddr4_dqs_t          (c0_ddr4_dqs_t),
   .c0_ddr4_ecc_err_addr   (c0_ddr4_ecc_err_addr),
   .c0_ddr4_ecc_single     (c0_ddr4_ecc_single),
   .c0_ddr4_ecc_multiple   (c0_ddr4_ecc_multiple),
   .c0_ddr4_app_correct_en_i      (c0_ddr4_app_correct_en_i),
   .c0_ddr4_ui_clk                (c0_ddr4_ui_clk),
   .c0_ddr4_ui_clk_sync_rst       (c0_ddr4_ui_clk_sync_rst),
   .addn_ui_clkout1                            (),
   .addn_ui_clkout2                            (),
   .addn_ui_clkout3                            (),
   .addn_ui_clkout4                            (),
   .dbg_clk                                    (dbg_clk),
   .sl_iport0                                  (37'b0),
   .sl_oport0                                  (),

   .c0_ddr4_app_addr              (c0_ddr4_app_addr),
   .c0_ddr4_app_cmd               (c0_ddr4_app_cmd),
   .c0_ddr4_app_en                (c0_ddr4_app_en),
   .c0_ddr4_app_hi_pri            (c0_ddr4_app_hi_pri),
   .c0_ddr4_app_wdf_data          (c0_ddr4_app_wdf_data),
   .c0_ddr4_app_wdf_end           (c0_ddr4_app_wdf_end),
   .c0_ddr4_app_wdf_mask          (c0_ddr4_app_wdf_mask),
   .c0_ddr4_app_wdf_wren          (c0_ddr4_app_wdf_wren),
   .c0_ddr4_app_rd_data           (c0_ddr4_app_rd_data),
   .c0_ddr4_app_rd_data_end       (c0_ddr4_app_rd_data_end),
   .c0_ddr4_app_rd_data_valid     (c0_ddr4_app_rd_data_valid),
   .c0_ddr4_app_rdy               (c0_ddr4_app_rdy),
   .c0_ddr4_app_wdf_rdy           (c0_ddr4_app_wdf_rdy),
   // Debug Port
   .dbg_bus               (dbg_bus) 
   );

 endmodule
