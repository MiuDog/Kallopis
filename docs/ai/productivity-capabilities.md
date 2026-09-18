# 生產力 App 能力清冊

狀態：`PE-B1` 基線。此頁記錄目前工作樹的 consumer 能力與缺口，不代表所有列出的能力已交付，也不取代個別功能契約、Catalog 或固定遷移清冊。

Kallopis 的完整能力地平線涵蓋所有產品無關的生產力 App 相關能力。筆記、圖表、規劃視圖、畫布、繪圖、手寫及溝通協作都是預期覆蓋範圍；可以分階段交付，但不因規模較大或較專門而永久排除。固定 254 項舊 Catalog 是目前已知基線，不是能力上限。

## 如何使用這份清冊

先依 consumer 目前的開發階段找能力，再沿能力 ID 查看狀態、公開入口、證據與缺口。

| 階段 | 目前要解決的問題 | 能力標記 |
| --- | --- | --- |
| S1 視覺組成 | 選擇 layout、容器、feature shell、合法 slot，以及空白／占位狀態。 | `S1` |
| S2 產品資料模型 | 在 consumer 端定義 entity、狀態、規則與資料來源，不讓 Klp 呈現型別成為產品權威。 | `S2` |
| S3 資料與互動接線 | 將產品資料投影成不可變 Klp data，接上 action／callback，更新產品後重新提交 application declaration。 | `S3` |
| S4 動畫與體驗優化 | 使用 Kallopis 提供的回饋、轉場、鍵盤、焦點、無障礙及 adaptive 能力。 | `S4` |

第一階段的「注入版面」只表示將公開 Klp 節點放入合法 slot，不包含 Widget、builder、`BuildContext`、renderer、painter 或局部 style。第四階段同樣不允許 consumer 傳入任意 animation、duration 或 curve；缺少的通用體驗能力必須回到 Kallopis 補齊。

## 狀態判準

| 狀態 | 可作出的結論 |
| --- | --- |
| `supported` | 同時具有新版公開宣告、資料／事件、合法組裝、唯一語意風格及可操作 Catalog。 |
| `partial` | 已有新版公開入口，但完整行為、平台、Catalog 或其他必要證據尚未齊全。 |
| `unverified` | 來源不足或互相矛盾，尚不能判斷是否支援。 |
| `unsupported` | 已核對現行公開面與契約，確定沒有可完成該意圖的新版能力。 |
| `legacy` | 只有舊 Flutter／相容入口；新 consumer 不得採用。 |
| `deferred` | 只用於不屬目前生產力能力地平線或另有明確產品決策的項目；不能用來擱置筆記、圖表、手寫等已接受領域。 |

找不到證據時使用 `unverified`，不是 `unsupported`。找到 class、adapter、舊 Widget 或靜態 specimen，也不能直接標為 `supported`。

## 證據基線

本清冊依下列現行來源判讀：

1. [`kallopis_declarative.dart`](../../lib/kallopis_declarative.dart)：新 consumer 的實際公開入口。
2. [feature ownership manifest](../../lib/src/features/catalog/component-ownership.json) 與 [application catalog](../../lib/src/application/bootstrap/internal/klp_application_catalog.json)：definition、owner、資格、slot 與 adapter 配對。
3. 本目錄的直接功能契約，以及其連結的可操作 Catalog／驗證紀錄。
4. [固定遷移 coverage](../architecture/catalog-migration/coverage.json) 與[人類可讀 inventory](../architecture/catalog-migration/inventory.md)：舊 Catalog 的固定分母與遷移狀態。

目前觀察值：

| 證據 | 數量／狀態 | 判讀限制 |
| --- | --- | --- |
| feature definitions | 26：24 public、2 internal | 只涵蓋目前 declarative feature manifest，不是完整地平線。 |
| structural components | 4：`KlpScreen`、`KlpAdaptive` public；scope boundary、retained screens internal | internal 元件不得出現在 consumer 用法。 |
| feature-related exports | 88 | data、event、qualification、re-export 與 node 混合，不能把 export 數量當元件數。 |
| 固定舊 Catalog | 254：2 migrated、1 preserved、251 pending；`complete=false` | 遷移狀態不等於完整能力狀態，也不是未來能力上限。 |

## 現行公開宣告式能力

下表完整覆蓋目前 manifest 的 24 個 public feature definition，以及 application catalog 的兩個 public structural component。由同一 definition 擁有的資料型別、事件、qualification 或公開變體沿用同一能力 ID，不另冒充獨立可渲染能力。

| 能力 ID | 使用者意圖 | 階段 | 目前公開入口／definition | 狀態 | 直接證據與限制 | 下一 owner |
| --- | --- | --- | --- | --- | --- | --- |
| APP-ROOT | 啟動 application 並建立可存取的 screen 結構。 | S1–S3 | `KlpApplication`、`KlpScreen` | `partial` | [組裝模板](composition-templates.md)有公開入口與更新方式；`KlpScreen` 已登錄。完整生產流程與 Catalog 證據仍由後續 reference flow 彙整。 | application |
| APP-NAV | 以 typed destination、route、guard、返回值與還原資料導覽。 | S2–S3 | `KlpRouter`、`KlpDestination`、`KlpRoute`、`KlpAction` | `partial` | [系統索引](systems.md#navigation-system)明示 typed 導覽可用，但瀏覽器 history 與完整 stack URL 尚未交付。 | capabilities／application |
| APP-STATE | 保存 consumer 資料權威並重新提交宣告。 | S2–S3 | `KlpState`、`KlpMutableState`、`KlpAsyncData`、`KlpStateController` | `partial` | [系統索引](systems.md#state-and-data-system)提供基礎契約；各 feature 的完整 loading／failure 呈現尚未普遍接入。 | capabilities |
| APP-ADAPT | 依受控平台與 viewport 策略選擇宣告樹。 | S1、S4 | `KlpAdaptive`／`kallopis.adaptive` | `partial` | [Adaptive 指南](adaptive-platform-strategies.md)存在，definition 已登錄；完整平台矩陣與跨領域 Catalog 證據不足。 | composition／foundation |
| LAY-WORKSPACE | 組合工作區行列、pane、resize handle、spacer 與 frame。 | S1、S4 | `KlpAppLayout`、`LayoutRow`、`LayoutColumn`、`KlpLayoutPane`、`LayoutResizeHandle`、`LayoutSpacer`、`KlpAppFrame` | `partial` | 7 個 public definitions 均已登錄；部分視覺已在工作區展示，但固定 legacy coverage 尚未完成，不能整組標 supported。 | features/workspace |
| LAY-GROUPS | 在 frame 內組合具內容與 footer 的功能群組。 | S1、S3 | `KlpFrameGroups`、`KlpFrameGroup` | `partial` | 兩個 public definitions 與受限 slots 已登錄；仍需逐情境組裝與 Catalog 證據。 | features/workspace |
| WKS-EXPLORER | 顯示階層資料，處理展開、選取、命令與受限拖放。 | S1–S4 | `KlpExplorer`／`kallopis.explorer` | `supported` | [Explorer 契約](explorer-model.md)包含資料、事件、組裝與限制；[Catalog](explorer-catalog.md)及固定 coverage 的 `preserved` 狀態提供操作與遷移證據。 | features/workspace |
| WKS-TABS | 呈現文件分頁、選取、關閉意圖與 dirty 狀態。 | S1、S3–S4 | `KlpDocumentTabs`、`KlpDocumentTab` | `partial` | 兩個 public definitions 已登錄；產品仍擁有保存、刪除、重排及 retained state，完整 Catalog 接受未在固定 coverage 完成。 | features/workspace |
| WKS-WINDOW | 顯示視窗控制並發出 host 意圖。 | S1、S3–S4 | `KlpWindowControls` | `partial` | public definition 與 host callbacks 已存在；[系統索引](systems.md#legacy-compatibility-system)明示所有 OS backend 尚未驗證。 | features/workspace／application |
| WKS-BLOCKS | 呈現通用工作區 action、content、choice、item 與 material。 | S1–S4 | `KlpWorkspaceBlock`、`KlpWorkspaceContent`、`KlpWorkspaceContentBlock` | `partial` | 三個 public definitions 已登錄；[工作區元件](workspace-components.md)列出資料責任，但多種 kind 仍需各自的合法位置及視覺證據。 | features/workspace |
| OVR-MENU | 顯示選單、子選單、鍵盤導覽、關閉與項目事件。 | S1、S3–S4 | `KlpMenu`／`kallopis.menu` | `supported` | [Menu 契約](menu-model.md)具有宣告、組裝、更新、失敗行為、Catalog 與測試；固定 coverage 的 `KlpMenu`、`KlpMenuItem` 均為 `migrated`。 | features/overlays |
| OVR-ANCHORED | 以受控 anchor 開關 popup，處理項目與 anchor 生命週期。 | S1、S3–S4 | `KlpAnchoredPopup` | `partial` | [Anchored popup 指南](anchored-popup-model.md)與交付證據存在；固定 254 coverage 尚未提供對應完成狀態，維持 partial。 | features/workspace／rendering |
| EDT-SHELL | 承載編輯內容、區塊控制、定位命令與模式工具。 | S1–S4 | `KlpEditingContent`、`KlpBlockControls`、`KlpAnchoredCommands`、`KlpModeToolbar` | `partial` | 四個 public definitions 已登錄；[編輯系統](editor.md)明示平台輸入、可見入口、完整操作與無障礙仍未完成。 | features/editing |
| EDT-NOTE | 透過 Krepis／BlockNote 承載版本化正文與保存生命週期。 | S1–S4 | `KlpBlockNoteEditingContent` | `partial` | [BlockNote 指南](blocknote-editor.md)為實驗能力；頁面連結、表格資料庫、typed drag 等已規劃但尚未實作發布。 | features/editing／Krepis contract |
| EDT-CANVAS-HOST | 承載 Canva 類型的外部編輯工作階段。 | S1–S4 | `KlpCanvaEditingContent` | `partial` | public definition 與 Krepis Canva re-export 已存在；它只證明 host 能力，不等於完整通用畫布、繪圖或手寫生態。 | features/editing／Krepis contract |

manifest 的兩個 internal feature definitions `kallopis.explorer.entry`、`kallopis.rail`，以及 application catalog 的 internal scope boundary、retained screens，刻意不列為 consumer 能力。尤其 `KlpRail` 不得因 adapter 已存在而出現在新 consumer 範例。

## 完整生產力能力地平線與缺口

下表從使用者意圖出發，包含目前尚未形成 public definition 的能力。狀態描述的是「新 consumer 能否以現行 Klp 合法完成」，不是舊程式碼是否存在。

| 能力 ID | 領域與意圖 | 階段 | 目前狀態 | 已知證據／缺口 | 下一 owner |
| --- | --- | --- | --- | --- | --- |
| ACT-CONTROLS | 按鈕、icon action、action group、bulk action、selection toolbar、快捷提示與 command menu。 | S1、S3–S4 | `legacy` | 固定清冊含 actions／interaction 元件；新版只有 menu、workspace action 與語意 action 的局部能力，沒有完整控制族群。 | features/actions |
| NAV-SHELL | rail、breadcrumb、tabs、drawer、sidebar、search navigation 與 retained navigation surface。 | S1、S3–S4 | `partial` | typed navigation 與部分 workspace 元件已公開；`KlpRail` 仍 internal，多數 navigation widgets 保持 legacy。 | features/navigation／application |
| DATA-COLLECTIONS | list、tree、table、grid、key-value、JSON、card、preview、pagination、filter 與 sort。 | S1–S4 | `legacy` | Explorer 與 workspace item 提供部分集合能力；通用 collections 仍主要位於固定舊清冊，未形成完整 declarative 入口。 | features/collections |
| FORM-INPUT | text、number、password、date、file、code、reference、repeater、picker 與 compound field。 | S1–S4 | `legacy` | 固定清冊有 48 個 forms 項目；[AI 入口](README.md)明示表單尚未有可用 renderer，新 consumer 不得生成表單用法。 | features/forms |
| FORM-SELECTION | checkbox、radio、select、multi-select、toggle、segmented control、slider、tag input 與 color role。 | S1–S4 | `legacy` | 舊控制存在但未完成 declarative renderer、狀態與組裝證據。 | features/forms／interaction |
| FEEDBACK-STATES | loading、empty、error、permission、inline notice、toast、progress、status、live region 與 workflow state。 | S1、S3–S4 | `legacy` | capabilities 有 async data，但可見 feedback 族群仍主要在固定舊清冊；不能以資料狀態推定 UI 已交付。 | features/feedback |
| OVERLAY-SURFACES | dialog、popover、context menu、tooltip、modal、drawer、overlay host 與 popup surface。 | S1、S3–S4 | `partial` | Menu 與 anchored popup 已有新版能力；其他 overlay surface 多數仍是 legacy 或未驗證。 | features/overlays |
| NOTE-CONTENT | 純文字、rich text、code、attachment、reference、正文 section、document chrome、保存與重開。 | S1–S4 | `partial` | BlockNote host、editing provider 與保存契約已存在；完整筆記操作、附件／引用及跨平台驗收尚未齊全。 | features/editing／capabilities |
| VIS-CHARTS | 基礎與進階圖表、metric、legend、axis、tooltip、selection、zoom 及資料視覺化無障礙。 | S1–S4 | `unsupported` | 現行 declarative export 沒有 chart node；舊分類曾移出 dashboard charts。新的完整地平線已重新納入此領域，但尚無公開契約。 | features/data-visualization／styling |
| PLAN-VIEWS | calendar、schedule、timeline、task list、board、stepper 與 workflow planning。 | S1–S4 | `legacy` | 固定清冊含 Calendar、ScheduleList、Timeline、TaskList、Stepper 等，但沒有完整新版宣告、組裝與 Catalog 證據。 | features/collections／planning |
| CANVAS-DRAWING | 無限畫布、viewport、node、selection、minimap、toolbar、drop、drawing 與 diagram。 | S1–S4 | `partial` | 固定清冊含 8 個 infinite-canvas 元件，另有 `KlpCanvaEditingContent` host；通用 canvas 元件與資料／事件契約仍未接入新版公開面。 | features/canvas／editing |
| HANDWRITING | 筆劃取樣、暫態預覽、工具、落筆目標、發布、中斷與跨平台輸入。 | S2–S4 | `unsupported` | [手寫狀態指南](handwriting-state.md)只有實驗性資料協定；正式目標解析、平台取樣、預覽 renderer 與工具尚未接入，無法完成 consumer 手寫流程。 | capabilities/editing／features/handwriting／rendering |
| COMM-COLLAB | message、composer、thread、presence、comment、mention、多人狀態與協作回饋。 | S1–S4 | `legacy` | 固定清冊含 message 與 presence 元件；沒有完整 declarative collaboration contract。產品 session、權限與同步仍由 consumer 擁有。 | features/collaboration |
| FILE-ASSET | file picker、dropzone、preview、Explorer、attachment、asset resolution 與失敗回饋。 | S1–S4 | `partial` | Explorer、file-selection action、BlockNote asset resolution 提供局部能力；通用 field、dropzone 與完整 platform matrix 尚未完成。 | capabilities/files／features/forms／editing |
| SEARCH-FILTER | 搜尋輸入、候選、篩選、排序、命令查找與結果導覽。 | S1–S4 | `legacy` | command、Explorer 與舊 search/filter 控制各有局部能力，尚無一致的新版資料、事件與組裝契約。 | features/actions／collections |
| ACCESS-INPUT | keyboard、focus、semantics、screen reader、IME、pointer、drag/drop 與 hit target。 | S3–S4 | `partial` | 現行 screen、Explorer、Menu、editing 等各有局部證據；缺少跨所有能力領域的一致完成矩陣。 | foundation／rendering／各 feature owner |
| ADAPT-PLATFORM | 窄寬布局、device class、orientation、display mode、window host、environment 與平台差異。 | S1、S4 | `partial` | `KlpAdaptive`、平台值與部分 host 能力已公開；完整元件與 OS 組合尚未驗證。 | composition／foundation／application |
| STYLE-EXPERIENCE | semantic style、互動狀態、動畫、轉場、密度、可讀性與品牌 primitive。 | S1、S4 | `partial` | primitive set 與 semantic resolver 已存在；consumer 不得傳局部值。大量 legacy 元件尚未遷移，動畫與體驗能力也沒有完整 public catalog。 | styling／foundation／rendering |

目前沒有任何產品無關的生產力能力因「太專門」而標為 `deferred`。真正產品專用的商業資料、功能選用、排列順序、權限策略與持久化流程仍不屬 Kallopis。

## 固定 254 項舊 Catalog 對照

[固定 baseline](../architecture/catalog-migration/legacy-baseline.json) 的 254 個 component 目前依舊來源分布如下。每個名稱的能力 ID、consumer 階段、coverage、預定處置、來源與下一 owner 已列於[固定 Catalog 逐項能力轉接](catalog-capability-map.md)；機械遷移狀態仍只由 [coverage](../architecture/catalog-migration/coverage.json) 擁有。

| 舊來源區域 | 數量 | 對應完整地平線 |
| --- | ---: | --- |
| workspace | 55 | workspace、document、editing、window、collaboration |
| forms | 48 | form input、selection、validation、file／reference |
| collections | 28 | list、tree、table、card、planning、message |
| layout | 28 | workspace layout、container、adaptive composition |
| navigation | 21 | application navigation、rail、sidebar、tabs、search |
| interaction | 16 | action、selection、keyboard、focus、drag/drop |
| feedback | 15 | loading、empty、error、toast、status、progress、workflow |
| overlays | 11 | menu、dialog、popover、tooltip、modal |
| surface | 9 | frame、surface、divider、scroll、background |
| infinite_canvas | 8 | canvas、node、selection、minimap、toolbar、drop |
| actions | 7 | button、icon action、command、bulk action |
| content | 2 | rich text 與一般內容呈現 |
| foundation／legacy 單項來源 | 6 | icon、inline code、spinner、segmented progress、legacy app／theme |
| **合計** | **254** | 固定分母；不是完整能力上限 |

目前 coverage 必須保持：`migrated=2`、`preserved=1`、`pending=251`、`complete=false`。本清冊與逐項轉接不修改 baseline 或 coverage，也不因重新分類、合併或取代而縮小分母。

## 缺口交接

下列 gap 是後續 module PLAN 的入口，不是本輪 BUILD 授權：

| Gap ID | 缺口 | 主要 owner | 進入後續 PLAN 前的必要輸入 |
| --- | --- | --- | --- |
| GAP-ACTIONS | 完整 declarative action／control 家族。 | features/actions | 各控制的用途、資料、事件、狀態、合法位置與無障礙行為。 |
| GAP-NAV | 完整 shell navigation、rail、sidebar、breadcrumb 與 retained surface。 | features/navigation／application | 導覽與呈現責任分離、route ownership、slot 與窄寬策略。 |
| GAP-DATA | 通用 collections、table、grid、filter、sort、pagination。 | features/collections | 資料規模、selection、virtualization、editing 與空／錯誤狀態。 |
| GAP-FORMS | 完整 form、field、validation、submission 與 selection controls。 | features/forms | 欄位值權威、驗證時機、錯誤摘要、提交與焦點契約。 |
| GAP-FEEDBACK | 通用 loading／empty／error／permission／toast／progress。 | features/feedback | view-state ownership、announcement、retry、dismiss 與 stacking。 |
| GAP-OVERLAYS | Menu 以外的 dialog／popover／tooltip／modal／drawer。 | features/overlays | anchor、focus trap、dismiss、結果、viewport 與生命週期。 |
| GAP-NOTES | 完整筆記內容、引用、附件、保存、重開及平台輸入。 | features/editing／capabilities | KLP-0020 權威、Krepis contract、host events 與 failure behavior。 |
| GAP-CHARTS | 圖表與資料視覺化元件生態。 | features/data-visualization／styling | chart grammar、資料／selection、responsive、accessibility 與 semantic palette。 |
| GAP-PLANNING | calendar、schedule、timeline、task、board 與 workflow views。 | features/collections／planning | 時間／分組模型、操作事件、virtualization、drag/drop 與狀態。 |
| GAP-CANVAS | 通用 canvas、diagram、drawing 與 spatial interaction。 | features/canvas／editing | viewport、selection、transform、tool、undo、drop 與 persistence ownership。 |
| GAP-HANDWRITING | 正式手寫輸入、preview、tool 與 stroke publication。 | capabilities/editing／features/handwriting／rendering | 取樣、anchor、pressure、interruption、platform channel 與 visual acceptance。 |
| GAP-COLLAB | message、comment、presence、mention 與協作狀態呈現。 | features/collaboration | session／identity／permission 留在產品；Klp 只定義產品無關資料、事件與呈現。 |
| GAP-CROSSCUT | 跨能力 keyboard、focus、semantics、adaptive、animation 與 platform matrix。 | foundation／rendering／各 feature owner | 每項能力的 deterministic interaction evidence 與人類體驗接受範圍。 |

後續 owner 必須從使用者意圖與產品無關契約開始，不能直接把 legacy Widget 包裝成新版節點，也不能透過 reference 文件宣稱尚未交付的能力已可用。
