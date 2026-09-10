# lib/src/styling/presets/legacy：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/styling/presets/legacy` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart TD
	n0["lib/src/styling/presets/legacy"]
	n1["lib/src/styling/legacy_theme"]
	n0 -->|"part of"| n1
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/styling/legacy_theme</code> | part of | 7 | [lib/src/styling/presets/legacy/default_colors.dart:1](../../../../../../lib/src/styling/presets/legacy/default_colors.dart#L1) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/styling/presets/legacy"]
	n1["default_colors.dart"]
	n2["default_data_visualization.dart"]
	n3["default_motion.dart"]
	n4["default_shape.dart"]
	n5["default_style.dart"]
	n6["default_surface.dart"]
	n7["default_typography.dart"]
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
| `default_colors.dart` | _defaultColorsLight, _defaultColorsDark, _defaultColorsUltraDark, _defaultColorsTransparent | [架構與 API](default_colors.md) | [lib/src/styling/presets/legacy/default_colors.dart:1](../../../../../../lib/src/styling/presets/legacy/default_colors.dart#L1) |
| `default_data_visualization.dart` | _defaultDataVisualizationLight, _defaultDataVisualizationDark, _defaultDataVisualizationUltraDark | [架構與 API](default_data_visualization.md) | [lib/src/styling/presets/legacy/default_data_visualization.dart:1](../../../../../../lib/src/styling/presets/legacy/default_data_visualization.dart#L1) |
| `default_motion.dart` | _defaultMotion | [架構與 API](default_motion.md) | [lib/src/styling/presets/legacy/default_motion.dart:1](../../../../../../lib/src/styling/presets/legacy/default_motion.dart#L1) |
| `default_shape.dart` | _defaultShape | [架構與 API](default_shape.md) | [lib/src/styling/presets/legacy/default_shape.dart:1](../../../../../../lib/src/styling/presets/legacy/default_shape.dart#L1) |
| `default_style.dart` | _defaultStyle | [架構與 API](default_style.md) | [lib/src/styling/presets/legacy/default_style.dart:1](../../../../../../lib/src/styling/presets/legacy/default_style.dart#L1) |
| `default_surface.dart` | _defaultSurface | [架構與 API](default_surface.md) | [lib/src/styling/presets/legacy/default_surface.dart:1](../../../../../../lib/src/styling/presets/legacy/default_surface.dart#L1) |
| `default_typography.dart` | _sans, _mono, _fallback, _monoFallback, _defaultTypography | [架構與 API](default_typography.md) | [lib/src/styling/presets/legacy/default_typography.dart:1](../../../../../../lib/src/styling/presets/legacy/default_typography.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
