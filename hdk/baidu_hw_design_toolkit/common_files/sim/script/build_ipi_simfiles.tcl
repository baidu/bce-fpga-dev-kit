#!/bin/bash
#set -o pipefail
#set -o nounset

cd ${SIMSCRIPT_DIR}/..
if [ -d "ipi_simfiles" ]; then
  rm -rf ipi_simfiles
fi

mkdir ipi_simfiles

cd $BUILD_DIR
if [ -d "tempDir" ]; then
  rm -rf tempDir
fi

vivado -mode batch -source ./scripts/build_rp_bd.tcl
vivado -mode batch -source ./scripts/ddr_define.tcl

file=($(find tempDir | grep .v$))
for rtl_file in ${file[@]}
do
  cp $rtl_file "${SIMSCRIPT_DIR}/../ipi_simfiles"
done
file=($(find tempDir| grep .vhd$))
for rtl_file in ${file[@]}
do
  cp $rtl_file "${SIMSCRIPT_DIR}/../ipi_simfiles"
done

rm -rf tempDir
