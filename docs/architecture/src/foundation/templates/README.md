# lib/src/foundation/templates：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/foundation/templates` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/foundation/templates"]
	n1["lib/src/composition/nodes"]
	n2["lib/src/composition/slots"]
	n3["lib/src/styling/primitives"]
	n4["lib/src/styling/semantics"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/composition/nodes</code> | import | 1 | [lib/src/foundation/templates/klp_template.dart:1](../../../../../lib/src/foundation/templates/klp_template.dart#L1) |
| <code>lib/src/composition/slots</code> | import | 1 | [lib/src/foundation/templates/klp_template.dart:2](../../../../../lib/src/foundation/templates/klp_template.dart#L2) |
| <code>lib/src/styling/primitives</code> | import | 2 | [lib/src/foundation/templates/klp_template.dart:3](../../../../../lib/src/foundation/templates/klp_template.dart#L3) |
| <code>lib/src/styling/semantics</code> | import | 2 | [lib/src/foundation/templates/klp_template.dart:4](../../../../../lib/src/foundation/templates/klp_template.dart#L4) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_children_template.dart → klp_template.dart</code> | part of | [lib/src/foundation/templates/klp_children_template.dart:1](../../../../../lib/src/foundation/templates/klp_children_template.dart#L1) |
| <code>klp_linear_template.dart → klp_template.dart</code> | part of | [lib/src/foundation/templates/klp_linear_template.dart:1](../../../../../lib/src/foundation/templates/klp_linear_template.dart#L1) |
| <code>klp_surface_template.dart → klp_template.dart</code> | part of | [lib/src/foundation/templates/klp_surface_template.dart:1](../../../../../lib/src/foundation/templates/klp_surface_template.dart#L1) |
| <code>klp_template.dart → klp_axis.dart</code> | import | [lib/src/foundation/templates/klp_template.dart:5](../../../../../lib/src/foundation/templates/klp_template.dart#L5) |
| <code>klp_template.dart → klp_text_semantics.dart</code> | import | [lib/src/foundation/templates/klp_template.dart:6](../../../../../lib/src/foundation/templates/klp_template.dart#L6) |
| <code>klp_template.dart → klp_text_template.dart</code> | part | [lib/src/foundation/templates/klp_template.dart:8](../../../../../lib/src/foundation/templates/klp_template.dart#L8) |
| <code>klp_template.dart → klp_linear_template.dart</code> | part | [lib/src/foundation/templates/klp_template.dart:9](../../../../../lib/src/foundation/templates/klp_template.dart#L9) |
| <code>klp_template.dart → klp_surface_template.dart</code> | part | [lib/src/foundation/templates/klp_template.dart:10](../../../../../lib/src/foundation/templates/klp_template.dart#L10) |
| <code>klp_template.dart → klp_children_template.dart</code> | part | [lib/src/foundation/templates/klp_template.dart:11](../../../../../lib/src/foundation/templates/klp_template.dart#L11) |
| <code>klp_text_template.dart → klp_template.dart</code> | part of | [lib/src/foundation/templates/klp_text_template.dart:1](../../../../../lib/src/foundation/templates/klp_text_template.dart#L1) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/foundation/templates"]
	n1["klp_axis.dart"]
	n2["klp_children_template.dart"]
	n3["klp_linear_template.dart"]
	n4["klp_surface_template.dart"]
	n5["klp_template.dart"]
	n6["klp_text_semantics.dart"]
	n7["klp_text_template.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
	n0 -->|"contains"| n3
	n0 -->|"contains"| n4
	n0 -->|"contains"| n5
	n0 -->|"contains"| n6
	n0 -->|"contains"| n7
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| 無 | 目前沒有下一層目錄 | — |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_axis.dart` | KlpAxis | [架構與 API](klp_axis.md) | [lib/src/foundation/templates/klp_axis.dart:1](../../../../../lib/src/foundation/templates/klp_axis.dart#L1) |
| `klp_children_template.dart` | KlpChildrenTemplate | [架構與 API](klp_children_template.md) | [lib/src/foundation/templates/klp_children_template.dart:1](../../../../../lib/src/foundation/templates/klp_children_template.dart#L1) |
| `klp_linear_template.dart` | KlpLinearTemplate | [架構與 API](klp_linear_template.md) | [lib/src/foundation/templates/klp_linear_template.dart:1](../../../../../lib/src/foundation/templates/klp_linear_template.dart#L1) |
| `klp_surface_template.dart` | KlpSurfaceTemplate | [架構與 API](klp_surface_template.md) | [lib/src/foundation/templates/klp_surface_template.dart:1](../../../../../lib/src/foundation/templates/klp_surface_template.dart#L1) |
| `klp_template.dart` | KlpTemplate | [架構與 API](klp_template.md) | [lib/src/foundation/templates/klp_template.dart:1](../../../../../lib/src/foundation/templates/klp_template.dart#L1) |
| `klp_text_semantics.dart` | KlpTextSemantics | [架構與 API](klp_text_semantics.md) | [lib/src/foundation/templates/klp_text_semantics.dart:1](../../../../../lib/src/foundation/templates/klp_text_semantics.dart#L1) |
| `klp_text_template.dart` | KlpTextTemplate | [架構與 API](klp_text_template.md) | [lib/src/foundation/templates/klp_text_template.dart:1](../../../../../lib/src/foundation/templates/klp_text_template.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
