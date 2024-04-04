
if { [ info exists dc_floorplanning ] && $dc_floorplanning } {
   set verilog_file ../../syn/outputs/${top_design}.dc.vg
} else {
   set verilog_file ../../syn/outputs/${top_design}.dct.vg
}

if { [ info exists fc_rtl ] && $fc_rtl } {
   set verilog_file $rtl_list
}

file delete -force $my_lib 

# Adding the tech file causes problems later with missing routing directions for some reason.
#create_lib $my_lib -ref_libs $libs -tech $tf_dir/saed32nm_1p9m_mw.tf 

create_lib $my_lib -ref_libs $libs  -use_technology_lib [lindex $libs 0 ] 


#import_designs $verilog_file \
#	-format verilog \
#	-cel $top_design \
#	-top $top_design

if { [ info exists fc_rtl ] && $fc_rtl } {
    analyze $rtl_list  -define SYNTHESIS -format sverilog
    elaborate ${top_design} 
    set_top_module $top_design  
    uniquify
    change_names -rules verilog -hierarchy

    if { [ info exists add_ios ] && $add_ios } {
       source -echo -verbose ../../syn/scripts/add_ios.tcl
       # Source the design dependent code that will put IOs on different sides
       source ../../$top_design.add_ios.tcl
    }
     
} else {
   create_block ${top_design}
   open_block ${top_design}
   read_verilog  -top $top_design  $verilog_file
}




# Read the SCANDEF information created by DFTC
# read_def $scandef_file


