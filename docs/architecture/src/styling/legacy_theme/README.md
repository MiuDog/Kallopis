# lib/src/styling/legacy_theme：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/styling/legacy_theme` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/styling/legacy_theme"]
	n1["lib/src/foundation"]
	n2["lib/src/styling/legacy_theme/internal"]
	n3["lib/src/styling/legacy_tokens"]
	n4["lib/src/styling/presets/legacy"]
	n5["package:flutter"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"part"| n4
	n0 -->|"import"| n5
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/foundation</code> | import | 2 | [lib/src/styling/legacy_theme/klp_geometry_theme.dart:3](../../../../../lib/src/styling/legacy_theme/klp_geometry_theme.dart#L3) |
| <code>lib/src/styling/legacy_theme/internal</code> | import | 12 | [lib/src/styling/legacy_theme/klp_visual_style_json.dart:2](../../../../../lib/src/styling/legacy_theme/klp_visual_style_json.dart#L2) |
| <code>lib/src/styling/legacy_tokens</code> | import | 11 | [lib/src/styling/legacy_theme/klp_control_geometry.dart:3](../../../../../lib/src/styling/legacy_theme/klp_control_geometry.dart#L3) |
| <code>lib/src/styling/presets/legacy</code> | part | 7 | [lib/src/styling/legacy_theme/klp_data_visualization_theme.dart:5](../../../../../lib/src/styling/legacy_theme/klp_data_visualization_theme.dart#L5) |
| <code>package:flutter</code> | import | 17 | [lib/src/styling/legacy_theme/klp_component_theme.dart:1](../../../../../lib/src/styling/legacy_theme/klp_component_theme.dart#L1) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_component_theme.dart → klp_control_geometry.dart</code> | import | [lib/src/styling/legacy_theme/klp_component_theme.dart:3](../../../../../lib/src/styling/legacy_theme/klp_component_theme.dart#L3) |
| <code>klp_component_theme.dart → klp_geometry_theme.dart</code> | import | [lib/src/styling/legacy_theme/klp_component_theme.dart:4](../../../../../lib/src/styling/legacy_theme/klp_component_theme.dart#L4) |
| <code>klp_component_theme.dart → klp_shape_theme.dart</code> | import | [lib/src/styling/legacy_theme/klp_component_theme.dart:5](../../../../../lib/src/styling/legacy_theme/klp_component_theme.dart#L5) |
| <code>klp_component_theme.dart → klp_spacing_theme.dart</code> | import | [lib/src/styling/legacy_theme/klp_component_theme.dart:6](../../../../../lib/src/styling/legacy_theme/klp_component_theme.dart#L6) |
| <code>klp_component_theme.dart → klp_surface_theme.dart</code> | import | [lib/src/styling/legacy_theme/klp_component_theme.dart:7](../../../../../lib/src/styling/legacy_theme/klp_component_theme.dart#L7) |
| <code>klp_geometry_theme.dart → klp_control_geometry.dart</code> | import | [lib/src/styling/legacy_theme/klp_geometry_theme.dart:5](../../../../../lib/src/styling/legacy_theme/klp_geometry_theme.dart#L5) |
| <code>klp_geometry_theme.dart → klp_data_geometry.dart</code> | import | [lib/src/styling/legacy_theme/klp_geometry_theme.dart:6](../../../../../lib/src/styling/legacy_theme/klp_geometry_theme.dart#L6) |
| <code>klp_geometry_theme.dart → klp_layout_geometry.dart</code> | import | [lib/src/styling/legacy_theme/klp_geometry_theme.dart:7](../../../../../lib/src/styling/legacy_theme/klp_geometry_theme.dart#L7) |
| <code>klp_geometry_theme.dart → klp_optical_geometry.dart</code> | import | [lib/src/styling/legacy_theme/klp_geometry_theme.dart:8](../../../../../lib/src/styling/legacy_theme/klp_geometry_theme.dart#L8) |
| <code>klp_theme.dart → klp_data_visualization_theme.dart</code> | import | [lib/src/styling/legacy_theme/klp_theme.dart:3](../../../../../lib/src/styling/legacy_theme/klp_theme.dart#L3) |
| <code>klp_theme.dart → klp_shape_theme.dart</code> | import | [lib/src/styling/legacy_theme/klp_theme.dart:4](../../../../../lib/src/styling/legacy_theme/klp_theme.dart#L4) |
| <code>klp_theme.dart → klp_surface_theme.dart</code> | import | [lib/src/styling/legacy_theme/klp_theme.dart:5](../../../../../lib/src/styling/legacy_theme/klp_theme.dart#L5) |
| <code>klp_theme.dart → klp_visual_style.dart</code> | import | [lib/src/styling/legacy_theme/klp_theme.dart:6](../../../../../lib/src/styling/legacy_theme/klp_theme.dart#L6) |
| <code>klp_theme.dart → klp_theme_data.dart</code> | import | [lib/src/styling/legacy_theme/klp_theme.dart:7](../../../../../lib/src/styling/legacy_theme/klp_theme.dart#L7) |
| <code>klp_theme.dart → klp_theme_data.dart</code> | export | [lib/src/styling/legacy_theme/klp_theme.dart:12](../../../../../lib/src/styling/legacy_theme/klp_theme.dart#L12) |
| <code>klp_theme.dart → klp_theme_scope.dart</code> | export | [lib/src/styling/legacy_theme/klp_theme.dart:13](../../../../../lib/src/styling/legacy_theme/klp_theme.dart#L13) |
| <code>klp_theme_data.dart → klp_surface_theme.dart</code> | import | [lib/src/styling/legacy_theme/klp_theme_data.dart:4](../../../../../lib/src/styling/legacy_theme/klp_theme_data.dart#L4) |
| <code>klp_theme_scope.dart → klp_component_theme.dart</code> | import | [lib/src/styling/legacy_theme/klp_theme_scope.dart:3](../../../../../lib/src/styling/legacy_theme/klp_theme_scope.dart#L3) |
| <code>klp_theme_scope.dart → klp_data_visualization_theme.dart</code> | import | [lib/src/styling/legacy_theme/klp_theme_scope.dart:4](../../../../../lib/src/styling/legacy_theme/klp_theme_scope.dart#L4) |
| <code>klp_theme_scope.dart → klp_geometry_theme.dart</code> | import | [lib/src/styling/legacy_theme/klp_theme_scope.dart:5](../../../../../lib/src/styling/legacy_theme/klp_theme_scope.dart#L5) |
| <code>klp_theme_scope.dart → klp_motion_theme.dart</code> | import | [lib/src/styling/legacy_theme/klp_theme_scope.dart:6](../../../../../lib/src/styling/legacy_theme/klp_theme_scope.dart#L6) |
| <code>klp_theme_scope.dart → klp_shape_theme.dart</code> | import | [lib/src/styling/legacy_theme/klp_theme_scope.dart:7](../../../../../lib/src/styling/legacy_theme/klp_theme_scope.dart#L7) |
| <code>klp_theme_scope.dart → klp_spacing_theme.dart</code> | import | [lib/src/styling/legacy_theme/klp_theme_scope.dart:8](../../../../../lib/src/styling/legacy_theme/klp_theme_scope.dart#L8) |
| <code>klp_theme_scope.dart → klp_surface_theme.dart</code> | import | [lib/src/styling/legacy_theme/klp_theme_scope.dart:9](../../../../../lib/src/styling/legacy_theme/klp_theme_scope.dart#L9) |
| <code>klp_theme_scope.dart → klp_theme_data.dart</code> | import | [lib/src/styling/legacy_theme/klp_theme_scope.dart:10](../../../../../lib/src/styling/legacy_theme/klp_theme_scope.dart#L10) |
| <code>klp_theme_scope.dart → klp_typography_theme.dart</code> | import | [lib/src/styling/legacy_theme/klp_theme_scope.dart:11](../../../../../lib/src/styling/legacy_theme/klp_theme_scope.dart#L11) |
| <code>klp_theme_scope.dart → klp_visual_style.dart</code> | import | [lib/src/styling/legacy_theme/klp_theme_scope.dart:12](../../../../../lib/src/styling/legacy_theme/klp_theme_scope.dart#L12) |
| <code>klp_visual_style.dart → klp_component_theme.dart</code> | import | [lib/src/styling/legacy_theme/klp_visual_style.dart:3](../../../../../lib/src/styling/legacy_theme/klp_visual_style.dart#L3) |
| <code>klp_visual_style.dart → klp_data_visualization_theme.dart</code> | import | [lib/src/styling/legacy_theme/klp_visual_style.dart:4](../../../../../lib/src/styling/legacy_theme/klp_visual_style.dart#L4) |
| <code>klp_visual_style.dart → klp_geometry_theme.dart</code> | import | [lib/src/styling/legacy_theme/klp_visual_style.dart:5](../../../../../lib/src/styling/legacy_theme/klp_visual_style.dart#L5) |
| <code>klp_visual_style.dart → klp_motion_theme.dart</code> | import | [lib/src/styling/legacy_theme/klp_visual_style.dart:6](../../../../../lib/src/styling/legacy_theme/klp_visual_style.dart#L6) |
| <code>klp_visual_style.dart → klp_shape_theme.dart</code> | import | [lib/src/styling/legacy_theme/klp_visual_style.dart:7](../../../../../lib/src/styling/legacy_theme/klp_visual_style.dart#L7) |
| <code>klp_visual_style.dart → klp_spacing_theme.dart</code> | import | [lib/src/styling/legacy_theme/klp_visual_style.dart:8](../../../../../lib/src/styling/legacy_theme/klp_visual_style.dart#L8) |
| <code>klp_visual_style.dart → klp_surface_theme.dart</code> | import | [lib/src/styling/legacy_theme/klp_visual_style.dart:9](../../../../../lib/src/styling/legacy_theme/klp_visual_style.dart#L9) |
| <code>klp_visual_style.dart → klp_theme_data.dart</code> | import | [lib/src/styling/legacy_theme/klp_visual_style.dart:10](../../../../../lib/src/styling/legacy_theme/klp_visual_style.dart#L10) |
| <code>klp_visual_style.dart → klp_typography_theme.dart</code> | import | [lib/src/styling/legacy_theme/klp_visual_style.dart:11](../../../../../lib/src/styling/legacy_theme/klp_visual_style.dart#L11) |
| <code>klp_visual_style_json.dart → klp_visual_style.dart</code> | import | [lib/src/styling/legacy_theme/klp_visual_style_json.dart:1](../../../../../lib/src/styling/legacy_theme/klp_visual_style_json.dart#L1) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/styling/legacy_theme"]
	n1["internal/"]
	n2["klp_component_theme.dart"]
	n3["klp_control_geometry.dart"]
	n4["klp_data_geometry.dart"]
	n5["klp_data_visualization_theme.dart"]
	n6["klp_geometry_theme.dart"]
	n7["klp_layout_geometry.dart"]
	n8["klp_motion_theme.dart"]
	n9["klp_optical_geometry.dart"]
	n10["klp_shape_theme.dart"]
	n11["klp_spacing_theme.dart"]
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
	n0["lib/src/styling/legacy_theme"]
	n1["klp_surface_theme.dart"]
	n2["klp_theme.dart"]
	n3["klp_theme_data.dart"]
	n4["klp_theme_scope.dart"]
	n5["klp_typography_theme.dart"]
	n6["klp_visual_style.dart"]
	n7["klp_visual_style_json.dart"]
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
| `internal/` | [架構入口](internal/README.md) | [來源目錄](../../../../../lib/src/styling/legacy_theme/internal) |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_component_theme.dart` | KlpComponentTheme | [架構與 API](klp_component_theme.md) | [lib/src/styling/legacy_theme/klp_component_theme.dart:1](../../../../../lib/src/styling/legacy_theme/klp_component_theme.dart#L1) |
| `klp_control_geometry.dart` | KlpControlGeometry | [架構與 API](klp_control_geometry.md) | [lib/src/styling/legacy_theme/klp_control_geometry.dart:1](../../../../../lib/src/styling/legacy_theme/klp_control_geometry.dart#L1) |
| `klp_data_geometry.dart` | KlpDataGeometry | [架構與 API](klp_data_geometry.md) | [lib/src/styling/legacy_theme/klp_data_geometry.dart:1](../../../../../lib/src/styling/legacy_theme/klp_data_geometry.dart#L1) |
| `klp_data_visualization_theme.dart` | KlpDataVisualizationTheme, KlpDataVisualizationThemeContext | [架構與 API](klp_data_visualization_theme.md) | [lib/src/styling/legacy_theme/klp_data_visualization_theme.dart:1](../../../../../lib/src/styling/legacy_theme/klp_data_visualization_theme.dart#L1) |
| `klp_geometry_theme.dart` | KlpGeometryTheme | [架構與 API](klp_geometry_theme.md) | [lib/src/styling/legacy_theme/klp_geometry_theme.dart:1](../../../../../lib/src/styling/legacy_theme/klp_geometry_theme.dart#L1) |
| `klp_layout_geometry.dart` | KlpLayoutGeometry | [架構與 API](klp_layout_geometry.md) | [lib/src/styling/legacy_theme/klp_layout_geometry.dart:1](../../../../../lib/src/styling/legacy_theme/klp_layout_geometry.dart#L1) |
| `klp_motion_theme.dart` | KlpMotionTheme | [架構與 API](klp_motion_theme.md) | [lib/src/styling/legacy_theme/klp_motion_theme.dart:1](../../../../../lib/src/styling/legacy_theme/klp_motion_theme.dart#L1) |
| `klp_optical_geometry.dart` | KlpOpticalGeometry | [架構與 API](klp_optical_geometry.md) | [lib/src/styling/legacy_theme/klp_optical_geometry.dart:1](../../../../../lib/src/styling/legacy_theme/klp_optical_geometry.dart#L1) |
| `klp_shape_theme.dart` | KlpShapeTheme | [架構與 API](klp_shape_theme.md) | [lib/src/styling/legacy_theme/klp_shape_theme.dart:1](../../../../../lib/src/styling/legacy_theme/klp_shape_theme.dart#L1) |
| `klp_spacing_theme.dart` | KlpSpacingTheme | [架構與 API](klp_spacing_theme.md) | [lib/src/styling/legacy_theme/klp_spacing_theme.dart:1](../../../../../lib/src/styling/legacy_theme/klp_spacing_theme.dart#L1) |
| `klp_surface_theme.dart` | KlpSurfaceSeparation, KlpSurfaceTheme | [架構與 API](klp_surface_theme.md) | [lib/src/styling/legacy_theme/klp_surface_theme.dart:1](../../../../../lib/src/styling/legacy_theme/klp_surface_theme.dart#L1) |
| `klp_theme.dart` | KlpThemeVariant, KlpFieldFillState, KlpFieldStyle, buildKlpTheme, buildKlpThemeVariant, _buildKlpThemeData | [架構與 API](klp_theme.md) | [lib/src/styling/legacy_theme/klp_theme.dart:1](../../../../../lib/src/styling/legacy_theme/klp_theme.dart#L1) |
| `klp_theme_data.dart` | KlpThemeContrast, KlpThemeData | [架構與 API](klp_theme_data.md) | [lib/src/styling/legacy_theme/klp_theme_data.dart:1](../../../../../lib/src/styling/legacy_theme/klp_theme_data.dart#L1) |
| `klp_theme_scope.dart` | KlpTheme, KlpTokenOverride, KlpThemeContext | [架構與 API](klp_theme_scope.md) | [lib/src/styling/legacy_theme/klp_theme_scope.dart:1](../../../../../lib/src/styling/legacy_theme/klp_theme_scope.dart#L1) |
| `klp_typography_theme.dart` | KlpTypographyTheme | [架構與 API](klp_typography_theme.md) | [lib/src/styling/legacy_theme/klp_typography_theme.dart:1](../../../../../lib/src/styling/legacy_theme/klp_typography_theme.dart#L1) |
| `klp_visual_style.dart` | KlpVisualStyle | [架構與 API](klp_visual_style.md) | [lib/src/styling/legacy_theme/klp_visual_style.dart:1](../../../../../lib/src/styling/legacy_theme/klp_visual_style.dart#L1) |
| `klp_visual_style_json.dart` | KlpVisualStyleJson | [架構與 API](klp_visual_style_json.md) | [lib/src/styling/legacy_theme/klp_visual_style_json.dart:1](../../../../../lib/src/styling/legacy_theme/klp_visual_style_json.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
