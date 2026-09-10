# lib/src/features/workspace/settings：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/features/workspace/settings` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/features/workspace/settings"]
	n1["dart:math"]
	n2["lib/src/features/collections/list_tile"]
	n3["lib/src/features/forms/input"]
	n4["lib/src/features/overlays/primitives"]
	n5["lib/src/features/workspace/settings/layout"]
	n6["lib/src/features/workspace/settings/navigation"]
	n7["lib/src/features/workspace/shell/theme"]
	n8["lib/src/foundation"]
	n9["lib/src/foundation/content"]
	n10["lib/src/foundation/interaction"]
	n11["lib/src/foundation/interaction/controls"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"part"| n5
	n0 -->|"part"| n6
	n0 -->|"import"| n7
	n0 -->|"import"| n8
	n0 -->|"import"| n9
	n0 -->|"import"| n10
	n0 -->|"import"| n11
```

```mermaid
flowchart LR
	n0["lib/src/features/workspace/settings"]
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
| <code>dart:math</code> | import | 1 | [lib/src/features/workspace/settings/klp_settings_layout.dart:1](../../../../../../lib/src/features/workspace/settings/klp_settings_layout.dart#L1) |
| <code>lib/src/features/collections/list_tile</code> | import | 1 | [lib/src/features/workspace/settings/klp_settings_navigation.dart:5](../../../../../../lib/src/features/workspace/settings/klp_settings_navigation.dart#L5) |
| <code>lib/src/features/forms/input</code> | import | 1 | [lib/src/features/workspace/settings/klp_settings_navigation.dart:4](../../../../../../lib/src/features/workspace/settings/klp_settings_navigation.dart#L4) |
| <code>lib/src/features/overlays/primitives</code> | import | 1 | [lib/src/features/workspace/settings/klp_settings_layout.dart:6](../../../../../../lib/src/features/workspace/settings/klp_settings_layout.dart#L6) |
| <code>lib/src/features/workspace/settings/layout</code> | part | 5 | [lib/src/features/workspace/settings/klp_settings_layout.dart:11](../../../../../../lib/src/features/workspace/settings/klp_settings_layout.dart#L11) |
| <code>lib/src/features/workspace/settings/navigation</code> | part | 6 | [lib/src/features/workspace/settings/klp_settings_navigation.dart:14](../../../../../../lib/src/features/workspace/settings/klp_settings_navigation.dart#L14) |
| <code>lib/src/features/workspace/shell/theme</code> | import | 2 | [lib/src/features/workspace/settings/klp_theme_mode_option.dart:3](../../../../../../lib/src/features/workspace/settings/klp_theme_mode_option.dart#L3) |
| <code>lib/src/foundation</code> | import | 2 | [lib/src/features/workspace/settings/klp_settings_navigation.dart:6](../../../../../../lib/src/features/workspace/settings/klp_settings_navigation.dart#L6) |
| <code>lib/src/foundation/content</code> | import | 4 | [lib/src/features/workspace/settings/klp_settings_action_bar.dart:12](../../../../../../lib/src/features/workspace/settings/klp_settings_action_bar.dart#L12) |
| <code>lib/src/foundation/interaction</code> | import | 1 | [lib/src/features/workspace/settings/klp_settings_navigation.dart:8](../../../../../../lib/src/features/workspace/settings/klp_settings_navigation.dart#L8) |
| <code>lib/src/foundation/interaction/controls</code> | import | 1 | [lib/src/features/workspace/settings/klp_settings_navigation.dart:3](../../../../../../lib/src/features/workspace/settings/klp_settings_navigation.dart#L3) |
| <code>lib/src/foundation/layout</code> | import | 14 | [lib/src/features/workspace/settings/klp_settings_action_bar.dart:3](../../../../../../lib/src/features/workspace/settings/klp_settings_action_bar.dart#L3) |
| <code>lib/src/foundation/surface</code> | import | 4 | [lib/src/features/workspace/settings/klp_settings_action_bar.dart:10](../../../../../../lib/src/features/workspace/settings/klp_settings_action_bar.dart#L10) |
| <code>lib/src/styling/legacy_theme</code> | import | 4 | [lib/src/features/workspace/settings/klp_settings_action_bar.dart:11](../../../../../../lib/src/features/workspace/settings/klp_settings_action_bar.dart#L11) |
| <code>package:flutter</code> | import | 6 | [lib/src/features/workspace/settings/klp_settings_action_bar.dart:1](../../../../../../lib/src/features/workspace/settings/klp_settings_action_bar.dart#L1) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_settings_content.dart → klp_settings_action_bar.dart</code> | export | [lib/src/features/workspace/settings/klp_settings_content.dart:10](../../../../../../lib/src/features/workspace/settings/klp_settings_content.dart#L10) |
| <code>klp_theme_mode_picker.dart → klp_theme_mode_option.dart</code> | import | [lib/src/features/workspace/settings/klp_theme_mode_picker.dart:6](../../../../../../lib/src/features/workspace/settings/klp_theme_mode_picker.dart#L6) |
| <code>klp_theme_mode_picker.dart → klp_theme_mode_option.dart</code> | export | [lib/src/features/workspace/settings/klp_theme_mode_picker.dart:8](../../../../../../lib/src/features/workspace/settings/klp_theme_mode_picker.dart#L8) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/features/workspace/settings"]
	n1["internal/"]
	n2["layout/"]
	n3["navigation/"]
	n4["klp_settings_action_bar.dart"]
	n5["klp_settings_content.dart"]
	n6["klp_settings_layout.dart"]
	n7["klp_settings_navigation.dart"]
	n8["klp_theme_mode_option.dart"]
	n9["klp_theme_mode_picker.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
	n0 -->|"contains"| n3
	n0 -->|"contains"| n4
	n0 -->|"contains"| n5
	n0 -->|"contains"| n6
	n0 -->|"contains"| n7
	n0 -->|"contains"| n8
	n0 -->|"contains"| n9
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| `internal/` | [架構入口](internal/README.md) | [來源目錄](../../../../../../lib/src/features/workspace/settings/internal) |
| `layout/` | [架構入口](layout/README.md) | [來源目錄](../../../../../../lib/src/features/workspace/settings/layout) |
| `navigation/` | [架構入口](navigation/README.md) | [來源目錄](../../../../../../lib/src/features/workspace/settings/navigation) |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_settings_action_bar.dart` | KlpSettingsActionBar | [架構與 API](klp_settings_action_bar.md) | [lib/src/features/workspace/settings/klp_settings_action_bar.dart:1](../../../../../../lib/src/features/workspace/settings/klp_settings_action_bar.dart#L1) |
| `klp_settings_content.dart` | KlpSettingsField | [架構與 API](klp_settings_content.md) | [lib/src/features/workspace/settings/klp_settings_content.dart:1](../../../../../../lib/src/features/workspace/settings/klp_settings_content.dart#L1) |
| `klp_settings_layout.dart` | 無頂層宣告 | [架構與 API](klp_settings_layout.md) | [lib/src/features/workspace/settings/klp_settings_layout.dart:1](../../../../../../lib/src/features/workspace/settings/klp_settings_layout.dart#L1) |
| `klp_settings_navigation.dart` | 無頂層宣告 | [架構與 API](klp_settings_navigation.md) | [lib/src/features/workspace/settings/klp_settings_navigation.dart:1](../../../../../../lib/src/features/workspace/settings/klp_settings_navigation.dart#L1) |
| `klp_theme_mode_option.dart` | KlpThemeModeOption | [架構與 API](klp_theme_mode_option.md) | [lib/src/features/workspace/settings/klp_theme_mode_option.dart:1](../../../../../../lib/src/features/workspace/settings/klp_theme_mode_option.dart#L1) |
| `klp_theme_mode_picker.dart` | KlpThemeModePicker | [架構與 API](klp_theme_mode_picker.md) | [lib/src/features/workspace/settings/klp_theme_mode_picker.dart:1](../../../../../../lib/src/features/workspace/settings/klp_theme_mode_picker.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
