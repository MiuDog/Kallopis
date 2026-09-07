## 分析入口

`layout/` 包含區域／分割布局、尺寸把手、捲動與虛擬列表／網格包裝，以及 KlpMasonryGrid。KlpResizablePane 只以輸入 width 建立 SizedBox；拖曳變化透過 KlpResizeHandle.onDelta 回報。此目錄無巢狀子目錄；目前 masonry 依索引輪流分欄，沒有量測欄高後挑最短欄的排程。

| 想查的問題 | 符號與來源 |
| --- | --- |
| 區域與分割入口？ | KlpRegion／KlpSplitLayout — `lib/src/layout/klp_layout.dart:8`、`lib/src/layout/klp_layout.dart:48` |
| 尺寸誰更新？ | KlpResizablePane／KlpResizeHandle — `lib/src/layout/klp_layout.dart:110`、`lib/src/layout/klp_layout.dart:123` |
| 虛擬列表與網格在哪？ | KlpVirtualList／KlpVirtualGrid — `lib/src/layout/klp_layout.dart:216`、`lib/src/layout/klp_layout.dart:242` |
| 瀑布流如何分欄？ | KlpMasonryGrid.build — `lib/src/layout/klp_masonry_grid.dart:17` |

重要關係：

- `KlpResizeHandle` → `onDelta`：依 axis 回報 dx 或 dy（`lib/src/layout/klp_layout.dart:158`、`lib/src/layout/klp_layout.dart:162`），沒有在自身保存 pane width。
- `KlpMasonryGrid.build` → theme／LayoutBuilder：gap 與預設最小欄寬取自 theme，依可用寬度算欄數，再以 index % count 分派 children（`lib/src/layout/klp_masonry_grid.dart:18`、`lib/src/layout/klp_masonry_grid.dart:30`）。
- `klp_layout.dart` → surface 模組：直接引入 KlpDashedBorder 與 KlpSurface（`lib/src/layout/klp_layout.dart:3`）。

import 不是執行順序；尺寸變更路線應追蹤 callback 的消費者。
