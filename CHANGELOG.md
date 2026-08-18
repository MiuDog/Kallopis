# Changelog

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
- `example/`：可實際執行的元件目錄（Windows）。
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

### 已知限制

- `example/` 僅有 Windows 平台設定。
- 無障礙 `Semantics` 覆蓋 76 個檔案中的 22 個。
- `klp_advanced_data`（20 個布林參數）與 `klp_foundation_extras`（17 個類別的雜物袋）
  未通過抽層規則 4，待重構。
- 只有一個實際消費者時，庫的介面有一部分是猜的；Notist 尚未接上。
