# lib/src/navigation/rail：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/navigation/rail` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/navigation/rail"]
	n1["lib/src/foundation"]
	n2["lib/src/interaction"]
	n3["lib/src/overlay"]
	n4["lib/src/surface"]
	n5["lib/src/theme"]
	n6["package:flutter"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/foundation</code> | import | 3 | [lib/src/navigation/rail/klp_rail_button_entry.dart:3](../../../../../lib/src/navigation/rail/klp_rail_button_entry.dart#L3) |
| <code>lib/src/interaction</code> | import | 1 | [lib/src/navigation/rail/klp_navigation_rail.dart:3](../../../../../lib/src/navigation/rail/klp_navigation_rail.dart#L3) |
| <code>lib/src/overlay</code> | import | 3 | [lib/src/navigation/rail/klp_rail_item.dart:4](../../../../../lib/src/navigation/rail/klp_rail_item.dart#L4) |
| <code>lib/src/surface</code> | import | 1 | [lib/src/navigation/rail/klp_rail_divider.dart:3](../../../../../lib/src/navigation/rail/klp_rail_divider.dart#L3) |
| <code>lib/src/theme</code> | import | 2 | [lib/src/navigation/rail/klp_navigation_rail.dart:4](../../../../../lib/src/navigation/rail/klp_navigation_rail.dart#L4) |
| <code>package:flutter</code> | import | 7 | [lib/src/navigation/rail/klp_navigation_rail.dart:1](../../../../../lib/src/navigation/rail/klp_navigation_rail.dart#L1) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_navigation_rail.dart → klp_rail_divider.dart</code> | import | [lib/src/navigation/rail/klp_navigation_rail.dart:5](../../../../../lib/src/navigation/rail/klp_navigation_rail.dart#L5) |
| <code>klp_navigation_rail.dart → klp_rail_entry.dart</code> | import | [lib/src/navigation/rail/klp_navigation_rail.dart:6](../../../../../lib/src/navigation/rail/klp_navigation_rail.dart#L6) |
| <code>klp_navigation_rail.dart → klp_rail_item_group.dart</code> | import | [lib/src/navigation/rail/klp_navigation_rail.dart:7](../../../../../lib/src/navigation/rail/klp_navigation_rail.dart#L7) |
| <code>klp_rail_button_entry.dart → klp_rail_entry.dart</code> | import | [lib/src/navigation/rail/klp_rail_button_entry.dart:4](../../../../../lib/src/navigation/rail/klp_rail_button_entry.dart#L4) |
| <code>klp_rail_button_entry.dart → klp_rail_item.dart</code> | import | [lib/src/navigation/rail/klp_rail_button_entry.dart:5](../../../../../lib/src/navigation/rail/klp_rail_button_entry.dart#L5) |
| <code>klp_rail_divider.dart → klp_rail_entry.dart</code> | import | [lib/src/navigation/rail/klp_rail_divider.dart:4](../../../../../lib/src/navigation/rail/klp_rail_divider.dart#L4) |
| <code>klp_rail_item_group.dart → klp_rail_entry.dart</code> | import | [lib/src/navigation/rail/klp_rail_item_group.dart:3](../../../../../lib/src/navigation/rail/klp_rail_item_group.dart#L3) |
| <code>klp_rail_menu_entry.dart → klp_rail_entry.dart</code> | import | [lib/src/navigation/rail/klp_rail_menu_entry.dart:6](../../../../../lib/src/navigation/rail/klp_rail_menu_entry.dart#L6) |
| <code>klp_rail_menu_entry.dart → klp_rail_item.dart</code> | import | [lib/src/navigation/rail/klp_rail_menu_entry.dart:7](../../../../../lib/src/navigation/rail/klp_rail_menu_entry.dart#L7) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/navigation/rail"]
	n1["klp_navigation_rail.dart"]
	n2["klp_rail_button_entry.dart"]
	n3["klp_rail_divider.dart"]
	n4["klp_rail_entry.dart"]
	n5["klp_rail_item.dart"]
	n6["klp_rail_item_group.dart"]
	n7["klp_rail_menu_entry.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
	n0 -->|"contains"| n3
	n0 -->|"contains"| n4
	n0 -->|"contains"| n5
	n0 -->|"contains"| n6
	n0 -->|"contains"| n7
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| 無 | 目前沒有下一層目錄 | — |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_navigation_rail.dart` | KlpNavigationRail, _KlpRailGroupSlot, _KlpRailDragData, _KlpNavigationRailState | [架構與 API](klp_navigation_rail.md) | [lib/src/navigation/rail/klp_navigation_rail.dart:1](../../../../../lib/src/navigation/rail/klp_navigation_rail.dart#L1) |
| `klp_rail_button_entry.dart` | KlpRailButtonEntry | [架構與 API](klp_rail_button_entry.md) | [lib/src/navigation/rail/klp_rail_button_entry.dart:1](../../../../../lib/src/navigation/rail/klp_rail_button_entry.dart#L1) |
| `klp_rail_divider.dart` | KlpRailDivider | [架構與 API](klp_rail_divider.md) | [lib/src/navigation/rail/klp_rail_divider.dart:1](../../../../../lib/src/navigation/rail/klp_rail_divider.dart#L1) |
| `klp_rail_entry.dart` | KlpRailEntry | [架構與 API](klp_rail_entry.md) | [lib/src/navigation/rail/klp_rail_entry.dart:1](../../../../../lib/src/navigation/rail/klp_rail_entry.dart#L1) |
| `klp_rail_item.dart` | KlpRailItem, _KlpRailItemState | [架構與 API](klp_rail_item.md) | [lib/src/navigation/rail/klp_rail_item.dart:1](../../../../../lib/src/navigation/rail/klp_rail_item.dart#L1) |
| `klp_rail_item_group.dart` | KlpRailGroupReorderCallback, KlpRailItemGroup | [架構與 API](klp_rail_item_group.md) | [lib/src/navigation/rail/klp_rail_item_group.dart:1](../../../../../lib/src/navigation/rail/klp_rail_item_group.dart#L1) |
| `klp_rail_menu_entry.dart` | KlpRailMenuEntry, _KlpRailMenuEntryView, _KlpRailMenuEntryViewState | [架構與 API](klp_rail_menu_entry.md) | [lib/src/navigation/rail/klp_rail_menu_entry.dart:1](../../../../../lib/src/navigation/rail/klp_rail_menu_entry.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
