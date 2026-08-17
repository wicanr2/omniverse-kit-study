# Omniverse Kit 實戰筆記

NVIDIA **Omniverse Kit SDK 本體**的實戰教學——框架層,不是應用層。

姊妹 repo [isaac-sim-study](https://github.com/wicanr2/isaac-sim-study) · [線上版](https://wicanr2.github.io/isaac-sim-study/)

> **狀態:骨架階段。** 目前 6 篇,工具鏈與分區已就緒。GitHub Pages 尚未開通,`docs/` 底下的 HTML 已建好,開通後即可直接用。
>
> **本 repo 目前沒有自有的 Kit 環境。** 六篇都是官方機制整理,篇首標明未實機驗證,並附待驗清單與各自的驗法。

## Kit 是框架,Isaac Sim 是搭在上面的應用

這個關係常常被講反,而講反了會讓人往錯的地方找答案:

```
Omniverse Kit   =  應用框架
                   引擎 + extension 系統 + USD stage + RTX/Hydra + omni.ui + OmniGraph

Isaac Sim       =  搭在 Kit 上的「一個應用」
                   額外疊上機器人領域層:PhysX 機器人工具、感測器、ROS 2 bridge、
                   URDF/MJCF 匯入器、isaacsim.* API
```

而這不只是比喻。Isaac Sim 安裝根目錄底下擺著 `apps/isaacsim.exp.full.kit`——它就是一個 `.kit` 應用檔,加上一組 `isaacsim.*` extension。細節在 [01 §3](docs/common/01-kit-is-the-framework/README.md)。

實際意義:**在 Isaac Sim 裡遇到 extension 載不起來、設定沒生效、圖不 tick、材質全黑,那多半不是 Isaac 的問題,是 Kit 這一層的行為**,答案要往 Kit 的文件與機制找。分層對照表在 [01 §5](docs/common/01-kit-is-the-framework/README.md)。

## 目錄

| 分區 | 篇數 | 收什麼 |
|---|---|---|
| [`docs/common/`](docs/common/) | 6 | 不綁 Kit 版本的機制與方法論 |
| [`docs/107/`](docs/107/) | 0 | 只在 Kit 107 成立的(Isaac Sim 5.0 / 5.1) |
| [`docs/110/`](docs/110/) | 0 | 只在 Kit 110 成立的(Isaac Sim 6.0 / 6.0.1) |

分區判準是「結論依不依賴 Kit 版本」,不是標題帶哪個版號。目前
6 篇裡真正綁死 Kit 版本的有 0 篇,所以兩個版本區都還是空的。

[版本差異速查](docs/version-matrix.md) 收 Kit ↔ Isaac Sim 的版本對應與已知跨版本變動,每列標證據等級。

## 篇目

| # | 篇名 |
|---|---|
| 01 | [Kit 是框架,Isaac Sim 是搭在上面的應用](docs/common/01-kit-is-the-framework/README.md) |
| 02 | [extension 系統:相依解析、來源優先序、生命週期](docs/common/02-extension-system/README.md) |
| 03 | [carb settings:設定樹、先寫先贏,以及官方沒寫全的優先序](docs/common/03-carb-settings/README.md) |
| 04 | [USD stage 與 Fabric:兩份真值,以及你正在讀哪一份](docs/common/04-usd-stage-and-fabric/README.md) |
| 05 | [OmniGraph:圖是 USD 資料,而求值不在物理迴圈上](docs/common/05-omnigraph/README.md) |
| 06 | [執行模式:headless 不是「沒在算圖」](docs/common/06-run-modes/README.md) |

## 這個 repo 收什麼

判準只有一句:

> **不裝 Isaac Sim 也成立的 → 這裡。需要機器人疊層才成立的 → [isaac-sim-study](https://github.com/wicanr2/isaac-sim-study)。**

| 收在這裡 | 收在 isaac-sim-study |
|---|---|
| extension 相依解析、registry、`.kit` app 檔 | ROS 2 bridge 的行為 |
| carb settings 的機制與優先序 | 物理參數與調參 |
| OmniGraph 的節點、連線、求值時機 | 機器人 articulation 怎麼建 |
| omni.ui、Hydra/RTX、MDL 材質 | 場域資產、感測器安裝 |
| 打包、發佈、headless / streaming 啟動 | 失效分類、實驗方法論 |

灰色地帶用同一句判,並在兩邊互相連結,不兩邊各寫一份。

## 主題骨架

由下往上,尚未動筆的候選主題。**每一條動筆前先確認手上的 Kit 版本行為,不照清單直接寫。**

| 群 | 候選主題 |
|---|---|
| **Kit 是什麼** | ✅ 01 框架與應用的關係;`.kit` app 檔的結構與繼承;啟動流程與各層職責邊界 |
| **extension** | ✅ 02 `extension.toml`、相依解析、registry、生命週期、「啟用成功」不是它活著;尚缺:離線 / air-gapped registry |
| **carb settings** | ✅ 03 設定樹、`--/path=value`、`/persistent`、`[settings]` 先寫先贏;尚缺:五個入口的完整優先序(官方沒寫全,要自己量) |
| **USD 與 Fabric** | ✅ 04 兩份真值、單向資料流、`HasWorldXform` 的正確語意;尚缺:Fabric 直接 authoring、跨網路填充 |
| **OmniGraph** | ✅ 05 節點型別與連線都是 USD 屬性、結構在 USD 值在 Fabric、求值不在物理迴圈上;尚缺:執行埠與求值器種類 |
| **omni.ui** | UI 框架與 extension 的關係;headless 下哪些東西不存在 |
| **渲染** | Hydra 與 RTX;MDL 材質;缺貼圖不是素色是純黑 |
| **執行模式** | ✅ 06 視窗與算圖是兩個獨立開關、`--exec`、串流的三個 extension 與兩個限制;尚缺:非同步算圖 |
| **打包發佈** | `kit-app-template`;build 與封裝;版本釘選 |
| **除錯** | log 怎麼讀;settings dump;extension 狀態查詢;每個列舉查詢配正對照 |

## 寫作紀律

證據等級分得清清楚楚,是這個 repo 的主要價值:

- 查證過才寫定論。還在猜的寫「推測」「待查證」,並說明怎麼驗才能升級。
- 貼了程式碼但沒實機跑過,篇首明寫「未在本 repo 環境驗證」。
- 引用官方文件給版本與連結;數字一律連同量測條件(Kit 版本、環境、樣本數)。
- 斷言被推翻就把正文改寫成正確答案,推翻紀錄集中到一處。

術語表在 [CONTEXT.md](CONTEXT.md)。

## 建站與檢查

改完 markdown 一定要重建,否則 GitHub 上是新的、Pages 上是舊的。

```bash
# 建站(docker + uv 暫時環境,不裝東西到系統)
docker run --rm --log-opt max-size=10m --log-opt max-file=3 \
  -v "$PWD":/w -w /w --user "$(id -u):$(id -g)" \
  -e HOME=/tmp -e UV_CACHE_DIR=/tmp/uv \
  ghcr.io/astral-sh/uv:python3.12-bookworm-slim \
  uv run --with markdown --with pygments python build_site.py

# 一致性檢查(不需第三方套件)
python3 check_docs.py
```

`check_docs.py` 驗五件事:連結解析、索引宣稱篇數 vs 實際、漏登、`§N` 章節引用存不存在、產出 HTML 有沒有比 markdown 舊。**它證明不了「引對了」**——引到「存在但講的是別的東西」的章節,只有讀才抓得到。
