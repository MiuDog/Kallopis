export const advancedComponentNames = Object.freeze(['KlpTreeGrid', 'KlpTree', 'KlpMultiSelect', 'KlpVirtualList', 'KlpDataGrid', 'KlpPopover', 'KlpDrawer', 'KlpToastRegion', 'KlpSpinner', 'KlpSplitButton', 'KlpRibbon', 'KlpContentHost', 'KlpSystemAction']);
/* 元件名稱只登錄實際公開入口；類型與平台限制分開，不用數量代表完整性。 */
export const desktopComponentNames = Object.freeze([
	...advancedComponentNames,
	'KlpTextArea', 'KlpCheckbox', 'KlpSwitch', 'KlpRadioGroup', 'KlpSelect', 'KlpComboBox', 'KlpSlider',
	'KlpList', 'KlpTabs', 'KlpTable', 'KlpAccordion', 'KlpBreadcrumb', 'KlpPagination',
	'KlpProgress', 'KlpAlert', 'KlpEmptyState', 'KlpDialog', 'KlpTooltip', 'KlpStatusBar', 'KlpSeparator', 'KlpLink', 'KlpAvatar', 'KlpSkeleton',
]);

/* id：類型識別；title：分類；types：常見型態；components：實作；boundary：實作限制與外部責任。 */
export const desktopCatalog = Object.freeze([
	{ id: 'shell', title: '應用骨架與視窗', types: '應用容器、標題列、內容區、側欄、狀態列、多視窗', components: ['KlpAppLayout', 'KlpWorkspace', 'KlpFrame', 'KlpStatusBar'], boundary: '原生視窗移動、最小化、最大化、多視窗及系統標題列由宿主提供。' },
	{ id: 'layout', title: '布局與表面', types: '水平／垂直布局、Pane、分隔、留白、Panel、Card、分割與停靠', components: ['KlpLayoutRow', 'KlpLayoutColumn', 'KlpLayoutPane', 'KlpLayoutDivider', 'KlpLayoutSpacer', 'KlpSurface', 'KlpCard', 'KlpDockLayout', 'KlpModernProductivityLayout'], boundary: 'Panel 有平面與微立體；第三種立體配方待定位。一般容器不重做 Dock 演算法。' },
	{ id: 'navigation', title: '導航與內容切換', types: '分組導航、Explorer、頁籤、麵包屑、分頁、可展開區段', components: ['KlpTree', 'KlpFileExplorer', 'KlpTabs', 'KlpBreadcrumb', 'KlpPagination', 'KlpAccordion'], boundary: 'Explorer 為 section/item 兩層；任意深度導覽採 KlpTree；路由、歷史與資料分頁由產品提供。' },
	{ id: 'commands', title: '動作與命令', types: '按鈕、圖示按鈕、切換按鈕、工具列、選單、右鍵選單、命令面板、快捷鍵', components: ['KlpSplitButton', 'KlpRibbon', 'KlpButton', 'KlpIconButton', 'KlpRegisteredCommandToolbar', 'KlpRegisteredCommandMenu', 'KlpRegisteredCommandPopup', 'KlpRegisteredCommandPalette', 'KlpCommandShortcutHost'], boundary: '命令 handler 與副作用由產品持有；SplitButton 與 Ribbon 提供組合入口；註冊命令仍透過既有 registry。' },
	{ id: 'text', title: '文字與身份', types: '標題、正文、說明、標籤、代碼、連結、頭像、狀態徽章', components: ['KlpText', 'KlpLink', 'KlpAvatar', 'KlpBadge'], boundary: '人物資料與圖片由產品提供；字型及 fallback 由套件擁有。' },
	{ id: 'input', title: '文字與值輸入', types: '單行、多行、搜尋、密碼、數字微調、日期、時間、顏色、檔案選取', components: ['KlpTextField', 'KlpTextArea'], boundary: 'TextField 的 type 支援原生 search/password/number/date/time/color/file；原生 picker 彈窗由瀏覽器/OS 擁有，不冒充自訂日曆或上傳服務。' },
	{ id: 'selection', title: '選取與範圍控制', types: '勾選、開關、單選群組、下拉、自由輸入建議、多選清單、滑桿', components: ['KlpMultiSelect', 'KlpCheckbox', 'KlpSwitch', 'KlpRadioGroup', 'KlpSelect', 'KlpComboBox', 'KlpSlider'], boundary: 'Select multiple 可呈現原生多選；ComboBox 使用共用建議列表，遠端資料由產品提供；可刪除多選採 KlpMultiSelect，大量單行資料採 KlpVirtualList。' },
	{ id: 'data', title: '資料呈現', types: '單行／多行選取清單、表格、卡片、分頁、空資料、排序與篩選', components: ['KlpTreeGrid', 'KlpDataGrid', 'KlpVirtualList', 'KlpList', 'KlpTable', 'KlpCard', 'KlpPagination', 'KlpEmptyState', 'KlpTextField', 'KlpSelect'], boundary: 'Table 是語意表格；排序與篩選由產品資料投影。TreeGrid 提供階層表格、受控展開與選取；DataGrid 提供受控文字儲存格與排序回報；VirtualList 提供固定列高視窗。公式、合併儲存格及完整試算表引擎屬專業內容整合。' },
	{ id: 'feedback', title: '回饋與載入', types: '資訊／成功／警告／錯誤訊息、狀態列、確定／不確定進度、載入占位、空狀態', components: ['KlpToastRegion', 'KlpSpinner', 'KlpAlert', 'KlpProgress', 'KlpSkeleton', 'KlpEmptyState', 'KlpStatusBar', 'KlpBadge'], boundary: 'Spinner 支援減少動態偏好；ToastRegion 呈現受控通知集合，關閉交還 consumer；排程、工作取消與重試由產品控制。' },
	{ id: 'overlay', title: '浮層與補充資訊', types: '對話框、確認、表單對話框、tooltip、命令 popup、檢查面板', components: ['KlpPopover', 'KlpDrawer', 'KlpDialog', 'KlpTooltip', 'KlpRegisteredCommandPopup', 'KlpFrame'], boundary: 'Dialog／Drawer 使用原生 modal 焦點管理；Popover 使用原生 top layer 與錨點定位、外部點擊／Escape 關閉。產品持有顯示狀態。' },
	{ id: 'settings', title: '表單與設定組合', types: '欄位列、群組、進階折疊、偏好設定、驗證提示、唯讀／停用', components: ['KlpTextField', 'KlpTextArea', 'KlpSelect', 'KlpCheckbox', 'KlpSwitch', 'KlpRadioGroup', 'KlpAccordion', 'KlpAlert', 'KlpSeparator'], boundary: '欄位保持 label/control 同 row；驗證、提交、撤銷、儲存與權限由產品決定。' },
	{ id: 'media', title: '媒體與專業內容', types: '圖片、影片、音訊、圖表、地圖、畫布、時間軸、日曆、程式碼／富文字編輯器、3D', components: ['KlpContentHost', 'KlpFrame', 'KlpSurface'], boundary: '僅 SCENE-CANVAS／專用內容 slot 可接內容引擎；本庫不自研編輯、圖表或 3D 核心。Krepis／BlockNote 正文權威不變。' },
	{ id: 'system', title: '系統整合與操作狀態', types: '檔案對話框、拖放檔案、剪貼簿、列印、托盤、系統通知、無障礙及 IME', components: ['KlpSystemAction', 'KlpTextField', 'KlpCommandShortcutHost'], boundary: '安全權限、原生 API 與不可逆副作用屬宿主／產品。SystemAction 接宿主 callback，具 pending／錯誤／不可用狀態；全域拖放與系統通知由宿主實作，原生控制保留焦點及 IME。' },
]);
