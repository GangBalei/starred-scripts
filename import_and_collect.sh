#!/usr/bin/env bash
set -euo pipefail

# import_and_collect.sh
# 说明：
# - GitHub 上“已加星/已关注”的公开 EDA Tcl 脚本仓库
# - 自动克隆并收集所有 .tcl 文件
# - 按 flow / tools / docs 结构放置
# - 并输出统计信息

TMP_DIR="tmp_starred_clone"
OUT_DIR="collected"
REPOS=(
  "NYU-MLDA/robust-pnr-time"
  "abdelazeem201/Tcl-Scripting-for-EDA"
  "amaaaaandabla/split_fanout.tcl"
  "wswslzp/AprScripts"
  "wswslzp/BackendScript"
)

mkdir -p "$TMP_DIR"
rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR/flow/01_synthesis" "$OUT_DIR/flow/02_floorplan" "$OUT_DIR/flow/03_cts" \
         "$OUT_DIR/flow/04_placement" "$OUT_DIR/flow/05_routing" "$OUT_DIR/flow/06_timing" \
         "$OUT_DIR/tools/tcl" "$OUT_DIR/docs"

for repo in "${REPOS[@]}"; do
  echo "Cloning $repo ..."
  short=$(basename "$repo")
  clone_to="$TMP_DIR/$short"
  rm -rf "$clone_to"
  git clone --depth 1 "https://github.com/$repo.git" "$clone_to" || {
    echo "克隆 $repo 失败，跳过";
    continue;
  }

  find "$clone_to" -type f -iname '*.tcl' | while read -r f; do
    fname=$(basename "$f")
    lower=$(echo "$fname" | tr '[:upper:]' '[:lower:]')
    dest=""

    case "$lower" in
      *synth*|*dc_*|*genus*|*compile*|*syn*) dest="$OUT_DIR/flow/01_synthesis" ;;
      *floorplan*|*fplan*|*fp*|*setup*|*macro*|*write* ) dest="$OUT_DIR/flow/02_floorplan" ;;
      *cts*|*ccopt*|*postcts*|*prects*|*clock* ) dest="$OUT_DIR/flow/03_cts" ;;
      *place*|*placement*|*nearest_flop*|*macro* ) dest="$OUT_DIR/flow/04_placement" ;;
      *route*|*routing*|*fanout*|*mf*|*metalfill* ) dest="$OUT_DIR/flow/05_routing" ;;
      *timing*|*pt_*|*timing_info*|*mem_skew*|*get_max_net_length*|*report_clock* ) dest="$OUT_DIR/flow/06_timing" ;;
      *) dest="$OUT_DIR/tools/tcl" ;;
    esac

    mkdir -p "$dest/$short"
    cp "$f" "$dest/$short/$fname"
    echo "  -> $dest/$short/$fname"
  done

done

echo "分类完成，结果在 $OUT_DIR 下："
find "$OUT_DIR" -maxdepth 3 -type f | sed 's/^/  /'

echo "注意：分类基于文件名关键词，部分脚本可能需要人工复核后移动到更合适的目录。"
