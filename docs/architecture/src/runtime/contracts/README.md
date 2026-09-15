# lib/src/runtime/contracts：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/runtime/contracts` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/runtime/contracts"]
	n1["lib/src/capabilities/actions"]
	n2["lib/src/composition/definitions"]
	n3["lib/src/composition/nodes"]
	n4["lib/src/composition/validation"]
	n5["lib/src/foundation/binding/contracts"]
	n6["lib/src/kernel/identity"]
	n7["lib/src/kernel/lifecycle"]
	n8["lib/src/styling/primitives"]
	n9["lib/src/styling/resolution"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
	n0 -->|"import"| n8
	n0 -->|"import"| n9
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/capabilities/actions</code> | import | 1 | [lib/src/runtime/contracts/klp_prepare_context.dart:6](../../../../../lib/src/runtime/contracts/klp_prepare_context.dart#L6) |
| <code>lib/src/composition/definitions</code> | import | 1 | [lib/src/runtime/contracts/klp_node_adapter.dart:1](../../../../../lib/src/runtime/contracts/klp_node_adapter.dart#L1) |
| <code>lib/src/composition/nodes</code> | import | 2 | [lib/src/runtime/contracts/klp_node_adapter.dart:2](../../../../../lib/src/runtime/contracts/klp_node_adapter.dart#L2) |
| <code>lib/src/composition/validation</code> | import | 4 | [lib/src/runtime/contracts/klp_node_adapter.dart:3](../../../../../lib/src/runtime/contracts/klp_node_adapter.dart#L3) |
| <code>lib/src/foundation/binding/contracts</code> | import | 2 | [lib/src/runtime/contracts/klp_prepared_node.dart:2](../../../../../lib/src/runtime/contracts/klp_prepared_node.dart#L2) |
| <code>lib/src/kernel/identity</code> | import | 2 | [lib/src/runtime/contracts/klp_prepare_context.dart:3](../../../../../lib/src/runtime/contracts/klp_prepare_context.dart#L3) |
| <code>lib/src/kernel/lifecycle</code> | import | 2 | [lib/src/runtime/contracts/klp_prepared_node.dart:3](../../../../../lib/src/runtime/contracts/klp_prepared_node.dart#L3) |
| <code>lib/src/styling/primitives</code> | import | 1 | [lib/src/runtime/contracts/klp_prepare_context.dart:4](../../../../../lib/src/runtime/contracts/klp_prepare_context.dart#L4) |
| <code>lib/src/styling/resolution</code> | import | 1 | [lib/src/runtime/contracts/klp_prepare_context.dart:5](../../../../../lib/src/runtime/contracts/klp_prepare_context.dart#L5) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_node_adapter.dart → package:kallopis/src/runtime/contracts/klp_prepare_context.dart</code> | import | [lib/src/runtime/contracts/klp_node_adapter.dart:4](../../../../../lib/src/runtime/contracts/klp_node_adapter.dart#L4) |
| <code>klp_node_adapter.dart → package:kallopis/src/runtime/contracts/klp_prepared_node.dart</code> | import | [lib/src/runtime/contracts/klp_node_adapter.dart:5](../../../../../lib/src/runtime/contracts/klp_node_adapter.dart#L5) |
| <code>klp_prepared_node.dart → package:kallopis/src/runtime/contracts/klp_placement_resource.dart</code> | import | [lib/src/runtime/contracts/klp_prepared_node.dart:4](../../../../../lib/src/runtime/contracts/klp_prepared_node.dart#L4) |
| <code>klp_prepared_resource_policy.dart → package:kallopis/src/runtime/contracts/klp_placement_resource.dart</code> | import | [lib/src/runtime/contracts/klp_prepared_resource_policy.dart:1](../../../../../lib/src/runtime/contracts/klp_prepared_resource_policy.dart#L1) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/runtime/contracts"]
	n1["klp_installation_exception.dart"]
	n2["klp_node_adapter.dart"]
	n3["klp_placement_resource.dart"]
	n4["klp_prepare_context.dart"]
	n5["klp_prepared_activation_policy.dart"]
	n6["klp_prepared_node.dart"]
	n7["klp_prepared_resource_policy.dart"]
	n8["klp_runtime_frame.dart"]
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
| `klp_installation_exception.dart` | KlpInstallationException | [架構與 API](klp_installation_exception.md) | [lib/src/runtime/contracts/klp_installation_exception.dart:1](../../../../../lib/src/runtime/contracts/klp_installation_exception.dart#L1) |
| `klp_node_adapter.dart` | KlpNodeAdapter | [架構與 API](klp_node_adapter.md) | [lib/src/runtime/contracts/klp_node_adapter.dart:1](../../../../../lib/src/runtime/contracts/klp_node_adapter.dart#L1) |
| `klp_placement_resource.dart` | KlpPlacementResource | [架構與 API](klp_placement_resource.md) | [lib/src/runtime/contracts/klp_placement_resource.dart:1](../../../../../lib/src/runtime/contracts/klp_placement_resource.dart#L1) |
| `klp_prepare_context.dart` | KlpPrepareContext | [架構與 API](klp_prepare_context.md) | [lib/src/runtime/contracts/klp_prepare_context.dart:1](../../../../../lib/src/runtime/contracts/klp_prepare_context.dart#L1) |
| `klp_prepared_activation_policy.dart` | KlpPreparedActivationPolicy | [架構與 API](klp_prepared_activation_policy.md) | [lib/src/runtime/contracts/klp_prepared_activation_policy.dart:1](../../../../../lib/src/runtime/contracts/klp_prepared_activation_policy.dart#L1) |
| `klp_prepared_node.dart` | KlpPreparedNode | [架構與 API](klp_prepared_node.md) | [lib/src/runtime/contracts/klp_prepared_node.dart:1](../../../../../lib/src/runtime/contracts/klp_prepared_node.dart#L1) |
| `klp_prepared_resource_policy.dart` | KlpPreparedResourcePolicy | [架構與 API](klp_prepared_resource_policy.md) | [lib/src/runtime/contracts/klp_prepared_resource_policy.dart:1](../../../../../lib/src/runtime/contracts/klp_prepared_resource_policy.dart#L1) |
| `klp_runtime_frame.dart` | KlpRuntimeFrame | [架構與 API](klp_runtime_frame.md) | [lib/src/runtime/contracts/klp_runtime_frame.dart:1](../../../../../lib/src/runtime/contracts/klp_runtime_frame.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
