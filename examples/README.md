# examples

把各篇的待驗清單變成可以直接跑的東西。

> **這裡的腳本沒有在本 repo 執行過。** 本機不符合 Kit 的官方硬體需求(見下),所以它們是骨架:結構、正對照、判準都寫好了,`TODO(未查證)` 標記的地方要用手上版本的 API 文件補完。**不要假設貼上去就會動。**

## 跑這些東西需要什麼機器

`kit-app-template` 的官方需求逐字:

| 項目 | 要求 |
|---|---|
| GPU | "NVIDIA RTX capable GPU (RTX 3070 or Better recommended)" |
| 驅動 | "This update requires driver version >=550.54.15 (Linux) or >=551.78 (Windows)" |
| OS | "Windows 10/11 or Linux (Ubuntu 22.04 or newer)" |
| 網路 | "Required for downloading the Omniverse Kit SDK, extensions, and tools" |

**官方沒有說建置本身需不需要 GPU**,只明確把 RTX GPU 列為系統需求。所以「在沒有 NVIDIA GPU 的機器上能不能建置、能不能啟動一個極簡 `.kit`」目前是未知數,不要當成可行方案來規劃。

## 待驗條目要什麼等級的環境

53 條待驗清單不是同一個門檻。分四級:

| 級 | 需要什麼 | 涵蓋哪些 |
|---|---|---|
| **L0** | 只要能上網 | 版本對應、release notes 比對。已在 [version-matrix](../docs/version-matrix.md) 做掉 |
| **L1** | Kit SDK,但不必啟動 | 盤點 build 產物、檢查 `.kit` 檔內容、比對兩次建置解出的版本清單 |
| **L2** | 能啟動 Kit | extension 解析與生命週期、settings 優先序、log channel、`--exec` 順序、OmniGraph 求值次數 |
| **L3** | 能啟動且要算圖 | 渲染、材質、串流、`--no-window` 的 GPU 用量對照 |

按篇對應:

| 篇 | 條數 | 主要落在 |
|---|---|---|
| [02 extension](../docs/common/02-extension-system/README.md) | 6 | L1–L2 |
| [03 carb settings](../docs/common/03-carb-settings/README.md) | 6 | L2 |
| [04 USD 與 Fabric](../docs/common/04-usd-stage-and-fabric/README.md) | 5 | L2(第 3、4 條需 FSD,可能落到 L3) |
| [05 OmniGraph](../docs/common/05-omnigraph/README.md) | 6 | L2 |
| [06 執行模式](../docs/common/06-run-modes/README.md) | 6 | L3 |
| [07 渲染與材質](../docs/common/07-rendering-and-materials/README.md) | 5 | L3 |
| [08 除錯](../docs/common/08-debugging/README.md) | 5 | L2 |
| [09 omni.ui](../docs/common/09-omni-ui/README.md) | 4 | L2 |
| [10 打包發佈](../docs/common/10-packaging-and-release/README.md) | 5 | L1 |
| [11 從 107 升到 110](../docs/110/11-migrating-107-to-110/README.md) | 5 | L1–L3(第 3 條要能算圖) |

**L1 那兩篇(02 部分、10)是門檻最低的**,只要建置得起來就能驗一批,不必啟動。拿到環境時從這裡開始最省事。

## 目錄

```
minimal-app/     最小的 .kit 應用檔,用來當實驗的載體
verify/          驗證腳本
  lib.sh         共用:正對照、單變數、log 抓取
  02-extension-alive.sh
  03-settings-precedence.sh
  10-build-reproducibility.sh
```

## 設計上的兩個選擇

**盡量走命令列,少走 Python API。** `--enable`、`--/path=value`、`--exec`、`--no-window`、`--/app/quitAfter` 都有官方出處([02](../docs/common/02-extension-system/README.md)、[03](../docs/common/03-carb-settings/README.md)、[06](../docs/common/06-run-modes/README.md));Python 那一側本 repo 查證得少,所以縮到最小並標記待補。

**每個腳本都內建正對照。** 查詢回空同時相容於「東西不在」與「查法有洞」兩個世界([08 §4](../docs/common/08-debugging/README.md)),所以每個列舉查詢都先用一個確定存在的東西試一次。試紙失敗就直接中止,不要拿一個壞掉的查法去產生結論。
