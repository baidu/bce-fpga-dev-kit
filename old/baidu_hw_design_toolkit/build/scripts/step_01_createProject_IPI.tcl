# Setup the variables and settings needed for the project.
source scripts/step_00_setup.tcl

# Create the project
puts "INFO: Creating Project: Part = $part"
create_project -force $projName $projDir -part $part
# Set the rtf Sandbox if needed.
if { $rtfSandbox != "none" } {
  # Set the IP path to your local sandbox build and rebuild the IP catalog
  puts "INFO: RTF Sandbox = ${rtfSandbox}"
  set_property ip_repo_paths  ${rtfSandbox} [current_fileset]
  update_ip_catalog -rebuild
}

# Add source files and IPs to the project.
# Add the top-level source files.
add_files -norecurse $commonDir/hdl
add_file $usrRtlPath/usr_counter.v

foreach xdcfile [glob -nocomplain $usrXdcPath/*] {
    add_files -fileset constrs_1 -norecurse $xdcfile
}
# Add additional design IPs
source $scriptDir/ip_configs.tcl

# Add the PR region .bd design and associated wrapper. This file can be updated by
# modifying the .bd design and using the following command to overwrite the existing
# rp_bd.tcl file. 
#     - write_bd_tcl -force -no_ip_version ./scripts/rp_bd.tcl
source $scriptDir/rp_bd.tcl
validate_bd_design
save_bd_design
close_bd_design [get_bd_designs rp_bd]
# Set the appropriate OOC Synthesis settings for the .bd
set_property synth_checkpoint_mode None [get_files  $projDir/${projName}.srcs/sources_1/bd/rp_bd/rp_bd.bd]

# Genearte Mig
source $scriptDir/ddr_init.tcl

# Set the PR region as OOC
create_fileset -blockset -define_from rp_bd_wrapper rp_bd_wrapper
add_file -fileset rp_bd_wrapper $commonDir/constraints/rp_bd_wrapper_ooc.xdc

# Error and Message Reporting
set warningCount [get_msg_config -severity {Warning} -count]
set criticalCount [get_msg_config -severity {Critical Warning} -count]
set errorCount [get_msg_config -severity {Error} -count]
puts "# HD INFO: Design creation completed with $errorCount Errors, $criticalCount Critical Warnings, and $warningCount Warnings.\n"
set fp [open $runSummary a]
puts $fp "Design creation completed with $errorCount Errors, $criticalCount Critical Warnings, and $warningCount Warnings at [clock format [clock seconds]]."
close $fp

