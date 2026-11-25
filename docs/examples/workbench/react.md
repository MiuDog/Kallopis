# React Workbench

狀態：draft；截圖待審閱。

實作來源：[scenarios.tsx](../../../react/example/scenarios.tsx)。先在 `react/` 執行 `npm run build`、`npm run dev`，開啟 `http://127.0.0.1:5173/?scenario=vscode`；其他既有場景為 `blockbench`、`blender`。

## 接線

Provider 供應語意風格。`KlpCommandShortcutHost` 與 registered toolbar／menu／palette 共用 registry；`KlpDockLayout` 接收產品狀態，產品透過 `applyKlpDockAction` 提交新布局。Explorer 選取、面板內容與草稿由 React state 擁有。

布局保存使用 `encodeKlpDockLayout` 與 `restoreKlpDockLayout`；保存媒介、正文與業務規則由產品負責。釋放 registry／keymap 的責任屬於建立它們的產品生命週期。

## 規範與查表

- [共通組裝圖與 token 選用](README.md)
- 產品專用區域透過 `useKlp().semantic(id)` 取語意；共用元件內部由 library 處理。
- [React Reference](../../reference/react/README.md)
- [布局與命令操作流程](../../ai/react-usage.md)
