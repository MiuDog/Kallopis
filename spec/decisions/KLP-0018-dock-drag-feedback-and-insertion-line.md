# KLP-0018：Dock 拖曳標題與放置線

## 狀態

Accepted（2026-09-07）

## 決策

- Header 放置線只繪製在 header inset 之內，且高度與 Dock code 標題的文字行高一致；
  外層 `DragTarget` 仍涵蓋完整 header，因此 padding 區仍是有效拖曳命中範圍。
- 拖曳 feedback 顯示 `KlpDockPanel.header`，沒有 header 時才回退到 panel id。
- `Draggable` 使用 `pointerDragAnchorStrategy`，feedback 以按下／拖曳的滑鼠位置為錨點，
  不以原始標題左上角作為固定位置。

## 理由

放置線是位置提示，不應視覺上佔滿整個標題區；命中範圍與提示線分離後，拖曳容錯較高。
Feedback 使用實際標題可讓使用者辨識拖曳中的 panel，而不是看到內部識別碼或錯誤的
navigation fallback。滑鼠錨點則維持拖曳操作的直接操控感。
