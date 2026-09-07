# 05 — UI IR Validation

## 目的

以可重現檢查驗證 UI IR 的完整性、traceability、一致性與分支就緒程度，產生合格判定或具 owner 的 issues；本階段不修正受檢 UI IR。

## 責任邊界

可做：執行結構與內容檢查、比對上游、建立 issue 清單、判定 `passed`／`failed`／`blocked`，並把問題指派給真正 owner stage。

不可做：修改 UI IR、重寫需求、替規則衝突選邊、進行審美 critique、撰寫 Flutter 或套用 patch。Validation 判斷「契約是否成立」，不評價整體體驗品質。

## 輸入與前置 gate

- 01–04 全部 `passed` 的固定產物、版本鏈與 evidence bundle。
- 受檢 UI IR、雙向 traceability map，以及作用分支的 baseline／target 資料或無基線聲明。
- 受檢版本若在檢查期間變更，停止該 attempt；不能把舊檢查結果套到新版。

## 階段內有序步驟

1. 固定受檢 UI IR 與全部上游版本，確認 evidence 能重新定位。
2. 檢查必要區段與節點識別是否完整，引用是否能解析，資料與事件契約是否可判定。
3. 檢查 Intent IR、模式、規則與 UI IR 的雙向 traceability；找出未覆蓋來源與無來源 UI 決策。
4. 檢查 screen／region／component tree、content、data、events、states、layout、responsive、accessibility 與 semantic references 之間是否一致。
5. 檢查所有必要狀態與轉移是否封閉，錯誤、空值、disabled 與非同步情況是否依適用性處理。
6. 檢查分支就緒：`new_ui` 是否可直接進行框架映射；`existing_ui` 是否具有可追溯 baseline、target 與 delta。
7. 對每個 issue 記錄 severity、failed claim、observation、locator、owner stage、建議回退點與是否阻斷。
8. 分開判斷內容不合格與檢查執行失敗。前者為 `failed`；檢查器、服務、權限或環境無法完成則為 `blocked`，不得把執行錯誤說成 UI IR 不合格。
9. 產生 immutable validation report 與 evidence bundle，不修改受檢產物。

## 輸出產物

- UI IR Validation report：檢查範圍、逐項結果、issues、severity、owner stage、分支 readiness 與整體結果。
- 被驗證 UI IR 版本與上游版本鏈。
- 本 attempt 的結果與 evidence bundle。

## 必證 claims 與可接受 evidence

- Claim：必要結構與內容完整。Evidence：可重現的完整性檢查及每項 locator。
- Claim：所有來源與 UI 決策雙向可追溯。Evidence：traceability inspection 的逐項結果。
- Claim：跨區段、狀態與事件沒有未處理矛盾。Evidence：一致性檢查與 issue disposition。
- Claim：作用分支具備實作前提。Evidence：branch readiness checklist 對固定版本的觀察。
- Claim：validation 未修改 UI IR。Evidence：檢查前後版本／內容身分比對。

## Passed

所有必要檢查皆通過；沒有阻斷 issue；非阻斷 findings 均有合理 disposition；作用分支 ready；報告與 evidence 對應同一固定 UI IR 版本。

## Failed

檢查成功完成，但至少一個必要 claim 不成立時為 `failed`。Issue 必須指派 owner stage；不得在 05 直接修補。多個 owner 同時存在時退回最上游 owner。

## Blocked

缺少受檢版本、證據、檢查能力、權限或可用環境，導致無法作出有效判定時為 `blocked`。記錄執行失敗本身及恢復條件，不可偽裝為內容 fail 或 pass。

## 重做／退回判準

UI IR 內容或 traceability 問題退 04；規則來源問題退 03；模式問題退 02；意圖問題退 01。Owner 修正後，從該 owner stage 起建立新版本，並重新執行所有受影響階段，包含 05。

## Handoff 與下一接手者責任

只有 `passed` 才把固定 UI IR、validation report、版本鏈與 evidence 交給 06。06 的 owner 評估 UI 品質，不重做完整性驗證；若發現 validation 漏檢，建立 finding 並退回對應 owner。
