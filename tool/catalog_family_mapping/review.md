# Catalog capability family 審閱

> 此頁由已接受的固定分類與 `families.json` 產生，請勿手動修改。Family 接受不代表公開處置、module ownership 或 migration 完成。

- Family 狀態：`proposed`
- 接受時間：`尚未接受`
- Classification revision：`0fcf54782b0fc0013a296bd4d505a85fd50ffd1a`
- Classification SHA-256：`e837e0d6be2ee36dbba4a94bb4869c1989050b232d3c0fefa640435ffcb07de8`
- 固定 legacy members：`254`
- Capability families：`161`

## 結構摘要

| Composition level | Family 數 |
| --- | ---: |
| `container` | 54 |
| `element` | 68 |
| `internal` | 22 |
| `layout` | 4 |
| `none` | 12 |
| `screen` | 1 |

- 公開 family 可達性：`127/127`
- Parent-owned role edges：`281`
- 唯一合法結構順序：`screen → layout → container → element`

## `screen` families — 1

### 應用畫面根 (`FAM-APP-SCREEN`)

- Consumer job：建立可啟動、可導覽且具輔助語意的產品畫面。
- Event contract：畫面只回報screen-level intent；feature intent由所屬container回報。
- Lifecycle contract：application建立與替換screen projection；Kallopis管理host與overlay生命週期。
- Legacy members（2）：`KlpApp`、`KlpAppScreen`
- Data invariants：
  - 畫面具有穩定身分、名稱與恰好一個根layout。
- Accepted by：
  - `application/router → screen` 固定根入口
- Child roles：
  - `root-layout`（`1..1`；`fixed`）：畫面的唯一根區域關係。
    - 接受：`FAM-LAYOUT-DOCK`、`FAM-LAYOUT-PAGE`、`FAM-LAYOUT-SETTINGS`、`FAM-LAYOUT-SPLIT`

## `layout` families — 4

### 可停駐工作區布局 (`FAM-LAYOUT-DOCK`)

- Consumer job：安排可停駐、移動或重組的工作區域。
- Event contract：以layout intent回報停駐、移動、收合與reveal，不暴露raw geometry。
- Lifecycle contract：產品可持久化語意pane state；Kallopis管理drag、尺寸與響應布局。
- Legacy members（1）：`KlpDockLayout`
- Data invariants：
  - dock region具有穩定身分、語意角色、可見與停駐狀態。
- Accepted by：
  - `應用畫面根` (`FAM-APP-SCREEN`).`root-layout`
- Child roles：
  - `workspace-actions`（`0..unbounded`；`consumer-semantic`）：工作區全域或目前內容的操作群組。
    - 接受：`FAM-ACTION-DOCUMENT-EDIT`、`FAM-ACTION-EDITOR-TOOLS`、`FAM-ACTION-GROUP`、`FAM-ACTION-MENU`、`FAM-ACTION-SELECTION`、`FAM-APP-WINDOW-CONTROLS`、`FAM-CANVAS-TOOLS`、`FAM-SETTINGS-ACTIONS`
  - `workspace-content`（`1..unbounded`；`consumer-semantic`）：可停駐的主要產品功能區域。
    - 接受：`FAM-CANVAS-VIEWPORT`、`FAM-COLLAB-CONVERSATION`、`FAM-COLLAB-MESSAGE-COMPOSER`、`FAM-DATA-ACCORDION`、`FAM-DATA-JSON-TREE`、`FAM-DATA-KEY-VALUE-LIST`、`FAM-DATA-KEY-VALUE-TABLE`、`FAM-DATA-TABLE`、`FAM-DATA-TREE`、`FAM-DOC-CODE-VIEWER`、`FAM-DOC-DIFF-VIEWER`、`FAM-DOC-TERMINAL`、`FAM-FILE-EXPLORER`、`FAM-FILE-PREVIEW`、`FAM-FORM-ASSEMBLY`、`FAM-FORM-KEY-VALUE-EDITOR`、`FAM-FORM-RADIO-SELECTION`、`FAM-FORM-REFERENCE-PICKER`、`FAM-FORM-REPEATER`、`FAM-PLAN-CALENDAR`、`FAM-PLAN-SCHEDULE`、`FAM-PLAN-STEPPER`、`FAM-PLAN-TASKS`、`FAM-PLAN-TIMELINE`、`FAM-PLAN-WORKFLOW-STATE`
  - `workspace-header`（`0..unbounded`；`fixed`）：工作區與目前內容的身分及狀態區。
    - 接受：`FAM-APP-IDENTITY-HEADER`、`FAM-APP-STAGE-HEADER`、`FAM-APP-STATUS-BAR`、`FAM-APP-WINDOW-HEADER`、`FAM-DOC-HEADER`、`FAM-LAYOUT-PANEL-HEADER`
  - `workspace-navigation`（`0..unbounded`；`consumer-semantic`）：工作區位置、階層、搜尋與分頁導覽。
    - 接受：`FAM-NAV-BREADCRUMB`、`FAM-NAV-EXPLORER`、`FAM-NAV-PAGINATION`、`FAM-NAV-PRIMARY`、`FAM-NAV-TABS`、`FAM-SEARCH-FILTER`、`FAM-SETTINGS-NAVIGATION`
  - `workspace-overlays`（`0..unbounded`；`fixed`）：工作區核准的暫態功能表面。
    - 接受：`FAM-ACTION-COMMAND-MENU`、`FAM-FEEDBACK-PROGRESS-OVERLAY`、`FAM-OVERLAY-CONTEXT-MENU`、`FAM-OVERLAY-DIALOG`、`FAM-OVERLAY-DRAWER`、`FAM-OVERLAY-POPOVER`、`FAM-SETTINGS-DIALOG`

### 文件與資料頁布局 (`FAM-LAYOUT-PAGE`)

- Consumer job：組成頁面的標題、主要內容、操作與狀態區。
- Event contract：layout只回報頁面區域intent；feature intent由container回報。
- Lifecycle contract：Kallopis管理頁面scroll、safe area與responsive placement。
- Legacy members（1）：`KlpPageChrome`
- Data invariants：
  - 頁面具有穩定身分及具名header、content、actions與feedback roles。
- Accepted by：
  - `應用畫面根` (`FAM-APP-SCREEN`).`root-layout`
- Child roles：
  - `page-actions`（`0..unbounded`；`consumer-semantic`）：頁面或文件操作。
    - 接受：`FAM-ACTION-DOCUMENT-EDIT`、`FAM-ACTION-EDITOR-TOOLS`、`FAM-ACTION-GROUP`、`FAM-ACTION-SELECTION`
  - `page-content`（`1..1`；`fixed`）：文件、資料或表單主要內容。
    - 接受：`FAM-DATA-ACCORDION`、`FAM-DATA-JSON-TREE`、`FAM-DATA-KEY-VALUE-LIST`、`FAM-DATA-KEY-VALUE-TABLE`、`FAM-DATA-TABLE`、`FAM-DATA-TREE`、`FAM-DOC-CODE-VIEWER`、`FAM-DOC-DIFF-VIEWER`、`FAM-DOC-TERMINAL`、`FAM-FILE-PREVIEW`、`FAM-FORM-ASSEMBLY`
  - `page-feedback`（`0..1`；`fixed`）：頁面工作與儲存狀態。
    - 接受：`FAM-APP-STATUS-BAR`、`FAM-FEEDBACK-PROGRESS-OVERLAY`
  - `page-header`（`1..unbounded`；`fixed`）：頁面位置與文件身分。
    - 接受：`FAM-APP-STAGE-HEADER`、`FAM-DOC-HEADER`、`FAM-NAV-BREADCRUMB`

### 設定頁布局 (`FAM-LAYOUT-SETTINGS`)

- Consumer job：組成可瀏覽與修改的一頁設定內容。
- Event contract：layout只回報區域級intent；設定值由settings container回報。
- Lifecycle contract：Kallopis管理responsive pane與scroll，不擁有設定資料。
- Legacy members（1）：`KlpSettingsPage`
- Data invariants：
  - 設定頁具有穩定scope、navigation、content與action roles。
- Accepted by：
  - `應用畫面根` (`FAM-APP-SCREEN`).`root-layout`
- Child roles：
  - `settings-actions`（`0..1`；`fixed`）：套用、取消與重設設定。
    - 接受：`FAM-SETTINGS-ACTIONS`
  - `settings-content`（`1..1`；`fixed`）：目前設定頁的欄位內容。
    - 接受：`FAM-FORM-ASSEMBLY`、`FAM-SETTINGS-CONTENT`
  - `settings-navigation`（`1..1`；`fixed`）：設定分類與頁面切換。
    - 接受：`FAM-SETTINGS-NAVIGATION`
  - `settings-overlay`（`0..1`；`fixed`）：設定流程的核准暫態表面。
    - 接受：`FAM-SETTINGS-DIALOG`

### 相鄰區域布局 (`FAM-LAYOUT-SPLIT`)

- Consumer job：把可用空間分配給兩個或多個具名相鄰區域。
- Event contract：以split layout intent回報收合與語意比例變更，不暴露raw pixels。
- Lifecycle contract：產品可持久化pane state；Kallopis管理尺寸、divider與responsive collapse。
- Legacy members（1）：`KlpSplitLayout`
- Data invariants：
  - 每個region具有穩定語意身分、可見狀態與產品順序。
- Accepted by：
  - `應用畫面根` (`FAM-APP-SCREEN`).`root-layout`
- Child roles：
  - `primary-content`（`1..1`；`fixed`）：主要工作區域。
    - 接受：`FAM-CANVAS-VIEWPORT`、`FAM-COLLAB-CONVERSATION`、`FAM-DATA-TABLE`、`FAM-DATA-TREE`、`FAM-DOC-CODE-VIEWER`、`FAM-DOC-DIFF-VIEWER`、`FAM-DOC-TERMINAL`、`FAM-FILE-EXPLORER`、`FAM-FORM-ASSEMBLY`、`FAM-PLAN-CALENDAR`、`FAM-PLAN-TASKS`
  - `secondary-content`（`1..unbounded`；`consumer-semantic`）：與主要工作共同運作的輔助區域。
    - 接受：`FAM-ACTION-GROUP`、`FAM-COLLAB-MESSAGE-COMPOSER`、`FAM-DATA-ACCORDION`、`FAM-DATA-JSON-TREE`、`FAM-DATA-KEY-VALUE-LIST`、`FAM-DATA-KEY-VALUE-TABLE`、`FAM-FILE-PREVIEW`、`FAM-FORM-KEY-VALUE-EDITOR`、`FAM-FORM-REFERENCE-PICKER`、`FAM-NAV-EXPLORER`、`FAM-PLAN-SCHEDULE`、`FAM-PLAN-TIMELINE`

## `container` families — 54

### 命令搜尋與執行 (`FAM-ACTION-COMMAND-MENU`)

- Consumer job：搜尋並執行目前上下文允許的命令。
- Event contract：以單一命令 intent 回報選取的命令身分。
- Lifecycle contract：查詢與目前命令集合隨 projection 更新；暫態選取由Kallopis管理。
- Legacy members（1）：`KlpCommandMenu`
- Data invariants：
  - 命令具有穩定身分、標籤、可用狀態與語意群組。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-overlays`
- Child roles：
  - 無。

### 文件編輯動作群組 (`FAM-ACTION-DOCUMENT-EDIT`)

- Consumer job：提供目前文件內容可以執行的編輯動作。
- Event contract：以文件動作 intent 回報被啟用的操作。
- Lifecycle contract：動作集合隨文件狀態重新宣告，不持有文件資料權威。
- Legacy members（1）：`KlpDocumentEditActions`
- Data invariants：
  - 動作具有穩定身分、可用狀態與文件上下文。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-actions`
  - `文件與資料頁布局` (`FAM-LAYOUT-PAGE`).`page-actions`
- Child roles：
  - `actions`（`1..unbounded`；`consumer-semantic`）：文件編輯操作。
    - 接受：`FAM-ACTION-TRIGGER`、`FAM-SYSTEM-SHORTCUT-HINT`

### 編輯器工具群組 (`FAM-ACTION-EDITOR-TOOLS`)

- Consumer job：提供內容編輯器目前允許的格式與操作。
- Event contract：以編輯工具 intent 回報使用者操作。
- Lifecycle contract：工具狀態隨編輯器 selection projection 更新。
- Legacy members（1）：`KlpEditorToolbar`
- Data invariants：
  - 工具具有穩定身分、選取狀態與可用狀態。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-actions`
  - `文件與資料頁布局` (`FAM-LAYOUT-PAGE`).`page-actions`
- Child roles：
  - `tools`（`1..unbounded`；`consumer-semantic`）：編輯器格式與操作入口。
    - 接受：`FAM-ACTION-TRIGGER`、`FAM-SYSTEM-SHORTCUT-HINT`

### 語意動作群組 (`FAM-ACTION-GROUP`)

- Consumer job：把共同工作的操作整理為一個受控群組。
- Event contract：以單一動作 intent 回報群組內被啟用的操作。
- Lifecycle contract：群組由目前產品狀態重新宣告，Kallopis管理焦點與呈現狀態。
- Legacy members（1）：`KlpActionGroup`
- Data invariants：
  - 群組與動作具有穩定身分、語意順序及可用狀態。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-actions`
  - `文件與資料頁布局` (`FAM-LAYOUT-PAGE`).`page-actions`
  - `相鄰區域布局` (`FAM-LAYOUT-SPLIT`).`secondary-content`
- Child roles：
  - `actions`（`1..unbounded`；`consumer-semantic`）：可由此群組執行的語意操作與輔助說明。
    - 接受：`FAM-ACTION-TRIGGER`、`FAM-OVERLAY-TOOLTIP`、`FAM-SYSTEM-SHORTCUT-HINT`

### 選單動作集合 (`FAM-ACTION-MENU`)

- Consumer job：呈現目前上下文可選取或執行的動作。
- Event contract：以單一menu intent回報選取或展開動作。
- Lifecycle contract：開關、焦點與子選單暫態狀態由Kallopis管理。
- Legacy members（1）：`KlpMenu`
- Data invariants：
  - 選單項保留身分、狀態、群組與可選子命令關係。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-actions`
- Child roles：
  - `items`（`1..unbounded`；`consumer-semantic`）：選單中的語意動作項目。
    - 接受：`FAM-ACTION-MENU-ITEM`

### 選取內容動作 (`FAM-ACTION-SELECTION`)

- Consumer job：對目前已選取的一筆或多筆內容提供共同操作。
- Event contract：以selection action intent回報動作及目前選取身分集合。
- Lifecycle contract：隨產品選取projection出現或更新，不持有選取權威。
- Legacy members（2）：`KlpBulkActionBar`、`KlpSelectionToolbar`
- Data invariants：
  - 選取摘要與可用動作具有穩定身分及可用狀態。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-actions`
  - `文件與資料頁布局` (`FAM-LAYOUT-PAGE`).`page-actions`
- Child roles：
  - `actions`（`1..unbounded`；`consumer-semantic`）：針對目前選取內容的操作。
    - 接受：`FAM-ACTION-TRIGGER`、`FAM-SYSTEM-SHORTCUT-HINT`

### 工作區身分標頭 (`FAM-APP-IDENTITY-HEADER`)

- Consumer job：在側邊區呈現目前工作區或主體身分。
- Event contract：以identity intent回報核准的主體操作。
- Lifecycle contract：身分隨workspace projection更新，不保存產品選取權威。
- Legacy members（1）：`KlpSidebarIdentityHeader`
- Data invariants：
  - 主體具有穩定身分、名稱與可選摘要。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-header`
- Child roles：
  - `identity`（`1..2`；`fixed`）：主體的辨識資料。
    - 接受：`FAM-DATA-AVATAR`、`FAM-DOC-TEXT`

### 主要工作內容標頭 (`FAM-APP-STAGE-HEADER`)

- Consumer job：呈現主要工作內容的標題、狀態、導覽與操作。
- Event contract：以stage header intent回報導覽或操作。
- Lifecycle contract：隨主要內容projection更新；Kallopis管理壓縮與響應呈現。
- Legacy members（2）：`KlpStageHeader`、`KlpStageTopBar`
- Data invariants：
  - 工作內容具有穩定身分、標題、狀態與可用操作。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-header`
  - `文件與資料頁布局` (`FAM-LAYOUT-PAGE`).`page-header`
- Child roles：
  - `actions`（`0..unbounded`；`consumer-semantic`）：主要工作內容的局部操作。
    - 接受：`FAM-ACTION-TRIGGER`、`FAM-NAV-DESTINATION`、`FAM-SYSTEM-SHORTCUT-HINT`
  - `identity`（`1..unbounded`；`fixed`）：工作內容的標題與狀態摘要。
    - 接受：`FAM-DATA-ANNOTATION`、`FAM-DOC-TEXT`、`FAM-FEEDBACK-STATUS`

### 應用狀態列 (`FAM-APP-STATUS-BAR`)

- Consumer job：在工作區固定區域呈現整體狀態與摘要。
- Event contract：以status intent回報可操作狀態項目。
- Lifecycle contract：狀態集合隨application projection更新；排序代表產品優先級。
- Legacy members（1）：`KlpStatusBar`
- Data invariants：
  - 狀態項具有穩定身分、嚴重度與文字摘要。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-header`
  - `文件與資料頁布局` (`FAM-LAYOUT-PAGE`).`page-feedback`
- Child roles：
  - `status-items`（`0..unbounded`；`consumer-semantic`）：應用層狀態、進度與提示。
    - 接受：`FAM-DATA-ANNOTATION`、`FAM-FEEDBACK-INLINE-NOTICE`、`FAM-FEEDBACK-PROGRESS`、`FAM-FEEDBACK-SAVE-STATUS`、`FAM-FEEDBACK-STATUS`、`FAM-FEEDBACK-TOAST`

### 宿主視窗操作 (`FAM-APP-WINDOW-CONTROLS`)

- Consumer job：提交最小化、最大化、還原與關閉視窗的宿主意圖。
- Event contract：以封閉window intent回報最小化、最大化、還原或關閉。
- Lifecycle contract：host狀態變更後重新宣告；不直接控制原生視窗。
- Legacy members（1）：`KlpWindowControls`
- Data invariants：
  - 視窗最大化狀態與允許操作由host projection提供。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-actions`
- Child roles：
  - 無。

### 桌面視窗標頭 (`FAM-APP-WINDOW-HEADER`)

- Consumer job：組成桌面應用視窗頂端的標識、拖曳區與控制。
- Event contract：以window header intent回報標識或宿主操作。
- Lifecycle contract：隨host window projection更新；拖曳與命中區由Kallopis管理。
- Legacy members（2）：`KlpAppWindowHeader`、`KlpWindowHeader`
- Data invariants：
  - 視窗具有穩定標題、應用身分與控制狀態。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-header`
- Child roles：
  - `identity`（`1..2`；`fixed`）：視窗應用身分與標題。
    - 接受：`FAM-DOC-TEXT`、`FAM-VISUAL-ICON`

### 畫布工具群組 (`FAM-CANVAS-TOOLS`)

- Consumer job：提供空間畫布目前可用的工具與操作。
- Event contract：以canvas tool intent回報工具切換或操作。
- Lifecycle contract：工具projection隨畫布模式更新；pointer gesture由Kallopis管理。
- Legacy members（1）：`KlpCanvasToolbar`
- Data invariants：
  - 工具具有穩定身分、選取狀態與可用狀態。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-actions`
- Child roles：
  - `tools`（`1..unbounded`；`consumer-semantic`）：畫布模式與操作入口。
    - 接受：`FAM-ACTION-TRIGGER`、`FAM-SYSTEM-SHORTCUT-HINT`

### 空間畫布 (`FAM-CANVAS-VIEWPORT`)

- Consumer job：承載可平移、縮放、選取與連接的空間內容。
- Event contract：以單一canvas intent回報選取、移動、連接、縮放與drop。
- Lifecycle contract：產品擁有圖資料；Kallopis管理手勢、暫態selection與viewport controller lease。
- Legacy members（1）：`KlpCanvasViewport`
- Data invariants：
  - 畫布具有穩定節點、連線、空間座標與viewport projection。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-content`
  - `相鄰區域布局` (`FAM-LAYOUT-SPLIT`).`primary-content`
- Child roles：
  - `nodes`（`0..unbounded`；`consumer-semantic`）：畫布中的空間節點資料。
    - 接受：`FAM-CANVAS-FLOW-NODE`
  - `overlays`（`0..unbounded`；`fixed`）：畫布概覽、拖放與驗證資料。
    - 接受：`FAM-CANVAS-DROP-INTENT`、`FAM-CANVAS-FLOW-VALIDATION`、`FAM-CANVAS-MINIMAP`

### 訊息對話 (`FAM-COLLAB-CONVERSATION`)

- Consumer job：按時間與回覆關係閱讀一組訊息並形成完整對話。
- Event contract：以conversation intent回報開啟、回覆或參與者操作。
- Lifecycle contract：產品擁有訊息權威；Kallopis管理scroll、focus與暫態選取。
- Legacy members（2）：`KlpMessageConversation`、`KlpMessageThread`
- Data invariants：
  - 訊息、參與者、時間與回覆關係具有穩定身分。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-content`
  - `相鄰區域布局` (`FAM-LAYOUT-SPLIT`).`primary-content`
- Child roles：
  - `messages`（`0..unbounded`；`consumer-semantic`）：依時間或回覆關係排列的訊息資料。
    - 接受：`FAM-COLLAB-MESSAGE`
  - `participants`（`0..unbounded`；`consumer-semantic`）：對話參與者與presence摘要。
    - 接受：`FAM-COLLAB-PRESENCE`、`FAM-DATA-AVATAR`

### 訊息撰寫 (`FAM-COLLAB-MESSAGE-COMPOSER`)

- Consumer job：撰寫並提交一則新訊息。
- Event contract：以composer intent回報草稿變更、附件與提交。
- Lifecycle contract：草稿權威由產品決定；Kallopis管理輸入焦點與IME。
- Legacy members（1）：`KlpMessageComposer`
- Data invariants：
  - 草稿文字、附件摘要與提交可用狀態由產品projection提供。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-content`
  - `相鄰區域布局` (`FAM-LAYOUT-SPLIT`).`secondary-content`
- Child roles：
  - `actions`（`1..unbounded`；`fixed`）：訊息提交與附件操作。
    - 接受：`FAM-ACTION-TRIGGER`
  - `input`（`1..1`；`fixed`）：訊息草稿輸入資料。
    - 接受：`FAM-FORM-TEXT-AREA`

### 可展開資料區段 (`FAM-DATA-ACCORDION`)

- Consumer job：逐段展開並閱讀具名稱的資料區段。
- Event contract：以section intent回報展開或收合。
- Lifecycle contract：產品決定持久展開狀態；Kallopis管理動畫與焦點。
- Legacy members（1）：`KlpAccordion`
- Data invariants：
  - 區段具有穩定身分、標題、展開狀態與摘要內容。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-content`
  - `文件與資料頁布局` (`FAM-LAYOUT-PAGE`).`page-content`
  - `相鄰區域布局` (`FAM-LAYOUT-SPLIT`).`secondary-content`
- Child roles：
  - `sections`（`1..unbounded`；`consumer-semantic`）：可展開區段的標題與摘要資料。
    - 接受：`FAM-DATA-LIST-ITEM`、`FAM-DOC-SECTION`

### 結構化鍵值樹 (`FAM-DATA-JSON-TREE`)

- Consumer job：以可展開階層閱讀結構化鍵值資料。
- Event contract：以json tree intent回報展開、複製或定位。
- Lifecycle contract：來源資料由產品擁有；Kallopis管理虛擬化與暫態焦點。
- Legacy members（1）：`KlpJsonTree`
- Data invariants：
  - 鍵值節點具有穩定path、型別、值摘要與展開狀態。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-content`
  - `文件與資料頁布局` (`FAM-LAYOUT-PAGE`).`page-content`
  - `相鄰區域布局` (`FAM-LAYOUT-SPLIT`).`secondary-content`
- Child roles：
  - `nodes`（`0..unbounded`；`consumer-semantic`）：結構化鍵值節點。
    - 接受：`FAM-DATA-TREE-ITEM`

### 鍵值線性清單 (`FAM-DATA-KEY-VALUE-LIST`)

- Consumer job：以線性項目呈現名稱與值的對應。
- Event contract：以item intent回報選取或核准操作。
- Lifecycle contract：資料隨產品projection更新；排列由Kallopis管理。
- Legacy members（1）：`KlpKeyValueList`
- Data invariants：
  - 每筆鍵值具有穩定身分、名稱、值與狀態。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-content`
  - `文件與資料頁布局` (`FAM-LAYOUT-PAGE`).`page-content`
  - `相鄰區域布局` (`FAM-LAYOUT-SPLIT`).`secondary-content`
- Child roles：
  - `items`（`0..unbounded`；`consumer-semantic`）：鍵值資料項目。
    - 接受：`FAM-DATA-LIST-ITEM`

### 鍵值比較表 (`FAM-DATA-KEY-VALUE-TABLE`)

- Consumer job：以欄列表格比較多組名稱與值。
- Event contract：以table intent回報選取、排序或資料操作。
- Lifecycle contract：資料與schema由產品擁有；Kallopis管理欄寬與虛擬化。
- Legacy members（1）：`KlpKeyValueTable`
- Data invariants：
  - 欄與列具有穩定schema、身分與可排序值。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-content`
  - `文件與資料頁布局` (`FAM-LAYOUT-PAGE`).`page-content`
  - `相鄰區域布局` (`FAM-LAYOUT-SPLIT`).`secondary-content`
- Child roles：
  - `cells`（`0..unbounded`；`consumer-semantic`）：鍵值表格中的資料摘要。
    - 接受：`FAM-DATA-LIST-ITEM`、`FAM-DOC-TEXT`

### 結構化資料表 (`FAM-DATA-TABLE`)

- Consumer job：以欄列schema呈現、選取與操作多筆資料。
- Event contract：以table intent回報選取、排序、分頁與row action。
- Lifecycle contract：產品擁有資料權威；Kallopis管理欄寬、焦點與虛擬化。
- Legacy members（1）：`KlpDataTable`
- Data invariants：
  - 欄schema、row身分、cell值、排序與選取狀態穩定。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-content`
  - `文件與資料頁布局` (`FAM-LAYOUT-PAGE`).`page-content`
  - `相鄰區域布局` (`FAM-LAYOUT-SPLIT`).`primary-content`
- Child roles：
  - `cell-content`（`0..unbounded`；`consumer-semantic`）：欄列中的語意資料摘要。
    - 接受：`FAM-DATA-ANNOTATION`、`FAM-DATA-AVATAR`、`FAM-DATA-LIST-ITEM`、`FAM-DATA-METRIC`、`FAM-DOC-TEXT`、`FAM-FEEDBACK-STATUS`

### 階層資料樹 (`FAM-DATA-TREE`)

- Consumer job：以可展開階層呈現、選取與操作結構化資料。
- Event contract：以tree intent回報展開、選取、reveal與節點操作。
- Lifecycle contract：產品擁有階層權威；Kallopis管理焦點、虛擬化與controller lease。
- Legacy members（1）：`KlpTree`
- Data invariants：
  - 節點具有穩定身分、parent關係、展開、選取與可用狀態。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-content`
  - `文件與資料頁布局` (`FAM-LAYOUT-PAGE`).`page-content`
  - `相鄰區域布局` (`FAM-LAYOUT-SPLIT`).`primary-content`
- Child roles：
  - `nodes`（`0..unbounded`；`consumer-semantic`）：樹狀資料節點。
    - 接受：`FAM-DATA-TREE-ITEM`

### 程式文字閱讀 (`FAM-DOC-CODE-VIEWER`)

- Consumer job：以程式文字語意閱讀內容。
- Event contract：以code viewer intent回報複製、選取或定位。
- Lifecycle contract：產品擁有文字資料；Kallopis管理scroll與syntax presentation。
- Legacy members（1）：`KlpCodeViewer`
- Data invariants：
  - 內容具有穩定身分、語言、文字與可選行範圍。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-content`
  - `文件與資料頁布局` (`FAM-LAYOUT-PAGE`).`page-content`
  - `相鄰區域布局` (`FAM-LAYOUT-SPLIT`).`primary-content`
- Child roles：
  - `content`（`1..unbounded`；`consumer-semantic`）：程式文字與行內技術語意。
    - 接受：`FAM-DOC-INLINE-CODE`、`FAM-DOC-TEXT`

### 文字差異閱讀 (`FAM-DOC-DIFF-VIEWER`)

- Consumer job：閱讀兩份文字內容之間的差異。
- Event contract：以diff intent回報展開、複製或定位。
- Lifecycle contract：產品擁有版本內容；Kallopis管理對齊、scroll與虛擬化。
- Legacy members（1）：`KlpDiffViewer`
- Data invariants：
  - 左右版本、hunk與line具有穩定身分及差異類型。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-content`
  - `文件與資料頁布局` (`FAM-LAYOUT-PAGE`).`page-content`
  - `相鄰區域布局` (`FAM-LAYOUT-SPLIT`).`primary-content`
- Child roles：
  - `annotations`（`0..unbounded`；`consumer-semantic`）：差異內容的說明與技術文字。
    - 接受：`FAM-DATA-ANNOTATION`、`FAM-DOC-INLINE-CODE`、`FAM-DOC-TEXT`

### 文件身分標頭 (`FAM-DOC-HEADER`)

- Consumer job：呈現文件的身分、標題與主要狀態。
- Event contract：以document header intent回報標題或主要操作。
- Lifecycle contract：隨文件projection更新；Kallopis管理編輯焦點與壓縮呈現。
- Legacy members（1）：`KlpDocumentHeader`
- Data invariants：
  - 文件具有穩定身分、標題、狀態與主要屬性。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-header`
  - `文件與資料頁布局` (`FAM-LAYOUT-PAGE`).`page-header`
- Child roles：
  - `identity`（`1..unbounded`；`fixed`）：文件標題、欄位、引用、屬性與狀態摘要。
    - 接受：`FAM-DATA-ANNOTATION`、`FAM-DOC-FIELD`、`FAM-DOC-PROPERTY-SUMMARY`、`FAM-DOC-REFERENCE`、`FAM-DOC-TEXT`、`FAM-FEEDBACK-SAVE-STATUS`

### 終端紀錄閱讀 (`FAM-DOC-TERMINAL`)

- Consumer job：閱讀命令、輸出與紀錄形成的終端內容。
- Event contract：以terminal intent回報複製、清除或核准輸入。
- Lifecycle contract：host擁有process與歷史；Kallopis管理scroll與選取。
- Legacy members（1）：`KlpTerminal`
- Data invariants：
  - entry具有穩定序號、來源、文字與時間。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-content`
  - `文件與資料頁布局` (`FAM-LAYOUT-PAGE`).`page-content`
  - `相鄰區域布局` (`FAM-LAYOUT-SPLIT`).`primary-content`
- Child roles：
  - `entries`（`0..unbounded`；`consumer-semantic`）：終端命令與輸出文字。
    - 接受：`FAM-DOC-INLINE-CODE`、`FAM-DOC-TEXT`、`FAM-FEEDBACK-STATUS`

### 阻斷式工作進度 (`FAM-FEEDBACK-PROGRESS-OVERLAY`)

- Consumer job：在工作進行期間暫時限制其他操作並說明進度。
- Event contract：以progress overlay intent回報取消或查看詳情。
- Lifecycle contract：隨host工作狀態出現與移除；Kallopis管理focus trap。
- Legacy members（1）：`KlpProgressOverlay`
- Data invariants：
  - 工作具有穩定身分、進度、訊息與可取消狀態。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-overlays`
  - `文件與資料頁布局` (`FAM-LAYOUT-PAGE`).`page-feedback`
- Child roles：
  - `progress`（`1..unbounded`；`fixed`）：目前工作的進度與狀態。
    - 接受：`FAM-FEEDBACK-INLINE-NOTICE`、`FAM-FEEDBACK-PROGRESS`、`FAM-FEEDBACK-STATUS`

### 檔案階層瀏覽 (`FAM-FILE-EXPLORER`)

- Consumer job：瀏覽資料夾與檔案資產並提交檔案操作。
- Event contract：以file explorer intent回報展開、選取、開啟與命令。
- Lifecycle contract：host擁有檔案資料；Kallopis管理focus、virtualization與controller lease。
- Legacy members（1）：`KlpFileExplorer`
- Data invariants：
  - 資料夾與資產具有穩定身分、parent關係、類型與狀態。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-content`
  - `相鄰區域布局` (`FAM-LAYOUT-SPLIT`).`primary-content`
- Child roles：
  - `assets`（`0..unbounded`；`consumer-semantic`）：檔案與資料夾的階層資料。
    - 接受：`FAM-DATA-TREE-ITEM`、`FAM-FILE-EXPLORER-SECTION`

### 檔案內容預覽 (`FAM-FILE-PREVIEW`)

- Consumer job：在開啟前預覽檔案資產的內容或摘要。
- Event contract：以preview intent回報開啟、下載或切換資產。
- Lifecycle contract：資產解析由host提供；Kallopis管理preview resource lease。
- Legacy members（1）：`KlpFilePreview`
- Data invariants：
  - 資產具有穩定身分、類型、metadata與可預覽內容。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-content`
  - `文件與資料頁布局` (`FAM-LAYOUT-PAGE`).`page-content`
  - `相鄰區域布局` (`FAM-LAYOUT-SPLIT`).`secondary-content`
- Child roles：
  - `metadata`（`0..unbounded`；`fixed`）：檔案摘要與狀態資料。
    - 接受：`FAM-DATA-ANNOTATION`、`FAM-DOC-TEXT`、`FAM-FEEDBACK-CONTENT-STATE`、`FAM-FEEDBACK-STATUS`

### 結構化表單 (`FAM-FORM-ASSEMBLY`)

- Consumer job：組織、驗證並提交一組結構化輸入。
- Event contract：以單一form intent回報值變更、欄位操作與提交動作。
- Lifecycle contract：產品擁有表單資料；Kallopis管理focus、IME、validation reveal與controller lease。
- Legacy members（1）：`KlpForm`
- Data invariants：
  - 表單具有穩定欄位身分、值、驗證結果、dirty與submission狀態。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-content`
  - `文件與資料頁布局` (`FAM-LAYOUT-PAGE`).`page-content`
  - `設定頁布局` (`FAM-LAYOUT-SETTINGS`).`settings-content`
  - `相鄰區域布局` (`FAM-LAYOUT-SPLIT`).`primary-content`
- Child roles：
  - `actions`（`1..unbounded`；`consumer-semantic`）：表單提交與流程操作。
    - 接受：`FAM-ACTION-FORM-ACTIONS`、`FAM-ACTION-TRIGGER`
  - `feedback`（`0..unbounded`；`fixed`）：表單層驗證與提示。
    - 接受：`FAM-FEEDBACK-INLINE-NOTICE`、`FAM-FORM-ERROR-SUMMARY`
  - `fields`（`1..unbounded`；`consumer-semantic`）：表單欄位、區段與條件資料。
    - 接受：`FAM-FILE-DROPZONE`、`FAM-FILE-FIELD`、`FAM-FORM-APPROVAL-STEPS`、`FAM-FORM-BOOLEAN`、`FAM-FORM-CODE`、`FAM-FORM-COLOR-ROLE`、`FAM-FORM-COMBOBOX`、`FAM-FORM-COMPOUND`、`FAM-FORM-CONDITIONAL-REGION`、`FAM-FORM-DATE`、`FAM-FORM-DATE-RANGE`、`FAM-FORM-FIELD`、`FAM-FORM-FIELD-GROUP`、`FAM-FORM-MULTI-SELECTION`、`FAM-FORM-NUMERIC`、`FAM-FORM-PASSWORD`、`FAM-FORM-PHASE`、`FAM-FORM-SINGLE-SELECTION`、`FAM-FORM-TAG-VALUES`、`FAM-FORM-TEXT`、`FAM-FORM-TEXT-AREA`、`FAM-FORM-TRI-STATE`

### 鍵值資料輸入 (`FAM-FORM-KEY-VALUE-EDITOR`)

- Consumer job：新增、刪除並編輯成對的名稱與值。
- Event contract：以key-value intent回報新增、移除、重排與值變更。
- Lifecycle contract：產品擁有資料；Kallopis管理欄位focus與重排。
- Legacy members（1）：`KlpKeyValueEditor`
- Data invariants：
  - 每筆鍵值具有穩定身分、名稱、值、順序與validation。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-content`
  - `相鄰區域布局` (`FAM-LAYOUT-SPLIT`).`secondary-content`
- Child roles：
  - `fields`（`2..unbounded`；`consumer-semantic`）：鍵與值的輸入資料。
    - 接受：`FAM-FORM-FIELD`、`FAM-FORM-TEXT`

### 互斥候選輸入群組 (`FAM-FORM-RADIO-SELECTION`)

- Consumer job：從一組互斥候選中輸入單一值。
- Event contract：以single selection intent回報選取值。
- Lifecycle contract：值由產品擁有；Kallopis管理group focus與keyboard movement。
- Legacy members（1）：`KlpRadioGroup`
- Data invariants：
  - 候選具有穩定身分、label、可用狀態與目前值。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-content`
- Child roles：
  - `options`（`2..unbounded`；`consumer-semantic`）：互斥候選的語意資料。
    - 接受：`FAM-FORM-SINGLE-SELECTION`

### 產品主體引用選取 (`FAM-FORM-REFERENCE-PICKER`)

- Consumer job：搜尋並選取可被目前資料引用的產品主體。
- Event contract：以reference picker intent回報query、選取、清除或開啟。
- Lifecycle contract：產品擁有候選與值；Kallopis管理搜尋、popover與focus。
- Legacy members（2）：`KlpEntityPicker`、`KlpReferencePicker`
- Data invariants：
  - 候選主體具有穩定身分、label、摘要、query與選取狀態。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-content`
  - `相鄰區域布局` (`FAM-LAYOUT-SPLIT`).`secondary-content`
- Child roles：
  - `results`（`0..unbounded`；`consumer-semantic`）：可引用主體的搜尋結果。
    - 接受：`FAM-DATA-AVATAR`、`FAM-DATA-LIST-ITEM`、`FAM-FEEDBACK-CONTENT-STATE`

### 重複欄位集合 (`FAM-FORM-REPEATER`)

- Consumer job：新增、移除與重排同型態輸入項目。
- Event contract：以repeater intent回報新增、移除、重排與值變更。
- Lifecycle contract：產品擁有項目資料；Kallopis管理重排與focus restoration。
- Legacy members（1）：`KlpRepeaterField`
- Data invariants：
  - 項目具有穩定身分、封閉欄位schema、順序與validation。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-content`
- Child roles：
  - `item-fields`（`1..unbounded`；`consumer-semantic`）：每筆重複項目的封閉欄位資料。
    - 接受：`FAM-FORM-COMPOUND`、`FAM-FORM-FIELD`、`FAM-FORM-FIELD-GROUP`

### 工作區面板標頭 (`FAM-LAYOUT-PANEL-HEADER`)

- Consumer job：呈現工作區面板的名稱、狀態與局部操作。
- Event contract：以panel intent回報收合、移動或局部操作。
- Lifecycle contract：隨panel projection更新；Kallopis管理drag與壓縮呈現。
- Legacy members（1）：`KlpPanelHeader`
- Data invariants：
  - 面板具有穩定身分、標題、狀態與可用操作。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-header`
- Child roles：
  - `panel-controls`（`0..unbounded`；`fixed`）：面板狀態與局部操作。
    - 接受：`FAM-ACTION-TRIGGER`、`FAM-FEEDBACK-STATUS`、`FAM-LAYOUT-DOCK-HEADER`、`FAM-LAYOUT-PANE-COLLAPSE`

### 階層位置路徑 (`FAM-NAV-BREADCRUMB`)

- Consumer job：呈現目前位置的階層路徑並允許返回上層。
- Event contract：以navigation intent回報選取的ancestor destination。
- Lifecycle contract：路徑隨route projection更新；Kallopis管理壓縮與overflow。
- Legacy members（1）：`KlpBreadcrumb`
- Data invariants：
  - 每個segment具有穩定目的地身分、label與目前位置狀態。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-navigation`
  - `文件與資料頁布局` (`FAM-LAYOUT-PAGE`).`page-header`
- Child roles：
  - `destinations`（`1..unbounded`；`consumer-semantic`）：目前位置及其祖先目的地。
    - 接受：`FAM-NAV-DESTINATION`

### 階層探索器 (`FAM-NAV-EXPLORER`)

- Consumer job：瀏覽階層資料並提交選取、展開與命令意圖。
- Event contract：以單一explorer intent回報選取、展開、reveal與命令。
- Lifecycle contract：產品擁有資料；Kallopis管理focus、virtualization與controller lease。
- Legacy members（1）：`KlpExplorer`
- Data invariants：
  - item具有穩定身分、parent關係、選取、展開與命令能力。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-navigation`
  - `相鄰區域布局` (`FAM-LAYOUT-SPLIT`).`secondary-content`
- Child roles：
  - `items`（`0..unbounded`；`consumer-semantic`）：可探索的階層項目。
    - 接受：`FAM-DATA-TREE-ITEM`、`FAM-NAV-DESTINATION-GROUP`

### 分頁集合導覽 (`FAM-NAV-PAGINATION`)

- Consumer job：在分頁資料集合之間移動並描述目前位置。
- Event contract：以pagination intent回報目標頁或方向。
- Lifecycle contract：產品擁有page state；Kallopis管理焦點與壓縮呈現。
- Legacy members（1）：`KlpPagination`
- Data invariants：
  - 目前頁、總頁數、可用方向與page size具有穩定語意。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-navigation`
- Child roles：
  - 無。

### 主要位置導覽 (`FAM-NAV-PRIMARY`)

- Consumer job：組織並切換應用主要位置與側邊導覽群組。
- Event contract：以navigation intent回報目的地身分。
- Lifecycle contract：產品擁有route state；Kallopis管理focus、collapse與responsive view。
- Legacy members（2）：`KlpNavigationRail`、`KlpNavigator`
- Data invariants：
  - 目的地與群組具有穩定身分、selected、enabled與語意順序。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-navigation`
- Child roles：
  - `destinations`（`1..unbounded`；`consumer-semantic`）：主要位置與導覽群組。
    - 接受：`FAM-NAV-DESTINATION`、`FAM-NAV-DESTINATION-GROUP`、`FAM-NAV-SECTION-LABEL`

### 同層內容分頁 (`FAM-NAV-TABS`)

- Consumer job：在同一位置切換多個同層內容檢視。
- Event contract：以tab selection intent回報目標身分。
- Lifecycle contract：產品擁有selected state；Kallopis管理overflow、focus與drag。
- Legacy members（1）：`KlpTabs`
- Data invariants：
  - tab具有穩定身分、label、selected、enabled與產品順序。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-navigation`
- Child roles：
  - `tabs`（`1..unbounded`；`consumer-semantic`）：可切換的同層內容目的地。
    - 接受：`FAM-NAV-DESTINATION`

### 上下文操作表面 (`FAM-OVERLAY-CONTEXT-MENU`)

- Consumer job：在目前指向內容旁提供核准操作。
- Event contract：以context menu intent回報動作或dismiss。
- Lifecycle contract：Kallopis管理anchor、focus與outside/Escape關閉。
- Legacy members（1）：`KlpContextMenu`
- Data invariants：
  - anchor context、動作集合與可用狀態具有穩定身分。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-overlays`
- Child roles：
  - `items`（`1..unbounded`；`consumer-semantic`）：目前上下文可執行的選單項目。
    - 接受：`FAM-ACTION-MENU-ITEM`

### 需要回應的暫態流程 (`FAM-OVERLAY-DIALOG`)

- Consumer job：以需要回應的暫態表面承載訊息或操作流程。
- Event contract：以dialog intent回報動作、提交或dismiss。
- Lifecycle contract：Kallopis管理overlay lease、focus trap與dismiss policy。
- Legacy members（1）：`KlpDialog`
- Data invariants：
  - dialog具有穩定身分、標題、狀態、核准內容kind與動作。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-overlays`
- Child roles：
  - `actions`（`1..unbounded`；`consumer-semantic`）：dialog核准回應操作。
    - 接受：`FAM-ACTION-TRIGGER`
  - `content`（`1..unbounded`；`fixed`）：dialog訊息與狀態資料。
    - 接受：`FAM-DOC-RICH-TEXT`、`FAM-DOC-TEXT`、`FAM-FEEDBACK-CONTENT-STATE`、`FAM-FEEDBACK-INLINE-NOTICE`

### 邊緣暫態面板 (`FAM-OVERLAY-DRAWER`)

- Consumer job：從畫面邊緣顯示可暫時開關的核准功能內容。
- Event contract：以drawer intent回報內容操作或dismiss。
- Lifecycle contract：Kallopis管理placement、focus、veil與responsive sizing。
- Legacy members（1）：`KlpDrawer`
- Data invariants：
  - drawer具有穩定身分、核准content kind與open state。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-overlays`
- Child roles：
  - `content-summary`（`1..unbounded`；`consumer-semantic`）：drawer內的摘要、導覽或操作資料。
    - 接受：`FAM-ACTION-TRIGGER`、`FAM-DATA-LIST-ITEM`、`FAM-DOC-RICH-TEXT`、`FAM-NAV-DESTINATION`、`FAM-NAV-DESTINATION-GROUP`

### 錨點補充表面 (`FAM-OVERLAY-POPOVER`)

- Consumer job：在錨點旁暫時顯示補充資料或操作。
- Event contract：以popover intent回報內容操作或dismiss。
- Lifecycle contract：Kallopis管理placement、collision、focus與outside/Escape關閉。
- Legacy members（1）：`KlpPopover`
- Data invariants：
  - popover具有anchor identity、核准content kind與open state。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-overlays`
- Child roles：
  - `content-summary`（`1..unbounded`；`consumer-semantic`）：錨點相關的補充資料與操作。
    - 接受：`FAM-ACTION-TRIGGER`、`FAM-DATA-LIST-ITEM`、`FAM-DOC-RICH-TEXT`、`FAM-DOC-TEXT`、`FAM-FEEDBACK-INLINE-NOTICE`

### 日期與月曆規劃 (`FAM-PLAN-CALENDAR`)

- Consumer job：以日期結構瀏覽、選取並定位排程資料。
- Event contract：以calendar intent回報日期選取、期間切換或項目開啟。
- Lifecycle contract：產品擁有日期與排程資料；Kallopis管理grid與focus。
- Legacy members（2）：`KlpCalendar`、`KlpDateGrid`
- Data invariants：
  - 日期、可見期間、選取值與日期項目具有穩定語意。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-content`
  - `相鄰區域布局` (`FAM-LAYOUT-SPLIT`).`primary-content`
- Child roles：
  - `date-status`（`0..unbounded`；`consumer-semantic`）：日期上的狀態與工作摘要。
    - 接受：`FAM-DATA-ANNOTATION`、`FAM-FEEDBACK-STATUS`、`FAM-PLAN-WORKFLOW-PROGRESS`

### 時間排序排程 (`FAM-PLAN-SCHEDULE`)

- Consumer job：按時間順序瀏覽排程項目。
- Event contract：以schedule intent回報選取、開啟或時間操作。
- Lifecycle contract：產品擁有排程資料；Kallopis管理分組與虛擬化。
- Legacy members（1）：`KlpScheduleList`
- Data invariants：
  - 項目具有穩定身分、開始、結束、狀態與時間順序。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-content`
  - `相鄰區域布局` (`FAM-LAYOUT-SPLIT`).`secondary-content`
- Child roles：
  - `entries`（`0..unbounded`；`consumer-semantic`）：排程項目與狀態摘要。
    - 接受：`FAM-DATA-ANNOTATION`、`FAM-DATA-LIST-ITEM`、`FAM-FEEDBACK-STATUS`

### 順序流程步驟 (`FAM-PLAN-STEPPER`)

- Consumer job：呈現並導引具有明確先後順序的流程步驟。
- Event contract：以step intent回報前往、返回或啟用步驟。
- Lifecycle contract：產品擁有流程state；Kallopis管理focus與responsive orientation。
- Legacy members（1）：`KlpStepper`
- Data invariants：
  - 步驟具有穩定身分、順序、目前、完成與可用狀態。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-content`
- Child roles：
  - `step-status`（`1..unbounded`；`consumer-semantic`）：步驟的狀態與進度資料。
    - 接受：`FAM-FEEDBACK-STATUS`、`FAM-PLAN-WORKFLOW-PROGRESS`

### 任務集合 (`FAM-PLAN-TASKS`)

- Consumer job：呈現並操作具有完成狀態的任務集合。
- Event contract：以task intent回報完成、開啟、選取或核准重排。
- Lifecycle contract：產品擁有任務資料；Kallopis管理focus與虛擬化。
- Legacy members（1）：`KlpTaskList`
- Data invariants：
  - 任務具有穩定身分、標題、完成、優先級與產品順序。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-content`
  - `相鄰區域布局` (`FAM-LAYOUT-SPLIT`).`primary-content`
- Child roles：
  - `tasks`（`0..unbounded`；`consumer-semantic`）：任務摘要、狀態與標記。
    - 接受：`FAM-DATA-ANNOTATION`、`FAM-DATA-LIST-ITEM`、`FAM-FEEDBACK-STATUS`

### 時間軸事件 (`FAM-PLAN-TIMELINE`)

- Consumer job：沿時間順序呈現事件、里程碑或活動。
- Event contract：以timeline intent回報選取、開啟或定位。
- Lifecycle contract：產品擁有事件資料；Kallopis管理分組與虛擬化。
- Legacy members（1）：`KlpTimeline`
- Data invariants：
  - 事件具有穩定身分、時間、類型、內容與時間順序。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-content`
  - `相鄰區域布局` (`FAM-LAYOUT-SPLIT`).`secondary-content`
- Child roles：
  - `events`（`0..unbounded`；`consumer-semantic`）：時間軸事件的摘要與狀態。
    - 接受：`FAM-DATA-ANNOTATION`、`FAM-DATA-CARD`、`FAM-FEEDBACK-STATUS`

### 工作流程狀態內容 (`FAM-PLAN-WORKFLOW-STATE`)

- Consumer job：呈現工作流程某一狀態的內容與可用操作。
- Event contract：以workflow intent回報transition或核准操作。
- Lifecycle contract：產品擁有state machine；Kallopis管理呈現與focus。
- Legacy members（1）：`KlpWorkflowStateSurface`
- Data invariants：
  - 流程具有穩定身分、封閉狀態、說明與可用transition。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-content`
- Child roles：
  - `actions`（`0..unbounded`；`consumer-semantic`）：目前狀態允許的transition操作。
    - 接受：`FAM-ACTION-TRIGGER`
  - `state`（`1..unbounded`；`fixed`）：流程狀態、說明與進度。
    - 接受：`FAM-DOC-RICH-TEXT`、`FAM-FEEDBACK-INLINE-NOTICE`、`FAM-FEEDBACK-STATUS`、`FAM-PLAN-WORKFLOW-PROGRESS`

### 資料篩選條件 (`FAM-SEARCH-FILTER`)

- Consumer job：集中描述目前資料檢視可用的篩選條件。
- Event contract：以filter intent回報條件值、清除或套用。
- Lifecycle contract：產品擁有filter state；Kallopis管理輸入與responsive grouping。
- Legacy members（1）：`KlpFilterBar`
- Data invariants：
  - 條件具有穩定身分、值、可用狀態與套用順序。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-navigation`
- Child roles：
  - `criteria`（`1..unbounded`；`consumer-semantic`）：篩選值、查詢、命中與檢視選項。
    - 接受：`FAM-FORM-BOOLEAN`、`FAM-FORM-DATE`、`FAM-FORM-DATE-RANGE`、`FAM-FORM-MULTI-SELECTION`、`FAM-FORM-SINGLE-SELECTION`、`FAM-FORM-TEXT`、`FAM-NAV-VIEW-SWITCHER`、`FAM-SEARCH-NAVIGATOR`、`FAM-SEARCH-SORT`

### 設定流程操作 (`FAM-SETTINGS-ACTIONS`)

- Consumer job：呈現設定變更的套用、取消或重設操作。
- Event contract：以settings action intent回報apply、cancel或reset。
- Lifecycle contract：設定權威由產品擁有；Kallopis管理focus與loading。
- Legacy members（1）：`KlpSettingsActionBar`
- Data invariants：
  - dirty、submitting、可套用與可重設狀態由設定projection提供。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-actions`
  - `設定頁布局` (`FAM-LAYOUT-SETTINGS`).`settings-actions`
- Child roles：
  - `actions`（`1..unbounded`；`fixed`）：設定流程的核准操作。
    - 接受：`FAM-ACTION-TRIGGER`

### 設定內容區 (`FAM-SETTINGS-CONTENT`)

- Consumer job：承載目前選取設定頁的欄位與狀態。
- Event contract：以settings content intent回報值變更與欄位操作。
- Lifecycle contract：產品擁有設定資料；Kallopis管理scroll、focus與reveal。
- Legacy members（1）：`KlpSettingsContentPane`
- Data invariants：
  - 頁面、欄位、值、validation與dirty state具有穩定身分。
- Accepted by：
  - `設定頁布局` (`FAM-LAYOUT-SETTINGS`).`settings-content`
- Child roles：
  - `fields`（`1..unbounded`；`consumer-semantic`）：設定值、搜尋與偏好欄位。
    - 接受：`FAM-FEEDBACK-INLINE-NOTICE`、`FAM-SETTINGS-FIELD`、`FAM-SETTINGS-SEARCH`、`FAM-SETTINGS-THEME-PREFERENCE`

### 設定暫態流程 (`FAM-SETTINGS-DIALOG`)

- Consumer job：在暫態視窗中完成應用或工作區設定。
- Event contract：以settings dialog intent回報值、套用、取消與dismiss。
- Lifecycle contract：Kallopis管理overlay與focus；產品擁有設定值。
- Legacy members（1）：`KlpSettingsDialog`
- Data invariants：
  - scope、頁面、dirty與submission state由設定projection提供。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-overlays`
  - `設定頁布局` (`FAM-LAYOUT-SETTINGS`).`settings-overlay`
- Child roles：
  - `actions`（`1..unbounded`；`fixed`）：設定暫態流程操作。
    - 接受：`FAM-ACTION-TRIGGER`
  - `fields`（`1..unbounded`；`consumer-semantic`）：暫態設定欄位資料。
    - 接受：`FAM-SETTINGS-FIELD`、`FAM-SETTINGS-SCOPE`、`FAM-SETTINGS-THEME-PREFERENCE`

### 設定頁導覽 (`FAM-SETTINGS-NAVIGATION`)

- Consumer job：承載設定分類、scope與頁面切換入口。
- Event contract：以settings navigation intent回報目的地或scope。
- Lifecycle contract：產品擁有selected page/scope；Kallopis管理focus與responsive pane。
- Legacy members（1）：`KlpSettingsNavigationPane`
- Data invariants：
  - 目的地與群組具有穩定身分、selected與scope關係。
- Accepted by：
  - `可停駐工作區布局` (`FAM-LAYOUT-DOCK`).`workspace-navigation`
  - `設定頁布局` (`FAM-LAYOUT-SETTINGS`).`settings-navigation`
- Child roles：
  - `destinations`（`1..unbounded`；`consumer-semantic`）：設定群組與頁面目的地。
    - 接受：`FAM-NAV-DESTINATION`、`FAM-NAV-DESTINATION-GROUP`
  - `scope`（`0..1`；`fixed`）：目前修改的設定作用範圍。
    - 接受：`FAM-SETTINGS-SCOPE`
  - `search`（`0..1`；`fixed`）：設定頁面與欄位搜尋。
    - 接受：`FAM-SETTINGS-SEARCH`

## `element` families — 68

### 表單流程動作 (`FAM-ACTION-FORM-ACTIONS`)

- Consumer job：描述表單提交、取消與次要流程操作。
- Event contract：由表單container的單一intent回報動作身分。
- Lifecycle contract：隨表單projection建立，不保存提交狀態。
- Legacy members（1）：`KlpFormActions`
- Data invariants：
  - 動作保留身分、語意優先級與可用狀態。
- Accepted by：
  - `結構化表單` (`FAM-FORM-ASSEMBLY`).`actions`
- Child roles：
  - 無。

### 選單動作項目 (`FAM-ACTION-MENU-ITEM`)

- Consumer job：描述選單中的一個操作、狀態或子命令入口。
- Event contract：由選單container統一回報項目intent。
- Lifecycle contract：項目是不可變資料，不保存焦點或展開權威。
- Legacy members（1）：`KlpMenuItem`
- Data invariants：
  - 項目具有穩定身分、標籤、狀態與命令關係。
- Accepted by：
  - `選單動作集合` (`FAM-ACTION-MENU`).`items`
  - `上下文操作表面` (`FAM-OVERLAY-CONTEXT-MENU`).`items`
- Child roles：
  - 無。

### 語意動作入口 (`FAM-ACTION-TRIGGER`)

- Consumer job：觸發一項具名稱與輔助語意的產品操作。
- Event contract：由owning container以單一intent回報動作身分。
- Lifecycle contract：操作是不可變資料；hover、focus與press由Kallopis管理。
- Legacy members（2）：`KlpButton`、`KlpIconButton`
- Data invariants：
  - 操作具有穩定身分、標籤、重要性與可用狀態。
- Accepted by：
  - `文件編輯動作群組` (`FAM-ACTION-DOCUMENT-EDIT`).`actions`
  - `編輯器工具群組` (`FAM-ACTION-EDITOR-TOOLS`).`tools`
  - `語意動作群組` (`FAM-ACTION-GROUP`).`actions`
  - `選取內容動作` (`FAM-ACTION-SELECTION`).`actions`
  - `主要工作內容標頭` (`FAM-APP-STAGE-HEADER`).`actions`
  - `畫布工具群組` (`FAM-CANVAS-TOOLS`).`tools`
  - `訊息撰寫` (`FAM-COLLAB-MESSAGE-COMPOSER`).`actions`
  - `結構化表單` (`FAM-FORM-ASSEMBLY`).`actions`
  - `工作區面板標頭` (`FAM-LAYOUT-PANEL-HEADER`).`panel-controls`
  - `需要回應的暫態流程` (`FAM-OVERLAY-DIALOG`).`actions`
  - `邊緣暫態面板` (`FAM-OVERLAY-DRAWER`).`content-summary`
  - `錨點補充表面` (`FAM-OVERLAY-POPOVER`).`content-summary`
  - `工作流程狀態內容` (`FAM-PLAN-WORKFLOW-STATE`).`actions`
  - `設定流程操作` (`FAM-SETTINGS-ACTIONS`).`actions`
  - `設定暫態流程` (`FAM-SETTINGS-DIALOG`).`actions`
- Child roles：
  - 無。

### 畫布拖放意圖 (`FAM-CANVAS-DROP-INTENT`)

- Consumer job：描述空間畫布上的拖放目標與預定動作。
- Event contract：由畫布container統一回報drop intent。
- Lifecycle contract：只在目前drag session有效，由Kallopis清除暫態回饋。
- Legacy members（1）：`KlpCanvasDropIntent`
- Data invariants：
  - 拖放意圖具有目標身分、允許動作與空間語意。
- Accepted by：
  - `空間畫布` (`FAM-CANVAS-VIEWPORT`).`overlays`
- Child roles：
  - 無。

### 流程畫布節點 (`FAM-CANVAS-FLOW-NODE`)

- Consumer job：描述流程畫布上一個可辨識且可連接的節點。
- Event contract：由畫布container回報選取、移動與連接intent。
- Lifecycle contract：產品擁有節點資料；Kallopis管理drag preview與selection。
- Legacy members（1）：`KlpFlowNodeCard`
- Data invariants：
  - 節點具有穩定身分、類型、位置資料與連接埠資料。
- Accepted by：
  - `空間畫布` (`FAM-CANVAS-VIEWPORT`).`nodes`
- Child roles：
  - 無。

### 流程結構驗證摘要 (`FAM-CANVAS-FLOW-VALIDATION`)

- Consumer job：描述流程畫布目前的結構問題與修正線索。
- Event contract：由畫布container回報定位或修正intent。
- Lifecycle contract：驗證結果隨產品流程資料更新，不保存第二份問題權威。
- Legacy members（1）：`KlpFlowValidationPanel`
- Data invariants：
  - 問題具有穩定身分、嚴重度、關聯節點與說明。
- Accepted by：
  - `空間畫布` (`FAM-CANVAS-VIEWPORT`).`overlays`
- Child roles：
  - 無。

### 畫布定位概覽 (`FAM-CANVAS-MINIMAP`)

- Consumer job：概覽大型空間畫布並協助定位目前視口。
- Event contract：由畫布container回報reveal或viewport intent。
- Lifecycle contract：隨畫布projection更新；縮放與拖曳暫態由Kallopis管理。
- Legacy members（1）：`KlpCanvasMinimap`
- Data invariants：
  - 概覽使用與主畫布相同節點身分、邊界與視口資料。
- Accepted by：
  - `空間畫布` (`FAM-CANVAS-VIEWPORT`).`overlays`
- Child roles：
  - 無。

### 訊息資料 (`FAM-COLLAB-MESSAGE`)

- Consumer job：描述單一參與者的一則訊息內容。
- Event contract：由conversation container回報訊息層intent。
- Lifecycle contract：訊息是產品projection；Kallopis不保存第二份對話資料。
- Legacy members（1）：`KlpMessageBubble`
- Data invariants：
  - 訊息具有穩定身分、作者、時間、內容與傳送狀態。
- Accepted by：
  - `訊息對話` (`FAM-COLLAB-CONVERSATION`).`messages`
- Child roles：
  - 無。

### 參與狀態 (`FAM-COLLAB-PRESENCE`)

- Consumer job：描述參與者目前在線、離開或活動狀態。
- Event contract：由owning container回報參與者intent；presence本身不持有callback。
- Lifecycle contract：隨協作projection更新，不自行建立presence權威。
- Legacy members（1）：`KlpPresenceIndicator`
- Data invariants：
  - presence以參與者身分、封閉狀態與最後活動摘要表示。
- Accepted by：
  - `訊息對話` (`FAM-COLLAB-CONVERSATION`).`participants`
- Child roles：
  - 無。

### 資料短標記 (`FAM-DATA-ANNOTATION`)

- Consumer job：以短文字或數量標示資料分類與屬性。
- Event contract：由owning container回報標記intent；無互動時不產生event。
- Lifecycle contract：標記是不可變projection，不保存選取狀態。
- Legacy members（2）：`KlpBadge`、`KlpTag`
- Data invariants：
  - 標記具有穩定文字、封閉語意角色與可選數量。
- Accepted by：
  - `主要工作內容標頭` (`FAM-APP-STAGE-HEADER`).`identity`
  - `應用狀態列` (`FAM-APP-STATUS-BAR`).`status-items`
  - `結構化資料表` (`FAM-DATA-TABLE`).`cell-content`
  - `文字差異閱讀` (`FAM-DOC-DIFF-VIEWER`).`annotations`
  - `文件身分標頭` (`FAM-DOC-HEADER`).`identity`
  - `檔案內容預覽` (`FAM-FILE-PREVIEW`).`metadata`
  - `日期與月曆規劃` (`FAM-PLAN-CALENDAR`).`date-status`
  - `時間排序排程` (`FAM-PLAN-SCHEDULE`).`entries`
  - `任務集合` (`FAM-PLAN-TASKS`).`tasks`
  - `時間軸事件` (`FAM-PLAN-TIMELINE`).`events`
- Child roles：
  - 無。

### 主體識別摘要 (`FAM-DATA-AVATAR`)

- Consumer job：以圖像或替代標識呈現一個或多個人物或主體。
- Event contract：由owning container回報主體intent。
- Lifecycle contract：圖像解析由Kallopis資產管線管理；主體資料由產品更新。
- Legacy members（2）：`KlpAvatar`、`KlpAvatarGroup`
- Data invariants：
  - 主體具有穩定身分、替代名稱、圖像來源與語意順序。
- Accepted by：
  - `工作區身分標頭` (`FAM-APP-IDENTITY-HEADER`).`identity`
  - `訊息對話` (`FAM-COLLAB-CONVERSATION`).`participants`
  - `結構化資料表` (`FAM-DATA-TABLE`).`cell-content`
  - `產品主體引用選取` (`FAM-FORM-REFERENCE-PICKER`).`results`
- Child roles：
  - 無。

### 內容摘要卡 (`FAM-DATA-CARD`)

- Consumer job：以具邊界摘要呈現一項可開啟資料或內容。
- Event contract：由owning container回報開啟或選取intent。
- Lifecycle contract：卡片是不可變projection；hover與focus由Kallopis管理。
- Legacy members（2）：`KlpCard`、`KlpPreviewCard`
- Data invariants：
  - 卡片具有穩定身分、標題、摘要、狀態與開啟能力。
- Accepted by：
  - `時間軸事件` (`FAM-PLAN-TIMELINE`).`events`
- Child roles：
  - 無。

### 集合資料項目 (`FAM-DATA-LIST-ITEM`)

- Consumer job：描述集合中一筆可辨識、可選取的資料。
- Event contract：由owning container統一回報item intent。
- Lifecycle contract：項目是不可變projection；renderer不保存產品選取權威。
- Legacy members（1）：`KlpListTile`
- Data invariants：
  - 項目具有穩定身分、主要文字、摘要、狀態與選取能力。
- Accepted by：
  - `可展開資料區段` (`FAM-DATA-ACCORDION`).`sections`
  - `鍵值線性清單` (`FAM-DATA-KEY-VALUE-LIST`).`items`
  - `鍵值比較表` (`FAM-DATA-KEY-VALUE-TABLE`).`cells`
  - `結構化資料表` (`FAM-DATA-TABLE`).`cell-content`
  - `產品主體引用選取` (`FAM-FORM-REFERENCE-PICKER`).`results`
  - `邊緣暫態面板` (`FAM-OVERLAY-DRAWER`).`content-summary`
  - `錨點補充表面` (`FAM-OVERLAY-POPOVER`).`content-summary`
  - `時間排序排程` (`FAM-PLAN-SCHEDULE`).`entries`
  - `任務集合` (`FAM-PLAN-TASKS`).`tasks`
- Child roles：
  - 無。

### 關鍵數值摘要 (`FAM-DATA-METRIC`)

- Consumer job：突出呈現一個關鍵數值及其脈絡。
- Event contract：由owning container回報drill-down intent；純摘要不產生event。
- Lifecycle contract：數值隨產品projection更新，不保存統計權威。
- Legacy members（1）：`KlpMetricCard`
- Data invariants：
  - 數值具有穩定身分、單位、比較基準與狀態。
- Accepted by：
  - `結構化資料表` (`FAM-DATA-TABLE`).`cell-content`
- Child roles：
  - 無。

### 階層資料節點 (`FAM-DATA-TREE-ITEM`)

- Consumer job：描述階層資料中的單一節點與展開狀態。
- Event contract：由tree-like container統一回報節點intent。
- Lifecycle contract：領域遞迴留在資料schema，不形成第二棵KLP結構樹。
- Legacy members（1）：`KlpTreeItem`
- Data invariants：
  - 節點具有穩定身分、label、子節點資料、展開與選取狀態。
- Accepted by：
  - `結構化鍵值樹` (`FAM-DATA-JSON-TREE`).`nodes`
  - `階層資料樹` (`FAM-DATA-TREE`).`nodes`
  - `檔案階層瀏覽` (`FAM-FILE-EXPLORER`).`assets`
  - `階層探索器` (`FAM-NAV-EXPLORER`).`items`
- Child roles：
  - 無。

### 文件屬性欄位 (`FAM-DOC-FIELD`)

- Consumer job：描述文件結構中一項具名稱的資料欄位。
- Event contract：由文件container回報欄位intent。
- Lifecycle contract：欄位是文件projection，不保存第二份文件資料。
- Legacy members（1）：`KlpDocumentField`
- Data invariants：
  - 欄位具有穩定身分、名稱、值摘要與可編輯狀態。
- Accepted by：
  - `文件身分標頭` (`FAM-DOC-HEADER`).`identity`
- Child roles：
  - 無。

### 行內程式語意 (`FAM-DOC-INLINE-CODE`)

- Consumer job：在文字內容中描述短小程式或技術片段。
- Event contract：由owning container回報複製或開啟intent。
- Lifecycle contract：片段是不可變內容資料。
- Legacy members（1）：`KlpInlineCode`
- Data invariants：
  - 片段保留文字、語言與可複製語意。
- Accepted by：
  - `程式文字閱讀` (`FAM-DOC-CODE-VIEWER`).`content`
  - `文字差異閱讀` (`FAM-DOC-DIFF-VIEWER`).`annotations`
  - `終端紀錄閱讀` (`FAM-DOC-TERMINAL`).`entries`
- Child roles：
  - 無。

### 文件屬性摘要 (`FAM-DOC-PROPERTY-SUMMARY`)

- Consumer job：摘要呈現文件或主體的重要屬性。
- Event contract：由文件container回報屬性intent。
- Lifecycle contract：摘要隨文件projection更新，不保存編輯權威。
- Legacy members（1）：`KlpPropertySummary`
- Data invariants：
  - 屬性具有穩定名稱、值與語意順序。
- Accepted by：
  - `文件身分標頭` (`FAM-DOC-HEADER`).`identity`
- Child roles：
  - 無。

### 文件內容引用 (`FAM-DOC-REFERENCE`)

- Consumer job：描述文件中可開啟的另一項內容引用。
- Event contract：由文件container回報open reference intent。
- Lifecycle contract：解析結果隨產品資料更新；Kallopis不擁有目標生命週期。
- Legacy members（1）：`KlpDocumentReferenceLink`
- Data invariants：
  - 引用具有穩定目標身分、標籤與可用狀態。
- Accepted by：
  - `文件身分標頭` (`FAM-DOC-HEADER`).`identity`
- Child roles：
  - 無。

### 富文字內容 (`FAM-DOC-RICH-TEXT`)

- Consumer job：閱讀包含多種行內語意與標記的文字內容。
- Event contract：由owning container回報link或selection intent。
- Lifecycle contract：上游內容模型是唯一權威；Kallopis只投影與管理暫態選取。
- Legacy members（1）：`KlpRichText`
- Data invariants：
  - 內容保留block與inline語意、文字及引用身分。
- Accepted by：
  - `需要回應的暫態流程` (`FAM-OVERLAY-DIALOG`).`content`
  - `邊緣暫態面板` (`FAM-OVERLAY-DRAWER`).`content-summary`
  - `錨點補充表面` (`FAM-OVERLAY-POPOVER`).`content-summary`
  - `工作流程狀態內容` (`FAM-PLAN-WORKFLOW-STATE`).`state`
- Child roles：
  - 無。

### 文件語意區段 (`FAM-DOC-SECTION`)

- Consumer job：描述文件內容中具名稱與閱讀順序的區段。
- Event contract：由文件container回報section intent。
- Lifecycle contract：區段屬文件資料schema，不形成任意KLP children。
- Legacy members（1）：`KlpDocumentSection`
- Data invariants：
  - 區段具有穩定身分、標題、內容摘要與閱讀順序。
- Accepted by：
  - `可展開資料區段` (`FAM-DATA-ACCORDION`).`sections`
- Child roles：
  - 無。

### 核准文字內容 (`FAM-DOC-TEXT`)

- Consumer job：以核准文字角色描述一般短文內容。
- Event contract：純文字不產生event；連結由owning container回報。
- Lifecycle contract：文字是不可變projection。
- Legacy members（1）：`KlpText`
- Data invariants：
  - 文字值與語意角色由資料決定，不含局部style。
- Accepted by：
  - `工作區身分標頭` (`FAM-APP-IDENTITY-HEADER`).`identity`
  - `主要工作內容標頭` (`FAM-APP-STAGE-HEADER`).`identity`
  - `桌面視窗標頭` (`FAM-APP-WINDOW-HEADER`).`identity`
  - `鍵值比較表` (`FAM-DATA-KEY-VALUE-TABLE`).`cells`
  - `結構化資料表` (`FAM-DATA-TABLE`).`cell-content`
  - `程式文字閱讀` (`FAM-DOC-CODE-VIEWER`).`content`
  - `文字差異閱讀` (`FAM-DOC-DIFF-VIEWER`).`annotations`
  - `文件身分標頭` (`FAM-DOC-HEADER`).`identity`
  - `終端紀錄閱讀` (`FAM-DOC-TERMINAL`).`entries`
  - `檔案內容預覽` (`FAM-FILE-PREVIEW`).`metadata`
  - `需要回應的暫態流程` (`FAM-OVERLAY-DIALOG`).`content`
  - `錨點補充表面` (`FAM-OVERLAY-POPOVER`).`content-summary`
- Child roles：
  - 無。

### 內容狀態回饋 (`FAM-FEEDBACK-CONTENT-STATE`)

- Consumer job：說明內容為空、載入中、失敗、權限不足或尚未提供。
- Event contract：由owning container回報retry、request或next-step intent。
- Lifecycle contract：狀態隨產品projection切換；Kallopis管理等待呈現。
- Legacy members（5）：`KlpEmptyState`、`KlpErrorState`、`KlpLoadingState`、`KlpPermissionState`、`KlpRegionPlaceholder`
- Data invariants：
  - 狀態具有封閉kind、標題、說明與可選復原動作。
- Accepted by：
  - `檔案內容預覽` (`FAM-FILE-PREVIEW`).`metadata`
  - `產品主體引用選取` (`FAM-FORM-REFERENCE-PICKER`).`results`
  - `需要回應的暫態流程` (`FAM-OVERLAY-DIALOG`).`content`
- Child roles：
  - 無。

### 內容內提示 (`FAM-FEEDBACK-INLINE-NOTICE`)

- Consumer job：在目前內容流內描述重要提示或警告。
- Event contract：由owning container回報提示動作intent。
- Lifecycle contract：提示隨產品狀態加入或移除。
- Legacy members（1）：`KlpInlineNotice`
- Data invariants：
  - 提示具有穩定身分、嚴重度、訊息與可選動作。
- Accepted by：
  - `應用狀態列` (`FAM-APP-STATUS-BAR`).`status-items`
  - `阻斷式工作進度` (`FAM-FEEDBACK-PROGRESS-OVERLAY`).`progress`
  - `結構化表單` (`FAM-FORM-ASSEMBLY`).`feedback`
  - `需要回應的暫態流程` (`FAM-OVERLAY-DIALOG`).`content`
  - `錨點補充表面` (`FAM-OVERLAY-POPOVER`).`content-summary`
  - `工作流程狀態內容` (`FAM-PLAN-WORKFLOW-STATE`).`state`
  - `設定內容區` (`FAM-SETTINGS-CONTENT`).`fields`
- Child roles：
  - 無。

### 工作進度 (`FAM-FEEDBACK-PROGRESS`)

- Consumer job：描述工作目前完成比例或多階段位置。
- Event contract：通常不產生event；取消或詳情由owning container回報。
- Lifecycle contract：隨工作projection更新，完成後由產品移除。
- Legacy members（2）：`KlpProgress`、`KlpSegmentedProgress`
- Data invariants：
  - 進度具有穩定工作身分、已完成量、總量或階段資料。
- Accepted by：
  - `應用狀態列` (`FAM-APP-STATUS-BAR`).`status-items`
  - `阻斷式工作進度` (`FAM-FEEDBACK-PROGRESS-OVERLAY`).`progress`
- Child roles：
  - 無。

### 儲存狀態摘要 (`FAM-FEEDBACK-SAVE-STATUS`)

- Consumer job：描述內容目前的儲存結果、進度或錯誤。
- Event contract：由owning container回報retry或details intent。
- Lifecycle contract：隨上游儲存狀態更新，不建立第二份保存權威。
- Legacy members（1）：`KlpSaveStatusCard`
- Data invariants：
  - 儲存狀態具有內容身分、封閉階段、時間與錯誤摘要。
- Accepted by：
  - `應用狀態列` (`FAM-APP-STATUS-BAR`).`status-items`
  - `文件身分標頭` (`FAM-DOC-HEADER`).`identity`
- Child roles：
  - 無。

### 精簡狀態標識 (`FAM-FEEDBACK-STATUS`)

- Consumer job：以精簡語意描述一項資料目前的狀態。
- Event contract：由owning container回報狀態intent；純指示不產生event。
- Lifecycle contract：狀態是不可變projection。
- Legacy members（1）：`KlpStatusIndicator`
- Data invariants：
  - 狀態具有封閉角色、輔助標籤與可選數量。
- Accepted by：
  - `主要工作內容標頭` (`FAM-APP-STAGE-HEADER`).`identity`
  - `應用狀態列` (`FAM-APP-STATUS-BAR`).`status-items`
  - `結構化資料表` (`FAM-DATA-TABLE`).`cell-content`
  - `終端紀錄閱讀` (`FAM-DOC-TERMINAL`).`entries`
  - `阻斷式工作進度` (`FAM-FEEDBACK-PROGRESS-OVERLAY`).`progress`
  - `檔案內容預覽` (`FAM-FILE-PREVIEW`).`metadata`
  - `工作區面板標頭` (`FAM-LAYOUT-PANEL-HEADER`).`panel-controls`
  - `日期與月曆規劃` (`FAM-PLAN-CALENDAR`).`date-status`
  - `時間排序排程` (`FAM-PLAN-SCHEDULE`).`entries`
  - `順序流程步驟` (`FAM-PLAN-STEPPER`).`step-status`
  - `任務集合` (`FAM-PLAN-TASKS`).`tasks`
  - `時間軸事件` (`FAM-PLAN-TIMELINE`).`events`
  - `工作流程狀態內容` (`FAM-PLAN-WORKFLOW-STATE`).`state`
- Child roles：
  - 無。

### 非阻斷結果通知 (`FAM-FEEDBACK-TOAST`)

- Consumer job：短暫通知一項不需阻斷操作的結果。
- Event contract：由toast host回報動作或dismiss intent。
- Lifecycle contract：Kallopis管理顯示期限與佇列，產品擁有通知資料。
- Legacy members（1）：`KlpToast`
- Data invariants：
  - 通知具有穩定身分、嚴重度、訊息、期限與可選動作。
- Accepted by：
  - `應用狀態列` (`FAM-APP-STATUS-BAR`).`status-items`
- Child roles：
  - 無。

### 檔案拖放輸入 (`FAM-FILE-DROPZONE`)

- Consumer job：透過拖放選取一個或多個檔案資產。
- Event contract：由form或file container回報files selected intent。
- Lifecycle contract：drag session由Kallopis管理；檔案權威由host持有。
- Legacy members（1）：`KlpFileDropzoneField`
- Data invariants：
  - 接受類型、數量限制與目前資產摘要由欄位資料定義。
- Accepted by：
  - `結構化表單` (`FAM-FORM-ASSEMBLY`).`fields`
- Child roles：
  - 無。

### 檔案階層區段 (`FAM-FILE-EXPLORER-SECTION`)

- Consumer job：描述檔案階層中一個具名稱的資料區段。
- Event contract：由file explorer統一回報section intent。
- Lifecycle contract：區段是檔案projection的一部分，不形成KLP結構children。
- Legacy members（1）：`KlpFileExplorerSection`
- Data invariants：
  - 區段具有穩定身分、標題與資產集合關係。
- Accepted by：
  - `檔案階層瀏覽` (`FAM-FILE-EXPLORER`).`assets`
- Child roles：
  - 無。

### 檔案值輸入 (`FAM-FILE-FIELD`)

- Consumer job：在表單中選取並描述一個或多個檔案值。
- Event contract：由form container回報選取、移除或開啟intent。
- Lifecycle contract：檔案資料由host擁有；Kallopis管理picker與暫態上傳狀態。
- Legacy members（1）：`KlpFileField`
- Data invariants：
  - 檔案值具有穩定身分、名稱、類型、大小與驗證狀態。
- Accepted by：
  - `結構化表單` (`FAM-FORM-ASSEMBLY`).`fields`
- Child roles：
  - 無。

### 核准步驟輸入 (`FAM-FORM-APPROVAL-STEPS`)

- Consumer job：輸入並調整具有先後次序的核准步驟。
- Event contract：由form container回報新增、移除、重排與值變更intent。
- Lifecycle contract：產品擁有步驟資料；Kallopis管理拖曳與欄位焦點。
- Legacy members（1）：`KlpApprovalStepsField`
- Data invariants：
  - 步驟具有穩定身分、核准者資料、狀態與工作流程順序。
- Accepted by：
  - `結構化表單` (`FAM-FORM-ASSEMBLY`).`fields`
- Child roles：
  - 無。

### 布林值輸入 (`FAM-FORM-BOOLEAN`)

- Consumer job：輸入一個可開啟、關閉或獨立選取的布林值。
- Event contract：由form container回報boolean value intent。
- Lifecycle contract：值由產品projection擁有；Kallopis管理press與focus。
- Legacy members（3）：`KlpCheckbox`、`KlpCompactSwitch`、`KlpToggle`
- Data invariants：
  - 欄位具有穩定身分、布林值、可用與驗證狀態。
- Accepted by：
  - `結構化表單` (`FAM-FORM-ASSEMBLY`).`fields`
  - `資料篩選條件` (`FAM-SEARCH-FILTER`).`criteria`
- Child roles：
  - 無。

### 程式文字輸入 (`FAM-FORM-CODE`)

- Consumer job：輸入並驗證具程式文字語意的值。
- Event contract：由form container回報文字與編輯intent。
- Lifecycle contract：產品擁有值；Kallopis管理editor host、IME與暫態selection。
- Legacy members（2）：`KlpCodeEditorField`、`KlpCodeField`
- Data invariants：
  - 欄位具有穩定身分、語言、文字、validation與selection projection。
- Accepted by：
  - `結構化表單` (`FAM-FORM-ASSEMBLY`).`fields`
- Child roles：
  - 無。

### 語意色彩角色輸入 (`FAM-FORM-COLOR-ROLE`)

- Consumer job：從核准的語意色彩角色中選取一個值。
- Event contract：由form container回報role selection intent。
- Lifecycle contract：選取值由產品projection更新。
- Legacy members（1）：`KlpColorRoleField`
- Data invariants：
  - 候選是封閉語意角色，不包含自由色值或style override。
- Accepted by：
  - `結構化表單` (`FAM-FORM-ASSEMBLY`).`fields`
- Child roles：
  - 無。

### 可搜尋單選輸入 (`FAM-FORM-COMBOBOX`)

- Consumer job：透過文字查找候選並選取一個值。
- Event contract：由form container回報query與selection intent。
- Lifecycle contract：產品提供候選與值；Kallopis管理popover、focus與IME。
- Legacy members（1）：`KlpCombobox`
- Data invariants：
  - 候選具有穩定身分、label、查詢命中與選取狀態。
- Accepted by：
  - `結構化表單` (`FAM-FORM-ASSEMBLY`).`fields`
- Child roles：
  - 無。

### 複合欄位值 (`FAM-FORM-COMPOUND`)

- Consumer job：把彼此相依的輸入資料組成一個欄位值。
- Event contract：由form container回報compound value intent，不暴露子Widget callback。
- Lifecycle contract：產品擁有複合值；內部欄位組成由Kallopis固定。
- Legacy members（1）：`KlpCompoundField`
- Data invariants：
  - 複合值具有封閉schema、子值身分與整體validation。
- Accepted by：
  - `結構化表單` (`FAM-FORM-ASSEMBLY`).`fields`
  - `重複欄位集合` (`FAM-FORM-REPEATER`).`item-fields`
- Child roles：
  - 無。

### 條件欄位區段 (`FAM-FORM-CONDITIONAL-REGION`)

- Consumer job：依表單資料決定一組已定義欄位是否適用。
- Event contract：欄位事件仍由form container統一回報。
- Lifecycle contract：顯示狀態由projection計算；隱藏策略由Kallopis執行。
- Legacy members（1）：`KlpConditionalFieldRegion`
- Data invariants：
  - 條件、區段身分與核准欄位schema由表單資料定義。
- Accepted by：
  - `結構化表單` (`FAM-FORM-ASSEMBLY`).`fields`
- Child roles：
  - 無。

### 日期輸入 (`FAM-FORM-DATE`)

- Consumer job：輸入或選取單一日期值。
- Event contract：由form container回報date value intent。
- Lifecycle contract：值由產品擁有；Kallopis管理picker與鍵盤輸入。
- Legacy members（1）：`KlpDateField`
- Data invariants：
  - 欄位具有日期值、允許範圍、locale語意與validation。
- Accepted by：
  - `結構化表單` (`FAM-FORM-ASSEMBLY`).`fields`
  - `資料篩選條件` (`FAM-SEARCH-FILTER`).`criteria`
- Child roles：
  - 無。

### 日期範圍輸入 (`FAM-FORM-DATE-RANGE`)

- Consumer job：輸入具有開始與結束的日期範圍。
- Event contract：由form container回報range value intent。
- Lifecycle contract：值由產品擁有；Kallopis管理雙端選取流程。
- Legacy members（1）：`KlpDateRangeField`
- Data invariants：
  - 範圍具有start、end、允許界限與跨欄validation。
- Accepted by：
  - `結構化表單` (`FAM-FORM-ASSEMBLY`).`fields`
  - `資料篩選條件` (`FAM-SEARCH-FILTER`).`criteria`
- Child roles：
  - 無。

### 表單錯誤摘要 (`FAM-FORM-ERROR-SUMMARY`)

- Consumer job：集中描述表單中需要修正的驗證問題。
- Event contract：由form container回報reveal field intent。
- Lifecycle contract：隨validation projection更新，不保存第二份錯誤權威。
- Legacy members（1）：`KlpFormErrorSummary`
- Data invariants：
  - 問題具有欄位身分、訊息、嚴重度與閱讀順序。
- Accepted by：
  - `結構化表單` (`FAM-FORM-ASSEMBLY`).`feedback`
- Child roles：
  - 無。

### 具標籤欄位資料 (`FAM-FORM-FIELD`)

- Consumer job：以一致名稱、說明與錯誤描述一項輸入。
- Event contract：實際值intent由form container依欄位schema回報。
- Lifecycle contract：欄位chrome由Kallopis固定，不接受任意child。
- Legacy members（1）：`KlpField`
- Data invariants：
  - 欄位具有穩定身分、label、description、required與error資料。
- Accepted by：
  - `結構化表單` (`FAM-FORM-ASSEMBLY`).`fields`
  - `鍵值資料輸入` (`FAM-FORM-KEY-VALUE-EDITOR`).`fields`
  - `重複欄位集合` (`FAM-FORM-REPEATER`).`item-fields`
- Child roles：
  - 無。

### 表單欄位區段 (`FAM-FORM-FIELD-GROUP`)

- Consumer job：把語意相關輸入整理成具名稱的表單區段。
- Event contract：欄位事件由form container統一回報。
- Lifecycle contract：區段是表單資料模型，不形成任意KLP children。
- Legacy members（2）：`KlpFieldGroup`、`KlpFormSection`
- Data invariants：
  - 區段具有穩定身分、標題、說明與封閉欄位schema。
- Accepted by：
  - `結構化表單` (`FAM-FORM-ASSEMBLY`).`fields`
  - `重複欄位集合` (`FAM-FORM-REPEATER`).`item-fields`
- Child roles：
  - 無。

### 多值候選輸入 (`FAM-FORM-MULTI-SELECTION`)

- Consumer job：從候選集合中輸入多個已選值。
- Event contract：由form container回報selection set intent。
- Lifecycle contract：產品擁有選取值；Kallopis管理popover與暫態query。
- Legacy members（1）：`KlpMultiSelectField`
- Data invariants：
  - 候選與已選值具有穩定身分、順序、可用與validation狀態。
- Accepted by：
  - `結構化表單` (`FAM-FORM-ASSEMBLY`).`fields`
  - `資料篩選條件` (`FAM-SEARCH-FILTER`).`criteria`
- Child roles：
  - 無。

### 數值輸入 (`FAM-FORM-NUMERIC`)

- Consumer job：輸入具有界限、步進或範圍語意的數值。
- Event contract：由form container回報numeric value intent。
- Lifecycle contract：產品擁有值；Kallopis管理拖曳、按鍵與格式化。
- Legacy members（3）：`KlpNumberField`、`KlpQuantityField`、`KlpSlider`
- Data invariants：
  - 欄位具有數值、單位、min、max、step與validation。
- Accepted by：
  - `結構化表單` (`FAM-FORM-ASSEMBLY`).`fields`
- Child roles：
  - 無。

### 密碼文字輸入 (`FAM-FORM-PASSWORD`)

- Consumer job：安全輸入可隱藏或暫時顯示的密碼文字。
- Event contract：由form container回報password value與reveal intent。
- Lifecycle contract：產品擁有值；Kallopis管理secure input與暫態顯示。
- Legacy members（1）：`KlpPasswordField`
- Data invariants：
  - 欄位具有文字值、reveal policy與validation，不保存明文副本。
- Accepted by：
  - `結構化表單` (`FAM-FORM-ASSEMBLY`).`fields`
- Child roles：
  - 無。

### 流程階段切換 (`FAM-FORM-PHASE`)

- Consumer job：在兩個具流程階段語意的值之間切換。
- Event contract：由owning container回報phase intent。
- Lifecycle contract：值由產品projection更新；動畫由Kallopis管理。
- Legacy members（1）：`KlpPhaseToggle`
- Data invariants：
  - 兩個封閉階段、目前值與可用狀態由資料定義。
- Accepted by：
  - `結構化表單` (`FAM-FORM-ASSEMBLY`).`fields`
- Child roles：
  - 無。

### 封閉單選值 (`FAM-FORM-SINGLE-SELECTION`)

- Consumer job：從少量或封閉候選中輸入單一值。
- Event contract：由owning container回報single value intent。
- Lifecycle contract：產品擁有值；Kallopis決定核准的選擇器呈現。
- Legacy members（4）：`KlpSegmentedControl`、`KlpSelect`、`KlpSelectField`、`KlpSlidingSelection`
- Data invariants：
  - 候選具有穩定身分、label、目前值、可用與validation狀態。
- Accepted by：
  - `結構化表單` (`FAM-FORM-ASSEMBLY`).`fields`
  - `互斥候選輸入群組` (`FAM-FORM-RADIO-SELECTION`).`options`
  - `資料篩選條件` (`FAM-SEARCH-FILTER`).`criteria`
- Child roles：
  - 無。

### 標籤集合輸入 (`FAM-FORM-TAG-VALUES`)

- Consumer job：輸入、新增、操作與移除多個文字標籤值。
- Event contract：由form container回報add、remove或activate tag intent。
- Lifecycle contract：產品擁有標籤集合；Kallopis管理輸入與chip focus。
- Legacy members（2）：`KlpTagChip`、`KlpTagInputField`
- Data invariants：
  - 標籤具有穩定身分、文字、順序與validation狀態。
- Accepted by：
  - `結構化表單` (`FAM-FORM-ASSEMBLY`).`fields`
- Child roles：
  - 無。

### 單行文字輸入 (`FAM-FORM-TEXT`)

- Consumer job：輸入單行或帶固定語意前後綴的文字值。
- Event contract：由form container回報text value intent。
- Lifecycle contract：產品擁有值；Kallopis管理IME、focus與selection。
- Legacy members（2）：`KlpAffixedTextField`、`KlpTextField`
- Data invariants：
  - 欄位具有穩定身分、文字、固定affix、validation與可用狀態。
- Accepted by：
  - `結構化表單` (`FAM-FORM-ASSEMBLY`).`fields`
  - `鍵值資料輸入` (`FAM-FORM-KEY-VALUE-EDITOR`).`fields`
  - `資料篩選條件` (`FAM-SEARCH-FILTER`).`criteria`
- Child roles：
  - 無。

### 多行文字輸入 (`FAM-FORM-TEXT-AREA`)

- Consumer job：輸入可包含多行的純文字值。
- Event contract：由owning container回報multiline text intent。
- Lifecycle contract：產品擁有值；Kallopis管理IME、scroll與selection。
- Legacy members（1）：`KlpTextArea`
- Data invariants：
  - 欄位具有穩定身分、文字、validation與長度限制。
- Accepted by：
  - `訊息撰寫` (`FAM-COLLAB-MESSAGE-COMPOSER`).`input`
  - `結構化表單` (`FAM-FORM-ASSEMBLY`).`fields`
- Child roles：
  - 無。

### 三態值輸入 (`FAM-FORM-TRI-STATE`)

- Consumer job：輸入是、否或未決三種狀態。
- Event contract：由form container回報tri-state value intent。
- Lifecycle contract：值由產品projection更新。
- Legacy members（1）：`KlpTriStateToggle`
- Data invariants：
  - 欄位具有三個封閉值、目前值與可用狀態。
- Accepted by：
  - `結構化表單` (`FAM-FORM-ASSEMBLY`).`fields`
- Child roles：
  - 無。

### 停駐區標頭資料 (`FAM-LAYOUT-DOCK-HEADER`)

- Consumer job：描述可停駐區域的標題與局部操作。
- Event contract：由dock layout或panel container回報局部intent。
- Lifecycle contract：隨dock region projection更新；drag handle由Kallopis管理。
- Legacy members（1）：`KlpDockHeader`
- Data invariants：
  - 區域具有穩定身分、標題、狀態與局部動作。
- Accepted by：
  - `工作區面板標頭` (`FAM-LAYOUT-PANEL-HEADER`).`panel-controls`
- Child roles：
  - 無。

### 面板收合意圖 (`FAM-LAYOUT-PANE-COLLAPSE`)

- Consumer job：描述工作區面板可收合或展開的狀態。
- Event contract：由owning workspace container回報collapse intent。
- Lifecycle contract：持久狀態由產品擁有；動畫與命中由Kallopis管理。
- Legacy members（1）：`KlpPaneCollapseControl`
- Data invariants：
  - 面板具有穩定身分、展開狀態與允許操作。
- Accepted by：
  - `工作區面板標頭` (`FAM-LAYOUT-PANEL-HEADER`).`panel-controls`
- Child roles：
  - 無。

### 導覽目的地 (`FAM-NAV-DESTINATION`)

- Consumer job：描述一個可切換的應用、側邊、設定或工作分頁目的地。
- Event contract：由owning navigation container回報destination intent。
- Lifecycle contract：目的地是route projection，不直接執行導覽。
- Legacy members（4）：`KlpRailItem`、`KlpSettingsNavigationItem`、`KlpSidebarNavigationButton`、`KlpStageTab`
- Data invariants：
  - 目的地具有穩定身分、label、selected、enabled與可選badge。
- Accepted by：
  - `主要工作內容標頭` (`FAM-APP-STAGE-HEADER`).`actions`
  - `階層位置路徑` (`FAM-NAV-BREADCRUMB`).`destinations`
  - `主要位置導覽` (`FAM-NAV-PRIMARY`).`destinations`
  - `同層內容分頁` (`FAM-NAV-TABS`).`tabs`
  - `邊緣暫態面板` (`FAM-OVERLAY-DRAWER`).`content-summary`
  - `設定頁導覽` (`FAM-SETTINGS-NAVIGATION`).`destinations`
- Child roles：
  - 無。

### 導覽目的地群組 (`FAM-NAV-DESTINATION-GROUP`)

- Consumer job：把相關導覽目的地整理成具名稱的語意群組。
- Event contract：目的地intent由owning navigation container統一回報。
- Lifecycle contract：群組是navigation資料schema，不形成任意KLP children。
- Legacy members（2）：`KlpSettingsNavigationGroup`、`KlpSidebarNavigationGroup`
- Data invariants：
  - 群組具有穩定身分、label與封閉destination資料。
- Accepted by：
  - `階層探索器` (`FAM-NAV-EXPLORER`).`items`
  - `主要位置導覽` (`FAM-NAV-PRIMARY`).`destinations`
  - `邊緣暫態面板` (`FAM-OVERLAY-DRAWER`).`content-summary`
  - `設定頁導覽` (`FAM-SETTINGS-NAVIGATION`).`destinations`
- Child roles：
  - 無。

### 導覽區段標籤 (`FAM-NAV-SECTION-LABEL`)

- Consumer job：描述側邊導覽中一組目的地的名稱。
- Event contract：純標籤不產生event。
- Lifecycle contract：標籤是navigation projection。
- Legacy members（1）：`KlpSidebarSectionLabel`
- Data invariants：
  - 標籤具有穩定區段身分與文字。
- Accepted by：
  - `主要位置導覽` (`FAM-NAV-PRIMARY`).`destinations`
- Child roles：
  - 無。

### 資料檢視切換 (`FAM-NAV-VIEW-SWITCHER`)

- Consumer job：切換同一份資料的核准語意檢視。
- Event contract：由owning container回報view kind intent。
- Lifecycle contract：產品可持久化選擇；Kallopis決定各view具體布局。
- Legacy members（1）：`KlpViewSwitcher`
- Data invariants：
  - 候選是封閉view kind並共享資料身分、選取與事件契約。
- Accepted by：
  - `資料篩選條件` (`FAM-SEARCH-FILTER`).`criteria`
- Child roles：
  - 無。

### 操作補充說明 (`FAM-OVERLAY-TOOLTIP`)

- Consumer job：在指向或聚焦操作時暫時描述補充說明。
- Event contract：通常不產生event；由owning container持有操作intent。
- Lifecycle contract：Kallopis管理hover/focus觸發、延遲、placement與dismiss。
- Legacy members（1）：`KlpTooltip`
- Data invariants：
  - 說明具有anchor identity、文字與延遲policy。
- Accepted by：
  - `語意動作群組` (`FAM-ACTION-GROUP`).`actions`
- Child roles：
  - 無。

### 工作流程進度 (`FAM-PLAN-WORKFLOW-PROGRESS`)

- Consumer job：描述多階段工作流程目前的完成位置。
- Event contract：由owning workflow container回報stage intent。
- Lifecycle contract：流程state由產品擁有；Kallopis只投影進度。
- Legacy members（1）：`KlpWorkflowProgress`
- Data invariants：
  - 流程具有穩定階段、目前位置、完成與錯誤狀態。
- Accepted by：
  - `日期與月曆規劃` (`FAM-PLAN-CALENDAR`).`date-status`
  - `順序流程步驟` (`FAM-PLAN-STEPPER`).`step-status`
  - `工作流程狀態內容` (`FAM-PLAN-WORKFLOW-STATE`).`state`
- Child roles：
  - 無。

### 搜尋命中導覽 (`FAM-SEARCH-NAVIGATOR`)

- Consumer job：在搜尋結果之間移動並描述目前命中位置。
- Event contract：由owning search container回報next、previous或close intent。
- Lifecycle contract：隨query result projection更新。
- Legacy members（1）：`KlpSearchNavigator`
- Data invariants：
  - 查詢具有目前命中索引、總數與可用方向。
- Accepted by：
  - `資料篩選條件` (`FAM-SEARCH-FILTER`).`criteria`
- Child roles：
  - 無。

### 集合排序選擇 (`FAM-SEARCH-SORT`)

- Consumer job：選擇資料集合目前的排序方式與方向。
- Event contract：由owning collection或search container回報sort intent。
- Lifecycle contract：排序state由產品擁有；Kallopis只投影。
- Legacy members（1）：`KlpSortControl`
- Data invariants：
  - 排序候選、目前key、方向與可用狀態由資料定義。
- Accepted by：
  - `資料篩選條件` (`FAM-SEARCH-FILTER`).`criteria`
- Child roles：
  - 無。

### 偏好設定值 (`FAM-SETTINGS-FIELD`)

- Consumer job：描述並修改一項具名稱與說明的偏好值。
- Event contract：由settings container回報value intent。
- Lifecycle contract：產品擁有設定值；Kallopis決定核准control。
- Legacy members（1）：`KlpSettingsField`
- Data invariants：
  - 設定具有穩定key、label、description、value kind與validation。
- Accepted by：
  - `設定內容區` (`FAM-SETTINGS-CONTENT`).`fields`
  - `設定暫態流程` (`FAM-SETTINGS-DIALOG`).`fields`
- Child roles：
  - 無。

### 設定作用範圍 (`FAM-SETTINGS-SCOPE`)

- Consumer job：描述目前正在修改的設定作用範圍。
- Event contract：由settings container回報scope intent。
- Lifecycle contract：scope state由產品擁有。
- Legacy members（1）：`KlpSettingsScopeSwitcher`
- Data invariants：
  - scope候選具有穩定身分、label與目前值。
- Accepted by：
  - `設定暫態流程` (`FAM-SETTINGS-DIALOG`).`fields`
  - `設定頁導覽` (`FAM-SETTINGS-NAVIGATION`).`scope`
- Child roles：
  - 無。

### 設定搜尋 (`FAM-SETTINGS-SEARCH`)

- Consumer job：搜尋並定位符合文字的設定項目。
- Event contract：由settings container回報query與reveal intent。
- Lifecycle contract：query可由產品或container控制；Kallopis管理focus。
- Legacy members（1）：`KlpSettingsSearchField`
- Data invariants：
  - query、命中數與目前命中位置由設定projection提供。
- Accepted by：
  - `設定內容區` (`FAM-SETTINGS-CONTENT`).`fields`
  - `設定頁導覽` (`FAM-SETTINGS-NAVIGATION`).`search`
- Child roles：
  - 無。

### 主題模式偏好 (`FAM-SETTINGS-THEME-PREFERENCE`)

- Consumer job：選擇應用偏好的明暗或跟隨系統模式。
- Event contract：由settings container回報theme preference intent。
- Lifecycle contract：偏好由產品持久化；Kallopis讀取唯一theme authority。
- Legacy members（2）：`KlpThemeModePicker`、`KlpThemeToggle`
- Data invariants：
  - 候選是封閉theme mode，不包含局部style值。
- Accepted by：
  - `設定內容區` (`FAM-SETTINGS-CONTENT`).`fields`
  - `設定暫態流程` (`FAM-SETTINGS-DIALOG`).`fields`
- Child roles：
  - 無。

### 快捷鍵提示資料 (`FAM-SYSTEM-SHORTCUT-HINT`)

- Consumer job：描述一項操作可用的鍵盤快捷方式。
- Event contract：提示本身不產生event。
- Lifecycle contract：隨command scope與platform projection更新。
- Legacy members（1）：`KlpShortcutHint`
- Data invariants：
  - 提示引用已核准命令身分與平台解析後按鍵。
- Accepted by：
  - `文件編輯動作群組` (`FAM-ACTION-DOCUMENT-EDIT`).`actions`
  - `編輯器工具群組` (`FAM-ACTION-EDITOR-TOOLS`).`tools`
  - `語意動作群組` (`FAM-ACTION-GROUP`).`actions`
  - `選取內容動作` (`FAM-ACTION-SELECTION`).`actions`
  - `主要工作內容標頭` (`FAM-APP-STAGE-HEADER`).`actions`
  - `畫布工具群組` (`FAM-CANVAS-TOOLS`).`tools`
- Child roles：
  - 無。

### 封閉圖示語意 (`FAM-VISUAL-ICON`)

- Consumer job：以核准圖示語意輔助辨識資料或操作。
- Event contract：圖示本身不產生event。
- Lifecycle contract：由Kallopis資產與semantic style resolver投影。
- Legacy members（1）：`KlpIcon`
- Data invariants：
  - 圖示使用封閉semantic identity與替代語意，不含asset或style override。
- Accepted by：
  - `桌面視窗標頭` (`FAM-APP-WINDOW-HEADER`).`identity`
- Child roles：
  - 無。

## `internal` families — 22

### 內部輔助語意投影 (`FAM-INTERNAL-ACCESS-SEMANTICS`)

- Consumer job：由Kallopis避免裝飾或重複內容進入輔助語意樹。
- Event contract：無consumer event；不提供語意樹customization。
- Lifecycle contract：隨renderer semantic subtree建立與釋放。
- Legacy members（1）：`KlpExcludeSemantics`
- Data invariants：
  - 只使用renderer已驗證的semantic bound state。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### 內部畫布選取呈現 (`FAM-INTERNAL-CANVAS-SELECTION`)

- Consumer job：由Kallopis呈現畫布選取範圍與控制點。
- Event contract：無consumer event；事件由畫布container統一回報。
- Lifecycle contract：隨畫布gesture session建立與釋放。
- Legacy members（1）：`KlpCanvasSelectionOverlay`
- Data invariants：
  - 只使用畫布renderer暫態選取資料，不形成consumer contract。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### 內部集合虛擬化 (`FAM-INTERNAL-DATA-VIRTUALIZATION`)

- Consumer job：由Kallopis有效排列與回收大量集合項目。
- Event contract：無consumer event；選取與scroll intent由owning container回報。
- Lifecycle contract：隨viewport與資料窗口建立、回收及釋放。
- Legacy members（3）：`KlpMasonryGrid`、`KlpVirtualGrid`、`KlpVirtualList`
- Data invariants：
  - 只使用owning feature的bound資料與viewport資訊。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### 內部拖放機制 (`FAM-INTERNAL-DRAG-DROP`)

- Consumer job：由Kallopis呈現拖曳預覽、放置位置並接收命中。
- Event contract：不直接暴露callback；語意drop intent由owning feature回報。
- Lifecycle contract：只在drag session存在，結束後完整釋放。
- Legacy members（3）：`KlpDragPreview`、`KlpDropIndicator`、`KlpDropTarget`
- Data invariants：
  - 只保存目前drag session、允許動作與命中結果。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### 內部等待呈現材料 (`FAM-INTERNAL-FEEDBACK-LOADING`)

- Consumer job：由Kallopis呈現等待動態或內容占位。
- Event contract：無consumer event。
- Lifecycle contract：隨loading state進出並由renderer釋放動畫資源。
- Legacy members（2）：`KlpGeometricSpinner`、`KlpSkeletonLine`
- Data invariants：
  - 只使用owning feature的loading bound state。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### 內部發布進度表面 (`FAM-INTERNAL-FEEDBACK-PUBLICATION`)

- Consumer job：由Kallopis在內容發布期間呈現進度並限制衝突操作。
- Event contract：不建立公開event；由owning publication feature回報。
- Lifecycle contract：隨發布工作建立與完成後移除。
- Legacy members（1）：`KlpPublicationProgressOverlay`
- Data invariants：
  - 只使用發布feature的bound進度與阻擋狀態。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### 內部檔案階層投影 (`FAM-INTERNAL-FILE-EXPLORER-VIEWS`)

- Consumer job：由Kallopis投影檔案資料夾、資產與區段。
- Event contract：不暴露renderer callback；由file explorer回報intent。
- Lifecycle contract：隨可見檔案項目建立與回收。
- Legacy members（3）：`KlpFileExplorerFolderView`、`KlpFileExplorerItemView`、`KlpFileExplorerSectionView`
- Data invariants：
  - 只讀file explorer bound records，不形成第二份資料模型。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### 內部表單欄位呈現 (`FAM-INTERNAL-FORM-CHROME`)

- Consumer job：由Kallopis呈現欄位名稱、說明、錯誤與選取指示。
- Event contract：無consumer event；值intent由form container回報。
- Lifecycle contract：隨欄位renderer建立與釋放。
- Legacy members（4）：`KlpFieldDescription`、`KlpFieldError`、`KlpFieldLabel`、`KlpToggleIndicator`
- Data invariants：
  - 只使用field bound record的label、description、error與state。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### 內部互動區域機制 (`FAM-INTERNAL-INTERACTION-REGIONS`)

- Consumer job：由Kallopis統一處理命中、按壓、手勢、阻擋與狀態回饋。
- Event contract：不直接暴露callback；語意intent由owning feature回報。
- Lifecycle contract：隨renderer identity建立並在unmount時釋放。
- Legacy members（5）：`KlpActionRegion`、`KlpGestureRegion`、`KlpPointerBlocker`、`KlpPressable`、`KlpStateHighlight`
- Data invariants：
  - 只保存renderer暫態focus、hover、press與pointer狀態。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### 內部布局材料 (`FAM-INTERNAL-LAYOUT-PRIMITIVES`)

- Consumer job：由Kallopis使用線性、疊放、約束、定位、轉換與捲動材料完成核准布局。
- Event contract：無consumer event；不形成可組裝public API。
- Lifecycle contract：隨renderer tree建立、更新與釋放。
- Legacy members（21）：`KlpAlign`、`KlpBox`、`KlpCenter`、`KlpColumn`、`KlpConstrainedBox`、`KlpDirectionalPositioned`、`KlpExpanded`、`KlpFit`、`KlpFlexible`、`KlpGap`、`KlpLayoutBuilder`、`KlpPositioned`、`KlpRegion`、`KlpRotate`、`KlpRow`、`KlpScrollViewport`、`KlpSection`、`KlpSpacer`、`KlpStack`、`KlpTranslate`、`KlpWrap`
- Data invariants：
  - 只使用Kallopis-owned bound geometry與semantic style。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### 內部導覽預覽投影 (`FAM-INTERNAL-NAV-PREVIEW`)

- Consumer job：由Kallopis以階層方式預覽可探索內容。
- Event contract：不暴露renderer callback；由navigation container回報intent。
- Lifecycle contract：隨可見預覽資料建立與回收。
- Legacy members（1）：`KlpPreviewTree`
- Data invariants：
  - 只讀owning navigation feature的bound資料。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### 內部導覽目的地宿主 (`FAM-INTERNAL-NAV-ROUTER-OUTLET`)

- Consumer job：由Kallopis在畫面宿主呈現已解析目的地。
- Event contract：無consumer callback；導覽intent由application契約處理。
- Lifecycle contract：隨route transaction替換並管理目的地資源。
- Legacy members（1）：`KlpRouterOutlet`
- Data invariants：
  - 只使用application已驗證的route projection。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### 內部暫態表面材料 (`FAM-INTERNAL-OVERLAY-SURFACES`)

- Consumer job：由Kallopis建立modal、popup、tooltip與veil的核准表面。
- Event contract：不暴露surface callback；dismiss與feature intent由overlay owner回報。
- Lifecycle contract：隨overlay lease建立、排序並釋放。
- Legacy members（5）：`KlpModalFrame`、`KlpPopupBackground`、`KlpPopupPanel`、`KlpTooltipSurface`、`KlpVeil`
- Data invariants：
  - 只使用overlay bound record與semantic style。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### 內部平台適應 (`FAM-INTERNAL-PLATFORM-ADAPTATION`)

- Consumer job：由Kallopis依平台與裝置環境選擇核准結構。
- Event contract：無consumer event；不開放builder分支。
- Lifecycle contract：隨environment更新重新解析，不建立第二份環境權威。
- Legacy members（3）：`KlpAdaptive`、`KlpWindowHeaderMacLayout`、`KlpWindowHeaderWindowsLayout`
- Data invariants：
  - 只讀唯一environment與host platform資料。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### 內部面板調整機制 (`FAM-INTERNAL-RESIZABLE-PANES`)

- Consumer job：由Kallopis在核准界限內調整相鄰面板尺寸。
- Event contract：持久pane intent由owning layout回報，不暴露raw pointer callback。
- Lifecycle contract：drag session結束後釋放暫態狀態。
- Legacy members（2）：`KlpResizablePane`、`KlpResizeHandle`
- Data invariants：
  - 只保存pane bound identity、限制與暫態drag geometry。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### 內部設定區標頭 (`FAM-INTERNAL-SETTINGS-CHROME`)

- Consumer job：由Kallopis呈現設定內容與導覽區的身分說明。
- Event contract：無consumer event。
- Lifecycle contract：隨settings layout區域建立與替換。
- Legacy members（2）：`KlpSettingsContentHeader`、`KlpSettingsNavigationHeader`
- Data invariants：
  - 只讀settings bound title與description。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### 內部側邊操作排列 (`FAM-INTERNAL-SIDEBAR-ACTIONS`)

- Consumer job：由Kallopis在側邊區排列相關操作。
- Event contract：不暴露renderer callback；由action container回報intent。
- Lifecycle contract：隨側邊區renderer建立與釋放。
- Legacy members（1）：`KlpSidebarButtonGroup`
- Data invariants：
  - 只讀owning action group bound records。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### 內部分隔與線框材料 (`FAM-INTERNAL-VISUAL-DIVIDERS`)

- Consumer job：由Kallopis以核准線條語言建立邊界與分隔。
- Event contract：無consumer event。
- Lifecycle contract：隨renderer tree建立與釋放。
- Legacy members（4）：`KlpDashedBorder`、`KlpDashedDivider`、`KlpDivider`、`KlpStrokeFrame`
- Data invariants：
  - 只使用semantic style resolver輸出的線條角色。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### 內部頁面表面 (`FAM-INTERNAL-VISUAL-PAGE-SURFACE`)

- Consumer job：由Kallopis建立文件與頁面的核准背景。
- Event contract：無consumer style event。
- Lifecycle contract：隨page renderer建立與釋放。
- Legacy members（2）：`KlpPageBackground`、`KlpPageBackgroundEditor`
- Data invariants：
  - 只使用semantic page style與document bound state。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### 內部內容表面 (`FAM-INTERNAL-VISUAL-SURFACE`)

- Consumer job：由Kallopis以核准表面語意承載內容。
- Event contract：無consumer event。
- Lifecycle contract：隨renderer tree建立與釋放。
- Legacy members（1）：`KlpSurface`
- Data invariants：
  - 只使用semantic surface resolver，不接受局部style。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### 內部視窗識別圖示 (`FAM-INTERNAL-WINDOW-ICON`)

- Consumer job：由Kallopis在視窗標頭呈現應用識別。
- Event contract：無consumer event。
- Lifecycle contract：隨window header renderer建立與釋放。
- Legacy members（1）：`KlpWindowAppIcon`
- Data invariants：
  - 只讀application asset identity與替代語意。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### 內部工作區框架 (`FAM-INTERNAL-WORKSPACE-FRAMES`)

- Consumer job：由Kallopis配置導覽、面板、側邊與主要工作區邊界。
- Event contract：不暴露任意content callback；intent由owning layout或container回報。
- Lifecycle contract：隨workspace layout建立、更新與釋放。
- Legacy members（6）：`KlpNavigationRailFrame`、`KlpPanelFooter`、`KlpPanelFrame`、`KlpPrimarySidebarFrame`、`KlpSidebarFrame`、`KlpStageFrame`
- Data invariants：
  - 只使用已驗證layout roles與semantic geometry。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

## `none` families — 12

### Catalog 色彩檢查工具 (`FAM-CATALOG-COLOR-TOOLS`)

- Consumer job：在設計目錄中挑選與精確檢查感知一致色彩值。
- Event contract：只供Catalog內部檢查，不提供consumer event。
- Lifecycle contract：隨Catalog頁面建立與釋放，不參與產品畫面。
- Legacy members（2）：`KlpOklchColorEditor`、`KlpOklchColorPicker`
- Data invariants：
  - 只保存Catalog檢查輸入，不形成consumer runtime資料契約。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### Catalog 能力檢查 (`FAM-CATALOG-COMPONENT-INSPECTION`)

- Consumer job：在設計目錄中瀏覽能力定義、狀態與無障礙契約。
- Event contract：只供Catalog檢查切換，不提供consumer event。
- Lifecycle contract：隨Catalog頁面建立與釋放，不參與產品畫面。
- Legacy members（4）：`KlpAccessibilityContractPanel`、`KlpComponentDefinitionCard`、`KlpComponentLibraryGrid`、`KlpComponentStateSelector`
- Data invariants：
  - 只保存Catalog specimen metadata，不形成consumer runtime資料契約。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### Catalog 畫布布局檢查 (`FAM-CATALOG-LAYOUT-LENS`)

- Consumer job：在設計目錄中檢查畫布節點的布局關係。
- Event contract：只供Catalog檢查，不提供consumer event。
- Lifecycle contract：隨Catalog檢查情境建立與釋放。
- Legacy members（1）：`KlpLayoutLens`
- Data invariants：
  - 只保存Catalog診斷資料，不形成consumer runtime資料契約。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### Catalog 狀態色檢查 (`FAM-CATALOG-STATUS-COLORS`)

- Consumer job：瀏覽核准的語意狀態色角色。
- Event contract：只供Catalog選取檢查，不提供產品event。
- Lifecycle contract：隨Catalog頁面建立與釋放。
- Legacy members（1）：`KlpStatusRoleSwatches`
- Data invariants：
  - 只讀語意色彩目錄，不形成consumer style override。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### Catalog 主題預覽 (`FAM-CATALOG-THEME-PREVIEW`)

- Consumer job：在設計目錄中預覽核准的視覺主題。
- Event contract：只供Catalog預覽，不提供consumer style event。
- Lifecycle contract：隨Catalog頁面建立與釋放。
- Legacy members（1）：`KlpThemePreviewTile`
- Data invariants：
  - 只讀Kallopis主題資料，不建立第二份theme權威。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### Catalog token 檢查 (`FAM-CATALOG-TOKEN-INSPECTION`)

- Consumer job：在設計目錄中檢查視覺原料與驗證結果。
- Event contract：只供Catalog檢查，不提供產品event。
- Lifecycle contract：暫時比較值只存在Catalog session，不進入產品runtime。
- Legacy members（3）：`KlpTokenOverride`、`KlpTokenTable`、`KlpTokenValidationBanner`
- Data invariants：
  - 只讀或暫時比較Catalog token資料，不形成consumer override。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### 焦點範圍契約 (`FAM-SYSTEM-FOCUS-SCOPE`)

- Consumer job：限定鍵盤焦點在受控互動範圍內移動。
- Event contract：不形成consumer composition event。
- Lifecycle contract：隨overlay或互動scope建立、暫停與釋放。
- Legacy members（2）：`KlpFocusBoundary`、`KlpFocusRegion`
- Data invariants：
  - 焦點範圍與恢復目標由Kallopis runtime擁有。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### 鍵盤命令範圍契約 (`FAM-SYSTEM-KEY-BINDINGS`)

- Consumer job：在受控範圍安裝並限定鍵盤命令對應。
- Event contract：只把核准命令轉為owning feature intent。
- Lifecycle contract：隨host與局部scope安裝、遮蔽及釋放。
- Legacy members（2）：`KlpKeyBindingHost`、`KlpKeyBindingRegion`
- Data invariants：
  - 命令身分、scope與優先級由Kallopis capture驗證。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### 輔助語意公告契約 (`FAM-SYSTEM-LIVE-SEMANTICS`)

- Consumer job：建立可辨識語意區域並公告重要內容變化。
- Event contract：不形成視覺composition event。
- Lifecycle contract：隨host semantic tree建立、更新與釋放。
- Legacy members（2）：`KlpLiveRegion`、`KlpSemanticRegion`
- Data invariants：
  - 語意身分、role、label與公告politeness由Kallopis驗證。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### 暫態介面宿主契約 (`FAM-SYSTEM-OVERLAY-HOST`)

- Consumer job：為目前畫面的核准暫態介面提供共同承載區。
- Event contract：overlay feature只收到語意intent，不取得host renderer。
- Lifecycle contract：與screen host同生命週期並管理overlay leases。
- Legacy members（1）：`KlpOverlayHost`
- Data invariants：
  - overlay identity、z-order、focus lease與dismiss policy由Kallopis擁有。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### 響應面板協調契約 (`FAM-SYSTEM-RESPONSIVE-PANES`)

- Consumer job：依可用空間協調多個工作面板的顯示狀態。
- Event contract：只回報語意pane state，不暴露raw尺寸或builder。
- Lifecycle contract：與owning layout共同建立並隨environment更新。
- Legacy members（1）：`KlpResponsivePaneCoordinator`
- Data invariants：
  - pane identity、優先級與可見policy由layout contract提供。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。

### 通知佇列契約 (`FAM-SYSTEM-TOAST-HOST`)

- Consumer job：依序管理並呈現多則非阻斷結果通知。
- Event contract：將toast action與dismiss轉回通知owner。
- Lifecycle contract：與screen host共同存在並在screen釋放時清空leases。
- Legacy members（1）：`KlpToastStack`
- Data invariants：
  - 通知identity、priority、期限與佇列順序由Kallopis管理。
- Accepted by：
  - 不參與 public composition graph。
- Child roles：
  - 無。
