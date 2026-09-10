# lib/src/features/workspace/shell/composition/pane：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/features/workspace/shell/composition/pane` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/features/workspace/shell/composition/pane"]
	n1["lib/src/application/localization"]
	n2["lib/src/features/workspace/shell/composition/pane/primitives"]
	n3["lib/src/foundation"]
	n4["lib/src/foundation/interaction"]
	n5["lib/src/foundation/layout"]
	n6["lib/src/styling/legacy_theme"]
	n7["package:flutter"]
	n0 -->|"import"| n1
	n0 -->|"part"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/application/localization</code> | import | 1 | [lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart:7](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart#L7) |
| <code>lib/src/features/workspace/shell/composition/pane/primitives</code> | part | 1 | [lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart:10](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart#L10) |
| <code>lib/src/foundation</code> | import | 2 | [lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart:3](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart#L3) |
| <code>lib/src/foundation/interaction</code> | import | 2 | [lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart:5](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart#L5) |
| <code>lib/src/foundation/layout</code> | import | 1 | [lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart:3](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart#L3) |
| <code>lib/src/styling/legacy_theme</code> | import | 2 | [lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart:8](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart#L8) |
| <code>package:flutter</code> | import | 3 | [lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart:1](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart#L1) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_pane_components.dart → klp_content_state.dart</code> | export | [lib/src/features/workspace/shell/composition/pane/klp_pane_components.dart:1](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_components.dart#L1) |
| <code>klp_pane_components.dart → klp_pane_collapse_control.dart</code> | export | [lib/src/features/workspace/shell/composition/pane/klp_pane_components.dart:2](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_components.dart#L2) |
| <code>klp_pane_components.dart → klp_responsive_pane_breakpoint.dart</code> | export | [lib/src/features/workspace/shell/composition/pane/klp_pane_components.dart:3](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_components.dart#L3) |
| <code>klp_pane_components.dart → klp_responsive_pane_coordinator.dart</code> | export | [lib/src/features/workspace/shell/composition/pane/klp_pane_components.dart:4](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_components.dart#L4) |
| <code>klp_responsive_pane_coordinator.dart → klp_responsive_pane_breakpoint.dart</code> | import | [lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart:4](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart#L4) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/features/workspace/shell/composition/pane"]
	n1["primitives/"]
	n2["klp_content_state.dart"]
	n3["klp_pane_collapse_control.dart"]
	n4["klp_pane_components.dart"]
	n5["klp_responsive_pane_breakpoint.dart"]
	n6["klp_responsive_pane_coordinator.dart"]
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
| `primitives/` | [架構入口](primitives/README.md) | [來源目錄](../../../../../../../../lib/src/features/workspace/shell/composition/pane/primitives) |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_content_state.dart` | KlpContentState | [架構與 API](klp_content_state.md) | [lib/src/features/workspace/shell/composition/pane/klp_content_state.dart:1](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_content_state.dart#L1) |
| `klp_pane_collapse_control.dart` | KlpPaneCollapseControl | [架構與 API](klp_pane_collapse_control.md) | [lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart:1](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart#L1) |
| `klp_pane_components.dart` | 無頂層宣告 | [架構與 API](klp_pane_components.md) | [lib/src/features/workspace/shell/composition/pane/klp_pane_components.dart:1](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_pane_components.dart#L1) |
| `klp_responsive_pane_breakpoint.dart` | KlpResponsivePaneBreakpoint | [架構與 API](klp_responsive_pane_breakpoint.md) | [lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_breakpoint.dart:1](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_breakpoint.dart#L1) |
| `klp_responsive_pane_coordinator.dart` | KlpResponsivePaneCoordinator | [架構與 API](klp_responsive_pane_coordinator.md) | [lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart:1](../../../../../../../../lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
