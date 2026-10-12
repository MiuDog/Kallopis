# React Foundation v1

日期：2026-10-11；擁有 module：`react/`；stage：0→1；需求 READY。

使用者明確選擇完整通用 token／語意接入與核心元件、展示，而非所有 Flutter API 逐項移植。本規格屬於 [跨框架核心目標](multi-framework-design-system.md) 的第一個 React 交付，不改正式視覺內容。

| ID | 版本 | 優先級 | 需求 | 驗收 | 狀態 |
| --- | --- | --- | --- | --- | --- |
| RF-01 | v1 | P1 | React 框架庫位於第一層 `react/`，可被一般 React 產品使用 | 套件匯出 JavaScript、TypeScript 宣告及樣式；獨立 consumer build 可匯入公開入口，React 為 peer dependency | accepted |
| RF-02 | v1 | P1 | 全部正式 primitive、350 個 theme 語意與既有配方接入，沒有第二份人工預設 | 建置直接讀取正式 Markdown；四個主題完整可解析；引用缺失、重複、循環或無法解析不得靜默略過；生成產物有來源證據與新鮮度檢查 | accepted |
| RF-03 | v1 | P1 | Theme Provider 與公開 hook 提供語意與主題切換 | light／dark／ultraDark／transparent 可切換；缺 provider 明確報錯；不同 provider 範圍不互相污染；透明模式明示依賴宿主能力 | accepted |
| RF-04 | v1 | P1 | 交付文字、表面、Card、Badge、按鈕、IconButton、文字輸入、Frame、Workspace、Explorer 核心元件 | 直接 React 元件與 DOM；型別化用途／尺寸；語意配方可追溯；disabled、selected、error、focus 等受影響狀態遵守正式規範 | accepted |
| RF-05 | v1 | P1 | Explorer 為產品資料投影與 callback 元件 | 可展開／收合 section 與選取 item；選取狀態由 consumer 提供；鍵盤可操作；hover／selected 同色；不建立產品 node／adapter runtime | accepted |
| RF-06 | v1 | P1 | 資產所有權、鍵盤、標籤與宿主責任清楚 | 字型及授權隨套件接入而非靜默 fallback；IconButton 有 accessible name，輸入有 label；layout、路由、資料與業務流程由產品擁有 | accepted |
| RF-07 | v1 | P1 | 提供真實 consumer 展示及文件 | 本機可執行；能切換主題並操作輸入、按鈕和 Explorer；以產品資料及公開入口組合；打包結果與文件接入可驗證 | accepted |

公開內容採 `Klp` 名稱，包含 Provider、semantic hook、primitive／theme／recipe 資料與核心元件。完整配方是語意參考，不宣稱 118 組配方全都已有獨立 React 元件；尚未實作的 Menu 等組合保持明示，不新增未確認設計。

成功路徑：產品安裝套件與樣式 → Provider 選用主題 → 使用公開元件並取得語意 → 回呼交回產品 state。無效用途或缺失語意應明確失敗；不得猜測公共 token。可逆 API 與打包細節由 PLAN 選擇；不發布 npm、不新增產品專用模板、不修改 Krepis。

能力地平線：此版可重用核心庫；新增元件依正式語意、實際 caller 與跨產品重用另行決定，不要求固定全量 Flutter 清冊。
