# Setup the variables and settings needed for the project.
source scripts/step_00_setup.tcl

# Create the project
puts "INFO: Creating Project: Part = $part"
create_project -force $projName $tempDir -part $part
# Set the rtf Sandbox if needed.
if { $rtfSandbox != "none" } {
  # Set the IP path to your local sandbox build and rebuild the IP catalog
  puts "INFO: RTF Sandbox = ${rtfSandbox}"
  set_property ip_repo_paths  ${rtfSandbox} [current_fileset]
  update_ip_catalog -rebuild
}

# Add source files and IPs to the project.
# Add the top-level source files.
if { ![ file isdirectory $usrRtlPath ] }  {
    exec mkdir $usrRtlPath
}
add_files $usrRtlPath
foreach xdcfile [glob -nocomplain $usrXdcPath/*] {
    add_files -fileset constrs_1 -norecurse $xdcfile
}

# Add the PR region .bd design and associated wrapper. This file can be updated by
# modifying the .bd design and using the following command to overwrite the existing
# rp_bd.tcl file.
#     - write_bd_tcl -force -no_ip_version ./scripts/rp_bd.tcl
source $scriptDir/rp_bd.tcl

generate_target simulation [get_files  $tempDir/$projName.srcs/sources_1/bd/rp_bd/rp_bd.bd]
