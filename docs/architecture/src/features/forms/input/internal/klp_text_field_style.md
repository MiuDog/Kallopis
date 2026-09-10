# klp_text_field_style.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/forms/input/internal/klp_text_field_style.dart)

## 範圍

核心是 `lib/src/features/forms/input/internal/klp_text_field_style.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_text_field_style.dart"]
	n1["../klp_text_field.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_text_field.dart&#x27;;</code> | [lib/src/features/forms/input/internal/klp_text_field_style.dart:1](../../../../../../../lib/src/features/forms/input/internal/klp_text_field_style.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["_KlpTextFieldStyle"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### _KlpTextFieldStyle

ClassDeclaration · private · [lib/src/features/forms/input/internal/klp_text_field_style.dart:3](../../../../../../../lib/src/features/forms/input/internal/klp_text_field_style.dart#L3)

<code>class _KlpTextFieldStyle</code>


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>_KlpTextFieldStyle</code> | private | <code>const _KlpTextFieldStyle({ required this.fillColor, required this.borderColor, required this.textColor, required this.hintColor, required this.iconColor, required this.cursorColor, required this.fieldHeight, required this.fontSize, required this.horizontalPadding, required this.verticalPadding, required this.controlInset, required this.stepActionHeight, required this.radius, required this.borderWidth, required this.lineHeight, required this.fontFamily, required this.fontFamilyFallback, required this.defaultMinLines, required this.defaultMaxLines, })</code> |  | [lib/src/features/forms/input/internal/klp_text_field_style.dart:4](../../../../../../../lib/src/features/forms/input/internal/klp_text_field_style.dart#L4) |
| field <code>fillColor</code> | public | <code>final Color fillColor</code> |  | [lib/src/features/forms/input/internal/klp_text_field_style.dart:26](../../../../../../../lib/src/features/forms/input/internal/klp_text_field_style.dart#L26) |
| field <code>borderColor</code> | public | <code>final Color borderColor</code> |  | [lib/src/features/forms/input/internal/klp_text_field_style.dart:27](../../../../../../../lib/src/features/forms/input/internal/klp_text_field_style.dart#L27) |
| field <code>textColor</code> | public | <code>final Color textColor</code> |  | [lib/src/features/forms/input/internal/klp_text_field_style.dart:28](../../../../../../../lib/src/features/forms/input/internal/klp_text_field_style.dart#L28) |
| field <code>hintColor</code> | public | <code>final Color hintColor</code> |  | [lib/src/features/forms/input/internal/klp_text_field_style.dart:29](../../../../../../../lib/src/features/forms/input/internal/klp_text_field_style.dart#L29) |
| field <code>iconColor</code> | public | <code>final Color iconColor</code> |  | [lib/src/features/forms/input/internal/klp_text_field_style.dart:30](../../../../../../../lib/src/features/forms/input/internal/klp_text_field_style.dart#L30) |
| field <code>cursorColor</code> | public | <code>final Color cursorColor</code> |  | [lib/src/features/forms/input/internal/klp_text_field_style.dart:31](../../../../../../../lib/src/features/forms/input/internal/klp_text_field_style.dart#L31) |
| field <code>fieldHeight</code> | public | <code>final double fieldHeight</code> |  | [lib/src/features/forms/input/internal/klp_text_field_style.dart:32](../../../../../../../lib/src/features/forms/input/internal/klp_text_field_style.dart#L32) |
| field <code>fontSize</code> | public | <code>final double fontSize</code> |  | [lib/src/features/forms/input/internal/klp_text_field_style.dart:33](../../../../../../../lib/src/features/forms/input/internal/klp_text_field_style.dart#L33) |
| field <code>horizontalPadding</code> | public | <code>final double horizontalPadding</code> |  | [lib/src/features/forms/input/internal/klp_text_field_style.dart:34](../../../../../../../lib/src/features/forms/input/internal/klp_text_field_style.dart#L34) |
| field <code>verticalPadding</code> | public | <code>final double verticalPadding</code> |  | [lib/src/features/forms/input/internal/klp_text_field_style.dart:35](../../../../../../../lib/src/features/forms/input/internal/klp_text_field_style.dart#L35) |
| field <code>controlInset</code> | public | <code>final double controlInset</code> |  | [lib/src/features/forms/input/internal/klp_text_field_style.dart:36](../../../../../../../lib/src/features/forms/input/internal/klp_text_field_style.dart#L36) |
| field <code>stepActionHeight</code> | public | <code>final double stepActionHeight</code> |  | [lib/src/features/forms/input/internal/klp_text_field_style.dart:37](../../../../../../../lib/src/features/forms/input/internal/klp_text_field_style.dart#L37) |
| field <code>radius</code> | public | <code>final double radius</code> |  | [lib/src/features/forms/input/internal/klp_text_field_style.dart:38](../../../../../../../lib/src/features/forms/input/internal/klp_text_field_style.dart#L38) |
| field <code>borderWidth</code> | public | <code>final double borderWidth</code> |  | [lib/src/features/forms/input/internal/klp_text_field_style.dart:39](../../../../../../../lib/src/features/forms/input/internal/klp_text_field_style.dart#L39) |
| field <code>lineHeight</code> | public | <code>final double lineHeight</code> |  | [lib/src/features/forms/input/internal/klp_text_field_style.dart:40](../../../../../../../lib/src/features/forms/input/internal/klp_text_field_style.dart#L40) |
| field <code>fontFamily</code> | public | <code>final String fontFamily</code> |  | [lib/src/features/forms/input/internal/klp_text_field_style.dart:41](../../../../../../../lib/src/features/forms/input/internal/klp_text_field_style.dart#L41) |
| field <code>fontFamilyFallback</code> | public | <code>final List&lt;String&gt; fontFamilyFallback</code> |  | [lib/src/features/forms/input/internal/klp_text_field_style.dart:42](../../../../../../../lib/src/features/forms/input/internal/klp_text_field_style.dart#L42) |
| field <code>defaultMinLines</code> | public | <code>final int defaultMinLines</code> |  | [lib/src/features/forms/input/internal/klp_text_field_style.dart:43](../../../../../../../lib/src/features/forms/input/internal/klp_text_field_style.dart#L43) |
| field <code>defaultMaxLines</code> | public | <code>final int defaultMaxLines</code> |  | [lib/src/features/forms/input/internal/klp_text_field_style.dart:44](../../../../../../../lib/src/features/forms/input/internal/klp_text_field_style.dart#L44) |
| constructor <code>resolve</code> | public | <code>factory _KlpTextFieldStyle.resolve( KlpTheme klp, { required KlpControlSize size, required bool enabled, required bool invalid, required bool multiline, required bool outlined, required bool focused, })</code> |  | [lib/src/features/forms/input/internal/klp_text_field_style.dart:46](../../../../../../../lib/src/features/forms/input/internal/klp_text_field_style.dart#L46) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
