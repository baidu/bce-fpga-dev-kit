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

# Genearte DDR define
source $scriptDir/ddr_define.tcl

# Add source files and IPs to the project.
# Add the top-level source files.
add_files -norecurse $commonDir/hdl
add_files -norecurse $usrIncPath
add_files -norecurse $usrRtlPath
add_files -norecurse $commonDir/constraints

foreach xdcfile [glob -nocomplain $usrXdcPath/*] {
    add_files -fileset constrs_1 -norecurse $xdcfile
}
# Add additional design IPs
source $scriptDir/ip_configs.tcl

# Genearte Mig
if {($USE_DDR4_C0 == 1) || ($USE_DDR4_C1 == 1) || ($USE_DDR4_C2 == 1) || ($USE_DDR4_C3 == 1)} {
   if {$USE_AXI_DDR == 1} {
      source $scriptDir/rp_mig_bd.tcl
      validate_bd_design
      save_bd_design
      close_bd_design [get_bd_designs rp_mig_bd]

      # Set the appropriate OOC Synthesis settings for the .bd
      set_property synth_checkpoint_mode None [get_files  $projDir/${projName}.srcs/sources_1/bd/rp_mig_bd/rp_mig_bd.bd]
   } else {
      set migxcifile $commonDir/ip/ddr4_0/ddr4_0.xci
      read_ip $migxcifile
      set_property generate_synth_checkpoint false [get_files $migxcifile]
      generate_target all [get_files $migxcifile]
      export_ip_user_files -of_objects $migxcifile -sync -force -quiet
   }
}

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

# Set the PR region as OOC
create_fileset -blockset -define_from rp_wrapper rp_wrapper
add_file -fileset rp_wrapper $commonDir/constraints/rp_wrapper_ooc.xdc
set_property PROCESSING_ORDER EARLY [get_files rp_wrapper_ooc.xdc]
set_property USED_IN {synthesis implementation OUT_OF_CONTEXT} [get_files rp_wrapper_ooc.xdc]
update_compile_order -fileset rp_wrapper

# Error and Message Reporting
set warningCount [get_msg_config -severity {Warning} -count]
set criticalCount [get_msg_config -severity {Critical Warning} -count]
set errorCount [get_msg_config -severity {Error} -count]
puts "# HD INFO: Design creation completed with $errorCount Errors, $criticalCount Critical Warnings, and $warningCount Warnings.\n"
set fp [open $runSummary a]
puts $fp "Design creation completed with $errorCount Errors, $criticalCount Critical Warnings, and $warningCount Warnings at [clock format [clock seconds]]."
close $fp

