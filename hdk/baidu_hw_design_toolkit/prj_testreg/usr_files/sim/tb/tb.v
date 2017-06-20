//Confidential and proprietary information of Baidu, Inc
//////////////////////////////////////////////////////
//
//
//    Version:1.0
//    FileName: card_sim.v
//    Data last Modified:
//    Data Created:June. 7th, 2017
//
//
//
//    Device:xcku115-flvf1924-2-e
//    Purpose: simulate for card of FPGA cloud.
//
//
//    Reference:
//    Revision History:
//    Rev 1.0 - First created, ruanyuan,
//    email: ruanyuan@baidu.com
//////////////////////////////////////////////////////
`timescale 1ns / 1ps

module tb ();

   localparam TEST_REG1_ADDR = 16'd0;
   localparam TEST_REG2_ADDR = 16'd4;
   localparam TEST_REG3_ADDR = 16'd8;
   localparam TEST_REG4_ADDR = 16'd12;
   localparam MAX_VALUE      = 32'h80000000;

   card_sim card_sim();

   reg  [31:0]  reg1_data_r;
   reg  [31:0]  reg2_data_r;
   reg  [31:0]  reg3_data_r;
   reg  [31:0]  reg3_expect_data_r;

   initial begin
      #1000;
      reg1_data_r = {$random} % MAX_VALUE;
      reg2_data_r = {$random} % MAX_VALUE;
      reg3_expect_data_r = reg1_data_r + reg2_data_r;
      card_sim.sp_sim.axi_l_wr(TEST_REG1_ADDR,reg1_data_r,4'hf);
      card_sim.sp_sim.axi_l_wr(TEST_REG2_ADDR,reg2_data_r,4'hf);
      #100;
      card_sim.sp_sim.axi_l_rd(TEST_REG3_ADDR,reg3_data_r);
      if (reg3_expect_data_r != reg3_data_r) begin
         $display ("%g Test fail", $time);
      end
      else begin
         $display ("%g Test pass", $time);
      end
      $finish;
   end

endmodule
