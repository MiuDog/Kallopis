# klp_bound_text_style.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/foundation/binding/internal/klp_bound_text_style.dart)

## 範圍

核心是 `lib/src/foundation/binding/internal/klp_bound_text_style.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_bound_text_style.dart"]
	n1["../../../styling/primitives/klp_style_value.dart"]
	n0 -->|"import"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../../../styling/primitives/klp_style_value.dart&#x27;;</code> | [lib/src/foundation/binding/internal/klp_bound_text_style.dart:1](../../../../../../lib/src/foundation/binding/internal/klp_bound_text_style.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpBoundTextStyle"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpBoundTextStyle

ClassDeclaration · public · [lib/src/foundation/binding/internal/klp_bound_text_style.dart:3](../../../../../../lib/src/foundation/binding/internal/klp_bound_text_style.dart#L3)

<code>final class KlpBoundTextStyle</code>

來源註解摘要：文字模板解析後的完整結果，轉換到平台型別由 renderer 負責。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>color</code> | public | <code>final KlpColor color</code> |  | [lib/src/foundation/binding/internal/klp_bound_text_style.dart:5](../../../../../../lib/src/foundation/binding/internal/klp_bound_text_style.dart#L5) |
| field <code>fontFamily</code> | public | <code>final KlpFontFamily fontFamily</code> |  | [lib/src/foundation/binding/internal/klp_bound_text_style.dart:6](../../../../../../lib/src/foundation/binding/internal/klp_bound_text_style.dart#L6) |
| field <code>fontSize</code> | public | <code>final KlpFontSize fontSize</code> |  | [lib/src/foundation/binding/internal/klp_bound_text_style.dart:7](../../../../../../lib/src/foundation/binding/internal/klp_bound_text_style.dart#L7) |
| field <code>fontWeight</code> | public | <code>final KlpFontWeight fontWeight</code> |  | [lib/src/foundation/binding/internal/klp_bound_text_style.dart:8](../../../../../../lib/src/foundation/binding/internal/klp_bound_text_style.dart#L8) |
| field <code>lineHeight</code> | public | <code>final KlpLineHeight lineHeight</code> |  | [lib/src/foundation/binding/internal/klp_bound_text_style.dart:9](../../../../../../lib/src/foundation/binding/internal/klp_bound_text_style.dart#L9) |
| field <code>letterSpacing</code> | public | <code>final KlpLetterSpacing letterSpacing</code> |  | [lib/src/foundation/binding/internal/klp_bound_text_style.dart:10](../../../../../../lib/src/foundation/binding/internal/klp_bound_text_style.dart#L10) |
| constructor <code>KlpBoundTextStyle</code> | public | <code>const KlpBoundTextStyle({ required this.color, required this.fontFamily, required this.fontSize, required this.fontWeight, required this.lineHeight, required this.letterSpacing, })</code> |  | [lib/src/foundation/binding/internal/klp_bound_text_style.dart:12](../../../../../../lib/src/foundation/binding/internal/klp_bound_text_style.dart#L12) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
