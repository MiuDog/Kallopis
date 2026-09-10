# lib/src/features/navigation/legacy_router：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/features/navigation/legacy_router` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart TD
	n0["lib/src/features/navigation/legacy_router"]
	n1["lib/src/foundation/layout"]
	n2["package:flutter"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/foundation/layout</code> | import | 1 | [lib/src/features/navigation/legacy_router/klp_router.dart:3](../../../../../../lib/src/features/navigation/legacy_router/klp_router.dart#L3) |
| <code>package:flutter</code> | import | 1 | [lib/src/features/navigation/legacy_router/klp_router.dart:1](../../../../../../lib/src/features/navigation/legacy_router/klp_router.dart#L1) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_panel_layout_builder.dart → klp_router.dart</code> | part of | [lib/src/features/navigation/legacy_router/klp_panel_layout_builder.dart:1](../../../../../../lib/src/features/navigation/legacy_router/klp_panel_layout_builder.dart#L1) |
| <code>klp_route.dart → klp_router.dart</code> | part of | [lib/src/features/navigation/legacy_router/klp_route.dart:1](../../../../../../lib/src/features/navigation/legacy_router/klp_route.dart#L1) |
| <code>klp_route_not_found.dart → klp_router.dart</code> | part of | [lib/src/features/navigation/legacy_router/klp_route_not_found.dart:1](../../../../../../lib/src/features/navigation/legacy_router/klp_route_not_found.dart#L1) |
| <code>klp_router.dart → klp_panel_layout_builder.dart</code> | part | [lib/src/features/navigation/legacy_router/klp_router.dart:5](../../../../../../lib/src/features/navigation/legacy_router/klp_router.dart#L5) |
| <code>klp_router.dart → klp_route.dart</code> | part | [lib/src/features/navigation/legacy_router/klp_router.dart:6](../../../../../../lib/src/features/navigation/legacy_router/klp_router.dart#L6) |
| <code>klp_router.dart → klp_route_not_found.dart</code> | part | [lib/src/features/navigation/legacy_router/klp_router.dart:7](../../../../../../lib/src/features/navigation/legacy_router/klp_router.dart#L7) |
| <code>klp_router.dart → klp_router_context.dart</code> | part | [lib/src/features/navigation/legacy_router/klp_router.dart:8](../../../../../../lib/src/features/navigation/legacy_router/klp_router.dart#L8) |
| <code>klp_router.dart → klp_router_controller.dart</code> | part | [lib/src/features/navigation/legacy_router/klp_router.dart:9](../../../../../../lib/src/features/navigation/legacy_router/klp_router.dart#L9) |
| <code>klp_router.dart → klp_router_outlet.dart</code> | part | [lib/src/features/navigation/legacy_router/klp_router.dart:10](../../../../../../lib/src/features/navigation/legacy_router/klp_router.dart#L10) |
| <code>klp_router.dart → klp_router_scope.dart</code> | part | [lib/src/features/navigation/legacy_router/klp_router.dart:11](../../../../../../lib/src/features/navigation/legacy_router/klp_router.dart#L11) |
| <code>klp_router_context.dart → klp_router.dart</code> | part of | [lib/src/features/navigation/legacy_router/klp_router_context.dart:1](../../../../../../lib/src/features/navigation/legacy_router/klp_router_context.dart#L1) |
| <code>klp_router_controller.dart → klp_router.dart</code> | part of | [lib/src/features/navigation/legacy_router/klp_router_controller.dart:1](../../../../../../lib/src/features/navigation/legacy_router/klp_router_controller.dart#L1) |
| <code>klp_router_outlet.dart → klp_router.dart</code> | part of | [lib/src/features/navigation/legacy_router/klp_router_outlet.dart:1](../../../../../../lib/src/features/navigation/legacy_router/klp_router_outlet.dart#L1) |
| <code>klp_router_scope.dart → klp_router.dart</code> | part of | [lib/src/features/navigation/legacy_router/klp_router_scope.dart:1](../../../../../../lib/src/features/navigation/legacy_router/klp_router_scope.dart#L1) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/features/navigation/legacy_router"]
	n1["klp_panel_layout_builder.dart"]
	n2["klp_route.dart"]
	n3["klp_route_not_found.dart"]
	n4["klp_router.dart"]
	n5["klp_router_context.dart"]
	n6["klp_router_controller.dart"]
	n7["klp_router_outlet.dart"]
	n8["klp_router_scope.dart"]
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
| `klp_panel_layout_builder.dart` | KlpPanelLayoutBuilder | [架構與 API](klp_panel_layout_builder.md) | [lib/src/features/navigation/legacy_router/klp_panel_layout_builder.dart:1](../../../../../../lib/src/features/navigation/legacy_router/klp_panel_layout_builder.dart#L1) |
| `klp_route.dart` | KlpRoute | [架構與 API](klp_route.md) | [lib/src/features/navigation/legacy_router/klp_route.dart:1](../../../../../../lib/src/features/navigation/legacy_router/klp_route.dart#L1) |
| `klp_route_not_found.dart` | KlpRouteNotFound | [架構與 API](klp_route_not_found.md) | [lib/src/features/navigation/legacy_router/klp_route_not_found.dart:1](../../../../../../lib/src/features/navigation/legacy_router/klp_route_not_found.dart#L1) |
| `klp_router.dart` | 無頂層宣告 | [架構與 API](klp_router.md) | [lib/src/features/navigation/legacy_router/klp_router.dart:1](../../../../../../lib/src/features/navigation/legacy_router/klp_router.dart#L1) |
| `klp_router_context.dart` | KlpRouterContext | [架構與 API](klp_router_context.md) | [lib/src/features/navigation/legacy_router/klp_router_context.dart:1](../../../../../../lib/src/features/navigation/legacy_router/klp_router_context.dart#L1) |
| `klp_router_controller.dart` | KlpRouter | [架構與 API](klp_router_controller.md) | [lib/src/features/navigation/legacy_router/klp_router_controller.dart:1](../../../../../../lib/src/features/navigation/legacy_router/klp_router_controller.dart#L1) |
| `klp_router_outlet.dart` | KlpRouterOutlet | [架構與 API](klp_router_outlet.md) | [lib/src/features/navigation/legacy_router/klp_router_outlet.dart:1](../../../../../../lib/src/features/navigation/legacy_router/klp_router_outlet.dart#L1) |
| `klp_router_scope.dart` | KlpRouterScope | [架構與 API](klp_router_scope.md) | [lib/src/features/navigation/legacy_router/klp_router_scope.dart:1](../../../../../../lib/src/features/navigation/legacy_router/klp_router_scope.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
