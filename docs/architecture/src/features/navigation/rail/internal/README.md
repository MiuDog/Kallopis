# lib/src/features/navigation/rail/internal：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/features/navigation/rail/internal` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/features/navigation/rail/internal"]
	n1["lib/src/capabilities/actions"]
	n2["lib/src/capabilities/controllers"]
	n3["lib/src/capabilities/state"]
	n4["lib/src/composition/definitions"]
	n5["lib/src/composition/nodes"]
	n6["lib/src/composition/validation"]
	n7["lib/src/features/navigation/rail/contracts"]
	n8["lib/src/foundation/binding/internal"]
	n9["lib/src/foundation/templates"]
	n10["lib/src/kernel/diagnostics"]
	n11["lib/src/kernel/identity"]
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
	n0["lib/src/features/navigation/rail/internal"]
	n1["lib/src/kernel/lifecycle/internal"]
	n2["lib/src/runtime/compilation/internal"]
	n3["lib/src/runtime/installation/internal"]
	n4["lib/src/styling/primitives"]
	n5["lib/src/styling/references"]
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
| <code>lib/src/capabilities/actions</code> | import | 6 | [lib/src/features/navigation/rail/internal/klp_prepared_rail.dart:10](../../../../../../../lib/src/features/navigation/rail/internal/klp_prepared_rail.dart#L10) |
| <code>lib/src/capabilities/controllers</code> | import | 1 | [lib/src/features/navigation/rail/internal/klp_rail_placement.dart:1](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_placement.dart#L1) |
| <code>lib/src/capabilities/state</code> | import | 2 | [lib/src/features/navigation/rail/internal/klp_rail_placement.dart:2](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_placement.dart#L2) |
| <code>lib/src/composition/definitions</code> | import | 1 | [lib/src/features/navigation/rail/internal/klp_rail_adapter.dart:1](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_adapter.dart#L1) |
| <code>lib/src/composition/nodes</code> | import | 1 | [lib/src/features/navigation/rail/internal/klp_rail_adapter.dart:2](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_adapter.dart#L2) |
| <code>lib/src/composition/validation</code> | import | 3 | [lib/src/features/navigation/rail/internal/klp_prepared_rail.dart:1](../../../../../../../lib/src/features/navigation/rail/internal/klp_prepared_rail.dart#L1) |
| <code>lib/src/features/navigation/rail/contracts</code> | import | 3 | [lib/src/features/navigation/rail/internal/klp_rail_adapter.dart:13](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_adapter.dart#L13) |
| <code>lib/src/foundation/binding/internal</code> | import | 3 | [lib/src/features/navigation/rail/internal/klp_prepared_rail.dart:2](../../../../../../../lib/src/features/navigation/rail/internal/klp_prepared_rail.dart#L2) |
| <code>lib/src/foundation/templates</code> | import | 1 | [lib/src/features/navigation/rail/internal/klp_prepared_rail.dart:4](../../../../../../../lib/src/features/navigation/rail/internal/klp_prepared_rail.dart#L4) |
| <code>lib/src/kernel/diagnostics</code> | import | 1 | [lib/src/features/navigation/rail/internal/klp_rail_adapter.dart:5](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_adapter.dart#L5) |
| <code>lib/src/kernel/identity</code> | import | 3 | [lib/src/features/navigation/rail/internal/klp_prepared_rail.dart:6](../../../../../../../lib/src/features/navigation/rail/internal/klp_prepared_rail.dart#L6) |
| <code>lib/src/kernel/lifecycle/internal</code> | import | 1 | [lib/src/features/navigation/rail/internal/klp_prepared_rail.dart:5](../../../../../../../lib/src/features/navigation/rail/internal/klp_prepared_rail.dart#L5) |
| <code>lib/src/runtime/compilation/internal</code> | import | 4 | [lib/src/features/navigation/rail/internal/klp_prepared_rail.dart:7](../../../../../../../lib/src/features/navigation/rail/internal/klp_prepared_rail.dart#L7) |
| <code>lib/src/runtime/installation/internal</code> | import | 2 | [lib/src/features/navigation/rail/internal/klp_prepared_rail.dart:8](../../../../../../../lib/src/features/navigation/rail/internal/klp_prepared_rail.dart#L8) |
| <code>lib/src/styling/primitives</code> | import | 5 | [lib/src/features/navigation/rail/internal/klp_prepared_rail.dart:9](../../../../../../../lib/src/features/navigation/rail/internal/klp_prepared_rail.dart#L9) |
| <code>lib/src/styling/references</code> | import | 1 | [lib/src/features/navigation/rail/internal/klp_rail_semantics.dart:4](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_semantics.dart#L4) |
| <code>lib/src/styling/semantics</code> | import | 3 | [lib/src/features/navigation/rail/internal/klp_rail_semantics.dart:5](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_semantics.dart#L5) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_prepared_rail.dart → klp_rail_placement.dart</code> | import | [lib/src/features/navigation/rail/internal/klp_prepared_rail.dart:12](../../../../../../../lib/src/features/navigation/rail/internal/klp_prepared_rail.dart#L12) |
| <code>klp_rail_adapter.dart → klp_prepared_rail.dart</code> | import | [lib/src/features/navigation/rail/internal/klp_rail_adapter.dart:15](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_adapter.dart#L15) |
| <code>klp_rail_adapter.dart → klp_rail_semantics.dart</code> | import | [lib/src/features/navigation/rail/internal/klp_rail_adapter.dart:16](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_adapter.dart#L16) |
| <code>klp_rail_placement.dart → klp_rail_activation_exception.dart</code> | import | [lib/src/features/navigation/rail/internal/klp_rail_placement.dart:7](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_placement.dart#L7) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/features/navigation/rail/internal"]
	n1["klp_prepared_rail.dart"]
	n2["klp_rail_activation_exception.dart"]
	n3["klp_rail_adapter.dart"]
	n4["klp_rail_placement.dart"]
	n5["klp_rail_semantics.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
	n0 -->|"contains"| n3
	n0 -->|"contains"| n4
	n0 -->|"contains"| n5
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| 無 | 目前沒有下一層目錄 | — |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_prepared_rail.dart` | KlpPreparedRail | [架構與 API](klp_prepared_rail.md) | [lib/src/features/navigation/rail/internal/klp_prepared_rail.dart:1](../../../../../../../lib/src/features/navigation/rail/internal/klp_prepared_rail.dart#L1) |
| `klp_rail_activation_exception.dart` | KlpRailActivationException | [架構與 API](klp_rail_activation_exception.md) | [lib/src/features/navigation/rail/internal/klp_rail_activation_exception.dart:1](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_activation_exception.dart#L1) |
| `klp_rail_adapter.dart` | KlpRailAdapter | [架構與 API](klp_rail_adapter.md) | [lib/src/features/navigation/rail/internal/klp_rail_adapter.dart:1](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_adapter.dart#L1) |
| `klp_rail_placement.dart` | KlpRailPlacement | [架構與 API](klp_rail_placement.md) | [lib/src/features/navigation/rail/internal/klp_rail_placement.dart:1](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_placement.dart#L1) |
| `klp_rail_semantics.dart` | KlpRailSemantics | [架構與 API](klp_rail_semantics.md) | [lib/src/features/navigation/rail/internal/klp_rail_semantics.dart:1](../../../../../../../lib/src/features/navigation/rail/internal/klp_rail_semantics.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
