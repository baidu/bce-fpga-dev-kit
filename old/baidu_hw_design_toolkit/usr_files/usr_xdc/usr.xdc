set_false_path -from [get_pins {rp_bd_i/rp_bd_i/usr_counter_0/inst/o_count_reg[*]/C}]

#set_property HD.RECONFIGURABLE 1 [get_cells rp_bd_i/rp_bd_i/axislave_cu*]
#create_pblock axislave_cu
#add_cells_to_pblock axislave_cu [get_cells rp_bd_i/rp_bd_i/axislave_cu*]
#resize_pblock axislave_cu -add { CLOCKREGION_X4Y2:CLOCKREGION_X4Y4 }
