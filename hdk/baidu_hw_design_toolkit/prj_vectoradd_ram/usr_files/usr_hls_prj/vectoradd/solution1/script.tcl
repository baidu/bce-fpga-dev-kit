############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 1986-2016 Xilinx, Inc. All Rights Reserved.
############################################################
open_project vectoradd
set_top example
add_files src/example.cpp
add_files src/example.h
add_files -tb src/example_test.cpp
open_solution "solution1"
set_part {xcku115-flvf1924-2-e} -tool vivado
create_clock -period 4 -name default
config_interface -m_axi_addr64 -m_axi_offset off -register_io off
#source "./vectoradd/solution1/directives.tcl"
csim_design -compiler gcc
csynth_design
cosim_design
export_design -rtl verilog -format ip_catalog -display_name "vector_add"
