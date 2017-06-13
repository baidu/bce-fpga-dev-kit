set_property SRC_FILE_INFO {cfile:/home/ruanyuan/CLOUD/fpga_cloud/0509/fpga-cloud/baidu_hw_design_toolkit/build/projDir/myProj.srcs/sources_1/bd/rp_bd/ip/rp_bd_axislave_cu_apctrl_v1_0_0_0/axislave_cu_apctrl.xdc rfile:../../../myProj.srcs/sources_1/bd/rp_bd/ip/rp_bd_axislave_cu_apctrl_v1_0_0_0/axislave_cu_apctrl.xdc id:1 order:EARLY scoped_inst:rp_bd_i/axislave_cu_apctrl_v1_0_0/inst} [current_design]
set_property src_info {type:SCOPED_XDC file:1 line:1 export:INPUT save:INPUT read:READ} [current_design]
create_pblock rp_bd_i_axislave_cu_apctrl_v1_0_0_inst_axislave_cu
current_instance rp_bd_i/axislave_cu_apctrl_v1_0_0/inst
add_cells_to_pblock [get_pblocks rp_bd_i_axislave_cu_apctrl_v1_0_0_inst_axislave_cu] [get_cells *]
current_instance
add_cells_to_pblock [get_pblocks rp_bd_i_axislave_cu_apctrl_v1_0_0_inst_axislave_cu] [get_cells rp_bd_i/axislave_cu_apctrl_v1_0_0]
resize_pblock [get_pblocks rp_bd_i_axislave_cu_apctrl_v1_0_0_inst_axislave_cu] -add {CLOCKREGION_X4Y2:CLOCKREGION_X4Y4}
