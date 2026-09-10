# lib/src/features/navigation/widgets/rail：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/features/navigation/widgets/rail` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/features/navigation/widgets/rail"]
	n1["lib/src/features/navigation/widgets/rail/internal"]
	n2["lib/src/features/navigation/widgets/rail/models"]
	n3["lib/src/features/navigation/widgets/rail/primitives"]
	n4["lib/src/features/overlays"]
	n5["lib/src/foundation"]
	n6["lib/src/foundation/interaction"]
	n7["lib/src/foundation/layout"]
	n8["lib/src/foundation/surface"]
	n9["lib/src/styling/legacy_theme"]
	n10["package:flutter"]
	n0 -->|"part"| n1
	n0 -->|"part"| n2
	n0 -->|"part"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
	n0 -->|"import"| n8
	n0 -->|"import"| n9
	n0 -->|"import"| n10
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/features/navigation/widgets/rail/internal</code> | part | 8 | [lib/src/features/navigation/widgets/rail/klp_navigation_rail.dart:9](../../../../../../../lib/src/features/navigation/widgets/rail/klp_navigation_rail.dart#L9) |
| <code>lib/src/features/navigation/widgets/rail/models</code> | part | 3 | [lib/src/features/navigation/widgets/rail/klp_navigation_rail.dart:14](../../../../../../../lib/src/features/navigation/widgets/rail/klp_navigation_rail.dart#L14) |
| <code>lib/src/features/navigation/widgets/rail/primitives</code> | part | 7 | [lib/src/features/navigation/widgets/rail/klp_navigation_rail.dart:16](../../../../../../../lib/src/features/navigation/widgets/rail/klp_navigation_rail.dart#L16) |
| <code>lib/src/features/overlays</code> | import | 3 | [lib/src/features/navigation/widgets/rail/klp_rail_item.dart:8](../../../../../../../lib/src/features/navigation/widgets/rail/klp_rail_item.dart#L8) |
| <code>lib/src/foundation</code> | import | 3 | [lib/src/features/navigation/widgets/rail/klp_rail_button_entry.dart:3](../../../../../../../lib/src/features/navigation/widgets/rail/klp_rail_button_entry.dart#L3) |
| <code>lib/src/foundation/interaction</code> | import | 3 | [lib/src/features/navigation/widgets/rail/klp_navigation_rail.dart:3](../../../../../../../lib/src/features/navigation/widgets/rail/klp_navigation_rail.dart#L3) |
| <code>lib/src/foundation/layout</code> | import | 2 | [lib/src/features/navigation/widgets/rail/klp_navigation_rail.dart:4](../../../../../../../lib/src/features/navigation/widgets/rail/klp_navigation_rail.dart#L4) |
| <code>lib/src/foundation/surface</code> | import | 1 | [lib/src/features/navigation/widgets/rail/klp_rail_divider.dart:3](../../../../../../../lib/src/features/navigation/widgets/rail/klp_rail_divider.dart#L3) |
| <code>lib/src/styling/legacy_theme</code> | import | 2 | [lib/src/features/navigation/widgets/rail/klp_navigation_rail.dart:5](../../../../../../../lib/src/features/navigation/widgets/rail/klp_navigation_rail.dart#L5) |
| <code>package:flutter</code> | import | 8 | [lib/src/features/navigation/widgets/rail/klp_navigation_rail.dart:1](../../../../../../../lib/src/features/navigation/widgets/rail/klp_navigation_rail.dart#L1) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_navigation_rail.dart → klp_rail_divider.dart</code> | import | [lib/src/features/navigation/widgets/rail/klp_navigation_rail.dart:6](../../../../../../../lib/src/features/navigation/widgets/rail/klp_navigation_rail.dart#L6) |
| <code>klp_navigation_rail.dart → klp_rail_item_group.dart</code> | import | [lib/src/features/navigation/widgets/rail/klp_navigation_rail.dart:7](../../../../../../../lib/src/features/navigation/widgets/rail/klp_navigation_rail.dart#L7) |
| <code>klp_rail_button_entry.dart → klp_rail_entry.dart</code> | import | [lib/src/features/navigation/widgets/rail/klp_rail_button_entry.dart:4](../../../../../../../lib/src/features/navigation/widgets/rail/klp_rail_button_entry.dart#L4) |
| <code>klp_rail_button_entry.dart → klp_rail_item.dart</code> | import | [lib/src/features/navigation/widgets/rail/klp_rail_button_entry.dart:5](../../../../../../../lib/src/features/navigation/widgets/rail/klp_rail_button_entry.dart#L5) |
| <code>klp_rail_divider.dart → klp_rail_entry.dart</code> | import | [lib/src/features/navigation/widgets/rail/klp_rail_divider.dart:4](../../../../../../../lib/src/features/navigation/widgets/rail/klp_rail_divider.dart#L4) |
| <code>klp_rail_item_group.dart → klp_rail_entry.dart</code> | import | [lib/src/features/navigation/widgets/rail/klp_rail_item_group.dart:3](../../../../../../../lib/src/features/navigation/widgets/rail/klp_rail_item_group.dart#L3) |
| <code>klp_rail_item_group.dart → klp_rail_group_reorder_callback.dart</code> | import | [lib/src/features/navigation/widgets/rail/klp_rail_item_group.dart:4](../../../../../../../lib/src/features/navigation/widgets/rail/klp_rail_item_group.dart#L4) |
| <code>klp_rail_item_group.dart → klp_rail_group_reorder_callback.dart</code> | export | [lib/src/features/navigation/widgets/rail/klp_rail_item_group.dart:6](../../../../../../../lib/src/features/navigation/widgets/rail/klp_rail_item_group.dart#L6) |
| <code>klp_rail_menu_entry.dart → klp_rail_entry.dart</code> | import | [lib/src/features/navigation/widgets/rail/klp_rail_menu_entry.dart:6](../../../../../../../lib/src/features/navigation/widgets/rail/klp_rail_menu_entry.dart#L6) |
| <code>klp_rail_menu_entry.dart → klp_rail_item.dart</code> | import | [lib/src/features/navigation/widgets/rail/klp_rail_menu_entry.dart:7](../../../../../../../lib/src/features/navigation/widgets/rail/klp_rail_menu_entry.dart#L7) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/features/navigation/widgets/rail"]
	n1["internal/"]
	n2["models/"]
	n3["primitives/"]
	n4["klp_navigation_rail.dart"]
	n5["klp_rail_button_entry.dart"]
	n6["klp_rail_divider.dart"]
	n7["klp_rail_entry.dart"]
	n8["klp_rail_group_reorder_callback.dart"]
	n9["klp_rail_item.dart"]
	n10["klp_rail_item_group.dart"]
	n11["klp_rail_menu_entry.dart"]
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
	n0 -->|"contains"| n11
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| `internal/` | [架構入口](internal/README.md) | [來源目錄](../../../../../../../lib/src/features/navigation/widgets/rail/internal) |
| `models/` | [架構入口](models/README.md) | [來源目錄](../../../../../../../lib/src/features/navigation/widgets/rail/models) |
| `primitives/` | [架構入口](primitives/README.md) | [來源目錄](../../../../../../../lib/src/features/navigation/widgets/rail/primitives) |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_navigation_rail.dart` | 無頂層宣告 | [架構與 API](klp_navigation_rail.md) | [lib/src/features/navigation/widgets/rail/klp_navigation_rail.dart:1](../../../../../../../lib/src/features/navigation/widgets/rail/klp_navigation_rail.dart#L1) |
| `klp_rail_button_entry.dart` | KlpRailButtonEntry | [架構與 API](klp_rail_button_entry.md) | [lib/src/features/navigation/widgets/rail/klp_rail_button_entry.dart:1](../../../../../../../lib/src/features/navigation/widgets/rail/klp_rail_button_entry.dart#L1) |
| `klp_rail_divider.dart` | KlpRailDivider | [架構與 API](klp_rail_divider.md) | [lib/src/features/navigation/widgets/rail/klp_rail_divider.dart:1](../../../../../../../lib/src/features/navigation/widgets/rail/klp_rail_divider.dart#L1) |
| `klp_rail_entry.dart` | KlpRailEntry | [架構與 API](klp_rail_entry.md) | [lib/src/features/navigation/widgets/rail/klp_rail_entry.dart:1](../../../../../../../lib/src/features/navigation/widgets/rail/klp_rail_entry.dart#L1) |
| `klp_rail_group_reorder_callback.dart` | KlpRailGroupReorderCallback | [架構與 API](klp_rail_group_reorder_callback.md) | [lib/src/features/navigation/widgets/rail/klp_rail_group_reorder_callback.dart:1](../../../../../../../lib/src/features/navigation/widgets/rail/klp_rail_group_reorder_callback.dart#L1) |
| `klp_rail_item.dart` | 無頂層宣告 | [架構與 API](klp_rail_item.md) | [lib/src/features/navigation/widgets/rail/klp_rail_item.dart:1](../../../../../../../lib/src/features/navigation/widgets/rail/klp_rail_item.dart#L1) |
| `klp_rail_item_group.dart` | KlpRailItemGroup | [架構與 API](klp_rail_item_group.md) | [lib/src/features/navigation/widgets/rail/klp_rail_item_group.dart:1](../../../../../../../lib/src/features/navigation/widgets/rail/klp_rail_item_group.dart#L1) |
| `klp_rail_menu_entry.dart` | 無頂層宣告 | [架構與 API](klp_rail_menu_entry.md) | [lib/src/features/navigation/widgets/rail/klp_rail_menu_entry.dart:1](../../../../../../../lib/src/features/navigation/widgets/rail/klp_rail_menu_entry.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
