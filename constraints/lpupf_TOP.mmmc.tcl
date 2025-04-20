create_library_set -name libs_max -timing "/pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_hvt/db_nldm/saed32hvt_ss0p75v125c.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_hvt/db_nldm/saed32hvt_ss0p95v125c.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_rvt/db_nldm/saed32rvt_ss0p75v125c.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_rvt/db_nldm/saed32rvt_ss0p95v125c.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_lvt/db_nldm/saed32lvt_ss0p75v125c.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_lvt/db_nldm/saed32lvt_ss0p95v125c.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/io_std/db_nldm/saed32io_wb_ss0p95v125c_2p25v.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/sram/db_nldm/saed32sram_ss0p95v125c.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/pll/db_nldm/saed32pll_ss0p95v125c_2p25v.lib"

create_library_set -name libs_min -timing "/pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_hvt/db_nldm/saed32hvt_ff0p95vn40c.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_hvt/db_nldm/saed32hvt_ff1p16vn40c.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_rvt/db_nldm/saed32rvt_ff0p95vn40c.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_rvt/db_nldm/saed32rvt_ff1p16vn40c.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_lvt/db_nldm/saed32lvt_ff0p95vn40c.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_lvt/db_nldm/saed32lvt_ff1p16vn40c.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/io_std/db_nldm/saed32io_wb_ff1p16vn40c_2p75v.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/sram/db_nldm/saed32sram_ff1p16vn40c.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/pll/db_nldm/saed32pll_ff1p16vn40c_2p75v.lib"

create_timing_condition -name max_timing_condition -library_sets {libs_max}
create_timing_condition -name min_timing_condition -library_sets {libs_min}

create_rc_corner -name cmax -T -40 -cap_table ../../cadence_cap_tech/saed32nm_1p9m_Cmax.cap
create_rc_corner -name cmin -T -40 -cap_table ../../cadence_cap_tech/saed32nm_1p9m_Cmin.cap

create_delay_corner -name max_corner -timing_condition {max_timing_condition max_timing_condition} -rc_corner cmax
create_delay_corner -name min_corner -timing_condition {min_timing_condition min_timing_condition} -rc_corner cmin

create_constraint_mode -name func_max_sdc -sdc_files ../../constraints/lpupf_TOP.sdc
#create_constraint_mode -name func_min_sdc -sdc_files ../../constraints/fifo1_sram.sdc
create_analysis_view -name func_max_scenario -delay_corner max_corner -constraint_mode func_max_sdc
#create_analysis_view -name func_min_scenario -delay_corner min_corner -constraint_mode func_min_sd

set_analysis_view -setup func_max_scenario -hold func_max_scenario
#set_analysis_view -setup func_max_scenario -hold func_min_scenario

set_interactive_constraint_modes {func_max_sdc func_max_sdc}



# do we need the following?
#yes

set link_library_worst "/pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_hvt/db_nldm/saed32hvt_ss0p75vn40c.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_hvt/db_nldm/saed32hvt_dlvl_ss0p75vn40c_i0p95v.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_hvt/db_nldm/saed32hvt_ulvl_ss0p75vn40c_i0p75v.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_hvt/db_nldm/saed32hvt_dlvl_ss0p75vn40c_i0p75v.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_hvt/db_nldm/saed32hvt_ss0p95vn40c.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_hvt/db_nldm/saed32hvt_ulvl_ss0p95vn40c_i0p75v.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_rvt/db_nldm/saed32rvt_ss0p75vn40c.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_rvt/db_nldm/saed32rvt_dlvl_ss0p75vn40c_i0p95v.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_rvt/db_nldm/saed32rvt_ulvl_ss0p75vn40c_i0p75v.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_rvt/db_nldm/saed32rvt_dlvl_ss0p75vn40c_i0p75v.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_rvt/db_nldm/saed32rvt_ss0p95vn40c.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_rvt/db_nldm/saed32rvt_ulvl_ss0p95vn40c_i0p75v.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_lvt/db_nldm/saed32lvt_ss0p75vn40c.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_lvt/db_nldm/saed32lvt_dlvl_ss0p75vn40c_i0p95v.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_lvt/db_nldm/saed32lvt_ulvl_ss0p75vn40c_i0p75v.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_lvt/db_nldm/saed32lvt_dlvl_ss0p75vn40c_i0p75v.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_lvt/db_nldm/saed32lvt_ss0p95vn40c.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_lvt/db_nldm/saed32lvt_ulvl_ss0p95vn40c_i0p75v.lib /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/sram/db_nldm/saed32sram_ss0p95vn40c.lib"













