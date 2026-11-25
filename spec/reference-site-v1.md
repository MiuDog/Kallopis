# Kallopis 官網與文件子站

目前 stage：跨平台開發者 Reference 重整（2026-10-16），Iteration；擁有 module：`tool/reference_site`。使用者已接受單元件樣板及檔案架構並要求全面套用。公開 API、視覺規範及產品責任不變，不發布網站。

本 stage 的現行消費端契約為 [Reference 架構](../docs/reference/architecture.md)：Flutter／React 各自依公開 export 清冊維護每個宣告唯一 Markdown，提供主要職責、完整自有成員與方法、速成使用及必要限制；框架繼承成員連官方。網站與 AI 同讀此正文，舊 URL 導向新頁。畫面範例由 [examples](../docs/examples/architecture.md) 擁有：先使用本庫公開元件組合，使用者迭代與確認後才收錄實際截圖、組裝圖及 token 選用；未確認皆為 draft。

專案定位以 [跨框架核心目標](multi-framework-design-system.md) 為準；正式視覺內容以 [規範索引](../docs/design-tokens/KALLOPIS-DESIGN-MAP.md) 及其章節為準。網站落實 [維護規則的整合契約](../docs/design-tokens/maintenance.md)，不擁有另一份視覺內容。

| ID | 目標版本 | 優先級 | 需求 | 可觀察驗收 | 狀態 |
| --- | --- | --- | --- | --- | --- |
| VDOC-01 | 整合 v1 | P1 | 在 docs 中提供正式通用視覺入口，與 Flutter API 區分 | docs 首頁與文件導覽可進入規範索引及兩平台 Reference；只列真正公開的能力；既有 API 路由保留 | accepted |
| VDOC-02 | 整合 v1 | P1 | 由單一 Markdown 來源產生分章頁面與可用連結 | 索引、維護規則與六章皆可讀取；索引中的匯出快照另有明示快照頁；相對連結與 anchor 在專案前綴下正確 | accepted |
| VDOC-03 | 整合 v1 | P1 | 完整呈現 token／配方表格及記號 | 真正表格、程式記號、色碼、運算與繼承說明不遺失；窄畫面可操作並讀取完整表格 | accepted |
| VDOC-04 | 整合 v1 | P1 | 以內容搜尋規範 | 查詢 `parchment50` 或 `button-size-md` 可找到包含它的規範章節；既有 API 搜尋及無結果／載入失敗行為保留 | accepted |
| VDOC-05 | 整合 v1 | P1 | 對來源、頁面、路由與搜尋進行完整性檢查 | 必要來源缺失、漏頁、多頁、無效本地連結／anchor 或遺失規範搜尋內容時，產生或驗證失敗；既有 API 驗證不弱化 | accepted |

目前能力包含跨框架視覺規範、Flutter／React 開發 Reference 與場景草稿；本 stage 不搬移套件、不新增商業邏輯 library API。

以下既有網站要求仍適用於目前 Flutter Reference：GitHub Pages 從 theme、foundation、experimental 三個 public barrels 產生 module 分類及每個公開 class 一頁的正式 Reference；不保留 declarative／compatibility API，網站工作不改 Flutter 元件。

## 需求與權限

- 首頁介紹 Kallopis 實際提供的 semantic theme、Flutter 共用元件與產品組合邊界；不搬用 Planist 的 agent、執行績效、定價或下載宣稱。
- Flutter 正式 API 來源為 `kallopis_theme.dart`、`kallopis_foundation.dart`、`kallopis_experimental.dart`；React 為 `react/src/index.ts` 公開 export graph。不得產生 private implementation 頁面。
- 同一來源宣告被多個 public barrels 匯出時只產生一頁並列出全部入口；同名不同來源保留各自頁面。
- 參考 https://miudog.github.io/Planist/ 的精簡導覽、中央主標題、工作區視覺、編號分段與進入產品的行動入口。
- 所有頁面依 [style-v1](style-v1.md) 使用暖灰、平整 Frame、12px 圓角、子內容 padding、內容紙色與微浮陰影；表單／選單以底色分層、區域分隔使用虛線。
- 預設淺色；可切換深色、暖灰／中性灰與內容微浮偏好，跨子頁保存。深色主內容比側欄亮。
- 讀者為開發者與 AI；主入口為首頁「閱讀文件」，文件入口提供開始使用、架構、元件、API 與規格。
- 原有 docs、spec、README、CHANGELOG 的 Markdown 保留為單一來源，建立靜態 HTML 子頁與相對連結轉換。`.agents` 不是公共文件站的遷移範圍。
- 不刪 Markdown，不另維護文章副本；舊 URL 提供相對轉址以支援 GitHub Pages 專案前綴。
- 本次只建立可本地預覽與既有 CI 部署的產物，不自動 push 或改 GitHub Pages 設定。

## 畫面與生命週期

```mermaid
graph TD
	Home[官網首頁] --> Docs[docs 文件入口]
	Docs --> Guides[教學與架構文件]
	Docs --> Components[元件索引]
	Docs --> API[API 與來源圖集]
	Docs --> Specs[規格與決策]
	Docs --> Project[README 與變更紀錄]
```

```mermaid
graph TD
	Markdown[單一 Markdown 來源] --> Generator[靜態產生器]
	Layout[共用 shell 與首頁] --> Generator
	Style[風格 v1 CSS] --> Page[靜態頁面]
	Generator --> Page
	Page --> Search[本地文件搜尋]
	Page --> Preference[瀏覽器偏好]
```

```text
Markdown source → source-to-route mapping → parser → 共用文件 shell → docs 子頁
風格預設 → 可選瀏覽器偏好 → CSS 根層變數 → Frame／內容／控制
舊路由 → 相對新路由轉址；無登入、編輯或後端寫入
```

桌面文件頁為左側導覽＋中央文章＋右側段落索引；窄畫面收合導覽並改單欄。搜尋應含 API、指南、規格與元件，提供無結果／讀取失敗狀態；文章表格、程式碼、標題 anchor、圖片與 Mermaid 不得靜默遺失。鍵盤可操作導航與偏好，保留可見焦點。

## 驗收

- 產生器與既有 Pages workflow 一致，首頁／docs／舊路由可到達。
- 文件數量與來源清單一致，檢查相對連結、anchor、表格與程式碼。
- 目視桌面／窄視窗首頁與文件頁，操作搜尋、導覽、明暗與自訂風格。
- 記錄原來源中的失效連結，不以未驗證內容冒充完整遷移。
