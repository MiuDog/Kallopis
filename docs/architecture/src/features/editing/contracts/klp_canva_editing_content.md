# klp_canva_editing_content.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/editing/contracts/klp_canva_editing_content.dart)

## 範圍

核心是 `lib/src/features/editing/contracts/klp_canva_editing_content.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_canva_editing_content.dart"]
	n1["package:krepis_canva/krepis_canva.dart"]
	n2["package:kallopis/src/composition/nodes/klp_composite_node.dart"]
	n3["package:kallopis/src/composition/slots/klp_children.dart"]
	n4["package:kallopis/src/composition/slots/klp_screen_body.dart"]
	n5["package:kallopis/src/kernel/identity/klp_id.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:krepis_canva/krepis_canva.dart&#x27;;</code> | [lib/src/features/editing/contracts/klp_canva_editing_content.dart:1](../../../../../../lib/src/features/editing/contracts/klp_canva_editing_content.dart#L1) |
| import | <code>import &#x27;package:kallopis/src/composition/nodes/klp_composite_node.dart&#x27;;</code> | [lib/src/features/editing/contracts/klp_canva_editing_content.dart:2](../../../../../../lib/src/features/editing/contracts/klp_canva_editing_content.dart#L2) |
| import | <code>import &#x27;package:kallopis/src/composition/slots/klp_children.dart&#x27;;</code> | [lib/src/features/editing/contracts/klp_canva_editing_content.dart:3](../../../../../../lib/src/features/editing/contracts/klp_canva_editing_content.dart#L3) |
| import | <code>import &#x27;package:kallopis/src/composition/slots/klp_screen_body.dart&#x27;;</code> | [lib/src/features/editing/contracts/klp_canva_editing_content.dart:4](../../../../../../lib/src/features/editing/contracts/klp_canva_editing_content.dart#L4) |
| import | <code>import &#x27;package:kallopis/src/kernel/identity/klp_id.dart&#x27;;</code> | [lib/src/features/editing/contracts/klp_canva_editing_content.dart:5](../../../../../../lib/src/features/editing/contracts/klp_canva_editing_content.dart#L5) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpCanvaEditingContent"]
```

```mermaid
classDiagram
	class n0["KlpCanvaEditingContent"]
	class n1["KlpScreenBody"]
	class n2["KlpCompositeNode"]
	n0 ..|> n1 : implements
	n0 ..|> n2 : implements
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpCanvaEditingContent

ClassDeclaration · public · [lib/src/features/editing/contracts/klp_canva_editing_content.dart:7](../../../../../../lib/src/features/editing/contracts/klp_canva_editing_content.dart#L7)

<code>final class KlpCanvaEditingContent implements KlpScreenBody, KlpCompositeNode</code>

來源註解摘要：受限 Canva 節點；consumer 只能提供 Krepis session。

- `implements` → <code>KlpScreenBody</code>：[lib/src/features/editing/contracts/klp_canva_editing_content.dart:8](../../../../../../lib/src/features/editing/contracts/klp_canva_editing_content.dart#L8)
- `implements` → <code>KlpCompositeNode</code>：[lib/src/features/editing/contracts/klp_canva_editing_content.dart:8](../../../../../../lib/src/features/editing/contracts/klp_canva_editing_content.dart#L8)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>typeId</code> | public | <code>static const (inferred) typeId</code> |  | [lib/src/features/editing/contracts/klp_canva_editing_content.dart:9](../../../../../../lib/src/features/editing/contracts/klp_canva_editing_content.dart#L9) |
| field <code>id</code> | public | <code>final KlpId id</code> |  | [lib/src/features/editing/contracts/klp_canva_editing_content.dart:12](../../../../../../lib/src/features/editing/contracts/klp_canva_editing_content.dart#L12) |
| field <code>controller</code> | public | <code>final KrepisCanvaSessionController controller</code> |  | [lib/src/features/editing/contracts/klp_canva_editing_content.dart:13](../../../../../../lib/src/features/editing/contracts/klp_canva_editing_content.dart#L13) |
| field <code>children</code> | public | <code>final KlpChildren children</code> |  | [lib/src/features/editing/contracts/klp_canva_editing_content.dart:15](../../../../../../lib/src/features/editing/contracts/klp_canva_editing_content.dart#L15) |
| constructor <code>KlpCanvaEditingContent</code> | public | <code>KlpCanvaEditingContent({required this.id, required this.controller})</code> |  | [lib/src/features/editing/contracts/klp_canva_editing_content.dart:17](../../../../../../lib/src/features/editing/contracts/klp_canva_editing_content.dart#L17) |
| getter <code>definitionId</code> | public | <code>String get definitionId</code> |  | [lib/src/features/editing/contracts/klp_canva_editing_content.dart:23](../../../../../../lib/src/features/editing/contracts/klp_canva_editing_content.dart#L23) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
