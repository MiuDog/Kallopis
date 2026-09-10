# klp_prepare_context.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/runtime/compilation/internal/klp_prepare_context.dart)

## 範圍

核心是 `lib/src/runtime/compilation/internal/klp_prepare_context.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_prepare_context.dart"]
	n1["../../../composition/nodes/klp_node.dart"]
	n2["../../../composition/validation/klp_validated_node.dart"]
	n3["../../../kernel/identity/klp_placement_id.dart"]
	n4["../../../foundation/binding/internal/klp_component_compiler.dart"]
	n5["../../../styling/primitives/klp_primitive_set.dart"]
	n6["../../../styling/resolution/internal/klp_semantic_resolution.dart"]
	n7["../../../capabilities/actions/klp_action_handler.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../../../composition/nodes/klp_node.dart&#x27;;</code> | [lib/src/runtime/compilation/internal/klp_prepare_context.dart:1](../../../../../../lib/src/runtime/compilation/internal/klp_prepare_context.dart#L1) |
| import | <code>import &#x27;../../../composition/validation/klp_validated_node.dart&#x27;;</code> | [lib/src/runtime/compilation/internal/klp_prepare_context.dart:2](../../../../../../lib/src/runtime/compilation/internal/klp_prepare_context.dart#L2) |
| import | <code>import &#x27;../../../kernel/identity/klp_placement_id.dart&#x27;;</code> | [lib/src/runtime/compilation/internal/klp_prepare_context.dart:3](../../../../../../lib/src/runtime/compilation/internal/klp_prepare_context.dart#L3) |
| import | <code>import &#x27;../../../foundation/binding/internal/klp_component_compiler.dart&#x27;;</code> | [lib/src/runtime/compilation/internal/klp_prepare_context.dart:4](../../../../../../lib/src/runtime/compilation/internal/klp_prepare_context.dart#L4) |
| import | <code>import &#x27;../../../styling/primitives/klp_primitive_set.dart&#x27;;</code> | [lib/src/runtime/compilation/internal/klp_prepare_context.dart:5](../../../../../../lib/src/runtime/compilation/internal/klp_prepare_context.dart#L5) |
| import | <code>import &#x27;../../../styling/resolution/internal/klp_semantic_resolution.dart&#x27;;</code> | [lib/src/runtime/compilation/internal/klp_prepare_context.dart:6](../../../../../../lib/src/runtime/compilation/internal/klp_prepare_context.dart#L6) |
| import | <code>import &#x27;../../../capabilities/actions/klp_action_handler.dart&#x27;;</code> | [lib/src/runtime/compilation/internal/klp_prepare_context.dart:7](../../../../../../lib/src/runtime/compilation/internal/klp_prepare_context.dart#L7) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpPrepareContext"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpPrepareContext

ClassDeclaration · public · [lib/src/runtime/compilation/internal/klp_prepare_context.dart:9](../../../../../../lib/src/runtime/compilation/internal/klp_prepare_context.dart#L9)

<code>final class KlpPrepareContext</code>

來源註解摘要：單次準備使用的快照；renderer 不會取得外部節點物件。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>sources</code> | public | <code>final Map&lt;KlpPlacementId, KlpNode&gt; sources</code> |  | [lib/src/runtime/compilation/internal/klp_prepare_context.dart:12](../../../../../../lib/src/runtime/compilation/internal/klp_prepare_context.dart#L12) |
| field <code>nodes</code> | public | <code>final Map&lt;KlpPlacementId, KlpValidatedNode&gt; nodes</code> |  | [lib/src/runtime/compilation/internal/klp_prepare_context.dart:13](../../../../../../lib/src/runtime/compilation/internal/klp_prepare_context.dart#L13) |
| field <code>components</code> | public | <code>final KlpComponentCompiler components</code> |  | [lib/src/runtime/compilation/internal/klp_prepare_context.dart:14](../../../../../../lib/src/runtime/compilation/internal/klp_prepare_context.dart#L14) |
| field <code>primitives</code> | public | <code>final KlpPrimitiveSet primitives</code> |  | [lib/src/runtime/compilation/internal/klp_prepare_context.dart:15](../../../../../../lib/src/runtime/compilation/internal/klp_prepare_context.dart#L15) |
| field <code>style</code> | public | <code>final KlpSemanticResolution style</code> |  | [lib/src/runtime/compilation/internal/klp_prepare_context.dart:16](../../../../../../lib/src/runtime/compilation/internal/klp_prepare_context.dart#L16) |
| field <code>actionHandler</code> | public | <code>final KlpActionHandler? actionHandler</code> |  | [lib/src/runtime/compilation/internal/klp_prepare_context.dart:17](../../../../../../lib/src/runtime/compilation/internal/klp_prepare_context.dart#L17) |
| constructor <code>KlpPrepareContext</code> | public | <code>KlpPrepareContext({ required Map&lt;KlpPlacementId, KlpNode&gt; sources, required Map&lt;KlpPlacementId, KlpValidatedNode&gt; nodes, required this.components, required this.primitives, required this.style, this.actionHandler, })</code> |  | [lib/src/runtime/compilation/internal/klp_prepare_context.dart:19](../../../../../../lib/src/runtime/compilation/internal/klp_prepare_context.dart#L19) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
