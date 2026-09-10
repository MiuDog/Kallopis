# klp_screen_adapter.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/application/bootstrap/internal/klp_screen_adapter.dart)

## 範圍

核心是 `lib/src/application/bootstrap/internal/klp_screen_adapter.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_screen_adapter.dart"]
	n1["../../../composition/definitions/klp_definition.dart"]
	n2["../../../composition/nodes/klp_node.dart"]
	n3["../../../composition/validation/klp_validated_node.dart"]
	n4["../../../runtime/compilation/internal/klp_node_adapter.dart"]
	n5["../../../runtime/compilation/internal/klp_prepare_context.dart"]
	n6["../../../runtime/compilation/internal/klp_prepared_node.dart"]
	n7["../../../styling/primitives/klp_primitive_index.dart"]
	n8["../../../styling/primitives/klp_style_kind.dart"]
	n9["../../../styling/references/klp_style_ref.dart"]
	n10["../../../styling/semantics/klp_semantic_key.dart"]
	n11["../../../styling/semantics/klp_semantic_schema.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
	n0 -->|"import"| n8
	n0 -->|"import"| n9
	n0 -->|"import"| n10
	n0 -->|"import"| n11
```

```mermaid
flowchart TD
	n0["klp_screen_adapter.dart"]
	n1["../../../styling/semantics/klp_semantic_token.dart"]
	n2["../../structure/klp_screen.dart"]
	n3["klp_prepared_screen.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../../../composition/definitions/klp_definition.dart&#x27;;</code> | [lib/src/application/bootstrap/internal/klp_screen_adapter.dart:1](../../../../../../lib/src/application/bootstrap/internal/klp_screen_adapter.dart#L1) |
| import | <code>import &#x27;../../../composition/nodes/klp_node.dart&#x27;;</code> | [lib/src/application/bootstrap/internal/klp_screen_adapter.dart:2](../../../../../../lib/src/application/bootstrap/internal/klp_screen_adapter.dart#L2) |
| import | <code>import &#x27;../../../composition/validation/klp_validated_node.dart&#x27;;</code> | [lib/src/application/bootstrap/internal/klp_screen_adapter.dart:3](../../../../../../lib/src/application/bootstrap/internal/klp_screen_adapter.dart#L3) |
| import | <code>import &#x27;../../../runtime/compilation/internal/klp_node_adapter.dart&#x27;;</code> | [lib/src/application/bootstrap/internal/klp_screen_adapter.dart:4](../../../../../../lib/src/application/bootstrap/internal/klp_screen_adapter.dart#L4) |
| import | <code>import &#x27;../../../runtime/compilation/internal/klp_prepare_context.dart&#x27;;</code> | [lib/src/application/bootstrap/internal/klp_screen_adapter.dart:5](../../../../../../lib/src/application/bootstrap/internal/klp_screen_adapter.dart#L5) |
| import | <code>import &#x27;../../../runtime/compilation/internal/klp_prepared_node.dart&#x27;;</code> | [lib/src/application/bootstrap/internal/klp_screen_adapter.dart:6](../../../../../../lib/src/application/bootstrap/internal/klp_screen_adapter.dart#L6) |
| import | <code>import &#x27;../../../styling/primitives/klp_primitive_index.dart&#x27;;</code> | [lib/src/application/bootstrap/internal/klp_screen_adapter.dart:7](../../../../../../lib/src/application/bootstrap/internal/klp_screen_adapter.dart#L7) |
| import | <code>import &#x27;../../../styling/primitives/klp_style_kind.dart&#x27;;</code> | [lib/src/application/bootstrap/internal/klp_screen_adapter.dart:8](../../../../../../lib/src/application/bootstrap/internal/klp_screen_adapter.dart#L8) |
| import | <code>import &#x27;../../../styling/references/klp_style_ref.dart&#x27;;</code> | [lib/src/application/bootstrap/internal/klp_screen_adapter.dart:9](../../../../../../lib/src/application/bootstrap/internal/klp_screen_adapter.dart#L9) |
| import | <code>import &#x27;../../../styling/semantics/klp_semantic_key.dart&#x27;;</code> | [lib/src/application/bootstrap/internal/klp_screen_adapter.dart:10](../../../../../../lib/src/application/bootstrap/internal/klp_screen_adapter.dart#L10) |
| import | <code>import &#x27;../../../styling/semantics/klp_semantic_schema.dart&#x27;;</code> | [lib/src/application/bootstrap/internal/klp_screen_adapter.dart:11](../../../../../../lib/src/application/bootstrap/internal/klp_screen_adapter.dart#L11) |
| import | <code>import &#x27;../../../styling/semantics/klp_semantic_token.dart&#x27;;</code> | [lib/src/application/bootstrap/internal/klp_screen_adapter.dart:12](../../../../../../lib/src/application/bootstrap/internal/klp_screen_adapter.dart#L12) |
| import | <code>import &#x27;../../structure/klp_screen.dart&#x27;;</code> | [lib/src/application/bootstrap/internal/klp_screen_adapter.dart:13](../../../../../../lib/src/application/bootstrap/internal/klp_screen_adapter.dart#L13) |
| import | <code>import &#x27;klp_prepared_screen.dart&#x27;;</code> | [lib/src/application/bootstrap/internal/klp_screen_adapter.dart:14](../../../../../../lib/src/application/bootstrap/internal/klp_screen_adapter.dart#L14) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpScreenAdapter"]
```

```mermaid
classDiagram
	class n0["KlpScreenAdapter"]
	class n1["KlpNodeAdapter"]
	n0 ..|> n1 : implements
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpScreenAdapter

ClassDeclaration · public · [lib/src/application/bootstrap/internal/klp_screen_adapter.dart:16](../../../../../../lib/src/application/bootstrap/internal/klp_screen_adapter.dart#L16)

<code>final class KlpScreenAdapter implements KlpNodeAdapter</code>

來源註解摘要：畫面底層用途由本庫定義；槽位映射尚未作正式預設風格承諾。

- `implements` → <code>KlpNodeAdapter</code>：[lib/src/application/bootstrap/internal/klp_screen_adapter.dart:17](../../../../../../lib/src/application/bootstrap/internal/klp_screen_adapter.dart#L17)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>background</code> | public | <code>static final (inferred) background</code> |  | [lib/src/application/bootstrap/internal/klp_screen_adapter.dart:19](../../../../../../lib/src/application/bootstrap/internal/klp_screen_adapter.dart#L19) |
| field <code>radius</code> | public | <code>static final (inferred) radius</code> |  | [lib/src/application/bootstrap/internal/klp_screen_adapter.dart:20](../../../../../../lib/src/application/bootstrap/internal/klp_screen_adapter.dart#L20) |
| field <code>inset</code> | public | <code>static final (inferred) inset</code> |  | [lib/src/application/bootstrap/internal/klp_screen_adapter.dart:21](../../../../../../lib/src/application/bootstrap/internal/klp_screen_adapter.dart#L21) |
| field <code>contract</code> | public | <code>final KlpDefinition&lt;KlpScreen&gt; contract</code> |  | [lib/src/application/bootstrap/internal/klp_screen_adapter.dart:24](../../../../../../lib/src/application/bootstrap/internal/klp_screen_adapter.dart#L24) |
| method <code>prepare</code> | public | <code>KlpPreparedNode prepare(KlpNode node, KlpValidatedNode snapshot, KlpPrepareContext context)</code> |  | [lib/src/application/bootstrap/internal/klp_screen_adapter.dart:30](../../../../../../lib/src/application/bootstrap/internal/klp_screen_adapter.dart#L30) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
