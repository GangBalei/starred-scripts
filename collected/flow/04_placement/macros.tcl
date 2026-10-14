#!/usr/bin/env tclsh8.5
#####################################################
# Script to Automatically Generate Macro Placement  #
# Two Methods to Create 'macro.tcl' with Commands   #
#####################################################

# Method 1: Append Mode
set fw [open "macro.tcl" a]
foreach macro [get_object_name [get_cells -design [current_blocks] -hierarchical -filter "is_hard_macro == true"]] {
    set origin  [get_attribute $macro origin]
    set bbox  [get_attribute $macro bbox]
    set orient [get_attribute $macro orientation]
    set x [lindex $bbox 0]
    set y [lindex $bbox 1]
    puts $fw "set_cell_location -coordinates \{$x $y\} -orientation $orient $macro"
}
close $fw

# Method 2: Write Mode
set macros [get_object_name [get_cells -hierarchical -filter "is_hard_macro == true"]]
set fw [open "macro.tcl" w]
foreach macro $macros {
    set bbox  [get_attribute $macro bbox]
    set orient [get_attribute $macro orientation]
    set x [lindex $bbox 0]
    set y [lindex $bbox 1]
    puts $fw "set_cell_location -coordinates \{$x $y\} -orientation $orient $macro"
}
close $fw
