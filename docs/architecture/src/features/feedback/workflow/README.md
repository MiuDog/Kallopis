# lib/src/features/feedback/workflow：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/features/feedback/workflow` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

```mermaid
flowchart LR
	n0["lib/src/features/feedback/workflow"]
	n1["lib/src/features/actions/button"]
	n2["lib/src/features/collections/badge"]
	n3["lib/src/features/feedback"]
	n4["lib/src/foundation"]
	n5["lib/src/foundation/content"]
	n6["lib/src/foundation/interaction"]
	n7["lib/src/foundation/layout"]
	n8["lib/src/foundation/surface"]
	n9["package:flutter"]
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
| <code>lib/src/features/actions/button</code> | import | 1 | [lib/src/features/feedback/workflow/klp_finite_workflow.dart:3](../../../../../../lib/src/features/feedback/workflow/klp_finite_workflow.dart#L3) |
| <code>lib/src/features/collections/badge</code> | import | 1 | [lib/src/features/feedback/workflow/klp_finite_workflow.dart:4](../../../../../../lib/src/features/feedback/workflow/klp_finite_workflow.dart#L4) |
| <code>lib/src/features/feedback</code> | import | 2 | [lib/src/features/feedback/workflow/klp_finite_workflow.dart:10](../../../../../../lib/src/features/feedback/workflow/klp_finite_workflow.dart#L10) |
| <code>lib/src/foundation</code> | import | 1 | [lib/src/features/feedback/workflow/klp_finite_workflow.dart:5](../../../../../../lib/src/features/feedback/workflow/klp_finite_workflow.dart#L5) |
| <code>lib/src/foundation/content</code> | import | 1 | [lib/src/features/feedback/workflow/klp_finite_workflow.dart:9](../../../../../../lib/src/features/feedback/workflow/klp_finite_workflow.dart#L9) |
| <code>lib/src/foundation/interaction</code> | import | 1 | [lib/src/features/feedback/workflow/klp_finite_workflow.dart:6](../../../../../../lib/src/features/feedback/workflow/klp_finite_workflow.dart#L6) |
| <code>lib/src/foundation/layout</code> | import | 1 | [lib/src/features/feedback/workflow/klp_finite_workflow.dart:7](../../../../../../lib/src/features/feedback/workflow/klp_finite_workflow.dart#L7) |
| <code>lib/src/foundation/surface</code> | import | 1 | [lib/src/features/feedback/workflow/klp_finite_workflow.dart:8](../../../../../../lib/src/features/feedback/workflow/klp_finite_workflow.dart#L8) |
| <code>package:flutter</code> | import | 1 | [lib/src/features/feedback/workflow/klp_finite_workflow.dart:1](../../../../../../lib/src/features/feedback/workflow/klp_finite_workflow.dart#L1) |

### 同目錄依賴

| 來源 → 目標 | 關係 | 證據 |
|---|---|---|
| <code>klp_finite_workflow.dart → klp_focus_boundary.dart</code> | part | [lib/src/features/feedback/workflow/klp_finite_workflow.dart:13](../../../../../../lib/src/features/feedback/workflow/klp_finite_workflow.dart#L13) |
| <code>klp_finite_workflow.dart → klp_focus_boundary_state.dart</code> | part | [lib/src/features/feedback/workflow/klp_finite_workflow.dart:14](../../../../../../lib/src/features/feedback/workflow/klp_finite_workflow.dart#L14) |
| <code>klp_finite_workflow.dart → klp_workflow_progress.dart</code> | part | [lib/src/features/feedback/workflow/klp_finite_workflow.dart:15](../../../../../../lib/src/features/feedback/workflow/klp_finite_workflow.dart#L15) |
| <code>klp_finite_workflow.dart → klp_workflow_stage_data.dart</code> | part | [lib/src/features/feedback/workflow/klp_finite_workflow.dart:16](../../../../../../lib/src/features/feedback/workflow/klp_finite_workflow.dart#L16) |
| <code>klp_finite_workflow.dart → klp_workflow_state.dart</code> | part | [lib/src/features/feedback/workflow/klp_finite_workflow.dart:17](../../../../../../lib/src/features/feedback/workflow/klp_finite_workflow.dart#L17) |
| <code>klp_finite_workflow.dart → klp_workflow_state_surface.dart</code> | part | [lib/src/features/feedback/workflow/klp_finite_workflow.dart:18](../../../../../../lib/src/features/feedback/workflow/klp_finite_workflow.dart#L18) |
| <code>klp_focus_boundary.dart → klp_finite_workflow.dart</code> | part of | [lib/src/features/feedback/workflow/klp_focus_boundary.dart:1](../../../../../../lib/src/features/feedback/workflow/klp_focus_boundary.dart#L1) |
| <code>klp_focus_boundary_state.dart → klp_finite_workflow.dart</code> | part of | [lib/src/features/feedback/workflow/klp_focus_boundary_state.dart:1](../../../../../../lib/src/features/feedback/workflow/klp_focus_boundary_state.dart#L1) |
| <code>klp_workflow_progress.dart → klp_finite_workflow.dart</code> | part of | [lib/src/features/feedback/workflow/klp_workflow_progress.dart:1](../../../../../../lib/src/features/feedback/workflow/klp_workflow_progress.dart#L1) |
| <code>klp_workflow_stage_data.dart → klp_finite_workflow.dart</code> | part of | [lib/src/features/feedback/workflow/klp_workflow_stage_data.dart:1](../../../../../../lib/src/features/feedback/workflow/klp_workflow_stage_data.dart#L1) |
| <code>klp_workflow_state.dart → klp_finite_workflow.dart</code> | part of | [lib/src/features/feedback/workflow/klp_workflow_state.dart:1](../../../../../../lib/src/features/feedback/workflow/klp_workflow_state.dart#L1) |
| <code>klp_workflow_state_surface.dart → klp_finite_workflow.dart</code> | part of | [lib/src/features/feedback/workflow/klp_workflow_state_surface.dart:1](../../../../../../lib/src/features/feedback/workflow/klp_workflow_state_surface.dart#L1) |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/features/feedback/workflow"]
	n1["klp_finite_workflow.dart"]
	n2["klp_focus_boundary.dart"]
	n3["klp_focus_boundary_state.dart"]
	n4["klp_workflow_progress.dart"]
	n5["klp_workflow_stage_data.dart"]
	n6["klp_workflow_state.dart"]
	n7["klp_workflow_state_surface.dart"]
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
| `klp_finite_workflow.dart` | 無頂層宣告 | [架構與 API](klp_finite_workflow.md) | [lib/src/features/feedback/workflow/klp_finite_workflow.dart:1](../../../../../../lib/src/features/feedback/workflow/klp_finite_workflow.dart#L1) |
| `klp_focus_boundary.dart` | KlpFocusBoundary | [架構與 API](klp_focus_boundary.md) | [lib/src/features/feedback/workflow/klp_focus_boundary.dart:1](../../../../../../lib/src/features/feedback/workflow/klp_focus_boundary.dart#L1) |
| `klp_focus_boundary_state.dart` | _KlpFocusBoundaryState | [架構與 API](klp_focus_boundary_state.md) | [lib/src/features/feedback/workflow/klp_focus_boundary_state.dart:1](../../../../../../lib/src/features/feedback/workflow/klp_focus_boundary_state.dart#L1) |
| `klp_workflow_progress.dart` | KlpWorkflowProgress | [架構與 API](klp_workflow_progress.md) | [lib/src/features/feedback/workflow/klp_workflow_progress.dart:1](../../../../../../lib/src/features/feedback/workflow/klp_workflow_progress.dart#L1) |
| `klp_workflow_stage_data.dart` | KlpWorkflowStageData | [架構與 API](klp_workflow_stage_data.md) | [lib/src/features/feedback/workflow/klp_workflow_stage_data.dart:1](../../../../../../lib/src/features/feedback/workflow/klp_workflow_stage_data.dart#L1) |
| `klp_workflow_state.dart` | KlpWorkflowState | [架構與 API](klp_workflow_state.md) | [lib/src/features/feedback/workflow/klp_workflow_state.dart:1](../../../../../../lib/src/features/feedback/workflow/klp_workflow_state.dart#L1) |
| `klp_workflow_state_surface.dart` | KlpWorkflowStateSurface | [架構與 API](klp_workflow_state_surface.md) | [lib/src/features/feedback/workflow/klp_workflow_state_surface.dart:1](../../../../../../lib/src/features/feedback/workflow/klp_workflow_state_surface.dart#L1) |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
