# 共通:機制與方法論

不綁 Kit 版本的內容。Kit 的多數核心概念跨版本是同一套——extension 相依樹怎麼解析、設定樹誰蓋過誰、stage 與 Fabric 為什麼是兩份真值——結論不隨版本改變的就收在這裡,不複製成兩份。

版本一改就不成立的,收到 [Kit 107](../107/) 或 [Kit 110](../110/)。

這一區的 3 篇:

| # | 篇名 | 講什麼 |
|---|---|---|
| 01 | [Kit 是框架,Isaac Sim 是搭在上面的應用](01-kit-is-the-framework/README.md) | 應用就是一棵 extension 相依樹的根,而 `.kit` 檔就是那個根;Kit 與 Isaac Sim 的版本對應;症狀該往哪一層找 |
| 02 | [extension 系統:相依解析、來源優先序、生命週期](02-extension-system/README.md) | 相容的判準是最左邊那個非零位;開發路徑會忽略版本檢查;啟用回傳成功不是它活著 |
| 03 | [carb settings:設定樹、先寫先贏](03-carb-settings/README.md) | `[settings]` 在任何 extension 啟動前套用完,順序反向、先寫先贏;完整優先序官方沒寫全,怎麼自己量 |
