# klp_workspace_components_adapter.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart)

## 範圍

核心是 `lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_workspace_components_adapter.dart"]
	n1["package:kallopis/src/features/workspace/presentation/klp_workspace_presentation.dart"]
	n2["package:kallopis/src/composition/definitions/klp_definition.dart"]
	n3["package:kallopis/src/composition/nodes/klp_node.dart"]
	n4["package:kallopis/src/composition/validation/klp_validated_node.dart"]
	n5["package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart"]
	n6["package:kallopis/src/foundation/binding/contracts/klp_bound_text_style.dart"]
	n7["package:kallopis/src/kernel/lifecycle/klp_frame_lease.dart"]
	n8["package:kallopis/src/kernel/identity/klp_id.dart"]
	n9["package:kallopis/src/kernel/identity/klp_placement_id.dart"]
	n10["package:kallopis/src/runtime/contracts/klp_node_adapter.dart"]
	n11["package:kallopis/src/runtime/contracts/klp_prepare_context.dart"]
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
	n0["klp_workspace_components_adapter.dart"]
	n1["package:kallopis/src/runtime/contracts/klp_prepared_node.dart"]
	n2["package:kallopis/src/runtime/installation/klp_default_placement.dart"]
	n3["package:kallopis/src/runtime/contracts/klp_placement_resource.dart"]
	n4["package:kallopis/src/styling/primitives/klp_primitive_index.dart"]
	n5["package:kallopis/src/styling/primitives/klp_style_kind.dart"]
	n6["package:kallopis/src/styling/primitives/klp_style_value.dart"]
	n7["package:kallopis/src/styling/references/klp_style_ref.dart"]
	n8["package:kallopis/src/styling/resolution/klp_semantic_resolution.dart"]
	n9["package:kallopis/src/styling/semantics/klp_semantic_key.dart"]
	n10["package:kallopis/src/styling/semantics/klp_semantic_schema.dart"]
	n11["package:kallopis/src/styling/semantics/klp_semantic_token.dart"]
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
	n0["klp_workspace_components_adapter.dart"]
	n1["package:kallopis/src/features/workspace/components/klp_document_tabs.dart"]
	n2["package:kallopis/src/features/workspace/components/klp_window_controls.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:kallopis/src/features/workspace/presentation/klp_workspace_presentation.dart&#x27;;</code> | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:1](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L1) |
| import | <code>import &#x27;package:kallopis/src/composition/definitions/klp_definition.dart&#x27;;</code> | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:2](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L2) |
| import | <code>import &#x27;package:kallopis/src/composition/nodes/klp_node.dart&#x27;;</code> | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:3](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L3) |
| import | <code>import &#x27;package:kallopis/src/composition/validation/klp_validated_node.dart&#x27;;</code> | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:4](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L4) |
| import | <code>import &#x27;package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart&#x27;;</code> | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:5](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L5) |
| import | <code>import &#x27;package:kallopis/src/foundation/binding/contracts/klp_bound_text_style.dart&#x27;;</code> | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:6](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L6) |
| import | <code>import &#x27;package:kallopis/src/kernel/lifecycle/klp_frame_lease.dart&#x27;;</code> | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:7](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L7) |
| import | <code>import &#x27;package:kallopis/src/kernel/identity/klp_id.dart&#x27;;</code> | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:8](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L8) |
| import | <code>import &#x27;package:kallopis/src/kernel/identity/klp_placement_id.dart&#x27;;</code> | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:9](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L9) |
| import | <code>import &#x27;package:kallopis/src/runtime/contracts/klp_node_adapter.dart&#x27;;</code> | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:10](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L10) |
| import | <code>import &#x27;package:kallopis/src/runtime/contracts/klp_prepare_context.dart&#x27;;</code> | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:11](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L11) |
| import | <code>import &#x27;package:kallopis/src/runtime/contracts/klp_prepared_node.dart&#x27;;</code> | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:12](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L12) |
| import | <code>import &#x27;package:kallopis/src/runtime/installation/klp_default_placement.dart&#x27;;</code> | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:13](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L13) |
| import | <code>import &#x27;package:kallopis/src/runtime/contracts/klp_placement_resource.dart&#x27;;</code> | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:14](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L14) |
| import | <code>import &#x27;package:kallopis/src/styling/primitives/klp_primitive_index.dart&#x27;;</code> | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:15](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L15) |
| import | <code>import &#x27;package:kallopis/src/styling/primitives/klp_style_kind.dart&#x27;;</code> | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:16](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L16) |
| import | <code>import &#x27;package:kallopis/src/styling/primitives/klp_style_value.dart&#x27;;</code> | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:17](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L17) |
| import | <code>import &#x27;package:kallopis/src/styling/references/klp_style_ref.dart&#x27;;</code> | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:18](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L18) |
| import | <code>import &#x27;package:kallopis/src/styling/resolution/klp_semantic_resolution.dart&#x27;;</code> | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:19](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L19) |
| import | <code>import &#x27;package:kallopis/src/styling/semantics/klp_semantic_key.dart&#x27;;</code> | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:20](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L20) |
| import | <code>import &#x27;package:kallopis/src/styling/semantics/klp_semantic_schema.dart&#x27;;</code> | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:21](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L21) |
| import | <code>import &#x27;package:kallopis/src/styling/semantics/klp_semantic_token.dart&#x27;;</code> | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:22](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L22) |
| import | <code>import &#x27;package:kallopis/src/features/workspace/components/klp_document_tabs.dart&#x27;;</code> | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:23](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L23) |
| import | <code>import &#x27;package:kallopis/src/features/workspace/components/klp_window_controls.dart&#x27;;</code> | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:24](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L24) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	direction LR
	class n0["KlpWorkspaceComponentsAdapter"]
	class n1["_KlpWorkspaceSemantics"]
	class n2["_KlpWorkspaceKeys"]
	class n3["_KlpWorkspaceStyle"]
	class n4["_KlpPreparedTabs"]
	class n5["_KlpPreparedWindow"]
	class n6["_KlpPreparedWorkspaceData"]
```

```mermaid
classDiagram
	class n0["KlpWorkspaceComponentsAdapter"]
	class n1["KlpNodeAdapter"]
	n0 ..|> n1 : implements
```

```mermaid
classDiagram
	class n0["_KlpPreparedTabs"]
	class n1["KlpPreparedNode"]
	n0 ..|> n1 : implements
```

```mermaid
classDiagram
	class n0["_KlpPreparedWindow"]
	class n1["KlpPreparedNode"]
	n0 ..|> n1 : implements
```

```mermaid
classDiagram
	class n0["_KlpPreparedWorkspaceData"]
	class n1["KlpPreparedNode"]
	n0 ..|> n1 : implements
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpWorkspaceComponentsAdapter

ClassDeclaration · public · [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:26](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L26)

<code>final class KlpWorkspaceComponentsAdapter implements KlpNodeAdapter</code>

來源註解摘要：內建分頁、視窗控制與工作區資料的封閉轉接器目錄；不接受使用端元件定義。

- `implements` → <code>KlpNodeAdapter</code>：[lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:27](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L27)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>_contract</code> | private | <code>final KlpDefinition&lt;KlpNode&gt; _contract</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:28](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L28) |
| constructor <code>_</code> | private | <code>KlpWorkspaceComponentsAdapter._(this._contract)</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:29](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L29) |
| getter <code>contract</code> | public | <code>KlpDefinition&lt;KlpNode&gt; get contract</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:30](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L30) |
| method <code>createAll</code> | public | <code>static List&lt;KlpNodeAdapter&gt; createAll()</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:33](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L33) |
| method <code>prepare</code> | public | <code>KlpPreparedNode prepare(KlpNode node, KlpValidatedNode snapshot, KlpPrepareContext context)</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:39](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L39) |
| method <code>_prepareTabs</code> | private | <code>KlpPreparedNode _prepareTabs(KlpDocumentTabs tabs, KlpValidatedNode snapshot, KlpPrepareContext context)</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:46](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L46) |
| method <code>_tabData</code> | private | <code>KlpBoundDocumentTabData _tabData(KlpDocumentTab tab, KlpPlacementId placement, KlpId? selectedId)</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:58](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L58) |
| method <code>_prepareWindow</code> | private | <code>KlpPreparedNode _prepareWindow(KlpWindowControls controls, KlpPrepareContext context)</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:60](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L60) |

### _KlpWorkspaceSemantics

ClassDeclaration · private · [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:63](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L63)

<code>final class _KlpWorkspaceSemantics</code>


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| method <code>key</code> | public | <code>static KlpSemanticKey&lt;T&gt; key&lt;T extends KlpStyleValue&gt;(String owner, String name, KlpStyleKind&lt;T&gt; kind)</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:64](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L64) |
| method <code>schema</code> | public | <code>static KlpSemanticSchema schema(String owner)</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:65](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L65) |

### _KlpWorkspaceKeys

ClassDeclaration · private · [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:76](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L76)

<code>final class _KlpWorkspaceKeys</code>


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>owner</code> | public | <code>final String owner</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:77](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L77) |
| field <code>background</code> | public | <code>late final (inferred) background</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:78](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L78) |
| field <code>foreground</code> | public | <code>late final (inferred) foreground</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:79](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L79) |
| field <code>selectedBackground</code> | public | <code>late final (inferred) selectedBackground</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:80](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L80) |
| field <code>mutedForeground</code> | public | <code>late final (inferred) mutedForeground</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:81](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L81) |
| field <code>focusColor</code> | public | <code>late final (inferred) focusColor</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:82](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L82) |
| field <code>closeHover</code> | public | <code>late final (inferred) closeHover</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:83](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L83) |
| field <code>extent</code> | public | <code>late final (inferred) extent</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:84](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L84) |
| field <code>indent</code> | public | <code>late final (inferred) indent</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:85](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L85) |
| field <code>inset</code> | public | <code>late final (inferred) inset</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:86](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L86) |
| field <code>gap</code> | public | <code>late final (inferred) gap</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:87](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L87) |
| field <code>radius</code> | public | <code>late final (inferred) radius</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:88](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L88) |
| field <code>focusWidth</code> | public | <code>late final (inferred) focusWidth</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:89](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L89) |
| field <code>fontFamily</code> | public | <code>late final (inferred) fontFamily</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:90](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L90) |
| field <code>fontSize</code> | public | <code>late final (inferred) fontSize</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:91](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L91) |
| field <code>fontWeight</code> | public | <code>late final (inferred) fontWeight</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:92](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L92) |
| field <code>lineHeight</code> | public | <code>late final (inferred) lineHeight</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:93](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L93) |
| field <code>letterSpacing</code> | public | <code>late final (inferred) letterSpacing</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:94](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L94) |
| constructor <code>_KlpWorkspaceKeys</code> | private | <code>_KlpWorkspaceKeys(this.owner)</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:95](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L95) |

### _KlpWorkspaceStyle

ClassDeclaration · private · [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:98](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L98)

<code>final class _KlpWorkspaceStyle</code>


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>background</code> | public | <code>final KlpColor background</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:99](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L99) |
| field <code>foreground</code> | public | <code>final KlpColor foreground</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:99](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L99) |
| field <code>selectedBackground</code> | public | <code>final KlpColor selectedBackground</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:99](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L99) |
| field <code>mutedForeground</code> | public | <code>final KlpColor mutedForeground</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:99](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L99) |
| field <code>focusColor</code> | public | <code>final KlpColor focusColor</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:99](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L99) |
| field <code>closeHover</code> | public | <code>final KlpColor closeHover</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:99](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L99) |
| field <code>extent</code> | public | <code>final KlpDistance extent</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:100](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L100) |
| field <code>indent</code> | public | <code>final KlpDistance indent</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:100](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L100) |
| field <code>inset</code> | public | <code>final KlpDistance inset</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:100](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L100) |
| field <code>gap</code> | public | <code>final KlpDistance gap</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:100](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L100) |
| field <code>radius</code> | public | <code>final KlpRadius radius</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:101](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L101) |
| field <code>focusWidth</code> | public | <code>final KlpStrokeWidth focusWidth</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:102](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L102) |
| field <code>text</code> | public | <code>final KlpBoundTextStyle text</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:103](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L103) |
| constructor <code>_KlpWorkspaceStyle</code> | private | <code>const _KlpWorkspaceStyle({required this.background, required this.foreground, required this.selectedBackground, required this.mutedForeground, required this.focusColor, required this.closeHover, required this.extent, required this.indent, required this.inset, required this.gap, required this.radius, required this.focusWidth, required this.text})</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:104](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L104) |
| method <code>read</code> | public | <code>static _KlpWorkspaceStyle read(KlpSemanticResolution style, String owner)</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:105](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L105) |

### _KlpPreparedTabs

ClassDeclaration · private · [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:115](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L115)

<code>final class _KlpPreparedTabs implements KlpPreparedNode</code>

- `implements` → <code>KlpPreparedNode</code>：[lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:115](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L115)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>tabs</code> | public | <code>final List&lt;KlpBoundDocumentTabData&gt; tabs</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:116](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L116) |
| field <code>onSelected</code> | public | <code>final void Function(KlpPlacementId)? onSelected</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:117](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L117) |
| field <code>onClose</code> | public | <code>final void Function(KlpPlacementId)? onClose</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:118](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L118) |
| field <code>onPinnedChanged</code> | public | <code>final void Function(KlpPlacementId, bool)? onPinnedChanged</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:119](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L119) |
| field <code>style</code> | public | <code>final _KlpWorkspaceStyle style</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:120](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L120) |
| constructor <code>_KlpPreparedTabs</code> | private | <code>const _KlpPreparedTabs({required this.tabs, required this.onSelected, required this.onClose, required this.onPinnedChanged, required this.style})</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:121](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L121) |
| method <code>createResource</code> | public | <code>KlpPlacementResource createResource(KlpValidatedNode node)</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:122](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L122) |
| method <code>materialize</code> | public | <code>KlpBoundTemplate materialize(KlpPlacementResource resource, List&lt;KlpBoundTemplate&gt; children, KlpFrameLease lease)</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:124](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L124) |

### _KlpPreparedWindow

ClassDeclaration · private · [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:128](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L128)

<code>final class _KlpPreparedWindow implements KlpPreparedNode</code>

- `implements` → <code>KlpPreparedNode</code>：[lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:128](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L128)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>controls</code> | public | <code>final KlpWindowControls controls</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:129](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L129) |
| field <code>style</code> | public | <code>final _KlpWorkspaceStyle style</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:130](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L130) |
| constructor <code>_KlpPreparedWindow</code> | private | <code>const _KlpPreparedWindow({required this.controls, required this.style})</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:131](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L131) |
| method <code>createResource</code> | public | <code>KlpPlacementResource createResource(KlpValidatedNode node)</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:132](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L132) |
| method <code>materialize</code> | public | <code>KlpBoundTemplate materialize(KlpPlacementResource resource, List&lt;KlpBoundTemplate&gt; children, KlpFrameLease lease)</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:134](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L134) |

### _KlpPreparedWorkspaceData

ClassDeclaration · private · [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:138](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L138)

<code>final class _KlpPreparedWorkspaceData implements KlpPreparedNode</code>

- `implements` → <code>KlpPreparedNode</code>：[lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:138](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L138)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>_KlpPreparedWorkspaceData</code> | private | <code>const _KlpPreparedWorkspaceData()</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:139](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L139) |
| method <code>createResource</code> | public | <code>KlpPlacementResource createResource(KlpValidatedNode node)</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:140](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L140) |
| method <code>materialize</code> | public | <code>KlpBoundTemplate materialize(KlpPlacementResource resource, List&lt;KlpBoundTemplate&gt; children, KlpFrameLease lease)</code> |  | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:142](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L142) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
