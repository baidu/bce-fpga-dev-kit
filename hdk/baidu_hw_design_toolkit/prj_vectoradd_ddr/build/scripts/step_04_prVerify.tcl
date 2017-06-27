# Setup the variables and settings needed for the project.
source scripts/step_00_setup.tcl
# Setup of additional variables, add additional configurations if desired.
set update_checkpoints [list \
    $implDir/$updateVer2Name/${topModuleName}_route_design.dcp \
]

# Run PR verify
puts "# HD INFO: Running pr_verify"
pr_verify -initial $commonDir/static_fix_dcp/${topModuleName}_route_design.dcp -additional $update_checkpoints > $bitDir/${topModuleName}_pr_verify.log

# Error and Message Reporting
set warningCount [get_msg_config -severity {Warning} -count]
set criticalCount [get_msg_config -severity {Critical Warning} -count]
set errorCount [get_msg_config -severity {Error} -count]
puts "# HD INFO: pr_verify completed with $errorCount Errors, $criticalCount Critical Warnings, and $warningCount Warnings.\n"
set fp [open $runSummary a]
puts $fp "pr_verify completed with $errorCount Errors, $criticalCount Critical Warnings, and $warningCount Warnings at [clock format [clock seconds]]."
close $fp

# close the in-memory project.
close_project


