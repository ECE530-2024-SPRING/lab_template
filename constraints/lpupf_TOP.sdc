if { [info exists synopsys_program_name ] && ($synopsys_program_name == "icc2_shell") } {
    puts " Creating ICC2 MCMM "
    create_mode func
    create_corner slow
    create_scenario -mode func -corner slow -name func_slow
    current_scenario func_slow
    set_operating_conditions ss0p75v125c
    read_parasitic_tech -tlup $tlu_dir/saed32nm_1p9m_Cmax.tluplus -layermap $tlu_dir/saed32nm_tf_itf_tluplus.map -name Cmax
    read_parasitic_tech -tlup $tlu_dir/saed32nm_1p9m_Cmin.tluplus -layermap $tlu_dir/saed32nm_tf_itf_tluplus.map -name Cmin
    set_parasitic_parameters -early_spec Cmax -early_temperature 125
    set_parasitic_parameters -late_spec Cmax -late_temperature 125
    #set_parasitic_parameters -early_spec 1p9m_Cmax -early_temperature 125 -corner default
    #set_parasitic_parameters -late_spec 1p9m_Cmax -late_temperature 125 -corner default

    #set_scenario_status  default -active false
    set_scenario_status func_slow -active true -hold true -setup true
}
create_clock -period 1.0 [get_ports clk_upf]
set_input_delay -max 0.34 -clock clk_upf [get_ports {A_TOP B_TOP P_TOP Q_TOP R_TOP CARRY_TOP_TO_MOD_B CARRY_TOP_TO_MOD_C CARRY_TOP_TO_MOD_D ISO Isola Isolb Isolc ctrl_a ctrl_b ctrl_c ctrl_d}]
set_output_delay -max 0.66 -clock clk_upf [get_ports {AB_XOR_TOP AB_AND_TOP XOR_from_mod_A_TOP AND_from_mod_A_TOP XOR_mod_B_A_TOP AND_mod_B_A_TOP XOR_from_mod_C_B_OUT_TOP AND_from_mod_C_B_OUT_TOP S_from_mod_B_TOP C_from_mod_B_TOP S_from_mod_C_TOP C_from_mod_C_TOP}]
set_input_transition 0.1 [all_inputs]
#set_load -wireload 0.05
set_load 0.05 [all_outputs]
