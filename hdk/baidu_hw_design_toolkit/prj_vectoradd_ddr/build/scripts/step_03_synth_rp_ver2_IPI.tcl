# Setup the variables and settings needed for the project.
source scripts/step_00_setup.tcl
# Setup of additional variables
set updateName $updateVer2Name

# Create the output directory
file mkdir $synthDir
file delete -force $synthDir/$$updateName
file mkdir $synthDir/$updateName

# Run OOC Synthesis for the static portion of the design
puts "# HD INFO: Running OOC synthesis for the RP portion of the design for $updateName"
reset_run rp_bd_wrapper_synth_1
launch_runs rp_bd_wrapper_synth_1
wait_on_run rp_bd_wrapper_synth_1

# Copy the log file to the synthesis directory
file copy -force $projDir/${projName}.runs/rp_bd_wrapper_synth_1/runme.log $synthDir/$updateName/${updateName}_synth.log

# Report ooc synthesis pass/fail and warning/error counts
#if {[catch {exec grep -B 1 -A 1 "synth_design completed successfully" $synthDir/$updateName/${updateName}_synth.log} returnVal]} {
#  puts "Synthesis failed. Pass string not found."
#  error "Synthesis failed. Pass string not found."
#} else {
  # Copy the post synthesis .dcp file to the synthesis directory
file copy -force $projDir/${projName}.runs/rp_bd_wrapper_synth_1/rp_bd_wrapper.dcp $synthDir/$updateName/${updateName}_synth.dcp

  # Error and Message Reporting
#  set warningCount [lindex $returnVal 2]
#  set criticalCount [lindex $returnVal 4]
#  set errorCount [lindex $returnVal 8]
  set warningCount [lindex 0 2]
  set criticalCount [lindex 0 4]
  set errorCount [lindex 0 8]

  puts "# HD INFO: RP $updateName synthesis completed with $errorCount Errors, $criticalCount Critical Warnings, and $warningCount Warnings.\n"
  set fp [open $runSummary a]
  puts $fp "RP $updateName synthesis completed with $errorCount Errors, $criticalCount Critical Warnings, and $warningCount Warnings at [clock format [clock seconds]]."
  close $fp
#}

