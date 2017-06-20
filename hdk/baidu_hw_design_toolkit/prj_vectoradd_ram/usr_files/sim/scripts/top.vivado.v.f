--define VIVADO_SIM

--sourcelibext .v

--sourcelibdir ${SIMSCRIPT_DIR}/../ipi_simfiles

--include ${SIMSCRIPT_DIR}/../ipi_simfiles
--include ${SIMSCRIPT_DIR}/../../include

${SIMSCRIPT_DIR}/../../sim/tb/tb.v

${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_axi_bram_ctrl_0_bram_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_xbar_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/axislave_cu_apctrl_v1_0_S00_AXI.v
${SIMSCRIPT_DIR}/../ipi_simfiles/example.v
${SIMSCRIPT_DIR}/../ipi_simfiles/example_buff_a.v
${SIMSCRIPT_DIR}/../ipi_simfiles/example_a_V_m_axi.v
${SIMSCRIPT_DIR}/../ipi_simfiles/example_fadd_32nsbkb.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_s00_regslice_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_s01_regslice_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd_m00_data_fifo_0.v
${SIMSCRIPT_DIR}/../ipi_simfiles/rp_bd.v

-f ${COMMON_DIR}/sim/filelists/tb.vivado.f
