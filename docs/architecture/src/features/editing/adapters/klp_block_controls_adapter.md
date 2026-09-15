# klp_block_controls_adapter.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/editing/adapters/klp_block_controls_adapter.dart)

## 範圍

核心是 `lib/src/features/editing/adapters/klp_block_controls_adapter.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_block_controls_adapter.dart"]
	n1["package:kallopis/src/features/editing/presentation/klp_editing_presentation.dart"]
	n2["package:kallopis/src/composition/definitions/klp_definition.dart"]
	n3["package:kallopis/src/composition/nodes/klp_node.dart"]
	n4["package:kallopis/src/composition/validation/klp_validated_node.dart"]
	n5["package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart"]
	n6["package:kallopis/src/kernel/lifecycle/klp_frame_lease.dart"]
	n7["package:kallopis/src/kernel/diagnostics/klp_contract_error.dart"]
	n8["package:kallopis/src/runtime/contracts/klp_node_adapter.dart"]
	n9["package:kallopis/src/runtime/contracts/klp_prepare_context.dart"]
	n10["package:kallopis/src/runtime/contracts/klp_prepared_node.dart"]
	n11["package:kallopis/src/runtime/installation/klp_default_placement.dart"]
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
	n0["klp_block_controls_adapter.dart"]
	n1["package:kallopis/src/runtime/contracts/klp_placement_resource.dart"]
	n2["package:kallopis/src/features/editing/contracts/klp_block_controls.dart"]
	n3["package:kallopis/src/features/editing/contracts/klp_editing_content.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:kallopis/src/features/editing/presentation/klp_editing_presentation.dart&#x27;;</code> | [lib/src/features/editing/adapters/klp_block_controls_adapter.dart:1](../../../../../../lib/src/features/editing/adapters/klp_block_controls_adapter.dart#L1) |
| import | <code>import &#x27;package:kallopis/src/composition/definitions/klp_definition.dart&#x27;;</code> | [lib/src/features/editing/adapters/klp_block_controls_adapter.dart:2](../../../../../../lib/src/features/editing/adapters/klp_block_controls_adapter.dart#L2) |
| import | <code>import &#x27;package:kallopis/src/composition/nodes/klp_node.dart&#x27;;</code> | [lib/src/features/editing/adapters/klp_block_controls_adapter.dart:3](../../../../../../lib/src/features/editing/adapters/klp_block_controls_adapter.dart#L3) |
| import | <code>import &#x27;package:kallopis/src/composition/validation/klp_validated_node.dart&#x27;;</code> | [lib/src/features/editing/adapters/klp_block_controls_adapter.dart:4](../../../../../../lib/src/features/editing/adapters/klp_block_controls_adapter.dart#L4) |
| import | <code>import &#x27;package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart&#x27;;</code> | [lib/src/features/editing/adapters/klp_block_controls_adapter.dart:5](../../../../../../lib/src/features/editing/adapters/klp_block_controls_adapter.dart#L5) |
| import | <code>import &#x27;package:kallopis/src/kernel/lifecycle/klp_frame_lease.dart&#x27;;</code> | [lib/src/features/editing/adapters/klp_block_controls_adapter.dart:6](../../../../../../lib/src/features/editing/adapters/klp_block_controls_adapter.dart#L6) |
| import | <code>import &#x27;package:kallopis/src/kernel/diagnostics/klp_contract_error.dart&#x27;;</code> | [lib/src/features/editing/adapters/klp_block_controls_adapter.dart:7](../../../../../../lib/src/features/editing/adapters/klp_block_controls_adapter.dart#L7) |
| import | <code>import &#x27;package:kallopis/src/runtime/contracts/klp_node_adapter.dart&#x27;;</code> | [lib/src/features/editing/adapters/klp_block_controls_adapter.dart:8](../../../../../../lib/src/features/editing/adapters/klp_block_controls_adapter.dart#L8) |
| import | <code>import &#x27;package:kallopis/src/runtime/contracts/klp_prepare_context.dart&#x27;;</code> | [lib/src/features/editing/adapters/klp_block_controls_adapter.dart:9](../../../../../../lib/src/features/editing/adapters/klp_block_controls_adapter.dart#L9) |
| import | <code>import &#x27;package:kallopis/src/runtime/contracts/klp_prepared_node.dart&#x27;;</code> | [lib/src/features/editing/adapters/klp_block_controls_adapter.dart:10](../../../../../../lib/src/features/editing/adapters/klp_block_controls_adapter.dart#L10) |
| import | <code>import &#x27;package:kallopis/src/runtime/installation/klp_default_placement.dart&#x27;;</code> | [lib/src/features/editing/adapters/klp_block_controls_adapter.dart:11](../../../../../../lib/src/features/editing/adapters/klp_block_controls_adapter.dart#L11) |
| import | <code>import &#x27;package:kallopis/src/runtime/contracts/klp_placement_resource.dart&#x27;;</code> | [lib/src/features/editing/adapters/klp_block_controls_adapter.dart:12](../../../../../../lib/src/features/editing/adapters/klp_block_controls_adapter.dart#L12) |
| import | <code>import &#x27;package:kallopis/src/features/editing/contracts/klp_block_controls.dart&#x27;;</code> | [lib/src/features/editing/adapters/klp_block_controls_adapter.dart:13](../../../../../../lib/src/features/editing/adapters/klp_block_controls_adapter.dart#L13) |
| import | <code>import &#x27;package:kallopis/src/features/editing/contracts/klp_editing_content.dart&#x27;;</code> | [lib/src/features/editing/adapters/klp_block_controls_adapter.dart:14](../../../../../../lib/src/features/editing/adapters/klp_block_controls_adapter.dart#L14) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpBlockControlsAdapter"]
	class n1["_KlpPreparedBlockControls"]
```

```mermaid
classDiagram
	class n0["KlpBlockControlsAdapter"]
	class n1["KlpNodeAdapter"]
	n0 ..|> n1 : implements
```

```mermaid
classDiagram
	class n0["_KlpPreparedBlockControls"]
	class n1["KlpPreparedNode"]
	n0 ..|> n1 : implements
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpBlockControlsAdapter

ClassDeclaration · public · [lib/src/features/editing/adapters/klp_block_controls_adapter.dart:16](../../../../../../lib/src/features/editing/adapters/klp_block_controls_adapter.dart#L16)

<code>final class KlpBlockControlsAdapter implements KlpNodeAdapter</code>

來源註解摘要：區塊控制子節點只攜帶結構身分；父編輯節點注入同一來源能力。

- `implements` → <code>KlpNodeAdapter</code>：[lib/src/features/editing/adapters/klp_block_controls_adapter.dart:17](../../../../../../lib/src/features/editing/adapters/klp_block_controls_adapter.dart#L17)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| getter <code>contract</code> | public | <code>KlpDefinition&lt;KlpNode&gt; get contract</code> |  | [lib/src/features/editing/adapters/klp_block_controls_adapter.dart:18](../../../../../../lib/src/features/editing/adapters/klp_block_controls_adapter.dart#L18) |
| method <code>prepare</code> | public | <code>KlpPreparedNode prepare(KlpNode node, KlpValidatedNode snapshot, KlpPrepareContext context)</code> |  | [lib/src/features/editing/adapters/klp_block_controls_adapter.dart:21](../../../../../../lib/src/features/editing/adapters/klp_block_controls_adapter.dart#L21) |

### _KlpPreparedBlockControls

ClassDeclaration · private · [lib/src/features/editing/adapters/klp_block_controls_adapter.dart:31](../../../../../../lib/src/features/editing/adapters/klp_block_controls_adapter.dart#L31)

<code>final class _KlpPreparedBlockControls implements KlpPreparedNode</code>

- `implements` → <code>KlpPreparedNode</code>：[lib/src/features/editing/adapters/klp_block_controls_adapter.dart:31](../../../../../../lib/src/features/editing/adapters/klp_block_controls_adapter.dart#L31)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>id</code> | public | <code>final String id</code> |  | [lib/src/features/editing/adapters/klp_block_controls_adapter.dart:32](../../../../../../lib/src/features/editing/adapters/klp_block_controls_adapter.dart#L32) |
| constructor <code>_KlpPreparedBlockControls</code> | private | <code>const _KlpPreparedBlockControls(this.id)</code> |  | [lib/src/features/editing/adapters/klp_block_controls_adapter.dart:34](../../../../../../lib/src/features/editing/adapters/klp_block_controls_adapter.dart#L34) |
| method <code>createResource</code> | public | <code>KlpPlacementResource createResource(KlpValidatedNode node)</code> |  | [lib/src/features/editing/adapters/klp_block_controls_adapter.dart:36](../../../../../../lib/src/features/editing/adapters/klp_block_controls_adapter.dart#L36) |
| method <code>materialize</code> | public | <code>KlpBoundTemplate materialize(KlpPlacementResource resource, List&lt;KlpBoundTemplate&gt; children, KlpFrameLease lease)</code> |  | [lib/src/features/editing/adapters/klp_block_controls_adapter.dart:39](../../../../../../lib/src/features/editing/adapters/klp_block_controls_adapter.dart#L39) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
