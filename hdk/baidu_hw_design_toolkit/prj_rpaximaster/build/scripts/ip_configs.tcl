# Add the debug bridge IP that will be added to the PR region
create_ip -name debug_bridge -vendor xilinx.com -library ip -module_name pr_region_dbg_bridge
set_property -dict [list \
    CONFIG.C_DEBUG_MODE {1} \
] [get_ips pr_region_dbg_bridge]
# Disable OOC for this module.
set_property generate_synth_checkpoint false [get_files  $projDir/${projName}.srcs/sources_1/ip/pr_region_dbg_bridge/pr_region_dbg_bridge.xci]

