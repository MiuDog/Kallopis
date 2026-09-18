# Kernel 模組架構

Status: PLAN READY — v1 契約稽核完成；不需要產品 BUILD 切片

依據：[模組登錄表](../architecture.md)、[模組架構 v1 規格](../../../spec/module-architecture-v1.md)

## 目的

`kernel` 掌管所有 Kallopis 上層皆可相依、與框架無關的最小契約：穩定身分、機器可讀的契約錯誤，以及內部生命週期清理原語。它是 L0 相依基底。

## 非目標

- 元件組合、插槽、註冊或結構驗證。
- 樣式、平台適配、渲染或 Flutter 型別。
- 產品資料、持久化、導覽或編輯權威。
- 僅為省去匯入真正所屬模組而設的公開便利 API。

## 目標階段與能力範圍

目前目標階段：為架構 v1 記錄並稽核既有 L0 邊界。

目前能力範圍：

- 宣告與放置的穩定階層式身分。
- 公開驗證邊界的穩定契約錯誤代碼與訊息。
- 執行階段／應用實作使用的內部生命週期租約，以及盡力完成所有清理的錯誤彙整。

後續需求可能要求為 `KlpId` 明定快取權責邊界，但 v1 不建立推測性的身分服務或第二套識別碼模型。

## 所屬路徑與公開介面

所屬路徑：

- `lib/src/kernel/diagnostics/`
- `lib/src/kernel/identity/`
- `lib/src/kernel/lifecycle/`

透過 `kallopis_declarative.dart` 公開：

- `KlpContractError`：公開契約拒絕的穩定錯誤代碼與診斷訊息。
- `KlpId`：階層式語意身分與宣告作用域查找。
- `KlpPlacementId`：跨擷取、執行階段與渲染邊界使用、具作用域且不可變的放置身分。

僅供內部使用：

- `KlpFrameLease`：保留影格的可撤銷操作資格。
- `KlpLifecycleException`：彙整生命週期清理失敗。
- `klpRunLifecycleActions`：個別動作失敗後仍繼續清理。
- 識別碼詞法驗證輔助工具。

上層模組可以使用這些契約，但不得透過註冊、回呼或繼承子類別增加 kernel 行為。

## 責任分布與相依方向

| 區域 | 責任 | 相依對象 |
| --- | --- | --- |
| `identity` | 建構、正規化並比較語意身分與放置身分。 | Dart 核心，以及供宣告作用域使用的 `dart:async`。 |
| `diagnostics` | 攜帶穩定契約錯誤代碼與訊息。 | 僅 Dart 核心。 |
| `lifecycle/internal` | 撤銷影格操作並彙整清理失敗，不放棄後續清理動作。 | Dart 核心與 kernel 診斷慣例。 |

所有原始碼相依皆限於 kernel 內部或 Dart SDK。其他所有已登錄模組皆可指向 kernel；kernel 不指向其中任何模組。

## 不變條件、生命週期與錯誤權責

- 公開身分值非空、經正規化，且對呼叫端而言不可變。
- 相同 `KlpId` 路徑具值相等性，以及穩定的點分隔表示法。
- `KlpPlacementId` 是跨組合、執行階段與渲染的唯一放置身分；上層模組不得建立平行的鍵值格式。
- 已撤銷的影格租約會拒絕後續操作。清理會執行每個已登錄動作，並在完成後回報彙整失敗。
- `KlpContractError` 負責公開契約違規。生命週期錯誤彙整維持內部用途，因其屬實作失敗，而非使用端擴充點。
- Kernel 絕不只為將錯誤轉成 UI 狀態而攔截錯誤；呈現與復原由呼叫端所屬權責決定。

## 允許與禁止的相依

允許：

- 不引入 UI 或平台權威的 Dart SDK 程式庫。
- `lib/src/kernel/` 內的匯入。

禁止：

- Flutter、Material、WebView 或其他渲染套件。
- 匯入 `application`、`capabilities`、`composition`、`features`、`foundation`、`rendering`、`runtime` 或 `styling`。
- 產品儲存庫、持久化適配器或產品領域型別。
- 可變的元件／定義登錄表，或使用端提供的身分實作。

## 採用設計與否決方案

採用：小型 final 值型別加上內部生命週期函式。這讓純 Dart 驗證器及面向 Flutter 的程式碼都能使用身分與失敗語意，而不反轉相依方向。

否決：將身分放在 `composition`，並將生命週期租約放在 `runtime`。這會迫使 application、capabilities 與 rendering 為跨切面契約匯入上層實作；由於 composition／runtime 也相依於身分，將形成循環。

不引入抽象服務層，因為 v1 只有一種程序內身分表示法，沒有已接受的替代後端，也沒有外部 I/O 邊界。

## 目前階段切片

| 切片 | 成果 | 允許路徑 | 驗收證據 | 狀態 |
| --- | --- | --- | --- | --- |
| `KERN-V1-01` | 建立受保護的模組契約，並稽核匯入／公開權責。 | `lib/src/kernel/architecture.md`、模組登錄表狀態 | Kernel 清冊顯示僅有 Dart SDK／內部匯入；宣告式匯出入口掌管三個公開契約；不存在上層匯入。 | complete（已完成） |

目前稽核不足以支持新增產品 BUILD 切片。未來 kernel 變更需要新接受的切片，不得擴張此文件任務。

`KERN-V1-01` 估算：冷啟動需 2,000–4,000 個模型 token 與 10–25 分鐘；目前沒有可比較的已結案任務登錄紀錄。里程碑為清冊盤點、邊界稽核與契約具體化；若超過 6,000 個 token 或 40 分鐘，原本就應重新界定稽核證據範圍。

## 驗收證據與測試狀態

2026-09-14 已觀察：

- 模組包含七個 Dart 檔案，以及 README 與本契約。
- 直接匯入限於 `dart:async` 與 kernel 內部檔案。
- 其餘八個已登錄上層根目錄目前皆匯入 kernel，符合其 L0 角色。
- `KlpContractError`、`KlpId` 與 `KlpPlacementId` 由 `kallopis_declarative.dart` 匯出；生命週期實作不匯出。

測試狀態：

- Green 範圍：既有身分與放置行為未變更，因此未重跑其測試。
- Yellow 範圍：直接驗證文件與匯入清冊；未新增執行階段斷言。
- Red 範圍：無；本次 PLAN 並非由失敗觸發。
- 視覺證據：不適用。

## 受保護路徑

- `lib/src/kernel/architecture.md`
- `test/klp_id_test.dart`
- `test/klp_placement_id_test.dart`
- `test/klp_placement_identity_test.dart`
- `test/klp_application_review_test.dart`
- Task Packet 中任何驗證生命週期租約或公開契約錯誤的測試所屬路徑。

### Application具名契約收尾（APP-CONTRACT-V1-r1）

APP-CONTRACT-V1-r1：APP-V1-06 剩餘完整 application foreign-internal 邊以25個既有來源實體歸具名路徑收尾。Kernel三個lifecycle來源、capabilities導航machine/兩exception及五part、composition scope boundary、十一features adapters、rendering renderer/viewport入口依精確map搬移。Renderer沒有parts；其餘平台實作保留同模組internal，具名入口的正常implementation imports不是consumer公開或跨模組穿透。Navigation五part隨原owner同library移動，狀態機／transaction／commit／lease／錯誤／回收body與callback身分不變。不得以轉匯出barrel遮住其他模組internal，不留舊shim；所有root公開library export指令與順序保持，25來源仍不公開。所有directcallers與36個catalog metadata字串同步原ID/factory/variant/順序，只替換路徑。features67exports／24component、application28ID保持。四個原未附文件的adapter只新增精確用途dartdoc以維持token baseline45，其餘非directive正文僅准行首tab正規化；去除這四新增註解後正文等價。不在這批實作R1/R2 lifecycle、filepicker或環境；後續使用新的rendering具名入口。

精確本模組範圍與派工條件見 [配對計畫](../../../docs/architecture/application-contract-plan/README.md)。APP-CONTRACT-V1-r1 已整合，七模組 scope、原行為、獨立 application 邊界與目錄檢查通過；見 [驗證](../../../docs/architecture/application-contract-plan/verification.md)。
