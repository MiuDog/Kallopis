# klp_screen.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/application/structure/klp_screen.dart)

## 範圍

核心是 `lib/src/application/structure/klp_screen.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_screen.dart"]
	n1["../../composition/nodes/klp_composite_node.dart"]
	n2["../../composition/slots/klp_children.dart"]
	n3["../../composition/slots/klp_slot.dart"]
	n4["../../composition/slots/klp_screen_body.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../../composition/nodes/klp_composite_node.dart&#x27;;</code> | [lib/src/application/structure/klp_screen.dart:1](../../../../../lib/src/application/structure/klp_screen.dart#L1) |
| import | <code>import &#x27;../../composition/slots/klp_children.dart&#x27;;</code> | [lib/src/application/structure/klp_screen.dart:2](../../../../../lib/src/application/structure/klp_screen.dart#L2) |
| import | <code>import &#x27;../../composition/slots/klp_slot.dart&#x27;;</code> | [lib/src/application/structure/klp_screen.dart:3](../../../../../lib/src/application/structure/klp_screen.dart#L3) |
| import | <code>import &#x27;../../composition/slots/klp_screen_body.dart&#x27;;</code> | [lib/src/application/structure/klp_screen.dart:4](../../../../../lib/src/application/structure/klp_screen.dart#L4) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpScreen"]
```

```mermaid
classDiagram
	class n0["KlpScreen"]
	class n1["KlpCompositeNode"]
	n0 ..|> n1 : implements
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpScreen

ClassDeclaration · public · [lib/src/application/structure/klp_screen.dart:6](../../../../../lib/src/application/structure/klp_screen.dart#L6)

<code>final class KlpScreen implements KlpCompositeNode</code>

來源註解摘要：畫面宣告只接受具有畫面內容資格的節點，渲染由本庫負責。

- `implements` → <code>KlpCompositeNode</code>：[lib/src/application/structure/klp_screen.dart:7](../../../../../lib/src/application/structure/klp_screen.dart#L7)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>typeId</code> | public | <code>static const String typeId</code> |  | [lib/src/application/structure/klp_screen.dart:9](../../../../../lib/src/application/structure/klp_screen.dart#L9) |
| field <code>bodySlot</code> | public | <code>static final (inferred) bodySlot</code> |  | [lib/src/application/structure/klp_screen.dart:10](../../../../../lib/src/application/structure/klp_screen.dart#L10) |
| field <code>id</code> | public | <code>final String id</code> |  | [lib/src/application/structure/klp_screen.dart:13](../../../../../lib/src/application/structure/klp_screen.dart#L13) |
| field <code>accessibilityLabel</code> | public | <code>final String accessibilityLabel</code> |  | [lib/src/application/structure/klp_screen.dart:14](../../../../../lib/src/application/structure/klp_screen.dart#L14) |
| field <code>child</code> | public | <code>final KlpScreenBody child</code> |  | [lib/src/application/structure/klp_screen.dart:15](../../../../../lib/src/application/structure/klp_screen.dart#L15) |
| field <code>children</code> | public | <code>final KlpChildren children</code> |  | [lib/src/application/structure/klp_screen.dart:17](../../../../../lib/src/application/structure/klp_screen.dart#L17) |
| constructor <code>KlpScreen</code> | public | <code>KlpScreen({ required this.id, required this.accessibilityLabel, required this.child, })</code> |  | [lib/src/application/structure/klp_screen.dart:19](../../../../../lib/src/application/structure/klp_screen.dart#L19) |
| getter <code>definitionId</code> | public | <code>String get definitionId</code> |  | [lib/src/application/structure/klp_screen.dart:33](../../../../../lib/src/application/structure/klp_screen.dart#L33) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
