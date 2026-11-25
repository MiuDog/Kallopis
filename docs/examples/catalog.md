# Example 採用 Catalog

狀態：基礎採用規則依使用者 2026-10-16 指示建立；現有 example 尚未完成逐項合規驗收。框架無關的責任規則適用所有 example，本輪具名元件對照先落在 React；Flutter 須依其公開入口補對照，不套用 React 型別。

本 Catalog 規定「出現某種角色時必須採用哪個元件」，不是要求每個畫面展示全部元件，也不是固定數量的元件清冊。公開 API 完整清單仍由 [互動元件清單契約](../architecture/interactive-component-registry-contract.md) 擁有。

桌面用途總覽見 [桌面元件分類](desktop-components.md)，可操作入口為 `/?catalog=desktop`。分類資料與畫面共用 `react/example/desktop-catalog-data.mjs`。

## 一、基礎元件：所有 example 必須遵守

| ID | 畫面角色 | React 指定元件／入口 | 可調整範圍 | 禁止替代方式 |
| --- | --- | --- | --- | --- |
| BASE-01 | 主題、字型、明暗與風格 | `KlpThemeProvider`、公開 style pack API | 有效語意覆寫、mode；資產保留 package ownership | 第二份 theme、頁面私有共用風格預設、硬編碼品牌值 |
| BASE-02 | 一般工作區 | `KlpWorkspace`；需要有限尺寸解算時使用 `KlpAppLayout` 與 `KlpLayoutRow/Column/Pane/Divider/Spacer` | 公開布局參數、內容區比例及排列 | 重做共用尺寸解算或把一般布局強制轉成 Dock |
| BASE-03 | Panel／側欄／閱讀區外框 | `KlpFrame` | role、header、footer、內容與公開 surface 選項 | 自製 Panel 陰影、邊框、圓角或覆寫內部 header/body CSS |
| BASE-04 | 非 Panel 的語意表面／資訊卡 | `KlpSurface`／`KlpCard` | 公開 tone、內容、header/footer | 用普通容器複製共用表面配方；用 Card 代替可操作清單元件 |
| BASE-05 | 標題、正文、說明、代碼文字 | `KlpText` | 公開 role、tone、語意化 HTML 標籤與內容 | 頁面各自定義字級、字重、字色或第二套 typography |
| BASE-06 | 一般動作、參數值選項 | `KlpButton` | 公開 tone、size、selected、disabled 與 callback | 改寫內部高度／padding／背景，將 Button 改造成另一種元件 |
| BASE-07 | 圖示動作與工具列 | `KlpIconButton`；註冊命令用 `KlpRegisteredCommandToolbar` | 圖示、可存取名稱、命令與狀態 | 用文字按鈕代替快捷鍵命令；未定義圖示時用任意符號占位 |
| BASE-08 | 單行輸入與搜尋 | `KlpTextField` | value、事件、label、hint、error、disabled；高度從 style pack 調整 | 原生 input 自製同款外觀、CSS 強壓高度、參數標籤與輸入改成 grid |
| BASE-09 | 分組導覽、簡單資料選取 | `KlpFileExplorer` | section/item 資料、選取與展開 callback | 自製 Explorer row、複製 hover/selected；恢復 node/adapter/renderer 層 |
| BASE-10 | 狀態標記 | `KlpBadge` | 公開 tone 與文字，顏色以外亦可辨識狀態 | 每頁新增徽章樣式或以品牌色取代狀態語意 |
| BASE-11 | 命令選單、浮層、搜尋命令、快捷鍵 | `KlpRegisteredCommandMenu/Popup/Palette`、`KlpCommandShortcutHost` | 同一 registry 的命令、條件、handler 與公開配置 | 分散複製命令狀態、另造選單樣式或繞過 disabled |
| BASE-12 | 多行資料選取清單 | `KlpList`／大量固定列高用 `KlpVirtualList` | items、selectedId、onSelect、disabled、empty | 用 Button 加私有 CSS 模擬清單 |
| BASE-13 | 表單選取與多行輸入 | `KlpTextArea/Checkbox/Switch/RadioGroup/Select/ComboBox/MultiSelect/Slider` | 公開 label、值、狀態與事件 | 各頁自製共用控制外觀 |
| BASE-14 | 表格與內容導航 | `KlpTable/DataGrid/Tree/Tabs/Accordion/Breadcrumb/Pagination` | 資料投影、受控值、內容槽 | 複製表格或頁籤內部樣式 |
| BASE-15 | 回饋與補充資訊 | `KlpAlert/Progress/Spinner/EmptyState/Dialog/Drawer/Popover/Tooltip/ToastRegion/StatusBar/Skeleton` | 訊息、值、開關狀態與內容槽 | 自製第二套浮層與回饋樣式 |
| BASE-16 | 連結、身份與分隔 | `KlpLink/Avatar/Separator` | href、標籤、圖片與語意 | 各頁複製共用視覺 |

原生 `main/section/article/div` 與 React state 可用於產品內容、可及性與非視覺結構；不因此取得重做共用元件的許可。一般內容排版可以使用 flex/grid，但參數設定維持 label＋control 的 row。組合必須遵守 [正式配方](../design-tokens/recipes.md)。

## 二、風格選擇與密度

- 元件及內部部位禁止圓形／膠囊形，使用方形或長方形加圓角；包含 checkbox、radio、toggle 把手、slider、avatar、badge 與載入點。尺寸以正式語意表為準，example 不另覆寫幾何。

- 禁止使用裝飾細邊框及左側強調線；以語意底色、留白與微立體區分區塊；強調表面沿用 Frame 的正式微立體配方，不另造陰影。允許低對比細虛線，用於資料列與群組分隔；欄位焦點提示畫在既定尺寸內，不擴張輸入框外徑。

- Panel 風格與畫面類型分開：研究 example 明確採微立體；其他 example 不因這次選擇自動改版。React 已確認的公開選項為 `flat`（平面）與 `raised`（微立體）。
- 使用者指定的「立體」是第三種期望選項，既有配方尚未定位；目前標記缺件，不以自訂 shadow 冒充已支援。
- 明暗、密度與 Panel 風格各自控制；只透過公開參數與合法 style pack 改變。切換風格不重設資料或輸入。
- 所有清單選項之間須留白，項目內 padding 與項目間距分開；共用互動列的間距由共用元件擁有，不能以 example 後代 selector 改寫內部。
- 本 Catalog 不抄錄 token 數值；正式數值、狀態與配方以 [通用視覺規範](../design-tokens/KALLOPIS-DESIGN-MAP.md) 為準。Example 的實驗覆寫需標示，不能宣稱成為正式預設。

## 三、特定畫面類型的擴充白名單

只有下列類型可在指定 slot 擴充。型別名稱與內容槽是採用邊界，不是固定業務順序；產品仍擁有自己的資料與流程。

| 類型 ID | 畫面類型 | 指定骨架 | 允許擴充的 slot／能力 | 不包含的許可 |
| --- | --- | --- | --- | --- |
| SCENE-READ | 資料閱讀／研究 | 基礎工作區＋Frame＋Explorer＋Text＋TextField | 閱讀內容區的段落、圖片、引用；資料投影、搜尋、備註事件 | 自製多行可選卡、正文編輯器核心、特殊 Panel 風格 |
| SCENE-PRODUCTIVITY | 單左欄生產力畫面 | `KlpModernProductivityLayout` | 公開 panels、header、stage slots；產品專用內容與事件 | 複製該布局內部或繞過其合法組合 |
| SCENE-WORKBENCH | 停靠工作台 | `KlpDockLayout`＋registered commands | Panel registry 的內容、受控分頁／布局、命令 handler | 自製拖放／停靠核心、替換共用分頁與命令樣式 |
| SCENE-CANVAS | 視覺創作／媒體預覽 | 基礎骨架或既有 Workbench | Stage 中的 canvas、SVG、圖片、影片與內容座標互動 | 將畫布特有樣式套到應用 chrome、重做屬性輸入元件 |
| SCENE-SPECIMEN | 單元件 API 展示 | 被展示的公開元件＋Provider | 該元件合法參數、狀態及成功／失敗展示；外層評估工具 | 把展示工具視為消費端必備產品 UI；用 placeholder 冒充元件 |
| SCENE-FORM | 表單／偏好設定 | Frame＋BASE-13＋Accordion＋Alert | 欄位資料、驗證、提交與復原事件 | 重做欄位內部風格、另建驗證權威 |
| SCENE-DATA | 資料管理 | Frame＋List／Table＋Pagination | columns/rows 投影、產品排序與篩選 | 自製試算表／TreeGrid 核心或覆寫資料列內部樣式 |

日曆、時間軸、富文字編輯等未列出的能力，不因畫面名稱而自動取得例外。需要時先登錄擴充：畫面類型、slot、所需能力、資料／事件 ownership、可依賴的公開 API、不能改動的基礎角色及驗收條件。專業內容使用 KlpContentHost 接入已選引擎；系統能力使用 KlpSystemAction 接宿主 callback。缺少共用元件應回到 library contract 補足；不得讓每個 example 各自實作。

擴充不得以「custom」或「其他」登錄無限制豁免。當同一能力跨情境重用時，重新評估是否應由公開共用元件擁有；不直接將產品業務提升進庫。

## 四、現有 Example 登錄與缺口

| Example | 類型 | 實作入口 | 採用狀態 |
| --- | --- | --- | --- |
| React 核心總覽 | 基礎元件組合 | `react/example/main.tsx` | 待逐項檢查；不是已核准模板 |
| React 元件 specimens | SCENE-SPECIMEN | `react/example/specimens.tsx`、`specimen-registry.mjs` | 保留公開清單與 route 驗證；新 Catalog 合規待查 |
| VS Code／Blockbench／Blender 工作區 | SCENE-WORKBENCH；畫布內容可加 SCENE-CANVAS | `react/example/scenarios.tsx` | 現有可操作展示，風格採用與人工接受另行記錄 |
| Modern productivity | SCENE-PRODUCTIVITY | `react/example/modern-productivity-starter.tsx` | 已有可複製入口；畫面仍為 draft |
| 研究資料庫 | SCENE-READ | `react/example/research/library.tsx` | draft；微立體、KlpList、KlpWorkspace 已接入，視覺待人工接受 |
| Layout／Dock／Commands demos | SCENE-SPECIMEN | `react/example/layout-demo.tsx`、`dock-demo.tsx`、`commands-demo.tsx` | 供能力展示；不得自動當作完整產品模板 |

研究 example 已移除以 KlpButton 改造的多行資料卡，改用公開 KlpList；外層使用 KlpWorkspace，頁面 CSS 僅決定欄寬與換行。新增桌面 Catalog 與 specimens 提供實際操作；其他舊 example 仍待逐項稽核。

## 五、每個 Example 的交付門檻

1. 登錄畫面類型、來源檔案與實際使用的 BASE ID；不適用的角色可省略。
2. 擴充逐項對照白名單的 slot；未登錄能力不進入可採用範例。
3. 情境畫面與 demo 資料／風格控制分離；提供必要檔案、公開 import、資料與事件接入方式。
4. CSS 只持有該畫面內容布局；不得覆寫共用元件的內部視覺與互動。發現缺能力時記錄缺件。
5. 記錄適用狀態、渲染觀察、已執行 code checks 與未驗證項；風格切換保留 consumer 狀態。
6. 程式可執行、Catalog 合規、人類視覺接受分別記錄。只有使用者接受具體版本後，才從 draft 改 approved。

本文件是採用政策，尚未加入自動 lint／CI 閘門；現有 registry 與發布檢查繼續保留。後續目錄： 既有 React examples 逐項登錄 → Flutter 公開元件對照。
