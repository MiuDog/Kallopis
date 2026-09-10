# lib/src/features/workspace/shell/composition：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/features/workspace/shell/composition` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart TD
	n0["lib/src/features/workspace/shell/composition"]
	n1["lib/src/features/workspace/shell/composition/app_screen"]
	n2["lib/src/features/workspace/shell/composition/pane"]
	n3["lib/src/features/workspace/shell/composition/window_header"]
	n0 -->|"export"| n1
	n0 -->|"export"| n2
	n0 -->|"export"| n3
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/features/workspace/shell/composition/app_screen</code> | export | 1 | [lib/src/features/workspace/shell/composition/klp_shell_extras.dart:1](../../../../../../../lib/src/features/workspace/shell/composition/klp_shell_extras.dart#L1) |
| <code>lib/src/features/workspace/shell/composition/pane</code> | export | 1 | [lib/src/features/workspace/shell/composition/klp_shell_extras.dart:2](../../../../../../../lib/src/features/workspace/shell/composition/klp_shell_extras.dart#L2) |
| <code>lib/src/features/workspace/shell/composition/window_header</code> | export | 1 | [lib/src/features/workspace/shell/composition/klp_shell_extras.dart:3](../../../../../../../lib/src/features/workspace/shell/composition/klp_shell_extras.dart#L3) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/features/workspace/shell/composition"]
	n1["app_screen/"]
	n2["pane/"]
	n3["window_header/"]
	n4["klp_shell_extras.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
	n0 -->|"contains"| n3
	n0 -->|"contains"| n4
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| `app_screen/` | [架構入口](app_screen/README.md) | [來源目錄](../../../../../../../lib/src/features/workspace/shell/composition/app_screen) |
| `pane/` | [架構入口](pane/README.md) | [來源目錄](../../../../../../../lib/src/features/workspace/shell/composition/pane) |
| `window_header/` | [架構入口](window_header/README.md) | [來源目錄](../../../../../../../lib/src/features/workspace/shell/composition/window_header) |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_shell_extras.dart` | 無頂層宣告 | [架構與 API](klp_shell_extras.md) | [lib/src/features/workspace/shell/composition/klp_shell_extras.dart:1](../../../../../../../lib/src/features/workspace/shell/composition/klp_shell_extras.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
