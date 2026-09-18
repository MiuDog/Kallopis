# 基礎呈現（foundation）模組架構

Status: PLAN READY — v1 的目標邊界，以及與 composition、runtime、features、rendering 和 application 配對的介面邊界均已接受

阻擋中的架構決策：無。BUILD 仍依下列已接受的配對切片分開執行。

依據：[模組登錄表](../architecture.md)、[模組架構 v1 規格](../../../spec/module-architecture-v1.md)、[KLP-0019](../../../spec/decisions/KLP-0019-declarative-framework-migration.md)

## 目的

`foundation` 掌管位於 kernel、styling、capabilities 與 composition 之上、不依賴渲染的呈現詞彙：封閉範本、不可變的已準備值、共用平台識別，以及確實跨功能共用的互動／版面配置契約。它位於 L3。目前使用中的宣告式路徑為函式庫功能作者提供有限的建構元件；它不是供使用端撰寫元件的 SDK。

舊版 Flutter 基礎元件在 KLP-0019 P9 之前維持為隔離的相容區域，不定義目前使用中的宣告式架構。

## 非目標

- 公開任意元件登錄能力或使用端定義的元件型別。
- 在通用的綁定呈現資料內納入功能專屬的編輯／工作區／按鈕契約。
- runtime 編譯、轉接器探索、應用程式接線或具體渲染。
- 產品工作流程、儲存庫／持久化存取，或第二份樣式／環境權威。
- 將每個看似共用的 Flutter widget 都視為宣告式 foundation 基本元件。

## 目標階段與能力範圍

目前目標階段：封閉外部元件定義介面、將通用呈現契約與功能／舊版實作分離，並移除 foundation 的向上相依。

目前能力範圍：

- 由 Kallopis 自有定義選用的有限封閉範本集合。
- 攜帶完整配置識別與已解析語意資料的不可變已準備呈現值。
- 不依賴框架的平台／自適應識別，以及共用互動／版面配置值契約。
- 透過經審查的功能定義，由函式庫控制成長，不在 runtime 由使用端登錄。
- 舊版 Flutter 元件只透過 Stable 相容入口保留至 P9。

此範圍不授權任意範本子類別、Widget 插槽、渲染器回呼，或在通用已準備基底中加入功能專屬聯集。

## 所屬路徑與公開介面

目標中的有效路徑：

- `templates/`：封閉且不依賴渲染的範本結構，僅供 Kallopis 自有元件定義使用。
- `binding/`：內部通用已準備呈現協定與值。
- `platform/`：宣告式平台／自適應識別，以及另行標記的舊版環境相容性。
- `interaction/` 與 `layout/` 中由多個功能家族共用、且不依賴渲染的部分。
- 圖示識別或色彩運算等低階值資產，但僅限不執行渲染或解析舊版主題狀態者。

相容路徑：

- 目前位於 `content/`、`interaction/`、`layout/`、`surface/`、`metrics/` 及 foundation 根目錄檔案中的 Flutter widget 與舊版主題使用者。
- `kallopis_foundation.dart` 中的相容匯出。

v1 遷移後經由 `kallopis_declarative.dart` 公開：

- 選擇函式庫自有策略所需的平台／自適應值契約。
- `KlpAxis`，因為目前函式庫自有的工作區版面配置節點接受它作為有限值。
- 不公開 `KlpComponentDefinition` 建構子或元件登錄清單。

僅限內部使用：

- 函式庫自有定義所選用的封閉範本與文字語意詞彙。
- 已準備／已綁定的呈現值與既有綁定契約。

舊元件 compiler 與專用範本插槽 helper 已退役；節點定義由 composition 擁有，完整功能／組裝清冊由 features/application 擁有。

## 責任分布與相依方向

| 區域 | 目標責任 | 允許的下層相依 | 目前狀態或剩餘債務 |
| --- | --- | --- | --- |
| `templates` | 以合格節點／插槽與語意鍵建立封閉呈現結構。 | kernel、styling、capabilities、composition。 | composition 移除已準備範本匯入後即無剩餘債務。 |
| `definitions`（已退役） | 舊元件定義與專用 helper 已刪除；現行節點定義由 composition 擁有。 | 無現行程式。 | FND-V1-02 已完成；不建立替代 compiler 或別名。 |
| `binding/contracts`、`binding/internal` | 前者為通用不可變呈現協定，後者保留 binder 實作。 | kernel、styling、capabilities 與 composition 契約。 | 通用 abstract 協定與 11 個通用 part；功能／引擎紀錄已歸 features。 |
| `platform` | 宣告式平台／自適應值；隔離舊版環境相容性。 | kernel；Flutter 僅可用於標記為相容的檔案。 | 純裝置／方向／顯示值由 capabilities/environment 擁有，原三個路徑只相容轉匯出；舊版平台宿主仍另待整理。 |
| `interaction`、`layout` | 跨功能的值／行為契約；舊版 widget 僅保留相容用途。 | kernel、styling；Flutter 僅可用於標記為相容的位置。 | 具體按鈕樣式／工具列已遷出，保留中立資料與 Stable 根匯出相容。 |
| `content`、`surface`、根目錄視覺檔案 | P9 舊版相容元件。 | 舊版 styling 與 Flutter。 | 雖然實際為 Widget 實作，其名稱目前仍看似屬於有效的 L3 權責。 |

目標相依只指向 L0–L2。runtime、features、rendering 和 application 可使用 foundation 契約；foundation 不得匯入這些模組。

## 不變條件、生命週期與錯誤權責

- 每個目前有效的範本均由 Kallopis 封閉，描述呈現時不包含 `Widget`、`BuildContext`、painter、局部樣式或渲染器回呼。
- 範本插槽擷取保留 composition 擁有的插槽資格；範本不得放寬可接受的子節點型別。
- 每個已準備配置都攜帶 `KlpPlacementId`；功能／渲染模組不得另創平行的鍵。
- 已準備值是不可變快照，不擁有訂閱、可變狀態、引擎工作階段或持久化生命週期。
- 功能專屬請求、回覆、外部引擎工作階段與儲存狀態仍由 capabilities/features 擁有，並透過功能自有的已準備紀錄傳入 rendering。
- foundation 錯誤屬於契約／驗證失敗，透過 kernel 診斷表達。渲染失敗與產品復原不移入 foundation。
- 舊版 Widget／主題行為與宣告式範本／綁定路徑隔離，且有明確的 P9 移除閘門。

## 允許與禁止的相依

目前有效路徑允許：

- L0 kernel。
- L1 styling 與 capabilities 契約。
- L2 composition 節點、插槽與定義契約。
- Dart SDK。

僅在標記為相容的檔案中允許：

- Flutter 框架與舊版 styling API。

所有目標 foundation 程式碼均禁止：

- `application`、`features`、`rendering` 或具體 runtime 實作。
- 在通用綁定檔案中匯入 Krepis/Canva/BlockNote 引擎套件。
- 使用端定義的元件識別或 runtime 登錄。
- 產品標籤、儲存庫、持久化或領域模型。
- 在配對遷移切片完成後，由下層模組匯入 foundation 的 `internal/` 路徑。

## 採用設計與否決方案

採用：將 foundation 維持為有限的 L3 呈現契約模組、使元件目錄中繼資料內部化，並以不匯出的通用已準備協定取代涵蓋所有功能的封閉綁定聯集，由功能自有的已準備紀錄實作該協定。如此可保留可重用的渲染器邊界，而不強迫 foundation 認識所有功能。

否決：持續向 `KlpBoundTemplate` 加入 `part` 檔案與引擎匯入。這會讓 foundation 隨每個新功能變更、產生循環，並使低階聯集成為第二份元件登錄表。

否決：因為範本已封閉，就將 `KlpComponentDefinition` 公開為安全擴充點。即使範本封閉，使用端自選的 ID、語意與應用程式登錄仍會形成無界限的平行元件來源，違反已接受的封閉目錄。

否決：將全部綁定值移至 rendering。runtime 與功能轉接器在 Flutter 具體呈現前，就需要不依賴框架的已準備資料；把協定移入 rendering 會反轉相依方向。

## 目前階段切片

| 切片 | 成果 | 允許路徑 | 公開／跨模組契約 | 驗收證據 | 狀態 |
| --- | --- | --- | --- | --- | --- |
| `FND-V1-01` | 建立本契約並稽核實際匯入／匯出。 | `lib/src/foundation/architecture.md`、登錄表狀態 | 無。 | 匯入圖列出全部向上相依；公開匯出入口辨識有效與舊版介面。 | complete（已完成） |
| `FND-V1-02` | 封閉使用端元件撰寫。移除公開的 `KlpComponentDefinition` 建構子／匯出，並將其編譯器中繼資料內部化或退役。 | `lib/src/foundation/definitions/**`、`lib/src/foundation/binding/internal/klp_component_compiler.dart` | composition 擁有節點／插槽驗證；runtime 只使用函式庫自有轉接器／目錄輸入；application 不再接受使用端元件。 | 舊 definition/compiler/helper 已退役，公開封閉與保留行為檢查通過。 | complete（CC-V1-r1 已整合） |
| `FND-V1-03` | 將通用已準備呈現值與編輯／工作區／引擎專屬已準備紀錄分離。 | `lib/src/foundation/binding/**` | 通用協定仍留在 foundation 內部；功能自有紀錄實作該協定，foundation 不匯入 features 或引擎套件。 | foundation 匯入稽核不含 `features`、`application`、`rendering`、`runtime`、Krepis、Canva 或 BlockNote 匯入。 | complete（PRES-V1-r1 已整合） |
| `FND-V1-04` | 將按鈕樣式與選取工具列實作遷至所屬功能家族。 | `lib/src/foundation/interaction/internal/klp_button_style.dart`、`lib/src/foundation/interaction/filter/klp_selection_toolbar.dart` 及直接耦合的 foundation 部分 | features 擁有具體按鈕／工具列行為；foundation 只保留中立的控制／版面配置值。 | foundation 匯入稽核不含 `features` 目標；僅在必要位置透過匯出入口轉送，保留舊版公開相容性。 | complete（PRES-V1-r1 已整合） |
| `FND-V1-05` | 將舊版主題所需、具權威性的舊版度量值移至 foundation 下層，以打破 styling 相容性循環，並保留公開相容轉匯出。 | `lib/src/foundation/metrics/**`、`lib/src/foundation/klp_metrics.dart` | styling 擁有建立舊版主題所需的值；foundation 使用它們，且可在 P9 前重新匯出相容名稱。 | 沒有 styling 原始碼匯入 foundation；確定性的度量值保持不變。 | complete（METRICS-V1-r1 已整合） |
| `FND-V1-06` | 將不依賴框架的裝置類別、顯示模式與方向值遷至能力環境契約。 | `lib/src/foundation/platform/klp_device_class.dart`、`klp_display_mode.dart`、`klp_orientation.dart` 及相容轉匯出檔案 | capabilities 擁有 L1 值；composition 不再匯入 foundation；遷移期間透過相容轉匯出保留既有名稱。 | 沒有 composition 原始碼匯入 foundation 平台值，且未引入第二份環境來源。 | complete（AD-V1-r1 已整合） |
| `FND-V1-07` | 從 application 接收呈現用在地化值，提供者仍由 application 宿主安裝。 | 新的 foundation 在地化契約與相容轉匯出原始碼 | features 使用 L3 在地化；application 安裝唯一來源。 | 沒有功能匯入 application，且不存在第二份 l10n 來源。 | complete（L10N-V1-r2 已整合） |
| `FND-V1-08` | 從使用端匯出入口移除範本／文字語意撰寫能力，只保留已公布節點所需的值。 | `lib/kallopis_declarative.dart`、公開介面文件與獨立編譯契約 | 範本維持為封閉的函式庫實作契約；使用端僅以具體節點與合格插槽組合。 | 合法公布節點可組合；外部 KlpTemplate／KlpTextSemantics 撰寫不可編譯，受封閉目錄獨立編譯檢查保護。 | complete（已完成） |

任何切片都不得將這些遷移與無關的視覺重新設計合併。

已完成切片 `FND-V1-02` 的規劃時冷啟動估算：8,000–16,000 模型 token，60–150 分鐘。沒有可比較的已定案任務登錄項目。里程碑：公開用法清冊、配對 API 移除、內建目錄遷移，以及局部編譯證據。超過 24,000 token 或 210 分鐘時，必須先進行異常檢查，才能增加更多檔案。

### 封閉目錄配對契約（CC-V1-r1）

`FND-V1-02` 已完成退役 `definitions/klp_component_definition.dart`、`definitions/internal/klp_template_slots.dart`、`binding/internal/klp_component_compiler.dart`。現行內建節點已由轉接器直接提供 composition 定義，無須建立替代中繼資料 API。既有 templates、bound/prepared 值、renderer 使用者及 Stable 相容面不在本切片清除範圍。

刪除須與 `RUN-V1-03`、application 呼叫端及獨立測試遷移同批整合。測試作者將舊編譯器案例對應到保留行為或已退役 API，實作者不得修改測試。跨模組介面以共通規格 `CC-V1-r1` 為準。

任務包：[FND-V1-02](../../../docs/architecture/closed-catalog-plan/FND-V1-02.json)。切片已配對整合完成；原 JSON 保留為規劃紀錄，實際執行紀錄見結案報告。

### 自適應責任配對（AD-V1-r1）

已接受共通規格 AD-V1-r1；本模組精確寫入範圍見 [配對計畫](../../../docs/architecture/adaptive-module-plan/README.md) 的 path-map。composition 保留宣告／策略，runtime 掌管 adaptive 實作，capabilities 擁有三個平台 enum，foundation 舊路徑以相容轉匯出維持同一型別；application 僅同步目錄來源。無新 API 或環境權威。

### 通用與功能呈現配對（PRES-V1-r1）

已接受 [配對規格](../../../docs/architecture/presentation-module-plan/README.md) 與精確路徑。PRES-V1-r1：KlpBoundTemplate 原名／constructor 保留，路徑由 LOWER-V1-r1 具名契約接替，改為不對 consumer 匯出的 abstract class 協定。11 個通用 part 留 foundation；15 editing part 與 editing style、15 workspace part 各移至 features 自有 presentation library，不跨模組 part，不由 foundation reexport。兩個 feature library 都只作唯讀呈現資料，保留上游 controller／engine／callback 身分與生命週期，不新增權威。renderer 保留原 26 concrete 類型的分支與非視覺標記，未知套件內實作明確拋 KlpContractError('unsupported_prepared_template', ...)；不提供註冊或 fallback。另將 button style 與 toolbar 三檔實體移至 features/actions；KlpSelectionAction 留 foundation，filter bar 移除 toolbar export，僅 root kallopis_foundation.dart 直接 export 新 toolbar 以保留 Stable。所有舊移動路徑刪除而不設 shim；公開符號／constructor／範本／catalog 28 ID 順序與效果不變。FND-V1-03 全 foundation 無 features/runtime/rendering/application 或 Krepis/Canva/BlockNote import/export/part 的原要求不得縮小。

### 唯一呈現在地化配對（L10N-V1-r1）

已接受 [配對規格](../../../docs/architecture/localization-module-plan/README.md)。L10N-V1-r1：三個既有 application/localization 檔案作為同一 library 實體搬至 foundation/localization；保留型別、constructor、全部預設字串、savedLabel 私有函式、delegate load/shouldReload/isSupported、fallback 與 equality。這仍是既有 Flutter 呈現契約，不另建純 Dart 模型或第二來源。12 個 features 指令（含1 export）及1個 rendering import 精確向下遷移，全部 features/rendering 不得再依賴 application（含相對／條件／export／公開 barrel 旁路）；無其他host前置。application legacy只更新URI並保留consumer delegates在前的順序；宣告式 KlpApplication 的 WidgetsApp 必須安裝 const KlpLocalizationsDelegate()，不新增locale/override/public API。Stable kallopis_foundation.dart 只改export來源，其他公開符號/可達性/畫面字串/預設環境不變；舊src路徑刪除無shim。

## 驗收證據與測試狀態

L10N-V1-r2 已整合：179 項保護測試通過，包含全 features/rendering 無 application 相依、唯一字串來源、defaults／delegate／fallback／Stable 相容與宿主實際安裝。七段既有 BlockNote 錯誤原文已補入同一 l10n；原70字串保留。既有 host 六案例與保留已掛載編輯器測試亦通過；App 舊基線過期參數由獨立作者移除，discipline 只修註解誤判並保留原閘門。見 [本批驗證](../../../docs/architecture/localization-module-plan/verification.md)。


PRES-V1-r1 已整合：105 項保護測試及 16 項實際 renderer／filter／catalog／import-root 測試通過，35 個搬移實作與直接呼叫正文等價。全 foundation 無上層／引擎指令；26 個渲染型別保留，未知型別明確拒絕。Stable toolbar 名稱與身分相容。詳見 [本批驗證](../../../docs/architecture/presentation-module-plan/verification.md)。


AD-V1-r1 最新證據：5 個模組 scope PASS，composition 沒有 runtime/foundation 指令；既有自適應／catalog／runtime／scope／root-import／runtime 邊界共 28 項與新增邊界／enum 相容身分檢查均通過。capabilities 擁有三個純 enum，foundation 轉匯出仍是同型別；application 僅更新真實 adapter 來源，不將 APP-V1-05/06 全部結案。詳見 [本批驗證](../../../docs/architecture/adaptive-module-plan/verification.md)。

2026-09-14，CC-V1-r1 配對整合完成：

- 已刪除 `KlpComponentDefinition`、`KlpComponentCompiler` 與 definition 專用 `klpTemplateSlots`；產品程式沒有舊型別或 helper 引用。
- 現行轉接器直接提供 composition 定義；templates、bound/prepared 值、renderer 與 Stable 相容面保持既有責任。
- 功能／引擎專屬紀錄已由 PRES-V1-r1 分離；在地化已由 L10N-V1-r1 完成；FND-V1-05 已完成舊度量唯一來源下移。

- Green：獨立 Test Author 的清冊／公開封閉／runtime／直接呼叫端共 188 項檢查通過；本模組 scope gate 通過。細項、原有失敗與限制見 [結案驗證](../../../docs/architecture/closed-catalog-plan/verification.md)。
- Yellow：已核對精確寫入範圍、來源 hash 與測試保護 hash；後續切片維持各自原有配對條件。
- Red：本切片無未解產品失敗；測試 setup 修復與既有匯入閘門失敗分別記錄於結案驗證。
- 視覺驗收：本輪不適用，未做感官品質判定。

## 受保護路徑

- `lib/src/foundation/architecture.md`
- `test/klp_component_binding_test.dart`
- `test/klp_component_children_binding_test.dart`
- `test/klp_template_compile_contract_test.dart`
- `test/klp_slot_compile_contract_test.dart`
- `test/frontend_architecture_boundary_test.dart`
- 既有使用端編譯測試資料，直到獨立測試作者切片替換其中對外部元件的預期。

### L10N-V1-r2 有證據修復

L10N-V1-r2 修復已重現的舊 discipline 失敗：BlockNote 兩個 renderer 檔的七段原始使用者文案納入既有 KlpLocalizations，七個可選 String constructor 欄位及對應 final 欄位預設完全沿用原文，加入 equality/hashCode 使覆寫可觸發delegate reload。這是相容的既有字串契約補齊，接替 r1「不加 public API」在這七個可選欄位的限制；其餘70既有字串、constructor用法、預設畫面、重試與中斷／WebView生命週期不變，不建第二來源。renderer的錯誤Widget只由 KlpLocalizations.of(context) 取字串，不改branch/controller/callback。獨立作者修 discipline scanner 的註解誤判：兩個 metric card 的單引號箭頭範例是註解而非 literal，必須加入synthetic正負控制，只忽略comments、不忽略真字串，保留Chinese零及icon上限15和下限13，不增加豁免。

### 具名下層契約配對（LOWER-V1-r1）

LOWER-V1-r1：CAP-V1-02 與 REND-V1-04 配對，71 個既有檔案實體移至具名路徑；全部名稱、constructor、預設值、演算法、狀態與 callback 身分不變。Provider 42 個 editing export 與 9 個 part 移至 editing/contracts，根入口原 44 個 export 的符號可達性不變。draw_command_validation 留 internal，不新增公開；block_drop_preview 仍非公開，drop_target 與 editing_submission 為 editing/ 下具名套件內入口，保留整體演算法及狀態。Foundation 15 個通用 binding 檔案含 11 part 移至 binding/contracts，維持同 library、abstract KlpBoundTemplate 與非 consumer 公開協定；此條明確接替 PRES-V1-r1 的「路徑保留」，其名稱、constructor、模組責任與原行為仍保留。Styling 的 paper_shadow_recipe 與 control_density 移至各自具名入口，值與唯一來源不變。所有直接呼叫端與測試 URI 配對更新，不留 shim、不新增 export。完整 rendering 的 import/export/part/part-of/conditional 指令不得跨到任何其他模組 internal；不能只檢查 capabilities/foundation。維持 26 renderer 分支、28 catalog ID、未知類型拒絕、同模組 reciprocal part、Stable 與 provider 可達性。編輯 pending/resync、save job/confirmed revision、手寫生命週期與上游正文／undo 權威不變。CAP-V1-03 舊正文分類、FND-V1-05 metrics、host 與剩餘 APP-V1-06 不藉此宣告完成。

精確本模組範圍與派工條件見 [配對計畫](../../../docs/architecture/lower-contract-plan/README.md)。LOWER-V1-r1 已整合：71 個原始檔實體搬移與 57 個直接 caller（共 128 個來源）正文／指令身分等價；7 個 module scope、局部分析與獨立整合測試通過。Provider 公開身分不變，完整 renderer 無不允許的跨模組 internal 指令。見 [驗證](../../../docs/architecture/lower-contract-plan/verification.md)。

### 舊度量來源配對（METRICS-V1-r1）

METRICS-V1-r1：FND-V1-05 配對 styling，14 個原 library／part 檔整體歸 lib/src/styling/legacy_metrics/，13 個 abstract final metrics 類型與全部 static 常數／list／Duration／字型 package 名稱、順序與型別完全保留。原 foundation/klp_metrics.dart 僅留單一相容 export 指向新唯一 library，13 個舊 part 刪除。此 export 是原切片明定 P9 前相容入口，非第二實作；根 Stable kallopis_foundation.dart 保持原 export，所有公開 barrel 可達性／型別身分不變。兩個 styling legacy_theme source 改用新下層權威；完整 styling 不得再 import/export/part 到 foundation，包含條件／相對／named part／barrel 旁路，不禁止正常同模組 private helper。part 與 part-of 仍在同 library/module。沒有第二 theme／environment／l10n 或新增 consumer API；只移動權責不重設預設值。

精確範圍與 Task Packet 條件見 [配對計畫](../../../docs/architecture/metrics-module-plan/README.md)。METRICS-V1-r1 已整合：14 檔度量 library／part 已歸 styling，foundation 單一相容 export 保留 Stable 身分；13 類型與150常數、完整 styling 向下邊界通過 8 項獨立契約，兩 module scope PASS。全九模組指令圖無循環。文件修復僅補50個dartdoc，原 token baseline45不變且9項通過。見 [驗證](../../../docs/architecture/metrics-module-plan/verification.md)。

### Host ports 配對（HOST-PORTS-V1-r1）

HOST-PORTS-V1-r1 接受 APP-V1-05／FEAT-V1-06 的 E 環境與 P 檔案選取配對。Capabilities 持有純環境解析及既有 KlpAppPlatform／KlpAdaptiveMode 唯一宣告，Stable foundation 原 facade、型別與 current(Size?) 行為保留；application 唯一既有 host 採樣並安裝，不增加 observer、store 或預設。P 接替已接受的 concrete picker 宣告式面：公開 L1 KlpPickFileAction，port/result 套件內部；application 唯一 plugin adapter，既有 action handler 用原 frame/lease/epoch/entry 在 await 前後檢驗。有效 selected 才回呼一次，cancel/stale/failed 為 false，平台或 callback error 原物件／stack 由 host 一次回報。舊零 host picker 搬 application/legacy 並由專用 legacy root 保留 const/欄位/pick Future 成功取消與原 error 傳播；不作現行宿主 fallback。公開 roots 6→7，僅 declarative 一增一刪及新 legacy，feature exports 67→66，24 components/28 IDs/順序保持。原 R1/APP06 root/hash/closure/catalog 基準依 path-map 精確增減由獨立作者更新，不 blanket resnapshot 或放寬原守衛。E 單獨不完成 APP05；E/P 與完整證據通過才 APP05/FEAT06 complete。

具體值與派工範圍見 [配對計畫](../../../docs/architecture/host-ports-plan/README.md)。實作驗證待完成。

HOST-PORTS-V1-r1 的 E／P 配對已整合，原環境相容與租約／錯誤／公開邊界檢查通過；見[最終驗證](../../../docs/architecture/host-ports-plan/verification.md)。完整 CI 的既存失敗另列，不代表發布全綠。
