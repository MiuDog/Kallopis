# klp_semantic_key.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/styling/semantics/klp_semantic_key.dart)

## 範圍

核心是 `lib/src/styling/semantics/klp_semantic_key.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_semantic_key.dart"]
	n1["../primitives/klp_style_kind.dart"]
	n2["../primitives/klp_style_value.dart"]
	n3["internal/klp_semantic_identifier.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../primitives/klp_style_kind.dart&#x27;;</code> | [lib/src/styling/semantics/klp_semantic_key.dart:1](../../../../../lib/src/styling/semantics/klp_semantic_key.dart#L1) |
| import | <code>import &#x27;../primitives/klp_style_value.dart&#x27;;</code> | [lib/src/styling/semantics/klp_semantic_key.dart:2](../../../../../lib/src/styling/semantics/klp_semantic_key.dart#L2) |
| import | <code>import &#x27;internal/klp_semantic_identifier.dart&#x27;;</code> | [lib/src/styling/semantics/klp_semantic_key.dart:3](../../../../../lib/src/styling/semantics/klp_semantic_key.dart#L3) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpSemanticKey"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpSemanticKey

ClassDeclaration · public · [lib/src/styling/semantics/klp_semantic_key.dart:5](../../../../../lib/src/styling/semantics/klp_semantic_key.dart#L5)

<code>final class KlpSemanticKey&lt;T extends KlpStyleValue&gt;</code>

來源註解摘要：用途名稱與量值種類分離；相同名稱不能藉不同型別重複註冊。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>owner</code> | public | <code>final String owner</code> |  | [lib/src/styling/semantics/klp_semantic_key.dart:7](../../../../../lib/src/styling/semantics/klp_semantic_key.dart#L7) |
| field <code>name</code> | public | <code>final String name</code> |  | [lib/src/styling/semantics/klp_semantic_key.dart:8](../../../../../lib/src/styling/semantics/klp_semantic_key.dart#L8) |
| field <code>kind</code> | public | <code>final KlpStyleKind&lt;T&gt; kind</code> |  | [lib/src/styling/semantics/klp_semantic_key.dart:9](../../../../../lib/src/styling/semantics/klp_semantic_key.dart#L9) |
| constructor <code>KlpSemanticKey</code> | public | <code>KlpSemanticKey(this.owner, this.name, this.kind)</code> |  | [lib/src/styling/semantics/klp_semantic_key.dart:11](../../../../../lib/src/styling/semantics/klp_semantic_key.dart#L11) |
| getter <code>identity</code> | public | <code>(String, String) get identity</code> |  | [lib/src/styling/semantics/klp_semantic_key.dart:16](../../../../../lib/src/styling/semantics/klp_semantic_key.dart#L16) |
| getter <code>path</code> | public | <code>String get path</code> |  | [lib/src/styling/semantics/klp_semantic_key.dart:17](../../../../../lib/src/styling/semantics/klp_semantic_key.dart#L17) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
