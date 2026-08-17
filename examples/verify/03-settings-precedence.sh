#!/usr/bin/env bash
# 驗:五個設定入口碰在一起時誰贏。
# 對應 docs/common/03-carb-settings §8 第 4 條。
#
# 為什麼要自己量:本 repo 查過 kit-manual 的 Configuration 頁、dev-guide 的
# Settings 頁、Extensions in-depth 頁,都沒有找到一段完整陳述優先序的文字。
# 找到的是分散的片段,拼不出一張表。
#
# 方法:單變數對照。一次只改一個入口,看最後留下的是哪一個值,兩兩比較排出全序。
#
# ⚠ 未在本 repo 執行過。

set -euo pipefail
source "$(dirname "$0")/lib.sh"

# 拿來當白老鼠的鍵。挑一個沒有人會用到的路徑,避免撞到真的設定。
: "${PROBE_KEY:=/exts/verify.probe/value}"

DUMP="$(dirname "$0")/_dump_setting.py"

# ---------------------------------------------------------------------------
# 讀值的腳本
# ---------------------------------------------------------------------------
# 官方說明:「You can interact with App, Extension, and User settings using the
# ISettings interface from the carb.settings module.」
# TODO(未查證):取得 ISettings 與讀單一鍵的確切函式名。以手上版本的
# carb.settings API 文件為準,補完下面這支再跑。
cat >"$DUMP" <<'PY'
import sys
# TODO(未查證):換成手上版本的正確寫法
# import carb.settings
# settings = carb.settings.<取得 ISettings 的方式>
# value = settings.<讀單一鍵的方式>(sys.argv[1] if len(sys.argv) > 1 else "")
value = "TODO"
print(f"PROBE_RESULT {value}", flush=True)
PY

read_setting() {
    local out="$1"; shift
    run_kit "$out" --exec "$DUMP $PROBE_KEY" "$@"
    grep -m1 -oE 'PROBE_RESULT .*' "$out" | cut -d' ' -f2- || echo "(讀不到)"
}

# ---------------------------------------------------------------------------
head_ "0. 正對照:確認讀得到一個我們剛設的值"
base="$(read_setting "$WORK/probe.log" "--$PROBE_KEY=SENTINEL")"
log "讀到:$base"
if [ "$base" != "SENTINEL" ]; then
    abort_untrustworthy "命令列剛設的 SENTINEL 都讀不回來(讀到:$base)"
fi

# ---------------------------------------------------------------------------
head_ "1. 命令列 vs .kit 檔"
echo "  把同一個鍵寫進 $KIT_APP 的 [settings],再用命令列給不同的值。"
echo "  留下來的是哪一個,哪一個就贏。"
echo "  TODO:先手動在 .kit 檔加上 exts.\"verify.probe\".value = \"FROM_KIT\""
cli="$(read_setting "$WORK/cli.log" "--$PROBE_KEY=FROM_CLI")"
log "結果:$cli"

# ---------------------------------------------------------------------------
head_ "2. 環境變數 vs 命令列"
echo "  TODO(未查證):設定樹對應的環境變數命名規則。"

# ---------------------------------------------------------------------------
head_ "3. /persistent 的殘留"
echo "  /persistent 底下的值會自動存進使用者設定檔,下次啟動載回"
echo "  (docs/common/03 §6)。所以量之前要先確認沒有殘留的舊值,"
echo "  否則會量到上一輪自己寫進去的東西。"
persist="$(read_setting "$WORK/persist.log" "--/persistent${PROBE_KEY}=STICKY")"
log "第一次:$persist"
persist2="$(read_setting "$WORK/persist2.log")"
log "重開後不給值:$persist2  ← 還在的話就證實了跨 session 留存"

# ---------------------------------------------------------------------------
head_ "填表"
cat <<'TABLE'
  兩兩比完之後填這張,補回 docs/common/03 §7:

  | 入口                    | 排名 |
  |-------------------------|------|
  | 命令列 --/...=          |      |
  | 環境變數                |      |
  | .kit 檔的 [settings]    |      |
  | extension.toml 的 [settings] |  |
  | 使用者設定檔            |      |

  ⚠ 讀得到那個值,不代表 runtime 真的照它跑。要證明生效,
     設一個大到行為必然改變的極端值,看行為有沒有跟著變。
TABLE

echo "輸出留在:$WORK"
