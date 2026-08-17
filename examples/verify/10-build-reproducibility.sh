#!/usr/bin/env bash
# 驗:同一份 .kit 檔,兩次建置不保證解出同一組版本。
# 對應 docs/common/10-packaging-and-release §6 第 1、3 條。
#
# 這是 L1 級的驗證——需要建置環境,但不需要啟動 Kit,所以門檻比多數條目低。
# 拿到環境時從這種開始最省事。
#
# 官方說解析取「the latest compatible versions of each extension, allowing for
# dynamic updates」,而相容是一個範圍(docs/common/02 §2)。範圍裡通常有很多版。
#
# 通過條件:兩台機器(或兩個時間點)解出的版本清單有差異。
#
# ⚠ 未在本 repo 執行過。

set -euo pipefail

: "${APP_ROOT:?請設定 APP_ROOT 指向 kit-app-template 專案根目錄}"
OUT="${OUT:-$(mktemp -d)}"

log() { printf '  %s\n' "$*"; }

# ---------------------------------------------------------------------------
# 解出來的版本清單
# ---------------------------------------------------------------------------
# 「安裝」就是把 zip 解壓進快取(docs/common/02 §4),所以快取目錄下的
# 目錄名通常帶版本號,可以直接盤點。
# TODO(未查證):registryCache 的實際位置。設定鍵是
# app/extensions/registryCache,建置產物的佈局要盤點過才知道。
snapshot_versions() {
    local dest="$1"
    : "${REGISTRY_CACHE:?請設定 REGISTRY_CACHE 指向 extension 快取目錄}"
    find "$REGISTRY_CACHE" -maxdepth 1 -mindepth 1 -printf '%f\n' \
        | sort > "$dest"
    log "盤點到 $(wc -l <"$dest") 個 extension → $dest"
}

# ---------------------------------------------------------------------------
section() { printf '\n== %s ==\n' "$*"; }

section "1. 建置"
log "跑:$APP_ROOT/repo.sh build"
( cd "$APP_ROOT" && ./repo.sh build ) 2>&1 | tail -20

section "2. 盤點這一次解出的版本"
snapshot_versions "$OUT/versions-now.txt"

# 正對照:清單是空的話,是「真的沒有 extension」還是「路徑找錯了」?
# 這兩件事長得一樣(docs/common/08 §4)。
if [ ! -s "$OUT/versions-now.txt" ]; then
    echo "中止:版本清單是空的。" >&2
    echo "REGISTRY_CACHE 可能指錯了——一個回空的查詢同時相容於" >&2
    echo "「真的沒有」與「我的查法有洞」。先確認那個路徑底下有東西。" >&2
    exit 2
fi

section "3. 比對"
BASELINE="${BASELINE:-}"
if [ -z "$BASELINE" ]; then
    cat <<EOF
  這是第一次跑,先留一份基準:

      cp $OUT/versions-now.txt <放進版控的位置>

  之後在「另一台空快取的機器」或「registry 更新過之後」再跑一次,
  帶 BASELINE=<那份基準> 進來比對。

  ⚠ 在同一台開發機重跑通常會得到一樣的結果,那不是反證——
     解析器偏好本地已下載的版本勝過遠端更新的(docs/common/02 §3)。
     正因為如此,「在我這台測過」對空快取的新機器沒有證明力。
EOF
else
    if diff -u "$BASELINE" "$OUT/versions-now.txt" > "$OUT/diff.txt"; then
        echo "  兩份清單相同。"
        echo "  這一輪沒有重現版本漂移——可能 registry 還沒有更新的相容版,"
        echo "  或者版本已經被釘死了。"
    else
        echo "  ⚠ 兩份清單不同:"
        sed -n '3,$p' "$OUT/diff.txt" | grep -E '^[+-]' | head -20 | sed 's/^/    /'
        echo
        echo "  待驗的斷言成立:同一份 .kit 檔解出了不同的版本組合,而兩次都合法。"
        echo "  處置見 docs/common/10 §4 的三道防線。"
    fi
fi

echo
echo "輸出留在:$OUT"
