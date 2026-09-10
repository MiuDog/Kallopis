# klp_node_adapter.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/runtime/compilation/internal/klp_node_adapter.dart)

## 範圍

核心是 `lib/src/runtime/compilation/internal/klp_node_adapter.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_node_adapter.dart"]
	n1["../../../composition/definitions/klp_definition.dart"]
	n2["../../../composition/nodes/klp_node.dart"]
	n3["../../../composition/validation/klp_validated_node.dart"]
	n4["klp_prepare_context.dart"]
	n5["klp_prepared_node.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../../../composition/definitions/klp_definition.dart&#x27;;</code> | [lib/src/runtime/compilation/internal/klp_node_adapter.dart:1](../../../../../../lib/src/runtime/compilation/internal/klp_node_adapter.dart#L1) |
| import | <code>import &#x27;../../../composition/nodes/klp_node.dart&#x27;;</code> | [lib/src/runtime/compilation/internal/klp_node_adapter.dart:2](../../../../../../lib/src/runtime/compilation/internal/klp_node_adapter.dart#L2) |
| import | <code>import &#x27;../../../composition/validation/klp_validated_node.dart&#x27;;</code> | [lib/src/runtime/compilation/internal/klp_node_adapter.dart:3](../../../../../../lib/src/runtime/compilation/internal/klp_node_adapter.dart#L3) |
| import | <code>import &#x27;klp_prepare_context.dart&#x27;;</code> | [lib/src/runtime/compilation/internal/klp_node_adapter.dart:4](../../../../../../lib/src/runtime/compilation/internal/klp_node_adapter.dart#L4) |
| import | <code>import &#x27;klp_prepared_node.dart&#x27;;</code> | [lib/src/runtime/compilation/internal/klp_node_adapter.dart:5](../../../../../../lib/src/runtime/compilation/internal/klp_node_adapter.dart#L5) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpNodeAdapter"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpNodeAdapter

ClassDeclaration · public · [lib/src/runtime/compilation/internal/klp_node_adapter.dart:7](../../../../../../lib/src/runtime/compilation/internal/klp_node_adapter.dart#L7)

<code>abstract interface class KlpNodeAdapter</code>

來源註解摘要：本庫內部把功能降為封閉 foundation，runtime 不認識特定功能型別。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| getter <code>contract</code> | public | <code>KlpDefinition&lt;KlpNode&gt; get contract</code> |  | [lib/src/runtime/compilation/internal/klp_node_adapter.dart:10](../../../../../../lib/src/runtime/compilation/internal/klp_node_adapter.dart#L10) |
| method <code>prepare</code> | public | <code>KlpPreparedNode prepare(KlpNode node, KlpValidatedNode snapshot, KlpPrepareContext context)</code> |  | [lib/src/runtime/compilation/internal/klp_node_adapter.dart:11](../../../../../../lib/src/runtime/compilation/internal/klp_node_adapter.dart#L11) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
