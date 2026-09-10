# klp_slot.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/composition/slots/klp_slot.dart)

## 範圍

核心是 `lib/src/composition/slots/klp_slot.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_slot.dart"]
	n1["../../kernel/diagnostics/klp_contract_error.dart"]
	n2["../../kernel/identity/internal/klp_identifier.dart"]
	n3["../nodes/klp_node.dart"]
	n4["klp_slot_assignment.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"part"| n4
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../../kernel/diagnostics/klp_contract_error.dart&#x27;;</code> | [lib/src/composition/slots/klp_slot.dart:1](../../../../../lib/src/composition/slots/klp_slot.dart#L1) |
| import | <code>import &#x27;../../kernel/identity/internal/klp_identifier.dart&#x27;;</code> | [lib/src/composition/slots/klp_slot.dart:2](../../../../../lib/src/composition/slots/klp_slot.dart#L2) |
| import | <code>import &#x27;../nodes/klp_node.dart&#x27;;</code> | [lib/src/composition/slots/klp_slot.dart:3](../../../../../lib/src/composition/slots/klp_slot.dart#L3) |
| part | <code>part &#x27;klp_slot_assignment.dart&#x27;;</code> | [lib/src/composition/slots/klp_slot.dart:5](../../../../../lib/src/composition/slots/klp_slot.dart#L5) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpSlot"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpSlot

ClassDeclaration · public · [lib/src/composition/slots/klp_slot.dart:7](../../../../../lib/src/composition/slots/klp_slot.dart#L7)

<code>final class KlpSlot&lt;C extends KlpNode&gt;</code>

來源註解摘要：定義期宣告的插槽身分及資格；實例只能交付符合資格的子項。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>owner</code> | public | <code>final String owner</code> |  | [lib/src/composition/slots/klp_slot.dart:9](../../../../../lib/src/composition/slots/klp_slot.dart#L9) |
| field <code>name</code> | public | <code>final String name</code> |  | [lib/src/composition/slots/klp_slot.dart:10](../../../../../lib/src/composition/slots/klp_slot.dart#L10) |
| field <code>min</code> | public | <code>final int min</code> |  | [lib/src/composition/slots/klp_slot.dart:11](../../../../../lib/src/composition/slots/klp_slot.dart#L11) |
| field <code>max</code> | public | <code>final int? max</code> |  | [lib/src/composition/slots/klp_slot.dart:12](../../../../../lib/src/composition/slots/klp_slot.dart#L12) |
| constructor <code>KlpSlot</code> | public | <code>KlpSlot({required this.owner, required this.name, this.min = 0, this.max})</code> |  | [lib/src/composition/slots/klp_slot.dart:14](../../../../../lib/src/composition/slots/klp_slot.dart#L14) |
| method <code>accepts</code> | public | <code>bool accepts(KlpNode node)</code> |  | [lib/src/composition/slots/klp_slot.dart:26](../../../../../lib/src/composition/slots/klp_slot.dart#L26) |
| method <code>assign</code> | public | <code>KlpSlotAssignment&lt;C&gt; assign(List&lt;C&gt; children)</code> |  | [lib/src/composition/slots/klp_slot.dart:28](../../../../../lib/src/composition/slots/klp_slot.dart#L28) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
