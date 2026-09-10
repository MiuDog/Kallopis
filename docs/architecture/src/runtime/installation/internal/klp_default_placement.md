# klp_default_placement.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/runtime/installation/internal/klp_default_placement.dart)

## 範圍

核心是 `lib/src/runtime/installation/internal/klp_default_placement.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_default_placement.dart"]
	n1["../../../capabilities/controllers/klp_state_controller.dart"]
	n2["../../../capabilities/state/klp_mutable_state.dart"]
	n3["../../../capabilities/state/klp_state.dart"]
	n4["../../../composition/validation/klp_validated_node.dart"]
	n5["klp_placement_resource.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../../../capabilities/controllers/klp_state_controller.dart&#x27;;</code> | [lib/src/runtime/installation/internal/klp_default_placement.dart:1](../../../../../../lib/src/runtime/installation/internal/klp_default_placement.dart#L1) |
| import | <code>import &#x27;../../../capabilities/state/klp_mutable_state.dart&#x27;;</code> | [lib/src/runtime/installation/internal/klp_default_placement.dart:2](../../../../../../lib/src/runtime/installation/internal/klp_default_placement.dart#L2) |
| import | <code>import &#x27;../../../capabilities/state/klp_state.dart&#x27;;</code> | [lib/src/runtime/installation/internal/klp_default_placement.dart:3](../../../../../../lib/src/runtime/installation/internal/klp_default_placement.dart#L3) |
| import | <code>import &#x27;../../../composition/validation/klp_validated_node.dart&#x27;;</code> | [lib/src/runtime/installation/internal/klp_default_placement.dart:4](../../../../../../lib/src/runtime/installation/internal/klp_default_placement.dart#L4) |
| import | <code>import &#x27;klp_placement_resource.dart&#x27;;</code> | [lib/src/runtime/installation/internal/klp_default_placement.dart:5](../../../../../../lib/src/runtime/installation/internal/klp_default_placement.dart#L5) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpDefaultPlacement"]
```

```mermaid
classDiagram
	class n0["KlpDefaultPlacement"]
	class n1["KlpPlacementResource"]
	n0 ..|> n1 : implements
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpDefaultPlacement

ClassDeclaration · public · [lib/src/runtime/installation/internal/klp_default_placement.dart:7](../../../../../../lib/src/runtime/installation/internal/klp_default_placement.dart#L7)

<code>final class KlpDefaultPlacement implements KlpPlacementResource</code>

來源註解摘要：為每個放置位置建立獨立狀態與借用控制器。

- `implements` → <code>KlpPlacementResource</code>：[lib/src/runtime/installation/internal/klp_default_placement.dart:8](../../../../../../lib/src/runtime/installation/internal/klp_default_placement.dart#L8)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>_owner</code> | private | <code>final KlpMutableState&lt;KlpValidatedNode&gt; _owner</code> |  | [lib/src/runtime/installation/internal/klp_default_placement.dart:10](../../../../../../lib/src/runtime/installation/internal/klp_default_placement.dart#L10) |
| field <code>controller</code> | public | <code>final KlpStateController&lt;KlpValidatedNode&gt; controller</code> |  | [lib/src/runtime/installation/internal/klp_default_placement.dart:11](../../../../../../lib/src/runtime/installation/internal/klp_default_placement.dart#L11) |
| constructor <code>KlpDefaultPlacement</code> | public | <code>KlpDefaultPlacement(KlpValidatedNode node)</code> |  | [lib/src/runtime/installation/internal/klp_default_placement.dart:13](../../../../../../lib/src/runtime/installation/internal/klp_default_placement.dart#L13) |
| getter <code>state</code> | public | <code>KlpState&lt;KlpValidatedNode&gt; get state</code> |  | [lib/src/runtime/installation/internal/klp_default_placement.dart:17](../../../../../../lib/src/runtime/installation/internal/klp_default_placement.dart#L17) |
| getter <code>isDisposed</code> | public | <code>bool get isDisposed</code> |  | [lib/src/runtime/installation/internal/klp_default_placement.dart:18](../../../../../../lib/src/runtime/installation/internal/klp_default_placement.dart#L18) |
| method <code>update</code> | public | <code>void update(KlpValidatedNode node)</code> |  | [lib/src/runtime/installation/internal/klp_default_placement.dart:20](../../../../../../lib/src/runtime/installation/internal/klp_default_placement.dart#L20) |
| method <code>dispose</code> | public | <code>void dispose()</code> |  | [lib/src/runtime/installation/internal/klp_default_placement.dart:25](../../../../../../lib/src/runtime/installation/internal/klp_default_placement.dart#L25) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
