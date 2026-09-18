# lib/src/composition/nodes：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/composition/nodes` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/composition/nodes"]
	n1["lib/src/capabilities/environment"]
	n2["lib/src/composition/definitions"]
	n3["lib/src/composition/slots"]
	n4["lib/src/kernel/identity"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/capabilities/environment</code> | import | 3 | [lib/src/composition/nodes/klp_platform_strategy.dart:2](../../../../../lib/src/composition/nodes/klp_platform_strategy.dart#L2) |
| <code>lib/src/composition/definitions</code> | import | 1 | [lib/src/composition/nodes/klp_scope_boundary.dart:2](../../../../../lib/src/composition/nodes/klp_scope_boundary.dart#L2) |
| <code>lib/src/composition/slots</code> | import | 6 | [lib/src/composition/nodes/klp_adaptive.dart:2](../../../../../lib/src/composition/nodes/klp_adaptive.dart#L2) |
| <code>lib/src/kernel/identity</code> | import | 3 | [lib/src/composition/nodes/klp_adaptive.dart:1](../../../../../lib/src/composition/nodes/klp_adaptive.dart#L1) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_adaptive.dart → klp_composite_node.dart</code> | import | [lib/src/composition/nodes/klp_adaptive.dart:5](../../../../../lib/src/composition/nodes/klp_adaptive.dart#L5) |
| <code>klp_adaptive.dart → klp_platform_strategy.dart</code> | import | [lib/src/composition/nodes/klp_adaptive.dart:6](../../../../../lib/src/composition/nodes/klp_adaptive.dart#L6) |
| <code>klp_composite_node.dart → klp_node.dart</code> | import | [lib/src/composition/nodes/klp_composite_node.dart:2](../../../../../lib/src/composition/nodes/klp_composite_node.dart#L2) |
| <code>klp_platform_strategy.dart → package:kallopis/src/composition/nodes/klp_composite_node.dart</code> | import | [lib/src/composition/nodes/klp_platform_strategy.dart:1](../../../../../lib/src/composition/nodes/klp_platform_strategy.dart#L1) |
| <code>klp_scope_boundary.dart → package:kallopis/src/composition/nodes/klp_composite_node.dart</code> | import | [lib/src/composition/nodes/klp_scope_boundary.dart:5](../../../../../lib/src/composition/nodes/klp_scope_boundary.dart#L5) |
| <code>klp_scope_boundary.dart → package:kallopis/src/composition/nodes/klp_node.dart</code> | import | [lib/src/composition/nodes/klp_scope_boundary.dart:6](../../../../../lib/src/composition/nodes/klp_scope_boundary.dart#L6) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/composition/nodes"]
	n1["internal/"]
	n2["klp_adaptive.dart"]
	n3["klp_composite_node.dart"]
	n4["klp_node.dart"]
	n5["klp_platform_strategy.dart"]
	n6["klp_scope_boundary.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
	n0 -->|"contains"| n3
	n0 -->|"contains"| n4
	n0 -->|"contains"| n5
	n0 -->|"contains"| n6
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| `internal/` | [架構入口](internal/README.md) | [來源目錄](../../../../../lib/src/composition/nodes/internal) |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_adaptive.dart` | KlpAdaptive | [架構與 API](klp_adaptive.md) | [lib/src/composition/nodes/klp_adaptive.dart:1](../../../../../lib/src/composition/nodes/klp_adaptive.dart#L1) |
| `klp_composite_node.dart` | KlpCompositeNode | [架構與 API](klp_composite_node.md) | [lib/src/composition/nodes/klp_composite_node.dart:1](../../../../../lib/src/composition/nodes/klp_composite_node.dart#L1) |
| `klp_node.dart` | KlpNode | [架構與 API](klp_node.md) | [lib/src/composition/nodes/klp_node.dart:1](../../../../../lib/src/composition/nodes/klp_node.dart#L1) |
| `klp_platform_strategy.dart` | KlpAdaptiveContext, KlpPlatformStrategy, KlpAdaptivePlatform | [架構與 API](klp_platform_strategy.md) | [lib/src/composition/nodes/klp_platform_strategy.dart:1](../../../../../lib/src/composition/nodes/klp_platform_strategy.dart#L1) |
| `klp_scope_boundary.dart` | KlpScopeBoundary | [架構與 API](klp_scope_boundary.md) | [lib/src/composition/nodes/klp_scope_boundary.dart:1](../../../../../lib/src/composition/nodes/klp_scope_boundary.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
