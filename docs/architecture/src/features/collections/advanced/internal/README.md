# lib/src/features/collections/advanced/internal：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/features/collections/advanced/internal` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart TD
	n0["lib/src/features/collections/advanced/internal"]
	n1["lib/src/features/collections/advanced"]
	n0 -->|"part of"| n1
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/features/collections/advanced</code> | part of | 10 | [lib/src/features/collections/advanced/internal/klp_data_table.dart:1](../../../../../../../lib/src/features/collections/advanced/internal/klp_data_table.dart#L1) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/features/collections/advanced/internal"]
	n1["klp_data_table.dart"]
	n2["klp_file_preview.dart"]
	n3["klp_file_preview_body.dart"]
	n4["klp_json_node.dart"]
	n5["klp_json_node_state.dart"]
	n6["klp_json_tree.dart"]
	n7["klp_table_line.dart"]
	n8["klp_tree.dart"]
	n9["klp_tree_item.dart"]
	n10["klp_tree_node_view.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
	n0 -->|"contains"| n3
	n0 -->|"contains"| n4
	n0 -->|"contains"| n5
	n0 -->|"contains"| n6
	n0 -->|"contains"| n7
	n0 -->|"contains"| n8
	n0 -->|"contains"| n9
	n0 -->|"contains"| n10
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| 無 | 目前沒有下一層目錄 | — |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_data_table.dart` | KlpDataTable | [架構與 API](klp_data_table.md) | [lib/src/features/collections/advanced/internal/klp_data_table.dart:1](../../../../../../../lib/src/features/collections/advanced/internal/klp_data_table.dart#L1) |
| `klp_file_preview.dart` | KlpFilePreview | [架構與 API](klp_file_preview.md) | [lib/src/features/collections/advanced/internal/klp_file_preview.dart:1](../../../../../../../lib/src/features/collections/advanced/internal/klp_file_preview.dart#L1) |
| `klp_file_preview_body.dart` | _KlpFilePreviewBody | [架構與 API](klp_file_preview_body.md) | [lib/src/features/collections/advanced/internal/klp_file_preview_body.dart:1](../../../../../../../lib/src/features/collections/advanced/internal/klp_file_preview_body.dart#L1) |
| `klp_json_node.dart` | _KlpJsonNode | [架構與 API](klp_json_node.md) | [lib/src/features/collections/advanced/internal/klp_json_node.dart:1](../../../../../../../lib/src/features/collections/advanced/internal/klp_json_node.dart#L1) |
| `klp_json_node_state.dart` | _KlpJsonNodeState | [架構與 API](klp_json_node_state.md) | [lib/src/features/collections/advanced/internal/klp_json_node_state.dart:1](../../../../../../../lib/src/features/collections/advanced/internal/klp_json_node_state.dart#L1) |
| `klp_json_tree.dart` | KlpJsonTree | [架構與 API](klp_json_tree.md) | [lib/src/features/collections/advanced/internal/klp_json_tree.dart:1](../../../../../../../lib/src/features/collections/advanced/internal/klp_json_tree.dart#L1) |
| `klp_table_line.dart` | _KlpTableLine | [架構與 API](klp_table_line.md) | [lib/src/features/collections/advanced/internal/klp_table_line.dart:1](../../../../../../../lib/src/features/collections/advanced/internal/klp_table_line.dart#L1) |
| `klp_tree.dart` | KlpTree | [架構與 API](klp_tree.md) | [lib/src/features/collections/advanced/internal/klp_tree.dart:1](../../../../../../../lib/src/features/collections/advanced/internal/klp_tree.dart#L1) |
| `klp_tree_item.dart` | KlpTreeItem | [架構與 API](klp_tree_item.md) | [lib/src/features/collections/advanced/internal/klp_tree_item.dart:1](../../../../../../../lib/src/features/collections/advanced/internal/klp_tree_item.dart#L1) |
| `klp_tree_node_view.dart` | _KlpTreeNodeView | [架構與 API](klp_tree_node_view.md) | [lib/src/features/collections/advanced/internal/klp_tree_node_view.dart:1](../../../../../../../lib/src/features/collections/advanced/internal/klp_tree_node_view.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
