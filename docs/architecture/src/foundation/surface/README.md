# lib/src/foundation/surface：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/foundation/surface` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart TD
	n0["lib/src/foundation/surface"]
	n1["dart:ui"]
	n2["lib/src/styling/legacy_theme"]
	n3["package:flutter"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>dart:ui</code> | import | 1 | [lib/src/foundation/surface/klp_surface.dart:1](../../../../../lib/src/foundation/surface/klp_surface.dart#L1) |
| <code>lib/src/styling/legacy_theme</code> | import | 5 | [lib/src/foundation/surface/klp_dashed_border.dart:3](../../../../../lib/src/foundation/surface/klp_dashed_border.dart#L3) |
| <code>package:flutter</code> | import | 5 | [lib/src/foundation/surface/klp_dashed_border.dart:1](../../../../../lib/src/foundation/surface/klp_dashed_border.dart#L1) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_dashed_border.dart → klp_stroke.dart</code> | import | [lib/src/foundation/surface/klp_dashed_border.dart:4](../../../../../lib/src/foundation/surface/klp_dashed_border.dart#L4) |
| <code>klp_surface.dart → klp_surface_tone.dart</code> | import | [lib/src/foundation/surface/klp_surface.dart:6](../../../../../lib/src/foundation/surface/klp_surface.dart#L6) |
| <code>klp_surface.dart → klp_surface_tone.dart</code> | export | [lib/src/foundation/surface/klp_surface.dart:8](../../../../../lib/src/foundation/surface/klp_surface.dart#L8) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/foundation/surface"]
	n1["legacy_components/"]
	n2["page_background/"]
	n3["klp_dashed_border.dart"]
	n4["klp_divider.dart"]
	n5["klp_stroke.dart"]
	n6["klp_surface.dart"]
	n7["klp_surface_tone.dart"]
	n8["klp_veil.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
	n0 -->|"contains"| n3
	n0 -->|"contains"| n4
	n0 -->|"contains"| n5
	n0 -->|"contains"| n6
	n0 -->|"contains"| n7
	n0 -->|"contains"| n8
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| `legacy_components/` | [架構入口](legacy_components/README.md) | [來源目錄](../../../../../lib/src/foundation/surface/legacy_components) |
| `page_background/` | [架構入口](page_background/README.md) | [來源目錄](../../../../../lib/src/foundation/surface/page_background) |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_dashed_border.dart` | KlpDashedBorder, KlpDashedDivider, _KlpDashedDividerPainter | [架構與 API](klp_dashed_border.md) | [lib/src/foundation/surface/klp_dashed_border.dart:1](../../../../../lib/src/foundation/surface/klp_dashed_border.dart#L1) |
| `klp_divider.dart` | KlpDivider | [架構與 API](klp_divider.md) | [lib/src/foundation/surface/klp_divider.dart:1](../../../../../lib/src/foundation/surface/klp_divider.dart#L1) |
| `klp_stroke.dart` | KlpStrokeRole, KlpStrokeState, KlpStrokeFrame, _KlpLatentStrokePainter | [架構與 API](klp_stroke.md) | [lib/src/foundation/surface/klp_stroke.dart:1](../../../../../lib/src/foundation/surface/klp_stroke.dart#L1) |
| `klp_surface.dart` | KlpSurface | [架構與 API](klp_surface.md) | [lib/src/foundation/surface/klp_surface.dart:1](../../../../../lib/src/foundation/surface/klp_surface.dart#L1) |
| `klp_surface_tone.dart` | KlpSurfaceTone | [架構與 API](klp_surface_tone.md) | [lib/src/foundation/surface/klp_surface_tone.dart:1](../../../../../lib/src/foundation/surface/klp_surface_tone.dart#L1) |
| `klp_veil.dart` | KlpVeil | [架構與 API](klp_veil.md) | [lib/src/foundation/surface/klp_veil.dart:1](../../../../../lib/src/foundation/surface/klp_veil.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
