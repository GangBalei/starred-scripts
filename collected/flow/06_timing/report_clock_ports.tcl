# Enhanced Clock Port Width Checker
proc check_clock_port_widths {} {
    set violation_count 0
    set total_ports 0
    set violations_list {}
    puts "=========================================="
    puts "Clock Port Width Analysis Report"
    puts "=========================================="
    puts ""
    set clocks [get_clocks]
    if {[llength $clocks] == 0} {
        puts "WARNING: No clocks found in design"
        return
    }
    puts "Found [llength $clocks] clock(s) in design"
    puts ""
    foreach_in_collection clock_port [get_attribute $clocks sources] {
        incr total_ports
        if {[catch {set port_name [get_attribute $clock_port name]} err]} {
            puts "ERROR: Cannot get port name for clock port #$total_ports: $err"
            continue
        }
        if {[catch {set shape [get_shapes -of_objects $clock_port]} err]} {
            puts "WARNING: No shape found for port '$port_name': $err"
            continue
        }
        if {[catch {
            set layer [get_attribute $shape layer]
            set layer_name [get_attribute $layer name]
            set layer_min_width [get_attribute $layer min_width]
        } err]} {
            puts "ERROR: Cannot get layer information for port '$port_name': $err"
            continue
        }
        if {[catch {
            set ll_y [get_attribute $clock_port bounding_box.ll_y]
            set ur_y [get_attribute $clock_port bounding_box.ur_y]
        } err]} {
            puts "ERROR: Cannot get bounding box for port '$port_name': $err"
            continue
        }
        set port_width [expr {$ur_y - $ll_y}]
        if {$port_width < $layer_min_width} {
            incr violation_count
            set violation_info [list \
                port_name $port_name \
                layer_name $layer_name \
                required_width $layer_min_width \
                actual_width $port_width \
                violation_amount [expr {$layer_min_width - $port_width}] \
            ]
            lappend violations_list $violation_info
            puts "VIOLATION: Port '$port_name'"
            puts "  Layer: $layer_name"
            puts "  Required Width: $layer_min_width"
            puts "  Actual Width: $port_width"
            puts "  Shortage: [expr {$layer_min_width - $port_width}]"
            puts "  Coordinates: Y($ll_y, $ur_y)"
            puts ""
        }
    }
    puts "=========================================="
    puts "SUMMARY REPORT"
    puts "=========================================="
    puts "Total clock ports analyzed: $total_ports"
    puts "Width violations found: $violation_count"
    puts "Pass rate: [expr {$total_ports > 0 ? (($total_ports - $violation_count) * 100.0 / $total_ports) : 0}]%"
    puts ""
    if {$violation_count > 0} {
        puts "ACTION REQUIRED: $violation_count port(s) need width adjustment"
    } else {
        puts "All clock ports meet minimum width requirements ✓"
    }
    return $violation_count
}
