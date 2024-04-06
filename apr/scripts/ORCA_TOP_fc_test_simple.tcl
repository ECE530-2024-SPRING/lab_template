# Fusion Comiler DFT
# https://spdocs.synopsys.com/dow_retrieve/qsc-u/dg/fcolh/U-2022.12-SP6/fcolh/pdf/fcfdft.pdf

#write -format verilog -hier -output ../outputs/${top_design}.dct.predft.vg
#write -hier -format ddc -output ../outputs/${top_design}.dct.predft.ddc
#save_upf ../outputs/${top_design}.dct.predft.upf

#Insert DFT 

#save_block -as "predft"

# -view_existing_dft means connection is there already in your design and use it
#     clocks are there and hooked up
# -view_spec means fusion compiler should add the connections to the point specfied.
#     SI/SO/SE ports are not connected
#     You might have -view_existing for main clock and another -view_spec for connection for Occ clock.  

set dftclk_ports { pclk sdram_clk sys_2x_clk }
set dftgenclk {I_CLOCKING/sys_clk_in_reg/Q }
set_dft_signal -view existing_dft -type ScanClock -port $dftclk_ports -timing [list 45 55] 

# if there are any resets or generated clocks, they should have a mux and be controllable by ports during test
set_dft_signal -port {prst_n} -active_state 0 -view existing_dft -type Reset

# This is for the te pin for test enable on a clock gating cell inserted by power compiler
set_dft_signal -view spec -port [get_ports test_si* ] -type ScanDataIn
set_dft_signal -view spec -port [get_ports test_so* ] -type ScanDataOut
set_dft_signal -port scan_enable -active_state 1 -view spec -type ScanEnable
set_dft_signal -port test_mode -active_state 1 -view existing -type TestMode


#set_app_var test_icg_p_ref_for_dft CGLNPRX2_LVT
set_app_option -name dft.test_icg_p_ref_for_dft -value CGLNPRX2_LVT 


set_dft_signal -type ScanEnable -view spec -usage clock_gating -port scan_enable


#Registers inside OCC controller must be non scan or else the internal clock will not be controlled correctly
set_scan_element false [get_cells I_CLOCKING/* -filter "is_sequential==true"  ]

##########################################################################################

#Add top level test_occ_bypass = occ_bypass & test_mode
create_cell test_occ_bypass saed32hvt_ss0p75vn40c/AND2X1_HVT
connect_pin -driver occ_bypass  test_occ_bypass/A1 -port_name occ_bypass
connect_pin -driver test_mode  test_occ_bypass/A2 -port_name test_mode
create_net test_occ_bypass_net 
connect_net test_occ_bypass_net [get_pin  test_occ_bypass/Y ]

# mux the div clock
create_cell dftclkmux saed32hvt_ss0p75vn40c/MUX21X1_HVT
set clkpin [ get_pin I_CLOCKING/sys_clk_in_reg/Q ]
set clknet [ get_net -of_obj $clkpin ]
disconnect_net $clknet $clkpin
connect_pin -driver $clkpin  dftclkmux/A1 -port dftmux_net
connect_pin -driver test_occ_bypass/Y  dftclkmux/S0 -port test_occ_bypass
connect_net $clknet dftclkmux/Y
connect_pin -driver ate_clk  dftclkmux/A2 -port_name ate_clk


##########################################################################################



# And off the resets FFs
foreach_in_collection i [ get_pins I_CLOCKING/*rst* -filter "direction==out" ] {
   set name [get_attribute $i name ]
   create_cell I_CLOCKING/${name}_testctl saed32hvt_ss0p75vn40c/OR2X1_HVT
   set driver [get_pin -leaf -of_obj [ get_net -of_obj  [get_pins $i ] ] -filter "direction == out" ]
   set drv_net [get_net -of_obj $driver ]
   disconnect_net $drv_net $driver
   connect_net $drv_net I_CLOCKING/${name}_testctl/Y
   connect_pin -driver test_mode   I_CLOCKING/${name}_testctl/A1 -port_name test_mode
   connect_pin -driver $driver  I_CLOCKING/${name}_testctl/A2 
}

# mux the port clocks together
#create_net ate_clk
#foreach clkport $dftclk_ports {
#    puts "working on $clkport"
#    set port_net [get_net -of_obj [ get_port $clkport ] ]
#    set clkpins [ get_pins -of_obj $port_net  ] 
#    create_net ${clkport}_mux_net
#    create_cell ${clkport}_mux saed32hvt_ss0p75vn40c/MUX21X1_HVT
#    connect_net ${clkport}_mux_net ${clkport}_mux/Y
#    foreach i $clkpins {
#      disconnect_net $port_net $i
#      connect_net ${clkport}_mux_net $i
#    }
#    connect_net $port_net ${clkport}_mux/A1 
#    connect_net [get_net ate_clk ] ${clkport}_mux/A2
#    connect_net [get_net -of_obj [ get_pin test_occ_bypass/Y ] ] ${clkport}_mux/S0
#}


##########################################################################################
#set_app_options -as_user_default -name dft.insert_dft_post_compiile -value true
create_test_protocol  
dft_drc 
preview_dft
insert_dft
dft_drc 

report_scan_path  > ../reports/${top_design}.dct.dft2.scan.rpt

