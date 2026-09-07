# KLP-0008：產品主內容根節點的 half-compact padding

- 狀態：Superseded by KLP-0009
- 日期：2026-09-04
- 取代：KLP-0006 的主內容外距所有權

> 2026-09-04：產品根 padding 仍保留，但 Dock 預設 margin 已由 KLP-0009
> 恢復為 halfCompact；「Dock 預設為零」不再是現行規則。
>
> 隨後 KLP-0010 將同一層 padding 提升至 AppFrame，使其同時包住 Header 與
> 產品主內容；現行所有權以 KLP-0010 為準。

## 決策

每個 App 產品的主內容根節點必須套用一層
`context.klp.space.halfCompact` padding；Kallopis 預設風格解析為 4px。
這一層由產品組合擁有，不由 `KlpDockLayout`、Stage 或 Sidebar 各自補入。

`KlpDockLayout.margin` 未指定時解析為零，只保留給局部嵌套或相容情境明確覆寫。
Catalog 由 `CatalogShell` 套用產品根 padding，並以零 margin 組合 Dock，作為產品
Sidebar＋Stage 架構的參考實作。

視窗標題列與產品主內容分屬不同組合層；Header chrome 的外距不視為產品主內容
padding。Area、Group、pane 之間的 gap 亦為內部布局語意，不得拿來取代或疊加
產品根 padding。

## 理由

外距若由第一層元件自行提供，產品同時組合多個根區域時容易形成雙份外距，且
無法從產品入口確認 app background 的安全邊界。把責任提升到產品主內容根節點後，
整個畫面只有一個明確的 4px 邊界，Dock 與其他布局元件也能安全嵌套。

## 影響

- 新產品在主內容入口明確加入一層 half-compact padding。
- `KlpDockLayout` 不再預設產生產品級外距。
- 既有直接依賴 Dock 預設 4px margin 的呼叫端需把 padding 移至產品根節點。
- KLP-0006 保留為歷史；其中由第一層元件各自擁有外距的部分由本決策取代。

## 邊界

- 本規則只處理 Kallopis 產品 chrome，不影響使用者建立的 Design System recipe。
- Window Header 可保留自己的 chrome margin，因為它不在產品主內容根節點內。
- pane、Area、Group 與內容內距仍由各自語意解析。

## 否決方案

- 否決由 AppFrame 自動包 padding：這會讓 library 隱藏產品組合責任，也會限制需要
  特殊 chrome 的產品。
- 否決由 Dock、Stage、Sidebar 各自加 margin：多個第一層元件並列時會形成難以
  稽核的雙份 gutter。

## 代價

每個產品入口需明確寫出一層 Padding；舊呼叫端若曾依賴 Dock 的預設 margin，需在
升級時調整組合。

## 閘門

- CatalogShell 必須有且只有一層 halfCompact 產品根 padding。
- KlpDockLayout 的未指定 margin 必須解析為零。
- 指南、screen tree 與語意表不得再把產品級外距歸給 Dock。

## 已知欠債

既有產品需逐一檢查根節點是否已明確提供 padding；本決策不在未檢查畫面中自動
搬移 Workbench pane 的既有 margin。
