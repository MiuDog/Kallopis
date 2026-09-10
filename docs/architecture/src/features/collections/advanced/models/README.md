# lib/src/features/collections/advanced/models：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/features/collections/advanced/models` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart TD
	n0["lib/src/features/collections/advanced/models"]
	n1["lib/src/features/feedback"]
	n2["lib/src/foundation"]
	n3["package:flutter"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/features/feedback</code> | import | 1 | [lib/src/features/collections/advanced/models/klp_advanced_models.dart:3](../../../../../../../lib/src/features/collections/advanced/models/klp_advanced_models.dart#L3) |
| <code>lib/src/foundation</code> | import | 1 | [lib/src/features/collections/advanced/models/klp_advanced_models.dart:4](../../../../../../../lib/src/features/collections/advanced/models/klp_advanced_models.dart#L4) |
| <code>package:flutter</code> | import | 1 | [lib/src/features/collections/advanced/models/klp_advanced_models.dart:1](../../../../../../../lib/src/features/collections/advanced/models/klp_advanced_models.dart#L1) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_advanced_models.dart → klp_data_alignment.dart</code> | part | [lib/src/features/collections/advanced/models/klp_advanced_models.dart:6](../../../../../../../lib/src/features/collections/advanced/models/klp_advanced_models.dart#L6) |
| <code>klp_advanced_models.dart → klp_data_column.dart</code> | part | [lib/src/features/collections/advanced/models/klp_advanced_models.dart:7](../../../../../../../lib/src/features/collections/advanced/models/klp_advanced_models.dart#L7) |
| <code>klp_advanced_models.dart → klp_data_column_span.dart</code> | part | [lib/src/features/collections/advanced/models/klp_advanced_models.dart:8](../../../../../../../lib/src/features/collections/advanced/models/klp_advanced_models.dart#L8) |
| <code>klp_advanced_models.dart → klp_data_row.dart</code> | part | [lib/src/features/collections/advanced/models/klp_advanced_models.dart:9](../../../../../../../lib/src/features/collections/advanced/models/klp_advanced_models.dart#L9) |
| <code>klp_advanced_models.dart → klp_data_sort.dart</code> | part | [lib/src/features/collections/advanced/models/klp_advanced_models.dart:10](../../../../../../../lib/src/features/collections/advanced/models/klp_advanced_models.dart#L10) |
| <code>klp_advanced_models.dart → klp_file_preview_size.dart</code> | part | [lib/src/features/collections/advanced/models/klp_advanced_models.dart:11](../../../../../../../lib/src/features/collections/advanced/models/klp_advanced_models.dart#L11) |
| <code>klp_advanced_models.dart → klp_file_preview_state.dart</code> | part | [lib/src/features/collections/advanced/models/klp_advanced_models.dart:12](../../../../../../../lib/src/features/collections/advanced/models/klp_advanced_models.dart#L12) |
| <code>klp_advanced_models.dart → klp_sort_direction.dart</code> | part | [lib/src/features/collections/advanced/models/klp_advanced_models.dart:13](../../../../../../../lib/src/features/collections/advanced/models/klp_advanced_models.dart#L13) |
| <code>klp_advanced_models.dart → klp_tree_node.dart</code> | part | [lib/src/features/collections/advanced/models/klp_advanced_models.dart:14](../../../../../../../lib/src/features/collections/advanced/models/klp_advanced_models.dart#L14) |
| <code>klp_data_alignment.dart → klp_advanced_models.dart</code> | part of | [lib/src/features/collections/advanced/models/klp_data_alignment.dart:1](../../../../../../../lib/src/features/collections/advanced/models/klp_data_alignment.dart#L1) |
| <code>klp_data_column.dart → klp_advanced_models.dart</code> | part of | [lib/src/features/collections/advanced/models/klp_data_column.dart:1](../../../../../../../lib/src/features/collections/advanced/models/klp_data_column.dart#L1) |
| <code>klp_data_column_span.dart → klp_advanced_models.dart</code> | part of | [lib/src/features/collections/advanced/models/klp_data_column_span.dart:1](../../../../../../../lib/src/features/collections/advanced/models/klp_data_column_span.dart#L1) |
| <code>klp_data_row.dart → klp_advanced_models.dart</code> | part of | [lib/src/features/collections/advanced/models/klp_data_row.dart:1](../../../../../../../lib/src/features/collections/advanced/models/klp_data_row.dart#L1) |
| <code>klp_data_sort.dart → klp_advanced_models.dart</code> | part of | [lib/src/features/collections/advanced/models/klp_data_sort.dart:1](../../../../../../../lib/src/features/collections/advanced/models/klp_data_sort.dart#L1) |
| <code>klp_file_preview_size.dart → klp_advanced_models.dart</code> | part of | [lib/src/features/collections/advanced/models/klp_file_preview_size.dart:1](../../../../../../../lib/src/features/collections/advanced/models/klp_file_preview_size.dart#L1) |
| <code>klp_file_preview_state.dart → klp_advanced_models.dart</code> | part of | [lib/src/features/collections/advanced/models/klp_file_preview_state.dart:1](../../../../../../../lib/src/features/collections/advanced/models/klp_file_preview_state.dart#L1) |
| <code>klp_sort_direction.dart → klp_advanced_models.dart</code> | part of | [lib/src/features/collections/advanced/models/klp_sort_direction.dart:1](../../../../../../../lib/src/features/collections/advanced/models/klp_sort_direction.dart#L1) |
| <code>klp_tree_node.dart → klp_advanced_models.dart</code> | part of | [lib/src/features/collections/advanced/models/klp_tree_node.dart:1](../../../../../../../lib/src/features/collections/advanced/models/klp_tree_node.dart#L1) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/features/collections/advanced/models"]
	n1["klp_advanced_models.dart"]
	n2["klp_data_alignment.dart"]
	n3["klp_data_column.dart"]
	n4["klp_data_column_span.dart"]
	n5["klp_data_row.dart"]
	n6["klp_data_sort.dart"]
	n7["klp_file_preview_size.dart"]
	n8["klp_file_preview_state.dart"]
	n9["klp_sort_direction.dart"]
	n10["klp_tree_node.dart"]
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
| `klp_advanced_models.dart` | 無頂層宣告 | [架構與 API](klp_advanced_models.md) | [lib/src/features/collections/advanced/models/klp_advanced_models.dart:1](../../../../../../../lib/src/features/collections/advanced/models/klp_advanced_models.dart#L1) |
| `klp_data_alignment.dart` | KlpDataAlignment | [架構與 API](klp_data_alignment.md) | [lib/src/features/collections/advanced/models/klp_data_alignment.dart:1](../../../../../../../lib/src/features/collections/advanced/models/klp_data_alignment.dart#L1) |
| `klp_data_column.dart` | KlpDataColumn | [架構與 API](klp_data_column.md) | [lib/src/features/collections/advanced/models/klp_data_column.dart:1](../../../../../../../lib/src/features/collections/advanced/models/klp_data_column.dart#L1) |
| `klp_data_column_span.dart` | KlpDataColumnSpan | [架構與 API](klp_data_column_span.md) | [lib/src/features/collections/advanced/models/klp_data_column_span.dart:1](../../../../../../../lib/src/features/collections/advanced/models/klp_data_column_span.dart#L1) |
| `klp_data_row.dart` | KlpDataRow | [架構與 API](klp_data_row.md) | [lib/src/features/collections/advanced/models/klp_data_row.dart:1](../../../../../../../lib/src/features/collections/advanced/models/klp_data_row.dart#L1) |
| `klp_data_sort.dart` | KlpDataSort | [架構與 API](klp_data_sort.md) | [lib/src/features/collections/advanced/models/klp_data_sort.dart:1](../../../../../../../lib/src/features/collections/advanced/models/klp_data_sort.dart#L1) |
| `klp_file_preview_size.dart` | KlpFilePreviewSize | [架構與 API](klp_file_preview_size.md) | [lib/src/features/collections/advanced/models/klp_file_preview_size.dart:1](../../../../../../../lib/src/features/collections/advanced/models/klp_file_preview_size.dart#L1) |
| `klp_file_preview_state.dart` | KlpFilePreviewState | [架構與 API](klp_file_preview_state.md) | [lib/src/features/collections/advanced/models/klp_file_preview_state.dart:1](../../../../../../../lib/src/features/collections/advanced/models/klp_file_preview_state.dart#L1) |
| `klp_sort_direction.dart` | KlpSortDirection | [架構與 API](klp_sort_direction.md) | [lib/src/features/collections/advanced/models/klp_sort_direction.dart:1](../../../../../../../lib/src/features/collections/advanced/models/klp_sort_direction.dart#L1) |
| `klp_tree_node.dart` | KlpTreeNode | [架構與 API](klp_tree_node.md) | [lib/src/features/collections/advanced/models/klp_tree_node.dart:1](../../../../../../../lib/src/features/collections/advanced/models/klp_tree_node.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
