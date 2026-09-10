# Changelog

## 0.8.0 — 2026-08-24

### 加入

- **`KlpSpacingTheme.gridTileWidth`** — 卡片式網格的預設單欄寬度，讓消費端以
  semantic token 組合瀑布流，不再自行寫死版面尺寸。
- **`KlpCalendar.dayContentBuilder`** — 月曆每一格日期底下可以放內容。
  這是 slot 而非布林參數：月曆不需要知道格子裡放的是待辦、排程還是別的東西，
  那屬於呼叫端的語意。回傳 `null` 代表該格沒有內容。
- **`KlpSpacingTheme.calendarContentCell`** — 帶內容的日期格最小高度。
  純日期選擇仍用 `controlHeightSmall`；沒有這個切換，日期數字加內容會擠在
  選擇器的格高裡糊成一團。

### 消費者須知

49 份來源未查證的舊圖示內容已換成固定於 Lucide `1.27.0` 的官方 SVG；
`KlpIcons` 欄位與 asset path 維持相容，但字形輪廓會有經核准的視覺變更。

第一個消費者 Notist 的 Journals 畫面需要「每格列出當天事項」的月曆。那仍然是
無語意元件，因此做在這裡而不是產品端——產品端另做一個，第二個產品要用時就得複製。

## 0.7.0 — 2026-08-24

### 加入

- 新增工作區通用呈現元件：日期概覽、待辦與排程清單、訊息串與輸入器、瀑布流、
  資產預覽卡、Primary Sidebar frame、導覽群組與可拖曳 pane 把手。
- Catalog 新增 Workspace 分組，展示 Shell、Agenda、Conversation 與 Assets 在明暗模式下的
  預設組合；所有文案與資料仍由消費端提供。

### 變更

- 工作台預設幾何對齊版面真相：window header 44px、shell panel 間距 10px、sidebar identity
  與導覽列高 36px、導覽列間距 2px；sidebar explorer 分區標題改由共用元件提供結構。
- Light 色梯改為參考稿的暖石色階：app `#EAE7E1`、panel `#F2F0EB`、stage `#FFFFFF`、
  soft interaction `#E6E3DC`、主要文字 `#1D1D1D`、次要文字 `#6B6459`；sidebar identity
  與 segmented control 直接採用這組 semantic token。

### 修正

- `KlpWorkbenchShell` 預設不再於全寬 window header 下方重複加入頂部 gutter；
  panel 現在與 Catalog 一樣緊接 header，左右與底部仍保留 `space.compact`。
- Primary Sidebar 現在會呈現 token 驅動的寬度拖曳把手，並保留 2px × 28px 的可見 grip。

## 0.6.0 — 2026-08-23

這個 minor 版本新增由 token 驅動的 Settings 呈現層與 Color Modes Catalog，並納入先前
尚未正式發布的 Primary Sidebar 導覽預設。直接建構 `KlpLayoutGeometry` 的消費端需補上
兩個新增欄位；讀取 `KlpThemePreviewTile.width` 的程式需接受 nullable 值。

### 加入

- 從 Planist Settings 抽取 token 驅動的設定頁呈現層：`KlpSettingsPage`、導覽與內容 pane、
  navigation group／item、設定欄位、固定 action bar 與 `KlpThemeModePicker`。
- Catalog 新增 Color Modes 與 Settings 分組，展示 Light、Dark、Ultra Dark、System、
  Transparent，以及完整設定頁與個別元件。
- 新增 `KlpSidebarNavigationButton`，由 Kallopis 統一 Primary Sidebar 導覽項的高度、
  內距、圓角、icon 尺寸、hover、選取與停用風格；消費端只傳入 icon、標籤、狀態與事件。

### 變更

- `KlpThemePreviewTile` 的預設寬度改由 theme geometry 決定；消費者不指定時不再使用元件內
  寫死尺寸。
- theme JSON geometry 新增 `settingsContentMaximumWidth` 與 `themePreviewTileWidth`。
- Catalog 的 Actions & Navigation 頁加入一般、選取與停用三態示範。
- Notist 的 Primary Sidebar 上半部改為直接採用 Kallopis 預設導覽風格，不再自行組合
  `Material`／`InkWell` 或指定視覺 token。

## 0.5.0 — 2026-08-23

這個 minor 版本把 Kallopis 的視窗與工作台風格收斂為消費端可直接採用的預設，並依
KLP-0003 把只有 Notist 使用的筆記語意元件移回產品層。這是破壞性 API 調整；升級前請先
完成下方遷移。

### 加入

- `KlpApp.startMaximized` 預設在首次建立時確保原生視窗最大化；消費端可明確停用。
- `KlpContextMenuController` 可由任意操作鈕以全域座標開啟選單，讓產品層組合區塊操作介面。

### 變更

- `KlpWorkbenchShell` 預設為 shell 與 sidebar／stage panel 套用均勻的 theme 間距；header
  維持全寬，內容起點與下方 panel 對齊。
- 視窗 header 的 app icon 尺寸、控制鈕尺寸、內距與 action 配置統一由 Kallopis geometry
  token 決定，消費端只需傳入 icon。
- 一般按鈕 hover／選取使用表面高亮；explorer 與表單維持低／高對比虛線邊框語言。
- Catalog 不再包含 Notes 分組，只展示至少兩個產品共用的視覺元件。

### 移除

- 移除 `KlpBlock`／`KlpBlockCanvas`；Notist 改用 `NtsBlock`／`NtsBlockCanvas`。
- 移除 `KlpSheetGrid`；Notist 改用 `NtsSheetGrid`。
- 移除 `KlpPageBackground*` recipe、viewport、painter 與 editor API；Notist 改用對應的
  `NtsPageBackground*` 型別。Kallopis 仍保留通用的 `pagePattern` 色彩 token。

### 修正

- 修正 Windows 最大化工作區、工作列命中、header 拖曳還原、視窗邊緣 resize 與最小尺寸
  契約，並避免極窄或短暫低高度視窗產生 RenderFlex overflow。
- 修正首幀顯示以 `SW_SHOWNORMAL` 覆蓋 `KlpApp` 啟動最大化的問題；視窗現在會依目前螢幕
  的工作區與 DPI 縮放比例最大化。
- 修正 header 水平與垂直內距不一致、控制鈕貼邊，以及關閉按鈕缺少語意紅色背景。
- 修正 shell、sidebar 與 stage 之間不均勻的大量留白。

## 0.4.1 — 2026-08-21

### 修正

- `KlpWorkbenchShell` 新增可選的 `paneGap`，讓消費端以 theme token 同時控制欄間距與
  resize handle 命中寬度；未指定時仍沿用 `space.base`，既有視覺不變。
- Notist 可將外框與欄間距一併設為 `space.tight`，避免 4px 外框中混入 16px 欄間距。

## 0.4.0 — 2026-08-21

這個 minor 版本加入可由產品資料驅動的筆記頁背景與編輯能力，並完成 Windows 自訂
視窗框架及互動狀態語言。所有視覺值仍由 theme／geometry token 解析，不新增元件內
寫死的顏色、圓角或間距。

### 加入

- 頁面背景 recipe、viewport、固定／縮放筆畫模式，以及受控的點線背景編輯器。
- Windows runner 工作區最大化契約、視窗最小尺寸傳遞與完整的標題列 geometry token。
- 統一的 hover／focus／selected 互動狀態驗證與對應元件測試。

### 變更

- `KlpApp` 依 theme geometry 約束 app icon、標題列高度與最小視窗尺寸；非正的
  `minWidth`／`minHeight` 會在建構時拒絕。
- 視窗控制鈕、file explorer 與工作台配置改由 semantic token 驅動；正常寬度維持
  既有排列，極窄啟動寬度優先保留視窗控制鈕。

### 修正

- 修正 Windows header 在 148px 內容寬度、同時含標題、圖示與 action 時的水平
  RenderFlex overflow；次要內容只在空間不足時依方向裁切。
- 最大化視窗仍可把拖曳手勢交給原生 runner，並由 runner 決定還原／移動行為。

## 0.3.1 — 2026-08-21

這個 patch 版本關閉 `0.3.0` 發布審查發現的 JSON theme 邊界問題，不改變任何
既有顏色或元件視覺。

### 修正

- typography 尺寸與 leading 必須大於 0，text field 的 min/max lines 關係在
  JSON decode 邊界以完整 path 驗證。
- data-visualization 的 raw colors 回到 `KlpPalette` primitive 層，semantic theme 不再
  需要 token discipline 例外。
- `KlpVisualStyleJson.encode` 的公開簽名直接回傳 `Map<String, Object?>`，不洩漏
  internal typedef。

## 0.3.0 — 2026-08-21

Kallopis 現在可以把 JSON 設定檔解碼成完整的 `KlpVisualStyle`，並以同一個 theme
入口控制顏色、字體、間距、邊界、圓角、動態、表面效果與 component token。
這個版本保留原有視覺結果，並讓本機與遠端消費者都能選擇可重現的來源。

### 加入

- **JSON theme 邊界**：`KlpVisualStyleJson` 可完整編碼 style，也可以指定 base style
  解碼局部 JSON；未提供的欄位沿用 base，不再由元件自行藏預設風格。
- **明確的錯誤邊界**：不合法型別、範圍或未知欄位會立即失敗，並在
  `FormatException` 中提供完整 JSON 路徑，避免設定錯字靜默失效。
- **Geometry semantic token**：控制項、資料元件、overlay、responsive layout 與光學校正
  的既有數值移入 theme；元件不再直接讀取 `Klp*Metrics` 或 primitive 色彩。
- **可重現發布**：Notist 繼續使用本機 path dependency；其他消費者可固定
  Git tag。`v*` tag 通過全部 CI 後會自動建立 GitHub Release。

### 變更

- 版本號、CHANGELOG 與 Git tag 由 release job 機械比對，不一致時不會建立
  GitHub Release。
- 新 token 均有 constructor 預設值，既有 Dart 呼叫維持相容；非整數毫秒 duration 與
  無法無損序列化的 curve 會在 JSON encode 邊界明確拒絕。
- 依賴發布政策維持 `publish_to: none`；Kallopis 不發布到 pub.dev。

## 0.2.0 — 2026-08-20

第一個可以被其他本機專案直接使用的版本。發布形式是 path dependency，
刻意不上 pub.dev（見 README「安裝與依賴」）。

**刻意不是 1.0.0。** 1.0.0 是 API 穩定的承諾，而語意色在亮態表面上的對比尚未
定案、公開型別仍有 78 個沒有 dartdoc。等那兩件事收斂再談。

### 加入

- **`KlpApp`** — 包住 `MaterialApp` 的接入層。套好亮暗兩套 theme、把主題過場歸零、
  可選地架好 `KlpRouterScope`。消費者不必再自己組一次樣板。
- **七個元件**：`KlpAccordion`、`KlpStepper`、`KlpTimeline`、`KlpDrawer`、
  `KlpContextMenu`、`KlpCalendar`、`KlpCombobox`。`KlpDateField` 已接上 `KlpCalendar`。
- **CI**（`.github/workflows/ci.yml`）：格式、`analyze --fatal-infos`、測試、
  元件清單新鮮度。測試跑在 windows runner 上——golden 產生於 Windows，換平台會整批假失敗。
- **40 張逐頁 golden**：20 個目錄頁 × 明暗兩態。驗證過三件事：連跑兩次一致、
  改一個間距 token 會 40 張全紅、總計 4.85 MB。
- 新閘門：互動狀態紀律、圖示網格與線寬、元件內字面值棘輪、dartdoc 交叉引用。

### 修正

- **`KlpBadge` 的預設變體丟棄 `tone`。** `KlpBadge(label: 'X', tone: success)`
  這個最自然的寫法什麼都不做，且無任何錯誤訊息——連目錄自己頁首的完成度徽章都踩到。
  語意色改為疊層而非實色（實色會讓標籤在亮態下掉出 AA）。
- **hover 統一為只有低對比虛線細框**，不再改變任何顏色。先前十幾個元件各自實作。
- **不合法輸入改為半透明紅底**，不再預混成不透明色——預混會在欄位換到別的表面時對不上。
- 亮態 divider 改用 `ink200`；`KlpRegion` 補上預設面板內距。

### 架構

- **收斂三處「一條規則兩份實作」**：`context.klpColors` 改為委派、
  新增 `KlpTheme.isDark`、抽出 `KlpTokenOverride`。
- **分層違規 15 → 3**。`klp_foundation_extras.dart`（17 個類別的雜物袋）已拆解刪除，
  12 個歸錯領域的元件搬到 `data/`、`surface/`、`interaction/`、`overlay/`、
  `typography/`、`feedback/`、`shell/`。
- **刪除 26 個零引用的 typedef 別名**，其中 12 個帶 Planist 產品語意
  （`KlpAgentPicker`、`KlpMcpPicker` 等），違反抽層規則 5。
  同時解除 `KlpComboBox` 與 `KlpCombobox` 只差大小寫的命名危險。
- 元件內的尺寸與透明度字面值 13 → 3，其餘搬進 token 層（數值照抄，畫面未變）。
- 未文件化的公開型別 156 → 78。

### 已知欠債

- 語意色在亮態表面上的對比為 1.48–2.45，低於 AA 4.5。`KlpInlineNotice` 把它當
  圖示前景時在亮態下近乎不可見。需要決定：回到明暗分離值，或限定只作填色並用
  `onStatus` 當前景。
- golden 截的是 1400×900 視窗，內容比視窗高的頁面捲動線以下不在基準內。
- 無障礙 `Semantics` 與鍵盤導覽的覆蓋仍低；`KlpMenu`、`KlpCommandMenu`、`KlpTabs`
  等尚無方向鍵操作。
- 庫內仍有硬編碼字串，尚無 l10n delegate。`KlpToast` 的做法（強制呼叫端提供標籤）
  是正確範例，但未貫徹。

## 0.1.0 — 2026-08-18

Kallopis 的第一個可用版本，由 Planist `lib/design_system/` 抽取而來。

### 加入

- **三層 design token**：primitive（`KlpScale`／`KlpPalette`，不可覆寫）→ semantic
  （色彩／字體／間距／形狀／動態／表面，皆為 `ThemeExtension`）→ component
  （`KlpComponentTheme`，欄位全 nullable）。
- **`KlpVisualStyle`**：把七層綁成必須整組給定的物件，換風格是單一動作。
  **庫只出貨 `modern` 一套，各層也只有一個 preset**——要別的外觀是逐層 `copyWith`，
  庫不預先替任何產品組好第二套。
- **`KlpTheme.of(context)` / `context.klp`**：元件取值的唯一入口，回傳已沿繼承樹解析
  的結果。任一層缺席時回退預設而非拋錯。
- 68 個通過五條抽層規則的元件。
- `example/`：可實際執行的元件目錄（Windows），分為 6 組 19 頁，124 個 widget 全數歸類。
- **`KlpRouter`**：只負責分發的目的地登記簿。庫不知道有哪些頁、不預設入口、
  不決定階層、不做轉場、不解析網址。
- `tool/inventory.dart`：由實際程式碼產生元件清單與 mermaid 元件樹，並檢查分層方向。

### 移除（相對於 Planist 的 design_system）

依五條抽層規則裁掉圖表族、資料庫視圖、時間軸、KPI 指標、任務卡、專案與邀請協作、
AI 對話 UI、diff 檢視。逐項理由見 `spec/component-classification.md`。

### 修正（抽取過程中發現的既有缺陷）

- `KlpTextField` 與 `KlpSlider` 內部使用 Material 系元件卻未提供 `Material` 祖先，
  導致消費者一放上去就拋 `No Material widget found`。現由庫自己提供。
- `buildKlpTheme` 會靜默丟棄傳入的 `style.colors`，改用 brightness 挑內建 preset
  ——消費者的品牌色不會生效，也不會報錯。現在 `style.colors` 是唯一來源。
- 明暗判斷原本用 `identical(baseTokens, KlpThemeData.light)`，任何自訂色盤都不會
  `identical` 於 preset，因此永遠被當成暗色。改為由實際表面色的亮度推導。
- `accent` 參數原本有預設值，會覆寫消費者設定的 interaction 色。改為 nullable。
- `hoverContrastMix` 在 `KlpInteraction` 與 `KlpSurfaceTheme` 各有一份實作。
- `KlpDialog.secondaryLabel` 與 `KlpToast.closeLabel` 原本寫死中文，現為必填。
- `KlpPalette` 未從 barrel 匯出，消費者拿不到 primitive 層。
- `KlpAppScreen` 未提供 `Material` 祖先，導致其下的每一段文字都被 Flutter 畫上黃色
  雙底線的除錯提示。它不拋錯、不被 analyze 抓到，只出現在畫面上。

### 色彩系統

中性色改為 **ink 11 階色梯**（`ink50`–`ink950`），權威格式為 oklch。原本的
`paper`／`canvas`／`chalk`／`dusk`／`night` 等 30 餘個各自命名的中性色全部移除
——它們的名字看不出彼此的明度關係。

視覺識別因此由暖調紙感轉為冷調中性（色相 232°–292°）。

換色梯時發現一個既有的無障礙問題：**五個彩色強調色全部卡在 AA 的 4.5 邊緣**，
新表面只亮了一點就全數掉出（4.39–4.43）。已重新校準到 ≥ 4.70，並把門檻寫成測試
（要求 4.6 的餘裕，下次調整色梯不會立刻踩線）。

### 已知限制

- `example/` 僅有 Windows 平台設定。
- 無障礙 `Semantics` 覆蓋 76 個檔案中的 22 個。
- `klp_advanced_data`（20 個布林參數）與 `klp_foundation_extras`（17 個類別的雜物袋）
  未通過抽層規則 4，待重構。
- 只有一個實際消費者時，庫的介面有一部分是猜的；Notist 尚未接上。
