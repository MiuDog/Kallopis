# lib/src/features/workspace/explorer：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/features/workspace/explorer` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/features/workspace/explorer"]
	n1["dart:collection"]
	n2["lib/src/composition/nodes"]
	n3["lib/src/composition/slots"]
	n4["lib/src/features/workspace/explorer/contracts"]
	n5["lib/src/features/workspace/explorer/internal"]
	n6["lib/src/features/workspace/explorer/internal"]
	n7["lib/src/kernel/diagnostics"]
	n8["lib/src/kernel/identity"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"export"| n4
	n0 -->|"import"| n5
	n0 -->|"part"| n6
	n0 -->|"import"| n7
	n0 -->|"import"| n8
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>dart:collection</code> | import | 1 | [lib/src/features/workspace/explorer/klp_explorer_snapshot.dart:1](../../../../../../lib/src/features/workspace/explorer/klp_explorer_snapshot.dart#L1) |
| <code>lib/src/composition/nodes</code> | import | 1 | [lib/src/features/workspace/explorer/klp_explorer.dart:1](../../../../../../lib/src/features/workspace/explorer/klp_explorer.dart#L1) |
| <code>lib/src/composition/slots</code> | import | 2 | [lib/src/features/workspace/explorer/klp_explorer.dart:2](../../../../../../lib/src/features/workspace/explorer/klp_explorer.dart#L2) |
| <code>lib/src/features/workspace/explorer/contracts</code> | export | 3 | [lib/src/features/workspace/explorer/klp_explorer_model.dart:4](../../../../../../lib/src/features/workspace/explorer/klp_explorer_model.dart#L4) |
| <code>lib/src/features/workspace/explorer/internal</code> | import | 1 | [lib/src/features/workspace/explorer/klp_explorer.dart:6](../../../../../../lib/src/features/workspace/explorer/klp_explorer.dart#L6) |
| <code>lib/src/features/workspace/explorer/internal</code> | part | 1 | [lib/src/features/workspace/explorer/klp_explorer_snapshot.dart:7](../../../../../../lib/src/features/workspace/explorer/klp_explorer_snapshot.dart#L7) |
| <code>lib/src/kernel/diagnostics</code> | import | 2 | [lib/src/features/workspace/explorer/klp_explorer.dart:4](../../../../../../lib/src/features/workspace/explorer/klp_explorer.dart#L4) |
| <code>lib/src/kernel/identity</code> | import | 2 | [lib/src/features/workspace/explorer/klp_explorer.dart:5](../../../../../../lib/src/features/workspace/explorer/klp_explorer.dart#L5) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_explorer.dart → klp_explorer_model.dart</code> | import | [lib/src/features/workspace/explorer/klp_explorer.dart:7](../../../../../../lib/src/features/workspace/explorer/klp_explorer.dart#L7) |
| <code>klp_explorer.dart → klp_explorer_snapshot.dart</code> | import | [lib/src/features/workspace/explorer/klp_explorer.dart:8](../../../../../../lib/src/features/workspace/explorer/klp_explorer.dart#L8) |
| <code>klp_explorer_snapshot.dart → klp_explorer_model.dart</code> | import | [lib/src/features/workspace/explorer/klp_explorer_snapshot.dart:5](../../../../../../lib/src/features/workspace/explorer/klp_explorer_snapshot.dart#L5) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/features/workspace/explorer"]
	n1["contracts/"]
	n2["internal/"]
	n3["klp_explorer.dart"]
	n4["klp_explorer_model.dart"]
	n5["klp_explorer_snapshot.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
	n0 -->|"contains"| n3
	n0 -->|"contains"| n4
	n0 -->|"contains"| n5
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| `contracts/` | [架構入口](contracts/README.md) | [來源目錄](../../../../../../lib/src/features/workspace/explorer/contracts) |
| `internal/` | [架構入口](internal/README.md) | [來源目錄](../../../../../../lib/src/features/workspace/explorer/internal) |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_explorer.dart` | KlpExplorerData, KlpExplorer | [架構與 API](klp_explorer.md) | [lib/src/features/workspace/explorer/klp_explorer.dart:1](../../../../../../lib/src/features/workspace/explorer/klp_explorer.dart#L1) |
| `klp_explorer_model.dart` | 無頂層宣告 | [架構與 API](klp_explorer_model.md) | [lib/src/features/workspace/explorer/klp_explorer_model.dart:1](../../../../../../lib/src/features/workspace/explorer/klp_explorer_model.dart#L1) |
| `klp_explorer_snapshot.dart` | KlpExplorerItemSnapshot, KlpExplorerTreeSnapshot, KlpExplorerSnapshot | [架構與 API](klp_explorer_snapshot.md) | [lib/src/features/workspace/explorer/klp_explorer_snapshot.dart:1](../../../../../../lib/src/features/workspace/explorer/klp_explorer_snapshot.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
