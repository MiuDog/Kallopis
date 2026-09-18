# 組合（composition）模組架構

## SCL：四層公開結構

架構目標已接受，當前 runtime BUILD 尚未授權。共通計畫為 [`screen → layout → container → element`](../../../docs/architecture/semantic-composition-layer-plan/README.md)；目前只執行固定 254 項的 `SCL-TAX-r1` 層級重審。

Composition 將擁有四層 vocabulary、封閉 catalog metadata、capture 與合法直接邊驗證，但不擁有 feature data。唯一合法公開結構邊為 screen→layout、layout→container、container→element data；跳層、逆向、同層、循環與 generic recursive children 均拒絕。現行 `KlpNode`／`KlpCompositeNode`／slot／children 公開 authoring 面及任意 node list 是已知 migration gap，不能作為新版 family 的目標 API。

確切 public qualification 與 capture 替換須等待 classification、family、disposition 與 module ownership 接受；不得在本 module 先建立萬用 `KlpLayout`／`KlpContainer`／`KlpElement` 或修改 runtime。

Status: PLAN READY — v1 的封閉目錄目標，以及與 capabilities、foundation、runtime 和 application 配對的介面邊界均已接受

阻擋中的架構決策：無。BUILD 仍依下列已接受的配對切片分開執行。

依據：[模組登錄表](../architecture.md)、[模組架構 v1 規格](../../../spec/module-architecture-v1.md)、[KLP-0019](../../../spec/decisions/KLP-0019-declarative-framework-migration.md)

## 目的

`composition` 掌管 Kallopis 唯一的宣告式結構樹。它定義節點識別、複合節點的子節點指派、受限插槽，以及函式庫內部的定義／登錄／驗證機制，在 runtime 準備前拒絕未知或格式錯誤的結構。它位於 kernel、styling 與 capabilities 之上的 L2。

使用端組裝函式庫擁有的功能節點，不自行撰寫新元件定義、登錄轉接器或擴充渲染。

## 非目標

- 公開元件定義或登錄表的建構能力。
- runtime 轉接器／已準備節點的實作、資源安裝或渲染。
- 除向 styling 請求驗證以外的樣式解析權責。
- 平台偵測、應用程式路由、產品資料或持久化。
- 任意子節點清單、Widget 插槽、建構回呼或由使用端控制的驗證演算法。

## 目標階段與能力範圍

目前目標階段：封閉目錄、將定義／登錄／驗證基礎設施內部化，並移除 composition 對 foundation/runtime 的向上匯入。

目前能力範圍：

- 一棵不可變的宣告樹，每個節點具有穩定的 `KlpId` 識別。
- 函式庫擁有的節點定義，具有明確的語意擁有者與受限插槽結構。
- 在 runtime 準備前，恰好完成一次完整結構擷取。
- 確定性地拒絕未知定義、重複登錄、相依循環、插槽擁有者／型別／數量限制不符，以及不穩定的擷取。
- 在渲染前，以不依賴框架的能力值決定自適應選擇。

此範圍不授權使用端登錄、替代結構樹，或在 runtime 內建立外掛市集。

## 所屬路徑與公開介面

目標所屬路徑：

- `nodes/`：純宣告資格條件與函式庫擁有的結構節點。
- `slots/`：具型別的插槽結構、指派與不可變子節點集合。
- `definitions/`：函式庫內部的節點定義中繼資料。
- `registry/`：函式庫內部的封閉目錄與相依驗證。
- `validation/`：函式庫內部的擷取與不可變結構快照。

v1 遷移後經由 `kallopis_declarative.dart` 公開：

- 僅公開函式庫自有公開功能節點的建構子與型別所需之節點／子節點／插槽資格條件。
- 若 `KlpAdaptive` 及其不依賴框架的策略輸入仍是使用端可選的組合基本元件，則予以公開。

v1 遷移後僅限內部使用：

- `KlpDefinition`、`KlpRegistry`、樹擷取實作、已驗證節點／插槽及樹驗證細節。
- 所有節點轉接器與已準備節點。

使用端可建構已公開的 Kallopis 節點，並透過這些節點公布的插槽指派子節點。自行建構 `KlpNode` 實作，若沒有函式庫擁有的目錄項目，也無法使其成為有效、可編譯或可渲染的節點。

同樣地，實作資格介面並不會登錄節點識別，也不會使其加入公開目錄。

## 責任分布與相依方向

| 區域 | 目標責任 | 允許的下層相依 | 目前狀態或剩餘債務 |
| --- | --- | --- | --- |
| `nodes` | 純節點／複合節點資格條件，以及結構性的自適應宣告。 | kernel、能力環境值。 | 自適應轉接器／已準備實作已移交 runtime；策略只使用 capabilities 平台值。 |
| `slots` | 由擁有者限定的型別／數量結構與不可變指派。 | kernel 與 composition 節點。 | 公開建構子可描述未使用的自訂插槽；封閉目錄必須使其不具權威性。 |
| `definitions` | 串接節點型別、語意擁有者、相依與插槽的內部中繼資料。 | kernel、styling 與 composition 契約。 | 已移除公開匯出；本庫轉接器需要的套件內建構保留，舊元件編譯路徑已於 CC-V1-r1 配對退役。 |
| `registry` | 內部封閉目錄、相依驗證與語意結構驗證請求。 | kernel、styling 跨模組驗證介面。 | 已移除公開匯出；仍匯入 styling 的 `internal/` 解析器路徑。 |
| `validation` | 單次擷取與不可變結構證據。 | kernel 與其他 composition 區域。 | 目前使用中的宣告式匯出入口已不再匯出驗證細節。 |

目標中的 composition 只匯入 L0 kernel 與 L1 styling/capabilities 契約。foundation、runtime、features、rendering 和 application 相依於 composition，反向相依一律禁止。

## 不變條件、生命週期與錯誤權責

- 有效的樹只有一個根，且一次 runtime 更新只有一份擷取後的結構權威。
- 每個節點定義與插槽擁有者都是函式庫擁有的穩定 ID；拒絕未知的使用端 ID。
- 子節點資格是插槽型別資格、擁有者、數量限制與子節點函式庫目錄項目的交集。
- 節點 getter 只在擷取時讀取。runtime/rendering 使用不可變的已驗證／已準備值，不重新讀取使用端物件。
- 資源安裝開始前，定義與語意相依圖必須無循環。
- composition 透過 `KlpContractError` 掌管結構契約錯誤；runtime 掌管安裝失敗，rendering 掌管平台失敗。
- composition 不擁有訂閱、配置資源、影格租約、Flutter 物件或引擎工作階段。

## 允許與禁止的相依

允許：

- L0 kernel。
- 透過具名跨模組介面使用 L1 styling 語意驗證。
- 自適應策略選擇所需的 L1 能力環境值。
- 其他 composition 契約。

禁止：

- foundation 的綁定／已準備範本。
- runtime 轉接器、已準備節點、安裝或配置資源的實作。
- 功能實作、rendering、application 或產品程式碼。
- Flutter/Material/WebView 與外部編輯器引擎。
- 使用端提供的定義／登錄表／轉接器清單。

## 採用設計與否決方案

採用：以封閉的內部目錄驗證函式庫擁有的公開節點值。公開建構維持宣告式且可組合，使新型別可渲染的能力則留在 Kallopis 審查與模組權責之內。

否決：公開 `KlpDefinition`/`KlpRegistry`，再搭配安全的範本 API。這仍讓每個使用端建立互不相關的元件識別與語意結構，造成多個元件來源及無界限的 runtime 成長。

否決：讓 runtime 擁有宣告樹。結構、插槽資格與單次擷取權威可獨立於安裝／渲染發揮作用，必須維持純 Dart。

否決：為了方便而將自適應轉接器留在 composition。其已準備節點與配置資源匯入造成直接模組循環；runtime 可擁有轉接器，composition 則只擁有節點契約。

## 目前階段切片

| 切片 | 成果 | 允許路徑 | 公開／跨模組契約 | 驗收證據 | 狀態 |
| --- | --- | --- | --- | --- | --- |
| `COMP-V1-01` | 建立本契約並稽核匯出／匯入循環。 | `lib/src/composition/architecture.md`、登錄表狀態 | 無。 | 依原始碼證據列出公開與內部介面，以及目前的兩個循環。 | complete（已完成） |
| `COMP-V1-02` | 封閉使用端定義／登錄／驗證入口，固定本庫目錄的內部建構責任。 | `lib/src/composition/definitions/**`、`registry/**`、`validation/**`；剩餘文件為 `registry/catalog-contract.md` | runtime/application 只接收函式庫擁有的目錄輸入；套件內定義／registry 建構與公開功能節點保留。 | 建構邊界已交付；公開封閉、內建目錄與配對退役檢查通過。 | complete（CC-V1-r1 已整合） |
| `COMP-V1-03` | 將 `KlpAdaptiveAdapter` 與 `KlpPreparedAdaptive` 遷至 runtime 所屬路徑。 | `lib/src/composition/nodes/internal/klp_adaptive_adapter.dart`、`klp_prepared_adaptive.dart` | composition 僅公布 `KlpAdaptive` 結構；runtime 在內部公布通用轉接器介面。 | composition 匯入不含 runtime/foundation 路徑；自適應行為維持確定性等價。 | complete（AD-V1-r1 已整合） |
| `COMP-V1-04` | 將自適應策略對 foundation 平台的匯入改為 L1 能力環境值。 | `lib/src/composition/nodes/klp_platform_strategy.dart`、直接相關的 composition 引用 | capabilities 擁有裝置／顯示／方向值；foundation 可為舊名稱提供相容轉匯出。 | composition 匯入不含 foundation 路徑；公開自適應輸入保留原有值與語意。 | complete（AD-V1-r1 已整合） |
| `COMP-V1-05` | 將對 styling `resolution/internal` 的跨模組匯入改為具名、非使用端的 styling 驗證介面。 | `lib/src/composition/registry/**` | styling 擁有語意圖驗證；composition 呼叫驗證而不擁有解析權責。 | 沒有模組為了語意驗證而匯入另一模組的 `internal/` 路徑。 | complete（SEM-V1-r1 已整合） |
| `COMP-V1-06` | 保護依層級組織的宣告式匯出入口及其有限的撰寫邊界。 | 公開介面文件與獨立的使用端編譯契約 | 每個匯出都有一個 L0–L7 擁有者；使用端無法存取定義、驗證、範本、語意撰寫與 runtime 型別。 | 公開介面清冊與負向編譯案例均與匯出入口一致。 | complete（已完成） |

`COMP-V1-02` 的冷啟動估算：8,000–16,000 模型 token，60–150 分鐘。沒有可比較的已定案任務登錄項目。里程碑：鎖定公開用法、目錄內部化、移除 application/runtime 輸入，以及負向編譯證據。超過 24,000 token 或 210 分鐘時，必須進行異常檢查。

### 封閉目錄配對契約（CC-V1-r1）

以下是已完成批次的原寫入範圍；搬移後的現行 runtime 路徑以 RC-V1-r1 為準。

依共通規格的 `CC-V1-r1` 精確化 `COMP-V1-02`：保留套件內 `KlpDefinition`／`KlpRegistry` 建構子與結構驗證；退役的是使用端可達的元件撰寫流程，不是內建轉接器所需的定義能力。不要求將必要建構子私有化或搬移。composition 不列舉 features、不接收 runtime 轉接器型別，也不建立第二份目錄。

已交付 `registry/catalog-contract.md`，記錄唯一建構責任、使用端與套件內測試邊界，以及封閉目錄整合驗收；本模組無需修改 Dart。application 清冊、runtime/foundation 退役及獨立邊界檢查均已完成，本切片標為 complete。

任務包：[COMP-V1-02](../../../docs/architecture/closed-catalog-plan/COMP-V1-02.json)。配對順序與共用證據見 [配對計畫](../../../docs/architecture/closed-catalog-plan/README.md)。本輪 BUILD 已完成；原 JSON 保留為規劃紀錄，實際執行基線與證據見結案報告。

### Runtime 契約路徑配對（RC-V1-r1）

COMP-RC-V1-01 是 RUN-V1-02 的必要呼叫端支援包；僅修改 nodes/internal/klp_adaptive_adapter.dart 與 klp_prepared_adaptive.dart 的 runtime 匯入。不得搬移自適應實作或將 COMP-V1-03 標 complete。

共通規格 RC-V1-r1 已接受。精確路徑、分工與驗收見 [配對計畫](../../../docs/architecture/runtime-contract-plan/README.md)；全部套件內 runtime API 不由 consumer barrel 匯出，舊來源不保留轉匯出 shim。

### 自適應責任配對（AD-V1-r1）

已接受共通規格 AD-V1-r1；本模組精確寫入範圍見 [配對計畫](../../../docs/architecture/adaptive-module-plan/README.md) 的 path-map。composition 保留宣告／策略，runtime 掌管 adaptive 實作，capabilities 擁有三個平台 enum，foundation 舊路徑以相容轉匯出維持同一型別；application 僅同步目錄來源。無新 API 或環境權威。

### 語意驗證介面配對（SEM-V1-r1）

已接受共通規格SEM-V1-r1與 [精確範圍](../../../docs/architecture/semantic-module-plan/README.md)。composition只呼叫具名驗證操作，runtime與features使用明確解析契約路徑；styling維持唯一驗證／解析規則與錯誤。沒有consumer匯出或default變更。


SEM-V1-r1 已整合：39 項獨立邊界／語意圖與保留的綁定／rail／shadow 測試、18 項目錄／runtime／frame／import-root 測試通過；局部分析無問題。解析器搬移保持演算法等價，公開匯出不變。見 [驗證紀錄](../../../docs/architecture/semantic-module-plan/verification.md)。

## 驗收證據與測試狀態

AD-V1-r1 最新證據：5 個模組 scope PASS，composition 沒有 runtime/foundation 指令；既有自適應／catalog／runtime／scope／root-import／runtime 邊界共 28 項與新增邊界／enum 相容身分檢查均通過。capabilities 擁有三個純 enum，foundation 轉匯出仍是同型別；application 僅更新真實 adapter 來源，不將 APP-V1-05/06 全部結案。詳見 [本批驗證](../../../docs/architecture/adaptive-module-plan/verification.md)。

2026-09-14，RC-V1-r1 配對整合完成：

- COMP-RC-V1-01 配對支援已完成，兩個既有自適應實作只更新 runtime import URI，函式 body 等價。
- AD-V1-r1 已完成 COMP-V1-03/04 的自適應實作／平台值配對；COMP-V1-05 已完成 styling 具名驗證介面。
- KlpDefinition／KlpRegistry 的套件內建構與單次擷取不變，consumer 撰寫邊界仍封閉。

- Green：19 份受影響測試共 139 項通過；application 與 import-root 共 14 項通過；本模組 scope gate PASS。完整群組與限制見 [本輪驗證](../../../docs/architecture/runtime-contract-plan/verification.md)。
- Red → Green：新跨模組邊界檢查先在基線因實際 internal 匯入而失敗，配對遷移後通過；不是缺檔／編譯錯誤。
- 測試保護：獨立作者遷移 20 個既有檔案並新增一個 guard，原案例／斷言與 fixture 行為保留。
- 上輪 [CC-V1-r1 證據](../../../docs/architecture/closed-catalog-plan/verification.md) 保留為歷史紀錄。未做全庫／感官或引擎保存驗收。

## 受保護路徑

- `lib/src/composition/architecture.md`
- `test/klp_composition_contract_test.dart`
- `test/klp_slot_contract_test.dart`
- `test/klp_tree_runtime_test.dart`
- `test/klp_scoped_capture_test.dart`
- `test/klp_adaptive_declarative_test.dart`
- 涵蓋禁止 Widget／自訂定義路徑的使用端編譯測試資料。
- `test/frontend_architecture_boundary_test.dart`

### Application具名契約收尾（APP-CONTRACT-V1-r1）

APP-CONTRACT-V1-r1：APP-V1-06 剩餘完整 application foreign-internal 邊以25個既有來源實體歸具名路徑收尾。Kernel三個lifecycle來源、capabilities導航machine/兩exception及五part、composition scope boundary、十一features adapters、rendering renderer/viewport入口依精確map搬移。Renderer沒有parts；其餘平台實作保留同模組internal，具名入口的正常implementation imports不是consumer公開或跨模組穿透。Navigation五part隨原owner同library移動，狀態機／transaction／commit／lease／錯誤／回收body與callback身分不變。不得以轉匯出barrel遮住其他模組internal，不留舊shim；所有root公開library export指令與順序保持，25來源仍不公開。所有directcallers與36個catalog metadata字串同步原ID/factory/variant/順序，只替換路徑。features67exports／24component、application28ID保持。四個原未附文件的adapter只新增精確用途dartdoc以維持token baseline45，其餘非directive正文僅准行首tab正規化；去除這四新增註解後正文等價。不在這批實作R1/R2 lifecycle、filepicker或環境；後續使用新的rendering具名入口。

精確本模組範圍與派工條件見 [配對計畫](../../../docs/architecture/application-contract-plan/README.md)。APP-CONTRACT-V1-r1 已整合，七模組 scope、原行為、獨立 application 邊界與目錄檢查通過；見 [驗證](../../../docs/architecture/application-contract-plan/verification.md)。
