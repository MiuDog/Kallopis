# KLP-0014：App 主內容採封閉 Panel Tree

## 狀態

Accepted（2026-09-07）

## 決策與適用邊界

`KlpApp` 的 app background 之後只能接入 Kallopis 擁有的 Panel Tree。Panel Tree 的葉節點
一律是 `KlpPanelFrame`；排版節點只能是 Kallopis 提供的具名元件，例如 `KlpDockLayout`。

每個 `KlpPanelFrame` 擁有固定的 `context.klp.space.dockMargin` 外距，預設為 4px。產品提供 Panel 內容、
資料、狀態與事件，但不得用原生 `Row`、`Column`、`Stack`、`Padding` 或任意 `Widget` slot
排列第一層 Panel。這項限制止於 Panel Tree；Panel 內容本身仍可依產品語意排版。

`KlpDockLayout` 是標準多 Panel 排版入口，負責把 stage 與 dock registry 投影為
`KlpPanelFrame`。`KlpNavigationRailFrame` 是 Rail 的 `KlpPanelFrame` 配方。已移除
`KlpWorkbenchShell`；新產品不得再建立固定三欄外殼。

`KlpPanelFrame` 只提供 panel surface、header/footer extent、dock margin 與可選的
Scrollbar host，不再提供 panel 內部 padding。`header`、`content`、`footer` 及 Rail
等子元件必須自行決定內距與上下節奏，避免 Frame 的通用內距與資料容器的視覺責任重疊。

`KlpNavigationRail` 的第一層回傳固定為 `KlpPanelFrame`。Rail 內部使用較小的上下
邊界與較大的 item 間距，並由 Rail 自己承擔其內容 padding；`KlpNavigationRailFrame`
僅作為需要明確命名 Rail surface 的相容配方。

本規則也延伸至所有具有資料語意的 container（例如 Rail、Explorer、Navigator、Sidebar
與其他資料列表容器）：公開建構子必須以該元件的 immutable 專用資料模型與 typed callback
為入口，不接受以任意 `Widget` 清單取代資料模型。元件內部的排版、選取、展開、排序與狀態
投影由 Kallopis 統一處理；產品只提供資料、狀態與事件。純排版元件則維持 layout-only，
不得偷偷承擔產品資料語意。

## 推導依據

若產品自行排列最外層 Panels，即使使用相同 token，仍會重新定義 gutter、收合、resize 與
surface 邊界。Kallopis 必須擁有 Panel Tree，才能讓所有產品有同一份幾何與互動規格。

否決「只以文件要求產品使用 Kallopis 元件」：任意 `Widget` root 無法形成可檢查的 API
邊界，也會讓產品以原生布局繞過 Panel 規則。

## 代價

產品失去快速組裝自訂 root layout 的能力。新增根層布局時，必須先在 Kallopis 定義具名排版
元件、語意與測試，再提供給產品使用。

## 閘門

- `KlpApp` 的 root content 型別只能接受 `KlpPanelLayout`。
- `KlpPanelLayout` 的公開 child slot 只能接受 `KlpPanelLayout` 或 `KlpPanelFrame`。
- `KlpPanelFrame` 不公開可覆寫的外距。
- `KlpDockLayout` 不公開可覆寫的 root margin。
- 具有資料語意的 container 不得以 `List<Widget>` 或任意 Widget tree 作為主要資料入口。
- Rail、Explorer、Navigator、Sidebar 等專用 container 必須有可檢查的專用 model 型別與
  typed callback 契約。
- 對外 API contract test 必須驗證上述型別與建構子限制。
