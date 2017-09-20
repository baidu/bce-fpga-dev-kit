--define VIVADO_SIM

--sourcelibext .v

--sourcelibdir ${SIMSCRIPT_DIR}/../ipi_simfiles

--include ${SIMSCRIPT_DIR}/../ipi_simfiles
--include ${SIMSCRIPT_DIR}/../../include
--include ${COMMON_DIR}/hdl

${SIMSCRIPT_DIR}/../../sim/tb/tb.v

${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_xbar_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_axi_register_slice_0_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_axi_register_slice_1_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/axislave_cu_apctrl_v1_0_S00_AXI.v
${SIMSCRIPT_DIR}/../ipi_simfiles/axislave_cu_apctrl_v1_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_axislave_cu_apctrl_v1_0_0_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/example.v
${SIMSCRIPT_DIR}/../ipi_simfiles/example_buff_a.v
${SIMSCRIPT_DIR}/../ipi_simfiles/example_a_V_m_axi.v
${SIMSCRIPT_DIR}/../ipi_simfiles/example_fadd_32nsbkb.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_s00_regslice_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_s01_regslice_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_m00_data_fifo_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_m00_regslice_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_m01_data_fifo_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_m01_regslice_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_m02_data_fifo_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_m02_regslice_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_m03_data_fifo_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_m03_regslice_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_auto_cc_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_auto_cc_1.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_auto_cc_2.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_auto_cc_3.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_auto_us_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_auto_rs_w_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_auto_us_1.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_auto_rs_w_1.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_util_vector_logic_0_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_util_vector_logic_1_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_util_vector_logic_2_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_util_vector_logic_3_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_util_vector_logic_4_0.v

${COMMON_DIR}/sim/module/ddr4/rtl/ip_top/axiddr/ddr4_0.sv
${COMMON_DIR}/sim/module/ddr4/rtl/ip_top/axiddr/ddr4_0_ddr4.sv

-f ${COMMON_DIR}/sim/filelists/tb.vivado.f
-f ${COMMON_DIR}/sim/filelists/ddr.vivado.f
