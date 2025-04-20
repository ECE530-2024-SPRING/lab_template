#history keep 100
#set_db timing_report_fields "delay arrival transition fanout load cell timing_point"
#source -echo -verbose ../../$top_design.design_config.tcl
#set lib_dir /pkgs/synopsys/2020/32_28nm/SAED32_EDK
set top_design lpupf_TOP
set rtl_list [list ../rtl/$top_design.sv ]
#set fast_corner "ff0p85v125c ff1p16v125c ff0p85v125c_i1p16v ulvl_ff1p16v125c_i0p85v pg_ff1p16v125c dlvl_ff0p85v125c_i1p16v"
#set fast_corner "ff0p85v125c ff1p16v125c ulvl_ff1p16v125c_i0p85v pg_ff1p16v125c dlvl_ff0p85v125c_i1p16v"
set lib_dir /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib
set hack_lef_dir /u/bcruik2/hacked_lefs
set lib_types "$lib_dir/stdcell_hvt"
set lib_types_target "$lib_dir/stdcell_hvt"
set sub_lib_type "saed32hvt_"
set sub_lib_type_target "saed32hvt_"
set lef_types [list $hack_lef_dir ]
set sub_lef_type "saed32nm_?vt_*.lef"
source -echo -verbose ../../$top_design.design_config.tcl

#set designs [set_db designs * ]
#if { $designs != "" } {
#  delete_obj $designs
#}

source ../scripts/genus-get-timlibslefs.tcl

set search_path "/pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_hvt/db_nldm ."
#set search_path "$lib_dir/lib/$lib_types/db_nldm ."
#set link_library "${sub_lib_type}${fast_corner}.lib "

#set_db init_lib_search_path "/pkgs/synopsys/2016/libs/SAED32_EDK/lib/stdcell_hvt/db_nldm"
set_db init_lib_search_path "/pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_hvt/db_nldm ."
#set_db init_lib_search_path $search_path

set_db library  "saed32hvt_ff0p85v125c.lib saed32hvt_ff1p16v125c.lib saed32hvt_dlvl_ff0p85v125c_i1p16v.lib  saed32hvt_ulvl_ff1p16v125c_i0p85v.lib saed32hvt_pg_ff1p16v125c.lib"
#set_db library "saed32rvt_ss0p95v125c.lib saed32io_wb_ss0p95v125c_2p25v.lib saed32sram_ss0p95v125c.lib saed32rvt_pg_ss0p95v125c.lib"
#set_db library $link_library

#set_db dft_opcg_domain_blocking true

#set_db auto_ungroup none

# Analyzing the current FIFO design
read_hdl -language sv ../rtl/${top_design}.sv

# Elaborate the FIFO design
elaborate $top_design

read_power_intent -module ${top_design} -1801 ../rtl/${top_design}.upf

set_operating_conditions -library saed32hvt_ff1p16v125c
set_operating_conditions -library saed32hvt_ff0p85v125c
set_operating_conditions -library saed32hvt_dlvl_ff0p85v125c_i1p16v
set_operating_conditions -library saed32hvt_ulvl_ff1p16v125c_i0p85v 

create_opcond -name VDD_TOPH -voltage 1.16
create_opcond -name VSS -voltage 0.00
create_opcond -name VDD_AH -voltage 1.16
create_opcond -name VDD_BH -voltage 1.16
create_opcond -name VDD_CL -voltage 0.85
create_opcond -name VDD_DL -voltage 0.85

create_opcond -name VDD_TOPH_OUT -voltage 1.16
create_opcond -name VDD_AH_OUT -voltage 1.16
create_opcond -name VDD_BH_OUT -voltage 1.16
create_opcond -name VDD_CL_OUT -voltage 0.85
create_opcond -name VDD_DL_OUT -voltage 0.85

#return -level 9 

apply_power_intent -design $top_design -module $top_design -summary

commit_power_intent -design $top_design

# Load the timing and design constraints
source -echo -verbose ../../constraints/${top_design}.sdc

#set_dont_use [get_lib_cells */DELLN* ]

syn_gen

uniquify $top_design

#compile with ultra features and with scan FFs
syn_map

syn_opt

# output reports
set stage genus
report_qor > ../reports/${top_design}.$stage.qor.rpt
#report_constraint -all_violators > ../reports/${top_design}.$stage.constraint.rpt
#report_timing -delay max -input -tran -cross -sig 4 -derate -net -cap -max_path 10000 > ../reports/${top_design}.$stage.timing.max.rpt
report_timing > ../reports/${top_design}.$stage.timing.max.rpt
check_timing > ../reports/${top_design}.$stage.check_timing.rpt
check_design > ../reports/${top_design}.$stage.check_design.rpt
#check_mv_design  > ../reports/${top_design}.$stage.mvrc.rpt
#report_reference > ../reports/${top_design}.$stage.ref.rpt

check_library -level_shifter_cell > ../reports/${top_design}.$stage.level_shifter.rpt
check_library -isolation_cell > ../reports/${top_design}.$stage.isolation_cell.rpt
report_power > ../reports/${top_design}.$stage.power.rpt
#report_pst > ../reports/${top_design}.$stage.pst.rpt

#write_db -all_root_attributes -verbose ../outputs/${top_design}.$stage.db
write_hdl $top_design > ../outputs/${top_design}.$stage.vg

write_power_intent -1801 -base_name ../outputs/${top_design}.$stage.upf

