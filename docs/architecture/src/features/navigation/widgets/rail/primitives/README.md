# lib/src/features/navigation/widgets/rail/primitives：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/features/navigation/widgets/rail/primitives` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart TD
	n0["lib/src/features/navigation/widgets/rail/primitives"]
	n1["lib/src/features/navigation/widgets/rail"]
	n0 -->|"part of"| n1
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/features/navigation/widgets/rail</code> | part of | 7 | [lib/src/features/navigation/widgets/rail/primitives/klp_rail_badge_indicator.dart:1](../../../../../../../../lib/src/features/navigation/widgets/rail/primitives/klp_rail_badge_indicator.dart#L1) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/features/navigation/widgets/rail/primitives"]
	n1["klp_rail_badge_indicator.dart"]
	n2["klp_rail_draggable_entry.dart"]
	n3["klp_rail_drop_slot.dart"]
	n4["klp_rail_pointer_tracker.dart"]
	n5["klp_rail_scrollable_center.dart"]
	n6["klp_rail_tooltip_anchor.dart"]
	n7["klp_rail_tooltip_anchor_state.dart"]
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
| `klp_rail_badge_indicator.dart` | _KlpRailBadgeIndicator | [架構與 API](klp_rail_badge_indicator.md) | [lib/src/features/navigation/widgets/rail/primitives/klp_rail_badge_indicator.dart:1](../../../../../../../../lib/src/features/navigation/widgets/rail/primitives/klp_rail_badge_indicator.dart#L1) |
| `klp_rail_draggable_entry.dart` | _KlpRailDraggableEntry | [架構與 API](klp_rail_draggable_entry.md) | [lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart:1](../../../../../../../../lib/src/features/navigation/widgets/rail/primitives/klp_rail_draggable_entry.dart#L1) |
| `klp_rail_drop_slot.dart` | _KlpRailDropSlot | [架構與 API](klp_rail_drop_slot.md) | [lib/src/features/navigation/widgets/rail/primitives/klp_rail_drop_slot.dart:1](../../../../../../../../lib/src/features/navigation/widgets/rail/primitives/klp_rail_drop_slot.dart#L1) |
| `klp_rail_pointer_tracker.dart` | _KlpRailPointerTracker | [架構與 API](klp_rail_pointer_tracker.md) | [lib/src/features/navigation/widgets/rail/primitives/klp_rail_pointer_tracker.dart:1](../../../../../../../../lib/src/features/navigation/widgets/rail/primitives/klp_rail_pointer_tracker.dart#L1) |
| `klp_rail_scrollable_center.dart` | _KlpRailScrollableCenter | [架構與 API](klp_rail_scrollable_center.md) | [lib/src/features/navigation/widgets/rail/primitives/klp_rail_scrollable_center.dart:1](../../../../../../../../lib/src/features/navigation/widgets/rail/primitives/klp_rail_scrollable_center.dart#L1) |
| `klp_rail_tooltip_anchor.dart` | _KlpRailTooltipAnchor | [架構與 API](klp_rail_tooltip_anchor.md) | [lib/src/features/navigation/widgets/rail/primitives/klp_rail_tooltip_anchor.dart:1](../../../../../../../../lib/src/features/navigation/widgets/rail/primitives/klp_rail_tooltip_anchor.dart#L1) |
| `klp_rail_tooltip_anchor_state.dart` | _KlpRailTooltipAnchorState | [架構與 API](klp_rail_tooltip_anchor_state.md) | [lib/src/features/navigation/widgets/rail/primitives/klp_rail_tooltip_anchor_state.dart:1](../../../../../../../../lib/src/features/navigation/widgets/rail/primitives/klp_rail_tooltip_anchor_state.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
