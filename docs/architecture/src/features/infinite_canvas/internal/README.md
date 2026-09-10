# lib/src/features/infinite_canvas/internal：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/features/infinite_canvas/internal` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart TD
	n0["lib/src/features/infinite_canvas/internal"]
	n1["lib/src/features/infinite_canvas"]
	n0 -->|"part of"| n1
```

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| <code>lib/src/features/infinite_canvas</code> | part of | 8 | [lib/src/features/infinite_canvas/internal/klp_canvas_drop_intent.dart:1](../../../../../../lib/src/features/infinite_canvas/internal/klp_canvas_drop_intent.dart#L1) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/features/infinite_canvas/internal"]
	n1["klp_canvas_drop_intent.dart"]
	n2["klp_canvas_minimap.dart"]
	n3["klp_canvas_selection_overlay.dart"]
	n4["klp_canvas_toolbar.dart"]
	n5["klp_canvas_viewport.dart"]
	n6["klp_flow_node_card.dart"]
	n7["klp_flow_validation_panel.dart"]
	n8["klp_layout_lens.dart"]
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
| `klp_canvas_drop_intent.dart` | KlpCanvasDropIntent | [架構與 API](klp_canvas_drop_intent.md) | [lib/src/features/infinite_canvas/internal/klp_canvas_drop_intent.dart:1](../../../../../../lib/src/features/infinite_canvas/internal/klp_canvas_drop_intent.dart#L1) |
| `klp_canvas_minimap.dart` | KlpCanvasMinimap | [架構與 API](klp_canvas_minimap.md) | [lib/src/features/infinite_canvas/internal/klp_canvas_minimap.dart:1](../../../../../../lib/src/features/infinite_canvas/internal/klp_canvas_minimap.dart#L1) |
| `klp_canvas_selection_overlay.dart` | KlpCanvasSelectionOverlay | [架構與 API](klp_canvas_selection_overlay.md) | [lib/src/features/infinite_canvas/internal/klp_canvas_selection_overlay.dart:1](../../../../../../lib/src/features/infinite_canvas/internal/klp_canvas_selection_overlay.dart#L1) |
| `klp_canvas_toolbar.dart` | KlpCanvasToolbar | [架構與 API](klp_canvas_toolbar.md) | [lib/src/features/infinite_canvas/internal/klp_canvas_toolbar.dart:1](../../../../../../lib/src/features/infinite_canvas/internal/klp_canvas_toolbar.dart#L1) |
| `klp_canvas_viewport.dart` | KlpCanvasViewport | [架構與 API](klp_canvas_viewport.md) | [lib/src/features/infinite_canvas/internal/klp_canvas_viewport.dart:1](../../../../../../lib/src/features/infinite_canvas/internal/klp_canvas_viewport.dart#L1) |
| `klp_flow_node_card.dart` | KlpFlowNodeCard | [架構與 API](klp_flow_node_card.md) | [lib/src/features/infinite_canvas/internal/klp_flow_node_card.dart:1](../../../../../../lib/src/features/infinite_canvas/internal/klp_flow_node_card.dart#L1) |
| `klp_flow_validation_panel.dart` | KlpFlowValidationPanel | [架構與 API](klp_flow_validation_panel.md) | [lib/src/features/infinite_canvas/internal/klp_flow_validation_panel.dart:1](../../../../../../lib/src/features/infinite_canvas/internal/klp_flow_validation_panel.dart#L1) |
| `klp_layout_lens.dart` | KlpLayoutLens | [架構與 API](klp_layout_lens.md) | [lib/src/features/infinite_canvas/internal/klp_layout_lens.dart:1](../../../../../../lib/src/features/infinite_canvas/internal/klp_layout_lens.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
