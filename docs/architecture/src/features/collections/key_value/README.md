# lib/src/features/collections/key_value：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/features/collections/key_value` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/features/collections/key_value"]
	n1["lib/src/features/collections/key_value/internal"]
	n2["lib/src/features/collections/key_value/models"]
	n3["lib/src/features/collections/key_value/primitives"]
	n4["lib/src/foundation"]
	n5["lib/src/foundation/content"]
	n6["lib/src/foundation/interaction"]
	n7["lib/src/foundation/layout"]
	n8["lib/src/foundation/surface"]
	n9["lib/src/styling/legacy_theme"]
	n10["package:flutter"]
	n0 -->|"part"| n1
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
| <code>lib/src/features/collections/key_value/internal</code> | part | 4 | [lib/src/features/collections/key_value/klp_key_value_table.dart:16](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L16) |
| <code>lib/src/features/collections/key_value/models</code> | part | 3 | [lib/src/features/collections/key_value/klp_key_value_table.dart:20](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L20) |
| <code>lib/src/features/collections/key_value/primitives</code> | part | 4 | [lib/src/features/collections/key_value/klp_key_value_table.dart:23](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L23) |
| <code>lib/src/foundation</code> | import | 2 | [lib/src/features/collections/key_value/klp_key_value_table.dart:3](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L3) |
| <code>lib/src/foundation/content</code> | import | 1 | [lib/src/features/collections/key_value/klp_key_value_table.dart:14](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L14) |
| <code>lib/src/foundation/interaction</code> | import | 1 | [lib/src/features/collections/key_value/klp_key_value_table.dart:5](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L5) |
| <code>lib/src/foundation/layout</code> | import | 6 | [lib/src/features/collections/key_value/klp_key_value_table.dart:6](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L6) |
| <code>lib/src/foundation/surface</code> | import | 1 | [lib/src/features/collections/key_value/klp_key_value_table.dart:12](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L12) |
| <code>lib/src/styling/legacy_theme</code> | import | 1 | [lib/src/features/collections/key_value/klp_key_value_table.dart:13](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L13) |
| <code>package:flutter</code> | import | 1 | [lib/src/features/collections/key_value/klp_key_value_table.dart:1](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L1) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/features/collections/key_value"]
	n1["internal/"]
	n2["models/"]
	n3["primitives/"]
	n4["klp_key_value_table.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
	n0 -->|"contains"| n3
	n0 -->|"contains"| n4
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| `internal/` | [架構入口](internal/README.md) | [來源目錄](../../../../../../lib/src/features/collections/key_value/internal) |
| `models/` | [架構入口](models/README.md) | [來源目錄](../../../../../../lib/src/features/collections/key_value/models) |
| `primitives/` | [架構入口](primitives/README.md) | [來源目錄](../../../../../../lib/src/features/collections/key_value/primitives) |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_key_value_table.dart` | 無頂層宣告 | [架構與 API](klp_key_value_table.md) | [lib/src/features/collections/key_value/klp_key_value_table.dart:1](../../../../../../lib/src/features/collections/key_value/klp_key_value_table.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
