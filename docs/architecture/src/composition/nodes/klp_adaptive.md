# klp_adaptive.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/composition/nodes/klp_adaptive.dart)

## 範圍

核心是 `lib/src/composition/nodes/klp_adaptive.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_adaptive.dart"]
	n1["package:kallopis/src/kernel/identity/klp_id.dart"]
	n2["package:kallopis/src/composition/slots/klp_children.dart"]
	n3["package:kallopis/src/composition/slots/klp_screen_body.dart"]
	n4["package:kallopis/src/composition/slots/klp_slot.dart"]
	n5["klp_composite_node.dart"]
	n6["klp_platform_strategy.dart"]
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
| import | <code>import &#x27;package:kallopis/src/kernel/identity/klp_id.dart&#x27;;</code> | [lib/src/composition/nodes/klp_adaptive.dart:1](../../../../../lib/src/composition/nodes/klp_adaptive.dart#L1) |
| import | <code>import &#x27;package:kallopis/src/composition/slots/klp_children.dart&#x27;;</code> | [lib/src/composition/nodes/klp_adaptive.dart:2](../../../../../lib/src/composition/nodes/klp_adaptive.dart#L2) |
| import | <code>import &#x27;package:kallopis/src/composition/slots/klp_screen_body.dart&#x27;;</code> | [lib/src/composition/nodes/klp_adaptive.dart:3](../../../../../lib/src/composition/nodes/klp_adaptive.dart#L3) |
| import | <code>import &#x27;package:kallopis/src/composition/slots/klp_slot.dart&#x27;;</code> | [lib/src/composition/nodes/klp_adaptive.dart:4](../../../../../lib/src/composition/nodes/klp_adaptive.dart#L4) |
| import | <code>import &#x27;klp_composite_node.dart&#x27;;</code> | [lib/src/composition/nodes/klp_adaptive.dart:5](../../../../../lib/src/composition/nodes/klp_adaptive.dart#L5) |
| import | <code>import &#x27;klp_platform_strategy.dart&#x27;;</code> | [lib/src/composition/nodes/klp_adaptive.dart:6](../../../../../lib/src/composition/nodes/klp_adaptive.dart#L6) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpAdaptive"]
```

```mermaid
classDiagram
	class n0["KlpAdaptive"]
	class n1["KlpCompositeNode"]
	class n2["KlpScreenBody"]
	n0 ..|> n1 : implements
	n0 ..|> n2 : implements
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpAdaptive

ClassDeclaration · public · [lib/src/composition/nodes/klp_adaptive.dart:8](../../../../../lib/src/composition/nodes/klp_adaptive.dart#L8)

<code>final class KlpAdaptive implements KlpCompositeNode, KlpScreenBody</code>

來源註解摘要：宣告式平台分流節點；由 Kallopis 選定平台後才建立命中策略子樹。

- `implements` → <code>KlpCompositeNode</code>：[lib/src/composition/nodes/klp_adaptive.dart:9](../../../../../lib/src/composition/nodes/klp_adaptive.dart#L9)
- `implements` → <code>KlpScreenBody</code>：[lib/src/composition/nodes/klp_adaptive.dart:9](../../../../../lib/src/composition/nodes/klp_adaptive.dart#L9)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>typeId</code> | public | <code>static const String typeId</code> |  | [lib/src/composition/nodes/klp_adaptive.dart:10](../../../../../lib/src/composition/nodes/klp_adaptive.dart#L10) |
| field <code>fallbackSlot</code> | public | <code>static final (inferred) fallbackSlot</code> | 保底通用內容插槽（必填 1 個）。 | [lib/src/composition/nodes/klp_adaptive.dart:13](../../../../../lib/src/composition/nodes/klp_adaptive.dart#L13) |
| field <code>id</code> | public | <code>final KlpId id</code> |  | [lib/src/composition/nodes/klp_adaptive.dart:21](../../../../../lib/src/composition/nodes/klp_adaptive.dart#L21) |
| field <code>fallback</code> | public | <code>final KlpCompositeNode fallback</code> | 沒有命中平台策略時使用的通用內容。 | [lib/src/composition/nodes/klp_adaptive.dart:24](../../../../../lib/src/composition/nodes/klp_adaptive.dart#L24) |
| field <code>strategies</code> | public | <code>final Map&lt;KlpAdaptivePlatform, KlpPlatformStrategy&gt; strategies</code> | 依平台延後建立的策略；未命中的策略絕不會被呼叫。 | [lib/src/composition/nodes/klp_adaptive.dart:27](../../../../../lib/src/composition/nodes/klp_adaptive.dart#L27) |
| field <code>children</code> | public | <code>final KlpChildren children</code> |  | [lib/src/composition/nodes/klp_adaptive.dart:30](../../../../../lib/src/composition/nodes/klp_adaptive.dart#L30) |
| getter <code>definitionId</code> | public | <code>String get definitionId</code> |  | [lib/src/composition/nodes/klp_adaptive.dart:32](../../../../../lib/src/composition/nodes/klp_adaptive.dart#L32) |
| constructor <code>KlpAdaptive</code> | public | <code>KlpAdaptive({ required this.id, required this.fallback, Map&lt;KlpAdaptivePlatform, KlpPlatformStrategy&gt; strategies = const {}, })</code> |  | [lib/src/composition/nodes/klp_adaptive.dart:35](../../../../../lib/src/composition/nodes/klp_adaptive.dart#L35) |
| method <code>childrenFor</code> | public | <code>KlpChildren childrenFor(KlpAdaptiveContext? context)</code> |  | [lib/src/composition/nodes/klp_adaptive.dart:44](../../../../../lib/src/composition/nodes/klp_adaptive.dart#L44) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
