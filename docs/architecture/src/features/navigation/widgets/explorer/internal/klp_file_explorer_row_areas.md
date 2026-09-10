# klp_file_explorer_row_areas.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../../lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_row_areas.dart)

## 範圍

核心是 `lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_row_areas.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_file_explorer_row_areas.dart"]
	n1["../klp_file_explorer.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_file_explorer.dart&#x27;;</code> | [lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_row_areas.dart:1](../../../../../../../../lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_row_areas.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["_KlpFileExplorerRowAreas"]
```

```mermaid
classDiagram
	class n0["_KlpFileExplorerRowAreas"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### _KlpFileExplorerRowAreas

ClassDeclaration · private · [lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_row_areas.dart:3](../../../../../../../../lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_row_areas.dart#L3)

<code>class _KlpFileExplorerRowAreas extends StatelessWidget</code>

來源註解摘要：將樹狀控制區與內容區分開，讓同層節點以內容圖示左緣對齊。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_row_areas.dart:4](../../../../../../../../lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_row_areas.dart#L4)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>_KlpFileExplorerRowAreas</code> | private | <code>const _KlpFileExplorerRowAreas({ required this.level, required this.spacing, required this.content, this.leading, })</code> |  | [lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_row_areas.dart:5](../../../../../../../../lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_row_areas.dart#L5) |
| field <code>level</code> | public | <code>final int level</code> |  | [lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_row_areas.dart:12](../../../../../../../../lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_row_areas.dart#L12) |
| field <code>spacing</code> | public | <code>final KlpFileExplorerSpacing spacing</code> |  | [lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_row_areas.dart:13](../../../../../../../../lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_row_areas.dart#L13) |
| field <code>leading</code> | public | <code>final Widget? leading</code> |  | [lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_row_areas.dart:14](../../../../../../../../lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_row_areas.dart#L14) |
| field <code>content</code> | public | <code>final Widget content</code> |  | [lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_row_areas.dart:15](../../../../../../../../lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_row_areas.dart#L15) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_row_areas.dart:17](../../../../../../../../lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_row_areas.dart#L17) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
