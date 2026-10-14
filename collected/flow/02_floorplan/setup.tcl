global vars
set vars(version)                                  17.1.0
source inn_config.tcl

#######################################################################
# Define some variables to point to data, libraries, and scripts
#----------------------------------------------------------------------
#set vars(design_root)                              ""
set vars(script_root)                              ./SCRIPTS
set vars(dbs_dir)                                  ./DBS
set vars(rpt_dir)                                  ./RPT


#######################################################################
# Define technology and physical libraries
#-----------------------------------------------------------------
set vars(process)                                  55nm
set vars(lef_files) \
  "/home/Data1/Zhengpeng/work/Remcm_mini_sram3/DATA/lef_techfiles/tech/HL055P_1p6m_501.lef \
    /home/Data1/Zhengpeng/work/Remcm_mini_sram3/DATA/lef.1p6m_501/M31GPIO1225HL055P.lef \
    /home/Data1/Zhengpeng/work/Remcm_mini_sram3/DATA/M31GPSC900HL055PR.0.01/lef/M31GPSC900HL055PR.lef \
    /home/Data1/Zhengpeng/work/Remcm_mini_sram3/DATA/Raochl_memory/asdrlspkb1p64x8cm2sw0/asdrlspkb1p64x8cm2sw0.plef \
    /home/Data1/Zhengpeng/work/Remcm_mini_sram3/DATA/Raochl_memory/asdrlspkb1p128x8cm4sw0/asdrlspkb1p128x8cm4sw0.plef \
    /home/Data1/Zhengpeng/work/Remcm_mini_sram3/DATA/Raochl_memory/sadslspkb2p128x42m4b2w0cp0d0t0/sadslspkb2p128x42m4b2w0cp0d0t0.plef"
#set vars(ilm_list)                                 ""
#set vars(partition_list)                           ""


#######################################################################
# Define the design data
#-----------------------------------------------------------------
set vars(netlist) "/home/Data1/Zhengpeng/work/Remcm_mini_sram3/DATA/Top_Remcm_mini_sram_all.v"
set vars(design)                                   Top_Remcm_mini_sram_withio
set vars(fp_file) "/home/Data1/Zhengpeng/work/Remcm_mini_sram3/Top_Remcm_mini_sram_withio03142334.fp"
#set vars(def_files) ""
#set vars(fp_tcl_file) ""
#set vars(fp_tcl_proc)                              ""
#set vars(scan_def) ""
set vars(power_nets)                               "CORE_VCCK IO_VCCK"
set vars(ground_nets)                              "CORE_GNDK IO_GNDK"
set vars(honor_pitch)                              FALSE

#set vars(cts_spec) ""
set vars(cts_cells)                                "CLKBUFX12AR9 CLKBUFX16AR9 CLKBUFX1AR9 CLKBUFX20AR9 CLKBUFX2AR9 CLKBUFX3AR9 CLKBUFX4AR9 CLKBUFX6AR9 CLKBUFX8AR9 CLKINVX12AR9 CLKINVX16AR9 CLKINVX[...]

set vars(enable_ss)                                false
set vars(flow)                                     mmmc
set vars(enable_ocv)                               pre_postcts


#######################################################################
# Define library sets ...
#-----------------------------------------------------------------
set vars(library_sets)                             "N40CSS1P08 25CTT1P2 N40CFF1P32"
#set vars(N40CSS1P08,si) ""
set vars(N40CSS1P08,timing) \
  "/home/Data1/Zhengpeng/work/Remcm_mini_sram3/DATA/ccs/M31GPSC900HL055PR_N40CSS1P08_cworst_ccs.lib \
    /home/Data1/Zhengpeng/work/Remcm_mini_sram3/DATA/nldm/M31GPIO1225HL055P_N40CSS1P08V2P97_nldm.lib \
    /home/Data1/Zhengpeng/work/Remcm_mini_sram3/DATA/Raochl_memory/asdrlspkb1p64x8cm2sw0/ss1p08vn40c/asdrlspkb1p64x8cm2sw0.lib \
    /home/Data1/Zhengpeng/work/Remcm_mini_sram3/DATA/Raochl_memory/asdrlspkb1p128x8cm4sw0/ss1p08vn40c/asdrlspkb1p128x8cm4sw0.lib \
    /home/Data1/Zhengpeng/work/Remcm_mini_sram3/DATA/Raochl_memory/sadslspkb2p128x42m4b2w0cp0d0t0/ss1p08vn40c/sadslspkb2p128x42m4b2w0cp0d0t0.lib"
#set vars(25CTT1P2,si) ""
set vars(25CTT1P2,timing) \
  "/home/Data1/Zhengpeng/work/Remcm_mini_sram3/DATA/ccs/M31GPSC900HL055PR_25CTT1P2_ctyp_ccs.lib \
    /home/Data1/Zhengpeng/work/Remcm_mini_sram3/DATA/nldm/M31GPIO1225HL055P_25CTT1P2V3P3_nldm.lib \
    /home/Data1/Zhengpeng/work/Remcm_mini_sram3/DATA/Raochl_memory/asdrlspkb1p64x8cm2sw0/tt1p2v25c/asdrlspkb1p64x8cm2sw0.lib \
    /home/Data1/Zhengpeng/work/Remcm_mini_sram3/DATA/Raochl_memory/asdrlspkb1p128x8cm4sw0/tt1p2v25c/asdrlspkb1p128x8cm4sw0.lib \
    /home/Data1/Zhengpeng/work/Remcm_mini_sram3/DATA/Raochl_memory/sadslspkb2p128x42m4b2w0cp0d0t0/tt1p2v25c/sadslspkb2p128x42m4b2w0cp0d0t0.lib"
#set vars(N40CFF1P32,si) ""
set vars(N40CFF1P32,timing) \
  "/home/Data1/Zhengpeng/work/Remcm_mini_sram3/DATA/ccs/M31GPSC900HL055PR_N40CFF1P32_cbest_ccs.lib \
    /home/Data1/Zhengpeng/work/Remcm_mini_sram3/DATA/nldm/M31GPIO1225HL055P_N40CFF1P32V3P63_nldm.lib \
    /home/Data1/Zhengpeng/work/Remcm_mini_sram3/DATA/Raochl_memory/asdrlspkb1p64x8cm2sw0/ff1p32vn40c/asdrlspkb1p64x8cm2sw0.lib \
    /home/Data1/Zhengpeng/work/Remcm_mini_sram3/DATA/Raochl_memory/asdrlspkb1p128x8cm4sw0/ff1p32vn40c/asdrlspkb1p128x8cm4sw0.lib \
    /home/Data1/Zhengpeng/work/Remcm_mini_sram3/DATA/Raochl_memory/sadslspkb2p128x42m4b2w0cp0d0t0/ff1p32vn40c/sadslspkb2p128x42m4b2w0cp0d0t0.lib"
