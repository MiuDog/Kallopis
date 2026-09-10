# klp_explorer_category.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../../lib/src/features/navigation/widgets/explorer/models/klp_explorer_category.dart)

## 範圍

核心是 `lib/src/features/navigation/widgets/explorer/models/klp_explorer_category.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_explorer_category.dart"]
	n1["../klp_explorer_models.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_explorer_models.dart&#x27;;</code> | [lib/src/features/navigation/widgets/explorer/models/klp_explorer_category.dart:1](../../../../../../../../lib/src/features/navigation/widgets/explorer/models/klp_explorer_category.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpExplorerCategory"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpExplorerCategory

ClassDeclaration · public · [lib/src/features/navigation/widgets/explorer/models/klp_explorer_category.dart:3](../../../../../../../../lib/src/features/navigation/widgets/explorer/models/klp_explorer_category.dart#L3)

<code>class KlpExplorerCategory</code>

來源註解摘要：Explorer 的分類資料模型。 分類只負責命名一組節點與宣告是否可收合；尺寸、內距與 排版由 `KlpExplorer` 統一管理。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpExplorerCategory</code> | public | <code>const KlpExplorerCategory({ required this.id, required this.label, this.nodes = const [], this.expanded = true, this.collapsible = true, })</code> |  | [lib/src/features/navigation/widgets/explorer/models/klp_explorer_category.dart:9](../../../../../../../../lib/src/features/navigation/widgets/explorer/models/klp_explorer_category.dart#L9) |
| field <code>id</code> | public | <code>final String id</code> |  | [lib/src/features/navigation/widgets/explorer/models/klp_explorer_category.dart:17](../../../../../../../../lib/src/features/navigation/widgets/explorer/models/klp_explorer_category.dart#L17) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/features/navigation/widgets/explorer/models/klp_explorer_category.dart:18](../../../../../../../../lib/src/features/navigation/widgets/explorer/models/klp_explorer_category.dart#L18) |
| field <code>nodes</code> | public | <code>final List&lt;KlpExplorerNode&gt; nodes</code> |  | [lib/src/features/navigation/widgets/explorer/models/klp_explorer_category.dart:19](../../../../../../../../lib/src/features/navigation/widgets/explorer/models/klp_explorer_category.dart#L19) |
| field <code>expanded</code> | public | <code>final bool expanded</code> |  | [lib/src/features/navigation/widgets/explorer/models/klp_explorer_category.dart:20](../../../../../../../../lib/src/features/navigation/widgets/explorer/models/klp_explorer_category.dart#L20) |
| field <code>collapsible</code> | public | <code>final bool collapsible</code> |  | [lib/src/features/navigation/widgets/explorer/models/klp_explorer_category.dart:21](../../../../../../../../lib/src/features/navigation/widgets/explorer/models/klp_explorer_category.dart#L21) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
