#!/usr/bin/env bash
# 驗:啟用回傳成功,不代表 extension 還活著。
# 對應 docs/common/02-extension-system §8 第 6 條(整份清單裡最該優先做的一條)。
#
# 為什麼優先:它決定後面每一篇「怎麼證明某個東西生效了」的寫法。
# 在驗到之前,本 repo 對 extension 是否生效一律只採信能力查詢,不採信回傳值。
#
# 通過條件:啟用的回傳是成功的,而 log 裡緊接著出現該 extension 的 shutdown。
#
# ⚠ 未在本 repo 執行過。

set -euo pipefail
source "$(dirname "$0")/lib.sh"

# 要觀察的兩個 extension:
#   PROBE — 確定會正常起來的,當試紙
#   TARGET — 待驗的。想重現「起來又收掉」,挑一個相依不滿足的
: "${PROBE_EXT:=omni.kit.uiapp}"
: "${TARGET_EXT:?請設定 TARGET_EXT 為一個相依不滿足的 extension 名}"

head_ "1. 基準:不啟用任何額外 extension"
run_kit "$WORK/base.log"

# 正對照:先確認我們抓 log 的方式是對的。
# 抓不到一個確定會出現的 extension 事件,代表樣式或 log 位置有問題,
# 這時候「TARGET 沒出現」完全不能當證據。
assert_probe_found "$WORK/base.log" '\[ext: ' "extension 事件的 log 樣式"

head_ "2. 啟用試紙 extension"
run_kit "$WORK/probe.log" --enable "$PROBE_EXT"
log "事件:"; ext_events "$WORK/probe.log" "$PROBE_EXT" | sed 's/^/    /'
if ext_still_alive "$WORK/probe.log" "$PROBE_EXT"; then
    log "試紙 $PROBE_EXT:起來且沒有收掉 ✓"
else
    abort_untrustworthy "試紙 $PROBE_EXT 自己就沒活著,無法用它當對照"
fi

head_ "3. 啟用待驗 extension"
run_kit "$WORK/target.log" --enable "$TARGET_EXT"
log "事件:"; ext_events "$WORK/target.log" "$TARGET_EXT" | sed 's/^/    /'

head_ "判定"
if ext_still_alive "$WORK/target.log" "$TARGET_EXT"; then
    echo "  $TARGET_EXT 起來之後沒有收掉 —— 這一輪沒有重現該現象。"
    echo "  換一個相依確實不滿足的 extension 再試。"
else
    echo "  $TARGET_EXT 起來之後隨即 shutdown。"
    echo "  ⚠ 這就是待驗的現象:呼叫端拿到的回傳是成功的,理由只寫在 log 裡。"
    echo "  結論:生效證明要看能力在不在,不看回傳值。"
fi

echo
echo "log 檔:$(kit_log_path "$WORK/target.log")"
echo "輸出留在:$WORK"

# TODO(未查證):再加一段從 Python 側取啟用回傳值的對照,
# 才能把「回傳成功」與「已經收掉」擺在同一份輸出裡。
# 需要確認手上版本 extension manager 的 Python API 名稱。
