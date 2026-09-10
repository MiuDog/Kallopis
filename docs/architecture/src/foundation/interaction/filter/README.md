# lib/src/foundation/interaction/filter：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/foundation/interaction/filter` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/foundation/interaction/filter"]
	n1["lib/src/features/actions/button"]
	n2["lib/src/foundation"]
	n3["lib/src/foundation/content"]
	n4["lib/src/foundation/interaction"]
	n5["lib/src/foundation/interaction/filter/internal"]
	n6["lib/src/foundation/interaction/filter/models"]
	n7["lib/src/foundation/interaction/filter/primitives"]
	n8["lib/src/foundation/layout"]
	n9["lib/src/foundation/surface"]
	n10["lib/src/styling/legacy_theme"]
	n11["package:flutter"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"part"| n5
	n0 -->|"export"| n6
	n0 -->|"part"| n7
	n0 -->|"import"| n8
	n0 -->|"import"| n9
	n0 -->|"import"| n10
	n0 -->|"import"| n11
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/features/actions/button</code> | import | 1 | [lib/src/foundation/interaction/filter/klp_selection_toolbar.dart:3](../../../../../../lib/src/foundation/interaction/filter/klp_selection_toolbar.dart#L3) |
| <code>lib/src/foundation</code> | import | 2 | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:3](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L3) |
| <code>lib/src/foundation/content</code> | import | 4 | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:8](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L8) |
| <code>lib/src/foundation/interaction</code> | import | 5 | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:9](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L9) |
| <code>lib/src/foundation/interaction/filter/internal</code> | part | 5 | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:19](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L19) |
| <code>lib/src/foundation/interaction/filter/models</code> | export | 2 | [lib/src/foundation/interaction/filter/klp_filter_models.dart:1](../../../../../../lib/src/foundation/interaction/filter/klp_filter_models.dart#L1) |
| <code>lib/src/foundation/interaction/filter/primitives</code> | part | 7 | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:21](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L21) |
| <code>lib/src/foundation/layout</code> | import | 3 | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:5](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L5) |
| <code>lib/src/foundation/surface</code> | import | 4 | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:6](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L6) |
| <code>lib/src/styling/legacy_theme</code> | import | 4 | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:7](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L7) |
| <code>package:flutter</code> | import | 4 | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:1](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L1) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_filter_bar.dart → klp_filter_models.dart</code> | import | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:12](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L12) |
| <code>klp_filter_bar.dart → klp_filter_models.dart</code> | export | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:14](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L14) |
| <code>klp_filter_bar.dart → klp_presence_indicator.dart</code> | export | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:15](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L15) |
| <code>klp_filter_bar.dart → klp_selection_toolbar.dart</code> | export | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:16](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L16) |
| <code>klp_filter_bar.dart → klp_shortcut_hint.dart</code> | export | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:17](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L17) |
| <code>klp_selection_toolbar.dart → klp_filter_models.dart</code> | import | [lib/src/foundation/interaction/filter/klp_selection_toolbar.dart:11](../../../../../../lib/src/foundation/interaction/filter/klp_selection_toolbar.dart#L11) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/foundation/interaction/filter"]
	n1["internal/"]
	n2["models/"]
	n3["primitives/"]
	n4["klp_filter_bar.dart"]
	n5["klp_filter_models.dart"]
	n6["klp_presence_indicator.dart"]
	n7["klp_selection_toolbar.dart"]
	n8["klp_shortcut_hint.dart"]
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
| `internal/` | [架構入口](internal/README.md) | [來源目錄](../../../../../../lib/src/foundation/interaction/filter/internal) |
| `models/` | [架構入口](models/README.md) | [來源目錄](../../../../../../lib/src/foundation/interaction/filter/models) |
| `primitives/` | [架構入口](primitives/README.md) | [來源目錄](../../../../../../lib/src/foundation/interaction/filter/primitives) |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_filter_bar.dart` | 無頂層宣告 | [架構與 API](klp_filter_bar.md) | [lib/src/foundation/interaction/filter/klp_filter_bar.dart:1](../../../../../../lib/src/foundation/interaction/filter/klp_filter_bar.dart#L1) |
| `klp_filter_models.dart` | 無頂層宣告 | [架構與 API](klp_filter_models.md) | [lib/src/foundation/interaction/filter/klp_filter_models.dart:1](../../../../../../lib/src/foundation/interaction/filter/klp_filter_models.dart#L1) |
| `klp_presence_indicator.dart` | 無頂層宣告 | [架構與 API](klp_presence_indicator.md) | [lib/src/foundation/interaction/filter/klp_presence_indicator.dart:1](../../../../../../lib/src/foundation/interaction/filter/klp_presence_indicator.dart#L1) |
| `klp_selection_toolbar.dart` | 無頂層宣告 | [架構與 API](klp_selection_toolbar.md) | [lib/src/foundation/interaction/filter/klp_selection_toolbar.dart:1](../../../../../../lib/src/foundation/interaction/filter/klp_selection_toolbar.dart#L1) |
| `klp_shortcut_hint.dart` | 無頂層宣告 | [架構與 API](klp_shortcut_hint.md) | [lib/src/foundation/interaction/filter/klp_shortcut_hint.dart:1](../../../../../../lib/src/foundation/interaction/filter/klp_shortcut_hint.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
