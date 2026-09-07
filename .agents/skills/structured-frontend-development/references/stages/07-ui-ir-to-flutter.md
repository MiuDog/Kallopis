# 07 — UI IR → Flutter

## 目的

在 `new_ui` 分支中，把已通過 01–06 的 UI IR 忠實轉成目標專案內的 Flutter 實作，完成技術驗證與適用的視覺／使用者確認，作為整體工作流的終端完成閘門。

## 責任邊界

可做：依固定 UI IR 選擇目標專案已允許的 Flutter 結構與公開能力、建立必要檔案、執行授權範圍內的實作與驗證。

不可做：變更需求、模式、規則或 UI IR，執行 08 的既有 UI 分支，以實作方便為由刪改狀態／accessibility／responsive 要求，或未經授權擴張修改範圍。本文件不提供 Kallopis 或其他設計系統的具體 API、元件或設計方法。

## 輸入與前置 gate

- Intent IR 的 `work_mode` 必須是 `new_ui`；08 明確為 `not_applicable`。
- 01–06 全部 `passed` 的固定產物、版本鏈、validation report、critique report 與 evidence bundle。
- 目標 Flutter repository、允許修改範圍，以及第 03 階段已查證的專案／設計系統／驗證契約。
- 任一上游版本失效或目標專案規則未查證時，拒絕實作並退回 owner stage。

## 階段內有序步驟

1. 核對 handoff、作用分支、UI IR 版本與目標 repo 現況；先辨識並保護使用者既有的無關變更。
2. 依 UI IR 的 screen／region／component tree 規劃 Flutter 映射，所有技術決策遵守第 03 階段取回的專案與設計系統契約。
3. 實作 content、data binding、events、states、responsive、accessibility、layout 與 semantic references，不從框架便利性反向改寫 UI IR。
4. 保持修改限於授權範圍，並建立 UI IR locator 到實作 locator 的 traceability。
5. 檢視完整 diff 與新檔案，確認沒有無關變更、硬編碼違規、私有 API 依賴或未查證能力。
6. 執行目標專案要求的格式化、靜態分析、單元／widget／整合測試及其他適用檢查；保存真實命令、exit code 與足以判讀的輸出。
7. 對需要視覺定型的 UI 執行適用的 golden／screenshot／實機檢視或取得使用者對特定版本的確認。若沒有可用定型，明示未取得，不能宣稱視覺通過。
8. 逐項對照 Intent IR 驗收與 UI IR traceability，記錄不適用檢查的可查證理由。
9. 只有所有 terminal claims 均有充分 evidence 時，將 07 設為 `passed` 並把整體工作流設為 `completed`；不建立後續階段。

## 輸出產物

- 目標 repo 中的 Flutter 實作及範圍受限的變更清單。
- UI IR 到 Flutter 實作的 traceability map 與完整 diff review。
- 分析、測試及適用視覺／使用者確認的驗證報告。
- 本 attempt 的結果與 evidence bundle；08 保持 `not_applicable`。

## 必證 claims 與可接受 evidence

- Claim：實作完整且忠實覆蓋固定 UI IR。Evidence：雙向 traceability inspection 與精確程式 locator。
- Claim：遵守目標 repo 與已檢索設計系統契約。Evidence：規則到實作的檢視、適用 discipline checks 與來源定位。
- Claim：沒有修改授權範圍外內容或吞入無關變更。Evidence：基線、完整 diff 與 scope review。
- Claim：適用的 analyze 與 tests 已通過。Evidence：已執行命令、exit code、輸出尾段與環境／版本；exit 0 不單獨證明 UI 品質。
- Claim：適用的視覺與互動結果已定型。Evidence：對應實作版本的 golden、畫面檢視、可重現互動觀察或使用者明確確認。沒有定型時此 claim 不得標 pass。
- Claim：Intent IR 驗收條件成立。Evidence：逐項驗收對照與各自最適方法，不接受單一泛用命令代替全部證明。

## Passed

Flutter 實作與 UI IR 可雙向追溯；範圍與規則均遵守；完整 diff 已審查；所有適用分析與測試通過；視覺／互動需要定型時已有證據；全部驗收成立。07 `passed` 即整體 `completed`，不再進入任何階段。

## Failed

實作、diff、分析、測試、視覺或驗收中有已觀察不合格時為 `failed`。純實作問題留在 07 建立新 attempt；不得把失敗測試或未取得視覺定型描述成通過。

## Blocked

缺少 repo 存取、實作授權、相依服務、驗證環境、必要裝置或使用者視覺裁決時為 `blocked`。記錄已完成檢查與恢復條件；阻塞期間不得宣稱整體完成。

## 重做／退回判準

Flutter 映射或實作瑕疵重做 07。UI IR 錯誤退 04；規則／專案契約不足退 03；模式問題退 02；需求、驗收、範圍或分支問題退 01。退回後所有受影響的 05、06 與 07 gate 必須重跑。

## Handoff 與下一接手者責任

07 是終端分支，沒有下一階段。通過時把實作、diff、traceability、驗證報告及 evidence 移交給使用者或指定維護者；對方接手的是已完成產物，不是新的工作流節點。失敗或阻塞時只移交問題 owner 與恢復責任。
