# 元件分類：什麼進 Kallopis，什麼留在產品

## 這份文件是什麼

Kallopis 由 Planist `lib/design_system/`（82 檔、17,684 行）抽取而來。來源目錄雖然對外
依賴為零，但**依賴乾淨不等於語意乾淨**——大量元件在結構上獨立、在語意上仍屬產品。

本文件記錄每一次裁剪的判準與結果，讓「這個元件為什麼不在庫裡」有可查的答案。

## 判準

一個元件要進 Kallopis，五條全部要過：

1. **至少兩個產品使用。**
2. **具有相同的產品語意。**
3. **互動與無障礙規則相同。**
4. **API 能以 token 或 slot 客製，而不是大量布林參數。**
5. **不含產品資料模型或商業邏輯。**

只過部分規則的，留在產品內。若未來兩個產品真的共享同一個領域概念，把它提升為**獨立
feature package**，而不是塞進視覺元件庫。

這與 Krepis [FND-0001 §4](../../Krepis/spec/decisions/00-foundation/FND-0001-scope-language-boundary-and-rejections.md)
的單一判準（「一個刻意平凡的筆記 app 需不需要？」）方向一致，但更嚴格：FND-0001 只問需不
需要，本判準另外要求 API 形狀（規則 4）與語意一致性（規則 2、3）。

## 結果

| | 檔案 | 行數 |
|---|---|---|
| 抽取來源（Planist design_system） | 82 | 17,684 |
| 留在 Kallopis | 68 | 10,275 |
| 移出 | 14 檔 ＋ 2 檔部分內容 | 7,409 |

公開符號 231 個。

## 移出清單與理由

### 整檔移出

| 元件 | 行數 | 違反 | 理由 |
|---|---|---|---|
| `dashboard/dash_charts` 等 6 檔 | 3,648 | 1 | 35 種圖表。Notist 不需要，Designist 不需要——沒有第二個產品 |
| `dashboard/dash_record_views` | 927 | 1, 5 | `DashRecord`／`BoardColumn`／`TableView`／`BoardView` 是資料庫視圖語意 |
| `dashboard/dash_time_views` | 1,192 | 1, 5 | 時間軸與日曆視圖是排程語意 |
| `data/klp_diff_view` | 377 | 1 | diff 檢視服務 repo binding，只有 Planist 需要 |
| `feedback/klp_status_states` | 167 | 5 | 9 處寫死文案（「目前離線」「CONNECTION / 04」），與產品連線狀態直接綁定 |
| `data/klp_task_card` | ~100 | 5 | 任務語意 |
| `shell/klp_project_banner` | ~100 | 5 | 專案語意 |

> 2026-08-24：使用者要求工作區新版頁面由 Kallopis 提供預設呈現。訊息與輸入元件因此以
> 無角色、無 AI session、無內嵌產品文案的 `KlpMessageBubble`／`KlpMessageThread`／
> `KlpMessageComposer` 重新納入；原先被拒絕的產品綁定版本仍不恢復。

### 部分移出（檔案必須拆，不能整檔留或整檔砍）

**`shell/klp_shell_extras.dart`**（489 → 100 行）——這是最混雜的一個檔案。

移出：`KlpProjectSummary`、`KlpProjectList`、`KlpProjectListItem`、`KlpProjectEntryScreen`、
`KlpProjectInviteList`、`KlpProjectInviteAcceptanceScreen`、`KlpProjectRail`、
`KlpProjectSyncIndicator`（專案與邀請協作語意，違反規則 5）、`KlpAiDock`（AI 產品語意，
違反規則 1）、`KlpFeatureNavigationHost`（導覽，同時踩到 Krepis FND-0001 §3 的拒絕清單）。

留下：`KlpAppScreen`、`KlpAppWindowHeader`、`KlpContentState`、`KlpPaneCollapseControl`，
以及 **`KlpResponsivePaneCoordinator`**——即點名要抽的 responsive pane primitive。

**`data/klp_advanced_data.dart`**（1,117 → 773 行）

移出：`KlpTimeline`／`KlpTimelineEntry`／`KlpTimelineGroup`／`KlpTimelineStatus`（專案時間軸，
明列留在產品）、`KlpMetric`／`KlpMetricTrend`（KPI 指標語意，與 `dash_kpi` 同類）。

留下：`KlpDataTable`、`KlpTree`、`KlpJsonTree`、`KlpFilePreview`。

### 反向：判為 token 而非元件

`dashboard/dash_theme.dart` 是零依賴的純 token 檔（`KlpDataVisualizationTheme`），且
`klp_theme.dart` 依賴它。資料視覺化色彩屬於 design token，改列
`theme/klp_data_visualization_theme.dart`。圖表元件移出，圖表**色彩 token 留下**。

### 曾誤判、經檢視後保留

`form/klp_structured_fields`（Repeater／KeyValue／Code／File／ColorRole 欄位）初步被列為產品
語意，實際檢視為通用表單控制項，五條全過，保留。

### 2026-08-23 Settings 呈現抽取

依使用者明確指示，從 Planist Settings 抽取不含產品語意的呈現方法：自適應雙欄版面、
navigation pane、不可收縮分類、選取後展開的 field deep links、content pane、欄位定位表面、
固定 action bar 與受控 theme mode picker。公開契約只接收 widget slot、文案、選取狀態與事件；
Project／App scope、descriptor、搜尋、權限、dirty guard、保存狀態機、透明視窗 adapter 與偏好
migration 全部留在產品層。完整邊界見 [`settings-presentation.md`](settings-presentation.md)。

Settings 的表面使用 Kallopis 既有 semantic color token，不搬移 Planist 的
`settingsNavigation`／`settingsContent` 色值，也不建立產品專用 palette。Theme preview 直接讀取
Kallopis 的 Light、Dark、Ultra Dark 與 Transparent token preset；System 仍由消費者解析平台狀態。

## 尚未處理（下一步）

### 規則 4 未過但暫時保留

以下元件通過規則 1、2、3、5，但 API 是布林參數堆疊而非 token／slot，需要重構而非移除：

| 元件 | 布林參數 | 行數 |
|---|---|---|
| `data/klp_advanced_data` | 20 | 773 |
| `foundation/klp_foundation_extras` | 11 | 509 |
| `data/klp_code_viewer` | 9 | 584 |
| `overlay/klp_menu` | 5 | 290 |
| `controls/klp_segmented_control`、`klp_toggle` | 各 4 | 148／108 |

`foundation/klp_foundation_extras` 另有問題：它是雜物袋（Avatar／StatusIndicator／RichText／
Popover／DragDrop／SortControl／ThemeToggle 共 17 個類別擠在一檔），應依領域拆檔。

### 內嵌文案殘留

6 個檔案仍有寫死的中文字串，違反規則 5 的精神（庫不該決定產品說什麼）：
`klp_badge`、`klp_page_chrome`、`klp_region_placeholder`、`klp_toast`、`klp_dialog`、
`klp_theme_preview_tile`。應收斂為必填的 label 參數或 `Klp*Labels` 物件——
`data/klp_code_viewer` 的 `KlpCodeViewerLabels` 已是這個形狀，可作為樣板。

### 待定案

- `editor/klp_page_chrome`（`KlpSaveStatusCard`／`KlpPropertySummary`）：與產品儲存狀態綁定，
  傾向移出，但 `KlpPageChrome` 本身是通用的頁面外框。與 `klp_shell_extras` 同屬「必須拆」的檔案。
- `form/klp_reference_picker` 與 `editor/klp_entity_picker` 做同一件事（挑選並引用另一個實體），
  應合併為單一元件。
