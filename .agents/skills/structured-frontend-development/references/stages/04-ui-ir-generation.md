# 04 — UI IR Generation

## 目的

把已通過的意圖、模式與規則轉成框架中立、可驗證且可實作的 UI IR，完整描述 UI 的結構、資料、狀態、互動、布局與語意，而不提前寫 Flutter 或 patch。

## 責任邊界

可做：建立 screen／region／component tree，定義內容與資料契約、事件、狀態、responsive 行為、accessibility、布局關係及 semantic rule references。

不可做：撰寫 Flutter、產生命令或具體 patch、修改 Intent IR、覆寫規則、引入特定框架 widget tree，或把目前程式實作反向當成需求。UI IR 必須框架中立。

## 輸入與前置 gate

- 01–03 全部 `passed` 的固定版本、完整版本鏈及 evidence bundle。
- Intent IR、Design Pattern decision report、rule set 與 provenance map。
- `work_mode`；若為 `existing_ui`，可讀既有 UI 的已查證 baseline 來描述 delta，但不可由 baseline 覆蓋目標意圖。

## 階段內有序步驟

1. 建立 UI IR 根資訊：版本、來源版本鏈、`work_mode`、目標平台與 scope。
2. 定義 screen 與 region 邊界、責任及導覽關係，再建立 component tree；每個節點使用框架中立角色與穩定識別。
3. 為節點定義可見內容、資料需求、資料來源／空值語意及呈現條件。
4. 定義使用者事件、系統事件、事件目標、前置條件、結果、錯誤處理與狀態轉移。
5. 覆蓋適用的初始、loading、empty、content、error、disabled、success、partial 或其他由 Intent IR／規則要求的狀態；不適用項目記錄理由。
6. 描述布局約束、順序、群組、尺寸關係、overflow、scroll、overlay 與 responsive breakpoint 行為，不寫死無來源視覺值。
7. 定義 accessibility 語意、名稱、角色、焦點順序、鍵盤／替代輸入、動態公告與對比等適用要求。
8. 將每個 UI 決策連回 Intent IR、模式決策或 rule provenance；對新增但必要的技術性結構明示其理由，不把它當產品需求。
9. 若為 `existing_ui`，另外建立 baseline 到 target 的 UI IR delta；若為 `new_ui`，明示無既有 baseline 依賴。
10. 執行生成階段的完整性自查，固定 UI IR 版本並收集 evidence；正式合格判定留給 05 與 06。

## 輸出產物

- 版本化、框架中立的 UI IR，包含 screen／region／component tree、content、data、events、states、responsive、accessibility、layout 與 semantic references。
- 需求／規則／模式到 UI IR 的雙向 traceability map。
- `existing_ui` 分支所需的 baseline／target delta，或 `new_ui` 的無基線聲明。
- 本 attempt 的結果與 evidence bundle。

## 必證 claims 與可接受 evidence

- Claim：UI IR 涵蓋所有適用的需求、模式與規則。Evidence：逐項雙向 traceability inspection。
- Claim：結構、內容、資料、事件與狀態足以供後續驗證及實作。Evidence：各區段完整性檢視與 locator。
- Claim：responsive、accessibility、layout 與 semantic references 已依來源描述。Evidence：來源對照與 UI IR 定位。
- Claim：UI IR 是框架中立且沒有 Flutter／patch 指令。Evidence：產物內容檢視。
- Claim：分支資料已就緒。Evidence：`new_ui` 無基線聲明，或 `existing_ui` 的可追溯 baseline／target delta。

## Passed

UI IR 版本固定、非空且框架中立；所有必要維度完整；每項設計決策可追溯；沒有未標示的新需求；作用分支具備 05 所需輸入。

## Failed

UI IR 遺漏、內部矛盾、含無來源決策、混入 Flutter／patch、traceability 斷裂或 delta 不完整時為 `failed`。若問題屬生成內容，留在 04 重做。

## Blocked

若無法取得既有 UI baseline、必要內容／資料契約或規則裁決，且 04 無權補足，標為 `blocked` 並指派真正 owner stage 或外部 owner。

## 重做／退回判準

生成或表達問題重做 04。規則不足退 03；模式不適配退 02；需求、驗收、範圍或分支有誤退 01。任何上游新版都使本 UI IR 與下游結果失效。

## Handoff 與下一接手者責任

把固定 UI IR、traceability、分支資料、版本鏈與 evidence 交給 05。05 只驗證這個確切版本並產生 issues，不得直接修正 UI IR。
