#!/bin/sh
lli=${LLVMINTERP-lli}
exec $lli \
    /home/ruanyuan/CLOUD/fpga_cloud/hls/vectoradd/solution1/.autopilot/db/a.g.bc ${1+"$@"}
