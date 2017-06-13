create_pblock axislave_cu
add_cells_to_pblock axislave_cu [get_cells *]
resize_pblock axislave_cu -add { CLOCKREGION_X4Y2:CLOCKREGION_X4Y4 }
