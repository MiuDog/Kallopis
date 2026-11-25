# 桌面元件 Catalog v1

擁有模組：桌面通用元件分類與 examples 採用契約。階段：Iteration。使用者已授權先完整分類，再加入 Catalog 並實作；本輪延續 React。READY，契約內可逆組合自動接受。

## 範圍與驗收

| ID | 優先級 | 要求 | 驗收 |
| --- | --- | --- | --- |
| DC-01 | P1 | 分類涵蓋桌面骨架、導航、命令、輸入、選取、資料、回饋、浮層、媒體、設定與宿主整合 | 每類列出常見型態、指定入口與真實支援邊界，不用固定元件數量作為完整性證據 |
| DC-02 | P1 | 共用控制由 React 公開入口提供 | 欄位、選取、資料清單／表格、頁籤、回饋與對話框皆有真實可操作 specimen |
| DC-03 | P1 | 風格由 Kallopis semantic 與現有配方持有 | CSS 屬 library，example 不仿製；新組合只組合既有 field、button、surface、text、selection 配方 |
| DC-04 | P1 | 消費端可採用，展示清單不分叉 | 新公開元件接既有 specimen registry，Catalog 提供來源及專屬 route；使用公開 props 與 callback |
| DC-05 | P1 | 受控狀態及可及性 | label/id 關聯、disabled 不回呼、tabs 鍵盤切換、modal Escape 關閉及焦點還原；不同 Provider 不共享狀態 |
| DC-06 | P1 | 明示限制 | 原生視窗／檔案權限與系統通知由宿主；正文／程式碼／3D 核心由外部引擎；資料網格虛擬化與進階編輯不冒充基本表格 |

每種型態不必另造元件名稱：密碼、數字、日期、時間、顏色、檔案選擇可透過既有 KlpTextField 的原生 type；這些 picker 彈窗由瀏覽器／OS 呈現，不宣稱可套用完整品牌風格。複合畫面仍遵守 Example Catalog 白名單。

本輪新增一般表單／設定、表格式資料檢視、狀態回饋的合法組合類型；它們只能使用 Catalog 指定元件。表單驗證規則、排序／分頁資料運算與持久化由 consumer 擁有。

第三種 Panel 立體效果仍待原配方，不能藉本輪猜測。React 完成不代表 Flutter 已同步；感官品質待使用者評估。

## 通用桌面完整化（使用者已確認，READY）

本輪補齊通用桌面元件；專業內容與系統功能只提供整合入口。新增 P1 DC-07：Tree、MultiSelect、VirtualList、DataGrid、Popover、Drawer、ToastRegion、Spinner、SplitButton、Ribbon、ContentHost、SystemAction 必須各有公開實作、可操作 specimen 與清楚責任。TreeGrid 以公開 KlpTreeGrid 呈現階層表格，受控展開與選取，方向鍵導航；不自研試算表。DC-08：強調採正式微立體、無裝飾細框；與 Frame 共用同一配方。受控值、停用、鍵盤導航、焦點還原與非同步失敗須可驗證。虛擬清單採固定列高；Toast 的集合與移除由產品持有；宿主操作必須由明確按鈕觸發，不自動呼叫系統。
