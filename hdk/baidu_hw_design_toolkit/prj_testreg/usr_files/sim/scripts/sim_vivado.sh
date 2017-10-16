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
xelab -m64 --initfile ${XILINX_VIVADO}/data/xsim/ip/xsim_ip.ini --debug typical --relax --mt 8  \
   -L xil_defaultlib               \
   -L generic_baseblocks_v2_1_0    \
   -L axi_infrastructure_v1_1_0    \
   -L axi_register_slice_v2_1_11   \
   -L axi_crossbar_v2_1_12         \
   -L axi_data_fifo_v2_1_10        \
   -L blk_mem_gen_v8_3_5           \
   -L fifo_generator_v13_1_3       \
   -L axi_dwidth_converter_v2_1_11 \
   -L unisims_ver                  \
   -L unimacro_ver                 \
   -L secureip                     \
   -L xpm                          \
   --snapshot tb_behav xil_defaultlib.tb xil_defaultlib.glbl -log elaborate.log
xsim tb_behav -R -tclbatch ${SIMSCRIPT_DIR}/tb_wave.tcl -log simulate.log
