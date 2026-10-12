# Kallopis Style Pack

目前完成 STYLE-PACK-1：以正式三張表產生 `kallopis-v1.json`，提供公開匯入、驗證與表格匯出。這是遷移中產物；正式 Markdown 暫仍擁有值權威，框架尚未改為接受此 pack。

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

JSON schema 描述交換結構，公開 validator 另檢查引用／循環。此 slice 不保證數值符合具體元件的 geometry／contrast 約束，也不把配方原文當作程式執行。

後續目錄：參數型別與範圍 → Flutter／React adapter → provider 注入 → docs 風格 playground。當前目標與邊界見 [架構](architecture.md)。
