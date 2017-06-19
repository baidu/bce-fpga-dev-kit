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
synth_design -top rp_bd_wrapper -part $part -mode out_of_context  -keep_equivalent_registers -flatten_hierarchy rebuilt

write_checkpoint -force $synthDir/$updateName/${updateName}_synth.dcp

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

