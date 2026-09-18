# Capabilities 模組架構

Status: PLAN READY — L1 相依邊界乾淨；公開編輯原始碼已歸具名契約；相容用途分類待 CAP-V1-03

依據：[模組登錄表](../architecture.md)、[模組架構 v1 規格](../../../spec/module-architecture-v1.md)、[KLP-0020](../../../spec/decisions/KLP-0020-blocknote-editor-adoption.md)

## 目的

`capabilities` 掌管與框架無關的狀態與互動契約，供上層使用而不需匯入 UI 或渲染實作。它與 styling 同屬 L1，下層只有 kernel。其責任為狀態權責／訂閱、泛用非同步資料、語意動作、導覽狀態轉移，以及編輯／provider 請求與投影契約。

`kallopis_editing_provider.dart` 是非視覺資料、命令與狀態的 provider 整合程式庫。它不是第二個元件來源，也不能公開元件建構或渲染。

## 非目標

- Flutter widget、版面配置／渲染、語意樣式值或元件範本。
- 持久化、儲存庫、文件引擎或產品領域權威。
- 在新路徑的 BlockNote 之外，另建即時正文模型、選取／排版引擎或 undo 堆疊。
- 元件註冊、應用組裝或 UI 擴充回呼。
- 掌管透過唯讀介面借用之狀態的生命週期。

## 目標階段與能力範圍

目前目標階段：記錄既有乾淨的 L1 相依邊界、分類編輯 provider 介面，並避免已棄用的自研編輯器責任擴張。

目前能力範圍：

- 明確區分狀態擁有者與唯讀介面，以及可安全撤銷的訂閱。
- 以世代／戳記保護非同步、導覽與編輯請求。
- 供程式庫功能適配器使用的純資料請求、回覆、投影與能力介面。
- 供 Krepis 適配器使用、不暴露 Kallopis UI 的穩定 provider 整合介面。
- 在 KLP-0020 尚未選定上游引擎的領域，可保留手寫與空間能力契約。

此範圍不授權新的 Kallopis 正文編輯器、持久化儲存庫、渲染器或產品工作流程。

## 所屬路徑與公開介面

所屬路徑：

- `state/`：唯讀與可變狀態，以及訂閱生命週期。
- `controllers/`：借用狀態的控制器契約。
- `data/`：泛用非同步資料狀態與通知失敗。
- `actions/`：語意動作與啟動契約。
- `navigation/`：路由值、決策、轉移與內部導覽狀態機。
- `editing/`：面向 provider 的請求、回覆、投影、狀態與能力介面。
- `block_note/` 與 `layout/`：僅保留給已接受、與框架無關的契約；沒有新接受的切片，不擴張空目錄或占位角色。

透過 `kallopis_declarative.dart` 公開：

- 宣告式節點需要的狀態／控制器、動作、非同步資料與導覽值契約。

透過 `kallopis_editing_provider.dart` 公開：

- 僅編輯／provider 資料、命令、投影、能力與狀態契約。

僅供內部使用：

- 未由公開程式庫匯出的導覽狀態機實作與輔助工具。

公開型別已實體歸位 `editing/contracts/`；公開性仍依 library 可達性判斷。未公開的 drop／submission 與 validation helper 保持非公開。

## 責任分布與相依方向

| 區域 | 責任 | 允許相依 |
| --- | --- | --- |
| `state` | 擁有者／唯讀狀態檢視與訂閱釋放。 | 僅 Dart SDK。 |
| `controllers` | 操作借用狀態，不取得釋放權。 | Capability 狀態。 |
| `data` | 具世代安全性的非同步閒置／載入／值／失敗狀態。 | Capability 狀態。 |
| `actions` | 語意請求與具放置感知的派發契約。 | Kernel 放置身分。 |
| `navigation` | 純路由值、政策決策、轉移與狀態機狀態。 | Capability 狀態與 kernel 語意身分。 |
| `editing` | 純 provider 請求、回覆、投影、來源，以及非視覺幾何／互動值。 | Capability 狀態、kernel 診斷與 Dart SDK。 |

Capabilities 只指向 L0 kernel。Foundation、composition、runtime、features、rendering 與 application 可相依於公開 capability 契約；capabilities 絕不匯入它們。

## 不變條件、生命週期與錯誤權責

- 可變狀態只有一個擁有者。借用端取得 `KlpState`；除非公開命令契約明確授權，否則不能釋放或修改擁有者的來源。
- 訂閱可冪等取消，取消後不得再收到通知。
- 非同步世代與導覽／編輯戳記可防止過期結果覆寫較新的已接受狀態。
- 請求與投影是不可變值；capabilities 不掌管 Flutter 影格、焦點節點、WebView、引擎工作階段或儲存庫生命週期。
- 新 BlockNote 路徑將正文模型、排版、選取與 undo 留在 BlockNote。Capability 契約可以傳輸快照／命令，但不能鏡像維護即時正文權威。
- Provider 失敗在此邊界維持為具型別回覆或穩定例外。使用者回饋與復原由 feature／application 所屬權責決定。
- 表示語意動作的回呼是事件契約，不是 Widget／渲染建構器擴充點。

## 允許與禁止的相依

允許：

- Dart SDK。
- L0 kernel 身分與診斷。
- Capabilities 內其他契約，但不得形成責任循環。

禁止：

- Flutter、Material、WebView 或平台 UI 套件。
- Styling 值、元件節點／插槽／範本、runtime 適配器或 rendering 型別。
- Application、feature 或產品領域模型。
- Krepis／BlockNote／Canva 的具體引擎工作階段或持久化實作。
- 第二份主題、環境、l10n 或即時文件權威。

## 採用設計與否決方案

採用：小型不可變請求／投影值與窄介面能力。來源只公開功能所需操作，同時保持狀態權責與過期結果防護明確。

否決：由單一編輯器控制器掌管文件狀態、排版、渲染、儲存與 undo。KLP-0020 將這些責任交給不同權威；單體設計將重建第二個即時正文引擎。

否決：因編輯 UI 使用 provider 契約，就將契約放進 features。Provider 契約必須維持與渲染器無關，並可供多種功能實現重用。

否決：將 `kallopis_editing_provider.dart` 視為元件匯出入口。它用於非視覺整合；UI 組合仍專屬於 `kallopis_declarative.dart`。

## 目前階段切片

| 切片 | 成果 | 允許路徑 | 驗收證據 | 狀態 |
| --- | --- | --- | --- | --- |
| `CAP-V1-01` | 具體化本契約，並稽核 L1 匯入邊界／公開程式庫。 | `lib/src/capabilities/architecture.md`、登錄表狀態 | Capability 原始碼只匯入 kernel 與自身；公開匯出已分類為宣告式或 provider 契約。 | complete（已完成） |
| `CAP-V1-02` | 將公開可達的編輯契約從 `editing/internal/` 正規化至 `editing/contracts/`，不變更名稱或行為。 | `lib/src/capabilities/editing/**` | Provider 匯出入口與上層模組解析至明確契約路徑；沒有公開程式庫匯出 `internal/` 原始碼路徑。 | complete（LOWER-V1-r1 已整合） |
| `CAP-V1-03` | 將 KLP-0020 已取代的自研正文模型／排版／選取／undo 契約標示為僅供相容，同時保留可重用的 provider／儲存／身分，以及尚未定案的手寫／空間契約。 | `lib/src/capabilities/editing/**`、直接相關能力文件 | 新 BlockNote 功能不相依於已棄用的即時正文權威；舊版相容匯入仍可識別且範圍受限。 | complete（COMPAT-V1-r1 已整合） |
| `CAP-V1-04` | 從 foundation 接收與框架無關的裝置分類、顯示模式與方向值，作為環境能力。 | 新的明確 capability 環境路徑與直接相關能力文件 | Composition 可使用 L1 值選擇適應式結構；foundation 以相容轉送保留舊匯入，直到呼叫端完成遷移。 | complete（AD-V1-r1 已整合） |

CAP-V1-02 已由 LOWER-V1-r1 完成舊 internal 路徑搬移；CAP-V1-03 是用途分類，不授權刪除舊正文相容實作。`CAP-V1-04` 是搬移既有純值，並非新增環境權威。

`CAP-V1-02` 冷啟動估算：6,000–12,000 個模型 token 與 45–100 分鐘。沒有可比較的已結案登錄任務。里程碑：公開型別清冊、契約路徑具體化、成對呼叫端遷移，以及過時路徑移除。超過 18,000 個 token 或 150 分鐘，需設異常檢查點。

### 自適應責任配對（AD-V1-r1）

已接受共通規格 AD-V1-r1；本模組精確寫入範圍見 [配對計畫](../../../docs/architecture/adaptive-module-plan/README.md) 的 path-map。composition 保留宣告／策略，runtime 掌管 adaptive 實作，capabilities 擁有三個平台 enum，foundation 舊路徑以相容轉匯出維持同一型別；application 僅同步目錄來源。無新 API 或環境權威。

## 驗收證據與測試狀態

AD-V1-r1 最新證據：5 個模組 scope PASS，composition 沒有 runtime/foundation 指令；既有自適應／catalog／runtime／scope／root-import／runtime 邊界共 28 項與新增邊界／enum 相容身分檢查均通過。capabilities 擁有三個純 enum，foundation 轉匯出仍是同型別；application 僅更新真實 adapter 來源，不將 APP-V1-05/06 全部結案。詳見 [本批驗證](../../../docs/architecture/adaptive-module-plan/verification.md)。

2026-09-14 已觀察：

- Capabilities 在 actions、controllers、data、editing、navigation 與 state 責任區域中包含 98 個 Dart 檔案。
- 唯一跨模組匯入是三處 kernel 身分／診斷參照。
- Capabilities 未匯入 Flutter 或外部引擎套件。
- `kallopis_declarative.dart` 匯出狀態、動作、導覽與資料契約。
- `kallopis_editing_provider.dart` 匯出 `editing/contracts/` 的原編輯／provider 型別；未匯出 Widget 或元件定義。

測試狀態：

- Green 範圍：能力行為未變更，未重跑測試。
- Yellow 範圍：已直接檢查匯入與公開匯出。
- Red 範圍：無。
- 視覺證據：不適用；能力幾何與狀態是確定性資料，不屬像素驗收。

## 受保護路徑

- `lib/src/capabilities/architecture.md`
- `test/klp_async_data_test.dart`
- `test/klp_state_test.dart`
- 導覽狀態機／路由契約測試。
- 編輯請求、投影、儲存、文字偏移、組合與手寫狀態測試。
- `test/frontend_architecture_boundary_test.dart`

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

### Host ports 配對（HOST-PORTS-V1-r1）

HOST-PORTS-V1-r1 接受 APP-V1-05／FEAT-V1-06 的 E 環境與 P 檔案選取配對。Capabilities 持有純環境解析及既有 KlpAppPlatform／KlpAdaptiveMode 唯一宣告，Stable foundation 原 facade、型別與 current(Size?) 行為保留；application 唯一既有 host 採樣並安裝，不增加 observer、store 或預設。P 接替已接受的 concrete picker 宣告式面：公開 L1 KlpPickFileAction，port/result 套件內部；application 唯一 plugin adapter，既有 action handler 用原 frame/lease/epoch/entry 在 await 前後檢驗。有效 selected 才回呼一次，cancel/stale/failed 為 false，平台或 callback error 原物件／stack 由 host 一次回報。舊零 host picker 搬 application/legacy 並由專用 legacy root 保留 const/欄位/pick Future 成功取消與原 error 傳播；不作現行宿主 fallback。公開 roots 6→7，僅 declarative 一增一刪及新 legacy，feature exports 67→66，24 components/28 IDs/順序保持。原 R1/APP06 root/hash/closure/catalog 基準依 path-map 精確增減由獨立作者更新，不 blanket resnapshot 或放寬原守衛。E 單獨不完成 APP05；E/P 與完整證據通過才 APP05/FEAT06 complete。

具體值與派工範圍見 [配對計畫](../../../docs/architecture/host-ports-plan/README.md)。實作驗證待完成。

HOST-PORTS-V1-r1 的 E／P 配對已整合，原環境相容與租約／錯誤／公開邊界檢查通過；見[最終驗證](../../../docs/architecture/host-ports-plan/verification.md)。完整 CI 的既存失敗另列，不代表發布全綠。
