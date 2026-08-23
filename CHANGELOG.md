# Changelog

## 0.5.0 — 2026-08-23

這個 minor 版本把 Kallopis 的視窗、工作台與區塊式筆記風格收斂為消費端可直接採用的
預設，並加入 Docs、Canva 與 Sheet 的元件目錄示範。消費端不必再重複指定 header 尺寸、
panel 間距或 Sheet 捲動與選取演算法。

### 加入

- `KlpSheetGrid` 提供可向右、向下延伸的表格、受控儲存格資料、選取、鍵盤移動、編輯提交
  與雙軸捲動。
- `KlpBlock` 提供區塊選取、hover／focus 高亮、六點操作把手、選單錨點與可選拖曳回呼，
  作為 Docs 類區塊筆記的共通互動基底。
- Notes 元件目錄新增 Docs、Canva 與 Sheet 頁面，涵蓋多欄文件、結構化區塊、自由畫布互動
  與無限延伸表格。
- `KlpApp.startMaximized` 預設在首次建立時確保原生視窗最大化；消費端可明確停用。

### 變更

- `KlpWorkbenchShell` 預設為 shell 與 sidebar／stage panel 套用均勻的 theme 間距；header
  維持全寬，內容起點與下方 panel 對齊。
- `KlpBlock` 建構介面新增必要的 `handleLabel`、`onHandlePressed` 與 `onPressed`；既有消費端
  升級時需提供區塊操作語意與受控選取行為。
- 視窗 header 的 app icon 尺寸、控制鈕尺寸、內距與 action 配置統一由 Kallopis geometry
  token 決定，消費端只需傳入 icon。
- 一般按鈕 hover／選取使用表面高亮；explorer 與表單維持低／高對比虛線邊框語言。

### 修正

- 修正 Windows 最大化工作區、工作列命中、header 拖曳還原、視窗邊緣 resize 與最小尺寸
  契約，並避免極窄或短暫低高度視窗產生 RenderFlex overflow。
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
