# KLP-0020：採用 BlockNote 作為正文編輯器

## 狀態

Implementing（2026-09-12）。使用者已同意採用 BlockNote；獨立原型可用，正式 consumer／保存／資料遷移尚未完成，不標 Accepted。

## 決策與理由

### 2026-09-13 補充：統一接口與暫時棄用範圍

使用者確認目標為 **Planist → Krepis 統一筆記接口 → BlockNote 正文引擎**。Krepis 負責統一文件身份、編輯工作階段、保存與引擎轉接；BlockNote 保有正文模型、排版、選取、交易與 undo／redo 權威。Kallopis 負責語意風格、宣告式呈現與 WebView 宿主。不得把採用 BlockNote 解讀成繞過 Krepis，也不得把接入 Krepis 解讀成恢復自研正文引擎。

**自研正文部分標註「暫時棄用」**：包含舊 Krepis 自研正文模型、文字排版／選取、文字與清單交易、undo／redo，以及專供該引擎的正文 binding／呈現路徑。不再作為新正文功能的預設實作或擴充方向；僅保留供既有文件相容、必要維護與回退。此標註不棄用 Krepis 統一接口、可重用的身份／保存能力，也不將尚待選型的手寫與 Spatial 一併棄用。

這是開發狀態標註，不是刪除程式、停用既有執行路徑、移除測試／CI 或轉換資料的授權。現有檔案保留；不得將 BlockNote 文件先轉成 Markdown 再交舊核心，冒充 Krepis 封裝 BlockNote。Krepis 的 BlockNote 工作階段轉接已由 `krepis_block_note` 套件提供，Planist 使用該公開接口，Kallopis 保留呈現與相容 re-export。2026-09-13 核對現行依賴指向 `D:/Projects/Krepis/bindings/block_note`（另一任務建立）；本任務僅讀取該樹，未修改或同步至 `Krepis-m0-checked-save`。功能驗收現況見交接，不將接口存在等同完整第一版完成。

正文採用上游 BlockNote，先固定原型已驗證的 0.54.2 與 lockfile，避免繼續自建完整文字編輯核心。依據是 [原型比較](../../docs/architecture/editor-library-comparison.md) 的實際操作與整合成本；不因已有 Krepis 投入而重做上游功能。

AppFlowy 不作本輪正式接入方向，保留原型供參考。手寫與 Spatial 仍需另外選型；本決策沒有採用付費 XL 套件或授權付款，也沒有將 BlockNote 當成完整 Notion／Concepts／Miro 替代品。

## 權威與邊界

- 新 BlockNote 正文路徑由上游文件模型、selection、排版與 undo 管理編輯狀態，不把每次按鍵送回 Krepis，不維持第二份即時正文權威。
- Kallopis 保留品牌、公開受限組裝、宿主生命週期及語意風格整合；內部可以封裝 Web 編輯區。Consumer 不注入任意 HTML／JS、原生 Widget、局部 style 或任意命令。
- 正式保存由宿主持久化 adapter 承接版本化文件與資產；原型 localStorage 僅供比較，不等於正式可靠保存。具体保存介面在首個接入切片固定，不繼承 Krepis 專用正文交易要求。
- 舊 Krepis 路徑與資料仍保留原權威，直到有可驗證轉換與回退。新舊文件有明確格式標識；未支援轉換不能靜默丟棄 marks、區塊或筆跡。保留原檔，先在副本上轉換。
- 本決策僅取代 KLP-0019／AGENTS 中「新正文也必須由 Krepis 管理文件、排版、選取、undo」的要求；其他宣告式 API／樣式所有權與舊路徑約束仍有效。不刪現有程式、測試、CI，不放寬 allowlist。

## 首個正式接入切片

讓一份獨立 BlockNote 文件能在現有 Flutter Catalog 編輯區開啟、輸入、保存、關閉及重開。先打包本地 web assets，封裝 WebView／受限橋接，沿目前 consumer 組裝與宿主保存入口；不一次改 Planist 全部頁面。

接入驗收：真實 WebView 中文組字與焦點、跨區塊貼上、清單／表格／圖片、undo／redo、保存失敗回饋、关闭重開與資產位置。只有涉及資料／橋接風險才補最小必要測試，先最高層局部流程。頁面重載不能冒充 durable save；未保存變更的关闭策略沿使用者既有確認，不靜默丟失。

後續才接 Planist 與舊文件轉換；轉換驗收通過前不切換舊文件預設讀取器。舊正文核心的停用／刪除需有實際引用核對與可回退成果，不因選型決策立即清理。

## 成本與未決事項

接受 WebView、資產包、橋接與資料格式轉換成本，以換取上游成熟編輯功能。真正中文 IME、手機、讀屏、WebView 剪貼簿與正式保存仍未驗證。需保留 BlockNote MPL notices；若日後需要 XL 功能，依其具體授權另作選擇，不默認可免費用於閉源產品。
