source ./scripts/step_00_setup.tcl

set refDir $commonDir/template/ref_xdc
set usrXdcDir $usrDir/usr_xdc
set ddrIncFile $usrDir/include/rp_if_define.vh
set comment "#"
set fp_define [open $ddrIncFile w]
exec rm -f $usrXdcDir/ddr_c0.xdc
exec rm -f $usrXdcDir/ddr_c1.xdc
exec rm -f $usrXdcDir/ddr_c2.xdc
exec rm -f $usrXdcDir/ddr_c3.xdc

if { ($USE_DDR4_C0 == 1) || ($USE_DDR4_C1 == 1) || ($USE_DDR4_C2 == 1) || ($USE_DDR4_C3 == 1)} {
    puts $fp_define "`define USE_DDR 1"
}
if { $USE_DDR4_C0 == 1} {
    exec cp $refDir/ddr_c0.xdc $usrXdcDir
    puts $fp_define "`define USE_DDR4_C0 1"
}
if { $USE_DDR4_C1 == 1} {
    exec cp $refDir/ddr_c1.xdc $usrXdcDir
    puts $fp_define "`define USE_DDR4_C1 1"
}
if { $USE_DDR4_C2 == 1} {
    exec cp $refDir/ddr_c2.xdc $usrXdcDir
    puts $fp_define "`define USE_DDR4_C2 1"
}
if { $USE_DDR4_C3 == 1} {
    exec cp $refDir/ddr_c3.xdc $usrXdcDir
    puts $fp_define "`define USE_DDR4_C3 1"
}
if { $USE_RP_AXI_MASTER == 1} {
    puts $fp_define "`define RP_AXI_MASTER 1"
}
if { $USE_AXI_DDR == 1} {
    puts $fp_define "`define AXI_DDR 1"
} else {
    puts $fp_define "`define APP_DDR 1"
}
close $fp_define
