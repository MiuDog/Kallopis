# lib/src/foundation/binding/internal：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/foundation/binding/internal` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/foundation/binding/internal"]
	n1["lib/src/foundation/binding/contracts"]
	n2["lib/src/foundation/templates"]
	n3["lib/src/kernel/diagnostics"]
	n4["lib/src/kernel/identity"]
	n5["lib/src/styling/primitives"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/foundation/binding/contracts</code> | import | 3 | [lib/src/foundation/binding/internal/klp_bound_component.dart:2](../../../../../../lib/src/foundation/binding/internal/klp_bound_component.dart#L2) |
| <code>lib/src/foundation/templates</code> | import | 1 | [lib/src/foundation/binding/internal/klp_prepared_template.dart:2](../../../../../../lib/src/foundation/binding/internal/klp_prepared_template.dart#L2) |
| <code>lib/src/kernel/diagnostics</code> | import | 1 | [lib/src/foundation/binding/internal/klp_prepared_component.dart:1](../../../../../../lib/src/foundation/binding/internal/klp_prepared_component.dart#L1) |
| <code>lib/src/kernel/identity</code> | import | 2 | [lib/src/foundation/binding/internal/klp_bound_component.dart:1](../../../../../../lib/src/foundation/binding/internal/klp_bound_component.dart#L1) |
| <code>lib/src/styling/primitives</code> | import | 1 | [lib/src/foundation/binding/internal/klp_prepared_template.dart:1](../../../../../../lib/src/foundation/binding/internal/klp_prepared_template.dart#L1) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_prepared_children.dart → klp_prepared_template.dart</code> | part of | [lib/src/foundation/binding/internal/klp_prepared_children.dart:1](../../../../../../lib/src/foundation/binding/internal/klp_prepared_children.dart#L1) |
| <code>klp_prepared_component.dart → klp_bound_component.dart</code> | import | [lib/src/foundation/binding/internal/klp_prepared_component.dart:3](../../../../../../lib/src/foundation/binding/internal/klp_prepared_component.dart#L3) |
| <code>klp_prepared_component.dart → klp_prepared_template.dart</code> | import | [lib/src/foundation/binding/internal/klp_prepared_component.dart:5](../../../../../../lib/src/foundation/binding/internal/klp_prepared_component.dart#L5) |
| <code>klp_prepared_linear.dart → klp_prepared_template.dart</code> | part of | [lib/src/foundation/binding/internal/klp_prepared_linear.dart:1](../../../../../../lib/src/foundation/binding/internal/klp_prepared_linear.dart#L1) |
| <code>klp_prepared_surface.dart → klp_prepared_template.dart</code> | part of | [lib/src/foundation/binding/internal/klp_prepared_surface.dart:1](../../../../../../lib/src/foundation/binding/internal/klp_prepared_surface.dart#L1) |
| <code>klp_prepared_template.dart → klp_prepared_value.dart</code> | part | [lib/src/foundation/binding/internal/klp_prepared_template.dart:5](../../../../../../lib/src/foundation/binding/internal/klp_prepared_template.dart#L5) |
| <code>klp_prepared_template.dart → klp_prepared_linear.dart</code> | part | [lib/src/foundation/binding/internal/klp_prepared_template.dart:6](../../../../../../lib/src/foundation/binding/internal/klp_prepared_template.dart#L6) |
| <code>klp_prepared_template.dart → klp_prepared_surface.dart</code> | part | [lib/src/foundation/binding/internal/klp_prepared_template.dart:7](../../../../../../lib/src/foundation/binding/internal/klp_prepared_template.dart#L7) |
| <code>klp_prepared_template.dart → klp_prepared_children.dart</code> | part | [lib/src/foundation/binding/internal/klp_prepared_template.dart:8](../../../../../../lib/src/foundation/binding/internal/klp_prepared_template.dart#L8) |
| <code>klp_prepared_value.dart → klp_prepared_template.dart</code> | part of | [lib/src/foundation/binding/internal/klp_prepared_value.dart:1](../../../../../../lib/src/foundation/binding/internal/klp_prepared_value.dart#L1) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/foundation/binding/internal"]
	n1["klp_bound_component.dart"]
	n2["klp_component_binding_exception.dart"]
	n3["klp_prepared_children.dart"]
	n4["klp_prepared_component.dart"]
	n5["klp_prepared_linear.dart"]
	n6["klp_prepared_surface.dart"]
	n7["klp_prepared_template.dart"]
	n8["klp_prepared_value.dart"]
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
| `klp_bound_component.dart` | KlpBoundComponent | [架構與 API](klp_bound_component.md) | [lib/src/foundation/binding/internal/klp_bound_component.dart:1](../../../../../../lib/src/foundation/binding/internal/klp_bound_component.dart#L1) |
| `klp_component_binding_exception.dart` | KlpComponentBindingException | [架構與 API](klp_component_binding_exception.md) | [lib/src/foundation/binding/internal/klp_component_binding_exception.dart:1](../../../../../../lib/src/foundation/binding/internal/klp_component_binding_exception.dart#L1) |
| `klp_prepared_children.dart` | KlpPreparedChildren | [架構與 API](klp_prepared_children.md) | [lib/src/foundation/binding/internal/klp_prepared_children.dart:1](../../../../../../lib/src/foundation/binding/internal/klp_prepared_children.dart#L1) |
| `klp_prepared_component.dart` | KlpPreparedComponent | [架構與 API](klp_prepared_component.md) | [lib/src/foundation/binding/internal/klp_prepared_component.dart:1](../../../../../../lib/src/foundation/binding/internal/klp_prepared_component.dart#L1) |
| `klp_prepared_linear.dart` | KlpPreparedLinear | [架構與 API](klp_prepared_linear.md) | [lib/src/foundation/binding/internal/klp_prepared_linear.dart:1](../../../../../../lib/src/foundation/binding/internal/klp_prepared_linear.dart#L1) |
| `klp_prepared_surface.dart` | KlpPreparedSurface | [架構與 API](klp_prepared_surface.md) | [lib/src/foundation/binding/internal/klp_prepared_surface.dart:1](../../../../../../lib/src/foundation/binding/internal/klp_prepared_surface.dart#L1) |
| `klp_prepared_template.dart` | KlpPreparedTemplate | [架構與 API](klp_prepared_template.md) | [lib/src/foundation/binding/internal/klp_prepared_template.dart:1](../../../../../../lib/src/foundation/binding/internal/klp_prepared_template.dart#L1) |
| `klp_prepared_value.dart` | KlpPreparedValue | [架構與 API](klp_prepared_value.md) | [lib/src/foundation/binding/internal/klp_prepared_value.dart:1](../../../../../../lib/src/foundation/binding/internal/klp_prepared_value.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
