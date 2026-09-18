# KLP-0021：生產力 App 元件生態與 Consumer Reference

階段：DEFINE／Iteration

狀態：Implementing — 使用者已於 2026-09-18 接受完整方向、第一版能力地平線、semantic feature 消費契約與端到端證據；目前 `DEFINE READY`。`PE-B1`～`PE-B4` 已完成確定性驗證，reference 可理解性仍待人類接受，其餘能力缺口與固定 Catalog 遷移仍在進行中。

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
| PE-14 | v1 | P1 | Consumer 以一致的 semantic feature 契約消費能力：公開宣告、immutable data projection、feature-specific intent，以及有一次性命令需求時才提供的 feature-specific controller。每個 feature 只有一個 `onIntent(FeatureIntent)` 事件出口；跨 feature 的 `KlpAction` 僅用於全域命令。 | Explorer、Document Tabs 等公開能力可以相同方法找到宣告、資料、intent 與可選 controller；不存在同一 feature 的多組並列 callback 消費模式。 | accepted |
| PE-15 | v1 | P1 | 權威狀態依可觀察責任分配：可儲存、還原、分享或影響其他 feature 的產品狀態由 consumer 擁有；hover、pressed、拖曳預覽等純互動短暫狀態由 Kallopis 擁有；正文、游標、選區、undo 等專業編輯狀態保留在 Krepis／provider。 | 同一產品或編輯狀態沒有第二份權威；每個公開 feature 的能力卡可查到其狀態 owner。 | accepted |
| PE-16 | v1 | P1 | Immutable projection 是 feature 唯一資料入口。大型或非同步資料使用 windowed projection 表達目前頁面或可視範圍，loading、empty、error、partial 與 ready 為明確狀態；feature 不直接呼叫 consumer repository、API 或第二套 data source。 | 分頁、查詢、重試與載入更多由 intent 輸出，consumer 提交新 projection；小型與大型資料不需學習兩種 feature 生命週期。 | accepted |
| PE-17 | v1 | P1 | Consumer 控制遵循宣告優先：持續狀態以新宣告輸入，使用者操作以 intent 輸出，無法自然表示為狀態的一次性語意命令才使用受限 controller。 | focus、reveal、begin rename 等命令使用 feature-specific controller 並回傳具型別結果；不暴露 Flutter controller、focus node、scroll controller 或全域 UI command bus。 | accepted |
| PE-18 | v1 | P1 | 跨 feature 共用小型 capability vocabulary 與值契約，不建立擁有大量方法的萬用 `KlpFeatureBase`。每個 feature 明列它支援的 selection、query／filter／sort、windowing、validation、editing、commands、drag-and-drop、focus／keyboard、accessibility 與 adaptive 等能力；feature-specific intent 仍保留語意上下文。 | Consumer 學會一個 feature 即能預測其他 feature 的公開形狀；不能因某 capability 型別存在就將它任意掛到未列出支援的 feature。 | accepted |
| PE-19 | v1 | P1 | 固定 Catalog 項目是遷移與展示單位，不必一對一產生公開 feature。多個舊 widget 可映射成同一 semantic feature 的狀態、capability 或合法組裝；只有獨立資料、事件或組裝語意才建立新公開 feature。 | 254 項仍逐項保留映射與證據，但 reference 以 consumer 意圖與 semantic feature 為主入口；純內部視覺零件不因清冊存在而升格為 consumer API。 | accepted |
| PE-20 | v1 | P1 | 新 declarative consumer 只能透過 `kallopis_declarative.dart` 明列的 API 提供產品資料、內容、語意狀態、intent 處理與合法 Kallopis 組裝。Kallopis 不暴露任何 API 之外的自訂入口，尤其完整擁有視覺風格與互動呈現。 | 公開 declarative 契約不接受 theme／style／token 覆寫、顏色、字型、間距、尺寸、圓角、陰影、動畫參數、Widget、builder、`BuildContext`、painter、renderer、Flutter controller 或 consumer component／adapter 註冊；destructive、selected 等僅為語意，實際外觀由 Kallopis 決定。 | accepted |
| PE-21 | v1 | P1 | Semantic feature 的程式契約完成與人類視覺／可理解性接受分開記錄。Consumer-ready 至少需有語意邊界、完整公開形狀、合法組裝、適用的功能狀態、鍵盤／焦點／accessibility、唯一呈現路徑、可操作 Catalog、consumer reference 及 deterministic evidence。 | 程式接通但契約不完整者不能標示 consumer-ready；自動證據不代替人類對視覺、操作方式與體驗的接受。 | accepted |
| PE-22 | v1 | P1 | 失敗依責任分流：非法組裝、重複 ID 與錯誤 slot 等開發契約違反使用具穩定 code 的 `KlpContractError`；載入失敗、權限拒絕與資料不存在等預期結果使用 typed projection state、intent 或 controller result；非預期 Kallopis／provider 錯誤由唯一 host 診斷。 | 契約錯誤不被靜默修正；預期失敗不以未分類例外取代資料流；非預期失敗保留上一安全 frame 或使用 Kallopis 擁有的錯誤狀態，consumer 不注入自訂錯誤 Widget。 | accepted |
| PE-23 | v1 | P1 | GitHub Pages 的正式 API Reference 以 `kallopis_declarative.dart` 實際可達的新版 consumer API 為唯一收錄權威；內部 `lib/src` 可見性、舊 Catalog class 或 Stable legacy library 不得自行進入正式 consumer API 導覽。 | 網站 API 清冊與 analyzer 解析出的 declarative export closure 一致；沒有未匯出型別，也沒有漏列已匯出的公開宣告。 | accepted |
| PE-24 | v1 | P1 | 正式 API Reference 先列出全部 consumer-facing module 分類，再由 module 頁列出該 module 的所有公開 API；每個 public class／sealed class／mixin／enum／extension／typedef 各有獨立宣告頁，top-level function 與 variable 也各有可直接連結的獨立頁，不以巨型檔案頁取代。 | 任一公開名稱可由「API Reference → module → declaration」在兩次導覽內到達；class 頁只描述一個 class，並列出 constructors、fields、getters、methods、型別關係、用途與來源。 | accepted |
| PE-25 | v1 | P1 | Reference 的 API 事實由 Dart analyzer 與公開來源產生，手寫 Markdown 只補用途、合法組裝、資料權威、intent／controller、限制、最小範例與能力證據；生成物不是第二份手寫權威。 | 公開簽名變更後重新產生即可更新清冊與宣告頁；驗證器拒絕缺頁、重複頁、失效來源、非公開 API、舊 callback／style 寫法及無法解析的範例。 | accepted |
| PE-26 | 完整地平線 | P1 | 固定 254 項舊 Catalog 必須全部能由新版宣告式架構實際呈現。新版能力能取代舊寫法時，先遷移本庫 consumer、Catalog、測試與文件，再刪除舊公開宣告、adapter、renderer 與無使用者的專用實作；不得保留同義相容入口。 | `coverage.json` 保持固定 254 分母並達成 254／254 具新版公開宣告、資料／事件、合法組裝、唯一呈現、可操作 Catalog 與驗證證據；repo 內沒有對應舊入口使用，正式 Reference 只列新版 API，遷移對照另行保留。 | accepted |

## Consumer 開發階段

Reference 採用下列四階段作為主要學習順序。這是 consumer 建立產品的工作階段，不是 Kallopis 內部 module、runtime pipeline 或強制產品流程。

| 階段 | Consumer 思考重點 | 使用 Kallopis 的方式 | 階段完成條件 |
| --- | --- | --- | --- |
| 1. 視覺組成 | 畫面有哪些區域、容器、層級與空／占位狀態。 | 選擇公開 layout、container、feature shell 與合法 slot，使用靜態或空資料建立可見結構。 | 主要區域可呈現且結構合法；不注入 Widget、renderer、局部 style 或產品資料模型。 |
| 2. 產品資料模型 | 產品真正擁有哪些 entity、狀態、規則與資料來源。 | 在 consumer 端建立產品模型；只參考 Klp feature 所需的資料／狀態契約，不讓呈現型別成為產品資料權威。 | 產品模型可獨立描述核心資料與狀態，不依賴 renderer 或複製 Klp 私有狀態。 |
| 3. 資料與互動接線 | 如何將產品資料投影到畫面，以及選取、編輯、導覽、提交與失敗如何回到產品。 | 建立不可變 Klp data，以單一 feature-specific `onIntent` 接回使用者操作，更新產品權威後重新提交 application declaration；只在一次性語意命令時使用受限 controller。 | 核心成功及失敗流程可操作；只有一份資料權威，Klp 不保存平行產品狀態。 |
| 4. 動畫與體驗優化 | 回饋、轉場、鍵盤、焦點、無障礙、適應性與感受是否完整。 | 選用 Kallopis 已公開的語意狀態與體驗能力，透過 Catalog 提出並接受缺少的通用行為。 | deterministic 互動證據完成，視覺與體驗由人類接受；consumer 不傳任意動畫、duration、curve 或局部樣式。 |

consumer 可以返回前一階段修正產品，但 reference 不應要求第一階段先理解尚未需要的資料控制或動畫細節。若某階段所需能力不存在，依能力清冊標示 partial／unsupported 並交回 Kallopis 能力流程，不以原生 Widget 補洞。

## Semantic feature 消費模型

Consumer 不從內部 module 或 class 清單挑選實作，而是依產品意圖找到 semantic feature，再使用統一的公開形狀：

| 方向 | 公開契約 | 責任 |
| --- | --- | --- |
| Consumer → Feature | declaration 與 immutable projection | 表示目前產品資料、可觀察狀態與合法組裝。 |
| Feature → Consumer | 單一 feature-specific `onIntent` | 回報使用者意圖，不直接改寫 consumer 權威。 |
| Consumer → Feature | 可選 feature-specific controller | 僅執行 focus、reveal 等無法自然表示為持續狀態的一次性語意命令。 |

標準流程為「consumer 產品模型 → immutable projection → Kallopis feature → typed intent → consumer 更新產品模型 → 重新宣告」。大型資料也使用同一流程，只是 projection 改為頁面或可視範圍；feature 不另行取得 repository 或 data source。

每個 semantic feature 必須可預測地找到宣告、資料、intent 與可選 controller，並明列它支援的共通 capabilities。共通契約只統一 vocabulary 和值，不使 consumer 取得任意擴充或把 capability 掛到未授權的 feature。

## 權威與封閉呈現

| 狀態 | 權威 |
| --- | --- |
| 可儲存、還原、分享或影響其他 feature 的產品狀態 | Consumer |
| hover、pressed、拖曳預覽等純互動短暫狀態 | Kallopis |
| 正文、游標、選區、undo 等編輯引擎狀態 | Krepis／provider |

Consumer 提供的文字、產品資料、語意角色與合法組裝是產品輸入，不是呈現自訂。新 declarative 路徑的視覺、動畫、互動呈現及錯誤表面完全由 Kallopis 擁有；缺少能力時先返回 Kallopis 建立正式契約，不在 consumer 局部開放自訂繞道。

## Feature 成熟度與失敗

Feature 的程式契約完成和人類接受是兩個獨立證據面。程式存在但契約、功能狀態、焦點／鍵盤／accessibility、Catalog、reference 或 deterministic evidence 不完整時，仍不是 consumer-ready。程式證據完成後，視覺、操作可理解性與體驗仍由人類接受。

失敗依來源分為三種：

1. 非法組裝、重複 ID 或錯誤 slot 為開發契約違反，使用具穩定 code 的 `KlpContractError`，不靜默修正。
2. 載入失敗、權限拒絕或資料不存在為預期結果，使用 typed projection state、intent 或 controller result。
3. 非預期 Kallopis／provider 錯誤由唯一 host 回報診斷，保留上一安全 frame 或使用 Kallopis 擁有的錯誤狀態。

## 建議的端到端證據

下列是 `PE-03` 已接受的驗收情境，不是固定產品模板，也不規定 consumer 的功能順序：

1. 工作區流程：應用程式 shell、導覽、Explorer、多區域布局、文件分頁、命令、選單與對話回饋能合法組合。
2. 結構化資料流程：集合或資料表、搜尋／篩選／排序、表單輸入、驗證、提交、載入、空白與錯誤狀態能完成一條受控流程。
3. 正文工作流程：透過已接受的 editing host 開啟、編輯、保存、失敗重試及關閉文件；正文權威仍遵守 KLP-0020。
4. 跨切面要求：以上流程具鍵盤操作、焦點、語意、窄寬布局及必要平台環境證據。

案例只證明通用能力可共同工作。Kallopis 不因此擁有專案、任務、文件庫或其他產品資料模型。

## 範圍外

- 原生 Widget 或任意 consumer renderer 擴充。
- consumer 自訂 semantic schema、theme／style／token、顏色、字型、間距、尺寸、圓角、陰影、動畫、painter、renderer 或 component／adapter 註冊。
- 將 Flutter controller、focus node、scroll controller、builder 或自訂錯誤 Widget 作為 declarative consumer 逃生口。
- Planist 或其他產品的固定頁面模板、業務流程與資料權威。
- 與生產力 App 無關的通用 Flutter primitive 複製；生產力語意能力本身仍屬完整地平線。
- 在 DEFINE 階段決定資料夾、類別名稱、module 配對或 BUILD 切片。

## 與現行契約的關係

- 本決策保留並加強 KLP-0019 的唯一結構樹、封閉 catalog、受限插槽及禁止 Widget 邊界；它新增的是產品能力地平線與 consumer 可學習性責任，不恢復被否決的 runtime extension。
- 視覺擁有權、功能契約卡及 Catalog 人類接受仍依 `spec/visual-component-governance.md`。
- 舊元件完整遷移仍依 `docs/architecture/catalog-migration/README.md` 的固定清冊與證據。
- Reference 網站沿用 `spec/reference-site-v1.md` 的 Markdown 單一來源與文件網站能力；本決策定義其 consumer 學習內容，不建立第二份文章來源。
- 正式 API Reference 的簽名與公開名稱由 analyzer 讀取 `kallopis_declarative.dart` export closure 產生；Markdown 單一來源只負責人類說明，不手動複製 API 簽名清冊。
- 最終發佈位置為本專案既有 GitHub Pages／github.io 網站；是否 push 或觸發外部部署仍依當次交付授權，不能以本決策自動擴張外部操作。

## 代價與否決方案

採用此方向會使 Kallopis 承擔比一般 design system 更大的跨功能整合、文件、Catalog、無障礙與相容性成本；新增能力也必須走完整契約與呈現流程，無法以 consumer Widget 快速補洞。

否決下列方案：

- 要求 consumer 先理解所有 module 或 class，再自行推導組裝方式。這把全域知識成本轉嫁給使用者。
- 只維護孤立 API reference。它不能證明跨功能組裝可完成生產流程。
- 為追求覆蓋率開放任意 Widget。這會失去結構驗證與視覺治理，並違反使用者本次確認。
- 將特定產品畫面或商業流程包成 Kallopis 模板。這會越過產品與通用元件的責任邊界。

## 閘門與目前 readiness

`PE-03`、`PE-14`～`PE-22` 與 `PE-23`～`PE-26` 已由使用者於 2026-09-18 接受；第一版能力領域、semantic feature 消費模型、權威邊界、封閉呈現、正式 API Reference 結構、舊 Catalog 全面新版呈現、成熟度、失敗行為及代表性端到端證據已固定。所有 P1 均有可觀察驗收，且現行 KLP-0019、KLP-0020、視覺治理與固定 Catalog 清冊沒有相反要求。

目前 `DEFINE READY`，沒有 open P1。`PE-B1`～`PE-B4` 已完成確定性建置與驗證；網站的視覺與可理解性維持 human-pending。後續各 semantic feature 由所屬 module 依本契約另行進入 PLAN／BUILD，不能靜默改變禁止自訂、單一 intent、資料與狀態權威或 consumer-ready 證據門檻。

現行證據與後續 module 入口為 [Consumer Reference 模組架構](../../docs/ai/architecture.md)；固定 Catalog 仍依個別 feature 遷移契約逐項接回。

## Open questions

None. 任何會改變公開消費模型、資料權威、呈現封閉性或 consumer-ready 條件的後續事項，必須重新回到 DEFINE。
