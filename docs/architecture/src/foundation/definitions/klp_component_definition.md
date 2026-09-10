# klp_component_definition.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/foundation/definitions/klp_component_definition.dart)

## 範圍

核心是 `lib/src/foundation/definitions/klp_component_definition.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_component_definition.dart"]
	n1["../../composition/definitions/klp_definition.dart"]
	n2["../../composition/nodes/klp_node.dart"]
	n3["../../styling/semantics/klp_semantic_schema.dart"]
	n4["../templates/klp_template.dart"]
	n5["internal/klp_template_slots.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../../composition/definitions/klp_definition.dart&#x27;;</code> | [lib/src/foundation/definitions/klp_component_definition.dart:1](../../../../../lib/src/foundation/definitions/klp_component_definition.dart#L1) |
| import | <code>import &#x27;../../composition/nodes/klp_node.dart&#x27;;</code> | [lib/src/foundation/definitions/klp_component_definition.dart:2](../../../../../lib/src/foundation/definitions/klp_component_definition.dart#L2) |
| import | <code>import &#x27;../../styling/semantics/klp_semantic_schema.dart&#x27;;</code> | [lib/src/foundation/definitions/klp_component_definition.dart:3](../../../../../lib/src/foundation/definitions/klp_component_definition.dart#L3) |
| import | <code>import &#x27;../templates/klp_template.dart&#x27;;</code> | [lib/src/foundation/definitions/klp_component_definition.dart:4](../../../../../lib/src/foundation/definitions/klp_component_definition.dart#L4) |
| import | <code>import &#x27;internal/klp_template_slots.dart&#x27;;</code> | [lib/src/foundation/definitions/klp_component_definition.dart:5](../../../../../lib/src/foundation/definitions/klp_component_definition.dart#L5) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpComponentDefinition"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpComponentDefinition

ClassDeclaration · public · [lib/src/foundation/definitions/klp_component_definition.dart:7](../../../../../lib/src/foundation/definitions/klp_component_definition.dart#L7)

<code>final class KlpComponentDefinition&lt;T extends KlpNode&gt;</code>

來源註解摘要：將受控模板與註冊契約綁在定義期，實例不再提供風格參數。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>contract</code> | public | <code>final KlpDefinition&lt;T&gt; contract</code> |  | [lib/src/foundation/definitions/klp_component_definition.dart:9](../../../../../lib/src/foundation/definitions/klp_component_definition.dart#L9) |
| field <code>content</code> | public | <code>final KlpTemplate&lt;T&gt; content</code> |  | [lib/src/foundation/definitions/klp_component_definition.dart:10](../../../../../lib/src/foundation/definitions/klp_component_definition.dart#L10) |
| field <code>accessibilityLabel</code> | public | <code>final String Function(T)? accessibilityLabel</code> |  | [lib/src/foundation/definitions/klp_component_definition.dart:11](../../../../../lib/src/foundation/definitions/klp_component_definition.dart#L11) |
| getter <code>hasAccessibilityLabel</code> | public | <code>bool get hasAccessibilityLabel</code> |  | [lib/src/foundation/definitions/klp_component_definition.dart:12](../../../../../lib/src/foundation/definitions/klp_component_definition.dart#L12) |
| constructor <code>KlpComponentDefinition</code> | public | <code>KlpComponentDefinition( String id, { required this.content, required KlpSemanticSchema semantics, this.accessibilityLabel, Iterable&lt;String&gt; dependencies = const [], })</code> |  | [lib/src/foundation/definitions/klp_component_definition.dart:14](../../../../../lib/src/foundation/definitions/klp_component_definition.dart#L14) |
| method <code>selectAccessibilityLabel</code> | public | <code>String? selectAccessibilityLabel(KlpNode node)</code> | 與模板 selector 相同，泛型上轉後仍保留原本實例型別資格。 | [lib/src/foundation/definitions/klp_component_definition.dart:27](../../../../../lib/src/foundation/definitions/klp_component_definition.dart#L27) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
