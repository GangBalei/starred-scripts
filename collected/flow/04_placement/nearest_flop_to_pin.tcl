#########################################################################
# Script : nearest_flop_to_pin.tcl
# Author : Ahmed Abdelazeem
# Purpose: Find the nearest register (flop) to a given pin in the design
#########################################################################

proc nearest_flop_to_pin {args} {
    parse_proc_arguments -args $args arg_values
    set pin $arg_values(-pin)

    set pin_x [expr ([lindex [get_attribute $pin bbox] 0 0] + [lindex [get_attribute $pin bbox] 1 0]) / 2.0]
    set pin_y [expr ([lindex [get_attribute $pin bbox] 0 1] + [lindex [get_attribute $pin bbox] 1 1]) / 2.0]

    set all_reg [all_registers]
    if {[sizeof_collection $all_reg] == 0} {
        puts "No registers found in design."
        return
    }

    set min_distance {}
    set min_distant_flop {}

    foreach_in_collection ff $all_reg {
        set ff_x [expr ([lindex [get_attribute $ff bbox] 0 0] + [lindex [get_attribute $ff bbox] 1 0]) / 2.0]
        set ff_y [expr ([lindex [get_attribute $ff bbox] 0 1] + [lindex [get_attribute $ff bbox] 1 1]) / 2.0]
        set distance [expr sqrt(pow(($ff_x - $pin_x),2) + pow(($ff_y - $pin_y),2))]

        if {$min_distance eq {} || $distance < $min_distance} {
            set min_distance $distance
            set min_distant_flop [get_object_name $ff]
        }
    }

    puts "Nearest flop to pin $pin is $min_distant_flop at distance $min_distance microns"
    return [list $min_distant_flop $min_distance]
}

define_proc_attributes nearest_flop_to_pin \
    -info "Returns the nearest flop name and distance (microns) from a given pin" \
    -define_args {{-pin "pin_name" pin string required}}
