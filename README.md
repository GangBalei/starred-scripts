# 数字后端 Tcl 脚本集合

这个仓库收集并整理了多个公开 EDA/Tcl 仓库中的脚本，重点覆盖数字后端工程中常见的流程：

- synthesis
- floorplan / powerplan
- CTS
- placement
- routing
- timing / signoff

目录结构

- collected/
  - flow/
    - 01_synthesis/
    - 02_floorplan/
    - 03_cts/
    - 04_placement/
    - 05_routing/
    - 06_timing/
  - tools/
    - tcl/
  - docs/

主要脚本来源

- NYU-MLDA/robust-pnr-time
- abdelazeem201/Tcl-Scripting-for-EDA
- amaaaaandabla/split_fanout.tcl
- wswslzp/AprScripts
- wswslzp/BackendScript

如何使用

1. 拉取此仓库后，执行：

   chmod +x import_and_collect.sh
   ./import_and_collect.sh

2. 生成的脚本会放到 collected/ 目录下，并按 flow / tools 结构分类。

3. 这些脚本通常依赖 Cadence/ Synopsys/ Innovus / ICC2 / PrimeTime 等专业工具，建议在真实 EDA 环境中执行；如果只是本地查看，优先做静态检查。

静态检查建议

- Tcl 语法：
  tclsh script.tcl
- Shell：
  shellcheck import_and_collect.sh

注意事项

- 很多脚本是拿来参考或复用的，不保证直接可运行于你的环境。
- 若需要在真实设计中使用，请先确认工艺库、路径与工具版本一致。
- 这套分类依赖文件名关键词，因此少数脚本可能需要人工复核后移动到更合适目录。

关键脚本说明（示例）

- nearest_flop_to_pin.tcl
  - 用途：给定一个 pin，查找设计中离它最近的 flop，并返回其名字和距离。
  - 典型应用：placement debug、时序排查、floorplan 检查。
  - 关键实现：遍历 all_registers，提取 bbox 中心，计算欧氏距离，记录最小值。

- run_power_planning.tcl
  - 用途：为 power domain 添加 power switches、ring、stripe，并进行电源完整性相关检查。
  - 典型应用：后端 power planning 阶段。

- fanout_splitting_cui.tcl
  - 用途：自动分割高扇出 net，增加 buffer，减小 fanout。
  - 典型应用：时序驱动的 net optimization，或者修正高扇出。

- timing_info_extraction.tcl
  - 用途：从 report_timing 输出中提取 startpoint / endpoint / path group / slack 等信息。
  - 典型应用：自动化整理 timing 报表。

- mem_skew.tcl
  - 用途：分析 RAM 宏相关的 WNS/TNS，评估是否值得做 memory skew 优化。
  - 典型应用：高级时序优化。

- pt_timing.tcl
  - 用途：PrimeTime 读取 parasitics 并生成 timing report。
  - 典型应用：post-route timing signoff。

- report_clock_ports.tcl
  - 用途：检查 clock port 宽度是否满足 layer 最小宽度要求。
  - 典型应用：物理设计中的收口 / DRC 审核。

后续建议

- 建议在真实环境中搭配 innovus / genus / dc / prime time 工具执行。
- 可将这些脚本再进一步整理成：
  - 可复用 proc 库
  - 工艺模板
  - flow 模板（floorplan, placement, cts, route）

本仓库适合做：

- 原型脚本收集
- 后端脚本复用
- EDA 参数模板整理
- 版本管理和 AI/LLM 代码索引
