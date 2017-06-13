//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.4 (lin64) Build 1733598 Wed Dec 14 22:35:42 MST 2016
//Date        : Thu May 11 16:27:08 2017
//Host        : BBhost_test1514 running 64-bit CentOS release 6.3 (Final)
//Command     : generate_target bd_9d42_wrapper.bd
//Design      : bd_9d42_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module bd_9d42_wrapper
   (clk,
    probe0,
    probe1,
    probe10,
    probe11,
    probe12,
    probe2,
    probe3,
    probe4,
    probe5,
    probe6,
    probe7,
    probe8,
    probe9);
  input clk;
  input [0:0]probe0;
  input [0:0]probe1;
  input [0:0]probe10;
  input [15:0]probe11;
  input [15:0]probe12;
  input [31:0]probe2;
  input [31:0]probe3;
  input [31:0]probe4;
  input [15:0]probe5;
  input [0:0]probe6;
  input [0:0]probe7;
  input [0:0]probe8;
  input [0:0]probe9;

  wire clk;
  wire [0:0]probe0;
  wire [0:0]probe1;
  wire [0:0]probe10;
  wire [15:0]probe11;
  wire [15:0]probe12;
  wire [31:0]probe2;
  wire [31:0]probe3;
  wire [31:0]probe4;
  wire [15:0]probe5;
  wire [0:0]probe6;
  wire [0:0]probe7;
  wire [0:0]probe8;
  wire [0:0]probe9;

  bd_9d42 bd_9d42_i
       (.clk(clk),
        .probe0(probe0),
        .probe1(probe1),
        .probe10(probe10),
        .probe11(probe11),
        .probe12(probe12),
        .probe2(probe2),
        .probe3(probe3),
        .probe4(probe4),
        .probe5(probe5),
        .probe6(probe6),
        .probe7(probe7),
        .probe8(probe8),
        .probe9(probe9));
endmodule
