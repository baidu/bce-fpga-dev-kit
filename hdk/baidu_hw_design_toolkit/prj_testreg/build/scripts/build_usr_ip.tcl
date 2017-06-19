# Setup the variables and settings needed for the project.
source scripts/step_00_setup.tcl

# Create the project
puts "INFO: Creating Project: Part = $part"
create_project -force $projName $tempDir -part $part

# Add the xci file in usr_ip and generate IP core files
set xcifile [split [exec find $usrDir/usr_ip | grep xci]]
for {set a 0} {$a < [llength $xcifile]} {incr a} {
   read_ip [lindex $xcifile $a]
   generate_target all [get_files [lindex $xcifile $a]]
   #export_ip_user_files -of_objects [get_files [lindex $xcifile $a]] -sync -force -quiet
}
