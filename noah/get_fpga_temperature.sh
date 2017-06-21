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
    exit 1
fi

fpga_type=''
detect_fpga_type fpga_type
if [[ "x$fpga_type" == "xunknown" ]]; then
    exit 1
fi
#echo "fpga_type=${fpga_type}"

fpga_bdf=''
detect_fpga_bdf fpga_bdf
if [[ "x$fpga_bdf" == "xerror" ]]; then
    exit 1
fi
#echo "fpga_bdf=${fpga_bdf}"

fpga_sysfs_path=''
detect_fpga_sysfs_path fpga_sysfs_path $fpga_bdf
if [[ "x$fpga_sysfs_path" == "xerror" ]]; then
    exit 1
fi
#echo "fpga_sysfs_path=${fpga_sysfs_path}"

if [[ ! -x $__dir/mmap_readq ]]; then
    gcc $__dir/mmap_readq.c -m64 -o $__dir/mmap_readq >/dev/null 2>&1
fi

qword='0'
fpga_temperature='0'
case $fpga_type in
"cnn")
    qword=$($__dir/mmap_readq $fpga_sysfs_path/resource0 $((2*8)))
    fpga_temperature=$(echo "${qword}*501.37/4096-273.68" | bc)
    ;;
"rsa")
    qword=$($__dir/mmap_readq $fpga_sysfs_path/resource0 $((32*8)))
    fpga_temperature=$(echo "${qword}*503.98/4096-273.15" | bc)
    ;;
"dev")
    # TODO unsupported
    #qword=$($__dir/mmap_readq $fpga_sysfs_path/resource0 $((2*8)))
    #fpga_temperature=$(echo "${qword}*501.37/4096-273.68" | bc)
    ;;
esac

if [[ $(echo "${fpga_temperature}>200.0" | bc) == "1" ]]; then
    # Maybe, PCIe link is not ready :), then use a faked value
    fpga_temperature='37.0'
fi

echo "FPGA_TEMPERATURE:${fpga_temperature}"
exit 0

