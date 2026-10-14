# Innovus Tcl proc 集合说明

本说明专门面向 Cadence Innovus 环境中的 Tcl `proc`（过程函数）与脚本片段，重点筛选出适用于后端设计、floorplan、placement、routing、CTS 和 timing debug 的 reusable proc。

说明：
- 这里的“proc”指的是 Tcl 过程函数，通常可以在 Innovus shell 中直接调用。
- 目录下的脚本来自你之前整理过的公开 EDA 仓库，主要是与 Innovus/ICC2/PrimeTime 相关的 Tcl 代码。
- 本索引偏向“适合直接复用、改造和集成到自己的 Innovus 流程中的 proc”。

## 1. 关键 Innovus proc / script 列表

### 1.1 `nearest_flop_to_pin.tcl`
- 来源: `abdelazeem201/Tcl-Scripting-for-EDA`
- proc 名称: `nearest_flop_to_pin`
- 用途: 给定一个 pin，返回距离最近的 flop 及其距离（micron）
- 典型调用:
  - `nearest_flop_to_pin -pin <pin_name>`
- 关键逻辑:
  - 读取 pin bbox 中心
  - 遍历 `all_registers`
  - 计算欧式距离并保留最小值
- 适用阶段: placement debug / timing debug / floorplan check

### 1.2 `fanout_splitting_cui.tcl`
- 来源: `amaaaaandabla/split_fanout.tcl`
- proc 名称: `fix_fanout_cui`
- 用途: 高扇出 net 分割，插入 buffer 并重连下游 pin
- 典型调用:
  - `fix_fanout_cui <netName> <fanout_required> <Buffer_master_name>`
- 关键逻辑:
  - 遍历 fanout 节点
  - 断开连接
  - 创建 buffer 实例
  - 重新连接分组后的扇出
- 适用阶段: routing / optimization / fanout reduction

### 1.3 `mem_skew.tcl`
- 来源: `abdelazeem201/Tcl-Scripting-for-EDA`
- proc 名称: `mem_skew_icc2`
- 用途: 评估 memory 相关路径的 WNS/TNS，并分析是否值得做 skew 优化
- 典型调用:
  - `mem_skew_icc2 * *ram* false`
- 关键逻辑:
  - 检查 from/to memory 的 timing paths
  - 汇总 WNS/TNS
  - 输出内存实例级统计
- 适用阶段: timing / signoff / memory path analysis

### 1.4 `report_clock_ports.tcl`
- 来源: `abdelazeem201/Tcl-Scripting-for-EDA`
- proc 名称: `check_clock_port_widths`
- 用途: 检查 clock port 的几何宽度是否满足 layer 最小宽度要求
- 典型调用:
  - `check_clock_port_widths`
- 关键逻辑:
  - 读取 clocks 的 source port
  - 获取 shape 和 layer min width
  - 比较 actual width 与 required width
- 适用阶段: physical verification / clock port sanity check

### 1.5 `get_max_net_length.tcl`
- 来源: `abdelazeem201/Tcl-Scripting-for-EDA`
- proc 名称: `get_max_net_length`
- 用途: 统计设计中的最长信号 net（通常排除 power/ground）
- 典型调用:
  - `get_max_net_length`
- 关键逻辑:
  - 遍历 nets
  - 过滤 `power` / `ground`
  - 记录最大 `dr_length`
- 适用阶段: congestion / routing hotspot diagnosis

### 1.6 `timing_info_extraction.tcl`
- 来源: `abdelazeem201/Tcl-Scripting-for-EDA`
- proc/脚本类型: 命令脚本，非严格类 proc，但适合做运行时提取器
- 用途: 从 `report_timing` 输出中抽取 Startpoint / Endpoint / Path Group / Slack 等信息
- 典型调用:
  - 交互式运行，然后输入 `max_paths` 和 `delay_type`
- 适用阶段: timing report parsing / automated review

### 1.7 `useful_scripts.tcl`
- 来源: `abdelazeem201/Tcl-Scripting-for-EDA`
- 功能: 通用小 helper 集合，包含多个有用的脚本片段
- 关键用途:
  - 获取 floating PG pins
  - 提取 timing path 信息
  - 替换 path 上的 cell 类型
  - 清理 null shape / null via
- 适用阶段: debug / cleanup / repair / sanity checks

## 2. 可直接用作 Innovus 流程模板的脚本

这些脚本最适合作为 Innovus flow 模板或后端脚本骨架：

- `collected/flow/02_floorplan/floorplan.tcl`
- `collected/flow/02_floorplan/run_floor_planning.tcl`
- `collected/flow/02_floorplan/run_power_planning.tcl`
- `collected/flow/03_cts/run_cts.tcl`
- `collected/flow/04_placement/run_placement.tcl`
- `collected/flow/05_routing/run_route.tcl`
- `collected/flow/05_routing/mf.tcl`
- `collected/flow/06_timing/pt_timing.tcl`

这些脚本通常不是纯粹的单个 `proc`，而是更完整的 stage 脚本；它们适合在真正的 Innovus 的 `source` 流程中复用。

## 3. 最实用的 Innovus proc 结论

如果你的目标是“抓取最适合 Innovus 的 Tcl proc”，优先优先考虑以下几类：

- 物理 debug:
  - `nearest_flop_to_pin`
  - `get_max_net_length`
  - `check_clock_port_widths`

- routing / optimization:
  - `fix_fanout_cui`
  - `mf.tcl`
  - `mf_blk.tcl`

- timing / signoff:
  - `mem_skew_icc2`
  - `timing_info_extraction`
  - `pt_timing.tcl`

- general helper:
  - `useful_scripts.tcl`

## 4. 适合你当前工作的推荐整理方式

建议把这些脚本分成两大类：

- 一类：可直接导入 Innovus 的 stage 脚本
  - floorplan.tcl
  - run_placement.tcl
  - run_cts.tcl
  - run_route.tcl
  - pt_timing.tcl

- 二类：可复用 proc / helper
  - nearest_flop_to_pin
  - fix_fanout_cui
  - mem_skew_icc2
  - check_clock_port_widths
  - get_max_net_length

这两类组合起来，最适合做一个自己维护的 Innovus script 库。

## 5. 处理建议

- 不要直接把这些脚本全部当成运行文件，很多脚本有路径、库、工艺、设计名和工具版本依赖。
- 最好的使用方式是：先把其中 3～5 个最通用的 proc 拷到自己的脚本目录中，再加上你当前设计的参数和库路径。
- 对于工业流，最好做一个 `config.tcl`，统一维护 LEF/LIB/clock/tech 文件路径。

## 6. 结论

对你来说，最重要的理解是：
- `proc` 是 Tcl 的函数/过程；
- Innovus 中大量脚本本质上都可以视为 `proc` 或命令封装；
- 你真正需要的是“适合 Innovus 自动化流程的可复用过程函数”。

这也是为什么 `nearest_flop_to_pin`、`fix_fanout_cui`、`mem_skew_icc2` 等脚本最有价值：它们都属于“可在 Innovus shell 中运行并复用”的典型 proc。
