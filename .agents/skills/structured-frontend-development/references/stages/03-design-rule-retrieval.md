# 03 — Design Rule Retrieval

## 目的

從適用且可定位的權威來源取回設計與實作規則，記錄 provenance、版本、scope、優先序與衝突裁決，形成 UI IR 可引用的規則集合。

## 責任邊界

可做：定位使用者指示、目標專案治理與設計系統規則，判斷適用性，整理衝突與未查證缺口。

不可做：創造不存在的規則、把一般慣例冒充專案規則、修改權威來源、選擇未授權的 API、生成 UI IR 或變更產品程式碼。本階段只取回與整理規則，不教授特定設計方法。

## 輸入與前置 gate

- 01 的 `passed` Intent IR 與 02 的 `passed` Design Pattern decision report。
- 兩者的版本鏈、traceability、待檢索規則清單與 evidence bundle。
- 目標專案、設計系統或使用者提供來源的可存取位置；無法驗證的來源不得視為已知。

## 階段內有序步驟

1. 從 Intent IR、模式決策及目標專案辨識需規則支撐的主題與查詢範圍。
2. 先查使用者當下的明確指示，再查目標專案宣告的治理與優先序，最後查被專案採用之設計系統的權威文件；若來源自訂不同優先序，記錄並依更高權威指示處理。
3. 對每條候選規則記錄原文定位、來源身分、版本或取回時間、適用 scope、強制程度及其所支撐的上游項目。
4. 排除已過期、不適用、來源不明或只屬一般建議的內容；排除理由保留在報告中。
5. 比較同一主題的規則，依已查證的權威順序裁決衝突。無法裁決時不自行選擇，標為未解衝突。
6. 對查不到或無法驗證的必要事實明確標示「未查證」，記錄已查來源與影響；不得用推測補洞。
7. 形成可供 UI IR 引用的 rule set 與 provenance map，固定版本並依 claims 收集 evidence。

## 輸出產物

- Design Rule Retrieval report：查詢範圍、採用規則、排除規則、provenance、版本、scope、優先序、衝突與未查證項目。
- Rule set 與上游需求／模式的 traceability map。
- 本 attempt 的結果與 evidence bundle。

## 必證 claims 與可接受 evidence

- Claim：每條採用規則來自真實且適用的權威來源。Evidence：來源 locator、版本／取回時間及 scope 對照。
- Claim：檢索遵循可查證的權威順序。Evidence：使用者、專案與設計系統的優先序來源及實際裁決紀錄。
- Claim：衝突均已處理或明確阻塞。Evidence：衝突矩陣、採用／排除理由與 owner。
- Claim：沒有發明查不到的規則。Evidence：未查證清單、查詢範圍與負面檢索紀錄。
- Claim：必要需求與模式都有足夠規則支撐，或被明示為不需外部規則。Evidence：雙向 traceability inspection。

## Passed

所有必要規則都有 provenance、版本、scope 與適用理由；權威衝突已裁決；沒有會阻止 UI IR 生成的未查證缺口；rule set 版本已固定。

## Failed

來源誤引、scope 判定錯誤、衝突處理不一致、provenance 缺漏或把非權威內容當規則時為 `failed`。若能從現有來源修正，留在 03 重做。

## Blocked

必要來源無法存取、權威順序不明、規則衝突需使用者裁決，或關鍵事實只能標為未查證而會影響 UI IR 時為 `blocked`。清楚列出缺口、影響與恢復條件。

## 重做／退回判準

檢索或適用性錯誤時重做 03。若所需規則範圍源於錯誤模式，退回 02；若源於意圖缺漏或衝突，退回 01。上游新版使本階段及下游結果失效。

## Handoff 與下一接手者責任

把固定的 rule set、retrieval report、provenance map、未查證但不阻斷的項目、版本與 evidence 交給 04。04 只能引用此集合中的規則或明示無規則項目，不得自行補造規則。
