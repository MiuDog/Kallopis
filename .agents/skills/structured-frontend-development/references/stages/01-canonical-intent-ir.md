# 01 — Prompt → Canonical Intent IR

## 目的

把使用者原始要求、後續澄清與已知專案限制正規化為唯一可追溯的 Intent IR，清楚分開明示內容、合理推論與未解事項，作為所有下游決策的需求真相來源。

## 責任邊界

可做：整理來源、消除同義表述、標記矛盾、建立來源映射、確認目標與驗收、界定範圍，並判斷 `work_mode` 是 `new_ui` 或 `existing_ui`。

不可做：偷補未說明的需求、把範例當要求、選設計模式、創造設計規則、描述具體 UI 結構、撰寫 Flutter 或修改既有 UI。合理推論仍必須標為 `inferred`，不能偽裝成 `explicit`。

## 輸入與前置 gate

- 使用者原始 prompt、可定位的後續澄清與明確批准。
- 已知的任務授權、目標專案、基線資訊及不可修改範圍。
- 恢復工作流時，上一版 Intent IR、變更來源與受影響下游版本。
- 新工作流無上游 gate；但來源不足以形成可判定意圖時，本階段不得通過。

## 階段內有序步驟

1. 為每一段原始要求建立來源 locator，保留語意而不改寫承諾強度。
2. 抽取使用者目標、目標使用者、使用情境、平台、輸入、預期輸出、互動與成功結果。
3. 界定 in-scope、out-of-scope、不可變條件、授權範圍及外部依賴。
4. 將每項內容標成 `explicit`、`inferred` 或 `unresolved`，並記錄來源或推論依據。
5. 整理功能、內容、狀態、responsive、accessibility、視覺與技術驗收；沒有來源的項目不得自行補齊。
6. 判斷工作分支：全新 UI 為 `new_ui`；具有需保留之既有 UI 基線並要求差異修改時為 `existing_ui`。
7. 檢查矛盾與會改變設計結果的未解事項。可安全延後者記錄 owner；會改變目標、範圍、驗收或分支者必須由使用者解決。
8. 固定 Intent IR 版本，建立來源到各欄位的雙向映射，再依必證 claims 收集 evidence。

## 輸出產物

- 版本化 Canonical Intent IR，至少涵蓋目標、使用者／情境、需求、限制、範圍、驗收條件、授權、假設、未解事項與 `work_mode`。
- Source map：每個 Intent IR 項目對應 `explicit`、`inferred` 或 `unresolved` 及其 locator。
- 本 attempt 的結果與 evidence bundle。

## 必證 claims 與可接受 evidence

- Claim：每個意圖項目都有真實來源或明示推論狀態。Evidence：逐項來源對照及可返回原文的 locator。
- Claim：沒有把未解事項或推論偽裝成使用者要求。Evidence：分類檢視結果與所有假設清單。
- Claim：目標、範圍、驗收及禁止事項沒有互相矛盾。Evidence：一致性檢視及矛盾 disposition。
- Claim：`work_mode` 有充分依據且唯一。Evidence：基線與要求的觀察，或使用者對分支的明確確認。
- Claim：會影響下游的未解事項已清空。Evidence：未解清單檢視；必要時附特定問題的使用者確認。

## Passed

Intent IR 版本已固定；所有必要內容都可追溯；`explicit`、`inferred`、`unresolved` 分離；沒有會改變下游結果的未解事項；`work_mode` 唯一且有證據。

## Failed

來源映射錯誤、內容彼此矛盾、推論被當成明示要求、範圍或驗收遺漏，且可由現有來源判定如何更正時，結果為 `failed` 並留在 01 建立新 attempt。

## Blocked

缺少只有使用者或外部權限方能提供的關鍵需求、授權、基線或分支決策時，結果為 `blocked`。回報精確問題、影響與恢復條件，不自行猜測。

## 重做／退回判準

任何後續新資訊若改變目標、範圍、驗收、不可變條件、授權或 `work_mode`，都退回 01 建立新版 Intent IR，並使所有依賴舊版的下游結果失效。純措辭修正只有在不改變語意且有檢視證據時才不必重跑。

## Handoff 與下一接手者責任

把固定的 Intent IR、source map、版本、evidence、非阻斷假設及 `work_mode` 交給 02。02 的 owner 先驗證版本與來源完整，再只負責模式決策；不得補寫意圖。
