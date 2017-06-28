# These paths need to be updated to match your environment
set projName myProj
set projDir "./projDir"
set tempDir "./tempDir"
set scriptDir "./scripts"
set commonDir "../../common_files"
set usrDir "../usr_files"

set synthDir   $projDir/Synth
set implDir    $projDir/Implement
set bitDir     $projDir/Bitstreams
set runSummary $projDir/run_summary.log
set tclFiles   [list ./scripts/include.tcl]

# Add additional update versions as required by your application.
# NOTE: If known, the most complex update version of your design should be
# Update1. This will improve the timing results for subsequent updates
# versions. If your update versions are not defined ahead of time this can
# be ignored. The most complex update version can be different than the
# version loaded into flash.
set updateVer1Name   ver1
# Additional updates should be added as needed.
set updateVer2Name   ver2

# PCIe Example design information. This should be updated to match
# your design.
set part             xcku115-flvf1924-2-e
set topModuleName    my_top
set updateTopFile    $commonDir/hdl/rp_wrapper.v
set updateModuleName rp_wrapper
set updateInstName   rp_i

# Other variables.
# The sandbox variable should point to locally built IPs if needed.
set rtfSandbox $usrDir/usr_ip_resposity
set usrRtlPath $usrDir/usr_rtl
set usrXdcPath $usrDir/usr_xdc
set usrIPPath  $usrDir/usr_ip
set usrIncPath $usrDir/include

# Use DDR Channel Setting
set USE_DDR4_C0 0
set USE_DDR4_C1 0
set USE_DDR4_C2 0
set USE_DDR4_C3 0
# Use AXI mig core
set USE_AXI_DDR 1
