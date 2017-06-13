-- (c) Copyright 1995-2017 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: xilinx.com:hls:example:1.0
-- IP Revision: 1703211715

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY rp_bd_example_0_0 IS
  PORT (
    n_V_ap_vld : IN STD_LOGIC;
    a_addr_ap_vld : IN STD_LOGIC;
    b_addr_ap_vld : IN STD_LOGIC;
    c_addr_ap_vld : IN STD_LOGIC;
    ap_clk : IN STD_LOGIC;
    ap_rst_n : IN STD_LOGIC;
    ap_start : IN STD_LOGIC;
    ap_done : OUT STD_LOGIC;
    ap_idle : OUT STD_LOGIC;
    ap_ready : OUT STD_LOGIC;
    m_axi_a_V_AWADDR : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axi_a_V_AWLEN : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    m_axi_a_V_AWSIZE : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    m_axi_a_V_AWBURST : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_axi_a_V_AWLOCK : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_axi_a_V_AWREGION : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_axi_a_V_AWCACHE : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_axi_a_V_AWPROT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    m_axi_a_V_AWQOS : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_axi_a_V_AWVALID : OUT STD_LOGIC;
    m_axi_a_V_AWREADY : IN STD_LOGIC;
    m_axi_a_V_WDATA : OUT STD_LOGIC_VECTOR(255 DOWNTO 0);
    m_axi_a_V_WSTRB : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axi_a_V_WLAST : OUT STD_LOGIC;
    m_axi_a_V_WVALID : OUT STD_LOGIC;
    m_axi_a_V_WREADY : IN STD_LOGIC;
    m_axi_a_V_BRESP : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_axi_a_V_BVALID : IN STD_LOGIC;
    m_axi_a_V_BREADY : OUT STD_LOGIC;
    m_axi_a_V_ARADDR : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axi_a_V_ARLEN : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    m_axi_a_V_ARSIZE : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    m_axi_a_V_ARBURST : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_axi_a_V_ARLOCK : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_axi_a_V_ARREGION : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_axi_a_V_ARCACHE : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_axi_a_V_ARPROT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    m_axi_a_V_ARQOS : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_axi_a_V_ARVALID : OUT STD_LOGIC;
    m_axi_a_V_ARREADY : IN STD_LOGIC;
    m_axi_a_V_RDATA : IN STD_LOGIC_VECTOR(255 DOWNTO 0);
    m_axi_a_V_RRESP : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_axi_a_V_RLAST : IN STD_LOGIC;
    m_axi_a_V_RVALID : IN STD_LOGIC;
    m_axi_a_V_RREADY : OUT STD_LOGIC;
    n_V : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    a_addr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    b_addr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    c_addr : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END rp_bd_example_0_0;

ARCHITECTURE rp_bd_example_0_0_arch OF rp_bd_example_0_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF rp_bd_example_0_0_arch: ARCHITECTURE IS "yes";
  COMPONENT example IS
    GENERIC (
      C_M_AXI_A_V_ID_WIDTH : INTEGER;
      C_M_AXI_A_V_ADDR_WIDTH : INTEGER;
      C_M_AXI_A_V_DATA_WIDTH : INTEGER;
      C_M_AXI_A_V_AWUSER_WIDTH : INTEGER;
      C_M_AXI_A_V_ARUSER_WIDTH : INTEGER;
      C_M_AXI_A_V_WUSER_WIDTH : INTEGER;
      C_M_AXI_A_V_RUSER_WIDTH : INTEGER;
      C_M_AXI_A_V_BUSER_WIDTH : INTEGER;
      C_M_AXI_A_V_USER_VALUE : INTEGER;
      C_M_AXI_A_V_PROT_VALUE : INTEGER;
      C_M_AXI_A_V_CACHE_VALUE : INTEGER;
      C_M_AXI_A_V_TARGET_ADDR : INTEGER
    );
    PORT (
      n_V_ap_vld : IN STD_LOGIC;
      a_addr_ap_vld : IN STD_LOGIC;
      b_addr_ap_vld : IN STD_LOGIC;
      c_addr_ap_vld : IN STD_LOGIC;
      ap_clk : IN STD_LOGIC;
      ap_rst_n : IN STD_LOGIC;
      ap_start : IN STD_LOGIC;
      ap_done : OUT STD_LOGIC;
      ap_idle : OUT STD_LOGIC;
      ap_ready : OUT STD_LOGIC;
      m_axi_a_V_AWID : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_a_V_AWADDR : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      m_axi_a_V_AWLEN : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axi_a_V_AWSIZE : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_a_V_AWBURST : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_a_V_AWLOCK : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_a_V_AWREGION : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_a_V_AWCACHE : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_a_V_AWPROT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_a_V_AWQOS : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_a_V_AWUSER : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_a_V_AWVALID : OUT STD_LOGIC;
      m_axi_a_V_AWREADY : IN STD_LOGIC;
      m_axi_a_V_WID : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_a_V_WDATA : OUT STD_LOGIC_VECTOR(255 DOWNTO 0);
      m_axi_a_V_WSTRB : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      m_axi_a_V_WLAST : OUT STD_LOGIC;
      m_axi_a_V_WUSER : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_a_V_WVALID : OUT STD_LOGIC;
      m_axi_a_V_WREADY : IN STD_LOGIC;
      m_axi_a_V_BID : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_a_V_BRESP : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_a_V_BUSER : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_a_V_BVALID : IN STD_LOGIC;
      m_axi_a_V_BREADY : OUT STD_LOGIC;
      m_axi_a_V_ARID : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_a_V_ARADDR : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      m_axi_a_V_ARLEN : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axi_a_V_ARSIZE : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_a_V_ARBURST : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_a_V_ARLOCK : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_a_V_ARREGION : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_a_V_ARCACHE : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_a_V_ARPROT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_a_V_ARQOS : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_a_V_ARUSER : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_a_V_ARVALID : OUT STD_LOGIC;
      m_axi_a_V_ARREADY : IN STD_LOGIC;
      m_axi_a_V_RID : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_a_V_RDATA : IN STD_LOGIC_VECTOR(255 DOWNTO 0);
      m_axi_a_V_RRESP : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_a_V_RLAST : IN STD_LOGIC;
      m_axi_a_V_RUSER : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_a_V_RVALID : IN STD_LOGIC;
      m_axi_a_V_RREADY : OUT STD_LOGIC;
      n_V : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      a_addr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      b_addr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      c_addr : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
  END COMPONENT example;
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_INFO OF ap_clk: SIGNAL IS "xilinx.com:signal:clock:1.0 ap_clk CLK";
  ATTRIBUTE X_INTERFACE_INFO OF ap_rst_n: SIGNAL IS "xilinx.com:signal:reset:1.0 ap_rst_n RST";
  ATTRIBUTE X_INTERFACE_INFO OF ap_start: SIGNAL IS "xilinx.com:interface:acc_handshake:1.0 ap_ctrl start";
  ATTRIBUTE X_INTERFACE_INFO OF ap_done: SIGNAL IS "xilinx.com:interface:acc_handshake:1.0 ap_ctrl done";
  ATTRIBUTE X_INTERFACE_INFO OF ap_idle: SIGNAL IS "xilinx.com:interface:acc_handshake:1.0 ap_ctrl idle";
  ATTRIBUTE X_INTERFACE_INFO OF ap_ready: SIGNAL IS "xilinx.com:interface:acc_handshake:1.0 ap_ctrl ready";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_AWADDR: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V AWADDR";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_AWLEN: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V AWLEN";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_AWSIZE: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V AWSIZE";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_AWBURST: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V AWBURST";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_AWLOCK: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V AWLOCK";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_AWREGION: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V AWREGION";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_AWCACHE: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V AWCACHE";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_AWPROT: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V AWPROT";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_AWQOS: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V AWQOS";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_AWVALID: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V AWVALID";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_AWREADY: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V AWREADY";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_WDATA: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V WDATA";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_WSTRB: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V WSTRB";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_WLAST: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V WLAST";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_WVALID: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V WVALID";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_WREADY: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V WREADY";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_BRESP: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V BRESP";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_BVALID: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V BVALID";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_BREADY: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V BREADY";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_ARADDR: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V ARADDR";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_ARLEN: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V ARLEN";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_ARSIZE: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V ARSIZE";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_ARBURST: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V ARBURST";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_ARLOCK: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V ARLOCK";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_ARREGION: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V ARREGION";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_ARCACHE: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V ARCACHE";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_ARPROT: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V ARPROT";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_ARQOS: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V ARQOS";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_ARVALID: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V ARVALID";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_ARREADY: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V ARREADY";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_RDATA: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V RDATA";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_RRESP: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V RRESP";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_RLAST: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V RLAST";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_RVALID: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V RVALID";
  ATTRIBUTE X_INTERFACE_INFO OF m_axi_a_V_RREADY: SIGNAL IS "xilinx.com:interface:aximm:1.0 m_axi_a_V RREADY";
  ATTRIBUTE X_INTERFACE_INFO OF n_V: SIGNAL IS "xilinx.com:signal:data:1.0 n_V DATA";
  ATTRIBUTE X_INTERFACE_INFO OF a_addr: SIGNAL IS "xilinx.com:signal:data:1.0 a_addr DATA";
  ATTRIBUTE X_INTERFACE_INFO OF b_addr: SIGNAL IS "xilinx.com:signal:data:1.0 b_addr DATA";
  ATTRIBUTE X_INTERFACE_INFO OF c_addr: SIGNAL IS "xilinx.com:signal:data:1.0 c_addr DATA";
BEGIN
  U0 : example
    GENERIC MAP (
      C_M_AXI_A_V_ID_WIDTH => 1,
      C_M_AXI_A_V_ADDR_WIDTH => 32,
      C_M_AXI_A_V_DATA_WIDTH => 256,
      C_M_AXI_A_V_AWUSER_WIDTH => 1,
      C_M_AXI_A_V_ARUSER_WIDTH => 1,
      C_M_AXI_A_V_WUSER_WIDTH => 1,
      C_M_AXI_A_V_RUSER_WIDTH => 1,
      C_M_AXI_A_V_BUSER_WIDTH => 1,
      C_M_AXI_A_V_USER_VALUE => 0,
      C_M_AXI_A_V_PROT_VALUE => 0,
      C_M_AXI_A_V_CACHE_VALUE => 3,
      C_M_AXI_A_V_TARGET_ADDR => 0
    )
    PORT MAP (
      n_V_ap_vld => n_V_ap_vld,
      a_addr_ap_vld => a_addr_ap_vld,
      b_addr_ap_vld => b_addr_ap_vld,
      c_addr_ap_vld => c_addr_ap_vld,
      ap_clk => ap_clk,
      ap_rst_n => ap_rst_n,
      ap_start => ap_start,
      ap_done => ap_done,
      ap_idle => ap_idle,
      ap_ready => ap_ready,
      m_axi_a_V_AWADDR => m_axi_a_V_AWADDR,
      m_axi_a_V_AWLEN => m_axi_a_V_AWLEN,
      m_axi_a_V_AWSIZE => m_axi_a_V_AWSIZE,
      m_axi_a_V_AWBURST => m_axi_a_V_AWBURST,
      m_axi_a_V_AWLOCK => m_axi_a_V_AWLOCK,
      m_axi_a_V_AWREGION => m_axi_a_V_AWREGION,
      m_axi_a_V_AWCACHE => m_axi_a_V_AWCACHE,
      m_axi_a_V_AWPROT => m_axi_a_V_AWPROT,
      m_axi_a_V_AWQOS => m_axi_a_V_AWQOS,
      m_axi_a_V_AWVALID => m_axi_a_V_AWVALID,
      m_axi_a_V_AWREADY => m_axi_a_V_AWREADY,
      m_axi_a_V_WDATA => m_axi_a_V_WDATA,
      m_axi_a_V_WSTRB => m_axi_a_V_WSTRB,
      m_axi_a_V_WLAST => m_axi_a_V_WLAST,
      m_axi_a_V_WVALID => m_axi_a_V_WVALID,
      m_axi_a_V_WREADY => m_axi_a_V_WREADY,
      m_axi_a_V_BID => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      m_axi_a_V_BRESP => m_axi_a_V_BRESP,
      m_axi_a_V_BUSER => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      m_axi_a_V_BVALID => m_axi_a_V_BVALID,
      m_axi_a_V_BREADY => m_axi_a_V_BREADY,
      m_axi_a_V_ARADDR => m_axi_a_V_ARADDR,
      m_axi_a_V_ARLEN => m_axi_a_V_ARLEN,
      m_axi_a_V_ARSIZE => m_axi_a_V_ARSIZE,
      m_axi_a_V_ARBURST => m_axi_a_V_ARBURST,
      m_axi_a_V_ARLOCK => m_axi_a_V_ARLOCK,
      m_axi_a_V_ARREGION => m_axi_a_V_ARREGION,
      m_axi_a_V_ARCACHE => m_axi_a_V_ARCACHE,
      m_axi_a_V_ARPROT => m_axi_a_V_ARPROT,
      m_axi_a_V_ARQOS => m_axi_a_V_ARQOS,
      m_axi_a_V_ARVALID => m_axi_a_V_ARVALID,
      m_axi_a_V_ARREADY => m_axi_a_V_ARREADY,
      m_axi_a_V_RID => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      m_axi_a_V_RDATA => m_axi_a_V_RDATA,
      m_axi_a_V_RRESP => m_axi_a_V_RRESP,
      m_axi_a_V_RLAST => m_axi_a_V_RLAST,
      m_axi_a_V_RUSER => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      m_axi_a_V_RVALID => m_axi_a_V_RVALID,
      m_axi_a_V_RREADY => m_axi_a_V_RREADY,
      n_V => n_V,
      a_addr => a_addr,
      b_addr => b_addr,
      c_addr => c_addr
    );
END rp_bd_example_0_0_arch;
