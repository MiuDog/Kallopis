# Kallopis React

`@kallopis/react` 提供完整通用 token／四主題及 React 19 核心元件。公開使用方式、語意對應與合法限制由 [React 產品使用指南](../docs/ai/react-usage.md) 統一維護；實作責任見 [架構](architecture.md)。

在此目錄執行：

```sh
npm ci
npm run build
npm test
npm run dev
```

展示預設為 `http://127.0.0.1:5173`；`npm run build:example` 建置展示。`npm pack` 可產生本機套件，尚未發布 npm。字型與授權由套件自行打包，產品需接入 `@kallopis/react/styles.css`。

公開 `createKlpStylePack(jsonOrObject)` 匯入完整風格；省略參數載入預設。`applyKlpStyleOverrides(pack, overrides)` 可原子覆寫既有 primitive 或部分 mode semantic；非法值拒絕且保留原 pack。將結果傳給 `<KlpThemeProvider stylePack={pack}>`；每個 Provider 自己擁有全部 CSS variables，巢狀 scope 可用不同風格。

`klpStyleParameters` 公開 350 項語意的型別、單位、限制、用途與直接引用配方。ARGB 與 package 字型身份保留於風格檔，由 React 轉換為 CSS。展示提供本機檔案／JSON 匯入與還原；檔案只在瀏覽器內解析。配方原文完整保留，但本階段只接入 typed semantic；完整 recipe 視覺參數及 Workbench 布局保護另列後續 slice。
