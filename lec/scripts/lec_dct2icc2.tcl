# Do this beforehand in order to get the licenses correct.
# export CDS_LIC_FILE=5280@license.cecs.pdx.edu
# source /pkgs/cadence/09-2015/local/bin/s_cadence.bash

# Make sure to exprt top=simple_adder
# lec -tclmode -dofile ../scripts/lec_rtl2dc.tcl

global env
set libs "/pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_rvt/verilog/saed32nm.v /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_hvt/verilog/saed32nm_hvt.v /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_lvt/verilog/saed32nm_lvt.v /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/sram/verilog/saed32sram.v  /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/io_std/verilog/saed32nm_io_wb.v" 
read_design [join [list $libs ../../apr/outputs/$env(TOP).route2.vg.gz ] ] -verilog  -Golden -sensitive -continuousassignment Bidirectional -nokeep_unreach   -nosupply -root $env(TOP)
read_design [join [list $libs ../../apr/outputs/$env(TOP).route2.vg.gz ] ] -verilog  -revised -sensitive -continuousassignment Bidirectional -nokeep_unreach   -nosupply -root $env(TOP)


# Set any DFT input ports to values to turn of scan shift mode
# add_pin_constraints <value> <port> -both

# ignore outputs related to dft
# add_ignored_outputs <port> -both

# if macro pins are more for DFT rather than functional mode, ignore them
# ignoreMacroInputPins <macro_names with wild cards> <pin list with wild cards>
# ignoreMacroOutputPins <macro name> <pin list with wild cards>

# don't work on the guts of macros
# add_notranslate_modules -both <macro name>

# set FFs that are internal test mode FFs if they exist
# add_inst_constraint <value> <instance_name> -both

set_system mode lec
add_compared_points -all
compare

