# Setup the variables and settings needed for the project.
source scripts/step_00_setup.tcl

# Create the project
puts "INFO: Creating your rp Project: Part = $part"
create_project -force $projName $projDir -part $part

# Set the rtf Sandbox if needed.
if { $rtfSandbox != "none" } {
  # Set the IP path to your local sandbox build and rebuild the IP catalog
  puts "INFO: RTF Sandbox = ${rtfSandbox}"
  set_property ip_repo_paths  ${rtfSandbox} [current_fileset]
  update_ip_catalog -rebuild
}

#mkdir
if { ![ file isdirectory $usrDir/include ] }  {
    exec mkdir $usrDir/include
}

if { ![ file isdirectory $usrDir/usr_xdc ] }  {
    exec mkdir $usrDir/usr_xdc
}

if { ![ file isdirectory $usrDir/usr_rtl ] }  {
    exec mkdir $usrDir/usr_rtl
}

# Genearte Mig
source $scriptDir/ddr_define.tcl
if { ($USE_DDR4_C0 == 1) || ($USE_DDR4_C1 == 1) || ($USE_DDR4_C2 == 1) || ($USE_DDR4_C3 == 1)} {
    if {$USE_AXI_DDR == 1} {
       source $scriptDir/rp_mig_bd.tcl
       validate_bd_design
       save_bd_design
       close_bd_design [get_bd_designs rp_mig_bd]

       # Set the appropriate OOC Synthesis settings for the .bd
       set_property GENERATE_SYNTH_CHECKPOINT 0 [get_files $projDir/${projName}.srcs/sources_1/bd/rp_mig_bd/rp_mig_bd.bd]
       generate_target all [get_files $projDir/${projName}.srcs/sources_1/bd/rp_mig_bd/rp_mig_bd.bd]
       set_property is_locked true [get_files $projDir/${projName}.srcs/sources_1/bd/rp_mig_bd/rp_mig_bd.bd]
    } else {
       set migxcifile $commonDir/ip/ddr4_0/ddr4_0.xci
       read_ip $migxcifile
       set_property GENERATE_SYNTH_CHECKPOINT 0 [get_files $migxcifile]
       generate_target all [get_files $migxcifile]
       #export_ip_user_files -of_objects [get_files $migxcifile] -sync -force -quiet
    }
}

# Add source files and IPs to the project.
# Add the top-level source files.
add_files -norecurse $commonDir/hdl
add_files -norecurse $usrRtlPath
add_files -norecurse $usrIncPath

add_file -fileset constrs_1 $commonDir/constraints/rp_wrapper_ooc.xdc
set_property PROCESSING_ORDER EARLY [get_files rp_wrapper_ooc.xdc]
set_property USED_IN {synthesis implementation OUT_OF_CONTEXT} [get_files rp_wrapper_ooc.xdc]

# Add the xci file in usr_ip and generate IP core files
set xcifile [split [exec find $usrDir/usr_ip | grep xci]]
for {set a 0} {$a < [llength $xcifile]} {incr a} {
   read_ip [lindex $xcifile $a]
   set_property generate_synth_checkpoint false [get_files [lindex $xcifile $a]]
   generate_target all [get_files [lindex $xcifile $a]]
   export_ip_user_files -of_objects [get_files [lindex $xcifile $a]] -sync -force -quiet
   #export_simulation -of_objects [get_files [lindex $xcifile $a]]
}

# Add the debug bridge IP that will be added to the PR region
source $scriptDir/ip_configs.tcl
generate_target all [get_files  $projDir/${projName}.srcs/sources_1/ip/pr_region_dbg_bridge/pr_region_dbg_bridge.xci]
export_ip_user_files -of_objects [get_files  $projDir/${projName}.srcs/sources_1/ip/pr_region_dbg_bridge/pr_region_dbg_bridge.xci] -sync -force -quiet
#export_simulation -of_objects [get_files  $projDir/${projName}.srcs/sources_1/ip/pr_region_dbg_bridge/pr_region_dbg_bridge.xci]

# Error and Message Reporting
set warningCount [get_msg_config -severity {Warning} -count]
set criticalCount [get_msg_config -severity {Critical Warning} -count]
set errorCount [get_msg_config -severity {Error} -count]
puts "# HD INFO: Design creation completed with $errorCount Errors, $criticalCount Critical Warnings, and $warningCount Warnings.\n"
set fp [open $runSummary a]
puts $fp "Design creation completed with $errorCount Errors, $criticalCount Critical Warnings, and $warningCount Warnings at [clock format [clock seconds]]."
close $fp

