# klp_rail_adapter.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_adapter.dart)

## 範圍

核心是 `lib/src/features/navigation/rail/internal/klp_rail_adapter.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_rail_adapter.dart"]
	n1["../../../../composition/definitions/klp_definition.dart"]
	n2["../../../../composition/nodes/klp_node.dart"]
	n3["../../../../composition/validation/klp_validated_node.dart"]
	n4["../../../../foundation/binding/internal/klp_bound_choice_style.dart"]
	n5["../../../../kernel/diagnostics/klp_contract_error.dart"]
	n6["../../../../kernel/identity/klp_placement_id.dart"]
	n7["../../../../runtime/compilation/internal/klp_node_adapter.dart"]
	n8["../../../../runtime/compilation/internal/klp_prepare_context.dart"]
	n9["../../../../runtime/compilation/internal/klp_prepared_node.dart"]
	n10["../../../../styling/primitives/klp_style_value.dart"]
	n11["../../../../capabilities/actions/klp_action.dart"]
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
flowchart LR
	n0["klp_rail_adapter.dart"]
	n1["../../../../capabilities/actions/klp_action_handler.dart"]
	n2["../contracts/klp_rail.dart"]
	n3["../contracts/klp_rail_item.dart"]
	n4["klp_prepared_rail.dart"]
	n5["klp_rail_semantics.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../../../../composition/definitions/klp_definition.dart&#x27;;</code> | [lib/src/features/navigation/rail/internal/klp_rail_adapter.dart:1](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_adapter.dart#L1) |
| import | <code>import &#x27;../../../../composition/nodes/klp_node.dart&#x27;;</code> | [lib/src/features/navigation/rail/internal/klp_rail_adapter.dart:2](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_adapter.dart#L2) |
| import | <code>import &#x27;../../../../composition/validation/klp_validated_node.dart&#x27;;</code> | [lib/src/features/navigation/rail/internal/klp_rail_adapter.dart:3](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_adapter.dart#L3) |
| import | <code>import &#x27;../../../../foundation/binding/internal/klp_bound_choice_style.dart&#x27;;</code> | [lib/src/features/navigation/rail/internal/klp_rail_adapter.dart:4](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_adapter.dart#L4) |
| import | <code>import &#x27;../../../../kernel/diagnostics/klp_contract_error.dart&#x27;;</code> | [lib/src/features/navigation/rail/internal/klp_rail_adapter.dart:5](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_adapter.dart#L5) |
| import | <code>import &#x27;../../../../kernel/identity/klp_placement_id.dart&#x27;;</code> | [lib/src/features/navigation/rail/internal/klp_rail_adapter.dart:6](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_adapter.dart#L6) |
| import | <code>import &#x27;../../../../runtime/compilation/internal/klp_node_adapter.dart&#x27;;</code> | [lib/src/features/navigation/rail/internal/klp_rail_adapter.dart:7](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_adapter.dart#L7) |
| import | <code>import &#x27;../../../../runtime/compilation/internal/klp_prepare_context.dart&#x27;;</code> | [lib/src/features/navigation/rail/internal/klp_rail_adapter.dart:8](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_adapter.dart#L8) |
| import | <code>import &#x27;../../../../runtime/compilation/internal/klp_prepared_node.dart&#x27;;</code> | [lib/src/features/navigation/rail/internal/klp_rail_adapter.dart:9](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_adapter.dart#L9) |
| import | <code>import &#x27;../../../../styling/primitives/klp_style_value.dart&#x27;;</code> | [lib/src/features/navigation/rail/internal/klp_rail_adapter.dart:10](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_adapter.dart#L10) |
| import | <code>import &#x27;../../../../capabilities/actions/klp_action.dart&#x27;;</code> | [lib/src/features/navigation/rail/internal/klp_rail_adapter.dart:11](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_adapter.dart#L11) |
| import | <code>import &#x27;../../../../capabilities/actions/klp_action_handler.dart&#x27;;</code> | [lib/src/features/navigation/rail/internal/klp_rail_adapter.dart:12](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_adapter.dart#L12) |
| import | <code>import &#x27;../contracts/klp_rail.dart&#x27;;</code> | [lib/src/features/navigation/rail/internal/klp_rail_adapter.dart:13](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_adapter.dart#L13) |
| import | <code>import &#x27;../contracts/klp_rail_item.dart&#x27;;</code> | [lib/src/features/navigation/rail/internal/klp_rail_adapter.dart:14](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_adapter.dart#L14) |
| import | <code>import &#x27;klp_prepared_rail.dart&#x27;;</code> | [lib/src/features/navigation/rail/internal/klp_rail_adapter.dart:15](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_adapter.dart#L15) |
| import | <code>import &#x27;klp_rail_semantics.dart&#x27;;</code> | [lib/src/features/navigation/rail/internal/klp_rail_adapter.dart:16](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_adapter.dart#L16) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpRailAdapter"]
```

```mermaid
classDiagram
	class n0["KlpRailAdapter"]
	class n1["KlpNodeAdapter"]
	n0 ..|> n1 : implements
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpRailAdapter

ClassDeclaration · public · [lib/src/features/navigation/rail/internal/klp_rail_adapter.dart:18](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_adapter.dart#L18)

<code>final class KlpRailAdapter implements KlpNodeAdapter</code>

來源註解摘要：本庫功能轉譯器，將資格插槽降為受控基礎層，不依賴 Flutter。

- `implements` → <code>KlpNodeAdapter</code>：[lib/src/features/navigation/rail/internal/klp_rail_adapter.dart:19](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_adapter.dart#L19)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpRailAdapter</code> | public | <code>const KlpRailAdapter()</code> |  | [lib/src/features/navigation/rail/internal/klp_rail_adapter.dart:20](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_adapter.dart#L20) |
| getter <code>contract</code> | public | <code>KlpDefinition&lt;KlpNode&gt; get contract</code> |  | [lib/src/features/navigation/rail/internal/klp_rail_adapter.dart:22](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_adapter.dart#L22) |
| method <code>prepare</code> | public | <code>KlpPreparedNode prepare( KlpNode node, KlpValidatedNode snapshot, KlpPrepareContext context, )</code> |  | [lib/src/features/navigation/rail/internal/klp_rail_adapter.dart:29](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_adapter.dart#L29) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
