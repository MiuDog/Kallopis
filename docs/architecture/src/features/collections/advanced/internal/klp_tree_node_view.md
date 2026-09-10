# klp_tree_node_view.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../../lib/src/features/collections/advanced/internal/klp_tree_node_view.dart)

## 範圍

核心是 `lib/src/features/collections/advanced/internal/klp_tree_node_view.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_tree_node_view.dart"]
	n1["../klp_advanced_data.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_advanced_data.dart&#x27;;</code> | [lib/src/features/collections/advanced/internal/klp_tree_node_view.dart:1](../../../../../../../lib/src/features/collections/advanced/internal/klp_tree_node_view.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["_KlpTreeNodeView"]
```

```mermaid
classDiagram
	class n0["_KlpTreeNodeView"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### _KlpTreeNodeView

ClassDeclaration · private · [lib/src/features/collections/advanced/internal/klp_tree_node_view.dart:3](../../../../../../../lib/src/features/collections/advanced/internal/klp_tree_node_view.dart#L3)

<code>class _KlpTreeNodeView extends StatelessWidget</code>

- `extends` → <code>StatelessWidget</code>：[lib/src/features/collections/advanced/internal/klp_tree_node_view.dart:3](../../../../../../../lib/src/features/collections/advanced/internal/klp_tree_node_view.dart#L3)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>_KlpTreeNodeView</code> | private | <code>const _KlpTreeNodeView({ required this.node, required this.onSelected, this.expandedIds, this.selectedId, this.onExpanded, })</code> |  | [lib/src/features/collections/advanced/internal/klp_tree_node_view.dart:4](../../../../../../../lib/src/features/collections/advanced/internal/klp_tree_node_view.dart#L4) |
| field <code>node</code> | public | <code>final KlpTreeNode node</code> |  | [lib/src/features/collections/advanced/internal/klp_tree_node_view.dart:12](../../../../../../../lib/src/features/collections/advanced/internal/klp_tree_node_view.dart#L12) |
| field <code>expandedIds</code> | public | <code>final Set&lt;String&gt;? expandedIds</code> |  | [lib/src/features/collections/advanced/internal/klp_tree_node_view.dart:13](../../../../../../../lib/src/features/collections/advanced/internal/klp_tree_node_view.dart#L13) |
| field <code>selectedId</code> | public | <code>final String? selectedId</code> |  | [lib/src/features/collections/advanced/internal/klp_tree_node_view.dart:14](../../../../../../../lib/src/features/collections/advanced/internal/klp_tree_node_view.dart#L14) |
| field <code>onSelected</code> | public | <code>final ValueChanged&lt;String&gt;? onSelected</code> |  | [lib/src/features/collections/advanced/internal/klp_tree_node_view.dart:15](../../../../../../../lib/src/features/collections/advanced/internal/klp_tree_node_view.dart#L15) |
| field <code>onExpanded</code> | public | <code>final ValueChanged&lt;String&gt;? onExpanded</code> |  | [lib/src/features/collections/advanced/internal/klp_tree_node_view.dart:16](../../../../../../../lib/src/features/collections/advanced/internal/klp_tree_node_view.dart#L16) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/collections/advanced/internal/klp_tree_node_view.dart:18](../../../../../../../lib/src/features/collections/advanced/internal/klp_tree_node_view.dart#L18) |
| method <code>_rowChildren</code> | private | <code>List&lt;Widget&gt; _rowChildren( _KlpAdvancedStyle style, bool selected, bool expanded, bool expandable, Color? statusColor, )</code> |  | [lib/src/features/collections/advanced/internal/klp_tree_node_view.dart:84](../../../../../../../lib/src/features/collections/advanced/internal/klp_tree_node_view.dart#L84) |
| method <code>_statusColor</code> | private | <code>Color? _statusColor(_KlpAdvancedStyle style)</code> |  | [lib/src/features/collections/advanced/internal/klp_tree_node_view.dart:154](../../../../../../../lib/src/features/collections/advanced/internal/klp_tree_node_view.dart#L154) |
| method <code>_labelColor</code> | private | <code>Color _labelColor( _KlpAdvancedStyle style, bool selected, Color? statusColor, )</code> |  | [lib/src/features/collections/advanced/internal/klp_tree_node_view.dart:164](../../../../../../../lib/src/features/collections/advanced/internal/klp_tree_node_view.dart#L164) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
