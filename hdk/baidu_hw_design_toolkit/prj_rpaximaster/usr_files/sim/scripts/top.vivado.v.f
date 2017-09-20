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
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_axi_register_slice_2_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_axi_register_slice_3_0.v
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
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_auto_rs_w_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_auto_rs_w_1.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_auto_us_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_auto_us_1.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_ila_0_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_util_vector_logic_0_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_util_vector_logic_1_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_util_vector_logic_2_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_util_vector_logic_3_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_util_vector_logic_4_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_util_vector_logic_5_0.v

${SIMSCRIPT_DIR}/../../usr_rtl/card_addr_translate.v

${COMMON_DIR}/sim/module/ddr4/rtl/ip_top/axiddr/ddr4_0.sv
${COMMON_DIR}/sim/module/ddr4/rtl/ip_top/axiddr/ddr4_0_ddr4.sv

-f ${COMMON_DIR}/sim/filelists/tb.vivado.f
-f ${COMMON_DIR}/sim/filelists/ddr.vivado.f
