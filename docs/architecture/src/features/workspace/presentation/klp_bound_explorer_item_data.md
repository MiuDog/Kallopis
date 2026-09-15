# klp_bound_explorer_item_data.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart)

## 範圍

核心是 `lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_bound_explorer_item_data.dart"]
	n1["klp_workspace_presentation.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;klp_workspace_presentation.dart&#x27;;</code> | [lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart:1](../../../../../../lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpBoundExplorerItemData"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpBoundExplorerItemData

ClassDeclaration · public · [lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart:3](../../../../../../lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart#L3)

<code>final class KlpBoundExplorerItemData</code>

來源註解摘要：套件內部的唯讀 Explorer 項目資料，保留來源與放置身分、子項目及動作。 不屬使用端 API，不自行變更階層、選取或展開狀態。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>id</code> | public | <code>final KlpPlacementId id</code> |  | [lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart:6](../../../../../../lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart#L6) |
| field <code>sourceId</code> | public | <code>final KlpId sourceId</code> |  | [lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart:7](../../../../../../lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart#L7) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart:8](../../../../../../lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart#L8) |
| field <code>folder</code> | public | <code>final bool folder</code> |  | [lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart:9](../../../../../../lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart#L9) |
| field <code>category</code> | public | <code>final bool category</code> |  | [lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart:10](../../../../../../lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart#L10) |
| field <code>collapsible</code> | public | <code>final bool collapsible</code> |  | [lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart:11](../../../../../../lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart#L11) |
| field <code>icon</code> | public | <code>final String? icon</code> |  | [lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart:12](../../../../../../lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart#L12) |
| field <code>badge</code> | public | <code>final String? badge</code> |  | [lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart:13](../../../../../../lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart#L13) |
| field <code>selected</code> | public | <code>final bool selected</code> |  | [lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart:14](../../../../../../lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart#L14) |
| field <code>expanded</code> | public | <code>final bool expanded</code> |  | [lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart:15](../../../../../../lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart#L15) |
| field <code>children</code> | public | <code>final List&lt;KlpBoundExplorerItemData&gt; children</code> |  | [lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart:16](../../../../../../lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart#L16) |
| field <code>actions</code> | public | <code>final List&lt;KlpBoundWorkspaceCommand&gt; actions</code> |  | [lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart:17](../../../../../../lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart#L17) |
| constructor <code>KlpBoundExplorerItemData</code> | public | <code>const KlpBoundExplorerItemData({required this.id, required this.sourceId, required this.label, required this.folder, this.category = false, this.collapsible = true, this.icon, this.badge, required this.selected, required this.expanded, required this.children, this.actions = const []})</code> |  | [lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart:18](../../../../../../lib/src/features/workspace/presentation/klp_bound_explorer_item_data.dart#L18) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
