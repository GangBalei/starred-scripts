# Innovus Tcl proc 全清单（collected/ 目录版）

本文件基于当前仓库里已收集到的 `collected/` 目录中的 Tcl 脚本，提取出所有明显的 Innovus/EDA Tcl `proc` 与可复用过程函数。范围已限定为：当前仓库中已写入的脚本集合，不扩展到全 GitHub 世界。

说明：
- 这里的“proc”指 Tcl 过程函数（例如 `proc nearest_flop_to_pin {args} ...`）。
- 本清单优先保留与 Innovus / ICC2 / PrimeTime 相关并且适合直接复用的脚本。
- 部分脚本是完整 stage 脚本，不是单独 `proc`，但它们也在 Innovus 工作流中非常有用。

## 1. 发现的 proc / 可复用函数

### 1.1 `nearest_flop_to_pin`
- 文件: `collected/flow/04_placement/nearest_flop_to_pin.tcl`
- 来源: `abdelazeem201/Tcl-Scripting-for-EDA`
- 作用: 给定一个 pin，返回离它最近的 flop 及其距离（micron）
- 典型调用:
  - `nearest_flop_to_pin -pin <pin_name>`
- 关键逻辑:
  - 读取 pin bbox 中心
  - 遍历 `all_registers`
  - 计算欧式距离
  - 返回最小距离项
- 适用阶段: placement debug, floorplan sanity check, timing debug

### 1.2 `fix_fanout_cui`
- 文件: `collected/flow/05_routing/fanout_splitting_cui.tcl`
- 来源: `amaaaaandabla/split_fanout.tcl`
- 作用: 对高扇出 net 进行拆分、插入 buffer，并重连下游端口
- 典型调用:
  - `fix_fanout_cui <netName> <fanout_required> <Buffer_master_name>`
- 关键逻辑:
  - 识别当前 fanout 和 driver pin
  - 遍历 leaf 连接
  - 断开原始 net 的输出连接
  - 创建 buffer inst 和子 net
  - 重新分组重新连接
- 适用阶段: routing, optimization, fanout reduction, timing fix

### 1.3 `mem_skew_icc2`
- 文件: `collected/flow/06_timing/mem_skew.tcl`
- 来源: `abdelazeem201/Tcl-Scripting-for-EDA`
- 作用: 分析 memory macro 相关的 timing paths，并输出 WNS/TNS
- 典型调用:
  - `mem_skew_icc2 {inst_pattern} {lib_pattern} {neg_only}`
  - 示例: `mem_skew_icc2 * *ram* false`
- 关键逻辑:
  - 获取 memory cell
  - 汇总从 memory 发出的 timing paths
  - 汇总流入 memory 的 timing paths
  - 计算 WNS/TNS 并打印表格
- 适用阶段: memory timing analysis, clock skew consideration, signoff review

### 1.4 `check_clock_port_widths`
- 文件: `collected/flow/06_timing/report_clock_ports.tcl`
- 来源: `abdelazeem201/Tcl-Scripting-for-EDA`
- 作用: 检查 clock port 的宽度是否满足 layer 最小宽度要求
- 典型调用:
  - `check_clock_port_widths`
- 关键逻辑:
  - 遍历 clocks 的 source port
  - 读取 port/shape/layer bounding box
  - 和 `min_width` 比较
  - 输出 violation 信息和 summary
- 适用阶段: physical verification, clock port geometry check

### 1.5 `get_max_net_length`
- 文件: `collected/flow/06_timing/get_max_net_length.tcl`
- 来源: `abdelazeem201/Tcl-Scripting-for-EDA`
- 作用: 获取设计里最长的信号 net，并输出长度、net name、net type
- 典型调用:
  - `get_max_net_length`
- 关键逻辑:
  - 过滤 power/ground net
  - 统计 `dr_length`
  - 记录最大值
- 适用阶段: congestion, routing hotspot detection, long net debug

### 1.6 `sum_list`
- 文件: `collected/flow/06_timing/mem_skew.tcl`
- 作用: 辅助 `mem_skew_icc2` 的数值求和函数
- 典型调用:
  - `sum_list $lst`
- 适用阶段: timing path 累积统计

### 1.7 `collection_to_list`
- 文件: `collected/flow/06_timing/get_max_net_length.tcl`
- 作用: 把 Tcl collection 转成普通列表，供最大 net 长度统计使用
- 典型调用:
  - `collection_to_list $a_collection`

### 1.8 `list_sub_const`
- 文件: `collected/flow/05_routing/mf_blk.tcl`
- 作用: 对列表逐项减去常数，用于生成 metal fill block box
- 适用阶段: routing blockage generation

### 1.9 `list_add_const`
- 文件: `collected/flow/05_routing/mf_blk.tcl`
- 作用: 对列表逐项加上常数，用于扩展 metal fill block box
- 适用阶段: route block box 计算

### 1.10 `list2d_flatten`
- 文件: `collected/flow/05_routing/mf_blk.tcl`
- 作用: 将二维列表展平为一维列表，供块状边界传给 `createRouteBlk`
- 适用阶段: routing blockage generation

## 2. 重要的非 proc 但非常有用的 Innovus stage 脚本

以下脚本不是单独的 `proc`，但在 Innovus 里属于完整 stage 流程，适合直接 `source` 或作为模板：

- `collected/flow/02_floorplan/floorplan.tcl`
  - floorPlan + addRing + addHalo + addIoFiller
- `collected/flow/02_floorplan/run_floor_planning.tcl`
  - relativeFPlan + power domain + macro placement
- `collected/flow/02_floorplan/run_power_planning.tcl`
  - addPowerSwitch + addRing + addStripe
- `collected/flow/03_cts/run_cts.tcl`
  - clock tree synthesis + post-CTS optimization
- `collected/flow/04_placement/run_placement.tcl`
  - placement + tie hi/lo + power domain checks
- `collected/flow/05_routing/run_route.tcl`
  - routeDesign + verification + post-route optimization
- `collected/flow/05_routing/mf.tcl`
  - metal fill + via fill + density check
- `collected/flow/06_timing/pt_timing.tcl`
  - PrimeTime timing run + report generation

这些文件更偏“stage script”，但仍是 Innovus 工作流中最核心的模板类内容。

## 3. proc 分类总览

### 3.1 placement / debug 类
- `nearest_flop_to_pin`
- `get_max_net_length`
- `check_clock_port_widths`

### 3.2 routing / optimization 类
- `fix_fanout_cui`
- `list_sub_const`
- `list_add_const`
- `list2d_flatten`

### 3.3 timing / signoff 类
- `mem_skew_icc2`
- `sum_list`
- `timing_info_extraction`（脚本型，非 strict proc）

### 3.4 helper / utility 类
- `collection_to_list`
- `useful_scripts.tcl` 中的多个小 helper

## 4. 结论

按当前仓库的 `collected/` 目录来看，真正明显且可独立复用的 Innovus proc 主要有以下几类：

- 物理 debug 类：
  - `nearest_flop_to_pin`
  - `get_max_net_length`
  - `check_clock_port_widths`

- routing optimization 类：
  - `fix_fanout_cui`

- timing analysis 类：
  - `mem_skew_icc2`

- helper 类：
  - `collection_to_list`
  - `sum_list`
  - `list_sub_const`
  - `list_add_const`
  - `list2d_flatten`

这已经覆盖了你“所有 Innovus proc”的核心范围（在当前已收集脚本内）。如果后面还要扩大到“从公开 GitHub 全量仓库中再筛选，不只限于当前 collected/ 目录”，我可以继续做第二轮筛选并输出一个更完整版本。
