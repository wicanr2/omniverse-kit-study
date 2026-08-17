#!/usr/bin/env bash
# 驗證腳本的共用部分。
#
# ⚠ 未在本 repo 執行過(本機不符合 Kit 的硬體需求,見 ../README.md)。
#
# 設計原則來自 docs/common/08-debugging:
#   - 每個列舉查詢先用一個確定存在的東西當試紙
#   - 試紙失敗就中止,不要拿壞掉的查法去產生結論
#   - 一次只改一個變數

set -euo pipefail

# ---------------------------------------------------------------------------
# 環境
# ---------------------------------------------------------------------------

# 指向 kit 執行檔。Isaac Sim 底下是 <isaac-sim-root>/kit/kit;
# kit-app-template 建出來的路徑不同,自行覆寫 KIT_BIN。
: "${KIT_BIN:?請設定 KIT_BIN 指向 kit 執行檔}"
: "${KIT_APP:=$(dirname "$0")/../minimal-app/my_company.my_app.kit}"

WORK="${WORK:-$(mktemp -d)}"

log()  { printf '  %s\n' "$*"; }
head_() { printf '\n== %s ==\n' "$*"; }

# 中止並說明為什麼。用在試紙失敗——這種情況下任何結論都不可信。
abort_untrustworthy() {
    printf '\n中止:%s\n' "$*" >&2
    printf '這代表查法有問題,不是待驗的東西不存在。先修查法。\n' >&2
    exit 2
}

# ---------------------------------------------------------------------------
# 跑一次 Kit,把 stdout/stderr 收進檔案
# ---------------------------------------------------------------------------
# 用法:run_kit <輸出檔> [額外參數...]
# --/app/quitAfter=<幀數> 跑滿指定幀數就離開主迴圈(官方旗標),
# 適合這種只要一份快照的用途。
run_kit() {
    local out="$1"; shift
    log "跑:$KIT_BIN $KIT_APP $*"
    "$KIT_BIN" "$KIT_APP" \
        --no-window \
        --/app/quitAfter=1 \
        "$@" >"$out" 2>&1 || true
    log "輸出:$out ($(wc -l <"$out") 行)"
}

# ---------------------------------------------------------------------------
# log 位置
# ---------------------------------------------------------------------------
# 官方:「The path to the log file is written to stdout among the first lines
# when Kit starts.」——所以從輸出的前幾行撈得到。
kit_log_path() {
    local out="$1"
    grep -m1 -oE '/[^ ]*\.log' "$out" || true
}

# ---------------------------------------------------------------------------
# 正對照
# ---------------------------------------------------------------------------
# 用法:assert_probe_found <輸出檔> <一個一定會出現的樣式> <這在驗什麼>
# 先確認「查得到本來就在的東西」,再去問待驗的那個。
assert_probe_found() {
    local out="$1" probe="$2" what="$3"
    if ! grep -qE "$probe" "$out"; then
        abort_untrustworthy "試紙樣式 '$probe' 在輸出裡找不到(驗的是:$what)"
    fi
    log "試紙通過:'$probe' 找得到"
}

# ---------------------------------------------------------------------------
# extension 的 startup / shutdown
# ---------------------------------------------------------------------------
# log 形狀(取自實測樣本,見 docs/common/02-extension-system §7):
#   [234.513s] [ext: some.extension-1.2.3] startup
#   [234.530s] [ext: some.extension-1.2.3] shutdown
ext_events() {
    local out="$1" ext="$2"
    grep -E "\[ext: ${ext}[^]]*\] (startup|shutdown)" "$out" || true
}

# 回傳 0 表示這個 extension 起來之後沒有馬上收掉。
ext_still_alive() {
    local out="$1" ext="$2"
    local ev; ev="$(ext_events "$out" "$ext")"
    [ -n "$ev" ] || return 1
    ! grep -q 'shutdown' <<<"$ev"
}
