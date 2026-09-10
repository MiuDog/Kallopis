# klp_prepared_screen.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/application/bootstrap/internal/klp_prepared_screen.dart)

## 範圍

核心是 `lib/src/application/bootstrap/internal/klp_prepared_screen.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_prepared_screen.dart"]
	n1["../../../composition/validation/klp_validated_node.dart"]
	n2["../../../foundation/binding/internal/klp_bound_template.dart"]
	n3["../../../kernel/lifecycle/internal/klp_frame_lease.dart"]
	n4["../../../runtime/compilation/internal/klp_prepared_node.dart"]
	n5["../../../runtime/installation/internal/klp_default_placement.dart"]
	n6["../../../runtime/installation/internal/klp_placement_resource.dart"]
	n7["../../../styling/primitives/klp_style_value.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../../../composition/validation/klp_validated_node.dart&#x27;;</code> | [lib/src/application/bootstrap/internal/klp_prepared_screen.dart:1](../../../../../../lib/src/application/bootstrap/internal/klp_prepared_screen.dart#L1) |
| import | <code>import &#x27;../../../foundation/binding/internal/klp_bound_template.dart&#x27;;</code> | [lib/src/application/bootstrap/internal/klp_prepared_screen.dart:2](../../../../../../lib/src/application/bootstrap/internal/klp_prepared_screen.dart#L2) |
| import | <code>import &#x27;../../../kernel/lifecycle/internal/klp_frame_lease.dart&#x27;;</code> | [lib/src/application/bootstrap/internal/klp_prepared_screen.dart:3](../../../../../../lib/src/application/bootstrap/internal/klp_prepared_screen.dart#L3) |
| import | <code>import &#x27;../../../runtime/compilation/internal/klp_prepared_node.dart&#x27;;</code> | [lib/src/application/bootstrap/internal/klp_prepared_screen.dart:4](../../../../../../lib/src/application/bootstrap/internal/klp_prepared_screen.dart#L4) |
| import | <code>import &#x27;../../../runtime/installation/internal/klp_default_placement.dart&#x27;;</code> | [lib/src/application/bootstrap/internal/klp_prepared_screen.dart:5](../../../../../../lib/src/application/bootstrap/internal/klp_prepared_screen.dart#L5) |
| import | <code>import &#x27;../../../runtime/installation/internal/klp_placement_resource.dart&#x27;;</code> | [lib/src/application/bootstrap/internal/klp_prepared_screen.dart:6](../../../../../../lib/src/application/bootstrap/internal/klp_prepared_screen.dart#L6) |
| import | <code>import &#x27;../../../styling/primitives/klp_style_value.dart&#x27;;</code> | [lib/src/application/bootstrap/internal/klp_prepared_screen.dart:7](../../../../../../lib/src/application/bootstrap/internal/klp_prepared_screen.dart#L7) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpPreparedScreen"]
```

```mermaid
classDiagram
	class n0["KlpPreparedScreen"]
	class n1["KlpPreparedNode"]
	n0 ..|> n1 : implements
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpPreparedScreen

ClassDeclaration · public · [lib/src/application/bootstrap/internal/klp_prepared_screen.dart:9](../../../../../../lib/src/application/bootstrap/internal/klp_prepared_screen.dart#L9)

<code>final class KlpPreparedScreen implements KlpPreparedNode</code>

來源註解摘要：準備階段已取得風格值，提交後只組合本庫封閉輸出。

- `implements` → <code>KlpPreparedNode</code>：[lib/src/application/bootstrap/internal/klp_prepared_screen.dart:10](../../../../../../lib/src/application/bootstrap/internal/klp_prepared_screen.dart#L10)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>background</code> | public | <code>final KlpColor background</code> |  | [lib/src/application/bootstrap/internal/klp_prepared_screen.dart:11](../../../../../../lib/src/application/bootstrap/internal/klp_prepared_screen.dart#L11) |
| field <code>radius</code> | public | <code>final KlpRadius radius</code> |  | [lib/src/application/bootstrap/internal/klp_prepared_screen.dart:12](../../../../../../lib/src/application/bootstrap/internal/klp_prepared_screen.dart#L12) |
| field <code>inset</code> | public | <code>final KlpDistance inset</code> |  | [lib/src/application/bootstrap/internal/klp_prepared_screen.dart:13](../../../../../../lib/src/application/bootstrap/internal/klp_prepared_screen.dart#L13) |
| field <code>accessibilityLabel</code> | public | <code>final String accessibilityLabel</code> |  | [lib/src/application/bootstrap/internal/klp_prepared_screen.dart:14](../../../../../../lib/src/application/bootstrap/internal/klp_prepared_screen.dart#L14) |
| constructor <code>KlpPreparedScreen</code> | public | <code>const KlpPreparedScreen( this.background, this.radius, this.inset, this.accessibilityLabel, )</code> |  | [lib/src/application/bootstrap/internal/klp_prepared_screen.dart:16](../../../../../../lib/src/application/bootstrap/internal/klp_prepared_screen.dart#L16) |
| method <code>createResource</code> | public | <code>KlpPlacementResource createResource(KlpValidatedNode node)</code> |  | [lib/src/application/bootstrap/internal/klp_prepared_screen.dart:23](../../../../../../lib/src/application/bootstrap/internal/klp_prepared_screen.dart#L23) |
| method <code>materialize</code> | public | <code>KlpBoundTemplate materialize( KlpPlacementResource resource, List&lt;KlpBoundTemplate&gt; children, KlpFrameLease lease, )</code> |  | [lib/src/application/bootstrap/internal/klp_prepared_screen.dart:27](../../../../../../lib/src/application/bootstrap/internal/klp_prepared_screen.dart#L27) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
