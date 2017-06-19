--define VIVADO_SIM

--sourcelibext .v

--include ${SIMSCRIPT_DIR}/../../include

${SIMSCRIPT_DIR}/../../sim/tb/tb.v

${SIMSCRIPT_DIR}/../../usr_rtl/rp_bd.v
${SIMSCRIPT_DIR}/../ip_simfiles/vio_0.v
${SIMSCRIPT_DIR}/../ip_simfiles/axi_lite_ila.v

-f ${COMMON_DIR}/sim/filelists/tb.vivado.f
