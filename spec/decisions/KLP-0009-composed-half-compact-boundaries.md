# KLP-0009：組合層級各自擁有 half-compact 邊界

- 狀態：Superseded by KLP-0010
- 日期：2026-09-04
- 取代：KLP-0008 的 Dock 零外距規則
- 整合：KLP-0006 的元件外距與 KLP-0008 的產品根 padding

> 2026-09-04：App padding 的所有權已由 KLP-0010 提升至 AppFrame，並同時包住
> Header 與產品主內容。Header 不再自行提供 margin；Dock 預設 margin 保留。

## 決策

Kallopis App 的三個組合層級各自解析 `context.klp.space.halfCompact`，預設為 4px：

- 產品主內容根節點提供一層 padding。
- `KlpDockLayout` 未指定 `margin` 時提供一層 margin。
- App Header 自身提供一層 margin。

產品根 padding 與 Dock margin 是兩個刻意相鄰的 halfCompact 貢獻；在 Catalog 的
Sidebar＋Stage 組合中會形成 8px `compact` gutter。Catalog 不覆寫 Dock margin，
直接採用元件預設值。AppFrame 只鋪 app background，不代替上述任一層。

## 理由

產品入口、可停駐布局與視窗 chrome 各自有可辨識的幾何邊界。讓各責任點解析同一
halfCompact 語意，可在維持單一真相來源的同時，穩定產生產品根至 Dock 的完整
compact 間距，也讓 Header 保持一致的 app background 邊界。

## 影響

- Catalog 主內容根保留 halfCompact padding，並移除 Dock 的零 margin 覆寫。
- `KlpDockLayout.margin` 未指定時由目前 Kallopis 風格解析 halfCompact。
- 使用 OKLCH 或其他主題入口調整 spacing recipe 時，三個層級會跟隨同一語意更新。
- 特殊巢狀布局仍可明確傳入 `margin`，但不得把例外寫成產品通則。

## 邊界

- 本規則只影響 Kallopis 產品 chrome，不影響使用者建立的 Design System。
- pane、Area、Group、Stage 內容 padding 與 overlay 仍由各自語意決定。
- Workbench 等其他產品入口需經畫面稽核後再調整，不由本決策自動搬移。

## 否決方案

- 否決 Dock 預設為零：無法表達 Dock 自身的 halfCompact 邊界責任。
- 否決 AppFrame 自動提供主內容 padding：會隱藏產品入口的組合責任。
- 否決用固定 4px 常數：必須由 `KlpSpacingTheme.halfCompact` 統一解析。

## 代價

產品根與 Dock 相鄰時總距離為 8px；消費端必須理解這是兩個已命名的組合層級，
不可僅因視覺上相加便移除其中一層。

## 閘門

- CatalogShell 主內容根必須存在一層 halfCompact padding。
- CatalogShell 不得把 Dock margin 覆寫為零。
- KlpDockLayout 未指定 margin 時必須解析 halfCompact。
- App Header 必須從目前 Kallopis spacing recipe 解析 halfCompact margin。
- 指南、screen tree、元件需求與語意表必須描述相同組合。

## 已知欠債

後續逐一稽核其他產品入口，確認是否同時包含產品根、Dock 與 Header，以及例外
margin 是否具有明確的局部理由。
