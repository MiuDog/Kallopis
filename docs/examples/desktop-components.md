# 桌面應用元件分類

分類權威：`react/example/desktop-catalog-data.mjs`，與互動 Catalog 共用；更新分類時同步本表。入口：`/?catalog=desktop`，單元件：`/?specimen=KlpTree`。採用規則見 [Catalog](catalog.md)。

目前桌面補充模組共 36 個公開元件；原有布局、命令與停靠沿用既有實作。依使用者確認，通用桌面能力在本庫實作，專業內容引擎與系統功能提供整合入口。每個 Catalog 項目皆能直接操作真實 fixture。

| 類型 | 常見型態 | 指定元件 | 支援限制 |
| --- | --- | --- | --- |
| 應用骨架與視窗 | 應用容器、標題列、內容區、側欄、狀態列、多視窗 | `KlpAppLayout`、`KlpWorkspace`、`KlpFrame`、`KlpStatusBar` | 原生視窗移動、最小化、最大化、多視窗及系統標題列由宿主提供。 |
| 布局與表面 | 水平／垂直布局、Pane、分隔、留白、Panel、Card、分割與停靠 | `KlpLayoutRow`、`KlpLayoutColumn`、`KlpLayoutPane`、`KlpLayoutDivider`、`KlpLayoutSpacer`、`KlpSurface`、`KlpCard`、`KlpDockLayout`、`KlpModernProductivityLayout` | Panel 有平面與微立體；第三種立體配方待定位。一般容器不重做 Dock 演算法。 |
| 導航與內容切換 | 分組導航、Explorer、頁籤、麵包屑、分頁、可展開區段 | `KlpTree`、`KlpFileExplorer`、`KlpTabs`、`KlpBreadcrumb`、`KlpPagination`、`KlpAccordion` | Explorer 為 section/item 兩層；任意深度導覽採 KlpTree；路由、歷史與資料分頁由產品提供。 |
| 動作與命令 | 按鈕、圖示按鈕、切換按鈕、工具列、選單、右鍵選單、命令面板、快捷鍵 | `KlpSplitButton`、`KlpRibbon`、`KlpButton`、`KlpIconButton`、`KlpRegisteredCommandToolbar`、`KlpRegisteredCommandMenu`、`KlpRegisteredCommandPopup`、`KlpRegisteredCommandPalette`、`KlpCommandShortcutHost` | 命令 handler 與副作用由產品持有；SplitButton 與 Ribbon 提供組合入口；註冊命令仍透過既有 registry。 |
| 文字與身份 | 標題、正文、說明、標籤、代碼、連結、頭像、狀態徽章 | `KlpText`、`KlpLink`、`KlpAvatar`、`KlpBadge` | 人物資料與圖片由產品提供；字型及 fallback 由套件擁有。 |
| 文字與值輸入 | 單行、多行、搜尋、密碼、數字微調、日期、時間、顏色、檔案選取 | `KlpTextField`、`KlpTextArea` | TextField 的 type 支援原生 search/password/number/date/time/color/file；原生 picker 彈窗由瀏覽器/OS 擁有，不冒充自訂日曆或上傳服務。 |
| 選取與範圍控制 | 勾選、開關、單選群組、下拉、自由輸入建議、多選清單、滑桿 | `KlpMultiSelect`、`KlpCheckbox`、`KlpSwitch`、`KlpRadioGroup`、`KlpSelect`、`KlpComboBox`、`KlpSlider` | Select multiple 可呈現原生多選；ComboBox 使用共用建議列表，遠端資料由產品提供；可刪除多選採 KlpMultiSelect，大量單行資料採 KlpVirtualList。 |
| 資料呈現 | 單行／多行選取清單、表格、卡片、分頁、空資料、排序與篩選 | `KlpTreeGrid`、`KlpDataGrid`、`KlpVirtualList`、`KlpList`、`KlpTable`、`KlpCard`、`KlpPagination`、`KlpEmptyState`、`KlpTextField`、`KlpSelect` | Table 是語意表格；排序與篩選由產品資料投影。TreeGrid 提供階層表格、受控展開與選取；DataGrid 提供受控文字儲存格與排序回報；VirtualList 提供固定列高視窗。公式、合併儲存格及完整試算表引擎屬專業內容整合。 |
| 回饋與載入 | 資訊／成功／警告／錯誤訊息、狀態列、確定／不確定進度、載入占位、空狀態 | `KlpToastRegion`、`KlpSpinner`、`KlpAlert`、`KlpProgress`、`KlpSkeleton`、`KlpEmptyState`、`KlpStatusBar`、`KlpBadge` | Spinner 支援減少動態偏好；ToastRegion 呈現受控通知集合，關閉交還 consumer；排程、工作取消與重試由產品控制。 |
| 浮層與補充資訊 | 對話框、確認、表單對話框、tooltip、命令 popup、檢查面板 | `KlpPopover`、`KlpDrawer`、`KlpDialog`、`KlpTooltip`、`KlpRegisteredCommandPopup`、`KlpFrame` | Dialog／Drawer 使用原生 modal 焦點管理；Popover 使用原生 top layer 與錨點定位、外部點擊／Escape 關閉。產品持有顯示狀態。 |
| 表單與設定組合 | 欄位列、群組、進階折疊、偏好設定、驗證提示、唯讀／停用 | `KlpTextField`、`KlpTextArea`、`KlpSelect`、`KlpCheckbox`、`KlpSwitch`、`KlpRadioGroup`、`KlpAccordion`、`KlpAlert`、`KlpSeparator` | 欄位保持 label/control 同 row；驗證、提交、撤銷、儲存與權限由產品決定。 |
| 媒體與專業內容 | 圖片、影片、音訊、圖表、地圖、畫布、時間軸、日曆、程式碼／富文字編輯器、3D | `KlpContentHost`、`KlpFrame`、`KlpSurface` | 僅 SCENE-CANVAS／專用內容 slot 可接內容引擎；本庫不自研編輯、圖表或 3D 核心。Krepis／BlockNote 正文權威不變。 |
| 系統整合與操作狀態 | 檔案對話框、拖放檔案、剪貼簿、列印、托盤、系統通知、無障礙及 IME | `KlpSystemAction`、`KlpTextField`、`KlpCommandShortcutHost` | 安全權限、原生 API 與不可逆副作用屬宿主／產品。SystemAction 接宿主 callback，具 pending／錯誤／不可用狀態；全域拖放與系統通知由宿主實作，原生控制保留焦點及 IME。 |

## 消費端採用

從 `@kallopis/react` 匯入元件，從 `@kallopis/react/styles.css` 匯入共用樣式，外層使用 KlpThemeProvider。Tree、MultiSelect、DataGrid、Popover 等由消費端保存值並接回 callback；VirtualList 的列高固定，適合大量單行選取，不提供可變高度排版。DataGrid 是文字儲存格編輯，不包含公式或合併儲存格。

KlpContentHost 提供載入／失敗與內容槽，消費端掛載圖表、日曆、時間軸、Krepis／BlockNote 等引擎；KlpSystemAction 接產品提供的宿主 callback，呈現 pending／失敗重試／能力不可用狀態，沒有 callback 時不執行操作。ToastRegion 的集合與關閉由消費端持有，不會自動消失或丟棄通知。

分類交叉參考：[Fluent 2 元件總覽](https://fluent2.microsoft.design/components/web/react/)、[Libadwaita widgets](https://gnome.pages.gitlab.gnome.org/libadwaita/doc/main/)。僅參考用途分類；Kallopis 外觀由本庫語意規範擁有。第三種立體 Panel 未有正式配方；本輪強調採微立體，禁止裝飾細框與左側強調線。
