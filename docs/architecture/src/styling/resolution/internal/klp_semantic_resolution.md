# klp_semantic_resolution.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/styling/resolution/internal/klp_semantic_resolution.dart)

## 範圍

核心是 `lib/src/styling/resolution/internal/klp_semantic_resolution.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_semantic_resolution.dart"]
	n1["../../../kernel/diagnostics/klp_contract_error.dart"]
	n2["../../primitives/klp_style_value.dart"]
	n3["../../semantics/klp_semantic_key.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../../../kernel/diagnostics/klp_contract_error.dart&#x27;;</code> | [lib/src/styling/resolution/internal/klp_semantic_resolution.dart:1](../../../../../../lib/src/styling/resolution/internal/klp_semantic_resolution.dart#L1) |
| import | <code>import &#x27;../../primitives/klp_style_value.dart&#x27;;</code> | [lib/src/styling/resolution/internal/klp_semantic_resolution.dart:2](../../../../../../lib/src/styling/resolution/internal/klp_semantic_resolution.dart#L2) |
| import | <code>import &#x27;../../semantics/klp_semantic_key.dart&#x27;;</code> | [lib/src/styling/resolution/internal/klp_semantic_resolution.dart:3](../../../../../../lib/src/styling/resolution/internal/klp_semantic_resolution.dart#L3) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpSemanticResolution"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpSemanticResolution

ClassDeclaration · public · [lib/src/styling/resolution/internal/klp_semantic_resolution.dart:5](../../../../../../lib/src/styling/resolution/internal/klp_semantic_resolution.dart#L5)

<code>final class KlpSemanticResolution</code>

來源註解摘要：本庫持有的單次求值快照，不向消費端暴露可寫入風格表。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>_values</code> | private | <code>final Map&lt;(String, String), KlpStyleValue&gt; _values</code> |  | [lib/src/styling/resolution/internal/klp_semantic_resolution.dart:7](../../../../../../lib/src/styling/resolution/internal/klp_semantic_resolution.dart#L7) |
| constructor <code>KlpSemanticResolution</code> | public | <code>KlpSemanticResolution(Map&lt;(String, String), KlpStyleValue&gt; values)</code> |  | [lib/src/styling/resolution/internal/klp_semantic_resolution.dart:9](../../../../../../lib/src/styling/resolution/internal/klp_semantic_resolution.dart#L9) |
| method <code>read</code> | public | <code>T read&lt;T extends KlpStyleValue&gt;(KlpSemanticKey&lt;T&gt; key)</code> |  | [lib/src/styling/resolution/internal/klp_semantic_resolution.dart:12](../../../../../../lib/src/styling/resolution/internal/klp_semantic_resolution.dart#L12) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
