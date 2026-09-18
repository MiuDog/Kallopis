# Application 模組架構

## CAT-MIG-01：舊 Catalog 全面遷移的選單切片

當前新增切片依 [CM-01 共通契約](../../../docs/architecture/catalog-migration/README.md) 配對，PLAN READY。僅授權該契約列出的本模組路徑；既有已接受元件、全域 preset 與其他階段保持。最終以固定舊 Catalog 基準逐項完成新版後刪除舊元件，不能以此首批宣稱全面完成。


Explorer 同批切換依 [EXP-V1-r2](../../../docs/architecture/explorer-v1-plan/README.md)：bootstrap 清冊在原順序改為 kallopis.explorer.entry，不保留舊 item schema。公開 library 與 Catalog 由整合 steward 配對，不新增產品模板或 runtime 註冊權限。

Status: PLAN READY — v1 已接受最終組合根、封閉內建轉接器目錄與宿主生命週期

阻擋中的架構決策：無。BUILD 仍依下列切片分開執行；公開相容性變更必須遵循已接受的 KLP-0019 替換契約。

權威依據：[模組登錄表](../architecture.md)、[模組架構 v1 規格](../../../spec/module-architecture-v1.md)、[KLP-0019](../../../spec/decisions/KLP-0019-declarative-framework-migration.md)、[KLP-0020](../../../spec/decisions/KLP-0020-blocknote-editor-adoption.md)

## 目的

`application` 是 Kallopis 的 L7 組合根。它掌管公開的應用程式／畫面／路由器宣告、單一應用程式工作階段、導覽投影、宿主環境安裝、完整的本庫所屬轉接器目錄，以及私有渲染器的建構。它將使用端透過 `kallopis_declarative.dart` 組合的資料／事件，轉換為單一已驗證的應用程式樹。

## 非目標

- 使用端的元件、轉接器、編譯器、渲染器或登錄表編寫。
- 功能呈現語意、通用 runtime 編譯、樣式解析或平台渲染實作。
- 產品持久化、儲存庫、產品專屬路由或產品在地化內容。
- 第二個元件來源、主題／環境／在地化權威，或即時編輯器狀態。
- 透過公開應用程式宣告暴露 Flutter Widget／`BuildContext`／繪製器／樣式回呼。

## 目標階段與能力範圍

目前目標階段：已移除使用端公開元件輸入與動態 application 轉接器附加。CC-V1-r1 已配對退役舊版 runtime 元件輸入；接下來將在地化與宿主能力的相依反轉至下層契約，且不拆分單一工作階段。

目前能力範圍：

- 使用端僅使用 `kallopis_declarative.dart` 匯出的節點，建構 `KlpApplication`、具型別路由及 `KlpScreen`。
- Application 恰好組裝一份本庫所屬轉接器目錄、驗證一棵保留樹，並提交一筆影格交易。
- 路由器／工作階段身分、還原及 epoch 順序仍由 application 掌管。
- Application 觀察宿主環境，並將框架中立的能力／在地化值安裝至下層契約。
- 新的本庫元件只能透過已接受的模組契約、公開匯出決策、所屬轉接器，以及完整渲染器支援進入。

此能力範圍不授權使用端登錄表、外掛探索、任意外部節點，或每個功能各自的應用程式工作階段。

## 所屬路徑與公開介面

所屬路徑：

- `structure/`：應用程式與畫面宣告，以及保留畫面的內部結構。
- `routing/`：具型別路由宣告、輸入及還原投影。
- `bootstrap/`：公開啟動入口，以及私有宿主／工作階段／目錄組裝。
- `environment/`：宿主觀察與安裝接線。
- 在地化字串契約由 foundation/localization 擁有；本模組只在宿主安裝。
- `legacy/`：Stable Widget 時期的應用程式相容層，與現行宣告式樹隔離。

透過 `kallopis_declarative.dart` 提供的現行公開介面：

- `KlpApplication`、`KlpScreen` 及其具型別的應用程式／路由器輸入。
- 透過 application library part 提供的 `runKlpApp`。
- 使用端欄位僅限應用程式中繼資料、基元、路由器／狀態／還原回呼，以及語意資料／事件。
- L0–L7 權責與排除的編寫／runtime 型別記錄於 `docs/architecture/declarative-public-surface.md`。

`KlpApplication.components`、`KlpComponentDefinition`、`KlpDefinition`、`KlpRegistry`、已驗證樹的細節及轉接器／編譯器型別，都不是目標使用端介面。Rendering/bootstrap/session 實作保持私有。

## 責任分布與相依方向

| 區域 | 目標責任 | 允許的下層相依 | 目前狀態或剩餘債務 |
| --- | --- | --- | --- |
| 公開應用程式結構 | 應用程式中繼資料、基元、路由器與還原輸出。 | Kernel 至 features 的公開契約。 | 已封閉：`KlpApplication` 沒有使用端元件欄位。 |
| 內建目錄 | 組裝有限且由本庫掌管的結構／功能轉接器集合。 | Composition/runtime 具名契約與功能轉接器。 | 組裝端已封閉；完整權責清冊與實際 28 個內建身分核對通過。 |
| 工作階段／交易 | 投影保留路由、提交一次 runtime 更新，並發布已提交的導覽／還原。 | Capabilities、composition、runtime。 | Application 不提交使用端定義；已配對移除 runtime 舊 components 參數。 |
| 宿主／環境 | 觀察 Flutter 宿主狀態，並安裝框架中立的能力值。 | Capabilities/foundation 契約與私有 rendering 建構。 | 純平台值及 l10n 已有下層唯一契約；具體宿主副作用仍依 APP-V1-05。 |
| 舊版相容 | 在 P9 前保留 Stable `KlpApp` 行為，且不進入現行樹。 | 舊版 foundation/styling/rendering 路徑。 | Stable delegate 覆寫順序保留；features/rendering 已全部改用 foundation l10n。 |

Application 作為最終組合根，可相依於所有下層。任何下層模組都不得匯入 application。

## 不變條件、生命週期與錯誤權責

- 一個 `runKlpApp` 宿主掌管一個 `_KlpApplicationSession`；一個工作階段掌管一個導覽狀態機、runtime 與目前已提交影格。
- 路由器身分與初始位置在工作階段中不可變更。保留目的地存在於導覽快照期間不得消失。
- 來源世代／epoch 拒絕過期的非同步動作。新動作只有在完整保留樹提交後才有效。
- 轉接器目錄具有確定性、由本庫掌管且完整。使用端不能附加、取代或遮蔽元件身分。
- Application 向 runtime 提交基元、根樹、動作處理器與環境；不提交使用端元件定義。
- Application 選擇／安裝宿主語系與環境值，但可重用的呈現契約位於 application 之下，讓 features/rendering 永不向上匯入。
- Runtime／安裝錯誤保留交易提交狀態。Application 掌管終端宿主復原與回報；不能將已提交的局部失敗標記為已回滾。

## 允許與禁止的相依

允許：

- L0–L6 的公開及具名套件內部契約。
- 私有宿主／bootstrap／legacy 實作中的 Flutter。
- 私有建構 Kallopis 渲染器，以及集中列舉本庫所屬轉接器。

禁止：

- 使用端 `KlpComponentDefinition`、登錄表、轉接器／編譯器清單或渲染器回呼。
- 產品模型、儲存庫、持久化，或產品路由／在地化權責。
- 同一棵應用程式樹使用多個 runtime／工作階段／元件目錄。
- 透過宣告式彙整匯出檔匯出 application 內部實作或原生宿主物件。
- 下層模組為使用在地化、環境或便利型別而匯入 application。

## 採用設計與否決方案

採用：application 是唯一的最終組合根，掌管封閉且明確的本庫轉接器目錄。使用端僅透過宣告式彙整匯出檔，組合本庫所屬節點與受限插槽。

否決：將 `KlpApplication.components` 保留為進階逃生通道。這會讓使用端成為另一個元件來源、允許語意身分遮蔽，並迫使 runtime/rendering 接受無界目錄。

否決：將轉接器探索移至 runtime。通用 runtime 將需要了解具體功能，並成為服務定位器，而非有界的編譯器／安裝器。

否決：讓每個功能掌管獨立的宿主／工作階段。這會拆分交易、路由還原、資源放置與錯誤權威。

## 目前階段切片

| 切片 | 產出 | 允許路徑 | 公開／跨模組契約 | 驗收證據 | 狀態 |
| --- | --- | --- | --- | --- | --- |
| `APP-V1-01` | 建立此契約，並清點公開介面／工作階段／目錄權責。 | `lib/src/application/architecture.md`、登錄表狀態 | 無。 | 已記錄公開匯出、目錄組裝、runtime 更新輸入及向上匯入的使用方。 | complete（完成） |
| `APP-V1-02` | 移除 `KlpApplication.components`，以及工作階段的使用端元件轉送。 | Application structure/bootstrap，加上使用端編譯測試素材／文件 | KLP-0019 封閉目錄；現行宣告式 API 不保留相容別名。 | 外部元件註冊不再能編譯；內建應用程式仍可建構與提交。 | complete（完成） |
| `APP-V1-03` | 以確定性的本庫所屬轉接器目錄，取代動態元件轉接器附加。 | `bootstrap/internal/klp_application_adapters.dart` 與所屬目錄中繼資料 | Feature/composition 清冊將每個內建身分對應至一個轉接器。 | 28 個內建身分與實際展開順序相等；權責清冊及 session 整合檢查通過。 | complete（CC-V1-r1 已整合） |
| `APP-V1-04` | 安裝下層在地化契約，並移除所有 feature/rendering 對 application 的匯入。 | Application 在地化／環境接線，加上下層契約整合 | Foundation 掌管呈現在地化；application 選擇／安裝值。 | 匯入圖沒有 application 循環相依；在地化行為維持確定性。 | complete（L10N-V1-r2 已整合） |
| `APP-V1-05` | 透過下層埠安裝裝置／顯示／方向與宿主副作用能力。 | Application environment/bootstrap 與能力轉接器 | Capabilities 掌管環境／檔案選取埠；功能節點接收語意結果／事件。 | Foundation 不再掌管宿主能力值；宣告式功能不直接執行檔案選取副作用。 | complete（HOST-PORTS-V1-r1 已整合） |
| `APP-V1-06` | 將 application 的跨模組匯入統一至具名套件內部契約。 | Application bootstrap/session 匯入與下層契約路徑 | Runtime/composition/features 發布明確的內部契約。 | 架構閘門回報 application 沒有不允許的跨模組 `internal` 匯入。 | complete（APP-CONTRACT-V1-r1 已整合） |
| `APP-V1-07` | 僅在已提交導覽值或觀察者變更時發布還原輸出；宿主／自適應更新重新編譯同一棵樹時不發布。 | `bootstrap/internal/klp_application_session.dart`、`klp_application_session_commit.dart` | Application 工作階段仍是唯一的還原通知所屬者；以正規路由 URI 作為比較值。 | 初始還原堆疊發布一次、導覽發布新堆疊、替換後的觀察者收到目前狀態，且拋出例外的觀察者可重試。 | complete（完成） |
| `APP-V1-08` | 將宣告式彙整匯出檔整理為依層級組織的有限使用端介面。 | `lib/kallopis_declarative.dart`、公開介面文件與獨立編譯契約 | 動作執行、語意／範本編寫、目錄驗證與不完整 rail 資格維持套件內部。 | 合法的內建組合可編譯，被禁止的公開名稱則不可編譯。 | complete（完成） |

`APP-V1-02` 的冷啟動估算：7,000–14,000 模型 token、60–140 分鐘。目前沒有可比較的已定案任務登錄項目。里程碑：公開建構子變更、runtime 輸入封閉、範例／文件遷移，以及禁止使用端輸入的編譯證據。超過 24,000 token 或 210 分鐘時，必須進行異常檢查點。

### 封閉目錄配對契約（CC-V1-r1）

以下是已完成批次的原寫入範圍；搬移後的現行 runtime 路徑以 RC-V1-r1 為準。

`APP-V1-03` 的已接受寫入範圍為 `bootstrap/internal/klp_application_catalog.json`、`klp_application_adapters.dart` 及 `klp_application_session_commit.dart`。依共通規格 `CC-V1-r1`，清冊引用 features 權責檔、列出結構節點權責及既有 adapter 組裝順序；不得由使用端輸入或 JSON 動態載入元件。維持 `klpApplicationAdapters()` 零參數與既有清單順序，不為重構而更換 API。

同一任務包移除 session 的空 `components: const []`，配對 `RUN-V1-03` 新簽名。這是已接受 runtime 退役的直接呼叫端遷移，不重開 `APP-V1-02`。保留 adaptive、scope boundary、retained screens、screen 與內部 rail 目錄項目；完整性以實際 adapter 展開結果比對，而非只數公開元件。

任務包：[APP-V1-03](../../../docs/architecture/closed-catalog-plan/APP-V1-03.json)。清冊與 Test Author 完整性證據已通過，本切片標為 complete；原 JSON 保留為規劃紀錄。

### Runtime 契約路徑配對（RC-V1-r1）

APP-V1-06-RUNTIME 僅完成 APP-V1-06 的 runtime 部分：5 個 Dart 檔改具名契約／組裝入口，清冊的 scope adapter source_path 同步實際來源。其他 composition/features internal 契約仍待配對，整個 APP-V1-06 不標 complete。

共通規格 RC-V1-r1 已接受。精確路徑、分工與驗收見 [配對計畫](../../../docs/architecture/runtime-contract-plan/README.md)；全部套件內 runtime API 不由 consumer barrel 匯出，舊來源不保留轉匯出 shim。

### 自適應責任配對（AD-V1-r1）

已接受共通規格 AD-V1-r1；本模組精確寫入範圍見 [配對計畫](../../../docs/architecture/adaptive-module-plan/README.md) 的 path-map。composition 保留宣告／策略，runtime 掌管 adaptive 實作，capabilities 擁有三個平台 enum，foundation 舊路徑以相容轉匯出維持同一型別；application 僅同步目錄來源。無新 API 或環境權威。

### 唯一呈現在地化配對（L10N-V1-r1）

已接受 [配對規格](../../../docs/architecture/localization-module-plan/README.md)。L10N-V1-r1：三個既有 application/localization 檔案作為同一 library 實體搬至 foundation/localization；保留型別、constructor、全部預設字串、savedLabel 私有函式、delegate load/shouldReload/isSupported、fallback 與 equality。這仍是既有 Flutter 呈現契約，不另建純 Dart 模型或第二來源。12 個 features 指令（含1 export）及1個 rendering import 精確向下遷移，全部 features/rendering 不得再依賴 application（含相對／條件／export／公開 barrel 旁路）；無其他host前置。application legacy只更新URI並保留consumer delegates在前的順序；宣告式 KlpApplication 的 WidgetsApp 必須安裝 const KlpLocalizationsDelegate()，不新增locale/override/public API。Stable kallopis_foundation.dart 只改export來源，其他公開符號/可達性/畫面字串/預設環境不變；舊src路徑刪除無shim。

## 驗收證據與測試狀態

L10N-V1-r2 已整合：179 項保護測試通過，包含全 features/rendering 無 application 相依、唯一字串來源、defaults／delegate／fallback／Stable 相容與宿主實際安裝。七段既有 BlockNote 錯誤原文已補入同一 l10n；原70字串保留。既有 host 六案例與保留已掛載編輯器測試亦通過；App 舊基線過期參數由獨立作者移除，discipline 只修註解誤判並保留原閘門。見 [本批驗證](../../../docs/architecture/localization-module-plan/verification.md)。


AD-V1-r1 最新證據：5 個模組 scope PASS，composition 沒有 runtime/foundation 指令；既有自適應／catalog／runtime／scope／root-import／runtime 邊界共 28 項與新增邊界／enum 相容身分檢查均通過。capabilities 擁有三個純 enum，foundation 轉匯出仍是同型別；application 僅更新真實 adapter 來源，不將 APP-V1-05/06 全部結案。詳見 [本批驗證](../../../docs/architecture/adaptive-module-plan/verification.md)。

2026-09-14，RC-V1-r1 配對整合完成：

- APP-V1-06 的 runtime 部分已完成：5 個 Dart 檔的 URI 與清冊兩處 scope adapter 來源同步實際搬移，函式 body／API／28 個身分與組裝順序不變。
- 13 項 router/session 與 application review 檢查通過；runtime 契約不經任何 consumer barrel 匯出。
- RC-V1-r1 當時僅完成 runtime 部分；APP-CONTRACT-V1-r1 已補齊其餘具名契約。APP-V1-04 已完成唯一 l10n 安裝及相依反轉。

- Green：19 份受影響測試共 139 項通過；application 與 import-root 共 14 項通過；本模組 scope gate PASS。完整群組與限制見 [本輪驗證](../../../docs/architecture/runtime-contract-plan/verification.md)。
- Red → Green：新跨模組邊界檢查先在基線因實際 internal 匯入而失敗，配對遷移後通過；不是缺檔／編譯錯誤。
- 測試保護：獨立作者遷移 20 個既有檔案並新增一個 guard，原案例／斷言與 fixture 行為保留。
- 上輪 [CC-V1-r1 證據](../../../docs/architecture/closed-catalog-plan/verification.md) 保留為歷史紀錄。未做全庫／感官或引擎保存驗收。

## 受保護路徑

- `lib/src/application/architecture.md`
- Application 工作階段、導覽、還原、交易與世代順序檢查。
- 封閉目錄身分與禁止使用端輸入的編譯測試素材。
- `test/frontend_architecture_boundary_test.dart`
- 視覺／golden 測試與 PNG 基準已退役；確定性的 application 生命週期與公開邊界檢查仍受保護。

### 具名下層契約配對（LOWER-V1-r1）

LOWER-V1-r1：CAP-V1-02 與 REND-V1-04 配對，71 個既有檔案實體移至具名路徑；全部名稱、constructor、預設值、演算法、狀態與 callback 身分不變。Provider 42 個 editing export 與 9 個 part 移至 editing/contracts，根入口原 44 個 export 的符號可達性不變。draw_command_validation 留 internal，不新增公開；block_drop_preview 仍非公開，drop_target 與 editing_submission 為 editing/ 下具名套件內入口，保留整體演算法及狀態。Foundation 15 個通用 binding 檔案含 11 part 移至 binding/contracts，維持同 library、abstract KlpBoundTemplate 與非 consumer 公開協定；此條明確接替 PRES-V1-r1 的「路徑保留」，其名稱、constructor、模組責任與原行為仍保留。Styling 的 paper_shadow_recipe 與 control_density 移至各自具名入口，值與唯一來源不變。所有直接呼叫端與測試 URI 配對更新，不留 shim、不新增 export。完整 rendering 的 import/export/part/part-of/conditional 指令不得跨到任何其他模組 internal；不能只檢查 capabilities/foundation。維持 26 renderer 分支、28 catalog ID、未知類型拒絕、同模組 reciprocal part、Stable 與 provider 可達性。編輯 pending/resync、save job/confirmed revision、手寫生命週期與上游正文／undo 權威不變。CAP-V1-03 舊正文分類、FND-V1-05 metrics、host 與剩餘 APP-V1-06 不藉此宣告完成。

精確本模組範圍與派工條件見 [配對計畫](../../../docs/architecture/lower-contract-plan/README.md)。LOWER-V1-r1 已整合：71 個原始檔實體搬移與 57 個直接 caller（共 128 個來源）正文／指令身分等價；7 個 module scope、局部分析與獨立整合測試通過。Provider 公開身分不變，完整 renderer 無不允許的跨模組 internal 指令。見 [驗證](../../../docs/architecture/lower-contract-plan/verification.md)。

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
