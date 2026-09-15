# Features 模組架構

Explorer 當前實作配對為 [EXP-V1-r2](../../../docs/architecture/explorer-v1-plan/README.md)：直接替換舊 API/專用 Widget、分離 adapter、保留資料 interface、統一命令結果。r2 接替下列 Explorer r1/Sidebar-v2 的新開發指令，其他功能保持。

Status: PLAN READY — v1 已接受現行宣告式目錄、舊版隔離區，以及與 foundation、runtime、rendering 和 application 配對的接合邊界

阻擋中的架構決策：無。BUILD 仍依下列已接受的配對切片分開執行。

權威依據：[模組登錄表](../architecture.md)、[模組架構 v1 規格](../../../spec/module-architecture-v1.md)、[KLP-0019](../../../spec/decisions/KLP-0019-declarative-framework-migration.md)、[KLP-0020](../../../spec/decisions/KLP-0020-blocknote-editor-adoption.md)

## 目的

Explorer 契約 v1 的當前資料切片為 `EXP-DATA-01`，PLAN READY，精確公開模組契約、檔案與驗收見 [EXP-V1-r1](../../../docs/architecture/explorer-v1-plan/README.md)。`workspace/explorer/` 擁有可實作的資料 interface、不可變完整快照及結構資格；尚不匯出至 consumer、不新增 renderer。它取代 FEAT-V1-10 作為 Explorer 新開發方向；既有畫面的切換與舊 API 移除須依同頁的接線／Catalog／遷移閘門完成。

BlockNote Flow prerequisites v1 已配對 `KBF-PAIR-r2`，詳見 [editing module](editing/architecture.md)、[workspace 的 Explorer 配對](workspace/architecture.md) 與 [共通契約](../../../docs/architecture/blocknote-flow-pairing.md)。此新增 stage 的契約 READY、實作 pending，不改本文件其他既有 stage 的完成狀態；所有新 BUILD 仍需獨立測試及精確 packet。

`features` 掌管 Kallopis 由本庫定義的可組合元件目錄。現行功能契約是不可變的宣告式節點，具備受限的子節點資格、呈現資料與語意事件。功能轉接器透過套件內部 runtime 契約，將這些節點轉換為已準備的呈現紀錄。此模組位於 L5，在 runtime 之上、rendering/application 之下。

同一個原始碼根目錄目前也包含大量舊版 Flutter 元件庫。這些 Widget 家族僅供相容用途，不得用來擴充現行宣告式樹。

## 非目標

- 產品實體、儲存庫／持久化邏輯，或 Planist/Notist 工作流程的權威。
- 由使用端撰寫的元件定義、任意節點轉接器、Widget 插槽或渲染器回呼。
- 通用 runtime 交易、語意樣式解析或 application 環境安裝。
- 掌管 BlockNote 的正文模型／排版／選取／復原，或第二份即時編輯器狀態。
- 將每個舊版 Widget 都視為自動接受的宣告式元件。

## 目標階段與能力範圍

目前目標階段：建立單一封閉的現行元件目錄，明確標示每個公開功能符號的層級／所屬者，並隔離舊版 Widget 家族，直到其 P9 遷移／移除。

目前能力範圍：

- 內建編輯、工作區／版面配置，以及未來核准的功能節點，透過具型別的插槽組合。
- 每個語意元件身分都有一份現行宣告與一個本庫轉接器。
- 功能專屬的已準備紀錄掌管自身資料／引擎相依，並實作通用 foundation/runtime 協定。
- Application 組裝完整的內建轉接器集合；使用端只提供節點資料與語意事件。
- 舊版元件家族只有在滿足共同的語意、插槽與權責標準後，才逐一遷移。

此能力範圍不授權動態功能登錄表、任意外部元件套件，或將舊版 Widget 自動升格。

## 所屬路徑與公開介面

目前現行宣告式路徑：

- `editing/contracts/` 與 `editing/internal/` 轉接器。
- `workspace/components/`、`workspace/layout/` 及其內部轉接器。

套件內部遷移區：

- `navigation/rail/contracts/` 與 `navigation/rail/internal/`；目前沒有本庫所屬的公開項目，能讓此容器成為完整的使用端能力。

目前舊版／實驗性相容區：

- `actions`、`collections`、`feedback`、`forms`、`infinite_canvas`、`navigation/widgets`、`overlays`，以及大部分 `workspace` 路徑下的 Flutter Widget 家族。
- 在遷移或移除前，公開相容介面僅透過 `kallopis_foundation.dart` 或 `kallopis_experimental.dart` 提供。

透過 `kallopis_declarative.dart` 提供的現行公開介面：

- 本庫所屬的編輯、工作區與版面配置節點，其不可變資料／列舉，以及語意事件回呼。
- 只有在需要指定本庫元件子節點型別時，才提供插槽資格介面。
- 不提供元件定義、登錄表、轉接器、已準備紀錄、Widget、`BuildContext`、繪製器或樣式輸入。

僅限內部：

- 功能轉接器、定義／語意、已準備紀錄、放置資源及引擎橋接。

檔案選取等提供者／服務工具不是元件。宿主副作用必須移至明確的 application/capability 埠，不得成為宣告式元件來源。

## 責任分布與相依方向

| 區域 | 目標責任 | 允許的下層相依 | 目前矛盾 |
| --- | --- | --- | --- |
| 現行契約 | 具有受限插槽、由本庫掌管的不可變節點／資料／事件。 | Kernel、capabilities、composition 及已核准的外部資料契約。 | 部分公開節點類別可被擴充，且檔案選取器執行具體的平台副作用。 |
| 現行轉接器／已準備紀錄 | 將功能契約轉換為 runtime/foundation 協定，並掌管功能專屬資源。 | Kernel 至 runtime，以及 KLP-0020 允許的外部引擎轉接器。 | 編輯／工作區 presentation 各自擁有功能紀錄，實作 foundation 通用協定。 |
| 舊版穩定區 | 維持既有 Stable Widget 行為，直到明確遷移／P9。 | Flutter、舊版 styling/foundation 與下層呈現契約。 | 與現行宣告共用原始碼根目錄及名稱，由權責清冊的 compatibility 區分現行與舊版來源。 |
| 實驗區 | 孵育範圍受限且由 Kallopis 掌管的功能，不隱式進入 Stable 或現行宣告式來源。 | 與其宣告的架構層級相同。 | 實驗性 Widget 可能看起來像宣告式節點以外的另一個公開來源。 |
| 在地化使用 | 使用下層的呈現在地化契約。 | Foundation 在地化。 | 十二個功能指令已向下改用 foundation/localization，沒有 application 相依。 |

Features 僅相依於 L0–L4 契約。Rendering/application 相依於 features。Features 不得匯入這兩個上層模組。

## 不變條件、生命週期與錯誤權責

- 每個現行公開節點都有一個穩定的定義 ID、一個所屬功能區與一個本庫所屬轉接器。
- 每個組合子節點都經過具名插槽，該插槽具備所屬者、型別資格與數量限制。使用端不能將未知節點附加至無型別清單。
- 公開功能實例僅承載資料、借用狀態與語意事件；不接受渲染器／建構／樣式／繪製器回呼。
- 轉接器與已準備型別不對使用端匯出。功能專屬的引擎／工作階段／資源生命週期留在所屬功能內，並遵循 runtime 放置資源釋放規則。
- 新的 BlockNote 正文狀態仍透過 Krepis 由 BlockNote 掌管。Kallopis 編輯節點負責承載／呈現工作階段，不鏡像即時正文、選取或復原狀態。
- 同名的舊版與現行型別是不同的相容介面。`kallopis_declarative.dart` 是新使用端的正式來源；舊版重複型別不能進入其樹。
- 功能錯誤是具型別的能力回覆或功能準備失敗。Application 掌管使用者層級復原；runtime 掌管交易失敗。

## 允許與禁止的相依

現行功能允許：

- Kernel、capabilities、composition、styling、foundation 與套件內部 runtime 契約。
- KLP-0020 已接受的明確外部引擎資料／工作階段契約，並隔離於所屬編輯功能。
- Flutter/file-selector 僅能存在於權責明確的宿主／渲染相容路徑，不得存在於純宣告式節點。

舊版相容檔案允許：

- Flutter 與舊版 foundation/styling 契約，直到文件所載的遷移閘門。

禁止：

- Application 或 rendering 實作。
- 產品模型、儲存庫、持久化或產品 l10n 權責。
- 使用端註冊、自訂元件定義或轉接器清單。
- 具名跨模組契約建立後，直接匯入其他模組的 `internal/` 路徑。
- 第二份主題／環境／l10n 或即時編輯器權威。

## 採用設計與否決方案

採用：明確且封閉、由本庫掌管的宣告式功能節點與轉接器目錄。舊版 Widget 家族維持隔離的相容來源；只有透過已接受的功能遷移，定義資料／事件／插槽與本庫轉接器後，才加入現行目錄。

否決：從宣告式彙整匯出檔匯出所有舊版 Widget。這會保留任意 Widget 組合與多個來源，而非定義有限的語意目錄。

否決：因 Kallopis 會驗證語意，就允許使用端註冊功能範本。驗證無法建立本庫權責、跨產品意義或渲染器生命週期。

否決：將功能轉接器移入 runtime。這會讓 runtime 必須匯入每個具體功能與外部編輯器引擎，反轉通用引擎邊界。

## 目前階段切片

| 切片 | 產出 | 允許路徑 | 公開／跨模組契約 | 驗收證據 | 狀態 |
| --- | --- | --- | --- | --- | --- |
| `FEAT-V1-01` | 建立此契約並分類現行、實驗性與舊版來源。 | `lib/src/features/architecture.md`、登錄表狀態 | 無。 | 已清點現行匯出、舊版匯出、外部相依、重複名稱及向上匯入。 | complete（完成） |
| `FEAT-V1-02` | 建立確定性的現行元件權責清冊，依功能、層級、定義 ID、插槽資格與轉接器所屬者分類每個宣告式匯出。 | 本模組內的功能文件／中繼資料 | Composition/application 使用封閉清冊；排除舊版項目。 | 全部匯出／身分／資格／插槽與實際轉接器對照通過，錯誤清冊負向案例通過。 | complete（CC-V1-r1 已整合） |
| `FEAT-V1-03` | 將功能轉接器遷移至明確的 runtime 契約路徑，並從 application 組裝中移除使用端元件轉接器。 | 現行功能的 `internal/**` 路徑 | Runtime 發布套件內部轉接器／已準備紀錄／資源契約；application 僅組裝內建項目。 | 已移除使用端轉接器附加；完整轉接器清冊已完成；15 個直接呼叫檔已改用具名 runtime 路徑；既有跨目錄相對匯入亦已修正。 | complete（RC-V1-r1 已整合） |
| `FEAT-V1-04` | 將編輯／工作區／引擎專屬的已準備紀錄移出 foundation 通用繫結聯集，移至所屬功能區。 | 現行功能內部路徑 | Foundation 發布不對外匯出的通用已準備紀錄協定；rendering 使用功能紀錄。 | Foundation 沒有功能／引擎匯入；功能行為與生命週期檢查通過。 | complete（PRES-V1-r1 已整合） |
| `FEAT-V1-05` | 透過下層 foundation 契約使用在地化，並移除所有功能對 application 的匯入。 | 目前匯入 application 在地化的十二個功能檔案及其局部相依彙整匯出檔 | Foundation 掌管呈現在地化值；application 安裝這些值。 | 功能匯入圖沒有 application 相依邊，且在地化行為維持確定性。 | complete（L10N-V1-r2 已整合） |
| `FEAT-V1-06` | 以宿主掌管的檔案選取能力／語意事件，取代具體的 `KlpLocalFilePicker` 宣告式匯出。 | `workspace/components/klp_local_file_picker.dart` 及直接使用它的現行呼叫端 | Application/capability 埠掌管副作用；功能節點接收結果／事件資料。 | 宣告式功能契約不匯入 `file_selector`；使用端來源仍僅組合資料／事件。 | complete（HOST-PORTS-V1-r1 已整合） |
| `FEAT-V1-07` | 關閉現行節點擴充接縫，並記錄舊版名稱衝突／移除閘門。 | 現行公開節點檔案與功能權責清冊 | 內建節點型別仍可建構，但不能建立未註冊的語意元件。 | 外部自訂子類別／定義不能進入有效樹；`KlpExplorer` 與 `KlpWindowControls` 各自只有一個現行正式來源。 | complete（COMPAT-V1-r1 已整合） |
| `FEAT-V1-08` | 為既有內建工作區動作區塊加入語意 `KlpAction` 輸入，讓封閉目錄的使用端可透過 application 處理器提交導覽動作。 | `workspace/components/klp_workspace_block.dart`、其內部轉接器及獨立的 application 動作檢查 | Capabilities 掌管 `KlpAction`；功能透過 runtime 提供的處理器、放置身分與影格租約驗證及派送動作。 | 導覽可提交、被拒絕的根層返回不改變狀態，且已替換影格的回呼會撤銷；保留 `onPressed` 相容性，但不得與 `action` 同時提供。 | complete（完成） |
| `FEAT-V1-09` | 在有限的本庫項目目錄建立前，從使用端彙整匯出檔移除不完整的 rail 編寫資格。 | `lib/kallopis_declarative.dart`、使用端文件與獨立編譯契約 | 使用端使用已發布的工作區／版面配置節點；實作 `KlpRailItem` 不能建立另一個元件來源。 | `KlpRail`/`KlpRailItem` 不對使用端匯出，且工作區動作組合仍可編譯。 | complete（完成） |
| `FEAT-V1-10` | 為 Sidebar v2 補足可選取分支、不可選取結構列與內容選單專用政策。 | `workspace/components/klp_explorer.dart`、workspace component adapter 與 Explorer presentation | 公開契約採 `SIDEBAR-V2-EXPLORER-r1`；consumer 仍只提供資料與事件，不提供 Widget 或 style。 | branch、selectable 與 command presentation 的公開契約檢查通過，既有 file／folder 行為相容。 | READY |

`FEAT-V1-02` 的冷啟動估算：8,000–16,000 模型 token、60–150 分鐘。目前沒有可比較的已定案任務登錄項目。里程碑：匯出清冊、身分／轉接器對照、重複檢查，以及 application 目錄交接。超過 24,000 token 或 210 分鐘時，必須進行異常檢查點。

`FEAT-V1-10` 與 rendering 的配對契約及精確邊界見 [Sidebar v2 Explorer 配對計畫](../../../docs/architecture/sidebar-v2-explorer-plan/README.md)。

### 封閉目錄配對契約（CC-V1-r1）

以下是已完成批次的原寫入範圍；搬移後的現行 runtime 路徑以 RC-V1-r1 為準。

`FEAT-V1-02` 交付 `catalog/component-ownership.json`，欄位依共通規格 `CC-V1-r1`。逐一分類現行 feature 匯出符號，清點所有內建功能身分（含尚未公開的 rail），保留宣告、層級、語意擁有者、資格、插槽與 adapter factory／variant 對照。不得以「一個 Dart 檔或 adapter 類別」代替「一個身分」。多個身分可共用同一宣告或轉接器類別，但每個身分只有一份權責記錄。

JSON 是可查核的架構中繼資料；原始碼宣告仍為權威，不成為 runtime 登錄表。application 引用此清冊並記錄組裝順序與結構性節點，不重複維護 feature 宣告。舊版同名 Widget 只列於 compatibility，保留 P9 移除條件。不得新增節點、公開 rail、改轉接器行為或搬移 runtime 匯入。

任務包：[FEAT-V1-02](../../../docs/architecture/closed-catalog-plan/FEAT-V1-02.json)。獨立 Test Author 已完成清冊及整合檢查，本切片標為 complete；原 JSON 保留為規劃紀錄。

### Runtime 契約路徑配對（RC-V1-r1）

FEAT-V1-03 配對 15 個現行呼叫檔的 runtime URI 遷移，並修正 workspace adapter 已知四個跨目錄相對匯入；不改功能邏輯、身分與清冊。

共通規格 RC-V1-r1 已接受。精確路徑、分工與驗收見 [配對計畫](../../../docs/architecture/runtime-contract-plan/README.md)；全部套件內 runtime API 不由 consumer barrel 匯出，舊來源不保留轉匯出 shim。

### 語意驗證介面配對（SEM-V1-r1）

已接受共通規格SEM-V1-r1與 [精確範圍](../../../docs/architecture/semantic-module-plan/README.md)。composition只呼叫具名驗證操作，runtime與features使用明確解析契約路徑；styling維持唯一驗證／解析規則與錯誤。沒有consumer匯出或default變更。


SEM-V1-r1 已整合：39 項獨立邊界／語意圖與保留的綁定／rail／shadow 測試、18 項目錄／runtime／frame／import-root 測試通過；局部分析無問題。解析器搬移保持演算法等價，公開匯出不變。見 [驗證紀錄](../../../docs/architecture/semantic-module-plan/verification.md)。

### 通用與功能呈現配對（PRES-V1-r1）

已接受 [配對規格](../../../docs/architecture/presentation-module-plan/README.md) 與精確路徑。PRES-V1-r1：KlpBoundTemplate 原名／constructor 保留，路徑由 LOWER-V1-r1 具名契約接替，改為不對 consumer 匯出的 abstract class 協定。11 個通用 part 留 foundation；15 editing part 與 editing style、15 workspace part 各移至 features 自有 presentation library，不跨模組 part，不由 foundation reexport。兩個 feature library 都只作唯讀呈現資料，保留上游 controller／engine／callback 身分與生命週期，不新增權威。renderer 保留原 26 concrete 類型的分支與非視覺標記，未知套件內實作明確拋 KlpContractError('unsupported_prepared_template', ...)；不提供註冊或 fallback。另將 button style 與 toolbar 三檔實體移至 features/actions；KlpSelectionAction 留 foundation，filter bar 移除 toolbar export，僅 root kallopis_foundation.dart 直接 export 新 toolbar 以保留 Stable。所有舊移動路徑刪除而不設 shim；公開符號／constructor／範本／catalog 28 ID 順序與效果不變。FND-V1-03 全 foundation 無 features/runtime/rendering/application 或 Krepis/Canva/BlockNote import/export/part 的原要求不得縮小。

### 唯一呈現在地化配對（L10N-V1-r1）

已接受 [配對規格](../../../docs/architecture/localization-module-plan/README.md)。L10N-V1-r1：三個既有 application/localization 檔案作為同一 library 實體搬至 foundation/localization；保留型別、constructor、全部預設字串、savedLabel 私有函式、delegate load/shouldReload/isSupported、fallback 與 equality。這仍是既有 Flutter 呈現契約，不另建純 Dart 模型或第二來源。12 個 features 指令（含1 export）及1個 rendering import 精確向下遷移，全部 features/rendering 不得再依賴 application（含相對／條件／export／公開 barrel 旁路）；無其他host前置。application legacy只更新URI並保留consumer delegates在前的順序；宣告式 KlpApplication 的 WidgetsApp 必須安裝 const KlpLocalizationsDelegate()，不新增locale/override/public API。Stable kallopis_foundation.dart 只改export來源，其他公開符號/可達性/畫面字串/預設環境不變；舊src路徑刪除無shim。

## 驗收證據與測試狀態

L10N-V1-r2 已整合：179 項保護測試通過，包含全 features/rendering 無 application 相依、唯一字串來源、defaults／delegate／fallback／Stable 相容與宿主實際安裝。七段既有 BlockNote 錯誤原文已補入同一 l10n；原70字串保留。既有 host 六案例與保留已掛載編輯器測試亦通過；App 舊基線過期參數由獨立作者移除，discipline 只修註解誤判並保留原閘門。見 [本批驗證](../../../docs/architecture/localization-module-plan/verification.md)。


PRES-V1-r1 已整合：105 項保護測試及 16 項實際 renderer／filter／catalog／import-root 測試通過，35 個搬移實作與直接呼叫正文等價。全 foundation 無上層／引擎指令；26 個渲染型別保留，未知型別明確拒絕。Stable toolbar 名稱與身分相容。詳見 [本批驗證](../../../docs/architecture/presentation-module-plan/verification.md)。


2026-09-14，RC-V1-r1 配對整合完成：

- FEAT-V1-03 已完成：15 個呼叫檔改用具名 runtime 契約／入口，函式 body 逐檔等價。
- workspace adapter 四個跨目錄相對匯入已改 package root，既有 import-root 失敗已消除；功能身分、宣告、轉接器順序及權責清冊未變。
- FEAT-V1-04/05 已完成；FEAT-V1-06 檔案 host 與 FEAT-V1-07 公開節點仍依原要求。

- Green：19 份受影響測試共 139 項通過；application 與 import-root 共 14 項通過；本模組 scope gate PASS。完整群組與限制見 [本輪驗證](../../../docs/architecture/runtime-contract-plan/verification.md)。
- Red → Green：新跨模組邊界檢查先在基線因實際 internal 匯入而失敗，配對遷移後通過；不是缺檔／編譯錯誤。
- 測試保護：獨立作者遷移 20 個既有檔案並新增一個 guard，原案例／斷言與 fixture 行為保留。
- 上輪 [CC-V1-r1 證據](../../../docs/architecture/closed-catalog-plan/verification.md) 保留為歷史紀錄。未做全庫／感官或引擎保存驗收。

## 受保護路徑

- `lib/src/features/architecture.md`
- 編輯、工作區與版面配置的現行宣告式功能契約測試；rail 測試仍是套件內部行為檢查，不作為使用端 API 證據。
- 轉接器／資源生命週期與安裝測試。
- 禁止 Widget／樣式／自訂元件輸入的使用端編譯測試素材。
- `test/frontend_architecture_boundary_test.dart`
- 確定性的功能契約、語意、生命週期與安裝檢查；視覺基準不屬於受保護測試產物。

### 具名下層契約配對（LOWER-V1-r1）

LOWER-V1-r1：CAP-V1-02 與 REND-V1-04 配對，71 個既有檔案實體移至具名路徑；全部名稱、constructor、預設值、演算法、狀態與 callback 身分不變。Provider 42 個 editing export 與 9 個 part 移至 editing/contracts，根入口原 44 個 export 的符號可達性不變。draw_command_validation 留 internal，不新增公開；block_drop_preview 仍非公開，drop_target 與 editing_submission 為 editing/ 下具名套件內入口，保留整體演算法及狀態。Foundation 15 個通用 binding 檔案含 11 part 移至 binding/contracts，維持同 library、abstract KlpBoundTemplate 與非 consumer 公開協定；此條明確接替 PRES-V1-r1 的「路徑保留」，其名稱、constructor、模組責任與原行為仍保留。Styling 的 paper_shadow_recipe 與 control_density 移至各自具名入口，值與唯一來源不變。所有直接呼叫端與測試 URI 配對更新，不留 shim、不新增 export。完整 rendering 的 import/export/part/part-of/conditional 指令不得跨到任何其他模組 internal；不能只檢查 capabilities/foundation。維持 26 renderer 分支、28 catalog ID、未知類型拒絕、同模組 reciprocal part、Stable 與 provider 可達性。編輯 pending/resync、save job/confirmed revision、手寫生命週期與上游正文／undo 權威不變。CAP-V1-03 舊正文分類、FND-V1-05 metrics、host 與剩餘 APP-V1-06 不藉此宣告完成。

精確本模組範圍與派工條件見 [配對計畫](../../../docs/architecture/lower-contract-plan/README.md)。LOWER-V1-r1 已整合：71 個原始檔實體搬移與 57 個直接 caller（共 128 個來源）正文／指令身分等價；7 個 module scope、局部分析與獨立整合測試通過。Provider 公開身分不變，完整 renderer 無不允許的跨模組 internal 指令。見 [驗證](../../../docs/architecture/lower-contract-plan/verification.md)。

### 已重現文件閘門修復（METRICS-DOC-r1）

METRICS-DOC-r1 修復：原工作樹與本批皆重現 token_discipline 未文件化型別 95 > 45。保留原 baseline 45 與其他全部斷言不動；補 50 個既有 provider 與 workspace／prepared／asset 契約型別的繁體中文 dartdoc（25 capabilities、25 features）。每項說明真實用途及不擁有的責任；prepared 仍為套件內部呈現值，不誤宣稱 consumer API。只插入 declaration 前的 /// 行，移除新增行後逐 byte 還原原 source。禁止改 modifier、member、constructor、export、值或分支。本批 degree migration 的純正文等價證據須與這項單獨 comments-only 修復分列；不藉此完成 CAP-V1-03 或 FEAT-V1-07。原 token 閘門及局部分析驗證即可，不新增或修改測試。

METRICS-DOC-r1 已補本模組25個指定宣告文件，移除新增dartdoc後原bytes相同；scope通過，配對token閘門95→45且原baseline不變。此為文件修復，CAP-V1-03／FEAT-V1-07仍待原判準驗收。

### 相容用途與節點封閉配對（COMPAT-V1-r1）

COMPAT-V1-r1／CAP-V1-03：用途分類以符號及用途為準。舊 text/IME intent、request/reply、block/list/undo 操作、layout／hit testing／text window 與 pending-resync submission 僅作既有資料相容、必要維護與回退；新 BlockNote 不使用其即時正文操作建立第二交易／undo／正文權威。保留全部42 editing exports＋9 parts與root44exports、base provider snapshot/stream、save job/confirmed revision/unknown outcome、stamp identity、共用drawing／geometry／anchor／command資料與handwriting/mode合約；不將共享Projection/Endpoint一概棄用，不新增Deprecated警告、刪除export或停用舊路徑。手寫及Spatial未定案不在本片決定。新正文content/adapter/bound/renderer只借用原Krepis BlockNote controller/channel，正文／排版／選取／undo由上游掌管。共享presentation library為其他legacy parts匯入DTO合法；驗收依BlockNote typed members/操作，不把共享名稱解析誤當第二權威。

COMPAT-V1-r1／FEAT-V1-07：關閉清冊中仍開放的七個layout節點對外extends/implements，精確改為final class；原constructor/default/member/body/slots/definition IDs與合法建構保持。KlpLayoutNode等qualification仍可表達資料資格，不能取得註冊權或冒用已知catalog identity。真catalog必須以node_type_mismatch拒絕已知ID偽裝並保留前一個committed frame/resources。完整24feature components（23公開＋1rail）、28總ID、67exports與ownership/presentation分工不變。舊Stable Explorer/WindowControls與新declarative canonical維持不同library面向；P9完整條件為下游完成遷移、無受支援舊入口匯入、相容證據及發布說明允許破壞性移除。仍有舊caller，不執行P9刪除。

用途分類與寫入清單以 [本配對計畫](../../../docs/architecture/compatibility-module-plan/README.md) 為準；COMPAT-V1-r1 已整合：用途分類保留provider／保存／身分／手寫與全部44exports；新BlockNote仍只借用上游正文controller。七個layout類型改final，55項外部建構／封閉／真catalog與相容檢查通過；新正文用途邊界5項、既有layout／BlockNote／provider37項通過。原constructor/default/member與其餘body不變，P9舊Stable來源未刪。見 [驗證](../../../docs/architecture/compatibility-module-plan/verification.md)。

### Application具名契約收尾（APP-CONTRACT-V1-r1）

APP-CONTRACT-V1-r1：APP-V1-06 剩餘完整 application foreign-internal 邊以25個既有來源實體歸具名路徑收尾。Kernel三個lifecycle來源、capabilities導航machine/兩exception及五part、composition scope boundary、十一features adapters、rendering renderer/viewport入口依精確map搬移。Renderer沒有parts；其餘平台實作保留同模組internal，具名入口的正常implementation imports不是consumer公開或跨模組穿透。Navigation五part隨原owner同library移動，狀態機／transaction／commit／lease／錯誤／回收body與callback身分不變。不得以轉匯出barrel遮住其他模組internal，不留舊shim；所有root公開library export指令與順序保持，25來源仍不公開。所有directcallers與36個catalog metadata字串同步原ID/factory/variant/順序，只替換路徑。features67exports／24component、application28ID保持。四個原未附文件的adapter只新增精確用途dartdoc以維持token baseline45，其餘非directive正文僅准行首tab正規化；去除這四新增註解後正文等價。不在這批實作R1/R2 lifecycle、filepicker或環境；後續使用新的rendering具名入口。

精確本模組範圍與派工條件見 [配對計畫](../../../docs/architecture/application-contract-plan/README.md)。APP-CONTRACT-V1-r1 已整合，七模組 scope、原行為、獨立 application 邊界與目錄檢查通過；見 [驗證](../../../docs/architecture/application-contract-plan/verification.md)。

### Renderer host 配對契約（REND-HOST-V1-r1）

REND-HOST-V1-r1 接受 REND-V1-05 的兩個實作里程碑。R1：features 純 Dart typed failure 經既有 viewport sink 由 application 安裝，原始 error/stack 與 origin/phase 送既有 recovery；renderer local input/binding 以捕捉身分且冪等的 detach 在所有 interrupt 結果後 finally 釋放。R2：兩 WebView 使用 controller identity key 與固定 attachment，依上游既有 bind 排他規則只解除自己成功取得的 sender；每個 await 後檢驗存活。BlockNote 開啟成功立即標記，後續 flush/callback 失敗不得重播初始文件；Canva 去重且不新增自動重試或 UI。環境 late result/dispose 只有一次清理及回報。借用的 provider/controller 不 close/save，不新增正文、theme、environment、l10n 或全域 registry 權威。細部已接受 API、失敗歸屬與驗收由同版 path-map 決策定義。R1 只代表部分完成，R1/R2 與整合證據全部通過才完成 REND-V1-05。

具體 API 與本模組寫入路徑见 [配對計畫](../../../docs/architecture/rendering-host-plan/README.md)。REND-HOST-V1-r1 已整合，文字與 WebView 的真實生命週期、原行為、公開／模組邊界及 scope 已通過，見 [驗證](../../../docs/architecture/rendering-host-plan/verification.md)。

### Host ports 配對（HOST-PORTS-V1-r1）

HOST-PORTS-V1-r1 接受 APP-V1-05／FEAT-V1-06 的 E 環境與 P 檔案選取配對。Capabilities 持有純環境解析及既有 KlpAppPlatform／KlpAdaptiveMode 唯一宣告，Stable foundation 原 facade、型別與 current(Size?) 行為保留；application 唯一既有 host 採樣並安裝，不增加 observer、store 或預設。P 接替已接受的 concrete picker 宣告式面：公開 L1 KlpPickFileAction，port/result 套件內部；application 唯一 plugin adapter，既有 action handler 用原 frame/lease/epoch/entry 在 await 前後檢驗。有效 selected 才回呼一次，cancel/stale/failed 為 false，平台或 callback error 原物件／stack 由 host 一次回報。舊零 host picker 搬 application/legacy 並由專用 legacy root 保留 const/欄位/pick Future 成功取消與原 error 傳播；不作現行宿主 fallback。公開 roots 6→7，僅 declarative 一增一刪及新 legacy，feature exports 67→66，24 components/28 IDs/順序保持。原 R1/APP06 root/hash/closure/catalog 基準依 path-map 精確增減由獨立作者更新，不 blanket resnapshot 或放寬原守衛。E 單獨不完成 APP05；E/P 與完整證據通過才 APP05/FEAT06 complete。

具體值與派工範圍見 [配對計畫](../../../docs/architecture/host-ports-plan/README.md)。實作驗證待完成。

HOST-PORTS-V1-r1 的 E／P 配對已整合，原環境相容與租約／錯誤／公開邊界檢查通過；見[最終驗證](../../../docs/architecture/host-ports-plan/verification.md)。完整 CI 的既存失敗另列，不代表發布全綠。
