# 使用者布局契約

本檔只記錄使用者已明確確認的長期規則。當次任務指示永遠優先；新指示修正舊規則時，在表格新增修訂而不是抹除來源。

| ID | Scope | 權限類型 | 已確認規則 | 來源 | 狀態 |
|---|---|---|---|---|---|
| LAY-001 | 參考圖驅動的 UI 任務 | 精確幾何 | 參考稿的布局尺寸、位置、距離與深淺關係必須遵守；不得以 agent 自選語意值近似。 | 使用者對設定頁與後續修正的明確要求，2026-08-31 | confirmed |
| SEM-001 | 使用者指定採 Kallopis 色彩的任務 | Kallopis 語意 | 顏色採 Kallopis 語意色；這項授權不自動擴張到尺寸、間距或位置。 | 使用者明確區分顏色與布局，2026-08-31 | confirmed |
| OWN-001 | Kallopis／Designist 邊界 | 呈現所有權 | 可重用視覺與元件呈現由 Kallopis 實作，Designist 只負責產品資料與組裝。 | 使用者明確要求，2026-08-31 | confirmed |
| Z-001 | Workbench Stage chrome | 精確圖層 | Tab 位於 Stage 後方；Stage 必須在 tab overflow 之後繪製並取得重疊區 hit test。 | 使用者覆蓋問題修正，2026-08-31 | confirmed |
| PROC-001 | 所有視覺實作 | 工作流程 | 修改前先理清風格繼承樹與語意定義，避免誤用；在溝通中持續學習並記錄使用者的布局邏輯。 | 使用者明確要求，2026-08-31 | confirmed |
| SET-001 | 所有設定頁 | Kallopis 語意／精確關係 | 不論 Light、Dark、Ultra Dark、System 或 Transparent，設定頁一律保持左側導覽較深、右側內容較淺。 | 使用者明確要求「設定一律都是保持左深右淺」，2026-09-01 | confirmed |
| INS-001 | Designist Inspector | 呈現所有權 | Designist 不再組裝獨立右側 Inspector；既有 Inspector 內容保留，未來預計整合至左側 Sidebar，整合方式尚待後續任務確認。 | 使用者明確說明未來整合方向，2026-09-03 | candidate |
| PROC-002 | 新布局設計 | 工作流程 | 第一個步驟必須提供需求規格表單並等待必要欄位確認；不得直接從圖片或說明猜測布局並實作。 | 使用者明確要求，2026-09-03 | confirmed |
| SEM-002 | 新元件、畫面與布局邏輯 | Kallopis 語意／工作流程 | 實作前必須明確討論語意、適用風格與理由；不得補出尚未確認的元件、畫面或細節。 | 使用者明確要求，2026-09-03 | confirmed |
| TEST-001 | 視覺實作測試時機 | 工作流程 | 視覺探索期不撰寫或執行 UI 測試；單一元件定型後只寫元件測試，完整畫面定型後才寫 golden 與整合測試。 | 使用者明確要求，2026-09-03 | confirmed |
| DOC-001 | 前端產品設計知識 | 語意唯一真相來源 | 持續維護用戶體驗生命週期、所有被建立或修改的元件需求、screen 構成與語意定義，並以 kallopis-design-contract 目錄的 Markdown 知識樹作為每次工作的唯一真相來源。 | 使用者明確要求，2026-09-03 | confirmed |
| ARCH-001 | 元件、screen 與語意文件 | 工作流程 | 必須維護元件繼承、畫面構成、風格／邏輯語意繼承三種架構；關係用 Mermaid，語意解析與元件注入邏輯用程式碼區塊。 | 使用者明確要求，2026-09-03 | confirmed |

| SEM-003 | Kallopis 預設風格與所有消費產品 | 語意唯一真相來源／呈現所有權 | Kallopis Semantic Manifest 是元件風格與 Catalog 分類的唯一真相來源；Designist、Notist 等消費產品只可覆寫品牌識別色，操作色與狀態色保持一致；使用者建立的 Design System 完全隔離。 | 使用者逐項確認後同意全部建議，2026-09-03 | superseded by SEM-004 for primary only |
| SEM-004 | Kallopis primary 與 Catalog 主題預覽 | Kallopis 語意／呈現所有權 | brand 與 accent 是不同語意；brand 是可編輯主題來源，primary 由 brand 解析。Catalog 的 OKLCH 編輯須即時更新整個 Catalog 的 primary 呈現；accent、一般 interaction 與 status 色維持獨立。 | 使用者明確修訂，2026-09-03 | superseded by SEM-005 for primary presentation |
| SEM-005 | Kallopis primary 元件對比 | Kallopis 語意／精確色彩規則 | Primary 使用 alpha 255 的不透明主題色背景；背景相對亮度換算至 0–255 後，0–127 使用淺色字，128–255 使用深色字。不得使用半透明色底搭配有色文字。 | 使用者明確修訂，2026-09-03 | superseded by SEM-006 |
| SEM-006 | Kallopis primary 前景切換點 | Kallopis 語意／精確色彩規則 | Primary 以 8-bit sRGB luma 判斷；低於 0xA0（160）使用淺色字，0xA0 以上使用深色字。灰階邊界為 #000000–#9F9F9F 與 #A0A0A0–#FFFFFF。 | 使用者明確修訂，2026-09-03 | confirmed |

| ARCH-002 | Kallopis 元件內部風格繼承 | 架構／呈現所有權 | 複合元件內部提供 InheritedWidget／InheritedTheme scope 處理預設產品風格繼承，消費產品不逐層傳遞操作風格；使用者 Design System 維持獨立 scope。 | 使用者明確要求，2026-09-03 | confirmed |
| DOC-002 | Kallopis 對 AI 的使用文件 | 文件交付 | runtime 與元件重構完成後，撰寫供其他 AI 使用的畫面組合文件，涵蓋 screen、pattern、元件輸入、事件、資料注入、合法覆寫與禁止事項。 | 使用者明確要求，2026-09-03 | confirmed |
| CAT-001 | Kallopis Catalog 全部元件 specimen | 語意追蹤／呈現所有權 | 每個元件展示都必須提供可查看的風格語意資訊，涵蓋實際採用的顏色、surface、邊框／shape、padding／spacing、字體、geometry、motion 與其他 component resolver；不得以猜測值補齊。 | 使用者明確要求，2026-09-03 | confirmed |

| ICON-001 | Kallopis 全部圖示元件 | Kallopis 語意／呈現所有權 | KlpIcon 保留 Thin 與 Regular 兩種線條粗細供元件選擇；不得以縮放扭曲圖形模擬細線。 | 使用者明確要求，2026-09-03 | confirmed |
| ICON-002 | Kallopis 與所有消費產品的圖示 | Kallopis 語意／資產政策 | 圖示預設一律使用 Flaticon 字型；舊 SVG 圖示與 SVG runtime 路徑全面棄用。 | 使用者明確裁決，2026-09-03 | confirmed |
| LAY-002 | App background 上的第一層 panel | Kallopis 語意／精確幾何 | 第一層 panel 各自擁有 `halfCompact` margin 的舊規則；主內容外距所有權已由 LAY-003 取代，Header chrome 的既有外距仍屬獨立層級。 | 使用者修正，2026-09-04 | superseded |
| LAY-003 | App 產品主內容根節點 | 產品組合／精確幾何 | 每個產品主內容根節點一律套用一層 `halfCompact` padding，預設風格為 4px。Dock margin 預設為零的舊組合已由 LAY-004 取代。 | 使用者修正，2026-09-04 | superseded |
| LAY-004 | App、Dock 與 Header 組合邊界 | Kallopis 語意／精確幾何 | 產品主內容根節點、Dock 與 Header 分別擁有 halfCompact 邊界的舊組合；已由 LAY-005 取代。 | 使用者明確修正，2026-09-04 | superseded |
| LAY-005 | App padding 包住 Header 與產品主內容 | Kallopis 語意／精確幾何 | AppFrame 提供 halfCompact padding、Header 不自行加 margin 的舊組合；已由 LAY-006 修正。 | 使用者明確修正「app padding 要包住 heading」，2026-09-04 | superseded |
| LAY-006 | App、Header 與 Dock 的 halfCompact 配對 | Kallopis 語意／精確幾何 | AppFrame 提供一層 `halfCompact` padding 並包住 Header 與產品主內容；Header 本身另有 `halfCompact` margin，Dock 預設也有 `halfCompact` margin。預設各 4px，相鄰兩層各貢獻一半並形成 8px compact gutter。 | 使用者明確重申這才是 halfCompact 的意義，2026-09-04 | confirmed |
| LAY-007 | Panel 內容捲軸 | Kallopis 語意／精確幾何 | Scrollbar 必須置於 panel 尾側的 8px content padding 槽，不得放進 padding 後的內容區；內容維持原水平 padding，Scrollbar 與內容共用同一 ScrollController 並保持可拖曳。 | 使用者依 Catalog 實機標示修正，2026-09-04 | confirmed |
| HEAD-001 | App Header／Heading | Kallopis 互動／平台行為 | 整個 App Header 表面都是視窗拖動範圍，沿用 heading 全區可拖動的定義；內部按鈕、選單與其他操作元件仍保留自身點擊事件。雙擊最大化只屬於非互動 Header 區域。 | 使用者明確要求，2026-09-04 | confirmed |
| ARCH-003 | Sidebar＋Stage 產品布局 | 架構／呈現所有權 | 未來產品的 Sidebar＋Stage 架構建議以 KlpDockLayout 組合；產品只提供 panel 內容、能力、受控 layout 與保存。Catalog 目錄 panel 固定 `allowSide: true`、`allowBottom: false`。 | 使用者明確要求，2026-09-03 | confirmed |
| CAT-002 | Catalog specimen 說明 | 語意追蹤／呈現所有權 | 每個元件 specimen 的 subtitle／description 必須直接顯示實際風格語意；tooltip 只能作完整補充，不得成為唯一入口。無資料時明示「未宣告」。 | 使用者明確要求，2026-09-03 | confirmed |
| NAV-001 | KlpNavigator 與 Sidebar 導覽內容 | 架構／精確延續 | KlpNavigator 採用目前 Catalog 目錄風格；對外只有 Category、Element、Component 三種具體注入模型。Category 是可折疊列表；Element 可遞迴巢狀，也可不依賴 Category 放在根層；Component 可注入虛線分隔線、搜尋框、按鈕列表等任意元件。Category 與 Element 維持目前 Catalog 高度，Component 不被強制高度。 | 使用者明確要求，2026-09-03 | confirmed |
| TYPE-001 | Kallopis 中文 UI 與正文 | Kallopis 語意／字體資產 | 中文比例文字統一使用 Kallopis 套件內的 Noto Sans TC，不依賴作業系統是否安裝；code、label 與 terminal 仍使用 IBM Plex Mono。 | 使用者明確要求「中文改用 Noto Sans TC」，2026-09-03 | confirmed |
| TYPE-002 | App Title／Header／Status 字體 | Kallopis 語意／字體資產 | App Title、Header 主標題與 Status 分別使用 `KlpTextRole.appTitle`、`KlpTextRole.header`、`KlpTextRole.status`；拉丁字元預設使用 IBM Plex Mono，中文字元 fallback 至套件內的 Noto Sans TC；App Title／Status 使用 500，Header 使用 600，不得借用 label、code 或 bodyStrong 表達。 | 使用者明確確認並將提高後的字重降低 100，2026-09-07 | confirmed |
| DOCK-001 | KlpDockLayout | 精確幾何／互動／呈現所有權 | Dock Header 固定 32px；單 panel 顯示標題，多 panel 顯示可用滾輪水平捲動的 tabs；右側產品 actions 寬度不足時由右向左逐個收入三點選單。拖曳 panel 到 Stage 時，支援 Bottom 與 Side 者優先判定下半部 Bottom，其餘區域分 Left／Right；空 Area 顯示主題色邊緣對齊線並建立首個 Group，收合但仍有內容的 Area 在 edge band 達 minExtent / 2 時展開。整個非 clickable header 是拖曳區。沒有內容的 Area 不占額外 resize handle，只在 panel 與 app 邊界既有 8px 內保留隱形命中區。 | 使用者逐項確認並補充，2026-09-04 | confirmed |
| DOCK-002 | KlpDockLayout Bottom 與 Group resize | 精確幾何／互動 | Bottom Group 的 header 接受 tab 合併；header 外只有目標 panel 右半部接受放置並在其右側新增 Group，左半部不接受，不提供向左或向下拆分。空 Left／Right 的放置線跨越 Stage 與已展開 Bottom 的中央區域全高。Group resize 以滑鼠全域位置換算 Area local 座標，讓分隔線中心逐幀對齊滑鼠，不累加相對 delta。 | 使用者明確修正，2026-09-04 | confirmed；修訂 DOCK-001 的 Group drop／resize 細節 |
| DOCK-003 | KlpDockLayout Area resize | 精確幾何／互動／生命週期 | Left／Right／Bottom 的 Area 分隔線是持續掛載於根層的 8px overlay：展開時位於既有間距，收合時移至 app 邊界，不另占空間或更換手勢元件。resize 以滑鼠全域位置換算 Dock local 絕對座標；超過 min／max 後反向移動必須先回到實際分隔線才改變尺寸。拖曳越過 closeThreshold 收合後不需放開滑鼠，反向越過門檻即以 minExtent 展開，追上分隔線後同一次手勢繼續調整。 | 使用者明確修正，2026-09-04 | confirmed；補完 DOCK-001 的 Area resize 細節 |
| BTN-001 | KlpButton 預設呈現 | 精確幾何／Kallopis 語意 | 五段按鈕高度為 XS 28、SM 32、MD 36、LG 40、XL 48px；Primary label 使用 semiBold，其他 tone 維持原角色字重。Primary 依每個狀態實際繪製背景的 8-bit sRGB luma 判斷，低於 160 使用淺色字，160 以上才使用深色字。 | 使用者再次要求降低高度、修正 Primary 光學字重並重申 160 門檻，2026-09-04 | confirmed |
| PANEL-001 | KlpPanelFrame | Kallopis 語意／呈現所有權 | KlpPanelFrame 圓角由 panel 降至下一階 card 語意；預設外圓角 8px，內層裁切繼續扣除 stroke。不得修改全域 panel token 來連動其他大型容器。 | 使用者明確要求，2026-09-04 | confirmed |
| BADGE-001 | KlpBadge 預設呈現 | 精確幾何／Kallopis 語意 | Badge 使用 caption 12px 字級／16px 行高、6px 水平 padding、2px 垂直 padding 與 pill 圓角，最終高度約 20px；所有 tone 與 variant 共用此幾何。 | 使用者採用建議規格，2026-09-04 | confirmed |
| SCHEDULE-001 | KlpScheduleList 時間欄 | 精確幾何／文字行為 | 排程時間必須完整維持單行，不可因時間欄寬度不足而換行；時間欄使用 sectionLarge 最小寬度，文字限制一行並在更長內容超界時省略。 | 使用者依 Catalog 實機畫面明確修正，2026-09-04 | confirmed |
| DATE-GRID-001 | KlpDateGrid 網格與週末 | 精確幾何／Kallopis 語意 | 日期格不可使用隱形欄間隔；相鄰日期格以 1px 實線分隔，最左與最右欄以中性高亮 surface 表示週末，選取狀態仍優先。 | 使用者依 Catalog 實機畫面明確修正，2026-09-04 | confirmed |
| MESSAGE-001 | KlpMessageBubble 對話背景 | Kallopis 語意／角色區分 | 有背景的訊息 bubble 必須使用相對所在區域可辨識的中性高亮 surface；使用者與 Assistant 以 trailing／leading 位置區分，不能因背景與頁面同色而失去對話邊界。 | 使用者依 Catalog 實機畫面明確修正，2026-09-04 | confirmed |
| IST-001 | IST 系列產品基礎畫面 | 架構／產品族配方 | IST 系列子產品共用 `IstWorkbenchScreen` 固定基礎畫面；此模板放在 Kallopis 的 `ist` 產品族配方層，不命名為跨所有消費端的 `KlpWorkbenchScreen`。 | 使用者明確說明，2026-09-04 | confirmed |
| IST-002 | IST Workbench 布局組裝 | 架構／呈現所有權 | `KlpDockLayout` 整合為 `KlpWorkbenchShell` 的 Dock 模式；`IstWorkbenchScreen` 透過 Shell 使用 Dock，不直接建立 Dock。既有固定三欄模式保留相容。 | 使用者明確要求，2026-09-04 | confirmed |
| NAV-002 | KlpNavigationRail 三區布局 | 精確幾何／互動／呈現所有權 | Rail 固定由 Top、Center、Bottom 三個 Group 組成；Top 從頂部開始、Bottom 從底部開始，Center 最後取得剩餘高度、在其中置中，並在溢出時無 Scrollbar 垂直捲動。Top 有內容時在下方加入分隔線，Bottom 有內容時在上方加入分隔線；item 只可在原 Group 內排序。 | 使用者明確要求並確認禁止跨 Group，2026-09-04 | confirmed；Center 對齊由 NAV-006 修訂 |
| NAV-003 | Navigation 原始碼結構 | 架構／程式碼所有權 | `lib/src/navigation` 下的 Explorer、Rail、Sidebar 各自使用獨立資料夾；公開型別仍統一由 `lib/kallopis.dart` 匯出，消費產品不依賴內部檔案路徑。 | 使用者明確要求，2026-09-04 | confirmed |
| NAV-004 | KlpRailDivider | Kallopis 語意／呈現所有權 | Rail group 分隔線使用低對比、hairline 粗細的虛線；顏色與透明度沿用 KlpDashedDivider 的 guide／dashedOpacity 語意，不改全域實線 KlpDivider。 | 使用者明確要求，2026-09-04 | confirmed |
| NAV-005 | KlpRailItemGroup 排序能力 | Kallopis 互動／產品控制 | KlpRailItemGroup 提供 isReorderable；false 時該 Group 不建立拖曳來源、不接受排序落點且不觸發 onReorder，item 原有點擊與選單操作維持有效。 | 使用者明確要求，2026-09-04 | confirmed |
| NAV-006 | KlpNavigationRail Center Group | 精確布局／呈現所有權 | Center Group 仍取得 Top 與 Bottom 之間的剩餘高度，但其中項目預設從該區域頂端排列，不再垂直置中；溢出時維持無 Scrollbar 垂直捲動。 | 使用者明確修正「rail center group 預設是在中間但是置頂」，2026-09-04 | confirmed；修訂 NAV-002 的 Center 對齊 |
| ARCH-004 | Kallopis primitive color 與 semantic theme | 架構／風格所有權 | Primitive color 只能以色族與色階命名；`axis`、`grid`、`marketUp` 等用途名稱及 `light`、`dark` 等模式名稱必須由 semantic theme 組合，不得放進 KlpPalette。 | 使用者檢視資料視覺化色彩定義後要求修正，2026-09-07 | confirmed |
| CODE-001 | Kallopis 連續常數定義 | 程式碼編排 | OKLCH 等只描述值的事實註解必須放在對應程式碼行尾；連續顏色定義必須靠攏，不以獨立註解行或空行拆散。 | 使用者明確要求，2026-09-07 | confirmed |
| SEM-007 | Kallopis 間距語意 | 架構／風格所有權 | 元件不得直接依賴責任過重的 `compact`／`halfCompact` 名稱；Semantic Theme 依 content、control、action、chrome、navigation、overlay、app frame、workbench、window header 與 dock scope 提供獨立欄位。預設完整間距指向 primitive 8px，半份組合邊界指向 primitive 4px，各欄位可獨立覆寫。 | 使用者明確要求進行風格語意重構，2026-09-07 | confirmed |
| LAY-008 | `KlpApp` 產品主內容與 Panel Tree | 呈現所有權／精確幾何 | App background 後只能由 Kallopis Panel Tree 組成；視覺葉節點一律為 `KlpPanelFrame`，每個 Frame 固定擁有 `dockMargin`，預設 4px。產品不得自行以原生布局排列第一層 Panel；`KlpDockLayout` 與 Rail frame 是合法 Kallopis 排版／配方節點，`KlpWorkbenchShell` 已刪除。 | 使用者明確要求，2026-09-07 | confirmed；修訂 LAY-006 的 Dock 外距所有權，欄位命名由 SEM-007 修訂 |
| DATA-001 | 所有具有資料語意的 container | 架構／呈現所有權 | Rail、Explorer 以及本庫其他資料型 container 必須以該元件專用的 immutable 資料模型與 typed callback 作為公開入口；不得以 `List<Widget>` 或任意 Widget tree 取代資料模型。純排版元件維持 layout-only，不承擔產品資料語意。 | 使用者明確要求，2026-09-07 | confirmed |

## 新規則記錄格式

新增規則時必須包含：

- `Scope`：只適用某元件、某產品、Workbench，或所有參考圖任務。
- `權限類型`：精確幾何、Kallopis 語意、呈現所有權或工作流程。
- `來源`：使用者明說的內容與日期；不要寫「從畫面看起來」。
- `狀態`：`candidate`、`confirmed` 或 `superseded by <ID>`。

只有明確的長期指示或跨任務重複規則可標為 `confirmed`。單次修正預設留在任務契約，不自動寫入本檔。
