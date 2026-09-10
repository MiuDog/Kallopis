# klp_semantic_schema.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/styling/semantics/klp_semantic_schema.dart)

## 範圍

核心是 `lib/src/styling/semantics/klp_semantic_schema.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_semantic_schema.dart"]
	n1["../../kernel/diagnostics/klp_contract_error.dart"]
	n2["../primitives/klp_style_value.dart"]
	n3["internal/klp_semantic_identifier.dart"]
	n4["klp_semantic_token.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../../kernel/diagnostics/klp_contract_error.dart&#x27;;</code> | [lib/src/styling/semantics/klp_semantic_schema.dart:1](../../../../../lib/src/styling/semantics/klp_semantic_schema.dart#L1) |
| import | <code>import &#x27;../primitives/klp_style_value.dart&#x27;;</code> | [lib/src/styling/semantics/klp_semantic_schema.dart:2](../../../../../lib/src/styling/semantics/klp_semantic_schema.dart#L2) |
| import | <code>import &#x27;internal/klp_semantic_identifier.dart&#x27;;</code> | [lib/src/styling/semantics/klp_semantic_schema.dart:3](../../../../../lib/src/styling/semantics/klp_semantic_schema.dart#L3) |
| import | <code>import &#x27;klp_semantic_token.dart&#x27;;</code> | [lib/src/styling/semantics/klp_semantic_schema.dart:4](../../../../../lib/src/styling/semantics/klp_semantic_schema.dart#L4) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpSemanticSchema"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpSemanticSchema

ClassDeclaration · public · [lib/src/styling/semantics/klp_semantic_schema.dart:6](../../../../../lib/src/styling/semantics/klp_semantic_schema.dart#L6)

<code>final class KlpSemanticSchema</code>

來源註解摘要：單一定義擁有的不可變用途集合；相依宣告不提供覆寫能力。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>owner</code> | public | <code>final String owner</code> |  | [lib/src/styling/semantics/klp_semantic_schema.dart:9](../../../../../lib/src/styling/semantics/klp_semantic_schema.dart#L9) |
| field <code>tokens</code> | public | <code>final List&lt;KlpSemanticToken&lt;KlpStyleValue&gt;&gt; tokens</code> |  | [lib/src/styling/semantics/klp_semantic_schema.dart:10](../../../../../lib/src/styling/semantics/klp_semantic_schema.dart#L10) |
| field <code>dependencies</code> | public | <code>final List&lt;String&gt; dependencies</code> |  | [lib/src/styling/semantics/klp_semantic_schema.dart:11](../../../../../lib/src/styling/semantics/klp_semantic_schema.dart#L11) |
| constructor <code>KlpSemanticSchema</code> | public | <code>KlpSemanticSchema(this.owner, Iterable&lt;KlpSemanticToken&lt;KlpStyleValue&gt;&gt; tokens, {Iterable&lt;String&gt; dependencies = const []})</code> |  | [lib/src/styling/semantics/klp_semantic_schema.dart:13](../../../../../lib/src/styling/semantics/klp_semantic_schema.dart#L13) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
