# klp_rail_draggable_entry.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../../lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart)

## 範圍

核心是 `lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_rail_draggable_entry.dart"]
	n1["../klp_navigation_rail.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_navigation_rail.dart&#x27;;</code> | [lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart:1](../../../../../../../../lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["_KlpRailDraggableEntry"]
```

```mermaid
classDiagram
	class n0["_KlpRailDraggableEntry"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### _KlpRailDraggableEntry

ClassDeclaration · private · [lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart:3](../../../../../../../../lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart#L3)

<code>class _KlpRailDraggableEntry extends StatelessWidget</code>

- `extends` → <code>StatelessWidget</code>：[lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart:3](../../../../../../../../lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart#L3)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>_KlpRailDraggableEntry</code> | private | <code>const _KlpRailDraggableEntry({ required this.data, required this.targetIndex, required this.onWillAccept, required this.onDropIndexChanged, required this.onAccepted, required this.onDragStarted, required this.onDragEnded, required this.item, })</code> |  | [lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart:4](../../../../../../../../lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart#L4) |
| field <code>data</code> | public | <code>final _KlpRailDragData data</code> |  | [lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart:15](../../../../../../../../lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart#L15) |
| field <code>targetIndex</code> | public | <code>final int targetIndex</code> |  | [lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart:16](../../../../../../../../lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart#L16) |
| field <code>onWillAccept</code> | public | <code>final bool Function(_KlpRailDragData) onWillAccept</code> |  | [lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart:17](../../../../../../../../lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart#L17) |
| field <code>onDropIndexChanged</code> | public | <code>final ValueChanged&lt;int&gt; onDropIndexChanged</code> |  | [lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart:18](../../../../../../../../lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart#L18) |
| field <code>onAccepted</code> | public | <code>final ValueChanged&lt;_KlpRailDragData&gt; onAccepted</code> |  | [lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart:19](../../../../../../../../lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart#L19) |
| field <code>onDragStarted</code> | public | <code>final VoidCallback onDragStarted</code> |  | [lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart:20](../../../../../../../../lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart#L20) |
| field <code>onDragEnded</code> | public | <code>final VoidCallback onDragEnded</code> |  | [lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart:21](../../../../../../../../lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart#L21) |
| field <code>item</code> | public | <code>final Widget item</code> |  | [lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart:22](../../../../../../../../lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart#L22) |
| method <code>_showDropIndex</code> | private | <code>void _showDropIndex(BuildContext targetContext, Offset globalPosition)</code> |  | [lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart:24](../../../../../../../../lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart#L24) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart:37](../../../../../../../../lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart#L37) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
