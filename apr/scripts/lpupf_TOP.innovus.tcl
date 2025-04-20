# Create the initial floorplan, power domains, and power grids. 
set top_design lpupf_TOP
set hack_lef_dir /u/bcruik2/hacked_lefs
set init_lef_file "../../cadence_cap_tech/tech.lef $hack_lef_dir/saed32nm_hvt_1p9m.lef"
set init_design_nettlist_type Verilog
set init_verilog ../../syn/outputs/lpupf_TOP.genus.vg
set init_top_cell $top_design
set init_pwr_net {VDD_TOPH VDD_AH VDD_BH VDD_CL VDD_DL}
set init_gnd_net VSS
set power_intent_file "../../syn/outputs/lpupf_TOP.genus.upf.upf"
#Has standard cell libraries, level shifters, and power switches. 
set link_library_worst "/pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_rvt/db_nldm/saed32rvt_ss0p95vn40c.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_rvt/db_nldm/saed32rvt_ss0p75vn40c.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_rvt/db_nldm/saed32rvt_pg_ss0p95vn40c.lib"
#set init_lef_file "/u/capatina/ASIC/PSU_RTL2GDS/cadence_cap_tech/tech.lef /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_rvt/lef/saed32nm_rvt_1p9m.lef "
set library $link_library_worst

# slow = worst = max = setup
# fast = best = min = hold

#set init_mmmc_file mmmc.tcl

read_mmmc ../../constraints/lpupf_TOP.mmmc.tcl


read_physical -lef $init_lef_file
read_netlist $init_verilog

init_design

#defIn ../../syn/outputs/${top_design}.genus.vg

read_power_intent -1801 ${power_intent_file} 
commit_power_intent -verbose 

create_floorplan -site unit -core_size {125 125 25 25 25 25}

update_power_domain PD_MOD_AH -power_extend_edges {10 0 0 10} -gap_sides {10 10 10 10} -box 100 130 135 105
update_power_domain PD_MOD_BH -power_extend_edges {10 0 10 0} -gap_sides {10 10 10 10} -box 105 75 135 40
update_power_domain PD_MOD_CL -power_extend_edges {10 10 0 10} -gap_sides {10 10 10 10} -box 40 135 75 105

edit_pin -edge 3 -pin [get_db [get_ports *] .name ] -layer M6 -spread_direction counterclockwise -spread_type start -offset_start 68 -spacing 4 -unit micron -fixed_pin 1
# Assigns voltage area on the chip.
plan_design 
#plan_design -constraints_file ../../constraints/plan_design.sdc

connect_global_net VSS -type pgpin -pin VSS -all
  

# power switch and isolation connection. 
#connect_global_net VDD -type pgpin -pin VDDG -inst_base_name *HEADX2*
#connect_global_net VDD -type pgpin -pin VDDG -inst_base_name *ISO*

# Power switches are double the row height. Include -noDoubleHeightCheck
add_power_switches -power_domain PD_MOD_AH -global_switch_cell_name HEADX2_HVT -1801power_switch_rule_name SW_AH -column -horizontal_pitch 40 -no_double_height_check -checker_board
add_power_switches -power_domain PD_MOD_BH -global_switch_cell_name HEADX2_HVT -1801power_switch_rule_name SW_BH -column -horizontal_pitch 30 -no_double_height_check -checker_board
add_power_switches -power_domain PD_MOD_CL -global_switch_cell_name HEADX2_HVT -1801power_switch_rule_name SW_CL -column -horizontal_pitch 40 -no_double_height_check -checker_board

# This group should come across with UPF from Genus I think.
connect_global_net VDDH -type pgpin -pin VDD -power_domain PD_MOD_TOP -inst_base_name * 
connect_global_net VDD_AH_OUT -type pgpin -pin VDD -power_domain PD_MOD_AH -inst_base_name * -override
connect_global_net VDD_BH_OUT -type pgpin -pin VDD -power_domain PD_MOD_BH -inst_base_name * -override
connect_global_net VDD_CL_OUT -type pgpin -pin VDD -power_domain PD_MOD_CL -inst_base_name * -override

#This group is necessary due to new power switches added
connect_global_net VDDH -type pgpin -pin VDDG  -power_domain PD_MOD_AH -inst_base_name *HEADX2* -override
connect_global_net VDDH -type pgpin -pin VDDG  -power_domain PD_MOD_BH -inst_base_name *HEADX2* -override
connect_global_net VDDL -type pgpin -pin VDDG  -power_domain PD_MOD_CL -inst_base_name *HEADX2* -override

# These groups should come across with UPF from Genus I think. I see them in that UPF.
foreach i [get_db [get_db insts *LSup* ] .name ] {
connect_global_net VDDL -type pgpin -pin VDDL  -single_inst $i -override
connect_global_net VDDH -type pgpin -pin VDDH  -single_inst $i -override
}
foreach i [get_db [get_db insts PD_MOD_AH_ISO* ] .name ] {
connect_global_net VDDH -type pgpin -pin VDDG  -single_inst $i -override
}
foreach i [get_db [get_db insts PD_MOD_CL_ISO* ] .name ] {
connect_global_net VDDL -type pgpin -pin VDDG  -single_inst $i -override
}


#source ../scripts/add_ports.tcl
select_obj PD_MOD_TOP
add_rings -type core_rings -nets {VDDH VDDL VSS} -layer {top M7 bottom M7 left M8 right M8} -offset 1 -width 4 -spacing 1.0 -follow core
add_stripes -nets {VDDH VDDL VSS} -direction vertical -layer M7 -width .057 -set_to_set_distance 25 -start_offset 1 -spacing 12.5 -over_power_domain 1
add_stripes -nets {VDDH VDDL VSS} -direction horizontal -layer M6 -width .059 -set_to_set_distance 25 -start_offset 1 -spacing 12.5 -over_power_domain 1

deselect_obj -all
select_obj PD_MOD_AH
# Adding a power ring for a power domain boundary:
add_rings -type block_rings -nets {VDDH VDD_AH_OUT VSS} -layer {top M7 bottom M7 left M8 right M8} -offset 1 -width 4 -spacing 1.0 -around power_domain
add_stripes -nets {VDDH VDD_AH_OUT VSS} -direction vertical -layer M7 -width .057 -set_to_set_distance 25 -start_offset 1 -spacing 12.5 -over_power_domain 1
add_stripes -nets {VDDH VDD_AH_OUT VSS} -direction horizontal -layer M6 -width .059 -set_to_set_distance 25 -start_offset 1 -spacing 12.5 -over_power_domain 1

deselect_obj -all
select_obj PD_MOD_BH
# Adding a power ring for a power domain boundary:
add_rings -type block_rings -nets {VDDH VDD_BH_OUT VSS} -layer {top M7 bottom M7 left M8 right M8} -offset 1 -width 4 -spacing 1.0 -around power_domain
add_stripes -nets {VDDH VDD_BH_OUT VSS} -direction vertical -layer M7 -width 0.057 -set_to_set_distance 25 -start_offset 1 -spacing 12.5 -over_power_domain 1
add_stripes -nets {VDDH VDD_BH_OUT VSS} -direction horizontal -layer M6 -width .059 -set_to_set_distance 25 -start_offset 1 -spacing 12.5 -over_power_domain 1

deselect_obj -all
select_obj PD_MOD_CL
# Adding a power ring for a power domain boundary:
add_rings -type block_rings -nets {VDDL VDD_CL_OUT VSS} -layer {top M7 bottom M7 left M8 right M8} -offset 1 -width 4 -spacing 1.0 -around power_domain
add_stripes -nets {VDDL VDD_CL_OUT VSS} -direction vertical -layer M7 -width 0.057 -set_to_set_distance 25 -start_offset 1 -spacing 12.5 -over_power_domain 1
add_stripes -nets {VDDL VDD_CL_OUT VSS} -direction horizontal -layer M6 -width .059 -set_to_set_distance 25 -start_offset 1 -spacing 12.5 -over_power_domain 1

deselect_obj -all


set_db add_stripes_ignore_block_check false
set_db add_stripes_break_at {block_ring outer_ring}
set_db add_stripes_route_over_rows_only false
set_db add_stripes_rows_without_stripes_only false 
set_db add_stripes_extend_to_closest_target ring 
set_db add_stripes_stop_at_last_wire_for_area false 
set_db add_stripes_partial_set_through_domain false 
set_db add_stripes_ignore_non_default_domains false 
set_db add_stripes_trim_antenna_back_to_shape none 
set_db add_stripes_spacing_type edge_to_edge 
set_db add_stripes_spacing_from_block 0 
set_db add_stripes_stripe_min_length stripe_width 
set_db add_stripes_stacked_via_top_layer MRDL 
set_db add_stripes_stacked_via_bottom_layer M1 
set_db add_stripes_via_using_exact_crossover_size false 
set_db add_stripes_split_vias false 
set_db add_stripes_orthogonal_only true 
set_db add_stripes_allow_jog {padcore_ring block_ring} 
set_db add_stripes_skip_via_on_pin {standardcell} 
set_db add_stripes_skip_via_on_wire_shape {noshape}

#place_design

# Add stripes over header cells and ground stripes over power domain.
#add_stripes -nets {VDD} -direction vertical -layer M7 -master *HEADX2* -width 2  -over_power_domain 1 -spacing 12.5 -start_offset 0 -set_to_set_distance 25 -over_pins 1
#add_stripes -nets {VSS} -direction vertical -layer M7 -master *HEADX2* -width 0.57  -over_power_domain 1 -spacing 12.5 -start_offset 10 -set_to_set_distance 25


# Adding the follow pins to moduleA domain.

route_special -nets {VDDH VDDL } -allow_layer_change 1 -allow_jogging 1 -core_pin_target {none} -power_domains PD_MOD_TOP -block_pin_target {nearest_target} -connect {block_pin pad_pin pad_ring core_pin floating_stripe secondary_power_pin} -block_pin use_lef -secondary_pin_net {VDD_AH}

route_special -nets {VSS} -allow_layer_change 1 -allow_jogging 1 -core_pin_target {stripe ring block_ring} -power_domains PD_MOD_TOP -block_pin_target {nearest_target} -connect {block_pin pad_pin pad_ring core_pin floating_stripe} 

route_special -nets {VDD_AH_OUT } -allow_layer_change 1 -allow_jogging 1 -core_pin_target {none} -power_domains PD_MOD_AH -block_pin_target {nearest_target} -connect {block_pin pad_pin pad_ring core_pin floating_stripe secondary_power_pin} -block_pin use_lef -secondary_pin_net {VDDH}

route_special -nets {VSS} -allow_layer_change 1 -allow_jogging 1 -core_pin_target {stripe ring block_ring} -power_domains PD_MOD_AH -block_pin_target {nearest_target} -connect {block_pin pad_pin pad_ring core_pin floating_stripe} 
# Connecting the power switch input supply pins.
#route_special -nets {VDD} -allow_layer_change 1 -allow_jogging 1 -core_pin_target {stripe} -power_domains PD_CPU -block_pin_target {nearest_target} -connect {secondary_power_pin} 

deselect_obj -all

# moduleB follow pins.
route_special -nets {VDD_BH_OUT } -allow_layer_change 1 -allow_jogging 1 -core_pin_target {none} -power_domains PD_MOD_BH -block_pin_target {nearest_target} -connect {block_pin pad_pin pad_ring core_pin floating_stripe secondary_power_pin} -block_pin use_lef -secondary_pin_net {VDDH}

route_special -nets {VSS} -allow_layer_change 1 -allow_jogging 1 -core_pin_target {stripe ring block_ring} -power_domains PD_MOD_BH -block_pin_target {nearest_target} -connect {block_pin pad_pin pad_ring core_pin floating_stripe} 
 

# moduleC follow pins.

route_special -nets {VDD_CL_OUT } -allow_layer_change 1 -allow_jogging 1 -core_pin_target {none} -power_domains PD_MOD_CL -block_pin_target {nearest_target} -connect {block_pin pad_pin pad_ring core_pin floating_stripe secondary_power_pin} -block_pin use_lef -secondary_pin_net {VDDL}
 
route_special -nets {VSS} -allow_layer_change 1 -allow_jogging 1 -core_pin_target {stripe ring block_ring} -power_domains PD_MOD_CL -block_pin_target {nearest_target} -connect {block_pin pad_pin pad_ring core_pin floating_stripe} 


# moduleD domain follow pins.


# Connect up the standard cells and secondary pins.  This at least is connecting the M1 std cell rails
route_special -connect {core_pin pad_pin secondary_power_pin} -crossover_via_layer_range {1 7}

#set_db opt_max_density 0.80
set_db place_global_cong_effort high
set_db place_global_max_density 0.35

set_db place_global_uniform_density true
set_db place_detail_irdrop_aware_effort high

#source ../scripts/cell_padding.tcl -verbose
#source ../scripts/cell_padding_commands.tcl 

place_design

if {1==0} {
    opt_design -pre_cts
    #place_fix_congestion
    ccopt_design
       # ccopt_design
        #setAnalysisMode -analysisType onChipVariation
        #setAnalysisMode -cppr both
    # routing the design
    set_db route_design_detail_end_iteration 10
    route_design 
    write_def ../outputs/$top_design.def -floorplan
}

write_power_intent ../outputs/$top_deisgn.innovus-cui.upf -1801

# Save netlist along with power and ground connections for LP verification.
write_netlist ../outputs/$top_design.pg.vg -phys -include_pg_ports
write_netlist ../outputs/$top_design.vg

write_db $top_design.innovus-cui

