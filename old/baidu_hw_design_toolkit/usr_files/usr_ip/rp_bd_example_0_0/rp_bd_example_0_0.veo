// (c) Copyright 1995-2017 Xilinx, Inc. All rights reserved.
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
// 
// DO NOT MODIFY THIS FILE.

// IP VLNV: xilinx.com:hls:example:1.0
// IP Revision: 1703211715

// The following must be inserted into your Verilog file for this
// core to be instantiated. Change the instance name and port connections
// (in parentheses) to your own signal names.

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
rp_bd_example_0_0 your_instance_name (
  .n_V_ap_vld(n_V_ap_vld),                  // input wire n_V_ap_vld
  .a_addr_ap_vld(a_addr_ap_vld),            // input wire a_addr_ap_vld
  .b_addr_ap_vld(b_addr_ap_vld),            // input wire b_addr_ap_vld
  .c_addr_ap_vld(c_addr_ap_vld),            // input wire c_addr_ap_vld
  .ap_clk(ap_clk),                          // input wire ap_clk
  .ap_rst_n(ap_rst_n),                      // input wire ap_rst_n
  .ap_start(ap_start),                      // input wire ap_start
  .ap_done(ap_done),                        // output wire ap_done
  .ap_idle(ap_idle),                        // output wire ap_idle
  .ap_ready(ap_ready),                      // output wire ap_ready
  .m_axi_a_V_AWADDR(m_axi_a_V_AWADDR),      // output wire [31 : 0] m_axi_a_V_AWADDR
  .m_axi_a_V_AWLEN(m_axi_a_V_AWLEN),        // output wire [7 : 0] m_axi_a_V_AWLEN
  .m_axi_a_V_AWSIZE(m_axi_a_V_AWSIZE),      // output wire [2 : 0] m_axi_a_V_AWSIZE
  .m_axi_a_V_AWBURST(m_axi_a_V_AWBURST),    // output wire [1 : 0] m_axi_a_V_AWBURST
  .m_axi_a_V_AWLOCK(m_axi_a_V_AWLOCK),      // output wire [1 : 0] m_axi_a_V_AWLOCK
  .m_axi_a_V_AWREGION(m_axi_a_V_AWREGION),  // output wire [3 : 0] m_axi_a_V_AWREGION
  .m_axi_a_V_AWCACHE(m_axi_a_V_AWCACHE),    // output wire [3 : 0] m_axi_a_V_AWCACHE
  .m_axi_a_V_AWPROT(m_axi_a_V_AWPROT),      // output wire [2 : 0] m_axi_a_V_AWPROT
  .m_axi_a_V_AWQOS(m_axi_a_V_AWQOS),        // output wire [3 : 0] m_axi_a_V_AWQOS
  .m_axi_a_V_AWVALID(m_axi_a_V_AWVALID),    // output wire m_axi_a_V_AWVALID
  .m_axi_a_V_AWREADY(m_axi_a_V_AWREADY),    // input wire m_axi_a_V_AWREADY
  .m_axi_a_V_WDATA(m_axi_a_V_WDATA),        // output wire [255 : 0] m_axi_a_V_WDATA
  .m_axi_a_V_WSTRB(m_axi_a_V_WSTRB),        // output wire [31 : 0] m_axi_a_V_WSTRB
  .m_axi_a_V_WLAST(m_axi_a_V_WLAST),        // output wire m_axi_a_V_WLAST
  .m_axi_a_V_WVALID(m_axi_a_V_WVALID),      // output wire m_axi_a_V_WVALID
  .m_axi_a_V_WREADY(m_axi_a_V_WREADY),      // input wire m_axi_a_V_WREADY
  .m_axi_a_V_BRESP(m_axi_a_V_BRESP),        // input wire [1 : 0] m_axi_a_V_BRESP
  .m_axi_a_V_BVALID(m_axi_a_V_BVALID),      // input wire m_axi_a_V_BVALID
  .m_axi_a_V_BREADY(m_axi_a_V_BREADY),      // output wire m_axi_a_V_BREADY
  .m_axi_a_V_ARADDR(m_axi_a_V_ARADDR),      // output wire [31 : 0] m_axi_a_V_ARADDR
  .m_axi_a_V_ARLEN(m_axi_a_V_ARLEN),        // output wire [7 : 0] m_axi_a_V_ARLEN
  .m_axi_a_V_ARSIZE(m_axi_a_V_ARSIZE),      // output wire [2 : 0] m_axi_a_V_ARSIZE
  .m_axi_a_V_ARBURST(m_axi_a_V_ARBURST),    // output wire [1 : 0] m_axi_a_V_ARBURST
  .m_axi_a_V_ARLOCK(m_axi_a_V_ARLOCK),      // output wire [1 : 0] m_axi_a_V_ARLOCK
  .m_axi_a_V_ARREGION(m_axi_a_V_ARREGION),  // output wire [3 : 0] m_axi_a_V_ARREGION
  .m_axi_a_V_ARCACHE(m_axi_a_V_ARCACHE),    // output wire [3 : 0] m_axi_a_V_ARCACHE
  .m_axi_a_V_ARPROT(m_axi_a_V_ARPROT),      // output wire [2 : 0] m_axi_a_V_ARPROT
  .m_axi_a_V_ARQOS(m_axi_a_V_ARQOS),        // output wire [3 : 0] m_axi_a_V_ARQOS
  .m_axi_a_V_ARVALID(m_axi_a_V_ARVALID),    // output wire m_axi_a_V_ARVALID
  .m_axi_a_V_ARREADY(m_axi_a_V_ARREADY),    // input wire m_axi_a_V_ARREADY
  .m_axi_a_V_RDATA(m_axi_a_V_RDATA),        // input wire [255 : 0] m_axi_a_V_RDATA
  .m_axi_a_V_RRESP(m_axi_a_V_RRESP),        // input wire [1 : 0] m_axi_a_V_RRESP
  .m_axi_a_V_RLAST(m_axi_a_V_RLAST),        // input wire m_axi_a_V_RLAST
  .m_axi_a_V_RVALID(m_axi_a_V_RVALID),      // input wire m_axi_a_V_RVALID
  .m_axi_a_V_RREADY(m_axi_a_V_RREADY),      // output wire m_axi_a_V_RREADY
  .n_V(n_V),                                // input wire [15 : 0] n_V
  .a_addr(a_addr),                          // input wire [31 : 0] a_addr
  .b_addr(b_addr),                          // input wire [31 : 0] b_addr
  .c_addr(c_addr)                          // input wire [31 : 0] c_addr
);
// INST_TAG_END ------ End INSTANTIATION Template ---------

// You must compile the wrapper file rp_bd_example_0_0.v when simulating
// the core, rp_bd_example_0_0. When compiling the wrapper file, be sure to
// reference the Verilog simulation library.

