# Kit 版本差異速查

跨版本排查最花時間的不是「哪裡不一樣」,是「這個症狀該不該歸給版本」。這張表把本 repo 查證過的差異集中在一處,每一列標出處與證據等級。**沒列進來的,就是本 repo 沒有證據,不要當成「兩版相同」。**

## Kit 版本與 Isaac Sim 的對應

Kit 與 Isaac Sim 的版本號完全不同步,而手上拿到的通常是 Isaac Sim 的版本號。

| Isaac Sim | Kit SDK | 證據等級 | 出處 |
|---|---|---|---|
| 4.5.0 | 106.5.0 | release notes 摘要,未逐字核對 | [01 §4](common/01-kit-is-the-framework/README.md) |
| 5.0.0 | 107.3.1 | 由 5.1.0 的變更前值反推 | [01 §4](common/01-kit-is-the-framework/README.md) |
| **5.1.0** | **107.3.3** | 官方逐字 | [01 §4](common/01-kit-is-the-framework/README.md) |
| 6.0.0 早期開發版 | 109.0.2 | 待查證 | [01 §4](common/01-kit-is-the-framework/README.md) |
| **6.0.0 GA** | **110.1.1** | 官方逐字 | [01 §4](common/01-kit-is-the-framework/README.md) |
| **6.0.1** | **110.1.2** | 官方逐字 | [01 §4](common/01-kit-is-the-framework/README.md) |

粗體那三列可以拿來當結論。其餘三列是線索,不要拿去做決策。

要確認手上這一套,別查 Isaac Sim 的版本再對表——直接問 Kit 自己:`<isaac-sim-root>/kit/kit --version`。輸出與這張表對不上時,以你機器上的輸出為準,該修的是這張表。

## 已知的跨版本變動

| 項目 | 變動 | 證據等級 | 出處 |
|---|---|---|---|
| `omni.kit.window.viewport` | 106 標為 deprecated,107 從 SDK 移除 | 官方 release notes,本 repo 未實機驗證 | [11 §2](110/11-migrating-107-to-110/README.md) |
| 版本號連續性 | 107 之後是 109(僅早期開發版)、110,沒有 108 | 由 release notes 推得 | [11 §1](110/11-migrating-107-to-110/README.md) |
| `ITokens` 的 unsafe string 方法 | 110.0 移除 | 官方逐字(OMPE-56022) | [11 §2](110/11-migrating-107-to-110/README.md) |
| `ui.Menu` / `ui.Separator` 的 `menu_compatibility` | 110.0 移除 | 官方逐字(OMPE-69110) | [11 §2](110/11-migrating-107-to-110/README.md) |
| `omni.kit.widget.settings.deprecated` | 110.0 移除,須遷移 | 官方逐字(OMPE-59133) | [11 §2](110/11-migrating-107-to-110/README.md) |
| OmniGraph `DeformedPointsToHydra` 節點 | 110.0 移除 | 官方逐字(OMPE-69458) | [11 §2](110/11-migrating-107-to-110/README.md) |
| RTX multi-node rendering | 110.0 移除 | 官方逐字(OMPE-67531) | [11 §2](110/11-migrating-107-to-110/README.md) |
| Hydra 2 rendering backend | 110.0 停用 | 官方逐字(OMPE-68552) | [11 §2](110/11-migrating-107-to-110/README.md) |
| `omni.renderer_capture` | 110.0 棄用 | 官方逐字(OMPE-71542) | [11 §3](110/11-migrating-107-to-110/README.md) |
| `IFileSystem` 的 raw `char*` 方法 | 110.0 棄用 | 官方逐字(OMPE-57069) | [11 §3](110/11-migrating-107-to-110/README.md) |
| `OnCustomEvent` 的 bundle 屬性 | 110.0 棄用 | 官方逐字(OMPE-72264) | [11 §3](110/11-migrating-107-to-110/README.md) |

升級時比清單本身更要緊的一件事:**這些變更浮現的時機不同**,而只有第一類會在啟動時被抓到。分類與對應的測試涵蓋見 [11 §4](110/11-migrating-107-to-110/README.md)。

## 表上沒有的,不等於兩版相同

上面那幾列全部來自官方 release notes,**本 repo 一條都沒有實機驗證**,驗法列在 [11 §6](110/11-migrating-107-to-110/README.md)。

分區判準是「結論依不依賴版本」:一條結論兩版都成立就留在共通區,只有出現「只有這一版這樣」的證據時才會落進版本區,同時在這裡補一列。目前共通區 10 篇的機制在兩版都成立,所以 107 區還是空的。
