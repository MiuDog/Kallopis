# lib/src/features/workspace/shell/docking：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/features/workspace/shell/docking` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/features/workspace/shell/docking"]
	n1["lib/src/application/localization"]
	n2["lib/src/features/actions/button"]
	n3["lib/src/features/overlays"]
	n4["lib/src/features/workspace/shell/docking/internal"]
	n5["lib/src/features/workspace/shell/docking/models"]
	n6["lib/src/features/workspace/shell/docking/primitives"]
	n7["lib/src/features/workspace/shell/panel"]
	n8["lib/src/foundation"]
	n9["lib/src/foundation/content"]
	n10["lib/src/foundation/interaction"]
	n11["lib/src/foundation/layout"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"part"| n4
	n0 -->|"part"| n5
	n0 -->|"part"| n6
	n0 -->|"import"| n7
	n0 -->|"import"| n8
	n0 -->|"import"| n9
	n0 -->|"import"| n10
	n0 -->|"import"| n11
```

```mermaid
flowchart TD
	n0["lib/src/features/workspace/shell/docking"]
	n1["lib/src/foundation/surface"]
	n2["lib/src/styling/legacy_theme"]
	n3["package:flutter"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/application/localization</code> | import | 1 | [lib/src/features/workspace/shell/docking/klp_dock_header.dart:6](../../../../../../../lib/src/features/workspace/shell/docking/klp_dock_header.dart#L6) |
| <code>lib/src/features/actions/button</code> | import | 1 | [lib/src/features/workspace/shell/docking/klp_dock_header.dart:4](../../../../../../../lib/src/features/workspace/shell/docking/klp_dock_header.dart#L4) |
| <code>lib/src/features/overlays</code> | import | 2 | [lib/src/features/workspace/shell/docking/klp_dock_header.dart:8](../../../../../../../lib/src/features/workspace/shell/docking/klp_dock_header.dart#L8) |
| <code>lib/src/features/workspace/shell/docking/internal</code> | part | 8 | [lib/src/features/workspace/shell/docking/klp_dock_header.dart:14](../../../../../../../lib/src/features/workspace/shell/docking/klp_dock_header.dart#L14) |
| <code>lib/src/features/workspace/shell/docking/models</code> | part | 6 | [lib/src/features/workspace/shell/docking/klp_dock_layout_models.dart:3](../../../../../../../lib/src/features/workspace/shell/docking/klp_dock_layout_models.dart#L3) |
| <code>lib/src/features/workspace/shell/docking/primitives</code> | part | 8 | [lib/src/features/workspace/shell/docking/klp_dock_header.dart:17](../../../../../../../lib/src/features/workspace/shell/docking/klp_dock_header.dart#L17) |
| <code>lib/src/features/workspace/shell/panel</code> | import | 2 | [lib/src/features/workspace/shell/docking/klp_dock_header.dart:12](../../../../../../../lib/src/features/workspace/shell/docking/klp_dock_header.dart#L12) |
| <code>lib/src/foundation</code> | import | 2 | [lib/src/features/workspace/shell/docking/klp_dock_header.dart:5](../../../../../../../lib/src/features/workspace/shell/docking/klp_dock_header.dart#L5) |
| <code>lib/src/foundation/content</code> | import | 1 | [lib/src/features/workspace/shell/docking/klp_dock_layout.dart:7](../../../../../../../lib/src/features/workspace/shell/docking/klp_dock_layout.dart#L7) |
| <code>lib/src/foundation/interaction</code> | import | 1 | [lib/src/features/workspace/shell/docking/klp_dock_layout.dart:3](../../../../../../../lib/src/features/workspace/shell/docking/klp_dock_layout.dart#L3) |
| <code>lib/src/foundation/layout</code> | import | 2 | [lib/src/features/workspace/shell/docking/klp_dock_header.dart:7](../../../../../../../lib/src/features/workspace/shell/docking/klp_dock_header.dart#L7) |
| <code>lib/src/foundation/surface</code> | import | 1 | [lib/src/features/workspace/shell/docking/klp_dock_layout.dart:5](../../../../../../../lib/src/features/workspace/shell/docking/klp_dock_layout.dart#L5) |
| <code>lib/src/styling/legacy_theme</code> | import | 2 | [lib/src/features/workspace/shell/docking/klp_dock_header.dart:10](../../../../../../../lib/src/features/workspace/shell/docking/klp_dock_header.dart#L10) |
| <code>package:flutter</code> | import | 5 | [lib/src/features/workspace/shell/docking/klp_dock_header.dart:1](../../../../../../../lib/src/features/workspace/shell/docking/klp_dock_header.dart#L1) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_dock_header.dart → klp_dock_panel.dart</code> | import | [lib/src/features/workspace/shell/docking/klp_dock_header.dart:11](../../../../../../../lib/src/features/workspace/shell/docking/klp_dock_header.dart#L11) |
| <code>klp_dock_layout.dart → klp_dock_header.dart</code> | import | [lib/src/features/workspace/shell/docking/klp_dock_layout.dart:9](../../../../../../../lib/src/features/workspace/shell/docking/klp_dock_layout.dart#L9) |
| <code>klp_dock_layout.dart → klp_dock_layout_models.dart</code> | import | [lib/src/features/workspace/shell/docking/klp_dock_layout.dart:10](../../../../../../../lib/src/features/workspace/shell/docking/klp_dock_layout.dart#L10) |
| <code>klp_dock_layout.dart → klp_dock_panel.dart</code> | import | [lib/src/features/workspace/shell/docking/klp_dock_layout.dart:11](../../../../../../../lib/src/features/workspace/shell/docking/klp_dock_layout.dart#L11) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/features/workspace/shell/docking"]
	n1["internal/"]
	n2["models/"]
	n3["primitives/"]
	n4["klp_dock_header.dart"]
	n5["klp_dock_layout.dart"]
	n6["klp_dock_layout_models.dart"]
	n7["klp_dock_panel.dart"]
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
| `internal/` | [架構入口](internal/README.md) | [來源目錄](../../../../../../../lib/src/features/workspace/shell/docking/internal) |
| `models/` | [架構入口](models/README.md) | [來源目錄](../../../../../../../lib/src/features/workspace/shell/docking/models) |
| `primitives/` | [架構入口](primitives/README.md) | [來源目錄](../../../../../../../lib/src/features/workspace/shell/docking/primitives) |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_dock_header.dart` | 無頂層宣告 | [架構與 API](klp_dock_header.md) | [lib/src/features/workspace/shell/docking/klp_dock_header.dart:1](../../../../../../../lib/src/features/workspace/shell/docking/klp_dock_header.dart#L1) |
| `klp_dock_layout.dart` | _KlpDockLayoutState | [架構與 API](klp_dock_layout.md) | [lib/src/features/workspace/shell/docking/klp_dock_layout.dart:1](../../../../../../../lib/src/features/workspace/shell/docking/klp_dock_layout.dart#L1) |
| `klp_dock_layout_models.dart` | 無頂層宣告 | [架構與 API](klp_dock_layout_models.md) | [lib/src/features/workspace/shell/docking/klp_dock_layout_models.dart:1](../../../../../../../lib/src/features/workspace/shell/docking/klp_dock_layout_models.dart#L1) |
| `klp_dock_panel.dart` | 無頂層宣告 | [架構與 API](klp_dock_panel.md) | [lib/src/features/workspace/shell/docking/klp_dock_panel.dart:1](../../../../../../../lib/src/features/workspace/shell/docking/klp_dock_panel.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
