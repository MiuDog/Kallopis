# klp_text_style_definition.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/foundation/content/klp_text_style_definition.dart)

## 範圍

核心是 `lib/src/foundation/content/klp_text_style_definition.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_text_style_definition.dart"]
	n1["package:flutter/widgets.dart"]
	n2["../../styling/legacy_theme/klp_typography_theme.dart"]
	n3["klp_font_role.dart"]
	n4["klp_text_color_tier.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/foundation/content/klp_text_style_definition.dart:1](../../../../../lib/src/foundation/content/klp_text_style_definition.dart#L1) |
| import | <code>import &#x27;../../styling/legacy_theme/klp_typography_theme.dart&#x27;;</code> | [lib/src/foundation/content/klp_text_style_definition.dart:3](../../../../../lib/src/foundation/content/klp_text_style_definition.dart#L3) |
| import | <code>import &#x27;klp_font_role.dart&#x27;;</code> | [lib/src/foundation/content/klp_text_style_definition.dart:4](../../../../../lib/src/foundation/content/klp_text_style_definition.dart#L4) |
| import | <code>import &#x27;klp_text_color_tier.dart&#x27;;</code> | [lib/src/foundation/content/klp_text_style_definition.dart:5](../../../../../lib/src/foundation/content/klp_text_style_definition.dart#L5) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpTextStyleDefinition"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpTextStyleDefinition

ClassDeclaration · public · [lib/src/foundation/content/klp_text_style_definition.dart:7](../../../../../lib/src/foundation/content/klp_text_style_definition.dart#L7)

<code>class KlpTextStyleDefinition</code>

來源註解摘要：單一文字角色由目前 theme 解析後的完整樣式參數。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpTextStyleDefinition</code> | public | <code>const KlpTextStyleDefinition({ required this.fontSize, required this.lineHeight, required this.fontWeight, required this.tier, this.letterSpacing, this.family = KlpFontRole.ui, })</code> |  | [lib/src/foundation/content/klp_text_style_definition.dart:10](../../../../../lib/src/foundation/content/klp_text_style_definition.dart#L10) |
| field <code>fontSize</code> | public | <code>final double fontSize</code> |  | [lib/src/foundation/content/klp_text_style_definition.dart:19](../../../../../lib/src/foundation/content/klp_text_style_definition.dart#L19) |
| field <code>lineHeight</code> | public | <code>final double lineHeight</code> |  | [lib/src/foundation/content/klp_text_style_definition.dart:20](../../../../../lib/src/foundation/content/klp_text_style_definition.dart#L20) |
| field <code>fontWeight</code> | public | <code>final FontWeight fontWeight</code> |  | [lib/src/foundation/content/klp_text_style_definition.dart:21](../../../../../lib/src/foundation/content/klp_text_style_definition.dart#L21) |
| field <code>tier</code> | public | <code>final KlpTextColorTier tier</code> |  | [lib/src/foundation/content/klp_text_style_definition.dart:22](../../../../../lib/src/foundation/content/klp_text_style_definition.dart#L22) |
| field <code>letterSpacing</code> | public | <code>final double? letterSpacing</code> |  | [lib/src/foundation/content/klp_text_style_definition.dart:23](../../../../../lib/src/foundation/content/klp_text_style_definition.dart#L23) |
| field <code>family</code> | public | <code>final KlpFontRole family</code> |  | [lib/src/foundation/content/klp_text_style_definition.dart:24](../../../../../lib/src/foundation/content/klp_text_style_definition.dart#L24) |
| method <code>toTextStyle</code> | public | <code>TextStyle toTextStyle(KlpTypographyTheme type)</code> |  | [lib/src/foundation/content/klp_text_style_definition.dart:26](../../../../../lib/src/foundation/content/klp_text_style_definition.dart#L26) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
