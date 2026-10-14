# EDA Tcl 脚本索引与说明

本文档为 `starred-scripts` 仓库的详细脚本索引，旨在方便按后端设计流程快速定位和复用 Tcl 脚本、proc 与辅助工具。

## 目录概览

- `collected/flow/01_synthesis/`  — 综合（Synthesis）脚本
- `collected/flow/02_floorplan/`  — Floorplan / powerplan / macro placement
- `collected/flow/03_cts/`       — CTS / clock tree 相关脚本
- `collected/flow/04_placement/` — Placement 相关脚本与 helper
- `collected/flow/05_routing/`   — Routing / fanout / metal fill / netlist output
- `collected/flow/06_timing/`    — Timing 报表提取、PT、memory skew、clock port 检查
- `collected/tools/tcl/`         — 通用 utility 脚本

## 1. 综合脚本（Synthesis）

### 1.1 `dc_synthesis.tcl`
- 来源: `NYU-MLDA/robust-pnr-time`
- 用途: 在 Synopsys Design Compiler 中做综合，输出综合后网表、SDC 与 timing report
- 关键动作:
  - `analyze -format sverilog -vcs "-f ${FILE_LIST}"`
  - `elaborate ${TOP_DESIGN}`
  - `compile_ultra`
  - `report_timing`
  - `write -format verilog ...`
  - `write_sdc ...`
- 适用场景: 传统 DC 流程，适合做逻辑综合与前端时序估计
- 备注: 依赖 Synopsys 工具与库路径配置，通常需要 `config.tcl` 和实际标准单元库

### 1.2 `genus_synthesis.tcl`
- 来源: `NYU-MLDA/robust-pnr-time`
- 用途: Cadence Genus 综合脚本，输出 synthesized verilog 与 SDC
- 关键动作:
  - `read_hdl -f ${DESIGN}`
  - `elaborate ${TOP_DESIGN}`
  - `syn_gen`, `syn_map`, `syn_opt`
  - `write_hdl -lec`
  - `write_design -innovus ...`
- 适用场景: Genus 设计流对接 Innovus
- 备注: 适合做 RTL -> netlist -> PNR 的标准化流水线

### 1.3 `genus_aspdac.tcl`
- 来源: `NYU-MLDA/robust-pnr-time`
- 用途: 类似 Genus 综合脚本，但额外输出多个路径组的 timing 报表
- 关键特点:
  - `report_timing -from [all_registers] -to [all_registers] ...`
  - `report_timing -from [all_inputs] -to [all_registers] ...`
  - `report_timing -from [all_registers] -to [all_outputs] ...`
  - `report_timing -from [all_inputs] -to [all_outputs] ...`
- 适用场景: 需要汇总 reg2reg、in2reg、reg2out、in2out 的路径分析

## 2. Floorplan / Powerplan / Macro 相关

### 2.1 `floorplan.tcl`
- ���源: `wswslzp/AprScripts`
- 用途: 典型 floorplan 脚本，包含 floorPlan、planDesign、addRing、addStripe、IO filler 等布局步骤
- 关键动作:
  - `floorPlan -site ...`
  - `planDesign`
  - `addHaloToBlock ...`
  - `addRing -nets ...`
  - `addIoFiller ...`
- 适用场景: 核心 floorplan 初始化和电源网格建设
- 备注: 脚本中包含大量工艺相关参数，适合做模板而非直接复制粘贴

### 2.2 `setup.tcl`
- 来源: `wswslzp/AprScripts`
- 用途: 流程配置文件，集中定义库、工艺、LEF、SDC、power net、corners 等
- 典型变量:
  - `vars(lef_files)`
  - `vars(netlist)`
  - `vars(design)`
  - `vars(power_nets)`
  - `vars(ground_nets)`
  - `vars(delay_corners)`
  - `vars(active_setup_views)`
- 适用场景: 编排整体 PNR 流程配置，作为其他脚本的基础文件

### 2.3 `floorplan_details.tcl`
- 来源: `abdelazeem201/Tcl-Scripting-for-EDA`
- 用途: 输出当前 design 的 boundary、side length、core offset 等 floorplan 统计信息
- 关键逻辑:
  - 获取 `boundary` 与 `core_area_boundary`
  - 计算边长、偏移和总边界信息
- 适用场景: floorplan 质量检查、自动报告、review 文档

### 2.4 `run_floor_planning.tcl`
- 来源: `wswslzp/BackendScript`
- 用途: 一个更完整的 floorplan 脚本，通常用于宏分区、RAM placement 和 halo 处理
- 关键动作:
  - `loadIoFile ...`
  - `setObjFPlanBox ...`
  - `relativeFPlan --place ...`
  - `addHaloToBlock ...`
- 适用场景: 多 power domain 背景下的 floorplan 标定

### 2.5 `run_power_planning.tcl`
- 来源: `wswslzp/BackendScript`
- 用途: 电源规划脚本，创建 power switch、ring 与 stripe
- 关键动作:
  - `addPowerSwitch ...`
  - `addRing ...`
  - `addStripe ...`
- 适用场景: 供电完整性与 power domain 设计

## 3. CTS 脚本

### 3.1 `run_cts.tcl`
- 来源: `wswslzp/BackendScript`
- 用途: 完整 CTS 流程，包括 clock tree synthesis 和 post-CTS hold 优化
- 关键动作:
  - `set_ccopt_property buffer_cells ...`
  - `set_ccopt_property inverter_cells ...`
  - `ccopt_design`
  - `optDesign -postCTS -hold`
- 适用场景: 主流程一般时钟树合成

### 3.2 `preCTS_Opt.tcl`
- 来源: `wswslzp/BackendScript`
- 用途: pre-CTS 优化脚本，用于报告 always-on buffer、恢复可用 buffer / inverter，并关闭不需要的 dont-use
- 关键动作:
  - `setOptMode -resizeShifterAndIsoInsts true`
  - `reportAlwaysOnBuffer -all -verbose`
  - `setDontUse CLKBUF* true`
  - `setDontUse DLY* true`
- 适用场景: 早期 CTS 之前的 buffer 评估和优化准备

## 4. Placement / Macro / Helper

### 4.1 `run_placement.tcl`
- 来源: `wswslzp/BackendScript`
- 用途: placement 阶段脚本，执行 `place_opt_design`，添加 tie hi/lo，并进行 power domain 校验
- 关键动作:
  - `setPlaceMode ...`
  - `place_opt_design`
  - `addTieHiLo ...`
  - `checkPlace`
  - `verifyPowerDomain ...`
- 适用场景: placement 与 power domain 约束检查

### 4.2 `macros.tcl`
- 来源: `abdelazeem201/Tcl-Scripting-for-EDA`
- 用途: 自动导出 macro 的位置，生成 `macro.tcl` 复位脚本
- 关键动作:
  - 遍历 hard macro
  - 获取 `origin`, `bbox`, `orientation`
  - 输出 `set_cell_location -coordinates ...`
- 适用场景: 物理布局复现、macro placement 最终化

### 4.3 `nearest_flop_to_pin.tcl`
- 来源: `abdelazeem201/Tcl-Scripting-for-EDA`
- 用途: 按 pin 查找最近的 flop，返回 `(flop_name, distance)`
- 示例:
  - `nearest_flop_to_pin -pin <pin_name>`
- 关键逻辑:
  - 取 pin bbox 中心
  - 取每个 flop bbox 中心
  - 计算欧式距离
  - 记录最小值
- 适用场景: debug placement、查看关键网络与寄存器的电学/物理距离

## 5. Routing / Fanout / Metal Fill

### 5.1 `run_route.tcl`
- 来源: `wswslzp/BackendScript`
- 用途: 典型 route + postroute optimize 流程
- 关键动作:
  - `routePGPinUseSignalRoute`
  - `verifyConnectivity ...`
  - `routeDesign`
  - `optDesign -postRoute`
- 适用场景: 整体 routing 完成与较后阶段优化

### 5.2 `fanout_splitting_cui.tcl`
- 来源: `amaaaaandabla/split_fanout.tcl`
- 用途: 分割高扇出 net，插入 buffer，并重新连接 fanout
- 关键 proc:
  - `fix_fanout_cui {net fanout cellname {prefix fix_fanout}}`
- 适用场景: 降低高扇出导致的驱动能力/时序问题
- 备注: 这是一个很典型的物理优化脚本，适合参考实现思路

### 5.3 `mf.tcl`
- 来源: `wswslzp/AprScripts`
- 用途: 执行 metal fill 设置、via fill 和 density verification
- 关键动作:
  - `setMetalFill ...`
  - `addViaFill ...`
  - `addMetalFill ...`
  - `verifyMetalDensity ...`
- 适用场景: 后端 signoff 前的 metal fill 与 density 处理

### 5.4 `mf_blk.tcl`
- 来源: `wswslzp/AprScripts`
- 用途: 为 sram / macro 周围创建路由阻塞（route block）以避免 metal fill 干扰
- 关键动作:
  - 读取 `top.insts {.isHaloBlock==1}`
  - 计算扩展 box
  - 使用 `createRouteBlk -box ... -layer all -fills`
- 适用场景: memory 周围金属填充控制

### 5.5 `write.tcl`
- 来源: `wswslzp/AprScripts`
- 用途: 输出 netlist、SDF 等后端文件
- 关键动作:
  - `saveNetlist ...`
  - 可视需求启用 `write_sdf`
- 适用场景: 生成给后续验证/LEC 的输出

## 6. Timing / Signoff / Timing Check

### 6.1 `pt_timing.tcl`
- 来源: `NYU-MLDA/robust-pnr-time`
- 用途: PrimeTime timing check 和 report generation
- 关键动作:
  - `read_verilog ...`
  - `create_clock ...`
  - `read_parasitics -format spef ...`
  - `report_timing ...`
- 适用场景: post-route 评估与 timing signoff

### 6.2 `timing_info_extraction.tcl`
- 来源: `abdelazeem201/Tcl-Scripting-for-EDA`
- 用途: 从 `report_timing` 输出中提取 Startpoint、Endpoint、Path Group、Fanout Nets 和 Slack
- 适用场景: 自动化整理 timing summary
- 备注: 脚本中使用 `gets stdin` 进行交互，适合改造成 CI 或批量自动化脚本

### 6.3 `mem_skew.tcl`
- 来源: `abdelazeem201/Tcl-Scripting-for-EDA`
- 用途: 分析 memory macro 到/从其它寄存器的 WNS / TNS，用判断是否适合 clock skew 优化
- 关键 proc:
  - `mem_skew_icc2 {inst_pattern lib_pattern neg_only}`
- 适用场景: 稍高层次的时序优化与 skew 评估

### 6.4 `report_clock_ports.tcl`
- 来源: `abdelazeem201/Tcl-Scripting-for-EDA`
- 用途: 检查 clock port 宽度是否满足 layer 最小 width 要求
- 关键逻辑:
  - 读取 clock source 的 shape
  - 获取 layer min_width
  - 比较 port width 与 required width
- 适用场景: 物理实现前后端口几何检查

### 6.5 `get_max_net_length.tcl`
- 来源: `abdelazeem201/Tcl-Scripting-for-EDA`
- 用途: 获取设计中最最长的信号 net（排除 power/ground）
- 适用场景: routing hotspot 或长线问题排查

## 7. 通用工具脚本

### 7.1 `useful_scripts.tcl`
- 来源: `abdelazeem201/Tcl-Scripting-for-EDA`
- 用途: 实用小脚本集合，包括：
  - 获取 floating PG pins
  - 从 timing report 中抽取 timing 信息
  - 替换特定 path 上的 cell 类型
  - 清理 null shape / via
- 适用场景: 工程上的调试辅助和快速脚本集合

## 8. 使用建议

### 8.1 实际运行前
- 确认工艺库、LEF、LIB、SDC 和设计路径都存在
- 确认工具环境中有对应的 EDA 软件（Innovus / Genus / DC / PrimeTime）
- 对于很多脚本，直接运行前需要根据当前设计参数替换路径与命名

### 8.2 适合作为模板的脚本
对后端工程师来说，优先适合作为工程模板参考的是：
- `floorplan.tcl`
- `run_power_planning.tcl`
- `run_placement.tcl`
- `run_cts.tcl`
- `run_route.tcl`
- `nearest_flop_to_pin.tcl`
- `mem_skew.tcl`
- `report_clock_ports.tcl`

### 8.3 适合作为脚本学习对象
- `fanout_splitting_cui.tcl`
- `macros.tcl`
- `timing_info_extraction.tcl`
- `useful_scripts.tcl`

## 9. 备注

- 这些脚本来源于公开 GitHub 仓库，保留原作者信息与许可证要求。
- 许多脚本依赖厂商命令，因此不保证在任意环境中直接可运行。
- 大多数脚本更适合做“模板/参考实现”，而不是开箱即用的执行文件。

## 10. 后续扩展建议

建议后续把这些脚本继续分成两类：
- “可直接复用模板”：用于实际后端流程中的 stage 脚本
- “题库/参考脚本”：用于学习和 debug 的技术实现示例

这样更容易在未来做脚本维护、版本化升级和 AI-assisted optimization。
