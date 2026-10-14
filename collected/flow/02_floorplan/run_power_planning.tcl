# add power switches for PDmac1 and PDmac2
addPowerSwitch -column  \
    -powerDomain PDmac1 \
    -enableNetOut ethernet_mac_1/switch_enable_out_PDmac1 \
    -leftOffset 30 -bottomOffset 0 \
    -horizontalPitch 72 \
    -checkerBoard \
    -loopBackAtEnd \
    -switchModuleInstance ethernet_mac_1

addPowerSwitch -column \
    -powerDomain PDmac2 \
    -enableNetOut ethernet_mac_2/switch_enable_out_PDmac2 \
    -leftOffset 30 -bottomOffset 0 \
    -horizontalPitch 72 \
    -checkerBoard \
    -loopBackAtEnd \
    -switchModuleInstance ethernet_mac_2

# power planning
addRing -center 1 -stacked_via_top_layer Metal11 -type core_rings -jog_distance 0.24 -threshold 0.24 \
  -nets {VDD VSS VDDm} -stacked_via_bottom_layer Metal1 \
  -layer {bottom Metal7 top Metal7 right Metal8 left Metal8} -width 10 -spacing 8 -offset 0.24

deselectAll
selectObject Group PDmac1
addRing -stacked_via_top_layer Metal11 -around power_domain -jog_distance 0.24 -threshold 0.24 \
  -type block_rings -nets {VDDau VDDm VSS VDD} -stacked_via_bottom_layer Metal1 \
  -layer {bottom Metal7 top Metal7 right Metal8 left Metal8} -width 5 -spacing 5 -offset 7.5

deselectAll
selectObject Group PDmac2
addRing -stacked_via_top_layer Metal11 -around power_domain -jog_distance 0.24 -threshold 0.24 \
  -type block_rings -nets {VDDlu VDDm VSS VDD} -stacked_via_bottom_layer Metal1 \
  -layer {bottom Metal7 top Metal7 right Metal8 left Metal8} -width 5 -spacing 5 -offset 7.5

# add stripes

deselectAll
selectInst dma_dut/dmamaster_dut/internal_memory/RAM4096x32
setAddStripeMode -ignore_nondefault_domains 1
addStripe -block_ring_top_layer_limit Metal9 -max_same_layer_jog_length 0.44 \
  -padcore_ring_bottom_layer_limit Metal7 -set_to_set_distance 144 \
  -break_at_selected_blocks 1 -stacked_via_top_layer Metal11 \
  -padcore_ring_top_layer_limit Metal9 -spacing 2 -xleft_offset 22 \
  -merge_stripes_value 0.24 -layer Metal8 -block_ring_bottom_layer_limit Metal7 \
  -width 5 -nets {VDD VSS} -stacked_via_bottom_layer Metal1
setAddStripeMode -ignore_nondefault_domains 0

# add stripes for VDDm, VDDau and VSS for PDmac1
# add VDDm rings for each RAMs
deselectAll
selectInst ethernet_mac_1/rx_fifo_module_to_dma/data/dual_port_ram_4_tx_fifo/ram2P1024x32
addRing -stacked_via_top_layer Metal11 -around selected -jog_distance 0.24 -threshold 0.24 \
  -type block_rings -nets VDDm -stacked_via_bottom_layer Metal1 \
  -layer {bottom Metal7 top Metal7 right Metal8 left Metal8} -width 3 -spacing 3.5

deselectAll
selectInst ethernet_mac_1/tx_fifo_module_from_dma/fifo1/dual_port_ram_4_tx_fifo/ram2P1024x32
addRing -stacked_via_top_layer Metal11 -around selected -jog_distance 0.24 -threshold 0.24 \
  -type block_rings -nets VDDm -stacked_via_bottom_layer Metal1 \
  -layer {bottom Metal7 top Metal7 right Metal8 left Metal8} -width 3 -spacing 3.5

deselectAll
selectInst ethernet_mac_1/rx_fifo_module_to_dma/pkt_cntr/dual_port_ram_4_tx_fifo/a
addRing -stacked_via_top_layer Metal11 -around selected -jog_distance 0.24 -threshold 0.24 \
  -type block_rings -nets VDDm -stacked_via_bottom_layer Metal1 \
  -layer {bottom Metal7 top Metal7 right Metal8 left Metal8} -width 3 -spacing 3.5

# add stripes
deselectAll
selectInst ethernet_mac_1/rx_fifo_module_to_dma/data/dual_port_ram_4_tx_fifo/ram2P1024x32
selectInst ethernet_mac_1/tx_fifo_module_from_dma/fifo1/dual_port_ram_4_tx_fifo/ram2P1024x32
selectInst ethernet_mac_1/rx_fifo_module_to_dma/pkt_cntr/dual_port_ram_4_tx_fifo/a
selectObject Group PDmac1

addStripe -block_ring_top_layer_limit Metal3 -max_same_layer_jog_length 0.44 \
  -over_power_domain 1 -padcore_ring_bottom_layer_limit Metal1 -set_to_set_distance 144 \
  -break_at_selected_blocks 1 -stacked_via_top_layer Metal11 -padcore_ring_top_layer_limit Metal3 \
  -spacing 2 -xleft_offset 138 -merge_stripes_value 0.24 -layer Metal8 \
  -block_ring_bottom_layer_limit Metal1 -width 3 -nets {VDDm VSS VDDau} -stacked_via_bottom_layer Metal1
