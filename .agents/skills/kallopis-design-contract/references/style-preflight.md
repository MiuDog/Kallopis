# 風格繼承與實作前置檢查

## 已查證的繼承樹

```text
KlpScale / KlpPalette
  ↓ 提供設計語彙，元件不可直接使用
Semantic ThemeExtension
  ├─ KlpThemeData（color）
  ├─ KlpTypographyTheme（type）
  ├─ KlpSpacingTheme（space）
  ├─ KlpShapeTheme（shape）
  ├─ KlpMotionTheme（motion）
  ├─ KlpSurfaceTheme（surface）
  ├─ KlpGeometryTheme（geometry）
  └─ KlpDataVisualizationTheme
  ↓ 預設來源
KlpComponentTheme（稀疏 nullable override）
  ↓ 由 KlpTheme resolver 合併
context.klp 的已解析 getter
  ↓
Kallopis widget
  ↓
產品只傳語意資料、狀態、事件與主要內容
```

`KlpVisualStyle` 將完整風格成組送入 `ThemeData.extensions`。`KlpTheme.of(context)` 是元件取值的唯一入口；extension 缺席會回退預設值，因此「能渲染」不代表繼承正確。

`KlpTokenOverride` 只替換子樹的 `KlpThemeData` 色彩 extension，其餘 semantic 與 component extension 沿用祖先。檢查 surface 內文字或 icon 時必須把這一層列入解析路徑。

## 權威來源

依任務只讀相關段落：

- 三層架構與 override 規則：`README.md`「三層 Token 繼承架構」。
- 抽層決策：`spec/decisions/KLP-0001-scope-token-architecture-and-extraction-method.md`。
- 呈現所有權：`spec/decisions/KLP-0004-presentation-decisions-owned-by-kallopis.md`。
- 完整風格組：`lib/src/theme/klp_visual_style.dart`。
- runtime 解析與局部色彩覆寫：`lib/src/theme/klp_theme_scope.dart`。
- 元件實際組合：`docs/architecture/components/<domain>/<component>.md` 與元件原始碼。

## 屬性權限表

改碼前在工作筆記或 commentary 完成以下欄位：

| 屬性 | 參考要求 | 權限 | 目前來源 | 完整解析路徑 | 修改層 | 歧義 |
|---|---|---|---|---|---|---|
| 例：tab x | 設計稿標註 164 px | 精確幾何 | header layout | geometry → header → positioned | Kallopis geometry | 無 |
| 例：tab 背景 | 使用 stage surface | Kallopis 語意 | `stageSurface` | app theme → surface override → tab | Kallopis component | 無 |

「使用 token」不是完整解析路徑。至少要回答：

1. 讀的是哪個 `context.klp` getter？
2. getter 是否先經過 `KlpComponentTheme.resolve*`？
3. 祖先是否存在 `KlpTokenOverride`？
4. 值屬於 semantic spacing、geometry 還是 component override？
5. 參考稿要求的是精確值，還是授權設計系統自行決定？

## 停止條件

出現以下任一情況，先停止實作：

- 只能由截圖猜測精確像素，且不同縮放會導致不同結果。
- 參考稿精確值與既有 Kallopis token 不同，但修改正確 token 會影響其他消費端，尚未評估。
- 同一屬性同時被 user contract 與已接受 decision 指向不同所有權層。
- 找不到 component resolver 或實際 surface override，無法說明畫面最終值從哪裡來。
