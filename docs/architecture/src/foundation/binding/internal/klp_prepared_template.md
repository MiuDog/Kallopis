# klp_prepared_template.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/foundation/binding/internal/klp_prepared_template.dart)

## 範圍

核心是 `lib/src/foundation/binding/internal/klp_prepared_template.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_prepared_template.dart"]
	n1["../../../styling/primitives/klp_style_value.dart"]
	n2["../../templates/klp_axis.dart"]
	n3["klp_bound_template.dart"]
	n4["klp_prepared_value.dart"]
	n5["klp_prepared_linear.dart"]
	n6["klp_prepared_surface.dart"]
	n7["klp_prepared_children.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"part"| n4
	n0 -->|"part"| n5
	n0 -->|"part"| n6
	n0 -->|"part"| n7
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../../../styling/primitives/klp_style_value.dart&#x27;;</code> | [lib/src/foundation/binding/internal/klp_prepared_template.dart:1](../../../../../../lib/src/foundation/binding/internal/klp_prepared_template.dart#L1) |
| import | <code>import &#x27;../../templates/klp_axis.dart&#x27;;</code> | [lib/src/foundation/binding/internal/klp_prepared_template.dart:2](../../../../../../lib/src/foundation/binding/internal/klp_prepared_template.dart#L2) |
| import | <code>import &#x27;klp_bound_template.dart&#x27;;</code> | [lib/src/foundation/binding/internal/klp_prepared_template.dart:3](../../../../../../lib/src/foundation/binding/internal/klp_prepared_template.dart#L3) |
| part | <code>part &#x27;klp_prepared_value.dart&#x27;;</code> | [lib/src/foundation/binding/internal/klp_prepared_template.dart:5](../../../../../../lib/src/foundation/binding/internal/klp_prepared_template.dart#L5) |
| part | <code>part &#x27;klp_prepared_linear.dart&#x27;;</code> | [lib/src/foundation/binding/internal/klp_prepared_template.dart:6](../../../../../../lib/src/foundation/binding/internal/klp_prepared_template.dart#L6) |
| part | <code>part &#x27;klp_prepared_surface.dart&#x27;;</code> | [lib/src/foundation/binding/internal/klp_prepared_template.dart:7](../../../../../../lib/src/foundation/binding/internal/klp_prepared_template.dart#L7) |
| part | <code>part &#x27;klp_prepared_children.dart&#x27;;</code> | [lib/src/foundation/binding/internal/klp_prepared_template.dart:8](../../../../../../lib/src/foundation/binding/internal/klp_prepared_template.dart#L8) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpPreparedTemplate"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpPreparedTemplate

ClassDeclaration · public · [lib/src/foundation/binding/internal/klp_prepared_template.dart:10](../../../../../../lib/src/foundation/binding/internal/klp_prepared_template.dart#L10)

<code>sealed class KlpPreparedTemplate</code>

來源註解摘要：已完成外部資料投影的封閉準備樹，插槽不會流入 renderer。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpPreparedTemplate</code> | public | <code>const KlpPreparedTemplate()</code> |  | [lib/src/foundation/binding/internal/klp_prepared_template.dart:12](../../../../../../lib/src/foundation/binding/internal/klp_prepared_template.dart#L12) |
| method <code>materialize</code> | public | <code>KlpBoundTemplate materialize(List&lt;KlpBoundTemplate&gt; children)</code> |  | [lib/src/foundation/binding/internal/klp_prepared_template.dart:14](../../../../../../lib/src/foundation/binding/internal/klp_prepared_template.dart#L14) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
