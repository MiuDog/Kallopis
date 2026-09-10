# klp_file_explorer_item_view.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../../lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_item_view.dart)

## 範圍

核心是 `lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_item_view.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_file_explorer_item_view.dart"]
	n1["../klp_file_explorer.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_file_explorer.dart&#x27;;</code> | [lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_item_view.dart:1](../../../../../../../../lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_item_view.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpFileExplorerItemView"]
```

```mermaid
classDiagram
	class n0["KlpFileExplorerItemView"]
	class n1["StatefulWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpFileExplorerItemView

ClassDeclaration · public · [lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_item_view.dart:3](../../../../../../../../lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_item_view.dart#L3)

<code>class KlpFileExplorerItemView extends StatefulWidget</code>

來源註解摘要：一般檔案項目視圖（含檔案圖示、文字標題、選取高亮與 Hover 回饋）。

- `extends` → <code>StatefulWidget</code>：[lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_item_view.dart:4](../../../../../../../../lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_item_view.dart#L4)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpFileExplorerItemView</code> | public | <code>const KlpFileExplorerItemView({ super.key, required this.item, required this.level, required this.isSelected, required this.onTap, this.spacing = KlpFileExplorerSpacing.standard, })</code> |  | [lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_item_view.dart:5](../../../../../../../../lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_item_view.dart#L5) |
| field <code>item</code> | public | <code>final KlpFileExplorerItem item</code> |  | [lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_item_view.dart:14](../../../../../../../../lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_item_view.dart#L14) |
| field <code>level</code> | public | <code>final int level</code> |  | [lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_item_view.dart:15](../../../../../../../../lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_item_view.dart#L15) |
| field <code>isSelected</code> | public | <code>final bool isSelected</code> |  | [lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_item_view.dart:16](../../../../../../../../lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_item_view.dart#L16) |
| field <code>onTap</code> | public | <code>final VoidCallback onTap</code> |  | [lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_item_view.dart:17](../../../../../../../../lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_item_view.dart#L17) |
| field <code>spacing</code> | public | <code>final KlpFileExplorerSpacing spacing</code> |  | [lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_item_view.dart:18](../../../../../../../../lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_item_view.dart#L18) |
| method <code>createState</code> | public | <code>State&lt;KlpFileExplorerItemView&gt; createState()</code> |  | [lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_item_view.dart:20](../../../../../../../../lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_item_view.dart#L20) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
