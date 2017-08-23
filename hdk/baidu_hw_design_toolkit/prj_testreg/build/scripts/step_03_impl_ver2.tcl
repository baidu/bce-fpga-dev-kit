source scripts/step_00_setup.tcl
# Setup of additional variables
set updateName $updateVer2Name

# Create the output directory and remove previously generated files.
file mkdir $implDir
file delete -force $implDir/$updateName
file mkdir $implDir/$updateName

puts "# HD INFO: Running implementation for configuration $updateName"

# Create an in-memory project
create_project -in_memory -part $part
set_param chipscope.enablePRFlow true
set_param bitstream.enablePR 4123
#set_param chipscope.enableXVCFlowDRC false

# Read in the placed, routed, and LOC'ed static netlist
add_files $commonDir/static_fix_dcp/${topModuleName}_static_routed.dcp
link_design -mode default -part $part -top $topModuleName

# Read in this version of the update checkpoint and associated constraints.
set_property HD.RECONFIGURABLE 1 [get_cells $updateInstName]
read_checkpoint -cell $updateInstName $synthDir/$updateName/${updateName}_synth.dcp -strict
# Read in the constraints for the new RP if needed
foreach xdcfile [glob -nocomplain $usrXdcPath/*] {
    read_xdc -quiet $xdcfile
}

# Run the desired implementation steps. Additional implementation steps and
# options can be added here as desired. A checkpoint is written after each
# step for convenience.
opt_design > $implDir/$updateName/${topModuleName}_opt_design.log
write_checkpoint -force $implDir/$updateName/${topModuleName}_opt_design.dcp
place_design > $implDir/$updateName/${topModuleName}_place_design.log
write_checkpoint -force $implDir/$updateName/${topModuleName}_place_design.dcp
phys_opt_design > $implDir/$updateName/${topModuleName}_phy_opt_design.log
write_checkpoint -force $implDir/$updateName/${topModuleName}_phy_opt_design.dcp
route_design > $implDir/$updateName/${topModuleName}_route_design.log
write_checkpoint -force $implDir/$updateName/${topModuleName}_route_design.dcp

# Generate a timing report for convenience.
report_timing_summary -warn_on_violation -file $implDir/$updateName/report_timing_summary.rpt
report_io -file $implDir/$updateName/report_io_summary.rpt

# Create the output directory and remove previously generated files.
file mkdir $bitDir
file delete -force $bitDir/$updateName
file mkdir $bitDir/$updateName
# Generate bitfiles
write_bitstream -force -bin_file -file $bitDir/$updateName/${updateName}.bit > $bitDir/$updateName/${updateName}_write_bitstream.log
write_debug_probes $bitDir/$updateName/${updateName}.ltx
exec rm -rf $bitDir/$updateName/${updateName}.bit 
exec rm -rf $bitDir/$updateName/${updateName}.bin 
exec rm -rf $bitDir/$updateName/${updateName}.ltx 

#generate meta_file for target_file
set target_file1 $bitDir/$updateName/${updateName}_pr_region_partial_clear.bin
set target_file2 $implDir/$updateName/${topModuleName}_route_design.dcp
set target_file3 $commonDir/static_fix_dcp/${topModuleName}_static_routed.dcp
#get md5 of target_file
set md5_result1 [lindex [exec md5sum $target_file1] 0]
set md5_result2 [lindex [exec md5sum $target_file2] 0]
set md5_result3 [lindex [exec md5sum $target_file3] 0]
#get time
set timestamp [exec date "+%Y-%m-%d %H:%M:%S"]
#write meta_file
set meta_file  $bitDir/$updateName/${updateName}_pr_region_partial_clear.bin.meta
set fp_define [open $meta_file w]
puts $fp_define "{\"md5sum\":\"${md5_result1}\",\"timestamp\":\"${timestamp}\",\"my_top_route_design_dcp_md5sum\":\"${md5_result2}\",\"my_top_static_routed_dcp_md5sum\":\"${md5_result3}\"}"
close $fp_define
#generate meta_file for target_file
set target_file1 $bitDir/$updateName/${updateName}_pr_region_partial.bin
set meta_file  $bitDir/$updateName/${updateName}_pr_region_partial.bin.meta
#get md5 of target_file
set md5_result1 [lindex [exec md5sum $target_file1] 0]
#get time
set timestamp [exec date "+%Y-%m-%d %H:%M:%S"]
#write meta_file
set fp_define [open $meta_file w]
puts $fp_define "{\"md5sum\":\"${md5_result1}\",\"timestamp\":\"${timestamp}\",\"my_top_route_design_dcp_md5sum\":\"${md5_result2}\",\"my_top_static_routed_dcp_md5sum\":\"${md5_result3}\"}"
close $fp_define

# Error and Message Reporting
set warningCount [get_msg_config -severity {Warning} -count]
set criticalCount [get_msg_config -severity {Critical Warning} -count]
set errorCount [get_msg_config -severity {Error} -count]
puts "# HD INFO: Implementation for $updateName completed with $errorCount Errors, $criticalCount Critical Warnings, and $warningCount Warnings.\n"
set fp [open $runSummary a]
puts $fp "Implementation for $updateName completed with $errorCount Errors, $criticalCount Critical Warnings, and $warningCount Warnings at [clock format [clock seconds]]."
close $fp

# close the in-memory project.
close_project


