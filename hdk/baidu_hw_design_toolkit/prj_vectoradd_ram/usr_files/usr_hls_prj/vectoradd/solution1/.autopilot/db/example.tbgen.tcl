set C_TypeInfoList {{ 
"example" : [[], { "return": [[], "void"]} , [{"ExternC" : 0}], [ {"a": [[],{ "pointer": "0"}] }, {"n": [[],"1"] }, {"a_addr": [[], {"scalar": "int"}] }, {"b_addr": [[], {"scalar": "int"}] }, {"c_addr": [[], {"scalar": "int"}] }],[],""], 
"0": [ "data_t", {"typedef": [[[],"2"],""]}], 
"2": [ "ap_int<256>", {"hls_type": {"ap_int": [[[[], {"scalar": { "int": 256}}]],""]}}], 
"1": [ "ap_uint<16>", {"hls_type": {"ap_uint": [[[[], {"scalar": { "int": 16}}]],""]}}]
}}
set moduleName example
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set C_modelName {example}
set C_modelType { void 0 }
set C_modelArgList {
	{ a_V int 256 regular {axi_master 2}  }
	{ n_V int 16 regular  }
	{ a_addr int 32 regular  }
	{ b_addr int 32 regular  }
	{ c_addr int 32 regular  }
}
set C_modelArgMapList {[ 
	{ "Name" : "a_V", "interface" : "axi_master", "bitwidth" : 256, "direction" : "READWRITE", "bitSlice":[{"low":0,"up":255,"cElement": [{"cName": "a.V","cData": "int256","bit_use": { "low": 0,"up": 255},"cArray": [{"low" : 0,"up" : 511,"step" : 1}]}]}]} , 
 	{ "Name" : "n_V", "interface" : "wire", "bitwidth" : 16, "direction" : "READONLY", "bitSlice":[{"low":0,"up":15,"cElement": [{"cName": "n.V","cData": "uint16","bit_use": { "low": 0,"up": 15},"cArray": [{"low" : 0,"up" : 0,"step" : 0}]}]}]} , 
 	{ "Name" : "a_addr", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY", "bitSlice":[{"low":0,"up":31,"cElement": [{"cName": "a_addr","cData": "int","bit_use": { "low": 0,"up": 31},"cArray": [{"low" : 0,"up" : 0,"step" : 0}]}]}]} , 
 	{ "Name" : "b_addr", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY", "bitSlice":[{"low":0,"up":31,"cElement": [{"cName": "b_addr","cData": "int","bit_use": { "low": 0,"up": 31},"cArray": [{"low" : 0,"up" : 0,"step" : 0}]}]}]} , 
 	{ "Name" : "c_addr", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY", "bitSlice":[{"low":0,"up":31,"cElement": [{"cName": "c_addr","cData": "int","bit_use": { "low": 0,"up": 31},"cArray": [{"low" : 0,"up" : 0,"step" : 0}]}]}]} ]}
# RTL Port declarations: 
set portNum 59
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst_n sc_in sc_logic 1 reset -1 active_low_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ m_axi_a_V_AWVALID sc_out sc_logic 1 signal 0 } 
	{ m_axi_a_V_AWREADY sc_in sc_logic 1 signal 0 } 
	{ m_axi_a_V_AWADDR sc_out sc_lv 64 signal 0 } 
	{ m_axi_a_V_AWID sc_out sc_lv 1 signal 0 } 
	{ m_axi_a_V_AWLEN sc_out sc_lv 8 signal 0 } 
	{ m_axi_a_V_AWSIZE sc_out sc_lv 3 signal 0 } 
	{ m_axi_a_V_AWBURST sc_out sc_lv 2 signal 0 } 
	{ m_axi_a_V_AWLOCK sc_out sc_lv 2 signal 0 } 
	{ m_axi_a_V_AWCACHE sc_out sc_lv 4 signal 0 } 
	{ m_axi_a_V_AWPROT sc_out sc_lv 3 signal 0 } 
	{ m_axi_a_V_AWQOS sc_out sc_lv 4 signal 0 } 
	{ m_axi_a_V_AWREGION sc_out sc_lv 4 signal 0 } 
	{ m_axi_a_V_AWUSER sc_out sc_lv 1 signal 0 } 
	{ m_axi_a_V_WVALID sc_out sc_logic 1 signal 0 } 
	{ m_axi_a_V_WREADY sc_in sc_logic 1 signal 0 } 
	{ m_axi_a_V_WDATA sc_out sc_lv 256 signal 0 } 
	{ m_axi_a_V_WSTRB sc_out sc_lv 32 signal 0 } 
	{ m_axi_a_V_WLAST sc_out sc_logic 1 signal 0 } 
	{ m_axi_a_V_WID sc_out sc_lv 1 signal 0 } 
	{ m_axi_a_V_WUSER sc_out sc_lv 1 signal 0 } 
	{ m_axi_a_V_ARVALID sc_out sc_logic 1 signal 0 } 
	{ m_axi_a_V_ARREADY sc_in sc_logic 1 signal 0 } 
	{ m_axi_a_V_ARADDR sc_out sc_lv 64 signal 0 } 
	{ m_axi_a_V_ARID sc_out sc_lv 1 signal 0 } 
	{ m_axi_a_V_ARLEN sc_out sc_lv 8 signal 0 } 
	{ m_axi_a_V_ARSIZE sc_out sc_lv 3 signal 0 } 
	{ m_axi_a_V_ARBURST sc_out sc_lv 2 signal 0 } 
	{ m_axi_a_V_ARLOCK sc_out sc_lv 2 signal 0 } 
	{ m_axi_a_V_ARCACHE sc_out sc_lv 4 signal 0 } 
	{ m_axi_a_V_ARPROT sc_out sc_lv 3 signal 0 } 
	{ m_axi_a_V_ARQOS sc_out sc_lv 4 signal 0 } 
	{ m_axi_a_V_ARREGION sc_out sc_lv 4 signal 0 } 
	{ m_axi_a_V_ARUSER sc_out sc_lv 1 signal 0 } 
	{ m_axi_a_V_RVALID sc_in sc_logic 1 signal 0 } 
	{ m_axi_a_V_RREADY sc_out sc_logic 1 signal 0 } 
	{ m_axi_a_V_RDATA sc_in sc_lv 256 signal 0 } 
	{ m_axi_a_V_RLAST sc_in sc_logic 1 signal 0 } 
	{ m_axi_a_V_RID sc_in sc_lv 1 signal 0 } 
	{ m_axi_a_V_RUSER sc_in sc_lv 1 signal 0 } 
	{ m_axi_a_V_RRESP sc_in sc_lv 2 signal 0 } 
	{ m_axi_a_V_BVALID sc_in sc_logic 1 signal 0 } 
	{ m_axi_a_V_BREADY sc_out sc_logic 1 signal 0 } 
	{ m_axi_a_V_BRESP sc_in sc_lv 2 signal 0 } 
	{ m_axi_a_V_BID sc_in sc_lv 1 signal 0 } 
	{ m_axi_a_V_BUSER sc_in sc_lv 1 signal 0 } 
	{ n_V sc_in sc_lv 16 signal 1 } 
	{ n_V_ap_vld sc_in sc_logic 1 invld 1 } 
	{ a_addr sc_in sc_lv 32 signal 2 } 
	{ a_addr_ap_vld sc_in sc_logic 1 invld 2 } 
	{ b_addr sc_in sc_lv 32 signal 3 } 
	{ b_addr_ap_vld sc_in sc_logic 1 invld 3 } 
	{ c_addr sc_in sc_lv 32 signal 4 } 
	{ c_addr_ap_vld sc_in sc_logic 1 invld 4 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst_n", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "m_axi_a_V_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "a_V", "role": "AWVALID" }} , 
 	{ "name": "m_axi_a_V_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "a_V", "role": "AWREADY" }} , 
 	{ "name": "m_axi_a_V_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "a_V", "role": "AWADDR" }} , 
 	{ "name": "m_axi_a_V_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "a_V", "role": "AWID" }} , 
 	{ "name": "m_axi_a_V_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "a_V", "role": "AWLEN" }} , 
 	{ "name": "m_axi_a_V_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "a_V", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_a_V_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "a_V", "role": "AWBURST" }} , 
 	{ "name": "m_axi_a_V_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "a_V", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_a_V_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "a_V", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_a_V_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "a_V", "role": "AWPROT" }} , 
 	{ "name": "m_axi_a_V_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "a_V", "role": "AWQOS" }} , 
 	{ "name": "m_axi_a_V_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "a_V", "role": "AWREGION" }} , 
 	{ "name": "m_axi_a_V_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "a_V", "role": "AWUSER" }} , 
 	{ "name": "m_axi_a_V_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "a_V", "role": "WVALID" }} , 
 	{ "name": "m_axi_a_V_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "a_V", "role": "WREADY" }} , 
 	{ "name": "m_axi_a_V_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":256, "type": "signal", "bundle":{"name": "a_V", "role": "WDATA" }} , 
 	{ "name": "m_axi_a_V_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "a_V", "role": "WSTRB" }} , 
 	{ "name": "m_axi_a_V_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "a_V", "role": "WLAST" }} , 
 	{ "name": "m_axi_a_V_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "a_V", "role": "WID" }} , 
 	{ "name": "m_axi_a_V_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "a_V", "role": "WUSER" }} , 
 	{ "name": "m_axi_a_V_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "a_V", "role": "ARVALID" }} , 
 	{ "name": "m_axi_a_V_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "a_V", "role": "ARREADY" }} , 
 	{ "name": "m_axi_a_V_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "a_V", "role": "ARADDR" }} , 
 	{ "name": "m_axi_a_V_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "a_V", "role": "ARID" }} , 
 	{ "name": "m_axi_a_V_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "a_V", "role": "ARLEN" }} , 
 	{ "name": "m_axi_a_V_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "a_V", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_a_V_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "a_V", "role": "ARBURST" }} , 
 	{ "name": "m_axi_a_V_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "a_V", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_a_V_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "a_V", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_a_V_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "a_V", "role": "ARPROT" }} , 
 	{ "name": "m_axi_a_V_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "a_V", "role": "ARQOS" }} , 
 	{ "name": "m_axi_a_V_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "a_V", "role": "ARREGION" }} , 
 	{ "name": "m_axi_a_V_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "a_V", "role": "ARUSER" }} , 
 	{ "name": "m_axi_a_V_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "a_V", "role": "RVALID" }} , 
 	{ "name": "m_axi_a_V_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "a_V", "role": "RREADY" }} , 
 	{ "name": "m_axi_a_V_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":256, "type": "signal", "bundle":{"name": "a_V", "role": "RDATA" }} , 
 	{ "name": "m_axi_a_V_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "a_V", "role": "RLAST" }} , 
 	{ "name": "m_axi_a_V_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "a_V", "role": "RID" }} , 
 	{ "name": "m_axi_a_V_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "a_V", "role": "RUSER" }} , 
 	{ "name": "m_axi_a_V_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "a_V", "role": "RRESP" }} , 
 	{ "name": "m_axi_a_V_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "a_V", "role": "BVALID" }} , 
 	{ "name": "m_axi_a_V_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "a_V", "role": "BREADY" }} , 
 	{ "name": "m_axi_a_V_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "a_V", "role": "BRESP" }} , 
 	{ "name": "m_axi_a_V_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "a_V", "role": "BID" }} , 
 	{ "name": "m_axi_a_V_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "a_V", "role": "BUSER" }} , 
 	{ "name": "n_V", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "n_V", "role": "default" }} , 
 	{ "name": "n_V_ap_vld", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "n_V", "role": "ap_vld" }} , 
 	{ "name": "a_addr", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "a_addr", "role": "default" }} , 
 	{ "name": "a_addr_ap_vld", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "a_addr", "role": "ap_vld" }} , 
 	{ "name": "b_addr", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "b_addr", "role": "default" }} , 
 	{ "name": "b_addr_ap_vld", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "b_addr", "role": "ap_vld" }} , 
 	{ "name": "c_addr", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "c_addr", "role": "default" }} , 
 	{ "name": "c_addr_ap_vld", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "c_addr", "role": "ap_vld" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"],
		"CDFG" : "example",
		"VariableLatency" : "1",
		"AlignedPipeline" : "0",
		"UnalignedPipeline" : "0",
		"ProcessNetwork" : "0",
		"Combinational" : "0",
		"ControlExist" : "1",
		"Port" : [
		{"Name" : "a_V", "Type" : "MAXI", "Direction" : "IO",
			"BlockSignal" : [
			{"Name" : "a_V_blk_n_AR", "Type" : "RtlSignal"},
			{"Name" : "a_V_blk_n_R", "Type" : "RtlSignal"},
			{"Name" : "a_V_blk_n_AW", "Type" : "RtlSignal"},
			{"Name" : "a_V_blk_n_W", "Type" : "RtlSignal"},
			{"Name" : "a_V_blk_n_B", "Type" : "RtlSignal"}]},
		{"Name" : "n_V", "Type" : "Vld", "Direction" : "I",
			"BlockSignal" : [
			{"Name" : "n_V_blk_n", "Type" : "RtlSignal"}]},
		{"Name" : "a_addr", "Type" : "Vld", "Direction" : "I",
			"BlockSignal" : [
			{"Name" : "a_addr_blk_n", "Type" : "RtlSignal"}]},
		{"Name" : "b_addr", "Type" : "Vld", "Direction" : "I",
			"BlockSignal" : [
			{"Name" : "b_addr_blk_n", "Type" : "RtlSignal"}]},
		{"Name" : "c_addr", "Type" : "Vld", "Direction" : "I",
			"BlockSignal" : [
			{"Name" : "c_addr_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.example_a_V_m_axi_U", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.buff_a_U", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.buff_b_U", "Parent" : "0"},
	{"ID" : "4", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.buff_V_U", "Parent" : "0"},
	{"ID" : "5", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.example_fadd_32nsbkb_U1", "Parent" : "0"},
	{"ID" : "6", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.example_fadd_32nsbkb_U2", "Parent" : "0"},
	{"ID" : "7", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.example_fadd_32nsbkb_U3", "Parent" : "0"},
	{"ID" : "8", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.example_fadd_32nsbkb_U4", "Parent" : "0"},
	{"ID" : "9", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.example_fadd_32nsbkb_U5", "Parent" : "0"},
	{"ID" : "10", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.example_fadd_32nsbkb_U6", "Parent" : "0"},
	{"ID" : "11", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.example_fadd_32nsbkb_U7", "Parent" : "0"},
	{"ID" : "12", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.example_fadd_32nsbkb_U8", "Parent" : "0"}]}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "2", "Max" : "271874"}
	, {"Name" : "Interval", "Min" : "3", "Max" : "271875"}
]}

set Spec2ImplPortList { 
	a_V { m_axi {  { m_axi_a_V_AWVALID VALID 1 1 }  { m_axi_a_V_AWREADY READY 0 1 }  { m_axi_a_V_AWADDR ADDR 1 64 }  { m_axi_a_V_AWID ID 1 1 }  { m_axi_a_V_AWLEN LEN 1 8 }  { m_axi_a_V_AWSIZE SIZE 1 3 }  { m_axi_a_V_AWBURST BURST 1 2 }  { m_axi_a_V_AWLOCK LOCK 1 2 }  { m_axi_a_V_AWCACHE CACHE 1 4 }  { m_axi_a_V_AWPROT PROT 1 3 }  { m_axi_a_V_AWQOS QOS 1 4 }  { m_axi_a_V_AWREGION REGION 1 4 }  { m_axi_a_V_AWUSER USER 1 1 }  { m_axi_a_V_WVALID VALID 1 1 }  { m_axi_a_V_WREADY READY 0 1 }  { m_axi_a_V_WDATA DATA 1 256 }  { m_axi_a_V_WSTRB STRB 1 32 }  { m_axi_a_V_WLAST LAST 1 1 }  { m_axi_a_V_WID ID 1 1 }  { m_axi_a_V_WUSER USER 1 1 }  { m_axi_a_V_ARVALID VALID 1 1 }  { m_axi_a_V_ARREADY READY 0 1 }  { m_axi_a_V_ARADDR ADDR 1 64 }  { m_axi_a_V_ARID ID 1 1 }  { m_axi_a_V_ARLEN LEN 1 8 }  { m_axi_a_V_ARSIZE SIZE 1 3 }  { m_axi_a_V_ARBURST BURST 1 2 }  { m_axi_a_V_ARLOCK LOCK 1 2 }  { m_axi_a_V_ARCACHE CACHE 1 4 }  { m_axi_a_V_ARPROT PROT 1 3 }  { m_axi_a_V_ARQOS QOS 1 4 }  { m_axi_a_V_ARREGION REGION 1 4 }  { m_axi_a_V_ARUSER USER 1 1 }  { m_axi_a_V_RVALID VALID 0 1 }  { m_axi_a_V_RREADY READY 1 1 }  { m_axi_a_V_RDATA DATA 0 256 }  { m_axi_a_V_RLAST LAST 0 1 }  { m_axi_a_V_RID ID 0 1 }  { m_axi_a_V_RUSER USER 0 1 }  { m_axi_a_V_RRESP RESP 0 2 }  { m_axi_a_V_BVALID VALID 0 1 }  { m_axi_a_V_BREADY READY 1 1 }  { m_axi_a_V_BRESP RESP 0 2 }  { m_axi_a_V_BID ID 0 1 }  { m_axi_a_V_BUSER USER 0 1 } } }
	n_V { ap_vld {  { n_V in_data 0 16 }  { n_V_ap_vld in_vld 0 1 } } }
	a_addr { ap_vld {  { a_addr in_data 0 32 }  { a_addr_ap_vld in_vld 0 1 } } }
	b_addr { ap_vld {  { b_addr in_data 0 32 }  { b_addr_ap_vld in_vld 0 1 } } }
	c_addr { ap_vld {  { c_addr in_data 0 32 }  { c_addr_ap_vld in_vld 0 1 } } }
}

set busDeadlockParameterList { 
	{ a_V { NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 } } \
}

# RTL port scheduling information:
set fifoSchedulingInfoList { 
}

# RTL bus port read request latency information:
set busReadReqLatencyList { 
	{ a_V 1 }
}

# RTL bus port write response latency information:
set busWriteResLatencyList { 
	{ a_V 1 }
}

# RTL array port load latency information:
set memoryLoadLatencyList { 
}
