# klp_text_semantics.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/foundation/templates/klp_text_semantics.dart)

## 範圍

核心是 `lib/src/foundation/templates/klp_text_semantics.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_text_semantics.dart"]
	n1["../../styling/primitives/klp_style_value.dart"]
	n2["../../styling/semantics/klp_semantic_key.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../../styling/primitives/klp_style_value.dart&#x27;;</code> | [lib/src/foundation/templates/klp_text_semantics.dart:1](../../../../../lib/src/foundation/templates/klp_text_semantics.dart#L1) |
| import | <code>import &#x27;../../styling/semantics/klp_semantic_key.dart&#x27;;</code> | [lib/src/foundation/templates/klp_text_semantics.dart:2](../../../../../lib/src/foundation/templates/klp_text_semantics.dart#L2) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpTextSemantics"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpTextSemantics

ClassDeclaration · public · [lib/src/foundation/templates/klp_text_semantics.dart:4](../../../../../lib/src/foundation/templates/klp_text_semantics.dart#L4)

<code>final class KlpTextSemantics</code>

來源註解摘要：文字呈現所需的完整型別參照，實際值由本庫語意解析取得。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>color</code> | public | <code>final KlpSemanticKey&lt;KlpColor&gt; color</code> |  | [lib/src/foundation/templates/klp_text_semantics.dart:7](../../../../../lib/src/foundation/templates/klp_text_semantics.dart#L7) |
| field <code>fontFamily</code> | public | <code>final KlpSemanticKey&lt;KlpFontFamily&gt; fontFamily</code> |  | [lib/src/foundation/templates/klp_text_semantics.dart:8](../../../../../lib/src/foundation/templates/klp_text_semantics.dart#L8) |
| field <code>fontSize</code> | public | <code>final KlpSemanticKey&lt;KlpFontSize&gt; fontSize</code> |  | [lib/src/foundation/templates/klp_text_semantics.dart:9](../../../../../lib/src/foundation/templates/klp_text_semantics.dart#L9) |
| field <code>fontWeight</code> | public | <code>final KlpSemanticKey&lt;KlpFontWeight&gt; fontWeight</code> |  | [lib/src/foundation/templates/klp_text_semantics.dart:10](../../../../../lib/src/foundation/templates/klp_text_semantics.dart#L10) |
| field <code>lineHeight</code> | public | <code>final KlpSemanticKey&lt;KlpLineHeight&gt; lineHeight</code> |  | [lib/src/foundation/templates/klp_text_semantics.dart:11](../../../../../lib/src/foundation/templates/klp_text_semantics.dart#L11) |
| field <code>letterSpacing</code> | public | <code>final KlpSemanticKey&lt;KlpLetterSpacing&gt; letterSpacing</code> |  | [lib/src/foundation/templates/klp_text_semantics.dart:12](../../../../../lib/src/foundation/templates/klp_text_semantics.dart#L12) |
| constructor <code>KlpTextSemantics</code> | public | <code>const KlpTextSemantics({ required this.color, required this.fontFamily, required this.fontSize, required this.fontWeight, required this.lineHeight, required this.letterSpacing, })</code> |  | [lib/src/foundation/templates/klp_text_semantics.dart:14](../../../../../lib/src/foundation/templates/klp_text_semantics.dart#L14) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
