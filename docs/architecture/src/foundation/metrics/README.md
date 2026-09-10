# lib/src/foundation/metrics：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/foundation/metrics` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart TD
	n0["lib/src/foundation/metrics"]
	n1["lib/src/foundation"]
	n0 -->|"part of"| n1
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/foundation</code> | part of | 13 | [lib/src/foundation/metrics/klp_code_metrics.dart:1](../../../../../lib/src/foundation/metrics/klp_code_metrics.dart#L1) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/foundation/metrics"]
	n1["klp_code_metrics.dart"]
	n2["klp_control_metrics.dart"]
	n3["klp_elevation.dart"]
	n4["klp_form_metrics.dart"]
	n5["klp_layout_gap.dart"]
	n6["klp_line.dart"]
	n7["klp_motion.dart"]
	n8["klp_placeholder_metrics.dart"]
	n9["klp_radius.dart"]
	n10["klp_size.dart"]
	n11["klp_space.dart"]
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
	n0["lib/src/foundation/metrics"]
	n1["klp_transparency.dart"]
	n2["klp_typography.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| 無 | 目前沒有下一層目錄 | — |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_code_metrics.dart` | KlpCodeMetrics | [架構與 API](klp_code_metrics.md) | [lib/src/foundation/metrics/klp_code_metrics.dart:1](../../../../../lib/src/foundation/metrics/klp_code_metrics.dart#L1) |
| `klp_control_metrics.dart` | KlpControlMetrics | [架構與 API](klp_control_metrics.md) | [lib/src/foundation/metrics/klp_control_metrics.dart:1](../../../../../lib/src/foundation/metrics/klp_control_metrics.dart#L1) |
| `klp_elevation.dart` | KlpElevation | [架構與 API](klp_elevation.md) | [lib/src/foundation/metrics/klp_elevation.dart:1](../../../../../lib/src/foundation/metrics/klp_elevation.dart#L1) |
| `klp_form_metrics.dart` | KlpFormMetrics | [架構與 API](klp_form_metrics.md) | [lib/src/foundation/metrics/klp_form_metrics.dart:1](../../../../../lib/src/foundation/metrics/klp_form_metrics.dart#L1) |
| `klp_layout_gap.dart` | KlpLayoutGap | [架構與 API](klp_layout_gap.md) | [lib/src/foundation/metrics/klp_layout_gap.dart:1](../../../../../lib/src/foundation/metrics/klp_layout_gap.dart#L1) |
| `klp_line.dart` | KlpLine | [架構與 API](klp_line.md) | [lib/src/foundation/metrics/klp_line.dart:1](../../../../../lib/src/foundation/metrics/klp_line.dart#L1) |
| `klp_motion.dart` | KlpMotion | [架構與 API](klp_motion.md) | [lib/src/foundation/metrics/klp_motion.dart:1](../../../../../lib/src/foundation/metrics/klp_motion.dart#L1) |
| `klp_placeholder_metrics.dart` | KlpPlaceholderMetrics | [架構與 API](klp_placeholder_metrics.md) | [lib/src/foundation/metrics/klp_placeholder_metrics.dart:1](../../../../../lib/src/foundation/metrics/klp_placeholder_metrics.dart#L1) |
| `klp_radius.dart` | KlpRadius | [架構與 API](klp_radius.md) | [lib/src/foundation/metrics/klp_radius.dart:1](../../../../../lib/src/foundation/metrics/klp_radius.dart#L1) |
| `klp_size.dart` | KlpSize | [架構與 API](klp_size.md) | [lib/src/foundation/metrics/klp_size.dart:1](../../../../../lib/src/foundation/metrics/klp_size.dart#L1) |
| `klp_space.dart` | KlpSpace | [架構與 API](klp_space.md) | [lib/src/foundation/metrics/klp_space.dart:1](../../../../../lib/src/foundation/metrics/klp_space.dart#L1) |
| `klp_transparency.dart` | KlpTransparency | [架構與 API](klp_transparency.md) | [lib/src/foundation/metrics/klp_transparency.dart:1](../../../../../lib/src/foundation/metrics/klp_transparency.dart#L1) |
| `klp_typography.dart` | KlpTypography | [架構與 API](klp_typography.md) | [lib/src/foundation/metrics/klp_typography.dart:1](../../../../../lib/src/foundation/metrics/klp_typography.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
