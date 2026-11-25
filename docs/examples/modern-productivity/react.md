# React Modern productivity

狀態：draft；截圖待審閱。

[可複製 starter](../../../react/example/modern-productivity-starter.tsx) 在 `KlpThemeProvider` 之下使用 `KlpModernProductivityLayout`，由 React state 擁有 selectedId 與導航／工具草稿。面板內容組合 `KlpTextField`，Header／Stage 組合 `KlpText`。

先在 `react/` 執行 `npm run build`、`npm run dev`，開啟 `http://127.0.0.1:5173/?template=modern-productivity-layout`。預覽控制區用來調整設定，不屬於產品畫面。

產品內容內距取 `Number(useKlp().semantic('theme.spacing.contentInset'))`；宿主須有確定寬高。產品持有選取回呼，使用 style pack 調整整體語意，不覆寫共用元件內部樣式。

- [組裝圖、狀態與 token 選用](README.md)
- [React Reference](../../reference/react/README.md)
- [設定複製及版本限制](../../templates/modern-productivity-layout.md)
