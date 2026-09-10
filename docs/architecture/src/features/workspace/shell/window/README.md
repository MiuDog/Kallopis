# lib/src/features/workspace/shell/window：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/features/workspace/shell/window` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/features/workspace/shell/window"]
	n1["lib/src/application/localization"]
	n2["lib/src/features/actions/button"]
	n3["lib/src/features/workspace/shell/internal"]
	n4["lib/src/features/workspace/shell/window/internal"]
	n5["lib/src/foundation"]
	n6["lib/src/foundation/content"]
	n7["lib/src/foundation/interaction"]
	n8["lib/src/foundation/layout"]
	n9["lib/src/foundation/platform"]
	n10["lib/src/foundation/surface"]
	n11["lib/src/styling/legacy_theme"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
	n0 -->|"import"| n8
	n0 -->|"import"| n9
	n0 -->|"import"| n10
	n0 -->|"import"| n11
```

```mermaid
flowchart TD
	n0["lib/src/features/workspace/shell/window"]
	n1["package:flutter"]
	n0 -->|"import"| n1
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/application/localization</code> | import | 1 | [lib/src/features/workspace/shell/window/klp_window_controls.dart:4](../../../../../../../lib/src/features/workspace/shell/window/klp_window_controls.dart#L4) |
| <code>lib/src/features/actions/button</code> | import | 1 | [lib/src/features/workspace/shell/window/klp_workbench_window_header.dart:3](../../../../../../../lib/src/features/workspace/shell/window/klp_workbench_window_header.dart#L3) |
| <code>lib/src/features/workspace/shell/internal</code> | import | 2 | [lib/src/features/workspace/shell/window/klp_window_header_strategy.dart:7](../../../../../../../lib/src/features/workspace/shell/window/klp_window_header_strategy.dart#L7) |
| <code>lib/src/features/workspace/shell/window/internal</code> | import | 1 | [lib/src/features/workspace/shell/window/klp_window_controls.dart:8](../../../../../../../lib/src/features/workspace/shell/window/klp_window_controls.dart#L8) |
| <code>lib/src/foundation</code> | import | 2 | [lib/src/features/workspace/shell/window/klp_window_controls.dart:3](../../../../../../../lib/src/features/workspace/shell/window/klp_window_controls.dart#L3) |
| <code>lib/src/foundation/content</code> | import | 2 | [lib/src/features/workspace/shell/window/klp_window_header.dart:10](../../../../../../../lib/src/features/workspace/shell/window/klp_window_header.dart#L10) |
| <code>lib/src/foundation/interaction</code> | import | 3 | [lib/src/features/workspace/shell/window/klp_window_header.dart:4](../../../../../../../lib/src/features/workspace/shell/window/klp_window_header.dart#L4) |
| <code>lib/src/foundation/layout</code> | import | 35 | [lib/src/features/workspace/shell/window/klp_window_app_icon.dart:6](../../../../../../../lib/src/features/workspace/shell/window/klp_window_app_icon.dart#L6) |
| <code>lib/src/foundation/platform</code> | import | 1 | [lib/src/features/workspace/shell/window/klp_window_header.dart:3](../../../../../../../lib/src/features/workspace/shell/window/klp_window_header.dart#L3) |
| <code>lib/src/foundation/surface</code> | import | 1 | [lib/src/features/workspace/shell/window/klp_window_header.dart:7](../../../../../../../lib/src/features/workspace/shell/window/klp_window_header.dart#L7) |
| <code>lib/src/styling/legacy_theme</code> | import | 9 | [lib/src/features/workspace/shell/window/klp_window_controls.dart:7](../../../../../../../lib/src/features/workspace/shell/window/klp_window_controls.dart#L7) |
| <code>package:flutter</code> | import | 8 | [lib/src/features/workspace/shell/window/klp_window_action.dart:1](../../../../../../../lib/src/features/workspace/shell/window/klp_window_action.dart#L1) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_window_controls.dart → klp_window_controls_geometry.dart</code> | import | [lib/src/features/workspace/shell/window/klp_window_controls.dart:9](../../../../../../../lib/src/features/workspace/shell/window/klp_window_controls.dart#L9) |
| <code>klp_window_controls.dart → klp_window_controls_style.dart</code> | import | [lib/src/features/workspace/shell/window/klp_window_controls.dart:10](../../../../../../../lib/src/features/workspace/shell/window/klp_window_controls.dart#L10) |
| <code>klp_window_header.dart → klp_window_action.dart</code> | import | [lib/src/features/workspace/shell/window/klp_window_header.dart:11](../../../../../../../lib/src/features/workspace/shell/window/klp_window_header.dart#L11) |
| <code>klp_window_header.dart → klp_window_header_height.dart</code> | import | [lib/src/features/workspace/shell/window/klp_window_header.dart:12](../../../../../../../lib/src/features/workspace/shell/window/klp_window_header.dart#L12) |
| <code>klp_window_header.dart → klp_window_header_keys.dart</code> | import | [lib/src/features/workspace/shell/window/klp_window_header.dart:13](../../../../../../../lib/src/features/workspace/shell/window/klp_window_header.dart#L13) |
| <code>klp_window_header.dart → klp_window_header_strategy.dart</code> | import | [lib/src/features/workspace/shell/window/klp_window_header.dart:14](../../../../../../../lib/src/features/workspace/shell/window/klp_window_header.dart#L14) |
| <code>klp_window_header_mac_layout.dart → klp_window_action.dart</code> | import | [lib/src/features/workspace/shell/window/klp_window_header_mac_layout.dart:11](../../../../../../../lib/src/features/workspace/shell/window/klp_window_header_mac_layout.dart#L11) |
| <code>klp_window_header_strategy.dart → klp_window_app_icon.dart</code> | import | [lib/src/features/workspace/shell/window/klp_window_header_strategy.dart:8](../../../../../../../lib/src/features/workspace/shell/window/klp_window_header_strategy.dart#L8) |
| <code>klp_window_header_strategy.dart → klp_window_controls.dart</code> | import | [lib/src/features/workspace/shell/window/klp_window_header_strategy.dart:9](../../../../../../../lib/src/features/workspace/shell/window/klp_window_header_strategy.dart#L9) |
| <code>klp_window_header_strategy.dart → klp_window_controls_style.dart</code> | import | [lib/src/features/workspace/shell/window/klp_window_header_strategy.dart:10](../../../../../../../lib/src/features/workspace/shell/window/klp_window_header_strategy.dart#L10) |
| <code>klp_window_header_strategy.dart → klp_window_controls_geometry.dart</code> | import | [lib/src/features/workspace/shell/window/klp_window_header_strategy.dart:11](../../../../../../../lib/src/features/workspace/shell/window/klp_window_header_strategy.dart#L11) |
| <code>klp_window_header_strategy.dart → klp_window_header_mac_layout.dart</code> | import | [lib/src/features/workspace/shell/window/klp_window_header_strategy.dart:12](../../../../../../../lib/src/features/workspace/shell/window/klp_window_header_strategy.dart#L12) |
| <code>klp_window_header_strategy.dart → klp_window_header_windows_layout.dart</code> | import | [lib/src/features/workspace/shell/window/klp_window_header_strategy.dart:13](../../../../../../../lib/src/features/workspace/shell/window/klp_window_header_strategy.dart#L13) |
| <code>klp_window_header_windows_layout.dart → klp_window_action.dart</code> | import | [lib/src/features/workspace/shell/window/klp_window_header_windows_layout.dart:12](../../../../../../../lib/src/features/workspace/shell/window/klp_window_header_windows_layout.dart#L12) |
| <code>klp_window_header_windows_layout.dart → klp_window_header_keys.dart</code> | import | [lib/src/features/workspace/shell/window/klp_window_header_windows_layout.dart:13](../../../../../../../lib/src/features/workspace/shell/window/klp_window_header_windows_layout.dart#L13) |
| <code>klp_workbench_window_header.dart → klp_window_header.dart</code> | import | [lib/src/features/workspace/shell/window/klp_workbench_window_header.dart:20](../../../../../../../lib/src/features/workspace/shell/window/klp_workbench_window_header.dart#L20) |
| <code>klp_workbench_window_header.dart → klp_window_header_height.dart</code> | import | [lib/src/features/workspace/shell/window/klp_workbench_window_header.dart:21](../../../../../../../lib/src/features/workspace/shell/window/klp_workbench_window_header.dart#L21) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/features/workspace/shell/window"]
	n1["internal/"]
	n2["klp_window_action.dart"]
	n3["klp_window_app_icon.dart"]
	n4["klp_window_controls.dart"]
	n5["klp_window_controls_geometry.dart"]
	n6["klp_window_controls_style.dart"]
	n7["klp_window_header.dart"]
	n8["klp_window_header_height.dart"]
	n9["klp_window_header_keys.dart"]
	n10["klp_window_header_mac_layout.dart"]
	n11["klp_window_header_strategy.dart"]
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
flowchart TD
	n0["lib/src/features/workspace/shell/window"]
	n1["klp_window_header_windows_layout.dart"]
	n2["klp_workbench_window_header.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| `internal/` | [架構入口](internal/README.md) | [來源目錄](../../../../../../../lib/src/features/workspace/shell/window/internal) |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_window_action.dart` | KlpWindowAction | [架構與 API](klp_window_action.md) | [lib/src/features/workspace/shell/window/klp_window_action.dart:1](../../../../../../../lib/src/features/workspace/shell/window/klp_window_action.dart#L1) |
| `klp_window_app_icon.dart` | KlpWindowAppIcon | [架構與 API](klp_window_app_icon.md) | [lib/src/features/workspace/shell/window/klp_window_app_icon.dart:1](../../../../../../../lib/src/features/workspace/shell/window/klp_window_app_icon.dart#L1) |
| `klp_window_controls.dart` | KlpWindowControls | [架構與 API](klp_window_controls.md) | [lib/src/features/workspace/shell/window/klp_window_controls.dart:1](../../../../../../../lib/src/features/workspace/shell/window/klp_window_controls.dart#L1) |
| `klp_window_controls_geometry.dart` | KlpWindowControlsGeometry | [架構與 API](klp_window_controls_geometry.md) | [lib/src/features/workspace/shell/window/klp_window_controls_geometry.dart:1](../../../../../../../lib/src/features/workspace/shell/window/klp_window_controls_geometry.dart#L1) |
| `klp_window_controls_style.dart` | KlpWindowControlsStyle | [架構與 API](klp_window_controls_style.md) | [lib/src/features/workspace/shell/window/klp_window_controls_style.dart:1](../../../../../../../lib/src/features/workspace/shell/window/klp_window_controls_style.dart#L1) |
| `klp_window_header.dart` | KlpWindowHeader | [架構與 API](klp_window_header.md) | [lib/src/features/workspace/shell/window/klp_window_header.dart:1](../../../../../../../lib/src/features/workspace/shell/window/klp_window_header.dart#L1) |
| `klp_window_header_height.dart` | klpWindowHeaderHeight | [架構與 API](klp_window_header_height.md) | [lib/src/features/workspace/shell/window/klp_window_header_height.dart:1](../../../../../../../lib/src/features/workspace/shell/window/klp_window_header_height.dart#L1) |
| `klp_window_header_keys.dart` | KlpWindowHeaderKeys | [架構與 API](klp_window_header_keys.md) | [lib/src/features/workspace/shell/window/klp_window_header_keys.dart:1](../../../../../../../lib/src/features/workspace/shell/window/klp_window_header_keys.dart#L1) |
| `klp_window_header_mac_layout.dart` | KlpWindowHeaderMacLayout | [架構與 API](klp_window_header_mac_layout.md) | [lib/src/features/workspace/shell/window/klp_window_header_mac_layout.dart:1](../../../../../../../lib/src/features/workspace/shell/window/klp_window_header_mac_layout.dart#L1) |
| `klp_window_header_strategy.dart` | KlpWindowHeaderStrategy | [架構與 API](klp_window_header_strategy.md) | [lib/src/features/workspace/shell/window/klp_window_header_strategy.dart:1](../../../../../../../lib/src/features/workspace/shell/window/klp_window_header_strategy.dart#L1) |
| `klp_window_header_windows_layout.dart` | KlpWindowHeaderWindowsLayout | [架構與 API](klp_window_header_windows_layout.md) | [lib/src/features/workspace/shell/window/klp_window_header_windows_layout.dart:1](../../../../../../../lib/src/features/workspace/shell/window/klp_window_header_windows_layout.dart#L1) |
| `klp_workbench_window_header.dart` | KlpWorkbenchWindowHeader | [架構與 API](klp_workbench_window_header.md) | [lib/src/features/workspace/shell/window/klp_workbench_window_header.dart:1](../../../../../../../lib/src/features/workspace/shell/window/klp_workbench_window_header.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
