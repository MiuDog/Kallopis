# lib/src/features/workspace/shell/theme：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/features/workspace/shell/theme` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/features/workspace/shell/theme"]
	n1["dart:math"]
	n2["lib/src/features/workspace/shell/theme/internal"]
	n3["lib/src/features/workspace/shell/theme/primitives"]
	n4["lib/src/foundation"]
	n5["lib/src/foundation/content"]
	n6["lib/src/foundation/interaction"]
	n7["lib/src/foundation/layout"]
	n8["lib/src/foundation/surface"]
	n9["lib/src/styling/legacy_theme"]
	n10["package:flutter"]
	n0 -->|"import"| n1
	n0 -->|"part"| n2
	n0 -->|"part"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
	n0 -->|"import"| n8
	n0 -->|"import"| n9
	n0 -->|"import"| n10
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>dart:math</code> | import | 1 | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:1](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L1) |
| <code>lib/src/features/workspace/shell/theme/internal</code> | part | 1 | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:16](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L16) |
| <code>lib/src/features/workspace/shell/theme/primitives</code> | part | 3 | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:17](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L17) |
| <code>lib/src/foundation</code> | import | 1 | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:5](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L5) |
| <code>lib/src/foundation/content</code> | import | 2 | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:11](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L11) |
| <code>lib/src/foundation/interaction</code> | import | 1 | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:6](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L6) |
| <code>lib/src/foundation/layout</code> | import | 3 | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:7](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L7) |
| <code>lib/src/foundation/surface</code> | import | 1 | [lib/src/features/workspace/shell/theme/klp_theme_toggle.dart:3](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_toggle.dart#L3) |
| <code>lib/src/styling/legacy_theme</code> | import | 2 | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:10](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L10) |
| <code>package:flutter</code> | import | 2 | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:3](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L3) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_theme_preview_tile.dart → klp_theme_preview_mode.dart</code> | import | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:12](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L12) |
| <code>klp_theme_preview_tile.dart → klp_theme_preview_mode.dart</code> | export | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:14](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L14) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/features/workspace/shell/theme"]
	n1["internal/"]
	n2["primitives/"]
	n3["klp_theme_preview_mode.dart"]
	n4["klp_theme_preview_tile.dart"]
	n5["klp_theme_toggle.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
	n0 -->|"contains"| n3
	n0 -->|"contains"| n4
	n0 -->|"contains"| n5
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| `internal/` | [架構入口](internal/README.md) | [來源目錄](../../../../../../../lib/src/features/workspace/shell/theme/internal) |
| `primitives/` | [架構入口](primitives/README.md) | [來源目錄](../../../../../../../lib/src/features/workspace/shell/theme/primitives) |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_theme_preview_mode.dart` | KlpThemePreviewMode | [架構與 API](klp_theme_preview_mode.md) | [lib/src/features/workspace/shell/theme/klp_theme_preview_mode.dart:1](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_mode.dart#L1) |
| `klp_theme_preview_tile.dart` | KlpThemePreviewTile | [架構與 API](klp_theme_preview_tile.md) | [lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart:1](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart#L1) |
| `klp_theme_toggle.dart` | KlpThemeToggle | [架構與 API](klp_theme_toggle.md) | [lib/src/features/workspace/shell/theme/klp_theme_toggle.dart:1](../../../../../../../lib/src/features/workspace/shell/theme/klp_theme_toggle.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
