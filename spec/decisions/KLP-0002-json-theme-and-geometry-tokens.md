# KLP-0002：JSON theme 與 geometry semantic token

狀態：Accepted（2026-08-21）

## 背景

`KlpVisualStyle` 原本能整組切換 semantic 與 component token，但只能由 Dart 程式碼建立。
部分元件仍直接讀 `Klp*Metrics` 或在元件內做圓角、透明度與尺寸運算，因此「theme 有欄位」
不等於「覆寫後畫面會響應」。Notist 需要從外部 JSON 載入完整風格，且預設畫面不能改變。

## 選項

1. **每個元件自行解析 JSON**：檔案少，但 schema、驗證與 fallback 會散落，拒絕。
2. **把所有幾何欄位塞進 `KlpSpacingTheme`**：接線直接，但會把密度尺度與元件幾何混為一談，
   並繼續擴大既有大檔，拒絕。
3. **單一 JSON 邊界 + 分組 geometry semantic token**：schema 集中，元件只讀 theme，採用。

## 決定與適用邊界

- `KlpVisualStyleJson` 是唯一 JSON 編解碼入口。decode 採 base overlay，拒絕未知欄位，
  錯誤必須包含完整 JSON path。
- `KlpVisualStyle` 綁定 color、typography、spacing、shape、motion、surface、geometry、
  data visualization 與稀疏 component token；切換 style 仍是一個原子動作。
- 不屬於密度尺度的精確幾何放進 `KlpGeometryTheme`，依 control、data、layout、optical 分組。
- 舊 `Klp*Metrics` 保留為公開相容 API 與預設值來源，但庫內元件不可直接讀取。
- JSON 色彩使用 `#AARRGGBB`（輸入另接受 `#RRGGBB`）、duration 使用整數毫秒、
  font weight 使用 100–900 整數。Curve 只序列化可無損描述的 Flutter `Cubic`；其他
  `Curve` 在 encode 邊界明確失敗，不做近似。
- `publish_to: none` 不變。本機消費使用 path dependency，跨機器重現使用固定 Git tag。

## 代價

- JSON schema 成為公開契約；新增 token 必須同步 codec 與測試。
- geometry 多一層 ThemeExtension，但換來欄位職責與大檔邊界清楚。
- 任意自訂 `Curve` 仍可用 Dart API，卻不能直接輸出 JSON；呼叫端需改用等價 `Cubic`。

## 閘門

- `test/klp_visual_style_json_test.dart`：round-trip、overlay、unknown field、range、schema 與
  非無損值拒絕。
- `test/geometry_theme_compatibility_test.dart`：新增 optional token 不破壞既有 constructor。
- `test/token_discipline_test.dart`：元件不得讀 primitive／舊 static metrics。
- `test/color_discipline_test.dart`：元件不得直接讀 `KlpPalette` 或 `Colors.*`。
- golden 不因本決策更新；任何新增差異都是視覺回歸。

## 已知欠債

- `KlpThemePreviewTile` 是繪製「視窗示意圖」的插畫，保留 3 個繪圖透明度字面值；它們不是
  產品表面風格。token discipline 以既有 baseline 鎖住，數量不可增加。
- JSON schema 目前為版本 1；尚未需要 migration API。遇到第一個破壞性 schema 變更時，
  必須另寫決策並提供明確版本遷移。
