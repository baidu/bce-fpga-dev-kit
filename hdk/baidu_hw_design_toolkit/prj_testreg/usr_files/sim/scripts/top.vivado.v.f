--define VIVADO_SIM

--sourcelibext .v
--sourcelibdir ${SIMSCRIPT_DIR}/../ip_simfiles

--include ${SIMSCRIPT_DIR}/../ip_simfiles
--include ${SIMSCRIPT_DIR}/../../include
--include ${COMMON_DIR}/hdl

${SIMSCRIPT_DIR}/../../sim/tb/tb.v

${SIMSCRIPT_DIR}/../../usr_rtl/rp_bd.v
${SIMSCRIPT_DIR}/../ip_simfiles/vio_0.v
${SIMSCRIPT_DIR}/../ip_simfiles/axi_lite_ila.v
${SIMSCRIPT_DIR}/../ip_simfiles/axi_dwidth_converter_256to512.v
${SIMSCRIPT_DIR}/../ip_simfiles/fifo_async_blk_fwft_576x512_latency_0.v
${SIMSCRIPT_DIR}/../ip_simfiles/fifo_async_blk_fwft_72x512_latency_0.v

#${COMMON_DIR}/sim/module/ddr4/rtl/ip_top/appddr/ddr4_0.sv
#${COMMON_DIR}/sim/module/ddr4/rtl/ip_top/appddr/ddr4_0_ddr4.sv

-f ${COMMON_DIR}/sim/filelists/tb.vivado.f
#-f ${COMMON_DIR}/sim/filelists/ddr.vivado.f
