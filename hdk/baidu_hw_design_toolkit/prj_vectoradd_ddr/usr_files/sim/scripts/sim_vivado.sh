#!/bin/bash
#set -o pipefail
#set -o nounset

SIM_IPI=0
if [[ $# == 0 ]]; then
    echo "No user define macros"
else
    while [[ "$1" != "" ]]; do
        if [[ ("$1" == "--define" || "$1" == "-d") && "$2" != "" ]]; then
            DEFINE_PARA="${DEFINE_PARA} $1 $2"
            shift
            shift
        elif [[ ("$1" == "-IPI" || "$1" == "-ipi") ]]; then
            SIM_IPI=1
            shift
        else
            echo "Usage: -d [define] <name>[=<val>]"
            exit 1
        fi
    done
fi

export SIMSCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export BUILD_DIR="${SIMSCRIPT_DIR}/../../../build"
export COMMON_DIR="${SIMSCRIPT_DIR}/../../../../common_files"

if [ $SIM_IPI == 1 ]; then
    echo "Simulation IPI mode, generating IPI sim files..."
    source ${COMMON_DIR}/sim/script/build_ipi_simfiles.tcl
else
    echo "Simulation nonIPI mode, generating usr IP sim files..."
    source ${COMMON_DIR}/sim/script/build_ip_simfiles.tcl
fi

cd ${SIMSCRIPT_DIR}/..
if [ -d "sim_vivado" ]; then
  rm -rf sim_vivado
fi
mkdir sim_vivado

cd ${SIMSCRIPT_DIR}/../sim_vivado

xvlog --sv ${DEFINE_PARA} -m64 --initfile ${XILINX_VIVADO}/data/xsim/ip/xsim_ip.ini --work xil_defaultlib --relax -f ${SIMSCRIPT_DIR}/top.vivado.v.f
xvhdl -m64 --initfile ${XILINX_VIVADO}/data/xsim/ip/xsim_ip.ini --relax -prj ${SIMSCRIPT_DIR}/top.vivado.vhd.prj
xelab -m64 --initfile ${XILINX_VIVADO}/data/xsim/ip/xsim_ip.ini --debug typical --relax --mt 8 -L xil_defaultlib -L microblaze_v10_0_1 -L lib_cdc_v1_0_2 -L proc_sys_reset_v5_0_10 -L lmb_v10_v3_0_9 -L lmb_bram_if_cntlr_v4_0_10 -L blk_mem_gen_v8_3_5 -L iomodule_v3_0_6 -L generic_baseblocks_v2_1_0 -L axi_infrastructure_v1_1_0 -L axi_register_slice_v2_1_11 -L fifo_generator_v13_1_3 -L axi_data_fifo_v2_1_10 -L axi_crossbar_v2_1_12 -L xbip_utils_v3_0_7 -L axi_utils_v2_0_3 -L xbip_pipe_v3_0_3 -L xbip_dsp48_wrapper_v3_0_4 -L xbip_dsp48_addsub_v3_0_3 -L xbip_dsp48_multadd_v3_0_3 -L xbip_bram18k_v3_0_3 -L mult_gen_v12_0_12 -L floating_point_v7_1_3 -L util_vector_logic_v2_0 -L axi_clock_converter_v2_1_10 -L axi_protocol_converter_v2_1_11 -L axi_dwidth_converter_v2_1_11 -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot tb_behav xil_defaultlib.tb xil_defaultlib.glbl -log elaborate.log
xsim tb_behav -R -tclbatch ${SIMSCRIPT_DIR}/tb_wave.tcl -log simulate.log
