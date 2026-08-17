# Omniverse Kit 實戰筆記

NVIDIA **Omniverse Kit SDK 本體**的實戰教學——框架層,不是應用層。

> **狀態:骨架階段。** 目錄與內容還在建立中。

## Kit 是框架,Isaac Sim 是搭在上面的應用

這個關係常常被講反,而講反了會讓人往錯的地方找答案:

```
Omniverse Kit   =  應用框架
                   引擎 + extension 系統 + USD stage + RTX/Hydra + omni.ui + OmniGraph

Isaac Sim       =  搭在 Kit 上的「一個應用」
                   額外疊上機器人領域層:PhysX 機器人工具、感測器、ROS 2 bridge、
                   URDF/MJCF 匯入器、isaacsim.* API
```

Isaac Sim **不是 Kit 的一個功能**,它是**消費 Kit 的產品**。類比是 Electron 與 VS Code——說「VS Code 是 Electron 的一個小功能」會錯得很徹底。

這件事對讀者的實際意義:**當你在 Isaac Sim 裡遇到 extension 載不起來、設定沒生效、圖不 tick、材質全黑,那多半不是 Isaac 的問題,是 Kit 這一層的行為**,而答案要往 Kit 的文件與機制找。

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

## 姊妹 repo

**[isaac-sim-study](https://github.com/wicanr2/isaac-sim-study)** · [線上版](https://wicanr2.github.io/isaac-sim-study/)

Isaac Sim 的實戰筆記,34 篇,依版本與主題分四區。兩個 repo 的寫作紀律相同:**每一條都標明哪些是官方機制、哪些是實測結論、哪些還只是推測**。
