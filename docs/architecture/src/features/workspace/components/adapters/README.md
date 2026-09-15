# lib/src/features/workspace/components/adapters：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/features/workspace/components/adapters` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/features/workspace/components/adapters"]
	n1["lib/src/capabilities/actions"]
	n2["lib/src/composition/definitions"]
	n3["lib/src/composition/nodes"]
	n4["lib/src/composition/validation"]
	n5["lib/src/features/workspace/components"]
	n6["lib/src/features/workspace/presentation"]
	n7["lib/src/foundation/binding/contracts"]
	n8["lib/src/kernel/diagnostics"]
	n9["lib/src/kernel/identity"]
	n10["lib/src/kernel/lifecycle"]
	n11["lib/src/runtime/contracts"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
	n0 -->|"import"| n8
	n0 -->|"import"| n9
	n0 -->|"import"| n10
	n0 -->|"import"| n11
```

```mermaid
flowchart LR
	n0["lib/src/features/workspace/components/adapters"]
	n1["lib/src/runtime/installation"]
	n2["lib/src/styling/presets/internal"]
	n3["lib/src/styling/primitives"]
	n4["lib/src/styling/references"]
	n5["lib/src/styling/resolution"]
	n6["lib/src/styling/semantics"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/capabilities/actions</code> | import | 1 | [lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart:2](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart#L2) |
| <code>lib/src/composition/definitions</code> | import | 2 | [lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart:3](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart#L3) |
| <code>lib/src/composition/nodes</code> | import | 2 | [lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart:4](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart#L4) |
| <code>lib/src/composition/validation</code> | import | 2 | [lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart:5](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart#L5) |
| <code>lib/src/features/workspace/components</code> | import | 5 | [lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart:6](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart#L6) |
| <code>lib/src/features/workspace/presentation</code> | import | 2 | [lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart:1](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart#L1) |
| <code>lib/src/foundation/binding/contracts</code> | import | 4 | [lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart:7](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart#L7) |
| <code>lib/src/kernel/diagnostics</code> | import | 1 | [lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart:9](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart#L9) |
| <code>lib/src/kernel/identity</code> | import | 3 | [lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart:10](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart#L10) |
| <code>lib/src/kernel/lifecycle</code> | import | 2 | [lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart:11](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart#L11) |
| <code>lib/src/runtime/contracts</code> | import | 8 | [lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart:12](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart#L12) |
| <code>lib/src/runtime/installation</code> | import | 2 | [lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart:15](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart#L15) |
| <code>lib/src/styling/presets/internal</code> | import | 1 | [lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart:25](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart#L25) |
| <code>lib/src/styling/primitives</code> | import | 6 | [lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart:17](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart#L17) |
| <code>lib/src/styling/references</code> | import | 2 | [lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart:20](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart#L20) |
| <code>lib/src/styling/resolution</code> | import | 2 | [lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart:21](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart#L21) |
| <code>lib/src/styling/semantics</code> | import | 6 | [lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart:22](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart#L22) |

## 目錄結構圖

```mermaid
flowchart TD
	n0["lib/src/features/workspace/components/adapters"]
	n1["klp_workspace_block_adapter.dart"]
	n2["klp_workspace_components_adapter.dart"]
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
| `klp_workspace_block_adapter.dart` | KlpWorkspaceBlockAdapter, _PreparedContent, _PreparedContentBlock, _Prepared | [架構與 API](klp_workspace_block_adapter.md) | [lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart:1](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart#L1) |
| `klp_workspace_components_adapter.dart` | KlpWorkspaceComponentsAdapter, _command, _KlpWorkspaceSemantics, _KlpWorkspaceKeys, _KlpWorkspaceStyle, _KlpPreparedExplorer, _KlpPreparedTabs, _KlpPreparedWindow, _KlpPreparedWorkspaceData | [架構與 API](klp_workspace_components_adapter.md) | [lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart:1](../../../../../../../lib/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
