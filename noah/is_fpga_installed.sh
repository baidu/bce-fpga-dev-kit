#!/bin/bash
#set -o xtrace
set -o nounset
set -o errexit

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"
__root="$(cd "$(dirname "${__dir}")" && pwd)" # <-- change this as it depends on your app

source $__dir/common.sh

if ! is_fpga_installed; then
    echo "IS_FPGA_INSTALLED:0"
else
    echo "IS_FPGA_INSTALLED:1"
fi
exit 0

