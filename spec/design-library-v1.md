# Kallopis 共通風格與互動展示 v1

擁有模組：Kallopis 共通設計規範。階段：既有設計系統迭代。目標版本：共通風格與互動展示 v1。狀態：DEFINE／READY。使用者已確認保留 Flutter／React 既有入口。

## 目標

從同一處查詢風格、取得能帶進自己專案的範例，並在 GitHub Pages 操作 Kallopis 的實際元件及組合。既有視覺語意、元件組合限制與產品資料責任以[跨框架核心目標](multi-framework-design-system.md)為基礎。

## 需求與驗收

| ID | 版本 | 優先級 | 需求與決策 | 可觀察驗收 | 狀態 |
| --- | --- | --- | --- | --- | --- |
| DL-01 | v1 | P1 | 集中共通風格至根目錄的風格模組，包含一份主要色彩資料、範例圖片及可讀的元件組合程式碼。沿用現有 `styles/`。 | 從 `styles/` 可定位原始風格值、圖片與組合範例。主要資料可機讀，包含 primitive 與 semantic 色彩 token，保有四種既有模式。遷移前後逐項比對語意、值及引用，框架與網站的衍生內容可由同一來源重建。 | accepted |
| DL-02 | v1 | P1 | 共通 token ID 自動對應 Flutter／React 元件的實際引用。各框架目錄負責元件實作、框架必要的接線及開發驗證。 | 由共通 ID 可查到兩框架的名稱及實際使用處。名稱轉換可重現。遺漏或無法解析的使用中 token、名稱碰撞及衍生資料過期會使發布驗證失敗；尚未支援的框架對應可辨識。 | accepted |
| DL-03 | v1 | P1 | 跨專案的主要路徑是查詢並複製，範例以目標框架可貼用的程式碼提供。Flutter／React 保留既有公開套件入口與相容使用方式。 | 可在乾淨的目標專案使用複製的 token、程式碼及標示的資產，無需安裝 Kallopis 套件。既有 consumer 可用原公開匯入完成原有操作。 | accepted |
| DL-04 | v1 | P1 | GitHub Pages 首頁以實際元件及組合互動為主要入口，提供風格查詢與範例複製。API 與文字規範可由次要導覽進入。 | 首頁可直接進入 Flutter／React 展示。可呈現元件使用真實框架實作，並操作該元件所支援的狀態、輸入或回饋。既有組合展示與公開元件涵蓋契約見[互動展示 v1](interactive-docs-v1.md)。展示載入失敗有可辨識的回饋。 | accepted |
| DL-05 | v1 | P1 | 使用現有 GitHub Actions Pages 重新發布驗證通過的互動展示。 | GitHub Pages 的實際網址可開啟新首頁；從 `/Kallopis/` 進入展示、直接開啟深層連結或刷新時，腳本、字型及資產可載入。瀏覽器實際操作兩個框架的元件並核對複製內容。 | accepted |

## 來源與介面

- 以[正式設計統整](../docs/design-tokens/KALLOPIS-DESIGN-MAP.md)及[既有風格包契約](style-pack-v1.md)為遷移依據。先取得逐項等價及框架驗證，再切換風格資料權威。合法組合規則、任務流程與產品狀態延續既有責任分工。
- 範例圖片、組合程式碼與主要風格資料共同位於根風格模組。程式碼與資產仍可獨立取用，風格資料沿用純資料契約。實際色彩檔名、生成方式與檔案配置由 PLAN 決定。
- `styles/` 提供 primitive 值、semantic 參照及原有主題模式。框架及網站使用同版本的 token 資料。範例列出貼用時所需的資產及前置條件，複製後由目標專案擁有。
- 遠端 `MiuDog/Kallopis` 的 Pages 設定回報 GitHub Actions 與 [GitHub Pages 目前網址](https://miudog.github.io/Kallopis/)。[現有 workflow](../.github/workflows/pages.yml) 以 repository variable `KALLOPIS_PAGES_DEPLOY` 決定是否部署。完成以新版本實際上線後的互動驗收為準。

## 能力階段

| 階段 | 可交付能力 |
| --- | --- |
| 風格來源 | 同一份可機讀風格資料支援跨框架對應、檢查與可攜範例。 |
| 互動展示與發布 | 在 GitHub Pages 查詢、操作並複製元件與組合範例，完成線上驗收。 |
