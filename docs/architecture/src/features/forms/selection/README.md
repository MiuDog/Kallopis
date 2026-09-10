# lib/src/features/forms/selection：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/features/forms/selection` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/features/forms/selection"]
	n1["lib/src/features/forms/internal"]
	n2["lib/src/features/forms/internal/primitives"]
	n3["lib/src/features/forms/selection/internal"]
	n4["lib/src/features/forms/selection/models"]
	n5["lib/src/features/forms/selection/models"]
	n6["lib/src/features/forms/selection/models"]
	n7["lib/src/features/forms/selection/primitives"]
	n8["lib/src/foundation"]
	n9["lib/src/foundation/content"]
	n10["lib/src/foundation/interaction"]
	n11["lib/src/foundation/interaction/primitives"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"part"| n3
	n0 -->|"export"| n4
	n0 -->|"import"| n5
	n0 -->|"part"| n6
	n0 -->|"part"| n7
	n0 -->|"import"| n8
	n0 -->|"import"| n9
	n0 -->|"import"| n10
	n0 -->|"import"| n11
```

```mermaid
flowchart LR
	n0["lib/src/features/forms/selection"]
	n1["lib/src/foundation/layout"]
	n2["lib/src/foundation/surface"]
	n3["lib/src/styling/legacy_theme"]
	n4["package:flutter"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/features/forms/internal</code> | import | 12 | [lib/src/features/forms/selection/klp_calendar.dart:1](../../../../../../lib/src/features/forms/selection/klp_calendar.dart#L1) |
| <code>lib/src/features/forms/internal/primitives</code> | import | 3 | [lib/src/features/forms/selection/klp_date_range_field.dart:3](../../../../../../lib/src/features/forms/selection/klp_date_range_field.dart#L3) |
| <code>lib/src/features/forms/selection/internal</code> | part | 25 | [lib/src/features/forms/selection/klp_calendar.dart:4](../../../../../../lib/src/features/forms/selection/klp_calendar.dart#L4) |
| <code>lib/src/features/forms/selection/models</code> | export | 1 | [lib/src/features/forms/selection/klp_status_role_swatches.dart:4](../../../../../../lib/src/features/forms/selection/klp_status_role_swatches.dart#L4) |
| <code>lib/src/features/forms/selection/models</code> | import | 1 | [lib/src/features/forms/selection/klp_status_role_swatches.dart:2](../../../../../../lib/src/features/forms/selection/klp_status_role_swatches.dart#L2) |
| <code>lib/src/features/forms/selection/models</code> | part | 2 | [lib/src/features/forms/selection/klp_calendar.dart:7](../../../../../../lib/src/features/forms/selection/klp_calendar.dart#L7) |
| <code>lib/src/features/forms/selection/primitives</code> | part | 16 | [lib/src/features/forms/selection/klp_calendar.dart:9](../../../../../../lib/src/features/forms/selection/klp_calendar.dart#L9) |
| <code>lib/src/foundation</code> | import | 7 | [lib/src/features/forms/selection/klp_checkbox.dart:3](../../../../../../lib/src/features/forms/selection/klp_checkbox.dart#L3) |
| <code>lib/src/foundation/content</code> | import | 5 | [lib/src/features/forms/selection/klp_checkbox.dart:7](../../../../../../lib/src/features/forms/selection/klp_checkbox.dart#L7) |
| <code>lib/src/foundation/interaction</code> | import | 1 | [lib/src/features/forms/selection/klp_radio_group.dart:3](../../../../../../lib/src/features/forms/selection/klp_radio_group.dart#L3) |
| <code>lib/src/foundation/interaction/primitives</code> | import | 1 | [lib/src/features/forms/selection/klp_date_field.dart:2](../../../../../../lib/src/features/forms/selection/klp_date_field.dart#L2) |
| <code>lib/src/foundation/layout</code> | import | 6 | [lib/src/features/forms/selection/klp_calendar.dart:2](../../../../../../lib/src/features/forms/selection/klp_calendar.dart#L2) |
| <code>lib/src/foundation/surface</code> | import | 1 | [lib/src/features/forms/selection/klp_select.dart:6](../../../../../../lib/src/features/forms/selection/klp_select.dart#L6) |
| <code>lib/src/styling/legacy_theme</code> | import | 6 | [lib/src/features/forms/selection/klp_checkbox.dart:6](../../../../../../lib/src/features/forms/selection/klp_checkbox.dart#L6) |
| <code>package:flutter</code> | import | 7 | [lib/src/features/forms/selection/klp_checkbox.dart:1](../../../../../../lib/src/features/forms/selection/klp_checkbox.dart#L1) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_color_role_field.dart → klp_choice_option.dart</code> | import | [lib/src/features/forms/selection/klp_color_role_field.dart:2](../../../../../../lib/src/features/forms/selection/klp_color_role_field.dart#L2) |
| <code>klp_color_role_field.dart → klp_select_field.dart</code> | import | [lib/src/features/forms/selection/klp_color_role_field.dart:3](../../../../../../lib/src/features/forms/selection/klp_color_role_field.dart#L3) |
| <code>klp_date_field.dart → klp_calendar.dart</code> | import | [lib/src/features/forms/selection/klp_date_field.dart:3](../../../../../../lib/src/features/forms/selection/klp_date_field.dart#L3) |
| <code>klp_date_field.dart → klp_date_field_calendar.dart</code> | import | [lib/src/features/forms/selection/klp_date_field.dart:4](../../../../../../lib/src/features/forms/selection/klp_date_field.dart#L4) |
| <code>klp_date_field_calendar.dart → klp_calendar.dart</code> | import | [lib/src/features/forms/selection/klp_date_field_calendar.dart:2](../../../../../../lib/src/features/forms/selection/klp_date_field_calendar.dart#L2) |
| <code>klp_date_field_calendar.dart → klp_date_field.dart</code> | import | [lib/src/features/forms/selection/klp_date_field_calendar.dart:3](../../../../../../lib/src/features/forms/selection/klp_date_field_calendar.dart#L3) |
| <code>klp_multi_select_field.dart → klp_choice_option.dart</code> | import | [lib/src/features/forms/selection/klp_multi_select_field.dart:2](../../../../../../lib/src/features/forms/selection/klp_multi_select_field.dart#L2) |
| <code>klp_select_field.dart → klp_choice_option.dart</code> | import | [lib/src/features/forms/selection/klp_select_field.dart:2](../../../../../../lib/src/features/forms/selection/klp_select_field.dart#L2) |
| <code>klp_selection_option.dart → klp_selection_tone.dart</code> | import | [lib/src/features/forms/selection/klp_selection_option.dart:4](../../../../../../lib/src/features/forms/selection/klp_selection_option.dart#L4) |
| <code>klp_sliding_selection.dart → klp_selection_option.dart</code> | import | [lib/src/features/forms/selection/klp_sliding_selection.dart:5](../../../../../../lib/src/features/forms/selection/klp_sliding_selection.dart#L5) |
| <code>klp_sliding_selection.dart → klp_selection_tone.dart</code> | import | [lib/src/features/forms/selection/klp_sliding_selection.dart:6](../../../../../../lib/src/features/forms/selection/klp_sliding_selection.dart#L6) |
| <code>klp_sliding_selection.dart → klp_selection_option.dart</code> | export | [lib/src/features/forms/selection/klp_sliding_selection.dart:8](../../../../../../lib/src/features/forms/selection/klp_sliding_selection.dart#L8) |
| <code>klp_sliding_selection.dart → klp_selection_tone.dart</code> | export | [lib/src/features/forms/selection/klp_sliding_selection.dart:9](../../../../../../lib/src/features/forms/selection/klp_sliding_selection.dart#L9) |
| <code>klp_tag_input_field.dart → klp_tag_chip.dart</code> | import | [lib/src/features/forms/selection/klp_tag_input_field.dart:2](../../../../../../lib/src/features/forms/selection/klp_tag_input_field.dart#L2) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/features/forms/selection"]
	n1["internal/"]
	n2["models/"]
	n3["primitives/"]
	n4["klp_calendar.dart"]
	n5["klp_checkbox.dart"]
	n6["klp_choice_option.dart"]
	n7["klp_color_role_field.dart"]
	n8["klp_date_field.dart"]
	n9["klp_date_field_calendar.dart"]
	n10["klp_date_range_field.dart"]
	n11["klp_multi_select_field.dart"]
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

```mermaid
flowchart LR
	n0["lib/src/features/forms/selection"]
	n1["klp_radio_group.dart"]
	n2["klp_segmented_control.dart"]
	n3["klp_select.dart"]
	n4["klp_select_field.dart"]
	n5["klp_selection_option.dart"]
	n6["klp_selection_tone.dart"]
	n7["klp_slider.dart"]
	n8["klp_sliding_selection.dart"]
	n9["klp_status_role_swatches.dart"]
	n10["klp_tag_chip.dart"]
	n11["klp_tag_input_field.dart"]
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
| `internal/` | [架構入口](internal/README.md) | [來源目錄](../../../../../../lib/src/features/forms/selection/internal) |
| `models/` | [架構入口](models/README.md) | [來源目錄](../../../../../../lib/src/features/forms/selection/models) |
| `primitives/` | [架構入口](primitives/README.md) | [來源目錄](../../../../../../lib/src/features/forms/selection/primitives) |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_calendar.dart` | 無頂層宣告 | [架構與 API](klp_calendar.md) | [lib/src/features/forms/selection/klp_calendar.dart:1](../../../../../../lib/src/features/forms/selection/klp_calendar.dart#L1) |
| `klp_checkbox.dart` | 無頂層宣告 | [架構與 API](klp_checkbox.md) | [lib/src/features/forms/selection/klp_checkbox.dart:1](../../../../../../lib/src/features/forms/selection/klp_checkbox.dart#L1) |
| `klp_choice_option.dart` | KlpChoiceOption | [架構與 API](klp_choice_option.md) | [lib/src/features/forms/selection/klp_choice_option.dart:1](../../../../../../lib/src/features/forms/selection/klp_choice_option.dart#L1) |
| `klp_color_role_field.dart` | KlpColorRoleField | [架構與 API](klp_color_role_field.md) | [lib/src/features/forms/selection/klp_color_role_field.dart:1](../../../../../../lib/src/features/forms/selection/klp_color_role_field.dart#L1) |
| `klp_date_field.dart` | KlpDateField | [架構與 API](klp_date_field.md) | [lib/src/features/forms/selection/klp_date_field.dart:1](../../../../../../lib/src/features/forms/selection/klp_date_field.dart#L1) |
| `klp_date_field_calendar.dart` | KlpDateFieldCalendar | [架構與 API](klp_date_field_calendar.md) | [lib/src/features/forms/selection/klp_date_field_calendar.dart:1](../../../../../../lib/src/features/forms/selection/klp_date_field_calendar.dart#L1) |
| `klp_date_range_field.dart` | KlpDateRangeField | [架構與 API](klp_date_range_field.md) | [lib/src/features/forms/selection/klp_date_range_field.dart:1](../../../../../../lib/src/features/forms/selection/klp_date_range_field.dart#L1) |
| `klp_multi_select_field.dart` | KlpMultiSelectField | [架構與 API](klp_multi_select_field.md) | [lib/src/features/forms/selection/klp_multi_select_field.dart:1](../../../../../../lib/src/features/forms/selection/klp_multi_select_field.dart#L1) |
| `klp_radio_group.dart` | 無頂層宣告 | [架構與 API](klp_radio_group.md) | [lib/src/features/forms/selection/klp_radio_group.dart:1](../../../../../../lib/src/features/forms/selection/klp_radio_group.dart#L1) |
| `klp_segmented_control.dart` | 無頂層宣告 | [架構與 API](klp_segmented_control.md) | [lib/src/features/forms/selection/klp_segmented_control.dart:1](../../../../../../lib/src/features/forms/selection/klp_segmented_control.dart#L1) |
| `klp_select.dart` | 無頂層宣告 | [架構與 API](klp_select.md) | [lib/src/features/forms/selection/klp_select.dart:1](../../../../../../lib/src/features/forms/selection/klp_select.dart#L1) |
| `klp_select_field.dart` | 無頂層宣告 | [架構與 API](klp_select_field.md) | [lib/src/features/forms/selection/klp_select_field.dart:1](../../../../../../lib/src/features/forms/selection/klp_select_field.dart#L1) |
| `klp_selection_option.dart` | KlpSelectionOption | [架構與 API](klp_selection_option.md) | [lib/src/features/forms/selection/klp_selection_option.dart:1](../../../../../../lib/src/features/forms/selection/klp_selection_option.dart#L1) |
| `klp_selection_tone.dart` | KlpSelectionTone | [架構與 API](klp_selection_tone.md) | [lib/src/features/forms/selection/klp_selection_tone.dart:1](../../../../../../lib/src/features/forms/selection/klp_selection_tone.dart#L1) |
| `klp_slider.dart` | 無頂層宣告 | [架構與 API](klp_slider.md) | [lib/src/features/forms/selection/klp_slider.dart:1](../../../../../../lib/src/features/forms/selection/klp_slider.dart#L1) |
| `klp_sliding_selection.dart` | 無頂層宣告 | [架構與 API](klp_sliding_selection.md) | [lib/src/features/forms/selection/klp_sliding_selection.dart:1](../../../../../../lib/src/features/forms/selection/klp_sliding_selection.dart#L1) |
| `klp_status_role_swatches.dart` | KlpStatusRoleSwatches | [架構與 API](klp_status_role_swatches.md) | [lib/src/features/forms/selection/klp_status_role_swatches.dart:1](../../../../../../lib/src/features/forms/selection/klp_status_role_swatches.dart#L1) |
| `klp_tag_chip.dart` | KlpTagChip | [架構與 API](klp_tag_chip.md) | [lib/src/features/forms/selection/klp_tag_chip.dart:1](../../../../../../lib/src/features/forms/selection/klp_tag_chip.dart#L1) |
| `klp_tag_input_field.dart` | KlpTagInputField | [架構與 API](klp_tag_input_field.md) | [lib/src/features/forms/selection/klp_tag_input_field.dart:1](../../../../../../lib/src/features/forms/selection/klp_tag_input_field.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
