# 08 — Existing UI IR → Patch / Commands

## 目的

在 `existing_ui` 分支中，根據已查證的既有 UI IR／baseline 與目標 UI IR／delta，產生並執行最小必要 patch 或 commands，保護所有無關變更，完成驗證後作為整體工作流的終端完成閘門。

## 責任邊界

可做：檢查既有基線、計算目標 delta、規劃最小變更、套用授權 patch／commands、審查完整 diff 及執行適用驗證。

不可做：把既有實作反向改寫成使用者需求、擴張為全新 UI 重寫、修改需求／模式／規則／UI IR、觸碰無關檔案或變更、執行 07 分支，或提供未查證的特定設計系統 API／方法。

## 輸入與前置 gate

- Intent IR 的 `work_mode` 必須是 `existing_ui`；07 明確為 `not_applicable`。
- 01–06 全部 `passed` 的固定產物、版本鏈、validation report、critique report 與 evidence bundle。
- 已查證的 existing UI IR／baseline、target UI IR／delta、允許修改範圍與目標 repo 現況。
- 第 03 階段取回的專案／設計系統／驗證契約。基線不明或已漂移時不得直接套 patch。

## 階段內有序步驟

1. 核對 handoff、作用分支、baseline 與 target 版本；檢查 repo 是否已較 baseline 漂移，並辨識使用者既有的無關變更。
2. 將 target delta 逐項映射到現有實作 locator，區分必要變更、必須保留內容與不得觸碰範圍。
3. 規劃最小 patch／commands 及執行順序，說明每項變更如何滿足 UI IR；不以大規模重寫代替可局部完成的差異。
4. 在授權範圍內執行 patch／commands，保留無關格式、行為與使用者變更；執行前後都維持可追溯基線。
5. 建立 baseline → delta → patch → target 的 traceability，檢視每個變更是否由目標 UI IR 支持。
6. 審查完整 diff、新增／刪除檔案與實際命令結果，確認沒有範圍外變更，也沒有用目前實作反向降低需求。
7. 執行目標專案要求的格式化、靜態分析、單元／widget／整合測試及其他適用檢查，保存真實命令與輸出。
8. 對受影響視覺與互動執行適用的 golden／screenshot／實機檢視或取得使用者對特定版本的確認；無定型時不得冒稱視覺通過。
9. 逐項驗證 Intent IR 驗收與 target delta；所有 terminal claims 有充分 evidence 後，將 08 設為 `passed` 並把整體工作流設為 `completed`，不建立後續階段。

## 輸出產物

- 已執行的最小 patch／commands 及受影響範圍報告。
- Baseline、target delta、完成後 diff 與雙向 traceability map。
- 分析、測試、diff review 及適用視覺／使用者確認的驗證報告。
- 本 attempt 的結果與 evidence bundle；07 保持 `not_applicable`。

## 必證 claims 與可接受 evidence

- Claim：使用的 baseline 與目前 repo 狀態相符或漂移已被明確處理。Evidence：版本定位、基線檢視與漂移結果。
- Claim：每項 patch／command 都是達成 target delta 的必要且最小變更。Evidence：delta 到 diff locator 的逐項映射與替代範圍檢視。
- Claim：無關檔案、行為及使用者既有變更均受保護。Evidence：修改前狀態、完整 diff 與 scope review。
- Claim：沒有用現行實作反向改寫 Intent IR 或 UI IR。Evidence：target-first traceability inspection。
- Claim：適用 analyze 與 tests 已通過。Evidence：已執行命令、exit code、輸出尾段與環境／版本；exit 0 不能單獨證明視覺或語意正確。
- Claim：受影響的視覺與互動已確認。Evidence：對應完成版本的 golden、畫面／互動觀察或使用者明確確認；沒有適用定型時不可標 pass。
- Claim：所有驗收與 delta 成立。Evidence：逐項驗收對照、diff review 及各 claim 的適當觀察。

## Passed

Baseline 與 target 均可追溯；patch／commands 已執行且為最小必要變更；無關變更受保護；完整 diff、適用分析、測試及視覺／互動檢查通過；所有驗收成立。08 `passed` 即整體 `completed`，不再進入任何階段。

## Failed

Patch 不最小、範圍外變更、命令失敗、測試失敗、視覺差異不符或驗收未成立時為 `failed`。純 patch／執行問題留在 08 建立新 attempt；不得用後續補做承諾取代證據。

## Blocked

Baseline 遺失或漂移無法裁決、repo／檔案權限不足、使用者變更所有權不明、驗證環境不可用或缺少必要視覺裁決時為 `blocked`。不得自行擴權、覆蓋或重置既有變更。

## 重做／退回判準

Patch 規劃、命令或執行瑕疵重做 08。Baseline／target UI IR 或 delta 問題退 04；規則問題退 03；模式問題退 02；需求、驗收、範圍或分支問題退 01。退回後所有受影響的 05、06 與 08 gate 必須重跑。

## Handoff 與下一接手者責任

08 是終端分支，沒有下一階段。通過時把 patch／commands 紀錄、完整 diff、traceability、驗證報告與 evidence 移交給使用者或指定維護者；失敗或阻塞時只移交問題 owner、受保護基線及恢復責任。
