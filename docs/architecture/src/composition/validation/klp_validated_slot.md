# klp_validated_slot.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/composition/validation/klp_validated_slot.dart)

## 範圍

核心是 `lib/src/composition/validation/klp_validated_slot.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_validated_slot.dart"]
	n1["../nodes/klp_node.dart"]
	n2["../slots/klp_slot.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../nodes/klp_node.dart&#x27;;</code> | [lib/src/composition/validation/klp_validated_slot.dart:1](../../../../../lib/src/composition/validation/klp_validated_slot.dart#L1) |
| import | <code>import &#x27;../slots/klp_slot.dart&#x27;;</code> | [lib/src/composition/validation/klp_validated_slot.dart:2](../../../../../lib/src/composition/validation/klp_validated_slot.dart#L2) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpValidatedSlot"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpValidatedSlot

ClassDeclaration · public · [lib/src/composition/validation/klp_validated_slot.dart:4](../../../../../lib/src/composition/validation/klp_validated_slot.dart#L4)

<code>final class KlpValidatedSlot</code>

來源註解摘要：已驗證插槽在 childrenIds 的半開範圍，不保存消費端子節點。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>slot</code> | public | <code>final KlpSlot&lt;KlpNode&gt; slot</code> |  | [lib/src/composition/validation/klp_validated_slot.dart:7](../../../../../lib/src/composition/validation/klp_validated_slot.dart#L7) |
| field <code>start</code> | public | <code>final int start</code> |  | [lib/src/composition/validation/klp_validated_slot.dart:8](../../../../../lib/src/composition/validation/klp_validated_slot.dart#L8) |
| field <code>end</code> | public | <code>final int end</code> |  | [lib/src/composition/validation/klp_validated_slot.dart:9](../../../../../lib/src/composition/validation/klp_validated_slot.dart#L9) |
| constructor <code>KlpValidatedSlot</code> | public | <code>const KlpValidatedSlot(this.slot, this.start, this.end)</code> |  | [lib/src/composition/validation/klp_validated_slot.dart:11](../../../../../lib/src/composition/validation/klp_validated_slot.dart#L11) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
