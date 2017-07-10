create_pblock pblock_die_1
resize_pblock [get_pblocks pblock_die_1] -add { CLOCKREGION_X0Y5:CLOCKREGION_X5Y9 }
resize_pblock pblock_die_1 -remove {IOB_X2Y312:IOB_X2Y336}
add_cells_to_pblock [get_pblocks pblock_die_1] [get_cells -quiet rp_i/rp_bd_i/axi_register_slice_0]
add_cells_to_pblock [get_pblocks pblock_die_1] [get_cells -quiet rp_i/rp_bd_i/axi_register_slice_1]
set_property PARENT pr_region [get_pblocks pblock_die_1]

create_pblock pblock_die_0
resize_pblock [get_pblocks pblock_die_0] -add { \
    CLOCKREGION_X0Y0:CLOCKREGION_X3Y4 \
    CLOCKREGION_X4Y2:CLOCKREGION_X4Y4 \
}
add_cells_to_pblock [get_pblocks pblock_die_0] [get_cells -quiet rp_i/rp_bd_i/axi_interconnect_1]
set_property PARENT pr_region [get_pblocks pblock_die_0]
