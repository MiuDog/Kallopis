# 執行階段（runtime）模組架構

Status: PLAN READY — v1 的通用封閉目錄 runtime，以及與 foundation、composition、features 和 application 配對的介面邊界均已接受

阻擋中的架構決策：無。BUILD 仍依下列已接受的配對切片分開執行。

依據：[模組登錄表](../architecture.md)、[模組架構 v1 規格](../../../spec/module-architecture-v1.md)、[KLP-0019](../../../spec/decisions/KLP-0019-declarative-framework-migration.md)

## 目的

`runtime` 掌管通用的純 Dart 流程，將一棵已驗證的組合樹轉為已安裝且不可變的呈現影格。它定義函式庫內部轉接器契約、準備節點、解析函式庫自有目錄語意、以交易方式安裝／重用配置資源，並撤銷過期影格的操作。它位於 L4，不認識任何具體功能家族。

runtime 完全屬於 Kallopis 內部。使用端不建構 runtime，也不提供轉接器、元件定義或登錄表。

## 非目標

- 公開元件登錄或功能探索。
- 擁有節點／插槽／語意定義、功能行為或具體渲染。
- 產品狀態、持久化、導覽權威或編輯器引擎工作階段。
- 匯入功能實作以列舉目錄。
- 透過變更已接受資料，從視覺或產品錯誤中復原。

## 目標階段與能力範圍

目前目標階段：移除外部元件編譯、正式建立套件內部轉接器／已準備契約，並成為自適應／範圍準備實作的唯一擁有者。

目前能力範圍：

- 由 application 組裝提供的封閉函式庫轉接器集合。
- 單次更新交易：擷取／驗證、準備、建立／重用資源、具體化與提交。
- 跨更新保持穩定的配置識別與影格租約。
- 提交前回滾、提交後彙總清理問題，並明確拒絕已釋放／重入操作。
- 功能自有的已準備紀錄透過通用且不匯出的呈現協定跨越邊界。

此範圍不授權動態外掛、反射、服務定位，或讓使用端提供建構轉接器／渲染器的回呼。

## 所屬路徑與公開介面

目標所屬路徑：

- `contracts/`：套件內部跨模組 runtime 契約，例如節點轉接器、已準備節點／資源策略與準備環境。這些契約不從任何公開使用端函式庫匯出。
- `compilation/`：供 application 使用的具名樹 runtime 與 scope boundary adapter 組裝入口。
- `installation/`：具名預設資源；`installation/internal/` 僅保留 KlpInstallation 交易實作。
- runtime 自有的結構性 composition 節點轉接器／已準備實作，例如自適應／範圍邊界。

公開使用端介面：無。

供 application/features 使用的套件內部介面：

- `KlpNodeAdapter`：函式庫自有定義與準備行為。
- `KlpPreparedNode`：資源策略，以及具體化為通用 foundation 已準備協定的能力。
- `KlpPrepareContext`：以不可變方式存取已擷取來源、已驗證節點、原料、已解析樣式及動作派送；`RUN-V1-03` 移除舊 `components` 編譯器服務。
- `KlpPlacementResource`：與單一配置綁定的更新／釋放生命週期。

原始碼路徑必須表達跨模組用途；這些契約不能一面被 features/application 廣泛匯入，一面仍放在另一模組的 `internal/` 目錄。

## 責任分布與相依方向

| 區域 | 責任 | 允許的下層相依 | 目前矛盾 |
| --- | --- | --- | --- |
| runtime 契約 | 定義函式庫轉接器如何準備已驗證節點，以及擁有配置資源。 | kernel、capabilities、composition、styling、foundation。 | 介面／值／政策已移至 `contracts/`；具體組裝入口位於 compilation/installation 根層。 |
| 編譯 | 協調擷取、目錄驗證、準備、樣式解析、具體化與影格提交。 | 全部下層契約模組。 | 已移除舊元件輸入與編譯器；僅由本庫轉接器 contract 建立 registry。 |
| 安裝 | 依配置識別，以交易方式建立／重用／更新／釋放資源。 | kernel、capabilities 與已驗證的 composition 快照。 | 資源／失敗契約與具名預設實作已分開；交易演算法保留 internal。 |
| 結構轉接器 | 準備 composition 自有結構節點，不包含功能行為。 | composition 與 runtime/foundation 契約。 | 自適應轉接器／已準備實作已由 runtime 擁有，composition 不再向上匯入。 |

runtime 相依於 L0–L3 契約。features、rendering 和 application 可使用 runtime 套件內部契約；runtime 絕不匯入這些上層模組。

## 不變條件、生命週期與錯誤權責

- 每次更新都不可重入，且釋放後拒絕更新。
- 任何新資源可見之前，完整的樹／目錄／樣式準備必須成功。
- 提交前失敗時保留上一個影格／資源；提交後清理失敗時公布已提交狀態，並回報彙總問題。
- 配置重用要求配置識別、定義識別相同，且獲得已準備資源策略的核准。
- 在過期操作可能指向已替換資源前，撤銷舊影格租約。
- 具體化只讀取已驗證／已準備快照，不重新讀取宣告式節點 getter。
- runtime 目錄輸入由函式庫擁有，且對目前 Kallopis 建置完整；未知節點在安裝前失敗。
- `KlpInstallationException` 掌管交易階段與彙總實作失敗。功能錯誤保留在具型別的功能回覆中；渲染錯誤仍由 rendering/application 掌管。

## 允許與禁止的相依

允許：

- L0 kernel 識別／生命週期／診斷。
- L1 capabilities 動作／狀態與 styling 值／解析介面。
- L2 composition 內部已驗證／目錄契約。
- L3 foundation 通用已準備呈現契約。
- Dart SDK。

禁止：

- 具體功能、rendering 或 application 實作。
- 使用端元件定義、登錄表、轉接器或渲染器回呼。
- Flutter/Material/WebView 與具體編輯器引擎。
- 產品儲存庫、持久化，或第二份資料／主題／環境／l10n 來源。
- 在具名介面切片完成後，跨模組匯入 styling/foundation/composition 的 `internal/` 路徑。

## 採用設計與否決方案

採用：application 組裝封閉的函式庫轉接器清單；runtime 驗證其定義並執行通用交易。轉接器契約移至明確的套件內部 `contracts/` 路徑，讓上層模組相依於穩定介面邊界，而非實作檔案。

否決：由 runtime 掃描 features 或反射節點類別。這會使 Dart 建置／執行行為隱晦、順序不穩定，並讓功能權責洩漏到引擎。

否決：由使用端提供元件，再由 runtime 驗證。驗證無法將無界限的外部目錄轉為 Kallopis 自有的唯一元件來源。

否決：由功能模組擁有安裝交易。這會讓每個元件家族重複實作資源、回滾與租約行為。

## 目前階段切片

| 切片 | 成果 | 允許路徑 | 公開／跨模組契約 | 驗收證據 | 狀態 |
| --- | --- | --- | --- | --- | --- |
| `RUN-V1-01` | 建立本契約並稽核 runtime 介面邊界／生命週期。 | `lib/src/runtime/architecture.md`、登錄表狀態 | 無。 | runtime 沒有公開匯出、不匯入上層 features/rendering/application 實作，且已辨識目前的自訂元件輸入。 | complete（已完成） |
| `RUN-V1-02` | 將跨模組轉接器、已準備節點、環境、資源與策略介面，從 `internal/` 移至明確的套件內部契約路徑。 | `lib/src/runtime/compilation/**`、`installation/**`、新的 `contracts/**` | features/application 實作或使用契約；沒有公開匯出入口匯出這些契約。 | 沒有上層模組匯入 `runtime/**/internal`；runtime 行為檢查維持不變。 | complete（RC-V1-r1 已整合） |
| `RUN-V1-03` | 從 `KlpTreeRuntime.update` 移除 `components`，將 `KlpComponentAdapter` 與自訂 `KlpComponentCompiler` 退役，並僅由函式庫轉接器建立登錄表。 | `lib/src/runtime/**` | application 提供封閉的內建轉接器集合；composition 擁有內部目錄驗證。 | 舊 components 輸入已移除；內建樹、未知身分拒絕與交易檢查通過。 | complete（CC-V1-r1 已整合） |
| `RUN-V1-04` | 接收 composition 的自適應轉接器／已準備實作。 | runtime 結構轉接器路徑 | composition 只公布自適應節點／策略契約；runtime 擁有準備／資源行為。 | composition 沒有 runtime/foundation 匯入；自適應選擇與單一子節點具體化檢查通過。 | complete（AD-V1-r1 已整合） |
| `RUN-V1-05` | 使用具名 styling 語意驗證／解析介面，取代 styling 的 `internal/` 路徑。 | runtime 編譯／環境匯入 | styling 維持解析器權威；runtime 接收不可變解析結果。 | 沒有 runtime 檔案匯入另一模組的 `internal/` 解析器路徑。 | complete（SEM-V1-r1 已整合） |

`RUN-V1-03` 的冷啟動估算：8,000–16,000 模型 token，60–150 分鐘。沒有可比較的已定案登錄任務。里程碑：移除外部輸入、封閉 application 轉接器組裝、將編譯器／轉接器退役，以及執行局部 runtime 整合驗證。超過 24,000 token 或 210 分鐘時，必須進行異常檢查。

### 封閉目錄配對契約（CC-V1-r1）

以下是已完成批次的原寫入範圍；搬移後的現行 runtime 路徑以 RC-V1-r1 為準。

`RUN-V1-03` 修改範圍固定為 `compilation/internal/klp_tree_runtime.dart`、`klp_prepare_context.dart`，並退役同目錄的 `klp_component_adapter.dart`。移除 `update.components`、context 編譯器欄位、舊定義快照／編譯器建立／自訂範本預驗證迴圈；以現有 `adapters` 的 `contract` 建構唯一 registry。其餘準備、安裝、提交、回滾、資源重用與租約機制維持。

production 的完整轉接器目錄由 application 提供，runtime 不匯入 feature/application，也不讀清冊 JSON。測試可使用套件內轉接器注入交易失敗，不因此建立受支援的 consumer 擴充點。`RUN-V1-02` 不是前置，本輪不搬移契約路徑。

依共通規格 `CC-V1-r1` 與 foundation 退役、application 呼叫端、Test Author 配對整合；單方簽名變更造成的暫時編譯失配只記為 integration-pending。任務包：[RUN-V1-03](../../../docs/architecture/closed-catalog-plan/RUN-V1-03.json)。切片已配對整合完成；實際執行紀錄見結案報告。

### Runtime 契約路徑配對（RC-V1-r1）

RUN-V1-02 採實體搬移：8 個 contracts、3 個具名組裝／預設實作入口；KlpInstallation 保留 internal。來源／目標逐檔依 path-map，public barrel、型別宣告、交易演算法不變。

共通規格 RC-V1-r1 已接受。精確路徑、分工與驗收見 [配對計畫](../../../docs/architecture/runtime-contract-plan/README.md)；全部套件內 runtime API 不由 consumer barrel 匯出，舊來源不保留轉匯出 shim。

### 自適應責任配對（AD-V1-r1）

已接受共通規格 AD-V1-r1；本模組精確寫入範圍見 [配對計畫](../../../docs/architecture/adaptive-module-plan/README.md) 的 path-map。composition 保留宣告／策略，runtime 掌管 adaptive 實作，capabilities 擁有三個平台 enum，foundation 舊路徑以相容轉匯出維持同一型別；application 僅同步目錄來源。無新 API 或環境權威。

### 語意驗證介面配對（SEM-V1-r1）

已接受共通規格SEM-V1-r1與 [精確範圍](../../../docs/architecture/semantic-module-plan/README.md)。composition只呼叫具名驗證操作，runtime與features使用明確解析契約路徑；styling維持唯一驗證／解析規則與錯誤。沒有consumer匯出或default變更。


SEM-V1-r1 已整合：39 項獨立邊界／語意圖與保留的綁定／rail／shadow 測試、18 項目錄／runtime／frame／import-root 測試通過；局部分析無問題。解析器搬移保持演算法等價，公開匯出不變。見 [驗證紀錄](../../../docs/architecture/semantic-module-plan/verification.md)。

## 驗收證據與測試狀態

AD-V1-r1 最新證據：5 個模組 scope PASS，composition 沒有 runtime/foundation 指令；既有自適應／catalog／runtime／scope／root-import／runtime 邊界共 28 項與新增邊界／enum 相容身分檢查均通過。capabilities 擁有三個純 enum，foundation 轉匯出仍是同型別；application 僅更新真實 adapter 來源，不將 APP-V1-05/06 全部結案。詳見 [本批驗證](../../../docs/architecture/adaptive-module-plan/verification.md)。

2026-09-14，RC-V1-r1 配對整合完成：

- RUN-V1-02 已完成：8 個 contracts 與 3 個具名組裝／預設實作入口實體搬移，11 個舊來源不保留 shim。
- KlpInstallation 留在 installation/internal；runtime 不新增上層相依。局部 analyzer 無問題，非 directive 的程式內容僅正規化縮排，API／演算法保持等價。
- 交易、未知節點拒絕、資源重用／rollback／lease 與 28 個實際目錄身分檢查通過。自適應實作權責已由 AD-V1-r1 完成，RUN-V1-05 已完成 styling 具名解析介面。

- Green：19 份受影響測試共 139 項通過；application 與 import-root 共 14 項通過；本模組 scope gate PASS。完整群組與限制見 [本輪驗證](../../../docs/architecture/runtime-contract-plan/verification.md)。
- Red → Green：新跨模組邊界檢查先在基線因實際 internal 匯入而失敗，配對遷移後通過；不是缺檔／編譯錯誤。
- 測試保護：獨立作者遷移 20 個既有檔案並新增一個 guard，原案例／斷言與 fixture 行為保留。
- 上輪 [CC-V1-r1 證據](../../../docs/architecture/closed-catalog-plan/verification.md) 保留為歷史紀錄。未做全庫／感官或引擎保存驗收。

## 受保護路徑

- `lib/src/runtime/architecture.md`
- runtime 安裝、樹更新、回滾、重入、影格租約與配置重用測試。
- `test/klp_tree_runtime_test.dart`
- `test/klp_installation_test.dart`
- `test/klp_scope_activation_test.dart`
- `test/klp_placement_identity_test.dart`
- `test/frontend_architecture_boundary_test.dart`

### 具名下層契約配對（LOWER-V1-r1）

LOWER-V1-r1：CAP-V1-02 與 REND-V1-04 配對，71 個既有檔案實體移至具名路徑；全部名稱、constructor、預設值、演算法、狀態與 callback 身分不變。Provider 42 個 editing export 與 9 個 part 移至 editing/contracts，根入口原 44 個 export 的符號可達性不變。draw_command_validation 留 internal，不新增公開；block_drop_preview 仍非公開，drop_target 與 editing_submission 為 editing/ 下具名套件內入口，保留整體演算法及狀態。Foundation 15 個通用 binding 檔案含 11 part 移至 binding/contracts，維持同 library、abstract KlpBoundTemplate 與非 consumer 公開協定；此條明確接替 PRES-V1-r1 的「路徑保留」，其名稱、constructor、模組責任與原行為仍保留。Styling 的 paper_shadow_recipe 與 control_density 移至各自具名入口，值與唯一來源不變。所有直接呼叫端與測試 URI 配對更新，不留 shim、不新增 export。完整 rendering 的 import/export/part/part-of/conditional 指令不得跨到任何其他模組 internal；不能只檢查 capabilities/foundation。維持 26 renderer 分支、28 catalog ID、未知類型拒絕、同模組 reciprocal part、Stable 與 provider 可達性。編輯 pending/resync、save job/confirmed revision、手寫生命週期與上游正文／undo 權威不變。CAP-V1-03 舊正文分類、FND-V1-05 metrics、host 與剩餘 APP-V1-06 不藉此宣告完成。

精確本模組範圍與派工條件見 [配對計畫](../../../docs/architecture/lower-contract-plan/README.md)。LOWER-V1-r1 已整合：71 個原始檔實體搬移與 57 個直接 caller（共 128 個來源）正文／指令身分等價；7 個 module scope、局部分析與獨立整合測試通過。Provider 公開身分不變，完整 renderer 無不允許的跨模組 internal 指令。見 [驗證](../../../docs/architecture/lower-contract-plan/verification.md)。

### Application具名契約收尾（APP-CONTRACT-V1-r1）

APP-CONTRACT-V1-r1：APP-V1-06 剩餘完整 application foreign-internal 邊以25個既有來源實體歸具名路徑收尾。Kernel三個lifecycle來源、capabilities導航machine/兩exception及五part、composition scope boundary、十一features adapters、rendering renderer/viewport入口依精確map搬移。Renderer沒有parts；其餘平台實作保留同模組internal，具名入口的正常implementation imports不是consumer公開或跨模組穿透。Navigation五part隨原owner同library移動，狀態機／transaction／commit／lease／錯誤／回收body與callback身分不變。不得以轉匯出barrel遮住其他模組internal，不留舊shim；所有root公開library export指令與順序保持，25來源仍不公開。所有directcallers與36個catalog metadata字串同步原ID/factory/variant/順序，只替換路徑。features67exports／24component、application28ID保持。四個原未附文件的adapter只新增精確用途dartdoc以維持token baseline45，其餘非directive正文僅准行首tab正規化；去除這四新增註解後正文等價。不在這批實作R1/R2 lifecycle、filepicker或環境；後續使用新的rendering具名入口。

精確本模組範圍與派工條件見 [配對計畫](../../../docs/architecture/application-contract-plan/README.md)。APP-CONTRACT-V1-r1 已整合，七模組 scope、原行為、獨立 application 邊界與目錄檢查通過；見 [驗證](../../../docs/architecture/application-contract-plan/verification.md)。
