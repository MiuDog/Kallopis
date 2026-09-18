# KLP-0021：生產力 App 元件生態與 Consumer Reference

階段：DEFINE／Iteration

狀態：Implementing — 使用者已於 2026-09-18 接受完整方向、第一版能力地平線與端到端證據；目前 `DEFINE READY`。能力清冊、Consumer Reference 與缺口補齊尚未完成，因此不能標記 Accepted。

語意責任：Kallopis 公開的產品無關生產力 App 元件生態，以及 consumer 由產品意圖定位能力、學會合法組裝並辨識缺口的 reference。內部 module 分層、實作型別與工作切片不由本決策定義。

目標版本：Productivity Ecosystem v1 基線。完整能力地平線涵蓋所有產品無關的生產力 App 相關能力；v1 的第一個交付不是一次實作全部元件，而是固定完整地平線、盤點現有公開能力與缺口，並建立 consumer reference，後續再由 PLAN 依缺口安排能力切片。

## 目標與動機

Kallopis 的主要職責改為提供完整生產力 App 所需的通用元件生態，使 consumer 能專注於產品資料、狀態、事件與功能選用，不必同時設計視覺系統或理解 Kallopis 全部內部 module。

「完整」表示 Kallopis 預期覆蓋所有產品無關的生產力 App 相關能力，並對每項能力提供可追溯的公開宣告、資料／事件、合法組裝、視覺與操作證據。固定 254 項舊 Catalog 是目前已知基線，不是能力上限；未交付能力保持明示缺口。完整不表示複製所有 Flutter primitive，也不允許以產品專用商業邏輯、任意 Widget 或局部樣式補洞。

## 需求與決策

| ID | 目標版本 | 優先級 | 需求或決策 | 可觀察驗收 | 狀態 |
| --- | --- | --- | --- | --- | --- |
| PE-01 | v1 | P1 | 維持 KLP-0019 的封閉宣告式邊界；consumer 不提供原生 Widget、`BuildContext`、renderer、painter 或局部 style。 | `kallopis_declarative.dart` 不提供原生 Widget 注入入口；不合法輸入有負向契約證據。 | accepted |
| PE-02 | v1 | P1 | Kallopis 以產品無關的完整生產力 App 元件生態為主要能力範圍。 | 已接受能力地平線中的每個領域都有公開能力、明示缺口或排除理由，不能因資料夾或舊類別存在便宣稱支援。 | accepted |
| PE-03 | v1 基線／完整地平線 | P1 | 完整能力地平線涵蓋所有產品無關的生產力 App 能力，包括 application／navigation、workspace／layout、actions／commands、collections／data、forms／input、feedback、overlays、筆記與內容編輯、圖表與資料視覺化、規劃視圖、畫布／繪圖／手寫、溝通協作、keyboard／focus／accessibility，以及 adaptive／platform environment；列舉不是封閉上限。 | 能力清冊能將目前已知能力追蹤到交付、缺口或產品無關性排除；筆記、圖表與手寫不得僅因專門化而移出能力地平線。 | accepted |
| PE-04 | v1 | P1 | 正式實作新能力前，先建立以產品意圖為索引的能力清冊與缺口矩陣。 | 每項意圖可查到對應公開功能、成熟度、資料、事件、合法位置、限制、Catalog 證據與缺口；`unknown` 與 `unsupported` 分開標記。 | accepted |
| PE-05 | v1 | P1 | Consumer Reference 以 consumer 開發階段組織「意圖 → 完整配方 → API」：先完成視覺組成，再建立產品資料模型，接著連接資料與互動，最後使用 Kallopis 的受控能力進行動畫與體驗優化；不以內部 module 或 class 清單作為初學者入口。 | 初學者可依目前開發階段只讀所需內容，不必先理解 kernel、runtime、rendering、foundation 或 styling；每階段都有輸入、產出、完成條件及不得越過的責任邊界。 | accepted |
| PE-06 | v1 | P1 | 每個公開功能使用一致的能力卡。 | 能力卡包含用途、狀態、必要資料、事件、狀態權威、合法父子／角色／數量／次序、最小宣告、完整組裝、限制及 Catalog 連結。 | accepted |
| PE-07 | v1 | P1 | 只有同時具備新版公開宣告、資料／事件、合法組裝、唯一語意風格與可操作 Catalog 的能力，才能標示為 supported。 | 缺少任一證據者保持 partial、unverified 或 unsupported；reference 不以類別存在或靜態 specimen 冒充可用能力。 | accepted |
| PE-08 | v1 | P1 | Reference 必須包含跨功能的端到端組裝證據，而非只有孤立元件頁。 | 每個已接受的代表性流程可從公開入口完成；確定性程式證據與人類視覺／操作接受分開記錄。 | accepted |
| PE-09 | v1 | P1 | 元件生態仍只提供產品無關能力；產品選用、順序、導航目的及商業流程由 consumer 產品擁有。 | Kallopis 不新增 Planist 專用模板、固定業務流程或產品資料模型；案例只作能力證據，不成為產品組裝權威。 | accepted |
| PE-10 | v1 | P1 | 固定 254 項舊 Catalog 遷移仍依既有清冊進行，不能以新能力分類縮小分母或重設完成狀態。 | 新能力清冊引用既有遷移狀態；刪頁、改名或重分類不改變固定分母。 | accepted |
| PE-11 | 完整地平線 | P1 | 所有產品無關的生產力相關元件都是預期覆蓋範圍；筆記、圖表、手寫及其他大型能力領域可以分階段交付，但不能因尚未完成或較專門而永久標為 deferred。 | 能力清冊將尚未交付項標示 partial／unverified／unsupported 與後續 owner；只有產品專用商業邏輯或不屬生產力 App 的能力可列 scope out。 | accepted |
| PE-12 | v1 | P1 | Consumer Reference 最終透過本專案既有 GitHub Pages／github.io 文件網站提供；repository Markdown 保持內容單一來源。 | 本機產生與驗證的 reference site 包含初學者入口、能力清冊、端到端流程及詳細能力頁；不另維護只存在於網站產物的文章副本。 | accepted |
| PE-13 | v1 基線 | P1 | 固定 254 項舊 Catalog 必須逐項分類，不能只提供來源區域統計。 | 每一項都可查到能力 ID、consumer 開發階段、現行 coverage 狀態、預定處置、下一 owner 與直接來源；任何合併、取代或排除都保留固定分母並有產品無關理由。 | accepted |

## Consumer 開發階段

Reference 採用下列四階段作為主要學習順序。這是 consumer 建立產品的工作階段，不是 Kallopis 內部 module、runtime pipeline 或強制產品流程。

| 階段 | Consumer 思考重點 | 使用 Kallopis 的方式 | 階段完成條件 |
| --- | --- | --- | --- |
| 1. 視覺組成 | 畫面有哪些區域、容器、層級與空／占位狀態。 | 選擇公開 layout、container、feature shell 與合法 slot，使用靜態或空資料建立可見結構。 | 主要區域可呈現且結構合法；不注入 Widget、renderer、局部 style 或產品資料模型。 |
| 2. 產品資料模型 | 產品真正擁有哪些 entity、狀態、規則與資料來源。 | 在 consumer 端建立產品模型；只參考 Klp feature 所需的資料／狀態契約，不讓呈現型別成為產品資料權威。 | 產品模型可獨立描述核心資料與狀態，不依賴 renderer 或複製 Klp 私有狀態。 |
| 3. 資料與互動接線 | 如何將產品資料投影到畫面，以及選取、編輯、導覽、提交與失敗如何回到產品。 | 建立不可變 Klp data，接上 action／callback，更新產品權威後重新提交 application declaration。 | 核心成功及失敗流程可操作；只有一份資料權威，Klp 不保存平行產品狀態。 |
| 4. 動畫與體驗優化 | 回饋、轉場、鍵盤、焦點、無障礙、適應性與感受是否完整。 | 選用 Kallopis 已公開的語意狀態與體驗能力，透過 Catalog 提出並接受缺少的通用行為。 | deterministic 互動證據完成，視覺與體驗由人類接受；consumer 不傳任意動畫、duration、curve 或局部樣式。 |

consumer 可以返回前一階段修正產品，但 reference 不應要求第一階段先理解尚未需要的資料控制或動畫細節。若某階段所需能力不存在，依能力清冊標示 partial／unsupported 並交回 Kallopis 能力流程，不以原生 Widget 補洞。

## 建議的端到端證據

下列是 `PE-03` 已接受的驗收情境，不是固定產品模板，也不規定 consumer 的功能順序：

1. 工作區流程：應用程式 shell、導覽、Explorer、多區域布局、文件分頁、命令、選單與對話回饋能合法組合。
2. 結構化資料流程：集合或資料表、搜尋／篩選／排序、表單輸入、驗證、提交、載入、空白與錯誤狀態能完成一條受控流程。
3. 正文工作流程：透過已接受的 editing host 開啟、編輯、保存、失敗重試及關閉文件；正文權威仍遵守 KLP-0020。
4. 跨切面要求：以上流程具鍵盤操作、焦點、語意、窄寬布局及必要平台環境證據。

案例只證明通用能力可共同工作。Kallopis 不因此擁有專案、任務、文件庫或其他產品資料模型。

## 範圍外

- 原生 Widget 或任意 consumer renderer 擴充。
- consumer 自訂 semantic schema、局部 style、尺寸、動畫或 painter。
- Planist 或其他產品的固定頁面模板、業務流程與資料權威。
- 與生產力 App 無關的通用 Flutter primitive 複製；生產力語意能力本身仍屬完整地平線。
- 在 DEFINE 階段決定資料夾、類別名稱、module 配對或 BUILD 切片。

## 與現行契約的關係

- 本決策保留並加強 KLP-0019 的唯一結構樹、封閉 catalog、受限插槽及禁止 Widget 邊界；它新增的是產品能力地平線與 consumer 可學習性責任，不恢復被否決的 runtime extension。
- 視覺擁有權、功能契約卡及 Catalog 人類接受仍依 `spec/visual-component-governance.md`。
- 舊元件完整遷移仍依 `docs/architecture/catalog-migration/README.md` 的固定清冊與證據。
- Reference 網站沿用 `spec/reference-site-v1.md` 的 Markdown 單一來源與文件網站能力；本決策定義其 consumer 學習內容，不建立第二份文章來源。
- 最終發佈位置為本專案既有 GitHub Pages／github.io 網站；是否 push 或觸發外部部署仍依當次交付授權，不能以本決策自動擴張外部操作。

## 代價與否決方案

採用此方向會使 Kallopis 承擔比一般 design system 更大的跨功能整合、文件、Catalog、無障礙與相容性成本；新增能力也必須走完整契約與呈現流程，無法以 consumer Widget 快速補洞。

否決下列方案：

- 要求 consumer 先理解所有 module 或 class，再自行推導組裝方式。這把全域知識成本轉嫁給使用者。
- 只維護孤立 API reference。它不能證明跨功能組裝可完成生產流程。
- 為追求覆蓋率開放任意 Widget。這會失去結構驗證與視覺治理，並違反使用者本次確認。
- 將特定產品畫面或商業流程包成 Kallopis 模板。這會越過產品與通用元件的責任邊界。

## 閘門與目前 readiness

`PE-03` 已由使用者於 2026-09-18 接受；第一版能力領域及代表性端到端證據已固定。所有 P1 均有可觀察驗收，且現行 KLP-0019、KLP-0020、視覺治理與固定 Catalog 清冊沒有相反要求。

目前 `DEFINE READY`，可交由 PLAN 將現有公開能力、固定遷移清冊及缺口配對成階段性 slices。後續未決事項只能是實作細節、P2 專門領域或視覺候選，不能靜默改變禁止 Widget、產品無關性或 supported 證據門檻。

目前 PLAN 入口為 [Consumer Reference 模組架構](../../docs/ai/architecture.md)；第一階段只建立能力清冊與 reference 基線，不提前補元件實作。
