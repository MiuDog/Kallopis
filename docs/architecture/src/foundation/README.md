# lib/src/foundation：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/foundation` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 模組閱讀重點

## 分析入口

`foundation/` 同時包含裝飾 palette／metrics 常數、OKLCH 色彩模型，以及 icon、inline code、spinner、progress 等會讀 theme 的視覺元件；不能把整個目錄視為無上游依賴的純常數底層。圖示目前由 KlpIconData 與 KlpIcon 組合 Flutter IconData 字型。設計語言的 KlpPalette 與 KlpAccent 已歸 tokens，這裡只保留非設計語言的 KlpDecorativePalette。

| 想查的問題 | 符號與來源 |
| --- | --- |
| 裝飾色盤定義在哪？ | KlpDecorativePalette — `lib/src/foundation/klp_palette.dart:8` |
| OKLCH 資料入口？ | KlpOklchColor — `lib/src/foundation/klp_oklch_color.dart:12` |
| 圖示如何實際繪出？ | KlpIcon.build — `lib/src/foundation/klp_icon.dart:57` |
| 靜態尺寸常數有哪些分類？ | KlpSpace／KlpControlMetrics — `lib/src/foundation/klp_metrics.dart:8`、`lib/src/foundation/klp_metrics.dart:138` |

重要關係：

- `klp_palette.dart` 僅 import Flutter 色彩型別，定義預覽桌布與視窗控制鈕的裝飾值；未匯出設計語言色盤（`lib/src/foundation/klp_palette.dart:1`、`lib/src/foundation/klp_palette.dart:8`）。
- `KlpIcon.build` → Flutter `IconData`：由字重決定字碼與字型，並指定 fontPackage 為 kallopis（`lib/src/foundation/klp_icon.dart:60`、`lib/src/foundation/klp_icon.dart:64`）。
- 目錄層級 `foundation → theme → tokens`：icon 引入 theme，theme 引入 primitive token（`lib/src/foundation/klp_icon.dart:3`、`lib/src/theme/klp_theme.dart:7`）。兩端是不同職責的檔案。

import 依賴圖不能推導執行順序；圖示載入應以現行 IconData 實作為準。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart TD
	n0["lib/src/foundation"]
	n1["dart:math"]
	n2["lib/src/theme"]
	n3["package:flutter"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>dart:math</code> | import | 2 | [lib/src/foundation/klp_geometric_spinner.dart:1](../../../../lib/src/foundation/klp_geometric_spinner.dart#L1) |
| <code>lib/src/theme</code> | import | 4 | [lib/src/foundation/klp_geometric_spinner.dart:4](../../../../lib/src/foundation/klp_geometric_spinner.dart#L4) |
| <code>package:flutter</code> | import | 8 | [lib/src/foundation/klp_geometric_spinner.dart:2](../../../../lib/src/foundation/klp_geometric_spinner.dart#L2) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_icons.dart → klp_icon.dart</code> | import | [lib/src/foundation/klp_icons.dart:1](../../../../lib/src/foundation/klp_icons.dart#L1) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/foundation"]
	n1["internal/"]
	n2["klp_geometric_spinner.dart"]
	n3["klp_icon.dart"]
	n4["klp_icons.dart"]
	n5["klp_inline_code.dart"]
	n6["klp_metrics.dart"]
	n7["klp_oklch_color.dart"]
	n8["klp_palette.dart"]
	n9["klp_segmented_progress.dart"]
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
| `internal/` | [架構入口](internal/README.md) | [來源目錄](../../../../lib/src/foundation/internal) |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_geometric_spinner.dart` | KlpGeometricSpinner, _KlpGeometricSpinnerState, _GeometricSpinnerPainter | [架構與 API](klp_geometric_spinner.md) | [lib/src/foundation/klp_geometric_spinner.dart:1](../../../../lib/src/foundation/klp_geometric_spinner.dart#L1) |
| `klp_icon.dart` | KlpIconData, KlpIconWeight, KlpIcon | [架構與 API](klp_icon.md) | [lib/src/foundation/klp_icon.dart:1](../../../../lib/src/foundation/klp_icon.dart#L1) |
| `klp_icons.dart` | KlpIcons | [架構與 API](klp_icons.md) | [lib/src/foundation/klp_icons.dart:1](../../../../lib/src/foundation/klp_icons.dart#L1) |
| `klp_inline_code.dart` | KlpInlineCode | [架構與 API](klp_inline_code.md) | [lib/src/foundation/klp_inline_code.dart:1](../../../../lib/src/foundation/klp_inline_code.dart#L1) |
| `klp_metrics.dart` | KlpSpace, KlpLayoutGap, KlpRadius, KlpLine, KlpMotion, KlpElevation, KlpSize, KlpFormMetrics, KlpControlMetrics, KlpPlaceholderMetrics, KlpCodeMetrics, KlpTypography, KlpTransparency | [架構與 API](klp_metrics.md) | [lib/src/foundation/klp_metrics.dart:1](../../../../lib/src/foundation/klp_metrics.dart#L1) |
| `klp_oklch_color.dart` | KlpOklchColor, _srgbToLinear, _linearToSrgb | [架構與 API](klp_oklch_color.md) | [lib/src/foundation/klp_oklch_color.dart:1](../../../../lib/src/foundation/klp_oklch_color.dart#L1) |
| `klp_palette.dart` | KlpDecorativePalette | [架構與 API](klp_palette.md) | [lib/src/foundation/klp_palette.dart:1](../../../../lib/src/foundation/klp_palette.dart#L1) |
| `klp_segmented_progress.dart` | KlpSegmentedProgress | [架構與 API](klp_segmented_progress.md) | [lib/src/foundation/klp_segmented_progress.dart:1](../../../../lib/src/foundation/klp_segmented_progress.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
