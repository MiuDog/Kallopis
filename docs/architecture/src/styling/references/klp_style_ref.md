# klp_style_ref.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/styling/references/klp_style_ref.dart)

## 範圍

核心是 `lib/src/styling/references/klp_style_ref.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_style_ref.dart"]
	n1["../primitives/klp_primitive_index.dart"]
	n2["../primitives/klp_style_kind.dart"]
	n3["../primitives/klp_style_value.dart"]
	n4["../semantics/klp_semantic_key.dart"]
	n5["klp_primitive_ref.dart"]
	n6["klp_semantic_ref.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"part"| n5
	n0 -->|"part"| n6
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../primitives/klp_primitive_index.dart&#x27;;</code> | [lib/src/styling/references/klp_style_ref.dart:1](../../../../../lib/src/styling/references/klp_style_ref.dart#L1) |
| import | <code>import &#x27;../primitives/klp_style_kind.dart&#x27;;</code> | [lib/src/styling/references/klp_style_ref.dart:2](../../../../../lib/src/styling/references/klp_style_ref.dart#L2) |
| import | <code>import &#x27;../primitives/klp_style_value.dart&#x27;;</code> | [lib/src/styling/references/klp_style_ref.dart:3](../../../../../lib/src/styling/references/klp_style_ref.dart#L3) |
| import | <code>import &#x27;../semantics/klp_semantic_key.dart&#x27;;</code> | [lib/src/styling/references/klp_style_ref.dart:4](../../../../../lib/src/styling/references/klp_style_ref.dart#L4) |
| part | <code>part &#x27;klp_primitive_ref.dart&#x27;;</code> | [lib/src/styling/references/klp_style_ref.dart:6](../../../../../lib/src/styling/references/klp_style_ref.dart#L6) |
| part | <code>part &#x27;klp_semantic_ref.dart&#x27;;</code> | [lib/src/styling/references/klp_style_ref.dart:7](../../../../../lib/src/styling/references/klp_style_ref.dart#L7) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpStyleRef"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpStyleRef

ClassDeclaration · public · [lib/src/styling/references/klp_style_ref.dart:9](../../../../../lib/src/styling/references/klp_style_ref.dart#L9)

<code>sealed class KlpStyleRef&lt;T extends KlpStyleValue&gt;</code>

來源註解摘要：封閉的風格參照語言；消費端不能加入常值或任意求值函式。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpStyleRef</code> | public | <code>const KlpStyleRef()</code> |  | [lib/src/styling/references/klp_style_ref.dart:12](../../../../../lib/src/styling/references/klp_style_ref.dart#L12) |
| getter <code>kind</code> | public | <code>KlpStyleKind&lt;T&gt; get kind</code> |  | [lib/src/styling/references/klp_style_ref.dart:14](../../../../../lib/src/styling/references/klp_style_ref.dart#L14) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
