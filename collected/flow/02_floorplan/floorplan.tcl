# specify floorplan
floorPlan -site M31_CORE_9T -r 0.99907493062 0.110222 50 50 50 50

# master plan
::mp::clearAllSeed

setPlanDesignMode -effort high -incremental false -boundaryPlace true -fixPlacedMacros false -noColorize false -macroSpacing 10
planDesign

addHaloToBlock {10 10 10 10} -allMacro
redraw
setInstancePlacementStatus -allHardMacros -status fixed

# powerplan

clearGlobalNets
globalNetConnect CORE_VCCK -type pgpin -pin VCCK -inst *
globalNetConnect CORE_VCCK -type tiehi -pin VCCK -inst *
globalNetConnect CORE_VCCK -type pgpin -pin VDD -inst *
globalNetConnect IO_VCCK -type pgpin -pin VDDIO -inst *
globalNetConnect CORE_GNDK -type pgpin -pin GNDK -inst *
globalNetConnect CORE_GNDK -type tielo -pin GNDK -inst *
globalNetConnect CORE_GNDK -type pgpin -pin VSS -inst *
globalNetConnect IO_GNDK -type pgpin -pin VSSIO -inst *

set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
setAddRingMode -ring_target default -extend_over_row 0 -ignore_rows 0 -avoid_short 0 -skip_crossing_trunks none -stacked_via_top_layer RDL -stacked_via_bottom_layer M1 -via_using_exact_crossover_s[...]
#addRing -nets {CORE_VCCK CORE_GNDK} -type core_rings -follow core -layer {top RDL bottom RDL left RDL right RDL} -width {top 20 bottom 20 left 20 right 20} -spacing {top 2 bottom 2 left 1.5 right[...]
addRing -nets {CORE_VCCK CORE_GNDK} -type core_rings -follow core -layer {top RDL bottom RDL left T4M2 right T4M2} -width {top 10 bottom 10 left 10 right 10} -spacing {top 2 bottom 2 left 1.5 righ[...]


#gui_select -rect {805.926 1577.394 1824.566 1790.110}
#setAddRingMode -ring_target default -extend_over_row 0 -ignore_rows 0 -avoid_short 0 -skip_crossing_trunks none -stacked_via_top_layer RDL -stacked_via_bottom_layer M1 -via_using_exact_crossover_[...]
#addRing -nets {CORE_VCCK CORE_GNDK} -type block_rings -around cluster -layer {top RDL bottom RDL left T4M2 right T4M2} -width {top 10 bottom 10 left 10 right 10} -spacing {top 2 bottom 2 left 1.5[...]
#gui_select -rect {710.054 624.666 1812.582 148.302}
#setAddRingMode -ring_target default -extend_over_row 0 -ignore_rows 0 -avoid_short 0 -skip_crossing_trunks none -stacked_via_top_layer RDL -stacked_via_bottom_layer M1 -via_using_exact_crossover_[...]
#addRing -nets {CORE_VCCK CORE_GNDK} -type block_rings -around cluster -layer {top RDL bottom RDL left T4M2 right T4M2} -width {top 10 bottom 10 left 10 right 10} -spacing {top 2 bottom 2 left 1.5[...]

  
#setAddStripeMode -ignore_block_check false -break_at {  block_ring  } -route_over_rows_only false -rows_without_stripes_only false -extend_to_closest_target none -stop_at_last_wire_for_area false[...]
#addStripe -nets {CORE_VCCK CORE_GNDK} -layer RDL -direction horizontal -width 10 -spacing 2 -set_to_set_distance 40 -start_from bottom -switch_layer_over_obs true -max_same_layer_jog_length 2 -pa[...]
#setAddStripeMode -ignore_block_check false -break_at {  block_ring  } -route_over_rows_only false -rows_without_stripes_only false -extend_to_closest_target none -stop_at_last_wire_for_area false[...]
#addStripe -nets {CORE_VCCK CORE_GNDK} -layer T4M2 -direction vertical -width 10 -spacing 1.5 -set_to_set_distance 40 -start_from left -switch_layer_over_obs true -max_same_layer_jog_length 2 -pad[...]


addIoFiller -cell FILLER05I -prefix FILLER -side n -fillAnyGap
addIoFiller -cell FILLER05I -prefix FILLER -side s -fillAnyGap
addIoFiller -cell FILLER05I -prefix FILLER -side w -fillAnyGap
addIoFiller -cell FILLER05I -prefix FILLER -side e -fillAnyGap


#setSrouteMode -viaConnectToShape { ring stripe blockring }
#sroute -connect { blockPin padPin padRing corePin floatingStripe } -layerChangeRange { M1(1) RDL(7) } -blockPinTarget { nearestTarget } -padPinPortConnect { allPort oneGeom } -padPinTarget { near[...]

# save the floorplan

saveFPlan Top_Remcm_mini_sram_withio.fp
