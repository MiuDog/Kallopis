# 02 — Intent IR → Design Pattern

## 目的

依已通過的 Intent IR 辨識可行設計模式，系統性比較候選，選出最符合意圖與限制的模式組合，並保留選擇與拒絕理由。

## 責任邊界

可做：產生候選模式、建立適配矩陣、判斷組合相容性、選擇模式並記錄替代方案。

不可做：把 pattern 當成需求來源、用常見模式覆蓋使用者意圖、宣稱尚未檢索的設計規則、產生 UI IR、撰寫 Flutter 或修改既有 UI。模式只是一種組織已知需求的方案。

## 輸入與前置 gate

- 01 的 `passed` Intent IR、source map、版本與 evidence bundle。
- 唯一的 `work_mode` 與已確認範圍。
- 若 01 的版本、證據或必要欄位失效，拒絕接手並退回 01。

## 階段內有序步驟

1. 從 Intent IR 提取需要模式解決的互動、資訊組織、導航、狀態與工作流問題。
2. 為每個問題建立多個可行候選；沒有合理替代時記錄為單一候選及原因。
3. 建立適配矩陣，逐候選對照使用者目標、使用情境、內容規模、平台限制、accessibility、responsive、技術邊界及 `work_mode`。
4. 辨識候選間的衝突、依賴、組合成本與會引入的假設。
5. 選擇能覆蓋需求且引入最少無來源假設的模式組合。
6. 對每個採用與拒絕的候選記錄理由、所對應的 Intent IR locator 及尚待第 03 階段查證的規則需求。
7. 確認模式決策沒有新增功能、內容或驗收條件，固定 decision report 版本並收集 evidence。

## 輸出產物

- Design Pattern decision report：設計問題、候選集合、適配矩陣、採用模式、拒絕模式、組合關係、取捨及待檢索規則。
- Intent IR 到模式決策的 traceability map。
- 本 attempt 的結果與 evidence bundle。

## 必證 claims 與可接受 evidence

- Claim：候選由 Intent IR 中的實際設計問題導出。Evidence：問題與 Intent IR locator 的逐項映射。
- Claim：採用模式符合需求與限制。Evidence：完成的適配矩陣及可重現的比較觀察。
- Claim：重要替代方案已評估且拒絕有理由。Evidence：候選與拒絕理由紀錄，不接受只有偏好結論。
- Claim：模式沒有成為新增需求的來源。Evidence：模式輸出反向對照 Intent IR 的檢視結果。
- Claim：需要權威規則支持的項目已交給 03。Evidence：待檢索規則清單與對應模式 locator。

## Passed

每個需解決的設計問題都有模式決策；候選比較完整；所有採用與拒絕理由可追溯；沒有模式自行新增需求；待檢索規則範圍明確。

## Failed

候選不足、適配矩陣缺漏、模式與 Intent IR 衝突、拒絕理由不可判讀或模式引入無來源需求時為 `failed`。若問題只在選型，留在 02 重做。

## Blocked

若模式取捨需要使用者主觀決策或缺少關鍵平台／內容規模資訊，且 02 無權決定，標為 `blocked`。若實際缺口屬於需求，owner 是 01。

## 重做／退回判準

選型方法或候選評估錯誤時重做 02。發現目標、情境、範圍、驗收或分支未定時退回 01。Intent IR 新版會使本階段及所有下游結果失效。

## Handoff 與下一接手者責任

把 decision report、適配矩陣、traceability、待檢索規則、版本及 evidence 交給 03。03 的 owner 只負責尋找與裁決權威規則，不得把模式偏好偽裝成規則。
