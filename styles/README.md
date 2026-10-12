# Kallopis Style Pack

目前完成交換、typed runtime 及原子覆寫：以正式三張表產生 `kallopis-v1.json`。這是遷移中產物；正式 Markdown 暫仍擁有值權威，框架尚未改為接受此 pack。

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
