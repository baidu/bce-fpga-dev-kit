//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.4 (lin64) Build 1733598 Wed Dec 14 22:35:42 MST 2016
//Date        : Thu May 11 16:27:06 2017
//Host        : BBhost_test1514 running 64-bit CentOS release 6.3 (Final)
//Command     : generate_target bd_f33b_wrapper.bd
//Design      : bd_f33b_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module bd_f33b_wrapper
   (bscanid,
    capture,
    clk,
    drck,
    reset,
    runtest,
    sel,
    shift,
    tck,
    tdi,
    tdo,
    tms,
    update);
  output [31:0]bscanid;
  input capture;
  input clk;
  input drck;
  input reset;
  input runtest;
  input sel;
  input shift;
  input tck;
  input tdi;
  output tdo;
  input tms;
  input update;

  wire [31:0]bscanid;
  wire capture;
  wire clk;
  wire drck;
  wire reset;
  wire runtest;
  wire sel;
  wire shift;
  wire tck;
  wire tdi;
  wire tdo;
  wire tms;
  wire update;

  bd_f33b bd_f33b_i
       (.bscanid(bscanid),
        .capture(capture),
        .clk(clk),
        .drck(drck),
        .reset(reset),
        .runtest(runtest),
        .sel(sel),
        .shift(shift),
        .tck(tck),
        .tdi(tdi),
        .tdo(tdo),
        .tms(tms),
        .update(update));
endmodule
