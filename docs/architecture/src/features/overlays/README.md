# lib/src/features/overlays：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/features/overlays` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/features/overlays"]
	n1["lib/src/features/actions/button"]
	n2["lib/src/features/forms/toggle"]
	n3["lib/src/features/overlays/context_menu"]
	n4["lib/src/features/overlays/drawer"]
	n5["lib/src/features/overlays/menu"]
	n6["lib/src/features/overlays/popup"]
	n7["lib/src/features/overlays/primitives"]
	n8["lib/src/features/overlays/tooltip"]
	n9["lib/src/foundation"]
	n10["lib/src/foundation/content"]
	n11["lib/src/foundation/interaction"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"part"| n3
	n0 -->|"part"| n4
	n0 -->|"part"| n5
	n0 -->|"part"| n6
	n0 -->|"part"| n7
	n0 -->|"part"| n8
	n0 -->|"import"| n9
	n0 -->|"import"| n10
	n0 -->|"import"| n11
```

```mermaid
flowchart LR
	n0["lib/src/features/overlays"]
	n1["lib/src/foundation/layout"]
	n2["lib/src/foundation/surface"]
	n3["lib/src/styling/legacy_theme"]
	n4["package:flutter"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/features/actions/button</code> | import | 1 | [lib/src/features/overlays/klp_dialog.dart:3](../../../../../lib/src/features/overlays/klp_dialog.dart#L3) |
| <code>lib/src/features/forms/toggle</code> | import | 1 | [lib/src/features/overlays/klp_menu.dart:4](../../../../../lib/src/features/overlays/klp_menu.dart#L4) |
| <code>lib/src/features/overlays/context_menu</code> | part | 3 | [lib/src/features/overlays/klp_context_menu.dart:9](../../../../../lib/src/features/overlays/klp_context_menu.dart#L9) |
| <code>lib/src/features/overlays/drawer</code> | part | 2 | [lib/src/features/overlays/klp_drawer.dart:8](../../../../../lib/src/features/overlays/klp_drawer.dart#L8) |
| <code>lib/src/features/overlays/menu</code> | part | 7 | [lib/src/features/overlays/klp_menu.dart:20](../../../../../lib/src/features/overlays/klp_menu.dart#L20) |
| <code>lib/src/features/overlays/popup</code> | part | 4 | [lib/src/features/overlays/klp_popup.dart:8](../../../../../lib/src/features/overlays/klp_popup.dart#L8) |
| <code>lib/src/features/overlays/primitives</code> | part | 1 | [lib/src/features/overlays/klp_tooltip.dart:9](../../../../../lib/src/features/overlays/klp_tooltip.dart#L9) |
| <code>lib/src/features/overlays/tooltip</code> | part | 1 | [lib/src/features/overlays/klp_tooltip.dart:8](../../../../../lib/src/features/overlays/klp_tooltip.dart#L8) |
| <code>lib/src/foundation</code> | import | 2 | [lib/src/features/overlays/klp_menu.dart:5](../../../../../lib/src/features/overlays/klp_menu.dart#L5) |
| <code>lib/src/foundation/content</code> | import | 3 | [lib/src/features/overlays/klp_dialog.dart:6](../../../../../lib/src/features/overlays/klp_dialog.dart#L6) |
| <code>lib/src/foundation/interaction</code> | import | 8 | [lib/src/features/overlays/klp_context_menu.dart:4](../../../../../lib/src/features/overlays/klp_context_menu.dart#L4) |
| <code>lib/src/foundation/layout</code> | import | 6 | [lib/src/features/overlays/klp_context_menu.dart:5](../../../../../lib/src/features/overlays/klp_context_menu.dart#L5) |
| <code>lib/src/foundation/surface</code> | import | 8 | [lib/src/features/overlays/klp_dialog.dart:5](../../../../../lib/src/features/overlays/klp_dialog.dart#L5) |
| <code>lib/src/styling/legacy_theme</code> | import | 8 | [lib/src/features/overlays/klp_context_menu.dart:6](../../../../../lib/src/features/overlays/klp_context_menu.dart#L6) |
| <code>package:flutter</code> | import | 9 | [lib/src/features/overlays/klp_context_menu.dart:1](../../../../../lib/src/features/overlays/klp_context_menu.dart#L1) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_context_menu.dart → klp_menu.dart</code> | import | [lib/src/features/overlays/klp_context_menu.dart:7](../../../../../lib/src/features/overlays/klp_context_menu.dart#L7) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/features/overlays"]
	n1["context_menu/"]
	n2["drawer/"]
	n3["menu/"]
	n4["popup/"]
	n5["primitives/"]
	n6["tooltip/"]
	n7["klp_context_menu.dart"]
	n8["klp_dialog.dart"]
	n9["klp_drawer.dart"]
	n10["klp_menu.dart"]
	n11["klp_popover.dart"]
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
flowchart TD
	n0["lib/src/features/overlays"]
	n1["klp_popup.dart"]
	n2["klp_tooltip.dart"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| `context_menu/` | [架構入口](context_menu/README.md) | [來源目錄](../../../../../lib/src/features/overlays/context_menu) |
| `drawer/` | [架構入口](drawer/README.md) | [來源目錄](../../../../../lib/src/features/overlays/drawer) |
| `menu/` | [架構入口](menu/README.md) | [來源目錄](../../../../../lib/src/features/overlays/menu) |
| `popup/` | [架構入口](popup/README.md) | [來源目錄](../../../../../lib/src/features/overlays/popup) |
| `primitives/` | [架構入口](primitives/README.md) | [來源目錄](../../../../../lib/src/features/overlays/primitives) |
| `tooltip/` | [架構入口](tooltip/README.md) | [來源目錄](../../../../../lib/src/features/overlays/tooltip) |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| `klp_context_menu.dart` | 無頂層宣告 | [架構與 API](klp_context_menu.md) | [lib/src/features/overlays/klp_context_menu.dart:1](../../../../../lib/src/features/overlays/klp_context_menu.dart#L1) |
| `klp_dialog.dart` | KlpDialog | [架構與 API](klp_dialog.md) | [lib/src/features/overlays/klp_dialog.dart:1](../../../../../lib/src/features/overlays/klp_dialog.dart#L1) |
| `klp_drawer.dart` | 無頂層宣告 | [架構與 API](klp_drawer.md) | [lib/src/features/overlays/klp_drawer.dart:1](../../../../../lib/src/features/overlays/klp_drawer.dart#L1) |
| `klp_menu.dart` | 無頂層宣告 | [架構與 API](klp_menu.md) | [lib/src/features/overlays/klp_menu.dart:1](../../../../../lib/src/features/overlays/klp_menu.dart#L1) |
| `klp_popover.dart` | KlpPopover | [架構與 API](klp_popover.md) | [lib/src/features/overlays/klp_popover.dart:1](../../../../../lib/src/features/overlays/klp_popover.dart#L1) |
| `klp_popup.dart` | 無頂層宣告 | [架構與 API](klp_popup.md) | [lib/src/features/overlays/klp_popup.dart:1](../../../../../lib/src/features/overlays/klp_popup.dart#L1) |
| `klp_tooltip.dart` | 無頂層宣告 | [架構與 API](klp_tooltip.md) | [lib/src/features/overlays/klp_tooltip.dart:1](../../../../../lib/src/features/overlays/klp_tooltip.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
