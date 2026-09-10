# klp_file_explorer_item.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../../lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart)

## 範圍

核心是 `lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_file_explorer_item.dart"]
	n1["../klp_file_explorer.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_file_explorer.dart&#x27;;</code> | [lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart:1](../../../../../../../../lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpFileExplorerItem"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpFileExplorerItem

ClassDeclaration · public · [lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart:3](../../../../../../../../lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart#L3)

<code>class KlpFileExplorerItem</code>

來源註解摘要：檔案瀏覽器中的節點資料模型（可為折疊資料夾或一般檔案項目）。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpFileExplorerItem</code> | public | <code>const KlpFileExplorerItem({ required this.id, required this.label, this.icon, this.children = const [], this.folder = false, this.expanded = false, this.selected = false, this.badge, this.tone, this.trailing, this.data, })</code> |  | [lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart:6](../../../../../../../../lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart#L6) |
| field <code>id</code> | public | <code>final String id</code> |  | [lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart:20](../../../../../../../../lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart#L20) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart:21](../../../../../../../../lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart#L21) |
| field <code>icon</code> | public | <code>final KlpIconData? icon</code> |  | [lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart:22](../../../../../../../../lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart#L22) |
| field <code>children</code> | public | <code>final List&lt;KlpFileExplorerItem&gt; children</code> |  | [lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart:23](../../../../../../../../lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart#L23) |
| field <code>folder</code> | public | <code>final bool folder</code> |  | [lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart:24](../../../../../../../../lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart#L24) |
| field <code>expanded</code> | public | <code>final bool expanded</code> |  | [lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart:25](../../../../../../../../lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart#L25) |
| field <code>selected</code> | public | <code>final bool selected</code> |  | [lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart:26](../../../../../../../../lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart#L26) |
| field <code>badge</code> | public | <code>final String? badge</code> |  | [lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart:27](../../../../../../../../lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart#L27) |
| field <code>tone</code> | public | <code>final KlpFeedbackTone? tone</code> |  | [lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart:28](../../../../../../../../lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart#L28) |
| field <code>trailing</code> | public | <code>final Widget? trailing</code> |  | [lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart:29](../../../../../../../../lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart#L29) |
| field <code>data</code> | public | <code>final Object? data</code> |  | [lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart:30](../../../../../../../../lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart#L30) |
| getter <code>isFolder</code> | public | <code>bool get isFolder</code> |  | [lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart:32](../../../../../../../../lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_item.dart#L32) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
