# klp_template.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/foundation/templates/klp_template.dart)

## 範圍

核心是 `lib/src/foundation/templates/klp_template.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_template.dart"]
	n1["../../composition/nodes/klp_node.dart"]
	n2["../../composition/slots/klp_slot.dart"]
	n3["../../styling/primitives/klp_style_value.dart"]
	n4["../../styling/semantics/klp_semantic_key.dart"]
	n5["klp_axis.dart"]
	n6["klp_text_semantics.dart"]
	n7["klp_text_template.dart"]
	n8["klp_linear_template.dart"]
	n9["klp_surface_template.dart"]
	n10["klp_children_template.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"part"| n7
	n0 -->|"part"| n8
	n0 -->|"part"| n9
	n0 -->|"part"| n10
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../../composition/nodes/klp_node.dart&#x27;;</code> | [lib/src/foundation/templates/klp_template.dart:1](../../../../../lib/src/foundation/templates/klp_template.dart#L1) |
| import | <code>import &#x27;../../composition/slots/klp_slot.dart&#x27;;</code> | [lib/src/foundation/templates/klp_template.dart:2](../../../../../lib/src/foundation/templates/klp_template.dart#L2) |
| import | <code>import &#x27;../../styling/primitives/klp_style_value.dart&#x27;;</code> | [lib/src/foundation/templates/klp_template.dart:3](../../../../../lib/src/foundation/templates/klp_template.dart#L3) |
| import | <code>import &#x27;../../styling/semantics/klp_semantic_key.dart&#x27;;</code> | [lib/src/foundation/templates/klp_template.dart:4](../../../../../lib/src/foundation/templates/klp_template.dart#L4) |
| import | <code>import &#x27;klp_axis.dart&#x27;;</code> | [lib/src/foundation/templates/klp_template.dart:5](../../../../../lib/src/foundation/templates/klp_template.dart#L5) |
| import | <code>import &#x27;klp_text_semantics.dart&#x27;;</code> | [lib/src/foundation/templates/klp_template.dart:6](../../../../../lib/src/foundation/templates/klp_template.dart#L6) |
| part | <code>part &#x27;klp_text_template.dart&#x27;;</code> | [lib/src/foundation/templates/klp_template.dart:8](../../../../../lib/src/foundation/templates/klp_template.dart#L8) |
| part | <code>part &#x27;klp_linear_template.dart&#x27;;</code> | [lib/src/foundation/templates/klp_template.dart:9](../../../../../lib/src/foundation/templates/klp_template.dart#L9) |
| part | <code>part &#x27;klp_surface_template.dart&#x27;;</code> | [lib/src/foundation/templates/klp_template.dart:10](../../../../../lib/src/foundation/templates/klp_template.dart#L10) |
| part | <code>part &#x27;klp_children_template.dart&#x27;;</code> | [lib/src/foundation/templates/klp_template.dart:11](../../../../../lib/src/foundation/templates/klp_template.dart#L11) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpTemplate"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpTemplate

ClassDeclaration · public · [lib/src/foundation/templates/klp_template.dart:13](../../../../../lib/src/foundation/templates/klp_template.dart#L13)

<code>sealed class KlpTemplate&lt;T extends KlpNode&gt;</code>

來源註解摘要：元件定義期使用的封閉模板；不提供外部渲染或風格求值入口。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpTemplate</code> | public | <code>const KlpTemplate()</code> |  | [lib/src/foundation/templates/klp_template.dart:16](../../../../../lib/src/foundation/templates/klp_template.dart#L16) |
| method <code>accepts</code> | public | <code>bool accepts(KlpNode node)</code> | 泛型上轉不能取消模板自身的資料資格。 | [lib/src/foundation/templates/klp_template.dart:18](../../../../../lib/src/foundation/templates/klp_template.dart#L18) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
