#!/bin/bash
#set -o pipefail
#set -o nounset

cd ${SIMSCRIPT_DIR}/..
if [ -d "ip_simfiles" ]; then
  rm -rf ip_simfiles
fi

mkdir ip_simfiles

cd ${BUILD_DIR}
if [ -d "tempDir" ]; then
  rm -rf tempDir
fi
vivado -mode batch -source ./scripts/build_usr_ip.tcl
vivado -mode batch -source ./scripts/ddr_define.tcl
rm -rf tempDir

cd ${BUILD_DIR}/../usr_files/usr_ip
file=($(find | grep /sim/ | grep .v$))
for sim_file in ${file[@]}
do
  cp $sim_file "${SIMSCRIPT_DIR}/../ip_simfiles"
done
