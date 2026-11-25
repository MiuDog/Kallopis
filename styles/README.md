# Kallopis Style Hub

`styles/` 是跨框架共用的風格權威中心，所有風格皆採版本化命名（`<family>-v<N>.json` / `<family>-v<N>.css`，重大調整升版為 `-v2` 並保留舊版）：
- 主要色彩與語意資料：`kallopis-v1.json`（暖紙預設）、`themes/micro-elevation-v1.json`（微立體）、`themes/modern-minimal-v1.json`（現代簡約風，取自 `fancyboi999/open-tag`）。
- 跨專案可複製 CSS / JS tokens：`themes/*-v1.css`、`themes/*-v1.js`（以 `--klp-*` 命名並自動對應 `component-bindings.json`）與色票清冊 `themes/swatches.json`。
- 參考範例圖片與獨立可複製 HTML 組合：`images/`、`examples/ide-workbench/index.html`、`examples/sidebar-stage/index.html`。
- 參數型別與約束目錄：`catalog.json`。

在 repository 根執行：

```sh
node styles/scripts/migrate.mjs
node styles/scripts/generate-themes.mjs
node styles/scripts/generate-curated.mjs
node styles/scripts/generate-bindings.mjs
node styles/scripts/generate-example.mjs
npm test --prefix styles
```

擴充新風格或精選元件請見 [風格設計師 Agent 工作流程](../docs/ai/style-designer-workflow.md)（提供 `scaffold-theme.mjs` 與 `scaffold-curated.mjs`）。

公開 `styles/src/index.mjs`：

- `importStyleTables({primitives, semantics, recipes}, {id, version})`：三份 Markdown 字串轉為 pack。
- `validateStylePack(pack)`：驗證版本、結構、有限原料、四 mode、引用與繼承循環；成功回傳 pack，失敗拋出帶參數路徑的錯誤。不修改輸入。
- `exportStyleTables(pack)`：匯出三張資料表，保留中文描述及配方原文；章節排版不由 pack 擁有。
- `resolveStylePack(pack, mode, catalog)`：依 `catalog.json` 解析並驗證 typed 語意與跨參數 constraints，回傳深度 frozen 的身份／mode／tokens／recipes；保留原色碼及 package 字型，不自動載入資產。
- `applyStyleOverrides(pack, {primitives, semantics}, catalog)`：只覆寫既有 primitive 或 semantic 的部分 mode；所有四 mode 皆驗證成功才回傳新 pack，不改原始 pack。不能覆寫 catalog、行為或新增 ID。

JSON schema 描述交換結構，公開 validator 另檢查引用／循環。typed runtime 依 catalog 驗證型別／單位／範圍及四項既有跨參數關係。此 module 不保證具體元件的文字容納、contrast 或完整布局，不把配方原文當作程式執行；框架 algorithm 仍須另外驗收。

後續目錄：配方運算 → Flutter／React adapter → provider 注入 → docs 風格 playground。當前目標與邊界見 [架構](architecture.md)。

## 框架名稱與使用處

`component-bindings.json` 由 `node styles/scripts/generate-bindings.mjs` 掃描框架手寫來源生成，列出 semantic ID、Flutter member、React ID、CSS 變數及直接引用的檔案與行號。空 references 代表沒有找到直接文字引用，動態 resolver 的適用範圍由框架契約定義。執行 `--check` 驗證新鮮度。

[可複製組合](examples/README.md) 包含獨立 HTML 與實際圖片。
