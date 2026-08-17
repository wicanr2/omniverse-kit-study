# CONTEXT — 術語表

> 本 repo 的統一用語。首次出現的術語在文中當場一句話翻譯,這裡收長期定義。

| 術語 | 定義 |
|---|---|
| Omniverse Kit | NVIDIA 的應用框架:引擎 + extension 系統 + USD stage + Hydra/RTX + omni.ui + OmniGraph。本身不是產品,是用來組出產品的零件與規則。 |
| Kit SDK | Kit 的發行單位,版本號自成一套(106 / 107 / 110),與搭在上面的應用版本不同步。 |
| Isaac Sim | 搭在 Kit 上的機器人模擬應用。實作上就是一個 `.kit` 檔加一組 `isaacsim.*` extension。 |
| extension | Kit 的擴充單位,以 `extension.toml` 定義自身與相依。應用啟動時載入的那組 extension 就定義了這個應用是什麼。 |
| `.kit` 檔 | 應用的設定檔,格式與 `extension.toml` 相同,差別在它是相依樹的**根**。放在 `apps/` 底下。 |
| experience 檔 | `.kit` 檔的另一個稱呼,強調它決定了「這次啟動是哪一套體驗」。可用絕對路徑或相對路徑指定。 |
| 相依樹 | `.kit` 檔的 `[dependencies]` 展開後的結果:extension 相依 extension,一路展開;Kit 啟動時解析它並決定載入順序。 |
| registry | extension 的遠端來源。第一次用某個 experience 檔啟動時會從這裡拉,官方稱可能超過十分鐘;拉完才有快取。 |
| registryCache | 從 registry 下載的 extension 解壓後存放的本地快取目錄,由 `app/extensions/registryCache` 設定。「安裝」就是解壓進這裡。 |
| devPaths / devFolders | 開發用的 extension 搜尋路徑。**會忽略所有版本檢查,而且優先於其他路徑**——所以開發機上的「跑得起來」不能當成正式環境的證明。 |
| 相容(版本) | Kit 的判準:兩個版本的**最左邊那個非零**的 major/minor/patch 相同才算相容。因此 `0.5.x` 與 `0.6.x` 不相容。 |
| IExt | extension 的進入點介面。Python 是 `omni.ext.IExt` 的子類別,啟用時實例化並呼叫 `on_startup`,停用時 `on_shutdown`;C++ 對應 `onStartup` / `onShutdown`。 |
| 熱重載(hot reload) | extension 系統偵測到已啟用 extension 的檔案變動時,把它停用再啟用;可能連帶重載相依樹的一大片。以 `reloadable` 設定關閉。 |
| carb settings | Kit 的全域設定樹,實質是一個巢狀字典。啟動參數 `--/path/to/key=value`、`.kit` 檔與 `extension.toml` 的 `[settings]` 段、使用者設定檔都是在改這棵樹。 |
| 先寫先贏 | `[settings]` 的合併規則:在任何 extension 啟動前全部套用完,順序是啟動順序的反向,且**不互相覆蓋**。結果是相依鏈上層的值勝過下層。 |
| `/persistent` | 設定樹裡會跨 session 留存的命名空間,自動存進使用者設定檔並在下次啟動載回。兩台機器行為不同時的第一個比對點。 |
| carb | Carbonite,Kit 底層的 C++ 框架層,提供設定、外掛載入等基礎服務。`carb settings` 的名字由此而來。 |
| USD | Universal Scene Description,Pixar 開源的 3D 場景描述格式,Kit 的原生場景格式。 |
| Stage | 一份開啟中的 USD 場景樹,所有 Prim 掛在其上。 |
| Prim | USD 場景樹的節點(primitive):Mesh、Xform、Light、Physics Scene 等。 |
| Fabric | Kit 的執行期場景資料層(usdrt)。與 USD stage 是**兩份真值**,讀寫時要清楚自己在動哪一份。 |
| Hydra | USD 的算圖抽象層,把場景資料交給後端算圖器。 |
| RTX | NVIDIA 的即時光線追蹤算圖後端,Kit 預設的 Hydra 算圖器之一。 |
| MDL(.mdl) | NVIDIA Material Definition Language,Omniverse 的材質格式。 |
| OmniGraph | Kit 的視覺化節點圖框架。節點型別與連線都是真的 USD 屬性,所以圖可以離線寫全。 |
| omni.ui | Kit 的 UI 框架。headless 模式下有一部分東西根本不存在。 |
| headless | 不開 GUI 視窗的執行模式,適合遠端伺服器與自動化。 |
| kit-app-template | NVIDIA 官方的應用腳手架倉庫,用來生成 `.kit` 應用與 extension 的骨架。 |
| 證據等級 | 本 repo 對每條斷言的標記:官方逐字 / 官方摘要未核對 / 實測 / 推測待驗。標錯比寫得不夠詳細嚴重。 |
| 正對照 | 列舉查詢時拿一個**確定存在**的東西當試紙,用來區分「東西不在」與「我的查法有洞」。 |
