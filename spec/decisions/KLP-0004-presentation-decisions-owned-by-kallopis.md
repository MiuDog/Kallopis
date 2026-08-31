# KLP-0004：產品提供語意，呈現決策由 Kallopis 擁有

## 狀態

Accepted（2026-08-31）

## 決策與適用邊界

Kallopis 擁有跨產品共用前端的完整呈現決策：元件選擇、元件組合、間距、尺寸、對齊、
換行、響應式行為、chrome 與互動狀態外觀。產品只提供產品語意、資料、狀態、事件與主要
內容，不在標準工作台接入點重新指定上述視覺細節。

標準工作舞台使用 `KlpStageFrame.workbench`，由它組合 `KlpStageHeader`、內容區與
`KlpStatusBar`。`KlpStageHeader` 不接受任意 action widget 或換行模式；舞台內距固定讀取
Kallopis 的 `space.compact`。若新產品需要另一種共通呈現，先在 Kallopis 建立語意 API、
token 與測試，再由產品採用，不在產品內以 `EdgeInsets`、固定尺寸或任意 widget slot
建立平行規格。

產品特有的資料模型、文案、業務流程與內容本體仍由產品擁有。這不推翻 KLP-0003：只有
產品語意的功能元件不因本決策被搬進 Kallopis；但它依賴的通用視覺原語與組裝規則仍應
由 Kallopis 提供。

## 推導依據

如果每個產品自行組合相同的 header、status、panel 與 breakpoint，即使都使用 Kallopis
token，仍會產生多份不同的前端規格。這會讓新產品必須重新回答「間距多少、是否換行、
按鈕放哪裡」等已經決定過的問題，無法直接取得完整生態系。

否決方案：

- 只提供 token，讓產品自行排版：只能統一數值，不能統一元件結構與響應式行為，拒絕。
- 保留 `actions`、`wrapTitle`、`padding` 等標準入口的視覺覆寫：會把設計決策重新交回
  產品，拒絕。
- 把產品資料模型也移入 Kallopis：會反轉產品與視覺庫的依賴方向，且違反 KLP-0003，拒絕。

## 代價

標準元件的視覺變體必須先修改 Kallopis，不能在單一產品中快速局部覆寫。這增加共用庫的
審查成本，但換來所有產品一致的行為、測試與升級路徑。低階組合原語仍可供 Kallopis 自身
與 Catalog 使用，但產品預設接入高階語意 API。

## 閘門

- `KlpStageHeader` 的公開建構子不得出現 `actions` 或 `wrapTitle`。
- `KlpStageFrame` 的標準工作台接入由 `workbench` factory 組合 header 與 status，且不公開
  stage padding 覆寫。
- `KlpWorkbenchWindowHeader` 依 primary 與 secondary pane 的即時寬度定位兩側收合按鈕；
  產品不計算按鈕座標。
- Secondary pane 收合時，Stage actions、header actions、pane toggle 與視窗控制區必須由
  `KlpWorkbenchWindowHeader` 配置在同一條互斥水平序列中，不得以重疊 Stack 各自搶占空間。
- `KlpFileExplorer` 的節點列分為樹狀控制區與內容區；沒有展開控制的節點仍保留控制區空槽，
  同層節點以內容 icon 左緣對齊，預設層級縮排使用 `space.tight`（`space.compact` 的一半）。
- `KlpStatusIndicator` 自身擁有左右 `space.compact` padding，垂直 padding 固定為零；
  `KlpStatusBar` 不重複包覆整列間距。
- Stage header 測試機械驗證兩行距離、自動長標題換行、沒有 action button，以及 factory
  會建立 header 與 status。
- `tool/verify.ps1` 必須通過 format、analyze、inventory、根套件與 Catalog golden 全部閘門。
- Designist 的工作舞台只傳語意資料給 `KlpStageFrame.workbench`，並由產品 widget test 驗證
  不存在預覽、匯出或 Inspector header action。

## 已知欠債

部分較早建立的低階 Kallopis 元件仍保留視覺覆寫參數。它們不在本次 Stage API 的破壞性
變更範圍；後續依相同判準逐一提供高階語意入口，再移除產品端使用。
