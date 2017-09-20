add_cells_to_pblock [get_pblocks pblock_die_1] [get_cells -quiet rp_i/rp_bd_i/axi_register_slice_0]
add_cells_to_pblock [get_pblocks pblock_die_1] [get_cells -quiet rp_i/rp_bd_i/axi_register_slice_1]

add_cells_to_pblock [get_pblocks pblock_die_0] [get_cells -quiet rp_i/rp_bd_i/axi_interconnect_1]
add_cells_to_pblock [get_pblocks pblock_die_0] [get_cells -quiet rp_i/rp_bd_i/axi_register_slice_3]
