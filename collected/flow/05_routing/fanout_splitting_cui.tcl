###usage fix_fanout <netName> <Fanout required> <Buffer master name>#########
proc fix_fanout_cui {net fanout cellname {prefix fix_fanout}} {

    set iter 0
    while {1} {
      set fanout_req $fanout
      set cell $cellname
      set net1 $net
      set net2 [split $net1 /]
      set length [llength $net2]
      set length1 [expr $length -1]
      set net3 [lindex $net2 $length1]
      set pinout1 [get_property [get_nets $net1] driver_pins]
      set pinout [get_object_name $pinout1]
      set module [get_db [get_db pins $pinout] .inst.parent.name]
      if {$module=="{}"} { set module "fix_fanout"}
      set output [all_connected $net1 -leaf ]
      set fanout_current [sizeof_collection $output]
      set num [expr $fanout_current/$fanout_req]
      if {$num<=0} {
          break
      } else {
          incr iter
          set prefix ${prefix}_${iter}
      }
      set i 0
      foreach_in_collection x [all_fanout -from $pinout -trace_through all -pin_levels 1 ] {
        set x_$i [get_object_name $x]
        incr i
      }
      set i 1
      while {$i<$fanout_current} {
        set cmd x_$i
        set x2 [eval get_db pins .name $$cmd]
        set Term_$i [get_db pin:$x2 .base_pin.base_name]
        set Inst_$i [get_db pin:$x2 .inst.name]
        set cmd1 Term_$i
        set cmd2 Inst_$i 
        eval set cmd11 $$cmd1
        eval set cmd22 $$cmd2
        disconnect_pin -inst $cmd22 -pin $cmd11 -net $net1
        incr i
      }
      set i 0
      while {$i<$num} {
        set cmd ${prefix}_${net3}_fanout_net_$i
        set cmd1 ${prefix}_${net3}_fanout_$i
        if {$module=="{}"} {
            create_inst -cell $cell -inst $cmd1
            create_net -name $cmd
            connect_pin -inst $cmd1 -pin [get_db [get_db inst:$cmd1 .base_cell.base_pins -if {.direction == in}] .base_name] -net $net1
            connect_pin -inst $cmd1 -pin [get_db [get_db inst:$cmd1 .base_cell.base_pins -if {.direction == out}] .base_name] -net $cmd
        } else {
            create_inst -cell $cell -inst $module/$cmd1
            create_net -name $module/$cmd
            connect_pin -inst $module/$cmd1 -pin [get_db [get_db inst:$module/$cmd1 .base_cell.base_pins -if {.direction == in}] .base_name] -net $net1
            connect_pin -inst $module/$cmd1 -pin [get_db [get_db inst:$module/$cmd1 .base_cell.base_pins -if {.direction == out}] .base_name] -net $module/$cmd
        }
        incr i
      }
      set i 0
      set j 0
      set k 1
      while {$i<$num} {
        while {$j<$fanout_req} {
          set cmd1 Term_$k
          set cmd2 Inst_$k 
          set cmd ${prefix}_${net3}_fanout_net_$i
          eval set cmd11 $$cmd1
          eval set cmd22 $$cmd2
          if {$module=="{}"} {
              connect_pin -inst $cmd22 -pin $cmd11 -net $cmd
          } else {
              connect_pin -inst $cmd22 -pin $cmd11 -net $module/$cmd
          }
          incr j
          incr k
        }
        incr i
        set j 0
      }
      if {$k<$fanout_current} {
        set cmd ${net3}_fanout_net_$i
        set cmd1 ${net3}_fanout_$i
        if {$module=="{}"} { 
          create_inst -cell $cell -inst $cmd1
          create_net -name $cmd
          connect_pin -inst $cmd1 -pin [get_db [get_db inst:$cmd1 .base_cell.base_pins -if {.direction == in}] .base_name] -net $net1
          connect_pin -inst $cmd1 -pin [get_db [get_db inst:$cmd1 .base_cell.base_pins -if {.direction == out}] .base_name] -net $cmd
        } else {
          create_inst -cell $cell -inst $module/$cmd1
          create_net -name $module/$cmd
          connect_pin -inst $module/$cmd1 -pin [get_db [get_db inst:$module/$cmd1 .base_cell.base_pins -if {.direction == in}] .base_name] -net $net1
          connect_pin -inst $module/$cmd1 -pin [get_db [get_db inst:$module/$cmd1 .base_cell.base_pins -if {.direction == out}] .base_name] -net $module/$cmd
        }
      }
      while {$k<$fanout_current} {
        set cmd1 Term_$k
        set cmd2 Inst_$k 
        eval set cmd11 $$cmd1
        eval set cmd22 $$cmd2
        if {$module=="{}"} { 
          connect_pin -inst $cmd22 -pin $cmd11 -net $cmd
        } else {
          connect_pin -inst $cmd22 -pin $cmd11 -net $module/$cmd
        }
        incr k
      }
    }
}
