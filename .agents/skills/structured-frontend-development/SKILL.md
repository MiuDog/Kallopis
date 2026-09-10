---
name: structured-frontend-development
description: 以逐階段證據閘門編排新建或既有 Flutter 前端工作。當任務需要把使用者要求依序轉成意圖、設計模式、設計規則與 UI IR，再實作新 UI 或修補既有 UI 時使用；不提供特定設計系統的 API 或設計方法。
---

# 結構化前端開發

本 skill 是前端工作的流程編排器。它管理八個階段的順序、證據、退回與接手責任；不替任何設計系統定義元件、API 或設計方法，也不擴張使用者授權。

## 啟動與恢復

1. 先讀 [工作流協定](references/workflow-protocol.md) 與 [證據契約](references/evidence-contract.md)。
2. 從使用者要求、既有產物與先前證據判斷是全新工作流或恢復工作流。
3. 全新工作流從 01 開始。恢復時逐一核對既有階段的版本、結果與證據，只從最後一個仍有效的 `passed` 階段之後接續；無法核對的階段不得視為已通過。
4. 只讀取目前階段的文件並執行該階段。需要退回時，才改讀 owner stage 的文件。

| 階段 | 階段文件 |
| --- | --- |
| 01 | [Prompt → Canonical Intent IR](references/stages/01-canonical-intent-ir.md) |
| 02 | [Intent IR → Design Pattern](references/stages/02-design-pattern.md) |
| 03 | [Design Rule Retrieval](references/stages/03-design-rule-retrieval.md) |
| 04 | [UI IR Generation](references/stages/04-ui-ir-generation.md) |
| 05 | [UI IR Validation](references/stages/05-ui-ir-validation.md) |
| 06 | [UI Critique / Evaluation](references/stages/06-ui-critique.md) |
| 07 | [UI IR → Flutter](references/stages/07-ui-ir-to-flutter.md) |
| 08 | [Existing UI IR → Patch / Commands](references/stages/08-existing-ui-patch.md) |

## 硬閘門

- 01–06 是共同流程，必須依序執行。階段只有在產物版本固定、結果為 `passed`，且必證 claims 均有合格 evidence 時才能移交。
- `failed` 表示已成功完成檢查但內容不合格；`blocked` 表示缺少外部決策、權限、輸入或可執行環境。兩者不得偽裝成 `passed`。
- 07 與 08 是互斥的終端分支。01 所確認的 `work_mode` 為 `new_ui` 時只執行 07；為 `existing_ui` 時只執行 08；未選分支記為 `not_applicable`。
- 不得在 06 或終端分支臨時更換 `work_mode`。分支改變必須退回 01，建立新版 Intent IR，並重新推進所有下游階段。
- 最終分析、測試、差異審查與適用的視覺或使用者確認，是 07／08 各自 terminal completion gate 的一部分。任一作用中分支通過即代表整體工作流完成；沒有第 9 階段。
- Evidence 只能記錄已觀察事實。推測、模型自述、預期結果或「應該可行」不能開啟下一階段。
- 每次移交都要明示：目前階段與版本、結果、evidence bundle、下一接手者、下一步，以及未選分支或退回範圍。

## 執行邊界

- 各階段只做其文件列出的責任；發現上游缺陷時提出 finding 並退回 owner stage，不得在下游暗改上游產物。
- 使用者的新要求若改變目標、範圍、驗收、基線或分支，視為上游版本變更；依工作流協定使受影響下游結果失效。
- 若目標專案另有治理、設計或驗證契約，在第 03 階段檢索並記錄其來源；本 skill 不複製或假造那些規則。
- 未經使用者授權，不得執行超出任務範圍的修改、發布、部署或外部操作。
