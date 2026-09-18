# 工作區第一版元件

新 consumer 只使用 `kallopis_declarative.dart`。Planist 的核准畫面來源為 [HTML 設計基準](../../design/planist/README.md)；本頁說明共用能力，不把 Planist 的功能順序或文件資料變成框架預設。

## 組裝責任

`KlpAppLayout` 下透過 `LayoutRow`／`LayoutColumn` 組合 `KlpAppFrame` 與無材質的 `KlpLayoutPane`。Frame 子元件先承接 `KlpFrameGroups`，由各 `KlpFrameGroup` 決定水平 padding 與前置 divider。使用 `KlpPadding` 時，它是同一個群組元件的別名，沒有第二份預設值。

`KlpLayoutPaneSize` 提供 trailing、content、expand 尺寸角色；expand 預設分配剩餘空間，其餘依角色保留固定尺寸。`KlpFrameGroupStyle.contentSpacing` 可選 standard（目前 20px）或 none；透明群組 divider 為 4px，水平 padding 只在擁有內容的群組選用一次。

導覽及文字區塊使用 `KlpWorkspaceBlock`；Explorer 與原生視窗控制繼續使用 `KlpExplorer`／`KlpWindowControls`。不要建立單一固定工作區 leaf 來隱藏整個產品結構，也不要以新的文字列複製 Explorer。

| 能力 | 公開節點／資料 | 責任 |
|---|---|---|
| 品牌與導覽 | `KlpWorkspaceBlock` 的 identity／action | 接收名稱、受控圖示、選取狀態，以及一般回呼或由 application handler 派送的 `KlpAction` |
| 正文組合 | `KlpWorkspaceContent`／`KlpWorkspaceContentBlock` | 受限插槽中的行列、文字、標題、提示、divider、連結與待辦 |
| 紙張與便利貼 | paper／sticky、`KlpWorkspaceMaterial` | 選擇材質及微浮陰影，幾何與顏色由語意解析 |
| 搜尋 | search、query／回呼／結果項目 | 輸入與呈現；搜尋資料來源、篩選規則與開啟流程由產品擁有 |
| 外觀選擇 | settings、`KlpWorkspaceChoice` | 呈現受控選項；產品以唯一應用宣告替換主題 |
| 清單與卡片 | `KlpWorkspaceItem` | 純呈現資料、選取／勾選狀態與使用者意圖 |
| 樹狀文件 | `KlpExplorer`／`KlpExplorerItemModel` | 受控展開、選取；不讀檔案系統 |
| 視窗控制 | `KlpWindowControls` | 發出 host 意圖、反映真實最大化狀態；不自行假設作業系統已執行 |

正文子節點必須出現在 `children` 與其 slot 中，使用唯一 ID 參與驗證、編譯及安裝。`items` 是沒有獨立宣告式身分的資料列；不可拿它藏另一棵結構樹。

需要 `navigate`、`finish` 或 `back` 時，把 `KlpRouteInput` 產生的 action 指定給 `KlpWorkspaceBlock.action`。它會先經 handler 資格檢查，再使用該 placement 與目前 frame lease 派送；被新 application frame 取代的舊按鈕不能繼續導覽。`action` 與 `onPressed` 互斥，單純產品資料更新才使用 `onPressed`。

## 樣式與產品狀態

元件透過 semantic resolver 取得字體、顏色、間距、圓角與陰影。公開選項不接受 Flutter Widget、原始 padding、Color 或外部 painter。Frame 保持無細邊框、無陰影；微浮只作用於選用該效果的內容材質。

產品負責決定哪些文件顯示右側欄、如何排列便利貼、工具列有哪些操作，以及搜尋結果如何開啟文件。視覺展示或記憶體互動不代表已完成正式編輯、保存、undo 或跨重啟恢復；這些仍由既定文件權威提供。

第一版幾何的實際整合驗收位於 Planist `frontend/test/workspace_design_v1_test.dart`；元件層的狀態控制、鍵盤及 primitive 替換仍由本庫既有公開入口整合測試驗證。

## Lucide 圖示

Planist 第一版工作區採用 Lucide 官方 SVG。`KlpWorkspaceIcon` 表達圖示語意，renderer 經唯一 `KlpFlutterLucideIcon` 載入 package-owned asset；顏色與尺寸仍由已解析語意傳入。新增 sparkles、image、music、board、lightbulb、calendarCheck 語意，原列舉值順序不變。

圖示資產保留固定上游 revision 與授權，見 [Lucide 資產說明](../../assets/icons/lucide/README.md)。筆畫使用 24px 網格內的 1.5 比例，對齊 HTML 參考；不由 consumer 注入 SVG 或路徑。Explorer 箭頭與視窗控制同樣使用 Lucide。未遷移的舊相容元件仍保留 UIcons，不把整庫圖示轉換宣稱已完成。

## 頂部背景拖曳

`KlpAppLayout.onHeaderDrag` 是可選的宿主意圖回呼。啟用時，頂部範圍由語意解析的外距與 header 高度決定；滑鼠左鍵按下背景或靜態文字時觸發，互動按鈕、連結與文字輸入區保留原操作。正文不觸發。消費端不傳入像素尺寸、Widget 或平台實作；Planist 將回呼接至 `PlnWindowHost.startDragging`，由 Win32 執行移動。

視窗控制列保留共用 header 高度 32px，內部按鈕為 32px 方形、圖示 16px，按鈕間距 4px，按鈕與頂列同高；與下方內容的距離由 12px 組間距提供。原有控制欄寬度不變，按鈕組靠右；空白仍屬 header 拖曳背景。尺寸由既有 extent／gap 語意解析。

頂列與主內容的組間距使用標準布局間距 12px；側欄第一個內容群組使用 `KlpFrameGroupDivider.sectionGap`（12px 透明間隔）對齊。既有 `transparentGap` 保持 4px，供 Explorer 分類及組內緊密排列使用。

Planist 左上頂列不顯示 logo／title，identity 可傳空標題且省略 symbol，僅保留右側搜尋／外觀動作；頂列與導覽列均解析為 32px。

導覽列與 Explorer 的 hover／selected 共用既有 selectedBackground 與圓角，只改背景；文字／圖示顏色不隨狀態改變，導覽文字維持一般字重。Hover 為暫態，selected 由產品資料控制；滑鼠移開不取消 selected。

## Explorer 整合契約

使用 [Workspace.Explorer / SFC-V1-r1](explorer-model.md)：可實作的分類／節點資料、有限能力、完整森林、明確 selection scopes、不可變 drop acceptance 與單一 intent。Consumer 不提供 Widget、style 或任意排列；背景透明、事件受控。舊 Explorer callbacks 與專用 Widget 已移除，沒有相容路徑。

所有尺寸、圖示、分類字級及間距都有獨立 semantic 用途；當前候選與人類接受項目見 [Explorer Catalog](explorer-catalog.md)。分類能否選取／收合及標題主動作依 consumer 能力宣告，角色不覆蓋能力。

### 浮動操作與底部群組

`KlpAppLayout.floatingAction` 接受 action 類型的 `KlpWorkspaceBlock`，作為同一結構樹的受限插槽。預設位於右下角，可拖曳且不觸發點擊；位置在畫面更新時保留，視窗縮放時限制於可見範圍及 header 下方，不跨重新啟動保存。

`KlpFrameGroups.footer` 接受單一 `KlpFrameGroup`，固定在底部置中；前方群組於剩餘高度內捲動。未提供 footer 時沿用既有群組布局。虛線分組上下各保留 4px，透明分類間隔仍為 4px。


### 統一互動回饋

新版工作區操作、Explorer、視窗控制、選擇原語及工具控制共用 `KlpFlutterSelectionSurface`，hover／press／selected 使用同一中性圓角底色，不另畫 focus／selected 邊框，不因互動改字色或字重。Material 選單與表單由 `KlpFlutterInteractionTheme` 投影同一份已解析語意，停用時不產生 hover／press 回饋。Explorer 分類與節點的能力皆由 consumer 宣告；選取及焦點按同一互動用途呈現。

視窗控制命中區保持 32px；最大化／還原圖示採 14px 光學補償，最小化／關閉仍為 16px。


底部圖示工具列使用 `KlpWorkspaceBlockKind.toolbar` 與 `KlpWorkspaceItem`：膠囊容器內排列 32px 圖示按鈕，外圍與按鈕間距為 4px。`title` 作為 tooltip／輔助標籤，`selected` 控制共用互動底色；工具列不顯示文字標籤。
