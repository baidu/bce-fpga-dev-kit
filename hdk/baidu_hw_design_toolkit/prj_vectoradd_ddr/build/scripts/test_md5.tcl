source ./scripts/step_00_setup.tcl

# Setup of additional variables
set updateName $updateVer2Name

#generate meta_file for target_file
set target_file $bitDir/$updateName/${updateName}_pr_region_partial_clear.bin
set meta_file  $bitDir/$updateName/${updateName}_pr_region_partial_clear.bin.meta

#get md5 of target_file
set md5_result [lindex [exec md5sum $target_file] 0]
#get time
set timestamp [exec date "+%Y-%m-%d %H:%M:%S"]

#write meta_file
set fp_define [open $meta_file w]
puts $fp_define "{\"md5sum\":${md5_result},\"timestamp\":${timestamp}}"
close $fp_define

#generate meta_file for target_file
set target_file $bitDir/$updateName/${updateName}_pr_region_partial.bin
set meta_file  $bitDir/$updateName/${updateName}_pr_region_partial.bin.meta

#get md5 of target_file
set md5_result [lindex [exec md5sum $target_file] 0]
#get time
set timestamp [exec date "+%Y-%m-%d %H:%M:%S"]

#write meta_file
set fp_define [open $meta_file w]
puts $fp_define "{\"md5sum\":${md5_result},\"timestamp\":${timestamp}}"
close $fp_define
