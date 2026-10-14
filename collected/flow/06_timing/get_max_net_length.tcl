#!/usr/bin/tclsh8.5
#Longest Net

proc collection_to_list {a_collection} {
    set my_list {}
    foreach_in_collection item $a_collection {
        lappend my_list [get_object_name $item]
    }
    return $my_list
}

proc get_max_net_length {} {
    set nets [collection_to_list [get_nets] -no_braces -name_only]
    set max_length 0
    set max_net ""
    set max_type ""

    foreach net $nets {
        set net_len [get_attribute [get_nets $net] dr_length]
        set net_type [get_attribute [get_nets $net] net_type]
        if {($net_type != "power") && ($net_type != "ground")} {
            if {$net_len > $max_length} {
                set max_length $net_len
                set max_net $net
                set max_type $net_type
            }
        }
    }

    puts "Longest Net Details: 
 ==============================================
 Net Name   : $max_net
 Net Length : $max_length
 Net Type   : $max_type
 "
}
