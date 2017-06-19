#!/bin/bash

if [[ $# != 2 ]]; then
    echo "Usage: $0 [path of custom clear.bin, or enter 'base'] [path of custom partial bin]"
    exit 1
fi

SCRIPTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MCAPBINDIR=${SCRIPTDIR}/mcap
LASTOPDIR=${SCRIPTDIR}/last_clear_bin
REGBIN=${SCRIPTDIR}/bin/reg_write_32
REGLOGFILE=${SCRIPTDIR}/bin_pr_set_reg.log
PARTIALLOGFILE=${SCRIPTDIR}/bin_pr_load_partial_bin.log
LASTOPLOGFILE=${SCRIPTDIR}/last_operation.log
BASECLEAR=${SCRIPTDIR}/base/base_pr_region_partial_clear.bin
CLEARBIN=$BASECLEAR
PARTIALBIN=""
var1=$1
var2=$2

#inputs check
if [ "$1" = "base" ]; then
    echo "set base partial clear bit"
elif [ ${#var1} -lt 10 ]; then
    echo "custom clear bin file should end with 'clear.bin'"
    exit 2
elif [ ${var1:0-9} = "clear.bin" ]; then 
    CLEARBIN=$1
else
    echo "clear bin file should end with 'clear.bin'"
    exit 2
fi

if [ ${#var2} -lt 12 ]; then
    echo "partial bin file should end with 'partial.bin'"
    exit 2
elif [ ${var2:0-11} = "partial.bin" ]; then 
    PARTIALBIN=$2
else
    echo "partial bin file should end with 'partial.bin'"
    exit 2
fi

if [ ! -f "$CLEARBIN" ]; then
    echo "clear bin file : $CLEARBIN does not exist!"
    exit 2
fi

if [ ! -f "$PARTIALBIN" ]; then
    echo "partial region bin file : $PARTIALBIN does not exist!"
    exit 2
fi

#set decouple reg
echo "set decouple..." > $REGLOGFILE
$REGBIN 0 $((0*1024+8)) 1 >> $REGLOGFILE 2>&1 
if [[ $? == 0 ]]; then
    echo "OK set decouple! ..."
else
    echo "error when setting decouple!"
    echo "refer to $REGLOGFILE for more details!"
    exit 2
fi
sleep 0.5

#mcap clear bit
echo "load partial clear bin file into device ..." > $PARTIALLOGFILE
$MCAPBINDIR/mcap -x 0x9038 -C $CLEARBIN >> $PARTIALLOGFILE 2>&1
done1=`cat $PARTIALLOGFILE | grep  "FPGA Partial Configuration Done" | wc -l`
if [[ $done1 == 1 ]]; then
    echo "OK loading clear bin! ..."
else
    echo "error when loading clear bitstream!"
    echo "refer to $PARTIALLOGFILE for more details!"
    exit 2
fi
sleep 0.5

#mcap partial bit
echo "load partial bin file into device ..." >> $PARTIALLOGFILE
$MCAPBINDIR/mcap -x 0x9038 -p $PARTIALBIN >> $PARTIALLOGFILE 2>&1
done1=`cat $PARTIALLOGFILE | grep  "FPGA Configuration Done" | wc -l`
if [[ $done1 == 1 ]]; then
    echo "OK loading pr region bin! ..."
else
    echo "error when loading pr region bitstream!"
    echo "refer to $PARTIALLOGFILE for more details!"
    exit 2
fi
sleep 0.5

#unset decouple reg
echo "unset decouple..." >> $REGLOGFILE
$REGBIN 0 $((0*1024+8)) 0 >> $REGLOGFILE 2>&1
if [[ $? == 0 ]]; then
    echo "OK unset decouple! ..."
else
    echo "error when removing decouple!"
    echo "refer to $REGLOGFILE for more details!"
    exit 2
fi
sleep 0.5

#soft reset rp_bd
echo "set soft reset..." >> $REGLOGFILE
$REGBIN 0 $((0*1024+16)) 0 >> $REGLOGFILE 2>&1
if [[ $? == 0 ]]; then
    echo "OK soft reset rp_bd ..."
else
    echo "error when soft reset rp_bd!"
    echo "refer to $REGLOGFILE for more details!"
    exit 2
fi
sleep 0.5

echo "successfully load custom bitstream!"
echo "partial clear bin: ${CLEARBIN}"
echo "partial bin: ${PARTIALBIN}"

rm -rf ${LASTOPDIR}/*_clear.bin
partialbin_prestr=${PARTIALBIN%.bin}
clearbin_suffix="_clear.bin"
partialbin_dir=$(cd ${PARTIALBIN%/*}; pwd)
currclearbin=${partialbin_prestr}${clearbin_suffix}
date > $LASTOPLOGFILE
echo "successfully load ${partialbin_dir}/${PARTIALBIN##*/} !" >> $LASTOPLOGFILE 
if [ -f $currclearbin ]; then
    echo "found clear bin ${currclearbin##*/} in the current partial bin file's directory"
    echo "found clear bin ${currclearbin##*/} in the same directory" >> $LASTOPLOGFILE
    cp $currclearbin $LASTOPDIR
    if [[ $? != 0 ]]; then
        echo "[warning]fail to copy bin ${currclearbin##*/} into 'last_clear_bin' directory"
        echo "[warning]fail to copy bin ${currclearbin##*/} into 'last_clear_bin' directory" >> $LASTOPLOGFILE
    else
        echo "copy bin ${currclearbin##*/} into 'last_clear_bin' directory"
        echo "copy bin ${currclearbin##*/} into 'last_clear_bin' directory" >> $LASTOPLOGFILE
    fi
else
    echo "[warning]cannot find clear bin ${currclearbin##*/} in the current partial bin file's directory"
    echo "[warning]cannot find clear bin ${currclearbin##*/} in the same directory" >> $LASTOPLOGFILE
fi
 
exit 0
