# lib/src/capabilities/navigation/internal：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/capabilities/navigation/internal` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart TD
	n0["lib/src/capabilities/navigation/internal"]
	n1["dart:async"]
	n2["lib/src/capabilities/navigation"]
	n3["lib/src/capabilities/state"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>dart:async</code> | import | 1 | [lib/src/capabilities/navigation/internal/klp_navigation_machine.dart:1](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_machine.dart#L1) |
| <code>lib/src/capabilities/navigation</code> | import | 10 | [lib/src/capabilities/navigation/internal/klp_navigation_machine.dart:5](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_machine.dart#L5) |
| <code>lib/src/capabilities/state</code> | import | 2 | [lib/src/capabilities/navigation/internal/klp_navigation_machine.dart:3](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_machine.dart#L3) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_navigation_machine.dart → klp_navigation_commit_exception.dart</code> | import | [lib/src/capabilities/navigation/internal/klp_navigation_machine.dart:15](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_machine.dart#L15) |
| <code>klp_navigation_machine.dart → klp_navigation_commit_contract_exception.dart</code> | import | [lib/src/capabilities/navigation/internal/klp_navigation_machine.dart:16](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_machine.dart#L16) |
| <code>klp_navigation_machine.dart → klp_navigation_machine_operations.dart</code> | part | [lib/src/capabilities/navigation/internal/klp_navigation_machine.dart:18](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_machine.dart#L18) |
| <code>klp_navigation_machine.dart → klp_navigation_machine_transaction.dart</code> | part | [lib/src/capabilities/navigation/internal/klp_navigation_machine.dart:19](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_machine.dart#L19) |
| <code>klp_navigation_machine.dart → klp_navigation_pending.dart</code> | part | [lib/src/capabilities/navigation/internal/klp_navigation_machine.dart:20](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_machine.dart#L20) |
| <code>klp_navigation_machine.dart → klp_navigation_machine_start.dart</code> | part | [lib/src/capabilities/navigation/internal/klp_navigation_machine.dart:21](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_machine.dart#L21) |
| <code>klp_navigation_machine.dart → klp_navigation_start.dart</code> | part | [lib/src/capabilities/navigation/internal/klp_navigation_machine.dart:22](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_machine.dart#L22) |
| <code>klp_navigation_machine_operations.dart → klp_navigation_machine.dart</code> | part of | [lib/src/capabilities/navigation/internal/klp_navigation_machine_operations.dart:1](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_machine_operations.dart#L1) |
| <code>klp_navigation_machine_start.dart → klp_navigation_machine.dart</code> | part of | [lib/src/capabilities/navigation/internal/klp_navigation_machine_start.dart:1](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_machine_start.dart#L1) |
| <code>klp_navigation_machine_transaction.dart → klp_navigation_machine.dart</code> | part of | [lib/src/capabilities/navigation/internal/klp_navigation_machine_transaction.dart:1](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_machine_transaction.dart#L1) |
| <code>klp_navigation_pending.dart → klp_navigation_machine.dart</code> | part of | [lib/src/capabilities/navigation/internal/klp_navigation_pending.dart:1](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_pending.dart#L1) |
| <code>klp_navigation_start.dart → klp_navigation_machine.dart</code> | part of | [lib/src/capabilities/navigation/internal/klp_navigation_start.dart:1](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_start.dart#L1) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/capabilities/navigation/internal"]
	n1["klp_navigation_commit_contract_exception.dart"]
	n2["klp_navigation_commit_exception.dart"]
	n3["klp_navigation_machine.dart"]
	n4["klp_navigation_machine_operations.dart"]
	n5["klp_navigation_machine_start.dart"]
	n6["klp_navigation_machine_transaction.dart"]
	n7["klp_navigation_pending.dart"]
	n8["klp_navigation_start.dart"]
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
| 無 | 目前沒有下一層目錄 | — |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_navigation_commit_contract_exception.dart` | KlpNavigationCommitContractException | [架構與 API](klp_navigation_commit_contract_exception.md) | [lib/src/capabilities/navigation/internal/klp_navigation_commit_contract_exception.dart:1](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_commit_contract_exception.dart#L1) |
| `klp_navigation_commit_exception.dart` | KlpNavigationCommitException | [架構與 API](klp_navigation_commit_exception.md) | [lib/src/capabilities/navigation/internal/klp_navigation_commit_exception.dart:1](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_commit_exception.dart#L1) |
| `klp_navigation_machine.dart` | KlpNavigationMachine | [架構與 API](klp_navigation_machine.md) | [lib/src/capabilities/navigation/internal/klp_navigation_machine.dart:1](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_machine.dart#L1) |
| `klp_navigation_machine_operations.dart` | _NavigationOperations | [架構與 API](klp_navigation_machine_operations.md) | [lib/src/capabilities/navigation/internal/klp_navigation_machine_operations.dart:1](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_machine_operations.dart#L1) |
| `klp_navigation_machine_start.dart` | _startNavigation, _runInitialGuards, _awaitInitialGuard, _commitStart, _rejectStart | [架構與 API](klp_navigation_machine_start.md) | [lib/src/capabilities/navigation/internal/klp_navigation_machine_start.dart:1](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_machine_start.dart#L1) |
| `klp_navigation_machine_transaction.dart` | _NavigationTransaction | [架構與 API](klp_navigation_machine_transaction.md) | [lib/src/capabilities/navigation/internal/klp_navigation_machine_transaction.dart:1](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_machine_transaction.dart#L1) |
| `klp_navigation_pending.dart` | _NavigationPending | [架構與 API](klp_navigation_pending.md) | [lib/src/capabilities/navigation/internal/klp_navigation_pending.dart:1](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_pending.dart#L1) |
| `klp_navigation_start.dart` | KlpNavigationStart | [架構與 API](klp_navigation_start.md) | [lib/src/capabilities/navigation/internal/klp_navigation_start.dart:1](../../../../../../lib/src/capabilities/navigation/internal/klp_navigation_start.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
