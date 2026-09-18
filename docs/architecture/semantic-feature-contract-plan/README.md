# Semantic Feature Consumer Contract — SFC-V1-r1

Status: PLAN READY

Owning module: `features`

Paired owners: `application` 擁有公開應用根與封閉 adapter 安裝；`rendering` 擁有短暫互動、controller 命令執行與平台焦點；integration steward 擁有 `kallopis_declarative.dart`、Catalog／reference 與跨模組驗證。

依據：[KLP-0021](../../../spec/decisions/KLP-0021-productivity-component-ecosystem.md)、[Features 模組契約](../../../lib/src/features/architecture.md)、[Rendering 模組契約](../../../lib/src/rendering/architecture.md)、[Application 模組契約](../../../lib/src/application/architecture.md)。

## 目標與當前階段

Kallopis 對 consumer 只暴露封閉的產品輸入與語意互動契約，不暴露視覺原料、平台物件或任意回呼擴充。Consumer 學會一個 semantic feature 後，應能以相同方式預測其他 feature 的資料入口、intent 出口、可選 controller、狀態權威與失敗行為。

`SFC-V1-r1` 只交付第一個垂直驗證階段：

1. `KlpApplication` 不再要求 consumer 傳入 primitives，`kallopis_declarative.dart` 不再匯出 styling primitives／preset。
2. `KlpExplorer` 改為完整的 declaration／data／single-intent／optional-controller 範例。
3. `KlpDocumentTabs` 以同一形狀完成第二個範例，證明契約不是 Explorer 專用特例。
4. Catalog／reference 只將這兩個 feature 標示為新契約驗證完成；其他現行匯出維持明示 gap。

這個階段不宣稱所有現行 feature 或固定 254 項已遷移，也不刪除 Stable legacy library。

## 非目標

- 不在 r1 遷移 Menu、Anchored Popup、Workspace Block、Window Controls 或 editing controls。
- 不在 r1 重設 raw layout／frame API；它們保持明示 non-conforming，不觀察成 consumer-ready。
- 不改變 Explorer／Document Tabs 已接受的視覺、鍵盤或焦點行為，不藉機重設 style recipe。
- 不建立萬用 feature base、全域 event bus、consumer data source 或動態 plugin registry。
- 不刪除 `kallopis_theme.dart`、`kallopis_foundation.dart` 或其他 P9 前 Stable 相容面。
- 不修改固定 Catalog baseline 的 254 項分母，不將兩個 pilot 當成全生態完成。

## 能力地平線對當前設計的壓力

完整地平線仍包含 overlays、actions、forms、collections、planning、charts、canvas、handwriting 與 provider-backed editing。當前設計因此保留下列可取代接縫，但不預先建立對應的空層或萬用型別：

- feature-specific intent 是 sealed hierarchy，可在未來加入新語意事件，不需改成字串或全域 event bus。
- data projection 可以是完整 snapshot 或 windowed snapshot；feature 不需知道 repository、cursor 或 transport。
- controller 使用受限的套件內 port 附接 renderer；未來 feature 可不同方法名擴充，不需建立 `KlpFeatureBase`。
- 共通 capability 只在兩個以上 feature 具有相同意義與失敗規則後才提取；名稱相似不足以建立共同基底。

## 公開類型分類

`kallopis_declarative.dart` 的公開宣告必須先屬於下列一類：

| 類別 | 公開形狀 | 是否要求 data／intent／controller |
| --- | --- | --- |
| Semantic feature | 會呈現產品資料或產生使用者意圖的封閉功能，例如 Explorer、Document Tabs、Menu。 | 必須有 declaration、immutable data 與單一 intent；只有一次性命令需求才有 controller。 |
| Structural declaration | 只建立 Kallopis 掌管的合法組裝關係，不產生產品意圖。 | 不強制建立空 data／intent；只能使用具名語意 slot，不提供原始幾何。 |
| Provider-backed feature | 呈現上游 provider 工作階段，例如 BlockNote。 | 仍使用 feature declaration／intent；provider session 是受限輸入，即時正文、選區與 undo 不複製成 Klp data。 |
| Cross-feature application action | 由 application host 執行的全域語意命令。 | 使用具體 `KlpAction`；不取代 feature intent，不接受任意 `KlpCallbackAction`。 |

無法分類的匯出不得新增；現行無法分類者必須保持 non-conforming 記錄，不得以「已在 barrel」當成接受證據。

## Semantic feature 的標準形狀

每個 feature `X` 的公開形狀為：

| 角色 | 契約 |
| --- | --- |
| `KlpX` | `final` declaration node；只接受 identity、`KlpXData`、單一 `onIntent` 與可選 `KlpXController`。 |
| `KlpXData` | 防衛複製後的 immutable projection；包含內容、consumer-owned state、enabled／read-only capability 及預期失敗狀態。 |
| `KlpXIntent` | `sealed` 且只有 Kallopis 定義的 `final` 變體；名稱使用 `Requested`，表示建議而非已提交事實。 |
| `onIntent` | `void Function(KlpXIntent)`；Kallopis 不 await consumer 商業工作，也不在事件後私自改寫 consumer state。 |
| `KlpXController` | 只包含焦點、reveal 等一次性語意命令；不提供 setter、state getter 或 Flutter 物件。 |

結構性 child node 不因位於 feature 內部而成為另一個 semantic feature。例如 Document Tab 是 `KlpDocumentTabsData` 內的項目值，不再作為 consumer 可單獨放置的 node。

### 公開欄位允許表

| 允許 | 禁止 |
| --- | --- |
| `KlpId`、產品文字／內容、產品狀態投影、Kallopis 定義的語意 role／capability、合法的 Kallopis child、`onIntent`、受限 provider session。 | Widget、builder、`BuildContext`、painter、renderer、theme／token／preset、顏色、字型、padding、gap、radius、shadow、raw size／flex、duration／curve、Flutter controller／focus node／scroll controller、repository／stream／data-source callback、item-level action callback。 |

產品文字是資料；通用 chrome 文字（例如「展開」、「關閉」）由 Kallopis l10n 擁有，不以 constructor 字串提供品牌或呈現自訂。圖示只能使用 Kallopis 語意枚舉或受限內容 asset 值，不接受 Widget／path／painter。

## Data projection 契約

1. Constructor 立即防衛複製 list、set 與 map；快照擷取後不再讀取 consumer 的可變容器。
2. 穩定 identity、項目順序、選取、展開、釘選、可用性及可見錯誤都是 projection，由權威 owner 重新宣告。
3. loading、empty、error、partial 與 ready 是顯式、互斥或契約明列可併存的狀態；不從 `items.isEmpty` 或 callback 是否為 null 猜測。
4. 大型資料的 `KlpXData` 可只包含 window 與 before／after 可載入語意；分頁、搜尋與重試透過 intent 輸出。
5. Feature 不持有來源、repository、stream 或延遲查詢回呼。Provider-backed feature 只借用 spec 明列的 session 介面。
6. 動作可用性由 projection 的語意 capability 表達，不從 handler 有無推導。若任一會產生 intent 的 capability 為 enabled，`onIntent` 必須存在；否則建構時拒絕。

## Intent 契約

- Intent 只描述使用者試圖、目標 identity、Kallopis 經驗證的建議值與必要輸入；不攜帶 Widget、style、repository、callback 或 mutable controller。
- Disabled、read-only 或已被 frame lease 取代的互動不產生 intent。同一已接受 gesture 最多輸出一個主 intent。
- Selection、expansion、pin 等 intent 可攜帶 Kallopis 依當前 snapshot 計算的完整 proposed state；consumer 可接受、修正或拒絕，畫面只以下一份 projection 為準。
- `onIntent` 是同步通知邊界，不返回產品結果。Consumer 回呼拋錯時，當前 frame 不被改寫，原 error／stack 由唯一 application host 回報。
- Feature 不暴露同等的 `onSelected`、`onClose`、`onDrop` 或 item-level `onPressed` 作第二事件出口。

## Controller 契約

- Controller 由 consumer 建立與釋放；Kallopis 只在對應 placement 存活期間附接套件內 port。
- 同一 controller 同時只能附接一個 live placement；重複附接拋出具穩定 code 的 `KlpContractError`。
- 未附接、目標不存在、能力被拒絕、frame 已取代與完成是具型別結果；未附接命令不排隊，避免在未來畫面意外執行。
- Controller 命令的 `Future` 在實際執行、拒絕或被取代後完成；當前 frame 失效後不得對新畫面產生效果。
- Controller 不讀寫 consumer-owned state。能以重新宣告表示的需求，不得新增 controller setter。

## SFC-V1-r1 精確公開契約

### Application visual authority

`KlpApplication` 保留 title、router 與導覽還原輸出，移除 consumer-supplied `KlpPrimitiveSet primitives`。Application host 依 Kallopis 擁有的 environment 選擇 Kallopis 內建 preset，consumer 沒有 preset／theme／token 覆寫。

明暗外觀也不是 consumer API。既有私有 `KlpApplicationEnvironment` 新增 `KlpApplicationAppearance.light／dark`，唯一 `_KlpApplicationEnvironmentObserver` 從 `platformDispatcher.platformBrightness` 採樣並投影；不得直接把 Flutter `Brightness` 傳進 feature、runtime 或公開契約。`_KlpApplicationHostState._accept` 在同一次提交採樣 environment 與 adaptive context，session 只保存目前 appearance；`_commit` 依 appearance 選擇固定 warm tone 的 `KlpWorkspacePreset.light()` 或 `KlpWorkspacePreset.dark()`。Preset recipe 仍只由 styling 擁有，application 只選擇，不複製 token 或建立第二套 theme。

`didChangePlatformBrightness` 以目前已接受的 application 重新投影，沿用既有 navigation snapshot、router identity 與 frame commit 規則；沒有 application 時不做事。這次重投影不得重新啟動資料來源、建立新導覽 machine 或改寫 consumer state。Catalog 的明暗驗證由平台 dispatcher 的測試值或 example 私有宿主完成，不新增 public selector。

`kallopis_declarative.dart` 移除 `KlpPrimitiveIndex`、`KlpPrimitiveSet`、`KlpStyleKind`、`KlpStyleValue` 與 `KlpWorkspacePreset` 匯出。Stable `kallopis_theme.dart`／legacy 相容面不在本階段刪除。

### Explorer

`KlpExplorer` 只保留 `id`、`data`、`onIntent` 與可選 `controller`。`actionsLabel`、`expandLabel`、`collapseLabel`、`onSelectionChanged`、`onActivate`、`onExpandedChanged`、`canDrop` 與 `onDrop` 全部移除；通用 chrome 字串改由 Kallopis l10n 提供。

唯一 `KlpLocalizations` 增加 Explorer 的 actions／expand／collapse，以及 Document Tabs 的 modified／pin／unpin／close chrome 字串。這是既有 l10n 權威的加法擴充，不建立 feature 私有字串來源，也不讓 consumer 以 feature constructor 注入 chrome 文案。

`KlpExplorerIntent` 的 r1 封閉變體：

- `KlpExplorerSelectionRequested`：scope ID、proposed selected IDs 與 proposed anchor ID。
- `KlpExplorerActivationRequested`：item ID。
- `KlpExplorerExpansionRequested`：item ID、expanded 與該樹 proposed complete expanded IDs。
- `KlpExplorerDropRequested`：經 snapshot 驗證的 source IDs、target ID 與 before／inside／after。
- `KlpExplorerCommandRequested`：item ID、command ID 與 Kallopis 命令表面收集的可選輸入。

Explorer command 資料改為無 callback 的 immutable descriptor；命令是否可用、destructive、需要輸入或確認都由封閉語意值表示。Consumer 用下一份 Explorer data 回傳 loading／error／result feedback，不將 async callback 放進 item。

Drop permission 改為 `KlpExplorerData` 內的 immutable acceptance snapshot，以精確 source ID set、target ID 與 placement 為 key。Preview 與 commit 共用同一份 snapshot；未列出即拒絕，feature 不回呼 consumer 查詢權限。Consumer 收到 drop intent 後才決定是否提交產品資料。

`KlpExplorerController` r1 只提供 `focusItem(id)` 與 `revealItem(id)`。結果區分 completed、unavailable、targetMissing 與 superseded。`revealItem` 只操作當前 projection 已存在且已展開路徑的呈現項目；不自動改寫 expansion 或載入資料。

### Document Tabs

`KlpDocumentTab` 由 public child node 改為 `KlpDocumentTabData` 不可變值。`KlpDocumentTabsData` 擁有有序 tabs、selected ID 與適用的可用性，拒絕重複 ID 與不存在的 selected ID。

`KlpDocumentTabs` 只保留 `id`、`data` 與 `onIntent`；r1 不需要 controller。`KlpDocumentTabsIntent` 的封閉變體為：

- `KlpDocumentTabSelectionRequested`：tab ID。
- `KlpDocumentTabCloseRequested`：tab ID。
- `KlpDocumentTabPinRequested`：tab ID 與 proposed pinned value。

選取、關閉與釘選只是請求；Kallopis 不移除、重排或修改 tab data。無可用互動時可省略 `onIntent`；任一 tab 可選、可關閉或可釘選時，缺少 handler 為契約錯誤。

## 內部流水線與相依方向

```text
consumer declaration
  → composition capture（結構、identity、slot）
  → feature adapter（data 驗證、intent 租約、controller port 附接）
  → immutable bound feature record
  → private renderer（短暫互動、focus／pointer／semantics）
  → leased feature intent／controller result
```

- `features` 擁有公開 declaration、data、intent、controller 及套件內 adapter／bound contract。
- `composition` 只驗證結構與封閉 catalog，不理解 intent 或 controller。
- `runtime` 依 placement／frame lease 保護 callback 與資源生命週期，不取得產品資料權威。
- `rendering` 只消費 bound record，不對 consumer 暴露 Widget 或平台 controller。
- `application` 安裝封閉 adapter 與 host diagnostic，不重新定義 feature 事件。

## 生命週期與錯誤

| 情況 | 契約 |
| --- | --- |
| 非法 data／重複 ID／不存在的 selected ID／缺少必要 handler | 在 capture／adapter 邊界拋 `KlpContractError` 與穩定 feature-specific code；不提交部分 frame。 |
| 使用者操作 | 只在 live frame lease 內輸出 intent；新 frame 取代後的舊 callback 無效。 |
| Consumer intent handler 拋錯 | 原 error／stack 交 application host diagnostic；Kallopis 不虛構新 projection。 |
| Controller 命令遇到 frame 取代 | 完成為 superseded，不把效果套用到新 placement。 |
| loading／permission／business rejection／not found | 使用 typed data state 或 controller result，不使用自訂 error Widget。 |
| Renderer／provider 非預期失敗 | 原 error／stack 由唯一 host 回報；保留上一安全 frame 或呈現 Kallopis-owned error state。 |

## 現行公開面差距

| 現行契約 | 差距 | r1 處置 |
| --- | --- | --- |
| `KlpApplication.primitives` 與 declarative styling exports | Consumer 直接選擇視覺原料。 | 本階段移除，改由 Kallopis host／environment 選擇。 |
| Explorer 五組 callbacks 與 permission predicate | 多事件出口，且 renderer 回呼 consumer 查詢資料。 | 本階段改為單一 intent、acceptance snapshot 與 controller。 |
| Document Tabs 三組 callbacks，tab 是 child node | 不符合一致 feature 形狀。 | 本階段改為 data value 與單一 intent。 |
| Menu、Anchored Popup、Workspace Block、Window Controls 及 editing controls 仍有 callback | 尚未符合新契約。 | 在清冊標示 non-conforming；不於 r1 擴張實作範圍。 |
| Layout row／column／flex／spacing／frame style 仍公開 | 結構 API 仍可控制原始呈現。 | 記錄為後續結構契約壓力；未改為語意具名 slots 前不標 consumer-ready。 |
| `KlpCallbackAction` | 任意 callback 可作為全域動作。 | 本階段從 declarative barrel 移除；具體 typed host action 依各自契約保留。 |

「non-conforming」不是之後不處理；它是完整地平線中已知且不允許被文件冒充完成的缺口。後續契約必須依對應 semantic family 回到獨立 PLAN，不在 r1 建立一個處理所有 callback 的萬用 event 系統。

## 採用與否決設計

採用：以命名約定、sealed feature intents、immutable projection 及可選受限 controller 建立一致形狀。一致性透過公開面清冊、編譯契約與個別 feature 行為證據驗證，不以 runtime 繼承強迫。

否決：

- 萬用 `KlpFeatureBase<TData, TIntent>`：將迫使 structural／provider-backed feature 進入同一生命週期，並使 consumer 面對無意義泛型。
- 全域 event bus：失去 feature 語意、類型窮盡與局部測試邊界。
- 同時保留舊 callback 與 `onIntent`：建立兩個事件權威，consumer 無法判斷正式路徑。
- 將 consumer repository 包成 data-source interface：feature 會取得非同步生命週期與產品存取責任。
- 用 callback predicate 處理 drop／permission：renderer 會在不可預測的平台時機執行 consumer 邏輯。
- 保留 visual primitives 但稱它們是 semantic：只要 consumer 能組合顏色、間距或 preset，視覺權威就不在 Kallopis。

## 當前階段配對切片

| Packet | Owner | 允許寫入 | 產出 | 確定性驗收 |
| --- | --- | --- | --- | --- |
| `SFC-V1-T` | Independent Test Author | 新增 semantic feature／public boundary 測試與專用 fixtures；不改 production | 真實 Red：application 仍要求 primitives、style exports 可達、Explorer／Tabs 仍有多 callback／permission callback／old tab node；保留現有功能行為的正向驗收。 | 每個 Red 在 baseline 因目標違約失敗，不因缺檔或無關編譯錯誤失敗；測試 worker 不寫 production。 |
| `SFC-V1-APP` | Application | `lib/src/application/structure/klp_application.dart`、`lib/src/application/environment/klp_application_environment.dart`、`lib/src/application/environment/klp_application_environment_observer.dart`、`lib/src/application/bootstrap/internal/klp_application_host_state.dart`、`lib/src/application/bootstrap/internal/klp_application_session.dart`、`lib/src/application/bootstrap/internal/klp_application_session_commit.dart` | 移除 public primitives 輸入；由既有唯一環境觀察器取得 appearance，session 保存提交輸入，Kallopis 宿主選擇唯一內建呈現來源。 | light／dark 選擇與平台亮度變更重投影具確定性、沒有 consumer style input；同一次提交只用一份 appearance，導覽、l10n、environment 單一權威不變。 |
| `SFC-V1-L10N` | Foundation | `lib/src/foundation/localization/klp_localizations.dart` 與直接 localization contract test | 在唯一 l10n authority 增加 Explorer／Document Tabs chrome 字串。 | 預設文字保持現有輸出；copyWith-like constructor、equality／hash 及 delegate 路徑仍使用同一份 `KlpLocalizations`，feature constructor 沒有文案逃生口。 |
| `SFC-V1-F` | Features | `lib/src/features/workspace/explorer/**`、`lib/src/features/workspace/components/klp_document_tabs.dart`、兩者直接的 workspace presentation／adapter contract | 新 data／intent／controller 形狀、純資料 drop／command 許可、frame-leased 單一 intent。 | 建構驗證、快照不可變、intent 窮盡、controller 附接生命週期，且沒有舊 callback 或 consumer query callback。 |
| `SFC-V1-R` | Rendering | `lib/src/rendering/flutter/internal/klp_flutter_explorer.dart`、承載 tabs 的 workspace renderer 分支與直接 helper | 現有指標、鍵盤、焦點、drag／drop、tabs 操作改為 intent／controller port，視覺保持。 | 事件次數、disabled／stale lease、drag acceptance snapshot、focus／reveal result、semantics 與幾何行為沒有感官 golden。 |
| `SFC-V1-I` | Integration Steward | `lib/kallopis_declarative.dart`、application adapter catalog／feature ownership metadata 的受影響列、直接 consumer 範例／Catalog／reference | 移除 style／callback 舊入口，接入新公開類型，將其餘 gap 誠實標示 non-conforming。 | 公開匯出清冊、封閉 catalog、負向編譯、Catalog 真實互動、reference 連結；Stable legacy 匯出不變。 |

執行順序為 `SFC-V1-T → SFC-V1-APP → SFC-V1-L10N → SFC-V1-F → SFC-V1-R → SFC-V1-I`。Test Author 首先凍結 Red；Foundation 先補齊唯一 chrome 字串來源，Features 再發布 bound／port 契約供 Rendering 實作；Integration 最後才替換 barrel 與範例，避免暫時對 consumer 公開不完整形狀。

## 任務估算與里程碑

現有 Explorer／Menu 任務只有冷啟動估算，沒有可供換算的精確 token 實測；下列使用目前模型、本機 Flutter `C:/development/flutter/bin`、無網路下載且 Krepis path dependencies 可解析為假設，basis 為 cold-start。

| Packet | 預計 token | 預計時間 | 里程碑 | 異常門檻 |
| --- | ---: | ---: | --- | --- |
| `SFC-V1-T` | 6k–12k | 45–90 分 | M1 公開 Red（3k／25 分）；M2 行為／生命週期 Red 與正向保留（6k–12k／45–90 分） | 任一 Red 來自缺檔或必須修 production，立即回報。 |
| `SFC-V1-APP` | 6k–12k | 45–90 分 | M1 private appearance snapshot 與 host-owned preset（3k–6k／25–50 分）；M2 亮度變更重投影與 application API Green（6k–12k／45–90 分） | 需新增第二 theme／environment 權威、公開 appearance selector 或超過 12k／90 分。 |
| `SFC-V1-L10N` | 2k–4k | 15–30 分 | M1 欄位／預設／相等性（1k–2k／10–20 分）；M2 localization contract Green（2k–4k／15–30 分） | 需新增另一份 localization authority、feature constructor 文案或超過 4k／30 分。 |
| `SFC-V1-F` | 12k–24k | 90–180 分 | M1 Explorer data／intent／drop／command（10k／75 分累計）；M2 controller／Tabs／adapter／bound（12k–24k／90–180 分） | 必須修改第三個 feature family、新建萬用基類或超過 24k／180 分。 |
| `SFC-V1-R` | 10k–20k | 75–150 分 | M1 intents／drag／tabs（8k／60 分累計）；M2 controller lifecycle／semantics／局部 Green（10k–20k／75–150 分） | 必須改全域 renderer 架構、引入 consumer Widget 或超過 20k／150 分。 |
| `SFC-V1-I` | 8k–16k | 60–120 分 | M1 barrel／catalog／examples（8k／60 分累計）；M2 reference／public boundary／scope（8k–16k／60–120 分） | 需變更固定 254 分母、Stable legacy API 或超過 16k／120 分。 |

每個 worker 只在里程碑完成後回報一次結構化 checkpoint。若 Krepis path dependencies 在隔離基準不存在，局部 Dart／source contract 證據與被阻擋的 Flutter 證據必須分開回報，不可把環境失敗寫成功能 Green。

## 測試狀態與受保護路徑

目前為 Yellow：契約與差距已根據實際公開面確認，但 `SFC-V1-T` 尚未由獨立 Test Author 建立真實 Red。本 PLAN 沒有執行 Flutter 測試，不將現有 Explorer／Tabs 測試的歷史通過狀態當成新契約 Green。

受保護路徑：

- `spec/decisions/KLP-0021-productivity-component-ecosystem.md`。
- `lib/src/features/architecture.md`、`lib/src/rendering/architecture.md`、`lib/src/application/architecture.md` 與本配對計畫。
- `docs/architecture/catalog-migration/legacy-baseline.json`、`coverage.json` 及其完成門檻。
- 所有 test-owned 路徑；implementation worker 可讀取與執行，不得修改、略過或放寬。
- Stable `kallopis_theme.dart`、`kallopis_foundation.dart`、legacy application 與本階段未列入的其他 feature family。

`SFC-V1-T` 除新契約測試外，也擁有受 `KlpApplication` constructor 變更影響的既有 application／menu／navigation fixtures，以及現有 Explorer／Document Tabs 測試的精確語法遷移。遷移必須保留原行為斷言，不得以刪除案例或改成只測新類型存在取得 Green。

## PLAN readiness

`SFC-V1-r1` 的當前 P1 已配對至 application visual authority、Explorer／Document Tabs 公開契約、features adapter／rendering／host 生命週期、公開 barrel／Catalog／reference 與獨立證據。相依方向保持 L0→L7，沒有新的 consumer 擴充點、第二資料權威或未決架構選擇。

目前 `PLAN READY`。這只授權上列 r1 packets；其他 non-conforming feature、raw layout API 與固定 Catalog 遷移必須各自另行 PLAN，不得併入某個 r1 worker 的 write paths。
