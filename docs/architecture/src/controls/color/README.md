# lib/src/controls/color：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/controls/color` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/controls/color"]
	n1["dart:math"]
	n2["lib/src/controls/selection"]
	n3["lib/src/foundation"]
	n4["lib/src/l10n"]
	n5["lib/src/theme"]
	n6["lib/src/typography"]
	n7["package:flutter"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>dart:math</code> | import | 2 | [lib/src/controls/color/klp_oklch_color_editor.dart:1](../../../../../lib/src/controls/color/klp_oklch_color_editor.dart#L1) |
| <code>lib/src/controls/selection</code> | import | 1 | [lib/src/controls/color/klp_oklch_color_editor.dart:8](../../../../../lib/src/controls/color/klp_oklch_color_editor.dart#L8) |
| <code>lib/src/foundation</code> | import | 2 | [lib/src/controls/color/klp_oklch_color_editor.dart:5](../../../../../lib/src/controls/color/klp_oklch_color_editor.dart#L5) |
| <code>lib/src/l10n</code> | import | 2 | [lib/src/controls/color/klp_oklch_color_editor.dart:6](../../../../../lib/src/controls/color/klp_oklch_color_editor.dart#L6) |
| <code>lib/src/theme</code> | import | 2 | [lib/src/controls/color/klp_oklch_color_editor.dart:7](../../../../../lib/src/controls/color/klp_oklch_color_editor.dart#L7) |
| <code>lib/src/typography</code> | import | 1 | [lib/src/controls/color/klp_oklch_color_picker.dart:9](../../../../../lib/src/controls/color/klp_oklch_color_picker.dart#L9) |
| <code>package:flutter</code> | import | 3 | [lib/src/controls/color/klp_oklch_color_editor.dart:3](../../../../../lib/src/controls/color/klp_oklch_color_editor.dart#L3) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_oklch_color_picker.dart → klp_oklch_color_editor.dart</code> | import | [lib/src/controls/color/klp_oklch_color_picker.dart:10](../../../../../lib/src/controls/color/klp_oklch_color_picker.dart#L10) |

## 目錄結構圖

```mermaid
flowchart TD
	n0["lib/src/controls/color"]
	n1["klp_oklch_color_editor.dart"]
	n2["klp_oklch_color_picker.dart"]
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
| `klp_oklch_color_editor.dart` | KlpOklchColorEditor | [架構與 API](klp_oklch_color_editor.md) | [lib/src/controls/color/klp_oklch_color_editor.dart:1](../../../../../lib/src/controls/color/klp_oklch_color_editor.dart#L1) |
| `klp_oklch_color_picker.dart` | KlpOklchColorPicker, _OklchPlaneKind, _OklchPlane, _OklchPlaneState, _OklchPlanePainter | [架構與 API](klp_oklch_color_picker.md) | [lib/src/controls/color/klp_oklch_color_picker.dart:1](../../../../../lib/src/controls/color/klp_oklch_color_picker.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
