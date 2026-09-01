# Workbench 預設間距契約

## Outcome

`KlpWorkbenchShell` 與 shell panel 不需消費端指定 spacing，即可呈現一致的 Kallopis
工作台版面。App padding、header／pane margin、panel 內部 padding 是三個不同
幾何層，不再以 insert 混稱。

## In scope / out of scope

- 範圍內：`KlpWindowHeader` margin、`KlpWorkbenchShell` pane margin、
  `KlpPanelFrame`／`KlpSidebarFrame`／`KlpStageFrame` 內容 padding。
- 範圍外：個別產品頁面的內容排版、色票與圓角。

## Visual contract

1. App 四周 padding 為半個 `space.compact`，背景仍填滿整個視窗。
2. Header 可視表面高度為 24px，四周 margin 為半個 `space.compact`；margin
   不屬於 Header 的繪製或碰撞範圍。
3. 每個 pane 可視表面四周 margin 為半個 `space.compact`；兩個相鄰 pane
   各自貢獻一半，因此可視表面之間合計為一個 `space.compact`。
4. Resize handle 位於兩個 pane 可視表面之間的 margin 正中央。
5. Panel 可視表面內部 padding 為一個 `space.compact`，屬於 Panel 自身。
6. 從視窗頂端到 pane 可視表面的垂直節奏為 `8 + 24 + 8 = 40px`。
7. Header 的左右 pane 收合按鈕分別貼齊對應 pane 的內側邊界，拖曳調寬時同步移動。

## Architecture constraints

- 預設 spacing 只能讀取 `context.klp` semantic token，不可參照 primitive。
- `paneMargin` 是正式 API；舊 `panePadding` 僅保留 deprecated 相容入口。
- Margin 必須在可視表面與碰撞範圍之外；Padding 必須位於元件背景之內。

## Acceptance criteria

1. Header surface bounds 比 Header 版面占位四周各縮半個 `space.compact`。
2. 未傳入 spacing 的 `KlpWorkbenchShell`，相鄰 pane 表面距離為
   `space.compact`，外側 margin 為其一半。
3. Resize handle 中線等於兩個相鄰 pane 表面之間距的中線。
4. 未傳入 panel padding 時，sidebar 與 stage 的完整內容四周皆等於
   `space.compact`。
5. 標準 `KlpStageFrame.workbench` 不提供 stage padding、header action 或換行模式覆寫；
   產品只傳入語意資料與內容。
