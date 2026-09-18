# 筆記元件：完整範圍與功能入口

使用者授權完整規劃並實作，尚未完成。即時狀態與下一步只維護在 [交接頁](../session-handoff.md)，本頁不追加進度或測試尾行。

## 交付範圍

### 畫布與手寫分期（2026-09-13 使用者確認）

第一版不要求 Concepts 等級的筆刷、壓感與精準編輯；先以成熟畫布引擎的基本繪圖能力接入。上述進階能力保留為後續版本需求，不刪除、不作為第一版交付或畫布選型的必備門檻。這項分期不延後其餘已確認的無限畫布需求，也不代表畫布引擎已選定。

後續擴充仍沿 Krepis 統一接口；本輪不預建進階筆刷系統或第二份筆跡模型。選型時記錄擴充與資料遷移限制，不假定第一版引擎必然涵蓋全部進階需求。下列完整功能索引包含跨版本範圍，不能全數當成第一版驗收清單。

- [功能蒸餾索引](note-reference-inventory.md) 的 Notion N01–N68、Concepts C01–C25、Miro M01–M24：契約、實作、可操作 Catalog、AI 文件與適用驗收。
- K01–K09 是工程切片，不縮減完整範圍；K10 連線仍屬 Miro 範圍，首版啟用政策另議。
- 視覺參考 Craft 官網。先蒸餾實際產品行為，再按本庫權威與受限組裝調整；不能用本機 Notist 代替 Notion。
- Planist 是第一消費者；产品細節由使用者逐步確認，不由底層庫猜定。

## 權威與不變條件

消費端只組裝合格節點、注入資料與事件；不接收 Widget／build/context／局部 style／painter。Kallopis 掌管風格解析、呈現、互動與資源生命週期；新正文依 KLP-0020 由 BlockNote 掌管文件、排版、選取與 undo，宿主 adapter 保存版本化快照；保留的 Krepis 路徑仍掌管原資料與筆跡，不建立第二份即時正文模型。

已確認：控制密度 A、Noto Sans TC、控制行高 18；固定頂端一般工具列，區塊操作跟隨選取。桌面三欄可拉伸、首版不自訂排序；平板以左中為主，手機側欄全幅覆蓋。切頁／失焦／切模式取消未提交組字，保留已提交內容。完整畫面尚未定型。

## 按功能讀取

| 功能 | 單一詳細規格 |
|---|---|
| 輸入、文字、組字、投影 | [K01](editor-input-contract-plan.md) |
| 區塊選取、轉換、重排 | [K02](block-controls-contract-plan.md) |
| 清單、縮排與 marker | [N06／N07](list-blocks-contract-plan.md) |
| 定位命令選單 | [K03](anchored-commands-contract-plan.md) |
| 模式與輸入排他 | [K04](editor-mode-contract-plan.md) |
| 手寫取樣／暫態／提交 | [K05](handwriting-input-contract-plan.md) |
| 保存、關閉、恢復 | [K09](editor-save-feedback-contract-plan.md) |
| Notion 完整元件 | [Notion](notion-note-components-spec.md) |
| 手寫完整體驗 | [Concepts](concepts-handwriting-spec.md) |
| Spatial 元件 | [Miro](miro-spatial-components-spec.md) |
| Consumer 組裝 | [AI 索引](../ai/README.md) |

## 採用 BlockNote 後的接入順序

使用者已選定 BlockNote，後續正文依 [KLP-0020](../../spec/decisions/KLP-0020-blocknote-editor-adoption.md)。先完成 Flutter Catalog 的本地編輯區與宿主保存，再接 Planist，最後驗證舊文件轉換。下方清單等是需在上游整合後驗收的使用流程，不再逐項自研 Krepis 正文功能。手寫／Spatial 完整範圍保留另作選型。

## 完成方式（2026-09-12 重排）

沿用既定權威及公開入口，以可操作流程交付；不再按 C++、ABI、Dart、UI 分別累積半成品。每條流程帶上需要的 Catalog 操作與 AI 文件，Planist 可沿既有 consumer 接點逐條接入，不留到所有底層功能完成才首次整合。即時通過／未通過僅記交接。

| 順序 | 可操作流程 | 收斂條件 |
|---|---|---|
| 目前：BlockNote Catalog | 本地編輯 → 保存 → 未保存離開保護 → 關閉重開 | 真實橋接與保存可恢復；隔離測試與原生輸入證據分開；不重新實作上游文字核心 |
| 後續：筆記區塊 | 依 Notion 現行規格逐組完成插入、編輯、移動、刪除與保存 | 每組有可操作的 consumer 路徑，未完成 N 項保留，不以基本區塊代替全部範圍 |
| 後續：手寫 | 依 Concepts 現行規格逐組完成取樣、提交、選取／修改與保存 | 接真實平台事件，取消不殘留、正文與筆跡權威一致 |
| 後續：Spatial | 依 Miro 現行規格逐組完成物件建立、選取、移動及適用操作 | 每組可在實際畫面操作；未定產品行為單獨決策，不阻塞已確定部分 |
| 最後：整體交付 | 核對 N／C／M 全清單、Planist、Catalog、AI 文件及實機／讀屏 | 所有已授權項目具備適用證據，剩餘缺口明確列出；不得用切片完成宣稱全部完成 |

### 目前流程的下一步

1. 沿 BlockNote Catalog 補齊載入失敗恢復、編輯與保存、未保存關閉保護；依目前授權採背景／無頭測試，不操作前景桌面。
2. 原生 IME、焦點與平台貼上按可用環境驗收，不把程式插入中文當作 OS 組字。
3. 接入 Planist 既有 Flow 文件插槽與 beforeLeaveDocument 保護，沿用產品文件身份與保存來源；不切換或轉換舊文件。
4. 按公開受限節點更新 AI 組裝文件；後續才逐組核對上游功能與原需求缺口。

未因本次重排另開架構重構、第二份計畫或全量 Verify。後續各組的細節到輪到該組時才按需展開，不猜工時或總百分比。

## 完成判定與未決事項

每項功能需接通資料、合法插槽、安裝、呈現、實際操作與文件；不以測試數量或已定義類別算完成。必要測試依 AGENTS 的高低階模型分工及局部主體優先政策，沒有必要不額外撰寫或執行。

頁面建頁、筆跡溢出與部分 Spatial 操作集合尚待產品定義；不能把這些局部待定擴大為整體停工。資料權威缺口在 Krepis 完成，不能由 Flutter 模擬。回退保留文件與原有可用能力，不以舊 Widget consumer 替代目標架構。
