#!/bin/bash
#set -o pipefail
#set -o nounset

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

#set project name
if [[ "$1" == "" ]]; then
    echo "create_prj prj_name [-g -m -i -d]"
    exit 0
else
    PRJ_NAME=$1
    shift
fi

#set project parameter
PRJ_IPI=0
DDR_NUM=0
GUI_PRJ=0
AXI_MASTER=0
while [[ "$1" != "" ]]; do
    if [[ ("$1" == "-gui" || "$1" == "-GUI" || "$1" == "-g" || "$1" == "-G" ) ]]; then
        GUI_PRJ=1
    fi
    if [[ ("$1" == "-master" || "$1" == "-MASTER" || "$1" == "-m" || "$1" == "-M" ) ]]; then
        AXI_MASTER=1
    fi
    if [[ ("$1" == "-IPI" || "$1" == "-ipi" || "$1" == "-i" || "$1" == "-I" ) ]]; then
        PRJ_IPI=1
        echo "$PRJ_NAME will use IP Integrator flow."
    fi
    if [[ ("$1" == "-ddr" || "$1" == "-DDR" || "$1" == "-d" || "$1" == "-D" ) ]]; then
        shift
        DDR_NUM=$1
        echo "$PRJ_NAME will use $DDR_NUM DDR channels."
    fi
    shift
done

#create project folder
cd $SCRIPT_DIR/../..
if [ -d prj_$PRJ_NAME ]; then
  echo "Same name project exists, please confirm the name of project you want to create."
  exit 2
fi

mkdir prj_$PRJ_NAME
mkdir prj_$PRJ_NAME/build
mkdir prj_$PRJ_NAME/build/scripts
mkdir prj_$PRJ_NAME/usr_files
mkdir prj_$PRJ_NAME/usr_files/usr_rtl
mkdir prj_$PRJ_NAME/usr_files/usr_xdc
mkdir prj_$PRJ_NAME/usr_files/usr_ip
mkdir prj_$PRJ_NAME/usr_files/usr_ip_resposity
mkdir prj_$PRJ_NAME/usr_files/include

#copy scripts
cp $SCRIPT_DIR/ref_script/* prj_$PRJ_NAME/build/scripts/
if [ $PRJ_IPI -eq 1 ]; then
   mv prj_$PRJ_NAME/build/scripts/run_IPI.tcl prj_$PRJ_NAME/build
   rm -rf prj_$PRJ_NAME/build/scripts/run_nonIPI.tcl
   rm -rf prj_$PRJ_NAME/build/scripts/step_01_createProject_nonIPI.tcl
else
   mv prj_$PRJ_NAME/build/scripts/run_nonIPI.tcl prj_$PRJ_NAME/build
   rm -rf prj_$PRJ_NAME/build/scripts/run_IPI.tcl
   rm -rf prj_$PRJ_NAME/build/scripts/step_01_createProject_IPI.tcl
fi
if [ $DDR_NUM -eq 0 ]; then
   rm -rf prj_$PRJ_NAME/build/scripts/rp_mig_bd.tcl
fi

#change step_00_setup for ddr config
if [ $DDR_NUM -gt 0 ]; then
   sed -i "s/USE_AXI_DDR 0/USE_AXI_DDR 1/" prj_$PRJ_NAME/build/scripts/step_00_setup.tcl
fi
if [ $AXI_MASTER -gt 0 ]; then
   sed -i "s/USE_RP_AXI_MASTER 0/USE_RP_AXI_MASTER 1/" prj_$PRJ_NAME/build/scripts/step_00_setup.tcl
fi
DDR_NUM_CNT=$(expr $DDR_NUM - 1)
for i in $(seq 0 $DDR_NUM_CNT); do
   sed -i "s/USE_DDR4_C$i 0/USE_DDR4_C$i 1/" prj_$PRJ_NAME/build/scripts/step_00_setup.tcl
done

#copy rp module template
if [ $PRJ_IPI -eq 0 ]; then
   rm -f prj_$PRJ_NAME/build/scripts/rp_bd.tcl
   rm -f prj_$PRJ_NAME/build/scripts/build_rp_bd.tcl
   cp $SCRIPT_DIR/ref_module/rp_bd.v prj_$PRJ_NAME/usr_files/usr_rtl/rp_bd.v
fi

#copy simulation template
cp -r $SCRIPT_DIR/ref_sim/ prj_$PRJ_NAME/usr_files/sim
if [ $DDR_NUM -gt 0 ]; then
   sed -i "s/#//" prj_$PRJ_NAME/usr_files/sim/scripts/top.vivado.v.f
fi

#generate vivado prj
cd prj_$PRJ_NAME/build
if [ $GUI_PRJ -gt 0 ]; then
   vivado -source ./scripts/build_gui_prj.tcl
fi
