# klp_scope_boundary_adapter.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart)

## 範圍

核心是 `lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_scope_boundary_adapter.dart"]
	n1["../../../composition/definitions/klp_definition.dart"]
	n2["../../../composition/nodes/internal/klp_scope_boundary.dart"]
	n3["../../../composition/nodes/klp_node.dart"]
	n4["../../../composition/validation/klp_validated_node.dart"]
	n5["../../../foundation/binding/internal/klp_bound_template.dart"]
	n6["../../../kernel/lifecycle/internal/klp_frame_lease.dart"]
	n7["../../installation/internal/klp_default_placement.dart"]
	n8["../../installation/internal/klp_placement_resource.dart"]
	n9["klp_node_adapter.dart"]
	n10["klp_prepare_context.dart"]
	n11["klp_prepared_node.dart"]
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
	n0["klp_scope_boundary_adapter.dart"]
	n1["klp_prepared_activation_policy.dart"]
	n0 -->|"import"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../../../composition/definitions/klp_definition.dart&#x27;;</code> | [lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart:1](../../../../../../lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart#L1) |
| import | <code>import &#x27;../../../composition/nodes/internal/klp_scope_boundary.dart&#x27;;</code> | [lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart:2](../../../../../../lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart#L2) |
| import | <code>import &#x27;../../../composition/nodes/klp_node.dart&#x27;;</code> | [lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart:3](../../../../../../lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart#L3) |
| import | <code>import &#x27;../../../composition/validation/klp_validated_node.dart&#x27;;</code> | [lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart:4](../../../../../../lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart#L4) |
| import | <code>import &#x27;../../../foundation/binding/internal/klp_bound_template.dart&#x27;;</code> | [lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart:5](../../../../../../lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart#L5) |
| import | <code>import &#x27;../../../kernel/lifecycle/internal/klp_frame_lease.dart&#x27;;</code> | [lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart:6](../../../../../../lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart#L6) |
| import | <code>import &#x27;../../installation/internal/klp_default_placement.dart&#x27;;</code> | [lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart:7](../../../../../../lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart#L7) |
| import | <code>import &#x27;../../installation/internal/klp_placement_resource.dart&#x27;;</code> | [lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart:8](../../../../../../lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart#L8) |
| import | <code>import &#x27;klp_node_adapter.dart&#x27;;</code> | [lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart:9](../../../../../../lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart#L9) |
| import | <code>import &#x27;klp_prepare_context.dart&#x27;;</code> | [lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart:10](../../../../../../lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart#L10) |
| import | <code>import &#x27;klp_prepared_node.dart&#x27;;</code> | [lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart:11](../../../../../../lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart#L11) |
| import | <code>import &#x27;klp_prepared_activation_policy.dart&#x27;;</code> | [lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart:12](../../../../../../lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart#L12) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpScopeBoundaryAdapter"]
	class n1["_PreparedBoundary"]
```

```mermaid
classDiagram
	class n0["KlpScopeBoundaryAdapter"]
	class n1["KlpNodeAdapter"]
	n0 ..|> n1 : implements
```

```mermaid
classDiagram
	class n0["_PreparedBoundary"]
	class n1["KlpPreparedNode"]
	class n2["KlpPreparedActivationPolicy"]
	n0 ..|> n1 : implements
	n0 ..|> n2 : implements
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpScopeBoundaryAdapter

ClassDeclaration · public · [lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart:14](../../../../../../lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart#L14)

<code>final class KlpScopeBoundaryAdapter implements KlpNodeAdapter</code>

來源註解摘要：作用域只隔離識別，不另建 runtime 或改寫子節點資料。

- `implements` → <code>KlpNodeAdapter</code>：[lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart:15](../../../../../../lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart#L15)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpScopeBoundaryAdapter</code> | public | <code>const KlpScopeBoundaryAdapter()</code> |  | [lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart:17](../../../../../../lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart#L17) |
| getter <code>contract</code> | public | <code>KlpDefinition&lt;KlpNode&gt; get contract</code> |  | [lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart:19](../../../../../../lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart#L19) |
| method <code>prepare</code> | public | <code>KlpPreparedNode prepare(KlpNode node, KlpValidatedNode snapshot, KlpPrepareContext context)</code> |  | [lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart:22](../../../../../../lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart#L22) |

### _PreparedBoundary

ClassDeclaration · private · [lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart:26](../../../../../../lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart#L26)

<code>final class _PreparedBoundary implements KlpPreparedNode, KlpPreparedActivationPolicy</code>

- `implements` → <code>KlpPreparedNode</code>：[lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart:26](../../../../../../lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart#L26)
- `implements` → <code>KlpPreparedActivationPolicy</code>：[lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart:26](../../../../../../lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart#L26)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>descendantsActive</code> | public | <code>final bool descendantsActive</code> |  | [lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart:29](../../../../../../lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart#L29) |
| constructor <code>_PreparedBoundary</code> | private | <code>const _PreparedBoundary(this.descendantsActive)</code> |  | [lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart:31](../../../../../../lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart#L31) |
| method <code>createResource</code> | public | <code>KlpPlacementResource createResource(KlpValidatedNode node)</code> |  | [lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart:33](../../../../../../lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart#L33) |
| method <code>materialize</code> | public | <code>KlpBoundTemplate materialize(KlpPlacementResource resource, List&lt;KlpBoundTemplate&gt; children, KlpFrameLease lease)</code> |  | [lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart:36](../../../../../../lib/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart#L36) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
