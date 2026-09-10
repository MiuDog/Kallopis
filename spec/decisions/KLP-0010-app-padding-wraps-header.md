# KLP-0010：App padding 同時包住 Header 與主內容

- 狀態：Superseded by KLP-0012
- 日期：2026-09-04
- 取代：KLP-0009 的產品根與 Header 分別擁有 halfCompact 邊界

> 2026-09-04：AppFrame padding 繼續包住 Header 與主內容，但 KLP-0012 恢復
> Header 自身的 halfCompact margin；現行組合以 KLP-0012 為準。

## 決策

`_KlpAppFrame` 在 app background 之上提供一層
`context.klp.space.halfCompact` padding，預設為 4px。這層 padding 必須同時包住
App Header 與產品主內容；Header 不再自行加入 margin，產品入口也不再重複加入
同一層 padding。

`KlpDockLayout` 保留自身預設 halfCompact margin。因此使用 Dock 的產品主內容在
左右與底部由 AppFrame 4px 加 Dock 4px，形成 8px compact gutter；Header 直接由
AppFrame 的 4px 邊界包住。

## 理由

App padding 是完整 app chrome 的共同外框，不應只從 Header 以下開始。將所有權放在
AppFrame，可保證 Header 與主內容位於同一安全邊界，並避免 Header 自行計算高度與
margin 後造成所有權分裂。

## 影響

- `_KlpAppFrame` 的 Padding 包住 Header 與 body。
- `KlpWindowHeader` 的高度只代表可視表面高度，不再包含外圍 margin。
- CatalogShell 移除自身的產品根 Padding，直接組合 KlpDockLayout。
- KlpDockLayout 未指定 margin 時仍解析 halfCompact。

## 邊界

- 本規則只影響使用 KlpApp AppFrame 與 Window Header 的 Kallopis app chrome。
- 使用者建立的 Design System 不受影響。
- pane、Area、Group 與內容內距仍由各自語意解析。

## 否決方案

- 否決 Header 自行加入 margin：App padding 無法形成包住 Header 的共同外框。
- 否決 Catalog 自行保留根 padding：會與 AppFrame 形成未命名的重複層。
- 否決移除 Dock margin：Dock 仍需擁有自己的布局邊界。

## 閘門

- AppFrame 必須以 halfCompact Padding 包住 Header 與 body。
- KlpWindowHeader 不得自行加入 halfCompact margin。
- CatalogShell 不得再包產品根 halfCompact Padding。
- KlpDockLayout 預設 margin 必須維持 halfCompact。

## 已知欠債

未使用 KlpApp Window Header 的特殊入口需在各自畫面定型時確認是否需要相同 AppFrame
外框，不由本決策猜測補入。
