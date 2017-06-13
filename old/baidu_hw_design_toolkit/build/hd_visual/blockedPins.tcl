 set mypins [get_site_pins { \
 SLICE_X99Y120/C_I \
 SLICE_X100Y120/EX \
 SLICE_X100Y120/E_I \
 SLICE_X100Y120/G_I \
 SLICE_X101Y120/GX \
 SLICE_X101Y120/G_I \
 SLICE_X102Y120/C_I \
}] 
select_objects -add $mypins 
