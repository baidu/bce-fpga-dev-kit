#!/bin/bash

function is_fpga_installed {
    lspci | grep -E -q "Xilinx|(1d22:2011)" && return 0 || return 1
}

function detect_fpga_type {
    (lspci -d 1d22:2011 -nn | grep -q "") && eval "$1='cnn'" && return
    (lspci -d 10ee:9038 -nn | grep -q "") && eval "$1='dev'" && return
    (lspci -d 10ee:8038 -nn | grep -q "") && eval "$1='rsa'" && return
    eval "$1='unknown'" && return
}

function detect_fpga_bdf {
    local local_fpga_cnt=$(lspci | grep -E -c "Xilinx|(1d22:2011)")
    if [[ $local_fpga_cnt -ne 1 ]]; then
        eval "$1='error'" && return
    fi

    local local_fpga_bdf=$(lspci | grep -E "Xilinx|(1d22:2011)" | awk '{print $1}')
    eval "$1=$local_fpga_bdf" && return
}

function detect_fpga_sysfs_path {
    local local_fpga_sysfs_cnt=$(find /sys/bus/pci/devices -name "*$2" | wc -l)
    if [[ $local_fpga_sysfs_cnt -ne 1 ]]; then
        eval "$1='error'" && return
    fi

    local local_fpga_sysfs_path=$(readlink -f $(find /sys/bus/pci/devices -name "*$2"))
    eval "$1=$local_fpga_sysfs_path" && return
}

