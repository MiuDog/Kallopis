# Kallopis Style Pack

`kallopis-v1.json` 集中維護 primitive、四模式 semantic 與配方資料。修改此檔後執行生成器，更新正式文件資料表及 Flutter／React 產物。`catalog.json` 維護型別、單位及合法範圍。

在 repository 根執行：

```sh
node styles/scripts/migrate.mjs
node styles/scripts/migrate.mjs --check
node --test styles/test/style-pack.test.mjs
```

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
