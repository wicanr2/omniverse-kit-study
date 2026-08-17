# Omniverse Kit 實戰筆記:框架這一層

大部分 Omniverse 的教學從應用開始講——開 Isaac Sim、開 USD Composer,點選單、拖物件。但那些應用共用的底座是同一套東西:extension 系統、carb settings、USD stage 與 Fabric、Hydra/RTX、OmniGraph、omni.ui。**應用層查不到答案的問題,答案通常在這一層。**

這裡整理的是 Kit SDK 本身的機制與踩坑,每篇從「要解決什麼根本問題」出發,並且標明哪些是官方機制、哪些是實測結論、哪些還只是推測。

## 三個入口

**[共通:機制與方法論](common/)** · 8 篇
不綁 Kit 版本的機制與方法。Kit 的多數概念——extension 相依樹、設定樹的優先序、stage 與 Fabric 的分工——跨版本是同一套,所以不按版本分。

**[Kit 107](107/)** · 0 篇
只在 107 系列成立的內容。Isaac Sim 5.0 / 5.1 底下就是這一版。

**[Kit 110](110/)** · 0 篇
只在 110 系列成立的內容。Isaac Sim 6.0 / 6.0.1 底下是這一版。

**[版本差異速查](version-matrix.md)**
跨版本排查最花時間的不是「哪裡不一樣」,是「這個症狀該不該歸給版本」。每一列都標出處與證據等級。

## 怎麼開始

| 你的處境 | 從這裡進 |
|---|---|
| 想搞清楚 Kit 與 Isaac Sim 到底誰包含誰 | [01 Kit 是框架,Isaac Sim 是搭在上面的應用](common/01-kit-is-the-framework/README.md) |
| 在 Isaac Sim 裡遇到問題,不確定該查誰的文件 | [01 §5 症狀該往哪一層找](common/01-kit-is-the-framework/README.md) |
| 手上有一套 Isaac Sim,想知道底下是哪一版 Kit | [01 §4 版本對應](common/01-kit-is-the-framework/README.md) |
| 同一份程式碼在開發機能跑、換一台就說找不到 extension | [02 §4 版本從哪裡拿](common/02-extension-system/README.md) |
| 啟用了 extension,該有的東西卻不存在 | [02 §7 「啟用回傳成功」不是「它活著」](common/02-extension-system/README.md) |
| 改一個檔案就整個應用停頓一下 | [02 §6 熱重載](common/02-extension-system/README.md) |
| 設定寫了沒生效,或不確定誰蓋過誰 | [03 §3 先寫先贏](common/03-carb-settings/README.md) → [03 §7 自己量優先序](common/03-carb-settings/README.md) |
| 同一份程式碼在兩台機器行為不同 | [03 §6 `/persistent` 會活過重開](common/03-carb-settings/README.md) |
| 模擬在跑,讀出來的座標卻一直不變 | [04 §5 你正在讀哪一份](common/04-usd-stage-and-fabric/README.md) |
| 改完存檔,改動不見了 | [04 §3 資料只往一個方向流](common/04-usd-stage-and-fabric/README.md) |
| 物理在跑,但圖沒有輸出 | [05 §4 圖跟著誰求值](common/05-omnigraph/README.md) |
| 要用程式生成 OmniGraph,不想開介面拉 | [05 §2 節點型別與連線都是 USD 屬性](common/05-omnigraph/README.md) |
| 想知道 headless 能不能省下 GPU 預算 | [06 §2 兩個獨立的開關](common/06-run-modes/README.md) |
| 串流連得上但畫面停在第一張 | [06 §5 串流的兩個結構性限制](common/06-run-modes/README.md) |
| 算出來的畫面是黑的 | [07 §6 判別紀律:不要看畫面](common/07-rendering-and-materials/README.md) |
| 東西設成不可見了,卻還是擋住路 | [07 §5 `visibility` 只影響算圖](common/07-rendering-and-materials/README.md) |
| 手上的訊號到底能不能當證據 | [08 §2 假訊號與真訊號](common/08-debugging/README.md) |
| 不知道從哪裡開始查 | [08 §5 排查的順序](common/08-debugging/README.md) |

## 這個 repo 的狀態

骨架階段。目前 8 篇,主題骨架列在[根 README](https://github.com/wicanr2/omniverse-kit-study#主題骨架) 裡。

**本 repo 目前沒有自有的 Kit 環境**,八篇都是官方機制整理,篇首標明未實機驗證,並各自附了待驗清單([02 §8](common/02-extension-system/README.md)、[03 §8](common/03-carb-settings/README.md)、[04 §6](common/04-usd-stage-and-fabric/README.md)、[05 §6](common/05-omnigraph/README.md)、[06 §7](common/06-run-modes/README.md)、[07 §7](common/07-rendering-and-materials/README.md)、[08 §6](common/08-debugging/README.md))。拿到環境之後逐條升級。

機器人領域的內容在姊妹 repo [isaac-sim-study](https://github.com/wicanr2/isaac-sim-study)([線上版](https://wicanr2.github.io/isaac-sim-study/))。兩邊的分工判準寫在 [01 §6](common/01-kit-is-the-framework/README.md)。
