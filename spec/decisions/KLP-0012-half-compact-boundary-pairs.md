# KLP-0012：App、Header 與 Dock 的 halfCompact 邊界配對

- 狀態：Accepted
- 日期：2026-09-04
- 修正：KLP-0010 移除 Header margin 的規則

> 2026-09-07：4px＋4px＝8px 的布局關係仍有效；runtime 欄位名稱與獨立注入方式改由
> KLP-0015 的 `appFrameInset`、`windowHeaderMargin` 與 `dockMargin` 表達。

## 決策

AppFrame 以 `context.klp.space.halfCompact` padding 同時包住 Header 與產品主內容；
Header 本身另有 `halfCompact` margin，`KlpDockLayout` 的預設 margin 也維持
`halfCompact`。Kallopis 預設每份為 4px。

因此 AppFrame＋Header 與 AppFrame＋Dock 各自形成 `4px + 4px = 8px compact`
gutter。相鄰責任層各自貢獻完整間距的一半，這是 halfCompact 的現行定義。

## 理由

App padding 必須包住 Header，表示 Header 位於 AppFrame padding 之內；但「包住」
不代表 Header 喪失自己的 margin。保留兩層貢獻可讓 Header 與主內容 Dock 的可視表面
對稱落在 8px app gutter 上。

## 影響

- AppFrame 保留包住 Header 與 body 的 halfCompact padding。
- KlpWindowHeader 恢復四周 halfCompact margin，其占位高度包含上下兩份 margin。
- KlpDockLayout 保留預設 halfCompact margin。
- CatalogShell 不額外加入產品根 padding。
- Header 最外層拖動手勢包住自身 margin，AppFrame padding 不屬於拖動範圍。

## 邊界

- 本規則只影響 Kallopis app chrome，不影響使用者建立的 Design System。
- pane、Area、Group 與內容內距仍由各自語意解析。
- 呼叫端只有在明確定義的特殊嵌套情境才能覆寫 Dock margin。

## 閘門

- AppFrame padding 必須包住 Header 與 body。
- Header 與 Dock 必須各自解析 halfCompact margin。
- Header 可視表面與 Dock 外框距 App 邊緣預設都為 8px。
- Catalog 不得補入第三份產品根 padding。
