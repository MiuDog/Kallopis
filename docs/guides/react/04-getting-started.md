# 維護

350 個語意 × 4 主題、269 個 primitive、118 個配方由正式 Markdown 產生。修改正式規範後執行 `npm run build`，`npm run check:tokens` 檢查來源與產物內容及 SHA256。禁止人工修改 `src/generated.ts`、`src/tokens.css`、`src/source-manifest.json`。

色碼由規範 `#AARRGGBB` 轉為 Web `#RRGGBBAA`；數值單位在 CSS 接入，primitive 原始值保留。字型 family 移除 Flutter package 前綴；字型與授權打包於本庫 `dist/fonts`，產品需允許這些資產載入。

正式配方由 getKlpRecipe 查詢；現行可用元件以 React Reference 清冊為準，不能由配方存在推論元件已實作。

## API 查表


