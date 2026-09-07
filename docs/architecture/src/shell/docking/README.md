# lib/src/shell/docking：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/shell/docking` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/shell/docking"]
	n1["lib/src/controls/button"]
	n2["lib/src/foundation"]
	n3["lib/src/interaction"]
	n4["lib/src/l10n"]
	n5["lib/src/overlay"]
	n6["lib/src/shell/docking/internal"]
	n7["lib/src/shell/panel"]
	n8["lib/src/theme"]
	n9["lib/src/typography"]
	n10["package:flutter"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"part"| n6
	n0 -->|"import"| n7
	n0 -->|"import"| n8
	n0 -->|"import"| n9
	n0 -->|"import"| n10
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/controls/button</code> | import | 1 | [lib/src/shell/docking/klp_dock_header.dart:4](../../../../../lib/src/shell/docking/klp_dock_header.dart#L4) |
| <code>lib/src/foundation</code> | import | 2 | [lib/src/shell/docking/klp_dock_header.dart:5](../../../../../lib/src/shell/docking/klp_dock_header.dart#L5) |
| <code>lib/src/interaction</code> | import | 1 | [lib/src/shell/docking/klp_dock_layout.dart:3](../../../../../lib/src/shell/docking/klp_dock_layout.dart#L3) |
| <code>lib/src/l10n</code> | import | 1 | [lib/src/shell/docking/klp_dock_header.dart:6](../../../../../lib/src/shell/docking/klp_dock_header.dart#L6) |
| <code>lib/src/overlay</code> | import | 2 | [lib/src/shell/docking/klp_dock_header.dart:7](../../../../../lib/src/shell/docking/klp_dock_header.dart#L7) |
| <code>lib/src/shell/docking/internal</code> | part | 2 | [lib/src/shell/docking/klp_dock_layout.dart:12](../../../../../lib/src/shell/docking/klp_dock_layout.dart#L12) |
| <code>lib/src/shell/panel</code> | import | 3 | [lib/src/shell/docking/klp_dock_header.dart:11](../../../../../lib/src/shell/docking/klp_dock_header.dart#L11) |
| <code>lib/src/theme</code> | import | 2 | [lib/src/shell/docking/klp_dock_header.dart:9](../../../../../lib/src/shell/docking/klp_dock_header.dart#L9) |
| <code>lib/src/typography</code> | import | 1 | [lib/src/shell/docking/klp_dock_layout.dart:5](../../../../../lib/src/shell/docking/klp_dock_layout.dart#L5) |
| <code>package:flutter</code> | import | 5 | [lib/src/shell/docking/klp_dock_header.dart:1](../../../../../lib/src/shell/docking/klp_dock_header.dart#L1) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_dock_header.dart → klp_dock_panel.dart</code> | import | [lib/src/shell/docking/klp_dock_header.dart:10](../../../../../lib/src/shell/docking/klp_dock_header.dart#L10) |
| <code>klp_dock_layout.dart → klp_dock_header.dart</code> | import | [lib/src/shell/docking/klp_dock_layout.dart:8](../../../../../lib/src/shell/docking/klp_dock_layout.dart#L8) |
| <code>klp_dock_layout.dart → klp_dock_layout_models.dart</code> | import | [lib/src/shell/docking/klp_dock_layout.dart:9](../../../../../lib/src/shell/docking/klp_dock_layout.dart#L9) |
| <code>klp_dock_layout.dart → klp_dock_panel.dart</code> | import | [lib/src/shell/docking/klp_dock_layout.dart:10](../../../../../lib/src/shell/docking/klp_dock_layout.dart#L10) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/shell/docking"]
	n1["internal/"]
	n2["klp_dock_header.dart"]
	n3["klp_dock_layout.dart"]
	n4["klp_dock_layout_models.dart"]
	n5["klp_dock_panel.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
	n0 -->|"contains"| n3
	n0 -->|"contains"| n4
	n0 -->|"contains"| n5
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| `internal/` | [架構入口](internal/README.md) | [來源目錄](../../../../../lib/src/shell/docking/internal) |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_dock_header.dart` | KlpDockHeaderDragRegionBuilder, KlpDockHeader, _KlpDockHeaderState | [架構與 API](klp_dock_header.md) | [lib/src/shell/docking/klp_dock_header.dart:1](../../../../../lib/src/shell/docking/klp_dock_header.dart#L1) |
| `klp_dock_layout.dart` | KlpDockLayout, _KlpDockLayoutState, _KlpDockAreaSlot, _KlpDockDropPlacement, _KlpDockPanelDragData | [架構與 API](klp_dock_layout.md) | [lib/src/shell/docking/klp_dock_layout.dart:1](../../../../../lib/src/shell/docking/klp_dock_layout.dart#L1) |
| `klp_dock_layout_models.dart` | KlpDockLayoutData, KlpDockAreaData, KlpDockAreaConstraints, KlpDockGroupData | [架構與 API](klp_dock_layout_models.md) | [lib/src/shell/docking/klp_dock_layout_models.dart:1](../../../../../lib/src/shell/docking/klp_dock_layout_models.dart#L1) |
| `klp_dock_panel.dart` | KlpDockHeaderAction, KlpDockPanel | [架構與 API](klp_dock_panel.md) | [lib/src/shell/docking/klp_dock_panel.dart:1](../../../../../lib/src/shell/docking/klp_dock_panel.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
