# lib/src/styling/legacy_metrics：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/styling/legacy_metrics` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart TD
	n0["lib/src/styling/legacy_metrics"]
	n1["package:flutter"]
	n0 -->|"import"| n1
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>package:flutter</code> | import | 1 | [lib/src/styling/legacy_metrics/klp_metrics.dart:1](../../../../../lib/src/styling/legacy_metrics/klp_metrics.dart#L1) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_code_metrics.dart → klp_metrics.dart</code> | part of | [lib/src/styling/legacy_metrics/klp_code_metrics.dart:1](../../../../../lib/src/styling/legacy_metrics/klp_code_metrics.dart#L1) |
| <code>klp_control_metrics.dart → klp_metrics.dart</code> | part of | [lib/src/styling/legacy_metrics/klp_control_metrics.dart:1](../../../../../lib/src/styling/legacy_metrics/klp_control_metrics.dart#L1) |
| <code>klp_elevation.dart → klp_metrics.dart</code> | part of | [lib/src/styling/legacy_metrics/klp_elevation.dart:1](../../../../../lib/src/styling/legacy_metrics/klp_elevation.dart#L1) |
| <code>klp_form_metrics.dart → klp_metrics.dart</code> | part of | [lib/src/styling/legacy_metrics/klp_form_metrics.dart:1](../../../../../lib/src/styling/legacy_metrics/klp_form_metrics.dart#L1) |
| <code>klp_layout_gap.dart → klp_metrics.dart</code> | part of | [lib/src/styling/legacy_metrics/klp_layout_gap.dart:1](../../../../../lib/src/styling/legacy_metrics/klp_layout_gap.dart#L1) |
| <code>klp_line.dart → klp_metrics.dart</code> | part of | [lib/src/styling/legacy_metrics/klp_line.dart:1](../../../../../lib/src/styling/legacy_metrics/klp_line.dart#L1) |
| <code>klp_metrics.dart → klp_code_metrics.dart</code> | part | [lib/src/styling/legacy_metrics/klp_metrics.dart:3](../../../../../lib/src/styling/legacy_metrics/klp_metrics.dart#L3) |
| <code>klp_metrics.dart → klp_control_metrics.dart</code> | part | [lib/src/styling/legacy_metrics/klp_metrics.dart:4](../../../../../lib/src/styling/legacy_metrics/klp_metrics.dart#L4) |
| <code>klp_metrics.dart → klp_elevation.dart</code> | part | [lib/src/styling/legacy_metrics/klp_metrics.dart:5](../../../../../lib/src/styling/legacy_metrics/klp_metrics.dart#L5) |
| <code>klp_metrics.dart → klp_form_metrics.dart</code> | part | [lib/src/styling/legacy_metrics/klp_metrics.dart:6](../../../../../lib/src/styling/legacy_metrics/klp_metrics.dart#L6) |
| <code>klp_metrics.dart → klp_layout_gap.dart</code> | part | [lib/src/styling/legacy_metrics/klp_metrics.dart:7](../../../../../lib/src/styling/legacy_metrics/klp_metrics.dart#L7) |
| <code>klp_metrics.dart → klp_line.dart</code> | part | [lib/src/styling/legacy_metrics/klp_metrics.dart:8](../../../../../lib/src/styling/legacy_metrics/klp_metrics.dart#L8) |
| <code>klp_metrics.dart → klp_motion.dart</code> | part | [lib/src/styling/legacy_metrics/klp_metrics.dart:9](../../../../../lib/src/styling/legacy_metrics/klp_metrics.dart#L9) |
| <code>klp_metrics.dart → klp_placeholder_metrics.dart</code> | part | [lib/src/styling/legacy_metrics/klp_metrics.dart:10](../../../../../lib/src/styling/legacy_metrics/klp_metrics.dart#L10) |
| <code>klp_metrics.dart → klp_radius.dart</code> | part | [lib/src/styling/legacy_metrics/klp_metrics.dart:11](../../../../../lib/src/styling/legacy_metrics/klp_metrics.dart#L11) |
| <code>klp_metrics.dart → klp_size.dart</code> | part | [lib/src/styling/legacy_metrics/klp_metrics.dart:12](../../../../../lib/src/styling/legacy_metrics/klp_metrics.dart#L12) |
| <code>klp_metrics.dart → klp_space.dart</code> | part | [lib/src/styling/legacy_metrics/klp_metrics.dart:13](../../../../../lib/src/styling/legacy_metrics/klp_metrics.dart#L13) |
| <code>klp_metrics.dart → klp_transparency.dart</code> | part | [lib/src/styling/legacy_metrics/klp_metrics.dart:14](../../../../../lib/src/styling/legacy_metrics/klp_metrics.dart#L14) |
| <code>klp_metrics.dart → klp_typography.dart</code> | part | [lib/src/styling/legacy_metrics/klp_metrics.dart:15](../../../../../lib/src/styling/legacy_metrics/klp_metrics.dart#L15) |
| <code>klp_motion.dart → klp_metrics.dart</code> | part of | [lib/src/styling/legacy_metrics/klp_motion.dart:1](../../../../../lib/src/styling/legacy_metrics/klp_motion.dart#L1) |
| <code>klp_placeholder_metrics.dart → klp_metrics.dart</code> | part of | [lib/src/styling/legacy_metrics/klp_placeholder_metrics.dart:1](../../../../../lib/src/styling/legacy_metrics/klp_placeholder_metrics.dart#L1) |
| <code>klp_radius.dart → klp_metrics.dart</code> | part of | [lib/src/styling/legacy_metrics/klp_radius.dart:1](../../../../../lib/src/styling/legacy_metrics/klp_radius.dart#L1) |
| <code>klp_size.dart → klp_metrics.dart</code> | part of | [lib/src/styling/legacy_metrics/klp_size.dart:1](../../../../../lib/src/styling/legacy_metrics/klp_size.dart#L1) |
| <code>klp_space.dart → klp_metrics.dart</code> | part of | [lib/src/styling/legacy_metrics/klp_space.dart:1](../../../../../lib/src/styling/legacy_metrics/klp_space.dart#L1) |
| <code>klp_transparency.dart → klp_metrics.dart</code> | part of | [lib/src/styling/legacy_metrics/klp_transparency.dart:1](../../../../../lib/src/styling/legacy_metrics/klp_transparency.dart#L1) |
| <code>klp_typography.dart → klp_metrics.dart</code> | part of | [lib/src/styling/legacy_metrics/klp_typography.dart:1](../../../../../lib/src/styling/legacy_metrics/klp_typography.dart#L1) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/styling/legacy_metrics"]
	n1["klp_code_metrics.dart"]
	n2["klp_control_metrics.dart"]
	n3["klp_elevation.dart"]
	n4["klp_form_metrics.dart"]
	n5["klp_layout_gap.dart"]
	n6["klp_line.dart"]
	n7["klp_metrics.dart"]
	n8["klp_motion.dart"]
	n9["klp_placeholder_metrics.dart"]
	n10["klp_radius.dart"]
	n11["klp_size.dart"]
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
	n0["lib/src/styling/legacy_metrics"]
	n1["klp_space.dart"]
	n2["klp_transparency.dart"]
	n3["klp_typography.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
	n0 -->|"contains"| n3
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| 無 | 目前沒有下一層目錄 | — |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_code_metrics.dart` | KlpCodeMetrics | [架構與 API](klp_code_metrics.md) | [lib/src/styling/legacy_metrics/klp_code_metrics.dart:1](../../../../../lib/src/styling/legacy_metrics/klp_code_metrics.dart#L1) |
| `klp_control_metrics.dart` | KlpControlMetrics | [架構與 API](klp_control_metrics.md) | [lib/src/styling/legacy_metrics/klp_control_metrics.dart:1](../../../../../lib/src/styling/legacy_metrics/klp_control_metrics.dart#L1) |
| `klp_elevation.dart` | KlpElevation | [架構與 API](klp_elevation.md) | [lib/src/styling/legacy_metrics/klp_elevation.dart:1](../../../../../lib/src/styling/legacy_metrics/klp_elevation.dart#L1) |
| `klp_form_metrics.dart` | KlpFormMetrics | [架構與 API](klp_form_metrics.md) | [lib/src/styling/legacy_metrics/klp_form_metrics.dart:1](../../../../../lib/src/styling/legacy_metrics/klp_form_metrics.dart#L1) |
| `klp_layout_gap.dart` | KlpLayoutGap | [架構與 API](klp_layout_gap.md) | [lib/src/styling/legacy_metrics/klp_layout_gap.dart:1](../../../../../lib/src/styling/legacy_metrics/klp_layout_gap.dart#L1) |
| `klp_line.dart` | KlpLine | [架構與 API](klp_line.md) | [lib/src/styling/legacy_metrics/klp_line.dart:1](../../../../../lib/src/styling/legacy_metrics/klp_line.dart#L1) |
| `klp_metrics.dart` | 無頂層宣告 | [架構與 API](klp_metrics.md) | [lib/src/styling/legacy_metrics/klp_metrics.dart:1](../../../../../lib/src/styling/legacy_metrics/klp_metrics.dart#L1) |
| `klp_motion.dart` | KlpMotion | [架構與 API](klp_motion.md) | [lib/src/styling/legacy_metrics/klp_motion.dart:1](../../../../../lib/src/styling/legacy_metrics/klp_motion.dart#L1) |
| `klp_placeholder_metrics.dart` | KlpPlaceholderMetrics | [架構與 API](klp_placeholder_metrics.md) | [lib/src/styling/legacy_metrics/klp_placeholder_metrics.dart:1](../../../../../lib/src/styling/legacy_metrics/klp_placeholder_metrics.dart#L1) |
| `klp_radius.dart` | KlpRadius | [架構與 API](klp_radius.md) | [lib/src/styling/legacy_metrics/klp_radius.dart:1](../../../../../lib/src/styling/legacy_metrics/klp_radius.dart#L1) |
| `klp_size.dart` | KlpSize | [架構與 API](klp_size.md) | [lib/src/styling/legacy_metrics/klp_size.dart:1](../../../../../lib/src/styling/legacy_metrics/klp_size.dart#L1) |
| `klp_space.dart` | KlpSpace | [架構與 API](klp_space.md) | [lib/src/styling/legacy_metrics/klp_space.dart:1](../../../../../lib/src/styling/legacy_metrics/klp_space.dart#L1) |
| `klp_transparency.dart` | KlpTransparency | [架構與 API](klp_transparency.md) | [lib/src/styling/legacy_metrics/klp_transparency.dart:1](../../../../../lib/src/styling/legacy_metrics/klp_transparency.dart#L1) |
| `klp_typography.dart` | KlpTypography | [架構與 API](klp_typography.md) | [lib/src/styling/legacy_metrics/klp_typography.dart:1](../../../../../lib/src/styling/legacy_metrics/klp_typography.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
