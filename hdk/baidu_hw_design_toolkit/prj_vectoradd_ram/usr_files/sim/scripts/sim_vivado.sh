#!/bin/bash
#set -o pipefail
#set -o nounset

SIM_IPI=0
FAST_SIM=0
SIMULATOR=xsim
DEFINE_PARA='--define VIVADO_SIM'
LIB_PATH="~"
if [[ $# == 0 ]]; then
    echo "No user define macros"
else
    while [[ "$1" != "" ]]; do
	if [[ ("$1" == "-simulator") && "$2" != ""  ]]; then
            SIMULATOR=$2
            shift
	    shift
	elif [[ ("$1" == "-lib_map_path") && "$2" != ""  ]]; then
            LIB_PATH=$2
            shift
	    shift
        elif [[ ("$1" == "--define" || "$1" == "-d") && "$2" != "" ]]; then
            DEFINE_PARA="${DEFINE_PARA} --define $2"
	    if [[ ("$2" == "FAST_SIM") ]]; then
            	FAST_SIM=1
	    fi
            shift
            shift
        elif [[ ("$1" == "-IPI" || "$1" == "-ipi") ]]; then
            SIM_IPI=1
	    DEFINE_PARA="${DEFINE_PARA} --define IPI"
            shift
        else
            echo "Usage: -simulator [val] default is xsim\n
		-lib_map_path <path>\n		
		-d [--define] <name>[=<val>]\n
		-ipi\n
		-FAST_SIM"
            exit 1
        fi
    done
fi

export SIMSCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export BUILD_DIR="${SIMSCRIPT_DIR}/../../../build"
export COMMON_DIR="${SIMSCRIPT_DIR}/../../../../common_files"

if [ $SIM_IPI == 1 ]; then
    echo "Simulation IPI mode, generating IPI sim files..."
else
    echo "Simulation nonIPI mode, generating usr IP sim files..."
fi

cd ${SIMSCRIPT_DIR}/..
if [ -d "sim_vivado" ]; then
  rm -rf sim_vivado
fi
mkdir sim_vivado
cd sim_vivado
if [ $SIMULATOR == "questa" ]; then
    DEFINE_PARA=$(echo $DEFINE_PARA | sed "s/--define\ /+define+/g")
fi
echo -e "set IPI $SIM_IPI\nset FAST_SIM $FAST_SIM\nset SIMULATOR $SIMULATOR\nset LIB_PATH $LIB_PATH\nset DEFINE_PARA \"$DEFINE_PARA\"" > sim_type.tcl
cd $BUILD_DIR
vivado -mode batch -source $COMMON_DIR/sim/script/build_sim_prj.tcl
if [ $SIMULATOR == "xsim" ]; then
    sed -i "s/\$xv_path\/bin\/xvlog \$xvlog_opts/\$xv_path\/bin\/xvlog \$xvlog_opts $DEFINE_PARA/" ${SIMSCRIPT_DIR}/../sim_vivado/xsim/tb.sh
    sed -i "s/\$xv_path\/bin\/xelab /\$xv_path\/bin\/xelab -L generic_baseblocks_v2_1_0 -L axi_infrastructure_v1_1_0  -L axi_register_slice_v2_1_11 -L axi_crossbar_v2_1_12 -L axi_data_fifo_v2_1_10 -L blk_mem_gen_v8_3_5 -L fifo_generator_v13_1_3  -L axi_dwidth_converter_v2_1_11 /" ${SIMSCRIPT_DIR}/../sim_vivado/xsim/tb.sh
else
    sed -i "s/vlog /vlog $DEFINE_PARA /g" ${SIMSCRIPT_DIR}/../sim_vivado/questa/compile.do
    sed -i "s/vopt -64 +acc -l elaborate.log/vopt -64 +acc -l elaborate.log -L generic_baseblocks_v2_1_0 -L axi_infrastructure_v1_1_0  -L axi_register_slice_v2_1_11 -L axi_crossbar_v2_1_12 -L axi_data_fifo_v2_1_10 -L blk_mem_gen_v8_3_5 -L fifo_generator_v13_1_3  -L axi_dwidth_converter_v2_1_11/" ${SIMSCRIPT_DIR}/../sim_vivado/questa/elaborate.do
fi

