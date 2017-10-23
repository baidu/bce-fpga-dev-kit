# Setup the variables and settings needed for the project.
source scripts/step_00_setup.tcl
source $usrDir/sim/sim_vivado/sim_type.tcl
# Create the project
puts "INFO: Creating Project: Part = $part"
create_project -force $projName $usrDir/sim/sim_vivado/ -part $part
source scripts/ddr_define.tcl
if { $FAST_SIM == 1 } {
    set fp_define [open $ddrIncFile a]
    puts $fp_define "`define FAST_SIM"
    close $fp_define
}
if { $rtfSandbox != "none" } {
  # Set the IP path to your local sandbox build and rebuild the IP catalog
  puts "INFO: RTF Sandbox = ${rtfSandbox}"
  set_property ip_repo_paths  ${rtfSandbox} [current_fileset]
  update_ip_catalog -rebuild
}
# Add source files and IPs to the project.
# Add the top-level source files.
add_files -norecurse $commonDir/hdl
add_files -norecurse $usrIncPath
add_files -norecurse $commonDir/constraints

if { $IPI == 1 } {
    source $scriptDir/rp_bd.tcl
    validate_bd_design
    save_bd_design
    close_bd_design [get_bd_designs rp_bd]
    set_property synth_checkpoint_mode None [get_files  $usrDir/sim/sim_vivado/${projName}.srcs/sources_1/bd/rp_bd/rp_bd.bd]
} else {
    add_files  $usrRtlPath
    set xcifile [split [exec find $usrDir/usr_ip | grep xci]]
    for {set a 0} {$a < [llength $xcifile]} {incr a} {
        read_ip [lindex $xcifile $a]
    generate_target simulation [get_files [lindex $xcifile $a]]
}
}
source $commonDir/template/ref_script/sim_env.tcl
set_property target_simulator $SIMULATOR [current_project]
if { $SIMULATOR == "xsim" } {
	set_property -name {xsim.compile.xvlog.more_options} -value "$DEFINE_PARA" -objects [get_filesets sim_1]
} else {
	set_property -name {questa.compile.vlog.more_options} -value "$DEFINE_PARA" -objects [get_filesets sim_1]
}
launch_simulation -scripts_only
export_simulation  -directory "$usrDir/sim/sim_vivado" -lib_map_path $LIB_PATH -simulator $SIMULATOR  -ip_user_files_dir "$usrDir/sim/sim_vivado/myProj.ip_user_files" -ipstatic_source_dir "$usrDir/sim/sim_vivado/myProj.ip_user_files/ipstatic" -use_ip_compiled_libs
exit

