--define VIVADO_SIM

--sourcelibext .v
--sourcelibdir ${SIMSCRIPT_DIR}/../ip_simfiles

--include ${SIMSCRIPT_DIR}/../../include
--include ${COMMON_DIR}/hdl

${SIMSCRIPT_DIR}/../../sim/tb/tb.v
${SIMSCRIPT_DIR}/../../usr_rtl/rp_bd.v


#${COMMON_DIR}/sim/module/ddr4/rtl/ip_top/axiddr/ddr4_0.sv
#${COMMON_DIR}/sim/module/ddr4/rtl/ip_top/axiddr/ddr4_0_ddr4.sv

-f ${COMMON_DIR}/sim/filelists/tb.vivado.f
#-f ${COMMON_DIR}/sim/filelists/ddr.vivado.f
