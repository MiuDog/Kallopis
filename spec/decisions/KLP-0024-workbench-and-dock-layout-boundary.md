# KLP-0024：Workbench Layout 與 Dock Layout 邊界

階段：Iteration

狀態：Accepted（2026-09-20）

擁有模組：Foundation layout、Workspace shell／docking

目標版本：Dual Layout v1

能力地平線：v1 恢復可遞迴 Row／Column 的一般 Workbench layout，同時保留現有 Dock
layout；兩者可共用私有尺寸算法，但維持不同公開語意。跨視窗拖放與浮動視窗不在本版本。

## 目標與動機

歷史 `KlpAppLayout` 與現行 `KlpDockLayout` 解決不同問題，不應因為都包含 pane 與 divider
就合併成同一個公開模型。

一般 Workbench layout 讓 consumer 明確組合 Row、Column 與內容 pane，由 Kallopis 統一
計算 flex、間距及 divider 所占空間。Dock layout 則描述可移動 panel 的位置與狀態，由
Kallopis 提供 registry、tabs、drag／drop、resize、collapse 及合法停靠互動。

兩者仍是直接 Flutter design-system 元件，不恢復 `KlpNode`、adapter、bound model、
compiler 或私有 renderer。

## 需求與決策

| ID | 目標版本 | 優先級 | 需求或決策 | 可觀察驗收 | 狀態 |
| --- | --- | --- | --- | --- | --- |
| DLB-01 | v1 | P1 | 保留兩個公開 Layout，各自擁有不同語意。 | 一般 Workbench layout 不要求 panel registry；Dock layout 不成為所有 Row／Column 組合的通用入口。 | accepted |
| DLB-02 | v1 | P1 | 一般 Workbench layout 支援遞迴 Row、Column 與內容 pane。 | Consumer 可建立左右、上下及巢狀混合版面，不必直接以 Flutter Row／Column 重寫 Kallopis 的 pane 幾何。 | accepted |
| DLB-03 | v1 | P1 | 一般 Layout 在分配 pane 空間前扣除 divider／gutter。 | 每層內容尺寸加 divider 尺寸等於可用主軸尺寸，巢狀布局不重複計算 divider。 | accepted |
| DLB-04 | v1 | P1 | 保留現有 `KlpDockLayout`、`KlpDockPanel` 與固定 Area 狀態模型。 | 現有 panel registry、Left／Right／Bottom、tabs、drag／drop、resize、collapse 與 capability rule 不因一般 Layout 恢復而改寫。 | accepted |
| DLB-05 | v1 | P1 | 兩套 Layout 不共用公開資料樹或狀態模型。 | Workbench pane 不需要 panel id；Dock consumer 不需要建立一般 Layout node。 | accepted |
| DLB-06 | v1 | P1 | 兩套 Layout 可以共用私有、無 Widget 狀態的線性尺寸解析。 | 共用實作只接收 axis extent、divider extent 與 child constraints，不認識 panel、tab、drop target 或產品資料。 | accepted |
| DLB-07 | v1 | P1 | 一般 Layout 還原歷史 divider 行為：占據 semantic gutter，但不提供拖曳 resize。 | Layout 不公開 resize callback；需要互動調整與持久狀態時使用 `KlpDockLayout`。 | accepted |
| DLB-08 | v1 | P1 | 兩套 Layout 都維持 KLP-0022 的直接 Flutter 邊界。 | 公開入口從現有 Flutter barrels 可達；不存在 declarative runtime 或第二套 renderer。 | accepted |
| DLB-09 | v1 | P2 | `KlpSplitLayout` 的重疊能力在一般 Workbench layout 完成後重新判斷。 | 若新版完整涵蓋固定二／三欄 split，才另行合併或刪除；本階段不先移除。 | deferred |
| DLB-10 | v1 | P1 | 恢復直接 Flutter `KlpFrameGroups`／`KlpFrameGroup`，讓 Frame 內容可使用受控群組、divider 與固定 footer。 | Consumer 不需自行組裝 Padding／Divider／Scroll footer；所有布局 gap 解析為同一個 8px semantic spacing。 | accepted |
| DLB-11 | v1 | P1 | Frame group 只接受 Widget 內容，不恢復 node slot、adapter 或 renderer。 | API 從 foundation barrel 可達，且 source 不依賴舊 declarative runtime。 | accepted |
| DLB-12 | v1 | P1 | `KlpAppLayout` 恢復可選的 draggable floating action；內容是 consumer 提供的 Widget，位置只屬呈現期。 | 預設右下、拖曳不觸發 child tap、Widget 更新保留位置、viewport 縮放後自動 clamp，且不恢復舊 runtime。 | accepted |

## 責任邊界

### 一般 Workbench layout

- 輸入：Row／Column／Pane 組合、內容 Widget、flex 或受限尺寸。
- 擁有：遞迴幾何、semantic gutter／divider、尺寸守恆及 overflow 行為。
- 不擁有：panel registry、tab、drag target、停靠能力、layout storage 或產品流程。

### Dock layout

- 輸入：Stage、`KlpDockPanel` registry、受控 `KlpDockLayoutData`、constraints 與 callback。
- 擁有：Left／Right／Bottom area、group、tabs、panel move／split／merge、resize、collapse、
  drop feedback 及 capability validation。
- 不擁有：產品內容狀態、storage、一般畫面 Row／Column 組合。

### 可共用的私有算法

共用 resolver 只處理單一主軸：先扣除 divider 總尺寸，再在非負內容空間內解析固定尺寸、
min／max 與 flex。它不輸出 Widget、不修改狀態，也不知道呼叫者是 Workbench 或 Dock。

### Frame 內容群組

- `KlpFrameGroups` 管理一個以上的主群組，以及可選的固定 footer group。
- `KlpFrameGroup` 管理水平 inset、群組內容節奏與前置 divider。
- horizontal inset、standard content gap、transparent gap 與 section gap 全部解析為 8px；
  divider 線寬與顏色仍使用 shape／color semantic token。
- Footer 存在時，主群組位於可捲動區，footer 固定於底部中央。

### Floating action

- `KlpAppLayout.floatingAction` 接受可選 Widget；產品 action／狀態仍由 consumer 擁有。
- Kallopis 擁有右下預設位置、拖曳手勢、呈現期位置、surface 與 viewport clamp。
- 可拖曳範圍保留 8px root inset，頂部另避開現行 semantic header extent。
- 拖曳與點擊由 gesture arena 分離；拖曳不得誤觸 child action。
- 位置不寫入 storage；移除並重新建立 layout 時回到預設位置。

## 範圍

範圍內：

- 恢復歷史 Row／Column 組合與 divider 空間計算的產品價值。
- 恢復 FrameGroups 的直接 Flutter compound component。
- 恢復 AppLayout 的呈現期 draggable floating action。
- 保留現行 Dock 的適應性互動與公開模型。
- 為兩者建立清楚文件、Catalog specimen 與正式 API reference。

範圍外：

- 將 Dock panel tree 泛化成全產品 UI schema。
- 將一般 pane 自動轉換成可停靠 panel。
- 跨視窗拖放、浮動 panel 或產品 storage。
- 重設已接受的外觀。

## 與既有決策的關係

- 延續 KLP-0022 的直接 Flutter design-system 邊界。
- KLP-0006 的 Dock 組合與能力邊界繼續有效。
- KLP-0018 的 Dock feedback 與 pointer anchor 行為繼續有效。
- 歷史 `KlpAppLayout` 只提供一般布局行為參考；不恢復其 declarative runtime 鏈路。

## 驗收證據

- 一般 Layout：巢狀 Row／Column、divider 扣除、flex、constraint 及不足空間測試。
- Dock Layout：既有 panel move、tabs、split、resize、collapse 與 capability 行為不回退。
- Integration：Catalog 分開展示兩套元件；文件清楚說明選擇條件；正式 reference 以公開
  class 為頁面單位列出 API。
- Human：人工確認 Workbench divider 與 Dock 互動手感；不以 deterministic test 代替。

## Readiness

所有 v1 P1 已接受；DEFINE READY，可進入一般 Workbench layout 的 PLAN。
