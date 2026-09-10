# KLP-0016：PanelFrame 無內距與 Rail surface 責任

## 狀態

Accepted（2026-09-07）

## 決策

- `KlpPanelFrame` 不提供或解析 panel 內部 padding。
- `KlpPanelFrame` 保留 surface、圓角、外側 `dockMargin`、header/footer extent，以及
  Scrollbar host 的責任。
- `content`、`header`、`footer` 與資料型 container 必須自行設計其內距。
- `KlpNavigationRail` 第一層固定回傳 `KlpPanelFrame`。
- Rail 以較小的上下 inset、較大的 item gap 建立垂直節奏，避免頂部／底部留白過多。
- `KlpNavigationRailFrame` 保留為具名相容配方，但不得重新引入 Frame 內距。

## 理由

PanelFrame 同時決定 surface 與內容內距會讓不同資料容器被迫共享不適合的節奏，
也會造成 Rail 的上下留白與 item 間距無法獨立調整。將內距責任移回子元件後，
Panel Tree 仍由 Kallopis 擁有，但每個具資料語意的 container 可以維持自己的幾何契約。

## 驗收

- `KlpPanelFrame` 不讀取 `padding`；舊欄位僅可保留為 deprecated compatibility API。
- `KlpNavigationRail.build` 的第一層為 `KlpPanelFrame`。
- Rail item 間距大於原本預設值，上下 inset 小於原本 `navigationRailInset`。
