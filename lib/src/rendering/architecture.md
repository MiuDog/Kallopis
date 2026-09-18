# Rendering 模組架構

## SCL：Private visual tree

架構目標已接受，runtime BUILD gated。依 [`screen → layout → container → element`](../../../docs/architecture/semantic-composition-layer-plan/README.md)，rendering 可在任何公開層的實作內自由使用 Row／Column／Stack／sliver／overlay 等平台容器，但只能消費 immutable bound records；不得把 Widget tree、geometry、builder、style 或跨層 child 能力回傳至 public API。具體 renderer 替換等待 family packets。

## CAT-MIG-02：移除未使用的 legacy WindowControls bridge

狀態：PLAN READY。現行 `KlpFlutterRenderer` 對 `KlpBoundWindowControls` 的唯一 dispatch 位於 `flutter/internal/klp_flutter_workspace_components.dart`，直接消費 bound 色彩、尺度、文字與 callback。`flutter/internal/klp_flutter_window_controls.dart` 沒有 import caller，仍自行採樣 runner 狀態並橋接 legacy theme／Widget，違反單一新版呈現路徑且已無責任。

ACW-R 只刪除該零 caller 檔案；不得修改現行 renderer、window action、legacy shell、style resolver 或 public API。驗收以 import graph、renderer dispatch、既有 workspace declarative tests 與 Catalog contract 證明刪除後沒有缺失。若發現動態或 generated caller，stage 返回 PLAN，不建立 shim。

## SFC-V1-r1：Explorer／Document Tabs intent 與 controller 實現配對

當前新增 stage 狀態：PLAN READY。共通契約見 [SFC-V1-r1](../../../docs/architecture/semantic-feature-contract-plan/README.md)；本節不改寫下方已完成 rendering v1／Explorer 視覺證據。

Rendering 只將現有 Explorer 與 Document Tabs 指標、鍵盤、焦點、drag／drop 操作改為消費 features-owned bound intent sink／controller port。不定義 public intent，不讀寫 consumer state，不對 consumer 暴露 FocusNode、ScrollController 或 Widget。舊 callback 只能在同一切片移除，不得與新 `onIntent` 並存。

Explorer drop 只接受 bound acceptance snapshot 已列出的精確 source／target／placement；preview 與 commit 使用同一 snapshot。Controller `focusItem`／`revealItem` 以 placement／frame lease 保護，未附接、找不到目標與 frame 取代都回傳 typed result，不丟出晚到平台效果。

本模組 write boundary 限 `flutter/internal/klp_flutter_explorer.dart`、承載 Document Tabs 的 workspace renderer 直接分支，以及當且僅當這兩者共用才必要的私有 helper。其他 renderer、視覺 recipe、全域焦點架構、測試與本模組契約對 BUILD worker 保護。

## CAT-MIG-01：舊 Catalog 全面遷移的選單切片

當前新增切片依 [CM-01 共通契約](../../../docs/architecture/catalog-migration/README.md) 配對，PLAN READY。僅授權該契約列出的本模組路徑；既有已接受元件、全域 preset 與其他階段保持。最終以固定舊 Catalog 基準逐項完成新版後刪除舊元件，不能以此首批宣稱全面完成。


## EXP-V1-r3 箭頭與後代收合

依 EXP-17～19，PLAN／BUILD 已完成，局部驗證通過；EXP-V1-r3 Catalog 外觀與互動已由使用者於 2026-09-15 回覆「同意」接受。分類一律顯示箭頭，可收合空分類可切換；一般節點仍需有子項。兩種箭頭使用 disclosureIconExtent（distance i3，12px），命中及一般圖示保持 20px。KlpExplorerData.expandedIdsAfter(KlpId id, bool expanded, {bool collapseDescendants = false}) 回傳該項所屬樹的不可變完整展開集合，不提交資料；遞迴模式移除所有後代含隱藏後代，其他樹與選取不變。未知項或不可切換項拋 explorer_invalid_expansion。既有 onExpandedChanged(id, bool) 保持。 本 slice 只寫 flutter/internal/klp_flutter_explorer.dart。指標、Enter／Space、左右鍵共用快照資格；不可收合分類的箭頭為向下非操作指示，不提供錯誤 button 語意。特徵模組先提供 bound 契約。


圖示與放置長條對齊修訂 EXP-V1-r2-icon-align-r2：同層級 node 的圖示使用固定 x 軸起點，不因 children／collapsible／展開狀態改變。每個 node 在圖示左側保留相同 disclosureExtent 箭頭欄；可展開才顯示箭頭，其餘只保留對齊空間，不增加按鈕或能力。放置 node 的長條也採預計插入層級的圖示基線（inset + disclosureExtent + depth × indent），inside node 再縮排一層；拖曳分類仍使用分類基線。分類維持標題後的小箭頭。這是使用者指定的結構對齊用途，不是空內容的任意占位。

放置長條修訂 EXP-V1-r2-drop-gap：使用者要求取代兩個元件間隙。中間 before／after／inside 指示填滿既有 gap，高度為 resolved gap、圓角半徑為高度一半，保留原縮排與顏色，不增加高度或攔截命中。首列 before／末列 after 若無外側間隙，於該列內側邊緣顯示同厚度圓角條避免裁切。舊 focusWidth 細線呈現由此取代。

拖曳視覺修訂 EXP-V1-r2-drag：feedback 包含原列圖示與標題；before 畫在目標上緣，after 畫在目標可見子樹末端，inside 以子層縮排畫在可見子樹末端表示加入子項。只有 canDrop 許可才畫線，區域變更即更新，離開／提交後清除。顏色／線寬使用既有 resolved focusColor／focusWidth，不增加 consumer 樣式 API。

分類箭頭視覺修訂 EXP-V1-r2-arrow：依使用者要求，分類箭頭緊接標題後，圖示採獨立 disclosureIconExtent（distance i3，預設 12px）；箭頭命中區維持 disclosureExtent（20px）乘分類列高，普通節點依 EXP-V1-r3 使用相同箭頭尺度，前置位置不變。features 提供 resolved 尺寸，rendering 決定分類標題後的固定排列；consumer API 不新增樣式選項。

Explorer 配對 [EXP-V1-r2](../../../docs/architecture/explorer-v1-plan/README.md) 已 PLAN READY。新增 flutter/internal/klp_flutter_explorer.dart、klp_flutter_commands.dart 並由主 renderer 接入；workspace_components 移除 Explorer，workspace_block 共用命令呈現。共享 anchor、frame lease、每次拖放驗證與真實 Catalog 依 r2；KBF 後續接線改引用新檔，不能沿用舊 kind。

## BlockNote Flow 配對（KBF-PAIR-r2）

此節為新增 stage，**配對契約 READY、實作 pending**，不改下方既有 rendering v1 狀態。[共通配對](../../../docs/architecture/blocknote-flow-pairing.md) 定義完整資料與恢復行為；只引用其連到的 Krepis KBF-WIRE-r2。

Explorer 來源／拖放部分受 EXP-V1-r2 替換，KP-R1 的 Explorer 舊檔案邊界須重新 PLAN 配對，不能直接沿用；其餘 Flow 需求保持。原 KP-R1 規劃路徑為 `flutter/internal/klp_flutter_block_note_editing.dart`、`flutter/internal/klp_block_note_web_session_loader.dart`、`flutter/internal/klp_flutter_workspace_components.dart`，以及新增 `flutter/internal/klp_block_note_flow_transport.dart`、`flutter/internal/klp_page_reference_drag.dart`。這是 module packet 輸入，非已派工授權。

責任：保留唯一 WebView attachment，協商 hostInstanceId；由 Krepis.acceptFlowMessage 驗證再回 typed receipt，consumer 回呼在 receipt 後執行；訂閱 operationChanges 而不覆寫 onChanged。JS 宿主重建或 blocked 時禁止普通 loader.open 自動覆蓋正文。原有 onOpened 與 asset/reference 流程依配對時序保留。

跨表面 drag 使用套件私有 carrier，保留 Explorer 原多選 move；只把有完整來源映射的單頁送到 database probe。viewport／scroll／zoom 換算與 drop hit test 由本層及 web 負責，consumer 不提供座標。drop 發送參考命令不觸發 onMove；鎖定／blocked 停止 drop 與預覽。

Krepis 的 blocked/error 是唯一操作狀態，平台異常沿既有 KlpEditingHostFailureSink 回報；renderer 不直接改 revision、不丟失原始 error/stack、不建立第二正文、theme 或 l10n。

獨立 test-owned paths：`test/klp_block_note_flow_host_test.dart`、`test/klp_page_reference_drop_test.dart`（repo 相對）；既有 loader／host failure 測試在直接變更風險涉及時回歸。新測試須涵蓋 receipt-before-callback、防重送、host replaced、dispose/late reply、source/target 身分、拖入不改 parent；原生 Windows WebView drag／IME 另驗，fake 不代替。

KP-R1 冷啟動估算 10k–20k tokens／1.5–3.5 小時，無可比較 task ID，沿用目前模型與本機 Dart/Flutter。M1 typed transport/observer/lifecycle（累計 4k–8k／40–80 分）；M2 drop/late reply/直接回歸與 scope（累計 10k–20k／1.5–3.5 小時）；超上限或要求跨白名單修改即回報。前置是 features/Krepis 宣告與正式 web protocol 可用，獨立 fixture 與 clean packet 基線已凍結。

FRAME-8-R1：本輪配對 [8px／微立體契約](../../../spec/frame-relief-8px.md)。app layout renderer 僅使用 features bound 的陰影色、亮邊色與尺度及 styling 具名配方；裝飾在內容 ClipRRect 外，不改 child bounds。flat 與 bare 保持既有繪製，Planist 僅透過公開 surface 選項選用。

Status: PLAN READY — v1 已接受 Flutter/WebView 實現、在地化相依反轉與功能已準備紀錄的接合邊界

阻擋中的架構決策：無。BUILD 仍依下列切片分開執行，並且必須保留渲染器生命週期檢查。

權威依據：[模組登錄表](../architecture.md)、[模組架構 v1 規格](../../../spec/module-architecture-v1.md)、[KLP-0019](../../../spec/decisions/KLP-0019-declarative-framework-migration.md)、[KLP-0020](../../../spec/decisions/KLP-0020-blocknote-editor-adoption.md)

## 目的

`rendering` 是 Kallopis 唯一的現行平台實現層。它接收不可變的已準備呈現紀錄、安裝 Flutter/WebView 宿主、將已解析的值轉換為平台基元，並掌管焦點、文字輸入、指標／鍵盤路由、無障礙語意，以及渲染器局部工作階段等暫態呈現機制。此模組位於 L6，在最終 application 組合根之下。

## 非目標

- 公開使用端組合、元件註冊或 application 路由。
- 產品實體、儲存庫、持久化或產品工作流程權威。
- 語意樣式選擇、備援 token 權責，或第二份主題／環境／在地化來源。
- 掌管 BlockNote/Canva 文件資料、選取、復原或儲存權威。
- 允許使用端注入 Widget、`BuildContext`、繪製器、渲染器回呼或平台工作階段。

## 目標階段與能力範圍

目前目標階段：讓 rendering 成為封閉本庫目錄的私有、完整平台實現，同時移除向上的 application 相依，以及對 foundation 功能專屬聯集變體的直接相依。

目前能力範圍：

- 單一渲染器實現通用結構紀錄與已核准的功能已準備紀錄。
- Flutter 焦點、文字輸入、指標、語意、保留介面與 WebView 宿主仍由渲染器掌管。
- 呈現在地化值透過 application 安裝的下層 foundation 契約傳入。
- 功能引擎透過其功能／runtime 契約維持權威；rendering 僅掌管平台宿主工作階段。
- 完整性依循本庫所屬目錄。不提供執行期外掛渲染器或使用端備援分支。

此能力範圍不授權另一個渲染器後端、動態渲染器探索，或使用端提供的原生內容。

## 所屬路徑與公開介面

所屬路徑：

- `flutter/internal/`：Flutter 實現、呈現工作階段、WebView 宿主、輸入橋接與渲染器局部值轉換。

公開介面：

- 無。`kallopis_declarative.dart`、`kallopis_foundation.dart` 與 `kallopis_experimental.dart` 不匯出 rendering 實作。
- Application 可在組合根建構套件私有渲染器。
- 功能已準備紀錄與通用已準備紀錄，只能透過所屬下層模組的具名套件內部契約進入 rendering。

即使 Dart 的匯入可達性在技術上允許存取路徑，rendering 局部的 Widget、繪製器、繼承式宿主、工作階段與視口輔助工具仍是實作細節。

## 責任分布與相依方向

| 區域 | 目標責任 | 允許的下層相依 | 目前矛盾 |
| --- | --- | --- | --- |
| 通用實現 | 完整地將通用已準備結構與已解析值轉換為 Flutter 基元。 | Kernel、capabilities、styling、foundation。 | 使用通用協定與 features 自有紀錄，保留原 26 型別完整分派。 |
| 功能實現 | 實現功能所屬的已準備紀錄，而不取得產品權威。 | 功能的套件內部已準備紀錄契約，以及已核准的引擎宿主契約。 | 功能變體由 features/editing、workspace 的 presentation library 宣告。 |
| 輸入與語意 | 掌管焦點、鍵盤、文字輸入、指標與無障礙的平台實現。 | Capabilities 與已準備的互動契約。 | 已使用具名 capabilities／foundation／styling 契約，完整跨模組 internal 閘門通過。 |
| WebView 宿主 | 掌管渲染器局部的 BlockNote/Canva 宿主工作階段與橋接生命週期。 | KLP-0020 接受的功能／引擎工作階段契約。 | 功能紀錄已歸 features；renderer 局部 session／錯誤轉送仍依 REND-V1-05。 |
| 在地化顯示 | 使用已選定的呈現字串／方向。 | Foundation 在地化契約。 | 使用 foundation/localization 唯一契約，無 application 相依。 |

Rendering 僅相依於 L0–L5 契約。Application 可建構 rendering。Rendering 不得匯入 application。

## 不變條件、生命週期與錯誤權責

- 每個已準備變體恰好有一個本庫所屬渲染器分支，或明確標示為非視覺；未知的使用端變體不能進入樹。
- Rendering 不解析語意 token，也不自行建立備援樣式。它只轉換 styling/foundation 已解析的值。
- 需要連續性時，Widget／工作階段身分以放置身分為索引。保留但非作用中的畫面，在保留核准狀態時，仍與指標、焦點及語意隔離。
- Flutter 文字輸入組字、焦點節點、控制器、WebView 控制器與訂閱，由所屬渲染器工作階段建立／釋放。
- BlockNote/Canva 的文件與儲存權威保留在上游。渲染器橋接失敗透過具型別的功能／runtime 結果回報；rendering 不會靜默替換引擎或建立第二個狀態來源。
- 同步平台實現契約違規會使影格交易失敗。非同步平台失敗須連同原始堆疊證據，送至 application 掌管的復原通道。

## 允許與禁止的相依

允許：

- 本模組內的 Flutter 與渲染器所需平台套件。
- Kernel、capabilities、styling、foundation 的公開或具名套件內部契約。
- 功能所屬的已準備紀錄契約，以及明確核准的 Krepis 橋接／工作階段契約。
- Application 從上層建構 rendering；這不允許反向匯入。

禁止：

- Application 實作或在地化路徑。
- Composition 登錄表、使用端定義或 runtime 編譯器控制流程。
- 產品模型、持久化、儲存庫或產品 l10n。
- 具名契約遷移完成後，直接匯入其他模組的 `internal/` 路徑。
- 寫死語意預設值、由渲染器掌管主題／環境／在地化來源，或使用端原生注入。

## 採用設計與否決方案

採用：以單一私有且完整的平台渲染器，處理封閉的通用與功能所屬已準備契約集合。功能呈現資料仍由功能掌管；平台工作階段仍由 rendering 掌管。

否決：可由使用端擴充的渲染器登錄表。這會讓 Widget／原生程式碼成為第二個元件來源，並繞過插槽、樣式、生命週期與無障礙契約。

否決：為了方便分支處理，將每個已準備變體都留在 foundation。這會迫使 foundation 匯入功能與外部引擎，反轉相依方向，並讓通用層掌管功能語意。

否決：讓 rendering 直接讀取 application 在地化。呈現字串屬於下層契約；application 負責選擇／安裝，但不能成為其渲染器的相依。

## 目前階段切片

| 切片 | 產出 | 允許路徑 | 公開／跨模組契約 | 驗收證據 | 狀態 |
| --- | --- | --- | --- | --- | --- |
| `REND-V1-01` | 建立此契約並清點平台實現責任。 | `lib/src/rendering/architecture.md`、登錄表狀態 | 無。 | 已記錄匯入、渲染器分支、平台套件及向上的在地化相依邊。 | complete（完成） |
| `REND-V1-02` | 透過 foundation 使用在地化，並移除 application 匯入。 | `flutter/internal/klp_flutter_editing.dart` 與在地化接線 | Foundation 掌管呈現在地化；application 安裝它。 | Rendering 匯入圖沒有 application 相依邊，且在地化編輯行為維持確定性。 | complete（L10N-V1-r2 已整合） |
| `REND-V1-03` | 從功能所屬的套件內部契約使用功能專屬已準備紀錄。 | 渲染器分支與功能實現檔案 | Foundation 通用已準備紀錄協定，加上功能已準備紀錄契約。 | Foundation 沒有功能／引擎匯入；渲染器仍完整涵蓋封閉目錄。 | complete（PRES-V1-r1 已整合） |
| `REND-V1-04` | 以具名契約取代跨模組的 `internal` capabilities/foundation 匯入。 | Rendering 匯入與下層契約路徑 | Capabilities/foundation 發布套件內部契約路徑。 | 架構閘門回報沒有不允許的跨模組內部匯入。 | complete（LOWER-V1-r1 已整合） |
| `REND-V1-05` | 整合文字輸入與 WebView 宿主的渲染器局部工作階段權責及錯誤轉送。 | `flutter/internal/` 工作階段／宿主檔案 | Feature/runtime 定義具型別宿主結果；application 掌管復原。 | 確定性的生命週期／錯誤檢查證明每個工作階段只有一個所屬者與一條釋放路徑。 | complete（REND-HOST-V1-r1 已整合） |

`REND-V1-02` 的冷啟動估算：5,000–10,000 模型 token、45–100 分鐘。目前沒有可比較的已定案任務登錄項目。里程碑：下層在地化契約、匯入遷移與在地化行為證據。超過 18,000 token 或 150 分鐘時，必須進行異常檢查點。

Explorer 與共享命令呈現依 [EXP-V1-r2](../../../docs/architecture/explorer-v1-plan/README.md)，由各自 internal renderer 維護。

### 通用與功能呈現配對（PRES-V1-r1）

已接受 [配對規格](../../../docs/architecture/presentation-module-plan/README.md) 與精確路徑。PRES-V1-r1：KlpBoundTemplate 原名／constructor 保留，路徑由 LOWER-V1-r1 具名契約接替，改為不對 consumer 匯出的 abstract class 協定。11 個通用 part 留 foundation；15 editing part 與 editing style、15 workspace part 各移至 features 自有 presentation library，不跨模組 part，不由 foundation reexport。兩個 feature library 都只作唯讀呈現資料，保留上游 controller／engine／callback 身分與生命週期，不新增權威。renderer 保留原 26 concrete 類型的分支與非視覺標記，未知套件內實作明確拋 KlpContractError('unsupported_prepared_template', ...)；不提供註冊或 fallback。另將 button style 與 toolbar 三檔實體移至 features/actions；KlpSelectionAction 留 foundation，filter bar 移除 toolbar export，僅 root kallopis_foundation.dart 直接 export 新 toolbar 以保留 Stable。所有舊移動路徑刪除而不設 shim；公開符號／constructor／範本／catalog 28 ID 順序與效果不變。FND-V1-03 全 foundation 無 features/runtime/rendering/application 或 Krepis/Canva/BlockNote import/export/part 的原要求不得縮小。

### 唯一呈現在地化配對（L10N-V1-r1）

已接受 [配對規格](../../../docs/architecture/localization-module-plan/README.md)。L10N-V1-r1：三個既有 application/localization 檔案作為同一 library 實體搬至 foundation/localization；保留型別、constructor、全部預設字串、savedLabel 私有函式、delegate load/shouldReload/isSupported、fallback 與 equality。這仍是既有 Flutter 呈現契約，不另建純 Dart 模型或第二來源。12 個 features 指令（含1 export）及1個 rendering import 精確向下遷移，全部 features/rendering 不得再依賴 application（含相對／條件／export／公開 barrel 旁路）；無其他host前置。application legacy只更新URI並保留consumer delegates在前的順序；宣告式 KlpApplication 的 WidgetsApp 必須安裝 const KlpLocalizationsDelegate()，不新增locale/override/public API。Stable kallopis_foundation.dart 只改export來源，其他公開符號/可達性/畫面字串/預設環境不變；舊src路徑刪除無shim。

## 驗收證據與測試狀態

L10N-V1-r2 已整合：179 項保護測試通過，包含全 features/rendering 無 application 相依、唯一字串來源、defaults／delegate／fallback／Stable 相容與宿主實際安裝。七段既有 BlockNote 錯誤原文已補入同一 l10n；原70字串保留。既有 host 六案例與保留已掛載編輯器測試亦通過；App 舊基線過期參數由獨立作者移除，discipline 只修註解誤判並保留原閘門。見 [本批驗證](../../../docs/architecture/localization-module-plan/verification.md)。


PRES-V1-r1 已整合：105 項保護測試及 16 項實際 renderer／filter／catalog／import-root 測試通過，35 個搬移實作與直接呼叫正文等價。全 foundation 無上層／引擎指令；26 個渲染型別保留，未知型別明確拒絕。Stable toolbar 名稱與身分相容。詳見 [本批驗證](../../../docs/architecture/presentation-module-plan/verification.md)。


2026-09-14 觀察結果：

- Rendering 包含 34 個 Dart 檔案，全數位於 Flutter 實作區。
- 十個檔案匯入 capabilities、二十二個匯入 foundation、五個匯入 styling、三個匯入 features，恰好一個匯入 application。
- 原 application 在地化相依已移除；完整 rendering 相依檢查通過。
- `KlpFlutterRenderer` 完整地對通用及功能專屬 `KlpBoundTemplate` 變體進行分支處理；功能／引擎變體已由 features 擁有，foundation 保留通用協定。
- 平台套件包含 Flutter、`flutter_inappwebview`、`flutter_svg`、`krepis_block_note` 與 `krepis_canva`。
- `kallopis_declarative.dart` 不匯出任何 rendering 檔案。

測試狀態：

- Green 範圍：PRES-V1-r1 的直接渲染、安裝／session、完整性與未知型別拒絕已驗證，詳見本批紀錄。
- Yellow 範圍：已直接檢查匯入、平台相依、渲染器變體與公開匯出。
- Red 範圍：無。
- 視覺證據：依儲存庫測試政策，golden 圖像不作為驗收證據；確定性的幾何、語意、輸入、生命週期與錯誤檢查仍可作為證據。

## 受保護路徑

- `lib/src/rendering/architecture.md`
- 渲染器放置／生命週期、文字輸入、焦點、語意、保留堆疊與 WebView 橋接檢查。
- 防止 rendering 匯出及使用端原生輸入的公開邊界檢查。
- 確定性的渲染器幾何、語意、輸入、生命週期與錯誤檢查；golden 測試／基準已退役，產品 BUILD 執行者不得重新建立並列為必要證據。

### L10N-V1-r2 有證據修復

L10N-V1-r2 修復已重現的舊 discipline 失敗：BlockNote 兩個 renderer 檔的七段原始使用者文案納入既有 KlpLocalizations，七個可選 String constructor 欄位及對應 final 欄位預設完全沿用原文，加入 equality/hashCode 使覆寫可觸發delegate reload。這是相容的既有字串契約補齊，接替 r1「不加 public API」在這七個可選欄位的限制；其餘70既有字串、constructor用法、預設畫面、重試與中斷／WebView生命週期不變，不建第二來源。renderer的錯誤Widget只由 KlpLocalizations.of(context) 取字串，不改branch/controller/callback。獨立作者修 discipline scanner 的註解誤判：兩個 metric card 的單引號箭頭範例是註解而非 literal，必須加入synthetic正負控制，只忽略comments、不忽略真字串，保留Chinese零及icon上限15和下限13，不增加豁免。

### 具名下層契約配對（LOWER-V1-r1）

LOWER-V1-r1：CAP-V1-02 與 REND-V1-04 配對，71 個既有檔案實體移至具名路徑；全部名稱、constructor、預設值、演算法、狀態與 callback 身分不變。Provider 42 個 editing export 與 9 個 part 移至 editing/contracts，根入口原 44 個 export 的符號可達性不變。draw_command_validation 留 internal，不新增公開；block_drop_preview 仍非公開，drop_target 與 editing_submission 為 editing/ 下具名套件內入口，保留整體演算法及狀態。Foundation 15 個通用 binding 檔案含 11 part 移至 binding/contracts，維持同 library、abstract KlpBoundTemplate 與非 consumer 公開協定；此條明確接替 PRES-V1-r1 的「路徑保留」，其名稱、constructor、模組責任與原行為仍保留。Styling 的 paper_shadow_recipe 與 control_density 移至各自具名入口，值與唯一來源不變。所有直接呼叫端與測試 URI 配對更新，不留 shim、不新增 export。完整 rendering 的 import/export/part/part-of/conditional 指令不得跨到任何其他模組 internal；不能只檢查 capabilities/foundation。維持 26 renderer 分支、28 catalog ID、未知類型拒絕、同模組 reciprocal part、Stable 與 provider 可達性。編輯 pending/resync、save job/confirmed revision、手寫生命週期與上游正文／undo 權威不變。CAP-V1-03 舊正文分類、FND-V1-05 metrics、host 與剩餘 APP-V1-06 不藉此宣告完成。

精確本模組範圍與派工條件見 [配對計畫](../../../docs/architecture/lower-contract-plan/README.md)。LOWER-V1-r1 已整合：71 個原始檔實體搬移與 57 個直接 caller（共 128 個來源）正文／指令身分等價；7 個 module scope、局部分析與獨立整合測試通過。Provider 公開身分不變，完整 renderer 無不允許的跨模組 internal 指令。見 [驗證](../../../docs/architecture/lower-contract-plan/verification.md)。

### Application具名契約收尾（APP-CONTRACT-V1-r1）

APP-CONTRACT-V1-r1：APP-V1-06 剩餘完整 application foreign-internal 邊以25個既有來源實體歸具名路徑收尾。Kernel三個lifecycle來源、capabilities導航machine/兩exception及五part、composition scope boundary、十一features adapters、rendering renderer/viewport入口依精確map搬移。Renderer沒有parts；其餘平台實作保留同模組internal，具名入口的正常implementation imports不是consumer公開或跨模組穿透。Navigation五part隨原owner同library移動，狀態機／transaction／commit／lease／錯誤／回收body與callback身分不變。不得以轉匯出barrel遮住其他模組internal，不留舊shim；所有root公開library export指令與順序保持，25來源仍不公開。所有directcallers與36個catalog metadata字串同步原ID/factory/variant/順序，只替換路徑。features67exports／24component、application28ID保持。四個原未附文件的adapter只新增精確用途dartdoc以維持token baseline45，其餘非directive正文僅准行首tab正規化；去除這四新增註解後正文等價。不在這批實作R1/R2 lifecycle、filepicker或環境；後續使用新的rendering具名入口。

精確本模組範圍與派工條件見 [配對計畫](../../../docs/architecture/application-contract-plan/README.md)。APP-CONTRACT-V1-r1 已整合，七模組 scope、原行為、獨立 application 邊界與目錄檢查通過；見 [驗證](../../../docs/architecture/application-contract-plan/verification.md)。

### Renderer host 配對契約（REND-HOST-V1-r1）

REND-HOST-V1-r1 接受 REND-V1-05 的兩個實作里程碑。R1：features 純 Dart typed failure 經既有 viewport sink 由 application 安裝，原始 error/stack 與 origin/phase 送既有 recovery；renderer local input/binding 以捕捉身分且冪等的 detach 在所有 interrupt 結果後 finally 釋放。R2：兩 WebView 使用 controller identity key 與固定 attachment，依上游既有 bind 排他規則只解除自己成功取得的 sender；每個 await 後檢驗存活。BlockNote 開啟成功立即標記，後續 flush/callback 失敗不得重播初始文件；Canva 去重且不新增自動重試或 UI。環境 late result/dispose 只有一次清理及回報。借用的 provider/controller 不 close/save，不新增正文、theme、environment、l10n 或全域 registry 權威。細部已接受 API、失敗歸屬與驗收由同版 path-map 決策定義。R1 只代表部分完成，R1/R2 與整合證據全部通過才完成 REND-V1-05。

具體 API 與本模組寫入路徑见 [配對計畫](../../../docs/architecture/rendering-host-plan/README.md)。REND-HOST-V1-r1 已整合，文字與 WebView 的真實生命週期、原行為、公開／模組邊界及 scope 已通過，見 [驗證](../../../docs/architecture/rendering-host-plan/verification.md)。

## CM-02 短期切片：子選單展開與返回

PLAN READY。依 spec/menu-interaction-migration.md 的 MENU-03/05/06，這次只完成既有面板內的層級導覽；彈出與外部點擊關閉仍待下一短期切片。

features：KlpMenuItem 增加不可變 children 清單；非空 children 是子選單，不能同時配置 onPressed。保留舊 hasSubmenu 指示用法至呼叫端遷移，但新 Catalog 使用 children。整棵項目樹 id 唯一，adapter 遞迴套用 lease。renderer：同面板呈現目前層，標头沿用既有樣式並提供返回，點擊／Enter／Space 進入，向右進入、向左返回；Escape 仍呼叫根 onEscape。返回恢復父項高亮；資料更新只保留仍存在且 enabled 的路徑，無效部分截斷。consumer 不管理此暫時路徑，selected/toggle 仍由 consumer 控制。

寫入配對：features 的 overlays/declarative/klp_menu_item.dart、klp_menu.dart、klp_menu_adapter.dart；rendering 的 flutter/internal/klp_flutter_menu_panel.dart；Catalog 的 example/lib/catalog_declarative/menu_specimen.dart。其他來源唯讀，test/klp_declarative_submenu_test.dart 由獨立 Test Author 維護。不修改 primitive、已接受元件外觀或固定254分母。驗收為真實 Catalog 導覽、停用及新資料撤銷巢狀 callback；視覺人類待驗。

估算：冷啟動 4k–9k tokens／15–35 分鐘，同一模型、本機 Flutter；M1 資料與導覽（20 分鐘），M2 局部測試與展示（35 分鐘），超過上限記錄原因。

選單間距補充（使用者要求）：相鄰項目使用獨立 itemGap distance semantic，i1 基準為4px，features 準備 bound itemGap，renderer 僅在沒有分隔線的相鄰項目插入此空隙。根與子選單一致；有分隔線時沿用其上下留白。

## CM-03 短期切片：選單彈出與關閉

PLAN READY。KlpMenu 新增可選 triggerLabel：未提供時保持獨立面板，提供非空標籤時由庫呈現開啟入口並管理浮層，不暴露 Widget／位置／style。features 將 triggerLabel 傳入 bound，空白拒絕。renderer 使用同一面板與 OverlayPortal，入口沿用選單列語意風格；點擊或 Enter／Space／向下鍵開啟，初始焦點進入選單。依入口位置優先下方，放不下時改上方或限制於 viewport，長內容可捲動；視窗變動重新定位。外部點擊只關閉不穿透、不執行動作；Escape 關閉並通知既有 onEscape；有效葉項啟用後關閉，子選單父項只導覽，disabled 不關閉。關閉恢復入口焦點，移除節點由 portal 釋放浮層。舊事件不可重新打開或提交過期內容。4px itemGap 保持。

寫入：features/overlays/declarative/klp_menu.dart、klp_bound_menu.dart、klp_menu_adapter.dart；rendering/flutter/internal/klp_flutter_menu_panel.dart、rendering/flutter/klp_flutter_renderer.dart；example/lib/catalog_declarative/menu_specimen.dart。不改其他元件外觀或舊 workspace menu bridge；後者仍須另外接線。獨立測試路徑 test/klp_declarative_menu_popup_test.dart，保護事件與浮層生命週期。M1 資料與浮層（15分鐘），M2 測試與展示（30分鐘）；冷啟動估算5k–10k tokens／15–30分鐘。視覺人類待驗。
