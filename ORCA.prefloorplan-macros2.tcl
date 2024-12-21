foreach_in_collection i [ get_cells pad_iopad* ] {
   set changed "io_l_[get_attribute $i full_name ]" 
   change_names -instance $i -new_name $changed
}
foreach_in_collection i [ get_cells sdram_DQ_iopad* ] {
   set changed "io_r_[get_attribute $i full_name ]" 
   change_names -instance $i -new_name $changed
}

foreach_in_collection i [ get_cells sdram_A_iopad* ] {
   set changed "io_t_[get_attribute $i full_name ]" 
   change_names -instance $i -new_name $changed
}
foreach_in_collection i [ get_cells *iopad* -filter "full_name!~io_*"] {
   set changed "io_b_[get_attribute $i full_name ]" 
   change_names -instance $i -new_name $changed
}

# There is some problem with the EW cells in fusionCompiler ring placement.  
# You need to use NS cells.
change_link [get_cell -hier -filter "ref_name=~B16I1025_EW" ] B16I1025_NS

