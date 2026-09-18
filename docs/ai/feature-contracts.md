# 功能名稱、組裝與視覺維護入口

狀態：DEFINE 工作稿。實際來源位置已讀取核對；下列人類功能名稱為文件提案，不是新增 Dart API、runtime ID、獨立架構模組或已接受的新元件。嚴格組裝目標以 [當前 DEFINE](../../spec/visual-component-governance.md) 為準。

## 1. 目前實際層級

正式架構見 [模組登錄表](../../lib/src/architecture.md)：L0 kernel；L1 capabilities、styling；L2 composition；L3 foundation；L4 runtime；L5 features；L6 rendering；L7 application。這是相依層級，不是畫面父子關係。

目前 `features` 是正式模組，`workspace`、`editing` 等主要是內部責任區。`workspace/architecture.md` 已有特定布局修訂契約，但不因此代表所有 feature 子資料夾已各自登錄為獨立模組。

以 Sidebar 為例，實際工作分工如下：

| 工作 | 目前來源 | 負責內容 |
| --- | --- | --- |
| 產品選用與資料組裝 | `D:/Projects/Planist/frontend/lib/features/workspace/layout/pln_workspace_sidebar.dart` | 選擇 toolbar／action／Explorer、資料、事件與群組順序。 |
| 產品外層結構 | `D:/Projects/Planist/frontend/lib/features/workspace/layout/pln_windows_workspace_layout.dart`、`pln_workspace_content_layout.dart` | Sidebar、視窗工具區及 Stage 的相鄰關係。 |
| 唯一公開元件入口 | [kallopis_declarative.dart](../../lib/kallopis_declarative.dart) | consumer 可以使用的實際匯出。 |
| 功能資料與插槽 | [klp_workspace_block.dart](../../lib/src/features/workspace/components/klp_workspace_block.dart)、[klp_frame_groups.dart](../../lib/src/features/workspace/layout/klp_frame_groups.dart)、[klp_app_layout.dart](../../lib/src/features/workspace/layout/klp_app_layout.dart) | constructor、資料、事件、種類、插槽與部分限制。 |
| 功能語意與轉接 | [klp_workspace_block_adapter.dart](../../lib/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart)、[klp_frame_groups_adapter.dart](../../lib/src/features/workspace/layout/adapters/klp_frame_groups_adapter.dart) | 元件語意、原料用途對應，以及轉成呈現資料。 |
| 共用風格值與解析 | [klp_workspace_preset.dart](../../lib/src/styling/presets/klp_workspace_preset.dart)、[klp_semantic_resolver.dart](../../lib/src/styling/resolution/klp_semantic_resolver.dart) | 完整原料、共用風格解析；微立體等配方也由 styling 擁有。 |
| 本庫目錄組裝 | [klp_application_adapters.dart](../../lib/src/application/bootstrap/internal/klp_application_adapters.dart) | 組裝本庫 adapter 集合，consumer 不註冊。 |
| 樹驗證、準備與安裝 | [klp_tree_runtime.dart](../../lib/src/runtime/compilation/klp_tree_runtime.dart)、[klp_tree_capture.dart](../../lib/src/composition/validation/internal/klp_tree_capture.dart) | 擷取並驗證結構、解析語意、準備元件、安裝與提交。 |
| 不可變呈現資料 | [klp_bound_workspace_block.dart](../../lib/src/features/workspace/presentation/klp_bound_workspace_block.dart) | renderer 所需的資料、已解析尺寸與顏色。 |
| 實際 Flutter 布局與互動 | [klp_flutter_renderer.dart](../../lib/src/rendering/flutter/klp_flutter_renderer.dart)、[klp_flutter_workspace_block.dart](../../lib/src/rendering/flutter/internal/klp_flutter_workspace_block.dart)、[klp_flutter_frame_groups.dart](../../lib/src/rendering/flutter/internal/klp_flutter_frame_groups.dart) | 分派、布局、繪製、命中及互動實現。 |

目前外觀決策並非全部集中在 preset：例如 toolbar renderer 使用 `rowExtent / 2 + compactGap` 計算膠囊圓角，並自行組合內外留白。這是需要對照新契約審核的實作位置；調色表本身無法解決錯用元件或錯誤表面用途。

## 2. 建議使用的功能名稱

`Workspace.Explorer / EXP-V1-r2` 已完成 API 替換，精確資料、能力、事件及宣告 → 組裝見 [Explorer 契約](explorer-model.md)；新外觀仍由 [Catalog](explorer-catalog.md) 接受。其他功能的 DEFINE 狀態不因此改變。

本節名稱只描述 Kallopis 的產品無關能力。Planist 的功能採用、組合順序、路由目的及商業流程由使用者設計並保存在 Planist；不在本庫新增產品組裝層。下列 Workspace 前綴對應現有來源分類，並非要求 consumer 使用固定工作區模板。

名稱用於定位契約；不代表新增元件。原始碼現況以 [feature ownership 清冊](../../lib/src/features/catalog/component-ownership.json)、實際公開匯出及 adapter 對照為準。公開可達性也不等於人類已接受所有視覺及平台行為。

| 功能名稱提案 | 責任 | 現有 API／來源 | 使用邊界 |
| --- | --- | --- | --- |
| `Workspace.Layout` | 工作區區域的組裝、角色與相鄰關係 | `KlpAppLayout`、`LayoutRow/Column`、`KlpAppFrame`、`KlpLayoutPane`、`LayoutSpacer/ResizeHandle`；`features/workspace/layout/klp_app_layout.dart` | 不是任意 Flutter 排版工具；嚴格位置與參數規則待本輪收斂。 |
| `Workspace.Groups` | Frame 內的分群、內容與 footer 插槽 | `KlpFrameGroups`、`KlpFrameGroup`；`features/workspace/layout/klp_frame_groups.dart` | 不負責業務資料；不能用 padding 選項補償其他元件錯配。 |
| `Workspace.Explorer` | 樹狀資料、選取、展開與命令輸入 | `KlpExplorer`、`KlpExplorerItemModel`；`features/workspace/explorer/` | Planist 擁有資料與操作結果，本庫擁有呈現；不可當作任意導航模板。 |
| `Workspace.DocumentTabs` | 文件分頁資料及對應事件 | `KlpDocumentTabs`、`KlpDocumentTab`；`features/workspace/components/klp_document_tabs.dart` | 不掌管文件持久化或正文。 |
| `Workspace.WindowControls` | 最小化、最大化／還原、關閉的宣告 | `KlpWindowControls`；`features/workspace/components/klp_window_controls.dart` | 原生操作需宿主能力，不由 consumer 提供 Widget。 |
| `Workspace.Blocks` | 既有通用工作區區塊家族 | `KlpWorkspaceBlock`；`features/workspace/components/klp_workspace_block.dart` | 交接時必須進一步指定下表用途；不能只寫此家族名便自由選 kind。 |
| `Workspace.Content` | 非正文引擎的文字、標題、提示、分隔、連結、勾選與群組資料 | `KlpWorkspaceContent`、`KlpWorkspaceContentBlock`；同上來源 | 不替代 BlockNote 正文權威。 |
| `Editing.BlockNoteHost` | 透過 Krepis 承載 BlockNote 文件與工作階段 | `KlpBlockNoteEditingContent`；`features/editing/contracts/klp_block_note_editing_content.dart` | 新筆記正文方向；上游掌管正文、排版、選取與 undo。 |
| `Editing.CanvaHost` | 承載 Canva 編輯工作階段 | `KlpCanvaEditingContent`；`features/editing/contracts/klp_canva_editing_content.dart` | 公開實驗能力；不因存在而自動成為產品需求。 |
| `Editing.Compatibility` | 原有自研編輯內容及相關控制接合 | `KlpEditingContent`、`KlpBlockControls`、`KlpAnchoredCommands`、`KlpModeToolbar`；`features/editing/contracts/` | 受 KLP-0020 相容／回退邊界限制，不默認加入 BlockNote 正文方案；各控制可用狀態需讀對應契約。 |

### Workspace.Blocks 必須再指定用途

下列十項對應現有 enum，不新增十個獨立 API 或模組。每個用途仍須有自己的合法位置及視覺驗收：

| 溝通名稱提案 | 目前 kind | 責任 |
| --- | --- | --- |
| `Workspace.Identity` | `identity` | 身分與標識內容。 |
| `Workspace.Action` | `action` | 單項操作資料與事件。 |
| `Workspace.Paper` | `paper` | 紙面內容呈現。 |
| `Workspace.Sticky` | `sticky` | 便箋內容呈現。 |
| `Workspace.Search` | `search` | 搜尋輸入及候選內容；Planist Sidebar 未採用。 |
| `Workspace.Settings` | `settings` | 既有設定選項內容。 |
| `Workspace.Board` | `board` | 既有看板集合內容。 |
| `Workspace.Cards` | `cards` | 既有卡片集合內容。 |
| `Workspace.Dialog` | `dialog` | 既有對話內容與命令。 |
| `Workspace.ToolActions` | `toolbar` | 工具操作項目；目前自帶膠囊外觀不代表已符合 Sidebar 需求。 |

### 尚非現行宣告式可選功能

`navigation/rail` 為內部能力，不能指示 consumer 使用 `KlpRail`。`actions`、`collections`、`feedback`、`forms`、`infinite_canvas`、`navigation/widgets`、`overlays` 及其餘舊 workspace Widget 主要屬相容路徑；不能因資料夾存在便當成已交付的宣告式 feature module。

## 3. 人類如何控管風格與設計新元件

人類主要維護「功能契約卡＋Catalog 接受結果」，不必逐一修改 adapter 或 renderer：

| 契約卡欄位 | 必須寫清楚 |
| --- | --- |
| 名稱／版本／狀態 | 固定名稱、契約版本、草案／可用／相容；API 可用與視覺已接受分開記錄。 |
| 職責與非職責 | 此功能解決什麼需求，以及不能拿來替代什麼。 |
| 公開宣告 | 真實 API、資料、事件、資料權威與最小範例。 |
| 組裝契約 | 父容器、插槽、允許子項、順序、數量、互斥及上下文；合法與拒絕反例。 |
| 視覺契約 | 表面用途、尺寸約束、間距責任、圖示／文字、互動狀態與命中關係；值引用唯一風格來源。 |
| Catalog | 孤立元件與實際組合的候選，接受的版本、環境、狀態及未解事項。 |
| 實作定位 | 宣告、adapter、bound、renderer 的實際檔案，方便本庫維護者追查。 |

改風格時先說明哪一項用途規則要改，例如「工具操作列不額外形成表面」；不是讓 consumer 改顏色或 padding。本庫再依變更落在共用原料、用途映射或布局實現，修改相應責任位置。

新元件第一步只定義契約卡的「需求、輸入、輸出、合法位置」，並核對是否已有合適能力。其餘順序為：Catalog 候選 → 人類接受 → PLAN 配對既有模組契約 → BUILD → 真實元件組合驗收。具體資料夾拆分、型別和防繞過機制留到 PLAN。

## 4. 如何向其他 agent 指定組裝

Kallopis 只定義通用功能名稱，例如 `Workspace.ToolActions`。產品若使用 `Planist.Sidebar` 作為組裝名稱，其定義只存在於 [Planist 產品文件](../../../Planist/docs/planning/sidebar-composition.md)，不成為本庫功能、模板或元件。Planist 可在本庫合法組裝範圍內自由組合，但必須遵循使用者設計的組合邏輯。

可以這樣交接：

> 依 Planist 中使用者已設計的 Sidebar 組裝規格，選用 Kallopis 通用元件並提供資料與事件。先讀產品規格，再透過本庫功能索引定位 API 與合法組裝規則；不得自行加入、替代或重排功能。若能力不足，先提出產品無關的元件需求，不在 Kallopis 新增 Planist 專用元件或商業流程。

完成各功能契約卡後，交接格式收斂為「產品組裝名稱及版本＋所採用功能名稱及版本＋資料／事件需求」。版本用實際已接受版本，不虛構 `v1` 或把 draft 當作 BUILD 授權。

本頁只是文件入口及功能名稱提案；當前仍為 DEFINE，不表示所有功能契約已逐一完成，也沒有新增或修改正式元件。
