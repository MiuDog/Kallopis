# klp_composition_text.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/capabilities/editing/contracts/klp_composition_text.dart)

## 範圍

核心是 `lib/src/capabilities/editing/contracts/klp_composition_text.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_composition_text.dart"]
	n1["klp_text_offsets.dart"]
	n2["klp_composition_segment.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;klp_text_offsets.dart&#x27;;</code> | [lib/src/capabilities/editing/contracts/klp_composition_text.dart:1](../../../../../../lib/src/capabilities/editing/contracts/klp_composition_text.dart#L1) |
| import | <code>import &#x27;klp_composition_segment.dart&#x27;;</code> | [lib/src/capabilities/editing/contracts/klp_composition_text.dart:2](../../../../../../lib/src/capabilities/editing/contracts/klp_composition_text.dart#L2) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpCompositionText"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpCompositionText

ClassDeclaration · public · [lib/src/capabilities/editing/contracts/klp_composition_text.dart:4](../../../../../../lib/src/capabilities/editing/contracts/klp_composition_text.dart#L4)

<code>final class KlpCompositionText</code>

來源註解摘要：暫定文字及相對選取；允許空預覽，位移不指向已提交文件。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>text</code> | public | <code>final String text</code> |  | [lib/src/capabilities/editing/contracts/klp_composition_text.dart:7](../../../../../../lib/src/capabilities/editing/contracts/klp_composition_text.dart#L7) |
| field <code>anchorUtf8</code> | public | <code>final int anchorUtf8</code> |  | [lib/src/capabilities/editing/contracts/klp_composition_text.dart:8](../../../../../../lib/src/capabilities/editing/contracts/klp_composition_text.dart#L8) |
| field <code>focusUtf8</code> | public | <code>final int focusUtf8</code> |  | [lib/src/capabilities/editing/contracts/klp_composition_text.dart:9](../../../../../../lib/src/capabilities/editing/contracts/klp_composition_text.dart#L9) |
| field <code>segments</code> | public | <code>final List&lt;KlpCompositionSegment&gt; segments</code> |  | [lib/src/capabilities/editing/contracts/klp_composition_text.dart:10](../../../../../../lib/src/capabilities/editing/contracts/klp_composition_text.dart#L10) |
| constructor <code>KlpCompositionText</code> | public | <code>KlpCompositionText( this.text, this.anchorUtf8, this.focusUtf8, { Iterable&lt;KlpCompositionSegment&gt; segments = const [], })</code> |  | [lib/src/capabilities/editing/contracts/klp_composition_text.dart:12](../../../../../../lib/src/capabilities/editing/contracts/klp_composition_text.dart#L12) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
