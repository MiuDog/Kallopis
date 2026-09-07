# lib/src/shell/stage：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/shell/stage` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/shell/stage"]
	n1["dart:math"]
	n2["lib/src/shell/panel"]
	n3["lib/src/shell/status"]
	n4["lib/src/theme"]
	n5["lib/src/typography"]
	n6["package:flutter"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>dart:math</code> | import | 1 | [lib/src/shell/stage/klp_stage_top_bar.dart:1](../../../../../lib/src/shell/stage/klp_stage_top_bar.dart#L1) |
| <code>lib/src/shell/panel</code> | import | 1 | [lib/src/shell/stage/klp_stage_frame.dart:5](../../../../../lib/src/shell/stage/klp_stage_frame.dart#L5) |
| <code>lib/src/shell/status</code> | import | 1 | [lib/src/shell/stage/klp_stage_frame.dart:7](../../../../../lib/src/shell/stage/klp_stage_frame.dart#L7) |
| <code>lib/src/theme</code> | import | 3 | [lib/src/shell/stage/klp_stage_frame.dart:3](../../../../../lib/src/shell/stage/klp_stage_frame.dart#L3) |
| <code>lib/src/typography</code> | import | 2 | [lib/src/shell/stage/klp_stage_header.dart:4](../../../../../lib/src/shell/stage/klp_stage_header.dart#L4) |
| <code>package:flutter</code> | import | 3 | [lib/src/shell/stage/klp_stage_frame.dart:1](../../../../../lib/src/shell/stage/klp_stage_frame.dart#L1) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_stage_frame.dart → klp_stage_header.dart</code> | import | [lib/src/shell/stage/klp_stage_frame.dart:6](../../../../../lib/src/shell/stage/klp_stage_frame.dart#L6) |

## 目錄結構圖

```mermaid
flowchart TD
	n0["lib/src/shell/stage"]
	n1["klp_stage_frame.dart"]
	n2["klp_stage_header.dart"]
	n3["klp_stage_top_bar.dart"]
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
| `klp_stage_frame.dart` | KlpStageFrame | [架構與 API](klp_stage_frame.md) | [lib/src/shell/stage/klp_stage_frame.dart:1](../../../../../lib/src/shell/stage/klp_stage_frame.dart#L1) |
| `klp_stage_header.dart` | KlpStageHeader | [架構與 API](klp_stage_header.md) | [lib/src/shell/stage/klp_stage_header.dart:1](../../../../../lib/src/shell/stage/klp_stage_header.dart#L1) |
| `klp_stage_top_bar.dart` | KlpStageTopBar, KlpStageTab | [架構與 API](klp_stage_top_bar.md) | [lib/src/shell/stage/klp_stage_top_bar.dart:1](../../../../../lib/src/shell/stage/klp_stage_top_bar.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
