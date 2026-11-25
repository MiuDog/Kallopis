# 可排序清單

將 `ReorderableList.tsx` 與 `reorderable-list.css` 一起複製到 consumer。維持既有清單項目插槽，不增加工具列、拖曳把手或額外說明列。

`ids` 是 consumer 控制的顯示順序；`children(id)` 呈現項目；`onMove(source,target)` 回報一次拖曳或 Alt+上下方向鍵操作。disabled 由 consumer 決定。原生拖曳只接受本元件內開始的手勢，外部文字不當作項目。

模板只保留手勢來源與低對比虛線目標提示。排序算法、穩定身分、團隊、API、草稿、保存及衝突均屬 consumer；不能將工作流執行次序與此呈現排序混用。

規範見 [recipes.md](../../docs/design-tokens/recipes.md)，函式責任見 [architecture.md](architecture.md)。Unico 的實際拖曳畫面仍待 browser 可用後驗證；不以資料模型測試代替畫面驗證。
