# klp_prepared_component.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/foundation/binding/internal/klp_prepared_component.dart)

## 範圍

核心是 `lib/src/foundation/binding/internal/klp_prepared_component.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_prepared_component.dart"]
	n1["../../../kernel/diagnostics/klp_contract_error.dart"]
	n2["klp_bound_component.dart"]
	n3["klp_bound_template.dart"]
	n4["klp_prepared_template.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../../../kernel/diagnostics/klp_contract_error.dart&#x27;;</code> | [lib/src/foundation/binding/internal/klp_prepared_component.dart:1](../../../../../../lib/src/foundation/binding/internal/klp_prepared_component.dart#L1) |
| import | <code>import &#x27;klp_bound_component.dart&#x27;;</code> | [lib/src/foundation/binding/internal/klp_prepared_component.dart:2](../../../../../../lib/src/foundation/binding/internal/klp_prepared_component.dart#L2) |
| import | <code>import &#x27;klp_bound_template.dart&#x27;;</code> | [lib/src/foundation/binding/internal/klp_prepared_component.dart:3](../../../../../../lib/src/foundation/binding/internal/klp_prepared_component.dart#L3) |
| import | <code>import &#x27;klp_prepared_template.dart&#x27;;</code> | [lib/src/foundation/binding/internal/klp_prepared_component.dart:4](../../../../../../lib/src/foundation/binding/internal/klp_prepared_component.dart#L4) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpPreparedComponent"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpPreparedComponent

ClassDeclaration · public · [lib/src/foundation/binding/internal/klp_prepared_component.dart:6](../../../../../../lib/src/foundation/binding/internal/klp_prepared_component.dart#L6)

<code>final class KlpPreparedComponent</code>

來源註解摘要：子放置數量在準備期固定，公開 renderer 永遠只收到完成的呈現樹。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>id</code> | public | <code>final String id</code> |  | [lib/src/foundation/binding/internal/klp_prepared_component.dart:8](../../../../../../lib/src/foundation/binding/internal/klp_prepared_component.dart#L8) |
| field <code>definitionId</code> | public | <code>final String definitionId</code> |  | [lib/src/foundation/binding/internal/klp_prepared_component.dart:9](../../../../../../lib/src/foundation/binding/internal/klp_prepared_component.dart#L9) |
| field <code>childCount</code> | public | <code>final int childCount</code> |  | [lib/src/foundation/binding/internal/klp_prepared_component.dart:10](../../../../../../lib/src/foundation/binding/internal/klp_prepared_component.dart#L10) |
| field <code>content</code> | public | <code>final KlpPreparedTemplate content</code> |  | [lib/src/foundation/binding/internal/klp_prepared_component.dart:11](../../../../../../lib/src/foundation/binding/internal/klp_prepared_component.dart#L11) |
| field <code>accessibilityLabel</code> | public | <code>final String? accessibilityLabel</code> |  | [lib/src/foundation/binding/internal/klp_prepared_component.dart:12](../../../../../../lib/src/foundation/binding/internal/klp_prepared_component.dart#L12) |
| constructor <code>KlpPreparedComponent</code> | public | <code>const KlpPreparedComponent({ required this.id, required this.definitionId, required this.childCount, required this.content, this.accessibilityLabel, })</code> |  | [lib/src/foundation/binding/internal/klp_prepared_component.dart:14](../../../../../../lib/src/foundation/binding/internal/klp_prepared_component.dart#L14) |
| method <code>materialize</code> | public | <code>KlpBoundComponent materialize(List&lt;KlpBoundTemplate&gt; children)</code> |  | [lib/src/foundation/binding/internal/klp_prepared_component.dart:22](../../../../../../lib/src/foundation/binding/internal/klp_prepared_component.dart#L22) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
