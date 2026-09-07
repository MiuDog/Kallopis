# 06 — UI Critique / Evaluation

## 目的

對已通過 validation 的 UI IR 進行品質評估，判斷其視覺層級、可用性、accessibility、視覺一致性、互動品質與實作可行性是否足以進入作用中的終端分支。

## 責任邊界

可做：依 Intent IR 與已檢索規則評估體驗品質，產生具 severity、claim、source、locator 與 owner 的 findings，並判定是否阻斷。

不可做：重跑或取代 05 的完整性 validation、直接修改 UI IR、增加無來源審美規則、切換 `work_mode`、撰寫 Flutter 或執行 patch。Critique 提出品質判斷與回退責任，不自行修正。

## 輸入與前置 gate

- 01–05 全部 `passed` 的固定產物、版本鏈與 evidence bundle。
- 已通過的 UI IR、validation report、Intent IR、模式決策及 rule set。
- 評估準則必須能追溯到使用者意圖、權威規則或明示的專業判斷範圍；不得把偏好寫成硬規則。

## 階段內有序步驟

1. 固定受評 UI IR 與來源版本，確認 05 的 validation 仍有效。
2. 評估 visual hierarchy：主要／次要任務、閱讀順序、資訊密度、分組與注意力是否支持目標。
3. 評估 usability：可發現性、可理解性、操作成本、錯誤預防／恢復與狀態回饋。
4. 評估 accessibility：語意、焦點、替代輸入、動態回饋、內容理解及適用的感知要求。
5. 評估 visual coherence：元件角色、布局節奏、層級與設計規則是否一致，不另行發明品牌或風格要求。
6. 評估 interaction：事件與狀態轉移是否符合使用者心智模型，loading、empty、error、disabled 等體驗是否合理。
7. 評估 feasibility：UI IR 是否能在目標 Flutter 專案與已知限制內實作；未知 API 或能力標為未查證，不得編造。
8. 為每個 finding 記錄 severity、被評 claim、source、observation、locator、owner stage、阻斷性及建議 disposition。
9. 將阻斷 finding 退回最上游 owner；沒有阻斷項時固定 critique report 並為指定分支建立 handoff。

## 輸出產物

- UI Critique report：六個評估面向、findings、severity、claim、source、locator、owner、disposition 與分支判定。
- 受評 UI IR 與全部來源版本鏈。
- 本 attempt 的結果與 evidence bundle。

## 必證 claims 與可接受 evidence

- Claim：六個適用品質面向均已評估。Evidence：逐面向 inspection 與 UI IR locator；不適用需有來源支持的理由。
- Claim：每個 finding 都有可判定 claim、來源、觀察、severity 與 owner。Evidence：finding records 的完整性檢視。
- Claim：阻斷性依使用者目標或權威規則判定，而非無來源偏好。Evidence：finding 到 Intent IR／rule locator 的對照。
- Claim：作用分支與 Intent IR 的 `work_mode` 一致。Evidence：版本化 Intent IR 與 branch handoff 比對。
- Claim：critique 沒有修改 UI IR 或重做 validation。Evidence：受評前後版本身分及報告範圍檢視。

## Passed

所有適用面向已評估；沒有未處理的阻斷 finding；非阻斷 findings 有明確 disposition；作用分支與 `work_mode` 一致；UI IR 版本保持不變。

## Failed

評估正常完成但存在阻斷 finding 時為 `failed`。依 finding owner 退回，不能在 06 直接修改 UI IR。若 critique 本身缺少面向、來源或一致 severity，留在 06 重做。

## Blocked

缺少只有使用者能裁決的主觀標準、必要的專案能力資訊或可進行評估的內容時為 `blocked`。未知可行性要標「未查證」並說明是否阻斷，不以信心取代證據。

## 重做／退回判準

Critique 報告品質問題重做 06。UI IR 品質問題退 04；規則不足或衝突退 03；模式問題退 02；需求或分支問題退 01。修正後重新執行所有受影響 gate，至少包含 05 與 06。

## Handoff 與下一接手者責任

`new_ui` 時把已驗證 UI IR、critique、版本鏈與 evidence 交給 07，並把 08 記為 `not_applicable`。`existing_ui` 時交給 08，並把 07 記為 `not_applicable`。終端分支 owner 不得改寫 UI IR；發現上游問題必須退回其 owner。
