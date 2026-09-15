# lib/src/foundation/binding/contracts：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/foundation/binding/contracts` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/foundation/binding/contracts"]
	n1["dart:async"]
	n2["lib/src/capabilities/state"]
	n3["lib/src/foundation/templates"]
	n4["lib/src/kernel/identity"]
	n5["lib/src/styling/primitives"]
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
| <code>dart:async</code> | import | 1 | [lib/src/foundation/binding/contracts/klp_bound_template.dart:1](../../../../../../lib/src/foundation/binding/contracts/klp_bound_template.dart#L1) |
| <code>lib/src/capabilities/state</code> | import | 1 | [lib/src/foundation/binding/contracts/klp_bound_template.dart:4](../../../../../../lib/src/foundation/binding/contracts/klp_bound_template.dart#L4) |
| <code>lib/src/foundation/templates</code> | import | 1 | [lib/src/foundation/binding/contracts/klp_bound_template.dart:5](../../../../../../lib/src/foundation/binding/contracts/klp_bound_template.dart#L5) |
| <code>lib/src/kernel/identity</code> | import | 1 | [lib/src/foundation/binding/contracts/klp_bound_template.dart:3](../../../../../../lib/src/foundation/binding/contracts/klp_bound_template.dart#L3) |
| <code>lib/src/styling/primitives</code> | import | 4 | [lib/src/foundation/binding/contracts/klp_bound_choice_style.dart:1](../../../../../../lib/src/foundation/binding/contracts/klp_bound_choice_style.dart#L1) |
| <code>lib/src/styling/semantics</code> | import | 1 | [lib/src/foundation/binding/contracts/klp_bound_control_style.dart:2](../../../../../../lib/src/foundation/binding/contracts/klp_bound_control_style.dart#L2) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_bound_accessibility.dart → klp_bound_template.dart</code> | part of | [lib/src/foundation/binding/contracts/klp_bound_accessibility.dart:1](../../../../../../lib/src/foundation/binding/contracts/klp_bound_accessibility.dart#L1) |
| <code>klp_bound_choice.dart → klp_bound_template.dart</code> | part of | [lib/src/foundation/binding/contracts/klp_bound_choice.dart:1](../../../../../../lib/src/foundation/binding/contracts/klp_bound_choice.dart#L1) |
| <code>klp_bound_control_style.dart → klp_bound_text_style.dart</code> | import | [lib/src/foundation/binding/contracts/klp_bound_control_style.dart:3](../../../../../../lib/src/foundation/binding/contracts/klp_bound_control_style.dart#L3) |
| <code>klp_bound_extent.dart → klp_bound_template.dart</code> | part of | [lib/src/foundation/binding/contracts/klp_bound_extent.dart:1](../../../../../../lib/src/foundation/binding/contracts/klp_bound_extent.dart#L1) |
| <code>klp_bound_linear.dart → klp_bound_template.dart</code> | part of | [lib/src/foundation/binding/contracts/klp_bound_linear.dart:1](../../../../../../lib/src/foundation/binding/contracts/klp_bound_linear.dart#L1) |
| <code>klp_bound_placement.dart → klp_bound_template.dart</code> | part of | [lib/src/foundation/binding/contracts/klp_bound_placement.dart:1](../../../../../../lib/src/foundation/binding/contracts/klp_bound_placement.dart#L1) |
| <code>klp_bound_regions.dart → klp_bound_template.dart</code> | part of | [lib/src/foundation/binding/contracts/klp_bound_regions.dart:1](../../../../../../lib/src/foundation/binding/contracts/klp_bound_regions.dart#L1) |
| <code>klp_bound_retained_stack.dart → klp_bound_template.dart</code> | part of | [lib/src/foundation/binding/contracts/klp_bound_retained_stack.dart:1](../../../../../../lib/src/foundation/binding/contracts/klp_bound_retained_stack.dart#L1) |
| <code>klp_bound_screen.dart → klp_bound_template.dart</code> | part of | [lib/src/foundation/binding/contracts/klp_bound_screen.dart:1](../../../../../../lib/src/foundation/binding/contracts/klp_bound_screen.dart#L1) |
| <code>klp_bound_surface.dart → klp_bound_template.dart</code> | part of | [lib/src/foundation/binding/contracts/klp_bound_surface.dart:1](../../../../../../lib/src/foundation/binding/contracts/klp_bound_surface.dart#L1) |
| <code>klp_bound_surface_shadow.dart → klp_bound_template.dart</code> | part of | [lib/src/foundation/binding/contracts/klp_bound_surface_shadow.dart:1](../../../../../../lib/src/foundation/binding/contracts/klp_bound_surface_shadow.dart#L1) |
| <code>klp_bound_template.dart → klp_bound_text_style.dart</code> | import | [lib/src/foundation/binding/contracts/klp_bound_template.dart:6](../../../../../../lib/src/foundation/binding/contracts/klp_bound_template.dart#L6) |
| <code>klp_bound_template.dart → klp_bound_choice_style.dart</code> | import | [lib/src/foundation/binding/contracts/klp_bound_template.dart:7](../../../../../../lib/src/foundation/binding/contracts/klp_bound_template.dart#L7) |
| <code>klp_bound_template.dart → klp_bound_text.dart</code> | part | [lib/src/foundation/binding/contracts/klp_bound_template.dart:9](../../../../../../lib/src/foundation/binding/contracts/klp_bound_template.dart#L9) |
| <code>klp_bound_template.dart → klp_bound_linear.dart</code> | part | [lib/src/foundation/binding/contracts/klp_bound_template.dart:10](../../../../../../lib/src/foundation/binding/contracts/klp_bound_template.dart#L10) |
| <code>klp_bound_template.dart → klp_bound_surface.dart</code> | part | [lib/src/foundation/binding/contracts/klp_bound_template.dart:11](../../../../../../lib/src/foundation/binding/contracts/klp_bound_template.dart#L11) |
| <code>klp_bound_template.dart → klp_bound_surface_shadow.dart</code> | part | [lib/src/foundation/binding/contracts/klp_bound_template.dart:12](../../../../../../lib/src/foundation/binding/contracts/klp_bound_template.dart#L12) |
| <code>klp_bound_template.dart → klp_bound_choice.dart</code> | part | [lib/src/foundation/binding/contracts/klp_bound_template.dart:13](../../../../../../lib/src/foundation/binding/contracts/klp_bound_template.dart#L13) |
| <code>klp_bound_template.dart → klp_bound_regions.dart</code> | part | [lib/src/foundation/binding/contracts/klp_bound_template.dart:14](../../../../../../lib/src/foundation/binding/contracts/klp_bound_template.dart#L14) |
| <code>klp_bound_template.dart → klp_bound_extent.dart</code> | part | [lib/src/foundation/binding/contracts/klp_bound_template.dart:15](../../../../../../lib/src/foundation/binding/contracts/klp_bound_template.dart#L15) |
| <code>klp_bound_template.dart → klp_bound_placement.dart</code> | part | [lib/src/foundation/binding/contracts/klp_bound_template.dart:16](../../../../../../lib/src/foundation/binding/contracts/klp_bound_template.dart#L16) |
| <code>klp_bound_template.dart → klp_bound_retained_stack.dart</code> | part | [lib/src/foundation/binding/contracts/klp_bound_template.dart:17](../../../../../../lib/src/foundation/binding/contracts/klp_bound_template.dart#L17) |
| <code>klp_bound_template.dart → klp_bound_screen.dart</code> | part | [lib/src/foundation/binding/contracts/klp_bound_template.dart:18](../../../../../../lib/src/foundation/binding/contracts/klp_bound_template.dart#L18) |
| <code>klp_bound_template.dart → klp_bound_accessibility.dart</code> | part | [lib/src/foundation/binding/contracts/klp_bound_template.dart:19](../../../../../../lib/src/foundation/binding/contracts/klp_bound_template.dart#L19) |
| <code>klp_bound_text.dart → klp_bound_template.dart</code> | part of | [lib/src/foundation/binding/contracts/klp_bound_text.dart:1](../../../../../../lib/src/foundation/binding/contracts/klp_bound_text.dart#L1) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/foundation/binding/contracts"]
	n1["klp_bound_accessibility.dart"]
	n2["klp_bound_choice.dart"]
	n3["klp_bound_choice_style.dart"]
	n4["klp_bound_control_style.dart"]
	n5["klp_bound_extent.dart"]
	n6["klp_bound_linear.dart"]
	n7["klp_bound_placement.dart"]
	n8["klp_bound_regions.dart"]
	n9["klp_bound_retained_stack.dart"]
	n10["klp_bound_screen.dart"]
	n11["klp_bound_surface.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
	n0 -->|"contains"| n3
	n0 -->|"contains"| n4
	n0 -->|"contains"| n5
	n0 -->|"contains"| n6
	n0 -->|"contains"| n7
	n0 -->|"contains"| n8
	n0 -->|"contains"| n9
	n0 -->|"contains"| n10
	n0 -->|"contains"| n11
```

```mermaid
flowchart LR
	n0["lib/src/foundation/binding/contracts"]
	n1["klp_bound_surface_shadow.dart"]
	n2["klp_bound_template.dart"]
	n3["klp_bound_text.dart"]
	n4["klp_bound_text_style.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
	n0 -->|"contains"| n3
	n0 -->|"contains"| n4
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| 無 | 目前沒有下一層目錄 | — |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_bound_accessibility.dart` | KlpBoundAccessibility | [架構與 API](klp_bound_accessibility.md) | [lib/src/foundation/binding/contracts/klp_bound_accessibility.dart:1](../../../../../../lib/src/foundation/binding/contracts/klp_bound_accessibility.dart#L1) |
| `klp_bound_choice.dart` | KlpBoundChoice | [架構與 API](klp_bound_choice.md) | [lib/src/foundation/binding/contracts/klp_bound_choice.dart:1](../../../../../../lib/src/foundation/binding/contracts/klp_bound_choice.dart#L1) |
| `klp_bound_choice_style.dart` | KlpBoundChoiceStyle | [架構與 API](klp_bound_choice_style.md) | [lib/src/foundation/binding/contracts/klp_bound_choice_style.dart:1](../../../../../../lib/src/foundation/binding/contracts/klp_bound_choice_style.dart#L1) |
| `klp_bound_control_style.dart` | KlpBoundControlStyle | [架構與 API](klp_bound_control_style.md) | [lib/src/foundation/binding/contracts/klp_bound_control_style.dart:1](../../../../../../lib/src/foundation/binding/contracts/klp_bound_control_style.dart#L1) |
| `klp_bound_extent.dart` | KlpBoundExtent | [架構與 API](klp_bound_extent.md) | [lib/src/foundation/binding/contracts/klp_bound_extent.dart:1](../../../../../../lib/src/foundation/binding/contracts/klp_bound_extent.dart#L1) |
| `klp_bound_linear.dart` | KlpBoundLinear | [架構與 API](klp_bound_linear.md) | [lib/src/foundation/binding/contracts/klp_bound_linear.dart:1](../../../../../../lib/src/foundation/binding/contracts/klp_bound_linear.dart#L1) |
| `klp_bound_placement.dart` | KlpBoundPlacement | [架構與 API](klp_bound_placement.md) | [lib/src/foundation/binding/contracts/klp_bound_placement.dart:1](../../../../../../lib/src/foundation/binding/contracts/klp_bound_placement.dart#L1) |
| `klp_bound_regions.dart` | KlpBoundRegions | [架構與 API](klp_bound_regions.md) | [lib/src/foundation/binding/contracts/klp_bound_regions.dart:1](../../../../../../lib/src/foundation/binding/contracts/klp_bound_regions.dart#L1) |
| `klp_bound_retained_stack.dart` | KlpBoundRetainedStack | [架構與 API](klp_bound_retained_stack.md) | [lib/src/foundation/binding/contracts/klp_bound_retained_stack.dart:1](../../../../../../lib/src/foundation/binding/contracts/klp_bound_retained_stack.dart#L1) |
| `klp_bound_screen.dart` | KlpBoundScreen | [架構與 API](klp_bound_screen.md) | [lib/src/foundation/binding/contracts/klp_bound_screen.dart:1](../../../../../../lib/src/foundation/binding/contracts/klp_bound_screen.dart#L1) |
| `klp_bound_surface.dart` | KlpBoundSurface | [架構與 API](klp_bound_surface.md) | [lib/src/foundation/binding/contracts/klp_bound_surface.dart:1](../../../../../../lib/src/foundation/binding/contracts/klp_bound_surface.dart#L1) |
| `klp_bound_surface_shadow.dart` | KlpBoundSurfaceShadow | [架構與 API](klp_bound_surface_shadow.md) | [lib/src/foundation/binding/contracts/klp_bound_surface_shadow.dart:1](../../../../../../lib/src/foundation/binding/contracts/klp_bound_surface_shadow.dart#L1) |
| `klp_bound_template.dart` | KlpBoundTemplate | [架構與 API](klp_bound_template.md) | [lib/src/foundation/binding/contracts/klp_bound_template.dart:1](../../../../../../lib/src/foundation/binding/contracts/klp_bound_template.dart#L1) |
| `klp_bound_text.dart` | KlpBoundText | [架構與 API](klp_bound_text.md) | [lib/src/foundation/binding/contracts/klp_bound_text.dart:1](../../../../../../lib/src/foundation/binding/contracts/klp_bound_text.dart#L1) |
| `klp_bound_text_style.dart` | KlpBoundTextStyle | [架構與 API](klp_bound_text_style.md) | [lib/src/foundation/binding/contracts/klp_bound_text_style.dart:1](../../../../../../lib/src/foundation/binding/contracts/klp_bound_text_style.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
