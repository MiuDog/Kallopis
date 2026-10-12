# 互動文件與 GUI 範例 v1

擁有模組：reference site 互動文件。階段：0→1。目標版本：Interactive Docs v1。

Readiness：READY，2026-10-12 使用者已授權所有元件頁面互動、多場景復刻及整合網頁。

| ID | 版本 | 優先級 | 需求 | 可觀察驗收 | 狀態 |
| --- | --- | --- | --- | --- | --- |
| IDOC-01 | v1 | P1 | 所有公開可呈現元件有對應互動 specimen。 | Flutter public manifest 與 React 公開元件清單映射到展示 registry；缺項或無效 route 阻擋網站交付，不顯示假展示。 | accepted |
| IDOC-02 | v1 | P1 | 元件頁面嵌入實際框架元件及操作控制。 | Flutter 展示執行 Flutter Web，React 展示使用公開 package；修改 props／資料及觸發 callback 可見結果；靜態元件可修改自己的參數，不強加元件不存在的互動。 | accepted |
| IDOC-03 | v1 | P1 | 展示按當前元件及語意定位，提供重設及狀態查看。 | 各頁直接到自己 specimen；顯示公開入口及使用例，元件選取不退回無關總覽；Enum／data／extension 頁保留查表，不算元件 coverage。 | accepted |
| IDOC-04 | v1 | P1 | 以本庫元件復刻至少三種 GUI 場景。 | VS Code 檔案／編輯群組、Blockbench 創作面板、Blender 分區工作區各有 Flutter／React 範例；引用官方來源並列出復刻的結構及操作。 | accepted |
| IDOC-05 | v1 | P1 | GUI 範例真正使用庫的公開元件與命令。 | panel、tabs、toolbar、menu、palette、Explorer 與輸入等使用本庫；場景狀態在 example，業務示意內容不得升格成共用模板；拖放、保存還原及命令可操作。 | accepted |
| IDOC-06 | v1 | P1 | 範例與元件頁可切換風格。 | 預設及另一份 style pack 可切換，並展示尺寸變更；無第二份寫死共用樣式。 | accepted |
| IDOC-07 | v1 | P1 | 網站靜態部署與前綴路由正確。 | `/Kallopis/` 下可載入 bundle、字型及 Flutter assets；直接進入元件／場景路由及刷新不失效；載入失敗可辨識。 | accepted |
| IDOC-08 | v1 | P1 | 操作可及與觀察證據。 | 鍵盤操作、焦點還原、展示 iframe 名稱及獨立開啟入口有效；實際桌面及窄畫面驗證，不以建置成功替代互動觀察。 | accepted |

復刻指資訊區塊、布局關係及通用工作台互動；視覺仍採用選定 style pack。場景／編輯器／時間軸的產品核心以明確標示的示意內容承載，不宣稱執行 Blender、Blockbench 或 VS Code。展示控制不模擬已不存在的 runtime。

官方參考：[VS Code UI](https://code.visualstudio.com/docs/editing/getting-started/userinterface)、[Blockbench Panel](https://web.blockbench.net/docs/classes/generated_interface_panels.Panel.html)、[Blender 4.5 Workspaces](https://docs.blender.org/manual/en/4.5/interface/window_system/workspaces.html)。Blender 官方正文已透過本機 HTTP 取得（2026-10-12，200）：workspace 是針對任務的 area／editor 組合；Topbar 分頁支援切換、更名、新增及 context menu 的複製／刪除／重排。此證據解除先前搜尋工具無法讀取正文的限制；場景渲染與互動仍需實際驗證。

展示 registry 是可驗證的路由契約，不承諾每個型別都是 UI。非 Web 平台限定元件需提供其可在 Web 操作的呈現／host callback 部分並標示限制，不能宣稱 browser 可控制原生視窗。
