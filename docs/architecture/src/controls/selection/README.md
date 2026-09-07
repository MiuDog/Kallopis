# lib/src/controls/selection：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/controls/selection` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/controls/selection"]
	n1["lib/src/foundation"]
	n2["lib/src/interaction"]
	n3["lib/src/surface"]
	n4["lib/src/theme"]
	n5["lib/src/typography"]
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
| <code>lib/src/foundation</code> | import | 6 | [lib/src/controls/selection/klp_checkbox.dart:3](../../../../../lib/src/controls/selection/klp_checkbox.dart#L3) |
| <code>lib/src/interaction</code> | import | 1 | [lib/src/controls/selection/klp_radio_group.dart:3](../../../../../lib/src/controls/selection/klp_radio_group.dart#L3) |
| <code>lib/src/surface</code> | import | 1 | [lib/src/controls/selection/klp_select.dart:5](../../../../../lib/src/controls/selection/klp_select.dart#L5) |
| <code>lib/src/theme</code> | import | 6 | [lib/src/controls/selection/klp_checkbox.dart:5](../../../../../lib/src/controls/selection/klp_checkbox.dart#L5) |
| <code>lib/src/typography</code> | import | 5 | [lib/src/controls/selection/klp_checkbox.dart:6](../../../../../lib/src/controls/selection/klp_checkbox.dart#L6) |
| <code>package:flutter</code> | import | 6 | [lib/src/controls/selection/klp_checkbox.dart:1](../../../../../lib/src/controls/selection/klp_checkbox.dart#L1) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/controls/selection"]
	n1["klp_checkbox.dart"]
	n2["klp_radio_group.dart"]
	n3["klp_segmented_control.dart"]
	n4["klp_select.dart"]
	n5["klp_slider.dart"]
	n6["klp_sliding_selection.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
	n0 -->|"contains"| n3
	n0 -->|"contains"| n4
	n0 -->|"contains"| n5
	n0 -->|"contains"| n6
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| 無 | 目前沒有下一層目錄 | — |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_checkbox.dart` | KlpCheckbox | [架構與 API](klp_checkbox.md) | [lib/src/controls/selection/klp_checkbox.dart:1](../../../../../lib/src/controls/selection/klp_checkbox.dart#L1) |
| `klp_radio_group.dart` | KlpRadioGroup, _KlpRadioItem | [架構與 API](klp_radio_group.md) | [lib/src/controls/selection/klp_radio_group.dart:1](../../../../../lib/src/controls/selection/klp_radio_group.dart#L1) |
| `klp_segmented_control.dart` | KlpSegmentedControl, _KlpSegment, _KlpSegmentState | [架構與 API](klp_segmented_control.md) | [lib/src/controls/selection/klp_segmented_control.dart:1](../../../../../lib/src/controls/selection/klp_segmented_control.dart#L1) |
| `klp_select.dart` | KlpSelect, _KlpSelectState | [架構與 API](klp_select.md) | [lib/src/controls/selection/klp_select.dart:1](../../../../../lib/src/controls/selection/klp_select.dart#L1) |
| `klp_slider.dart` | KlpSlider | [架構與 API](klp_slider.md) | [lib/src/controls/selection/klp_slider.dart:1](../../../../../lib/src/controls/selection/klp_slider.dart#L1) |
| `klp_sliding_selection.dart` | KlpSelectionOption, KlpSlidingSelection | [架構與 API](klp_sliding_selection.md) | [lib/src/controls/selection/klp_sliding_selection.dart:1](../../../../../lib/src/controls/selection/klp_sliding_selection.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
