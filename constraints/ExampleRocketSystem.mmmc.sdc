# need to create something more complicated for different link_library for each corner.
# Clear the file before writing to it. 
echo create_library_set -name worst_libs -timing \"$link_library_worst\" > mmmc.tcl
echo create_library_set -name best_libs -timing \"$link_library_best\" >> mmmc.tcl

#slow = worst = max = setup
#fast = best = min = hold

#create_op_cond
#similar to parasitic corners in Synopsys
if [is_common_ui_mode] { set temp_option temperature } else { set temp_option T }
echo create_rc_corner -name cmax -$temp_option -40 -cap_table ../../cadence_cap_tech/saed32nm_1p9m_Cmax.cap >> mmmc.tcl
echo create_rc_corner -name cmin -$temp_option -40 -cap_table ../../cadence_cap_tech/saed32nm_1p9m_Cmin.cap >> mmmc.tcl
#echo create_rc_corner -name default_rc_corner -T -40 -cap_table ../../cadence_cap_tech/saed32nm_1p9m_Cmax.cap >> mmmc.tcl


# Creating corners. 
if [is_common_ui_mode ] {
    echo create_timing_condition -library_sets worst_libs -name timingcondition_max  >> mmmc.tcl
    echo create_timing_condition -library_sets best_libs -name timingcondition_min  >> mmmc.tcl
    echo create_delay_corner -name worst_corner -timing_condition timingcondition_max -rc_corner cmax >> mmmc.tcl
    echo create_delay_corner -name best_corner -timing_condition timingcondition_min -rc_corner cmin >> mmmc.tcl
} else {
    echo create_delay_corner -name worst_corner -library_set worst_libs -rc_corner cmax >> mmmc.tcl
    echo create_delay_corner -name best_corner -library_set best_libs -rc_corner cmin >> mmmc.tcl
}

# Creating modes, sdc file mentioned..
echo create_constraint_mode -name func_max_sdc -sdc_files ../../constraints/${top_design}.sdc >> mmmc.tcl
echo create_constraint_mode -name func_min_sdc -sdc_files ../../constraints/${top_design}.sdc >> mmmc.tcl

# Creating scenario. 
echo create_analysis_view -name func_max_scenario -delay_corner worst_corner -constraint_mode func_max_sdc >> mmmc.tcl
echo create_analysis_view -name func_min_scenario -delay_corner best_corner -constraint_mode func_min_sdc >> mmmc.tcl

echo set_analysis_view -setup func_max_scenario -hold func_min_scenario >> mmmc.tcl

# This is done so constraints applied are applied to all analysis views.
# sdc file that needs to run is /syn/outputs/$top_design.genus.sdc
echo "set_interactive_constraint_modes \{func_max_sdc func_min_sdc\}" >> mmmc.tcl

set init_mmmc_file mmmc.tcl

