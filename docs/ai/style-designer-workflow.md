# 風格設計師 Agent 工作流程與擴充架構指南

本文件供負責搜尋外部設計案例、與人類協作篩選並實作擴充元件的 **「風格設計師（Style Designer）」Agent** 直接閱讀與執行。

## 1. 專案擴充架構總覽

本專案將「**風格與設計案例**」集中於根目錄 `styles/`，並以宣告式目錄自動生成接線至 React / Flutter 展示網站：

| 目錄／檔案 | 擁有者與職責 | 風格設計師可編輯範圍 |
| --- | --- | --- |
| `styles/themes/index.json` | 全部版本化主題的單一登錄表 | 可用 `scaffold-theme.mjs` 新增或調整 metadata |
| `styles/themes/<family>-v<N>.json` | 350 semantic + 270 primitive 色票與數值權威 | 調整色彩、字型、圓角與對比（須通過四模式驗證） |
| `styles/themes/<family>-v<N>.surface.css` | 該風格專屬表面陰影、邊框微亮邊與排版規則 | 僅寫 `[data-klp-visual-style='<family>']` 規則 |
| `styles/curated/<id>/` | 外部案例拆解實作的**精選互動元件外掛目錄** | 用 `scaffold-curated.mjs` 建立並實作元件與三語言範例 |
| `react/example/theme-preview-snapshot.tsx` | 固定構圖的風格預覽截圖範例（`?showcase=theme-preview`） | 正常擴充不需改動；由截圖腳本自動切換 `--theme` |
| `styles/scripts/generate-themes.mjs` | 驗證主題並自動生成 `.css`、`.js`、`swatches.json` 與 React 預設包 | 自動執行（勿手改產物） |
| `styles/scripts/capture-theme-previews.mjs` | 無頭瀏覽器自動切換 `?showcase=theme-preview&theme=<id>` 並截取預覽圖 | 新增／微調風格後必跑 |
| `styles/images/previews/<id>.png` | 由標準化預覽範例自動截圖產出的官方預覽圖 | 由腳本產出並以視覺檢查確認 |
| `styles/scripts/generate-curated.mjs` | 掃描 `styles/curated/*/`，僅發布 `status: "approved"` 的元件至展示站 | 自動執行（勿手改 `react/example/curated*`） |
| `react/src/`、`flutter/lib/` | 穩定公開元件核心庫 | 僅在元件確認跨產品重用並升級時才修改 |
| `tool/reference_site/` | 靜態網站生成器與驗證器（`主頁` / `風格示範` / `元件表` / `文件參考`） | 正常擴充不需改動網站程式碼 |

## 2. 不可違反的鐵則（Invariants）

1. **版本化命名**：所有風格 ID 與檔名必須符合 `<family>-v<N>`（例如 `nord-slate-v1`）。重大視覺調整請新增 `-v2` 並保留 `-v1`，不得破壞舊版連結。
2. **禁止寫死主題顏色**：所有 `styles/curated/<id>/component.tsx` 與 `styles.css` 必須讀取 `--klp-*` CSS 變數（如 `var(--klp-colors-component)`、`var(--klp-colors-border)`、`var(--klp-colors-accent)`）或 `@kallopis/react` 元件，確保任何主題切換時皆能正確適配四種模式（`light` / `dark` / `ultraDark` / `transparent`）。
3. **人為篩選閘門（Human Curation Gate）**：搜尋外部網站案例後，必須先列出候選清單給人類篩選。任何元件在獲得人類明確核准前，`meta.json` 的 `status` 只能為 `"draft"` 或 `"review"`；`generate-curated.mjs` 只會將 `status: "approved"` 的元件發布到公開網站。
4. **禁止在展示 UI 加入工程說明註記**：元件畫面與示範卡保持真實產品質感，不在畫面內放「此為示意／限制說明」等常駐工程文字。
5. **程式格式與安全**：所有新增程式縮排使用 **tab 字元**（顯示寬度 2），註解使用繁體中文；`inspiration.url` 必須為 `https://`。
6. **每個版本必推送並建置公開網站**：完成新風格或核准元件後，必須執行完整本地驗證、提交並推送至 `origin main`，且追蹤 GitHub Actions Pages 部署成功。
7. **設定控制項與範例本體嚴格分離**：切換參數、風格或面板的控制列必須拆放在範例本體上方或下方，不可混在元件展示群組內。
8. **元件表獨立頁面與側欄導覽**：所有元件維護與明細統一置於獨立「元件表」頁（`components.html`）搭配左側 Navigator，不在「風格示範」首頁塞入全量元件清單。
9. **群組相鄰色票與即時 CSS 實驗**：相同類型色票必須相鄰成列、hover 顯示屬性、點擊複製 HEX；「風格示範」支援即時修改 CSS 並套用到全頁範例。
10. **風格與明暗模式完全獨立**：絕不把任何風格綁定「預設深色」，每次切換風格或明暗模式只改變該單一維度。
11. **風格預覽圖一律由標準化範例自動截圖**：嚴禁直接使用使用者提供的參考圖或外部網站截圖作為 `previewImage`；每個風格每次僅需切換 `?showcase=theme-preview&theme=<id>` 並執行 `capture-theme-previews.mjs`，將標準範例畫面截圖存為 `styles/images/previews/<id>.png`。
12. **網頁標題與副標題專注呈現產品特色**：所有公開網頁的標題、副標題、區塊主標與導語用於傳達產品與風格價值，禁止寫入專案規範、內部目錄路徑或操作教學文字。

---

## 3. 六階段標準作業流程（SOP）

### 階段一：搜尋外部設計案例與設計語彙拆解

1. 使用瀏覽器或搜尋工具調查外部高品質設計系統／工作台網站（記錄真實來源 URL 與參考頁面）。
2. 逐項拆解視覺特徵，禁止僅靠印象憑空捏造數值：
   - **色彩層次**：畫布（`app`）、側欄（`surface`）、內容舞台（`stageSurface`）、元件底色（`component`）、凹陷區塊（`surfaceInset`）、文字對比（`text` / `textMuted` / `textFaint`）、邊框（`border` / `borderStrong`）與強調色（`accent`）。
   - **表面與材質**：圓角（`shape.control` / `shape.card` / `shape.panel`）、1px 細線或微浮陰影／頂部亮邊（寫入 `.surface.css`）。
   - **字型與動態**：Display / UI / Monospace 字型搭配、hover / selected / focus-visible 狀態回饋。

### 階段二：人為篩選閘門（提交提案等待核准）

將候選案例整理為以下格式請人類審核與挑選：
- 來源網站名稱與 `https://` 連結
- 擬新增的**風格主題**或**精選元件 ID**（kebab-case）
- 核心視覺特徵與互動行為摘要
- 若適合直接沿用現有主題（`micro-elevation-v1`、`modern-minimal-v1`、`kallopis-v1`）則標記推薦主題

取得人類確認要開發的項目後，才進入階段三或階段四。

### 階段三：擴充新風格主題（如需要新色票或表面質感）

1. **建立主題鷹架**（會自動把 `previewImage` 指到 `styles/images/previews/<slug>-v1.png`）：
   ```sh
   node styles/scripts/scaffold-theme.mjs --family <slug> --version 1 --name "<中文名稱>" --english "<English Name>" --mode light --source "<https://...>" --description "<簡短描述>"
   ```
2. **調整語意色票與參數**：
   - 編輯 `styles/themes/<slug>-v1.json` 中的 `primitives`、`primitiveDescriptions` 與 `semantics`（四種模式：`light`、`dark`、`ultraDark`、`transparent` 皆須合法，不可刪除任何既有 semantic key，色碼須為 `#AARRGGBB` 或 `#RRGGBB`）。
   - 同步更新 `styles/themes/index.json` 中的 `palettePreview` 與 `typography`（勿改寫 `previewImage` 規範路徑，亦勿放外部截圖或使用者圖檔）。
3. **撰寫專屬表面樣式**：
   - 編輯 `styles/themes/<slug>-v1.surface.css`，以 `[data-klp-visual-style='<slug>']` 定義該主題特有的陰影、亮邊、漸層或襯線標題規則。
4. **同步主題資料、建置預覽範例並自動截圖**：
   - 本階段只需調整風格定義，不需另外手刻預覽頁面；直接切換標準範例 `?showcase=theme-preview&theme=<slug>-v1` 並截圖：
   ```sh
   node styles/scripts/generate-themes.mjs
   npm run build:example --prefix react
   node styles/scripts/capture-theme-previews.mjs --theme <slug>-v1
   ```
5. **檢查截圖並驗證通過**：
   - 以影像閱讀工具開啟 `styles/images/previews/<slug>-v1.png`，確認無文字截斷、無重疊且 Light／Dark 對比清晰後，執行驗證：
   ```sh
   node styles/scripts/generate-themes.mjs --check
   npm test --prefix styles
   ```

### 階段四：開發精選互動元件（外掛式 `styles/curated/`）

1. **建立元件鷹架**（預設 `status` 為 `"draft"`）：
   ```sh
   node styles/scripts/scaffold-curated.mjs --id <component-kebab-id> --name "<中文元件名稱>" --english "<English Name>" --theme micro-elevation-v1 --site "<參考網站>" --url "<https://...>"
   ```
2. **實作檔案（都在 `styles/curated/<id>/` 內完成）**：
   - `component.tsx`：export `default` React 互動元件，善用 `@kallopis/react` 基礎元件與狀態管理，確保支援鍵盤操作、無障礙標籤與四模式適配。
   - `styles.css`：使用 `--klp-*` CSS 變數撰寫排版與視覺效果，所有類別名稱建議加上 `.klp-curated-<id>-` 前綴避免衝突。
   - `snippets/react.tsx`、`snippets/flutter.dart`、`snippets/html.html`：撰寫簡潔且真正可複製使用的三語言程式碼範例。
   - `meta.json`：完整填寫 `summary`、`inspiration.traits`、`tokensUsed` 與 `props`。
3. **人為驗收並核准上線**：
   - 人類審閱元件效果與互動確認通過後，將 `meta.json` 的 `"status"` 從 `"draft"` 改為 `"approved"`。
4. **同步至展示站**：
   ```sh
   node styles/scripts/generate-curated.mjs
   node styles/scripts/generate-curated.mjs --check
   ```

### 階段五：本機完整驗證閘門

在提交與推送前，於 repository 根目錄依序執行所有檢查，任一失敗必須先修正：

```sh
node styles/scripts/generate-themes.mjs --check
node styles/scripts/generate-curated.mjs --check
node styles/scripts/generate-bindings.mjs --check
node styles/scripts/generate-example.mjs --check
node styles/scripts/migrate.mjs --check
node react/scripts/generate-catalog-props.mjs --check
npm test --prefix styles
npm run build --prefix react
npm run build:example --prefix react
node react/scripts/reference-components.mjs
npm test --prefix tool/reference_site
node tool/reference_site/generate.mjs --react --react-scenes --flutter-scenes
node tool/reference_site/verify.mjs --react --react-scenes --flutter-scenes
```

### 階段六：推送 `main` 並驗證公開 GitHub Pages

1. 檢查 `git status`，確認不包含暫存檔與被 `.gitignore` 排除的本機設定，且確認已提交對應 `styles/images/previews/<id>.png`。
2. 提交並推送至 `origin main`（會自動觸發 `.github/workflows/pages.yml`）。
3. 監看 GitHub Actions Workflow 直到 `build` 與 `deploy` 全綠：
   ```sh
   gh run list --workflow pages.yml -L 3
   gh run watch <run-id> --exit-status
   ```
4. 確認公開網址回傳 HTTP 200 並實測頁面與預覽圖：
   - 主頁：`https://miudog.github.io/Kallopis/`
   - 風格示範：`https://miudog.github.io/Kallopis/showcase.html`
   - 元件表：`https://miudog.github.io/Kallopis/components.html`
   - 風格預覽圖：`https://miudog.github.io/Kallopis/styles/images/previews/<id>.png`
   - 精選清單 JSON：`https://miudog.github.io/Kallopis/styles/curated/index.json`

---

## 4. 成熟元件升級至核心套件的時機

當某個 `styles/curated/<id>/` 元件經過至少兩個 `-ist` 產品實際採用且穩定後，才依 `AGENTS.md` 與 `spec/multi-framework-design-system.md` 規劃升級流程：
1. 在 `react/src/` 新增正式公開元件與單元測試。
2. 在 `flutter/lib/` 新增對等的 Flutter Widget 與測試。
3. 執行 `node react/scripts/generate-catalog-props.mjs` 與 `node styles/scripts/generate-bindings.mjs` 重新索引。

## 5. 常見錯誤排查

| 錯誤訊息 | 原因 | 解法 |
| --- | --- | --- |
| `Theme ID must be versioned` | 主題 ID 未採 `<family>-v<N>` | 修正 `styles/themes/index.json` 與檔名為 `-v1` |
| `Theme previewImage must use canonical preview path` | `previewImage` 指到外部或使用者上傳圖片 | 改為 `styles/images/previews/<id>.png` 並執行截圖腳本 |
| `Missing theme preview screenshot` | 尚未產出標準預覽截圖檔 | 先 `npm run build:example --prefix react`，再跑 `node styles/scripts/capture-theme-previews.mjs --theme <id>` |
| `value below / above / does not fit` | 觸犯 `styles/catalog.json` 數值範圍或跨 token 幾何約束 | 調整 `styles/themes/<id>.json` 中對應的數值後重跑 `generate-themes.mjs` |
| `Generated curated output stale` | 修改了 `styles/curated/` 卻未重新同步 | 執行 `node styles/scripts/generate-curated.mjs` |
| `tsc -p tsconfig.example.json` 找不到模組 | 元件直接相對匯入 `styles/` 越過 `react/tsconfig.example.json` 邊界 | 一律透過 `generate-curated.mjs` 自動同步到 `react/example/curated/` |
