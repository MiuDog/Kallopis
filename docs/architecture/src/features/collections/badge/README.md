# lib/src/features/collections/badge：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/features/collections/badge` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/features/collections/badge"]
	n1["lib/src/features/collections/badge/internal"]
	n2["lib/src/features/collections/badge/primitives"]
	n3["lib/src/features/feedback"]
	n4["lib/src/foundation/content"]
	n5["lib/src/foundation/interaction"]
	n6["lib/src/foundation/layout"]
	n7["lib/src/styling/legacy_theme"]
	n8["package:flutter"]
	n0 -->|"part"| n1
	n0 -->|"part"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
	n0 -->|"import"| n8
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/features/collections/badge/internal</code> | part | 2 | [lib/src/features/collections/badge/klp_badge.dart:12](../../../../../../lib/src/features/collections/badge/klp_badge.dart#L12) |
| <code>lib/src/features/collections/badge/primitives</code> | part | 4 | [lib/src/features/collections/badge/klp_badge.dart:14](../../../../../../lib/src/features/collections/badge/klp_badge.dart#L14) |
| <code>lib/src/features/feedback</code> | import | 1 | [lib/src/features/collections/badge/klp_badge.dart:3](../../../../../../lib/src/features/collections/badge/klp_badge.dart#L3) |
| <code>lib/src/foundation/content</code> | import | 1 | [lib/src/features/collections/badge/klp_badge.dart:7](../../../../../../lib/src/features/collections/badge/klp_badge.dart#L7) |
| <code>lib/src/foundation/interaction</code> | import | 1 | [lib/src/features/collections/badge/klp_badge.dart:4](../../../../../../lib/src/features/collections/badge/klp_badge.dart#L4) |
| <code>lib/src/foundation/layout</code> | import | 1 | [lib/src/features/collections/badge/klp_badge.dart:5](../../../../../../lib/src/features/collections/badge/klp_badge.dart#L5) |
| <code>lib/src/styling/legacy_theme</code> | import | 1 | [lib/src/features/collections/badge/klp_badge.dart:6](../../../../../../lib/src/features/collections/badge/klp_badge.dart#L6) |
| <code>package:flutter</code> | import | 1 | [lib/src/features/collections/badge/klp_badge.dart:1](../../../../../../lib/src/features/collections/badge/klp_badge.dart#L1) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_badge.dart → klp_badge_variant.dart</code> | import | [lib/src/features/collections/badge/klp_badge.dart:8](../../../../../../lib/src/features/collections/badge/klp_badge.dart#L8) |
| <code>klp_badge.dart → klp_badge_variant.dart</code> | export | [lib/src/features/collections/badge/klp_badge.dart:10](../../../../../../lib/src/features/collections/badge/klp_badge.dart#L10) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/features/collections/badge"]
	n1["internal/"]
	n2["primitives/"]
	n3["klp_badge.dart"]
	n4["klp_badge_variant.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
	n0 -->|"contains"| n3
	n0 -->|"contains"| n4
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| `internal/` | [架構入口](internal/README.md) | [來源目錄](../../../../../../lib/src/features/collections/badge/internal) |
| `primitives/` | [架構入口](primitives/README.md) | [來源目錄](../../../../../../lib/src/features/collections/badge/primitives) |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_badge.dart` | 無頂層宣告 | [架構與 API](klp_badge.md) | [lib/src/features/collections/badge/klp_badge.dart:1](../../../../../../lib/src/features/collections/badge/klp_badge.dart#L1) |
| `klp_badge_variant.dart` | KlpBadgeVariant | [架構與 API](klp_badge_variant.md) | [lib/src/features/collections/badge/klp_badge_variant.dart:1](../../../../../../lib/src/features/collections/badge/klp_badge_variant.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
