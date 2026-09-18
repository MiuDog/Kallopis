# klp_prepared_adaptive.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/runtime/compilation/internal/klp_prepared_adaptive.dart)

## 範圍

核心是 `lib/src/runtime/compilation/internal/klp_prepared_adaptive.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_prepared_adaptive.dart"]
	n1["package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart"]
	n2["package:kallopis/src/kernel/lifecycle/klp_frame_lease.dart"]
	n3["package:kallopis/src/runtime/contracts/klp_prepared_node.dart"]
	n4["package:kallopis/src/runtime/installation/klp_default_placement.dart"]
	n5["package:kallopis/src/runtime/contracts/klp_placement_resource.dart"]
	n6["package:kallopis/src/composition/validation/klp_validated_node.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart&#x27;;</code> | [lib/src/runtime/compilation/internal/klp_prepared_adaptive.dart:1](../../../../../../lib/src/runtime/compilation/internal/klp_prepared_adaptive.dart#L1) |
| import | <code>import &#x27;package:kallopis/src/kernel/lifecycle/klp_frame_lease.dart&#x27;;</code> | [lib/src/runtime/compilation/internal/klp_prepared_adaptive.dart:2](../../../../../../lib/src/runtime/compilation/internal/klp_prepared_adaptive.dart#L2) |
| import | <code>import &#x27;package:kallopis/src/runtime/contracts/klp_prepared_node.dart&#x27;;</code> | [lib/src/runtime/compilation/internal/klp_prepared_adaptive.dart:3](../../../../../../lib/src/runtime/compilation/internal/klp_prepared_adaptive.dart#L3) |
| import | <code>import &#x27;package:kallopis/src/runtime/installation/klp_default_placement.dart&#x27;;</code> | [lib/src/runtime/compilation/internal/klp_prepared_adaptive.dart:4](../../../../../../lib/src/runtime/compilation/internal/klp_prepared_adaptive.dart#L4) |
| import | <code>import &#x27;package:kallopis/src/runtime/contracts/klp_placement_resource.dart&#x27;;</code> | [lib/src/runtime/compilation/internal/klp_prepared_adaptive.dart:5](../../../../../../lib/src/runtime/compilation/internal/klp_prepared_adaptive.dart#L5) |
| import | <code>import &#x27;package:kallopis/src/composition/validation/klp_validated_node.dart&#x27;;</code> | [lib/src/runtime/compilation/internal/klp_prepared_adaptive.dart:6](../../../../../../lib/src/runtime/compilation/internal/klp_prepared_adaptive.dart#L6) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpPreparedAdaptive"]
```

```mermaid
classDiagram
	class n0["KlpPreparedAdaptive"]
	class n1["KlpPreparedNode"]
	n0 ..|> n1 : implements
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpPreparedAdaptive

ClassDeclaration · public · [lib/src/runtime/compilation/internal/klp_prepared_adaptive.dart:8](../../../../../../lib/src/runtime/compilation/internal/klp_prepared_adaptive.dart#L8)

<code>final class KlpPreparedAdaptive implements KlpPreparedNode</code>

來源註解摘要：平台策略已在樹捕捉期收斂為單一子樹，這裡只保留受控資料邊界。

- `implements` → <code>KlpPreparedNode</code>：[lib/src/runtime/compilation/internal/klp_prepared_adaptive.dart:9](../../../../../../lib/src/runtime/compilation/internal/klp_prepared_adaptive.dart#L9)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpPreparedAdaptive</code> | public | <code>const KlpPreparedAdaptive()</code> |  | [lib/src/runtime/compilation/internal/klp_prepared_adaptive.dart:11](../../../../../../lib/src/runtime/compilation/internal/klp_prepared_adaptive.dart#L11) |
| method <code>createResource</code> | public | <code>KlpPlacementResource createResource(KlpValidatedNode node)</code> |  | [lib/src/runtime/compilation/internal/klp_prepared_adaptive.dart:13](../../../../../../lib/src/runtime/compilation/internal/klp_prepared_adaptive.dart#L13) |
| method <code>materialize</code> | public | <code>KlpBoundTemplate materialize(KlpPlacementResource resource, List&lt;KlpBoundTemplate&gt; children, KlpFrameLease lease)</code> |  | [lib/src/runtime/compilation/internal/klp_prepared_adaptive.dart:16](../../../../../../lib/src/runtime/compilation/internal/klp_prepared_adaptive.dart#L16) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
