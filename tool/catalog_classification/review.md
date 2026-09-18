# 固定 Catalog 分類審閱

> 此頁由 `classification.json` 與固定 legacy baseline 產生，請勿手動修改。分類服務 consumer 導航，不代表 module ownership、公開處置或 migration 完成。

- 分類狀態：`proposed`
- 接受時間：`尚未接受`
- 規格 revision：`320d2a036c6b199c78e399579d5f8a7bbc752321`
- 固定項目：`254`

## 分類摘要

| ID | 分類 | 項數 |
| --- | --- | ---: |
| `CAT-APP` | 應用與工作區 | 11 |
| `CAT-LAYOUT` | 布局與組成 | 32 |
| `CAT-NAV` | 導覽與探索 | 16 |
| `CAT-ACTION` | 動作與命令 | 12 |
| `CAT-DATA` | 資料與集合 | 18 |
| `CAT-SEARCH` | 搜尋與篩選 | 3 |
| `CAT-FORM` | 表單與輸入 | 42 |
| `CAT-FEEDBACK` | 狀態與回饋 | 16 |
| `CAT-OVERLAY` | 浮層與暫態介面 | 11 |
| `CAT-DOC` | 文件、內容與編輯 | 14 |
| `CAT-PLAN` | 規劃與時間 | 8 |
| `CAT-SETTINGS` | 設定與偏好 | 14 |
| `CAT-FILE` | 檔案與資產 | 8 |
| `CAT-COLLAB` | 溝通與協作 | 5 |
| `CAT-CANVAS` | 畫布、圖解與手寫 | 8 |
| `CAT-CHART` | 圖表與資料視覺化 | 0 |
| `CAT-SYSTEM` | 無障礙、輸入與平台適應 | 19 |
| `CAT-VISUAL` | 視覺語言與體驗 | 17 |

## Role 摘要

| Role | 項數 |
| --- | ---: |
| `catalog-artifact` | 12 |
| `composition-part` | 48 |
| `consumer-capability` | 112 |
| `implementation-material` | 73 |
| `system-contract` | 9 |

## Composition level 摘要

| Level | 項數 |
| --- | ---: |
| `container` | 61 |
| `element` | 93 |
| `internal` | 73 |
| `layout` | 4 |
| `none` | 21 |
| `screen` | 2 |

## 應用與工作區 (`CAT-APP`) — 11

### `KlpApp`

- Consumer intent：建立可啟動並承載產品畫面的應用根。
- Role：`consumer-capability`
- Composition level：`screen`
- Composition rationale：「建立可啟動並承載產品畫面的應用根」屬畫面根責任，只直接選擇一個由Kallopis定義的根layout。
- Secondary：無
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/application/legacy/klp_app.dart`](../../lib/src/application/legacy/klp_app.dart)

### `KlpAppScreen`

- Consumer intent：定義具名稱與輔助語意的應用畫面。
- Role：`consumer-capability`
- Composition level：`screen`
- Composition rationale：「定義具名稱與輔助語意的應用畫面」屬畫面根責任，只直接選擇一個由Kallopis定義的根layout。
- Secondary：`CAT-NAV`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/features/workspace/shell/composition/app_screen/klp_app_screen.dart`](../../lib/src/features/workspace/shell/composition/app_screen/klp_app_screen.dart)

### `KlpAppWindowHeader`

- Consumer intent：組成桌面應用視窗頂端的標識與控制區。
- Role：`composition-part`
- Composition level：`container`
- Composition rationale：「組成桌面應用視窗頂端的標識與控制區」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-SYSTEM`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/features/workspace/shell/composition/window_header/klp_app_window_header.dart`](../../lib/src/features/workspace/shell/composition/window_header/klp_app_window_header.dart)

### `KlpSidebarIdentityHeader`

- Consumer intent：在側邊區呈現目前工作區或主體身分。
- Role：`composition-part`
- Composition level：`container`
- Composition rationale：「在側邊區呈現目前工作區或主體身分」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-NAV`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/features/navigation/widgets/sidebar/klp_sidebar_identity_header.dart`](../../lib/src/features/navigation/widgets/sidebar/klp_sidebar_identity_header.dart)

### `KlpStageFrame`

- Consumer intent：在工作區中配置主要工作內容的邊界。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「在工作區中配置主要工作內容的邊界」只描述單一frame、pane或outlet的放置技術，必須吸收到Kallopis定義的完整layout內部。
- Secondary：`CAT-LAYOUT`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/features/workspace/shell/stage/klp_stage_frame.dart`](../../lib/src/features/workspace/shell/stage/klp_stage_frame.dart)

### `KlpStageHeader`

- Consumer intent：呈現主要工作內容的標題、狀態與操作。
- Role：`composition-part`
- Composition level：`container`
- Composition rationale：「呈現主要工作內容的標題、狀態與操作」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-ACTION`、`CAT-LAYOUT`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/features/workspace/shell/stage/klp_stage_header.dart`](../../lib/src/features/workspace/shell/stage/klp_stage_header.dart)

### `KlpStageTopBar`

- Consumer intent：在主要工作內容上方排列導覽、狀態與操作。
- Role：`composition-part`
- Composition level：`container`
- Composition rationale：「在主要工作內容上方排列導覽、狀態與操作」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-ACTION`、`CAT-LAYOUT`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart`](../../lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart)

### `KlpStatusBar`

- Consumer intent：在工作區固定區域呈現整體狀態與摘要。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「在工作區固定區域呈現整體狀態與摘要」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-FEEDBACK`、`CAT-LAYOUT`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/features/workspace/shell/status/klp_status_bar.dart`](../../lib/src/features/workspace/shell/status/klp_status_bar.dart)

### `KlpWindowAppIcon`

- Consumer intent：在桌面視窗標題區呈現應用識別圖示。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「在桌面視窗標題區呈現應用識別圖示」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-SYSTEM`、`CAT-VISUAL`
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/features/workspace/shell/window/klp_window_app_icon.dart`](../../lib/src/features/workspace/shell/window/klp_window_app_icon.dart)

### `KlpWindowControls`

- Consumer intent：提交最小化、最大化或還原與關閉視窗的宿主意圖。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「提交最小化、最大化或還原與關閉視窗的宿主意圖」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-ACTION`、`CAT-SYSTEM`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/features/workspace/shell/window/klp_window_controls.dart`](../../lib/src/features/workspace/shell/window/klp_window_controls.dart)

### `KlpWindowHeader`

- Consumer intent：組成桌面視窗標題、拖曳區與視窗操作。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「組成桌面視窗標題、拖曳區與視窗操作」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-LAYOUT`、`CAT-SYSTEM`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/features/workspace/shell/window/klp_window_header.dart`](../../lib/src/features/workspace/shell/window/klp_window_header.dart)


## 布局與組成 (`CAT-LAYOUT`) — 32

### `KlpAlign`

- Consumer intent：在受控容器內依核准位置安排內容。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「在受控容器內依核准位置安排內容」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：無
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/foundation/layout/klp_align.dart`](../../lib/src/foundation/layout/klp_align.dart)

### `KlpBox`

- Consumer intent：為內容提供舊版通用尺寸與表面容器。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「為內容提供舊版通用尺寸與表面容器」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：無
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/foundation/layout/klp_box.dart`](../../lib/src/foundation/layout/klp_box.dart)

### `KlpCenter`

- Consumer intent：在受控區域中央安排單一內容。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「在受控區域中央安排單一內容」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：無
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/foundation/layout/klp_center.dart`](../../lib/src/foundation/layout/klp_center.dart)

### `KlpColumn`

- Consumer intent：以舊版垂直線性規則排列多個內容。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「以舊版垂直線性規則排列多個內容」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：無
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/foundation/layout/klp_column.dart`](../../lib/src/foundation/layout/klp_column.dart)

### `KlpConstrainedBox`

- Consumer intent：以舊版通用界限限制內容尺寸。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「以舊版通用界限限制內容尺寸」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：無
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/foundation/layout/klp_constrained_box.dart`](../../lib/src/foundation/layout/klp_constrained_box.dart)

### `KlpDirectionalPositioned`

- Consumer intent：依文字方向在舊版疊放容器中定位內容。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「依文字方向在舊版疊放容器中定位內容」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-SYSTEM`
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/foundation/layout/klp_directional_positioned.dart`](../../lib/src/foundation/layout/klp_directional_positioned.dart)

### `KlpDockHeader`

- Consumer intent：呈現可停駐區域的標題與局部操作。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「呈現可停駐區域的標題與局部操作」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-ACTION`、`CAT-APP`
- 舊 Catalog：可停駐工作區（`Docking`）
- 舊來源：[`lib/src/features/workspace/shell/docking/internal/klp_dock_header_widget.dart`](../../lib/src/features/workspace/shell/docking/internal/klp_dock_header_widget.dart)

### `KlpDockLayout`

- Consumer intent：安排可停駐、移動或重組的工作區域。
- Role：`consumer-capability`
- Composition level：`layout`
- Composition rationale：「安排可停駐、移動或重組的工作區域」屬畫面區域關係，只以具名typed roles承載核准的功能container，實際排列由Kallopis決定。
- Secondary：`CAT-APP`
- 舊 Catalog：可停駐工作區（`Docking`）
- 舊來源：[`lib/src/features/workspace/shell/docking/internal/klp_dock_layout_widget.dart`](../../lib/src/features/workspace/shell/docking/internal/klp_dock_layout_widget.dart)

### `KlpExpanded`

- Consumer intent：讓舊版線性布局中的內容填滿剩餘空間。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「讓舊版線性布局中的內容填滿剩餘空間」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：無
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/foundation/layout/klp_expanded.dart`](../../lib/src/foundation/layout/klp_expanded.dart)

### `KlpFit`

- Consumer intent：依舊版通用規則縮放內容以符合可用區域。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「依舊版通用規則縮放內容以符合可用區域」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：無
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/foundation/layout/klp_fit.dart`](../../lib/src/foundation/layout/klp_fit.dart)

### `KlpFlexible`

- Consumer intent：讓舊版線性布局中的內容彈性使用可用空間。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「讓舊版線性布局中的內容彈性使用可用空間」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：無
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/foundation/layout/klp_flexible.dart`](../../lib/src/foundation/layout/klp_flexible.dart)

### `KlpGap`

- Consumer intent：在舊版布局中插入固定語意間距。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「在舊版布局中插入固定語意間距」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-VISUAL`
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/foundation/layout/klp_gap.dart`](../../lib/src/foundation/layout/klp_gap.dart)

### `KlpLayoutBuilder`

- Consumer intent：依舊版可用尺寸動態建立布局內容。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「依舊版可用尺寸動態建立布局內容」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-SYSTEM`
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/foundation/layout/klp_layout_builder.dart`](../../lib/src/foundation/layout/klp_layout_builder.dart)

### `KlpPaneCollapseControl`

- Consumer intent：收合或展開工作區中的一個面板。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「收合或展開工作區中的一個面板」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-ACTION`、`CAT-APP`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart`](../../lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart)

### `KlpPanelFooter`

- Consumer intent：在面板底部安排摘要或操作內容。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「在面板底部安排摘要或操作內容」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-ACTION`
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/features/workspace/shell/panel/klp_panel_footer.dart`](../../lib/src/features/workspace/shell/panel/klp_panel_footer.dart)

### `KlpPanelFrame`

- Consumer intent：為工作區面板提供具角色的內容邊界。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「為工作區面板提供具角色的內容邊界」只描述單一frame、pane或outlet的放置技術，必須吸收到Kallopis定義的完整layout內部。
- Secondary：`CAT-APP`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/features/workspace/shell/panel/klp_panel_frame.dart`](../../lib/src/features/workspace/shell/panel/klp_panel_frame.dart)

### `KlpPanelHeader`

- Consumer intent：呈現工作區面板的名稱、狀態與局部操作。
- Role：`composition-part`
- Composition level：`container`
- Composition rationale：「呈現工作區面板的名稱、狀態與局部操作」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-ACTION`、`CAT-APP`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/features/workspace/shell/panel/klp_panel_header.dart`](../../lib/src/features/workspace/shell/panel/klp_panel_header.dart)

### `KlpPositioned`

- Consumer intent：在舊版疊放容器中以指定方位安排內容。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「在舊版疊放容器中以指定方位安排內容」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：無
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/foundation/layout/klp_positioned.dart`](../../lib/src/foundation/layout/klp_positioned.dart)

### `KlpRegion`

- Consumer intent：把頁面內容組成具用途的受控區域。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「把頁面內容組成具用途的受控區域」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-APP`
- 舊 Catalog：區塊與主題（`Block Layout & Theme`）
- 舊來源：[`lib/src/foundation/layout/klp_region.dart`](../../lib/src/foundation/layout/klp_region.dart)

### `KlpResizablePane`

- Consumer intent：讓使用者在核准界限內調整面板所占空間。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「讓使用者在核准界限內調整面板所占空間」只描述單一frame、pane或outlet的放置技術，必須吸收到Kallopis定義的完整layout內部。
- Secondary：`CAT-ACTION`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/foundation/layout/klp_resizable_pane.dart`](../../lib/src/foundation/layout/klp_resizable_pane.dart)

### `KlpResizeHandle`

- Consumer intent：提供調整相鄰面板尺寸的拖曳命中區。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「提供調整相鄰面板尺寸的拖曳命中區」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-SYSTEM`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/foundation/layout/klp_resize_handle.dart`](../../lib/src/foundation/layout/klp_resize_handle.dart)

### `KlpResponsivePaneCoordinator`

- Consumer intent：依可用空間協調多個工作面板的顯示狀態。
- Role：`system-contract`
- Composition level：`none`
- Composition rationale：「依可用空間協調多個工作面板的顯示狀態」屬Kallopis安裝的跨切面宿主或互動契約，不是consumer可放置的結構。
- Secondary：`CAT-APP`、`CAT-SYSTEM`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart`](../../lib/src/features/workspace/shell/composition/pane/klp_responsive_pane_coordinator.dart)

### `KlpRotate`

- Consumer intent：依舊版布局需求旋轉呈現內容。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「依舊版布局需求旋轉呈現內容」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-VISUAL`
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/foundation/layout/klp_rotate.dart`](../../lib/src/foundation/layout/klp_rotate.dart)

### `KlpRow`

- Consumer intent：以舊版水平線性規則排列多個內容。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「以舊版水平線性規則排列多個內容」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：無
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/foundation/layout/klp_row.dart`](../../lib/src/foundation/layout/klp_row.dart)

### `KlpScrollViewport`

- Consumer intent：在有限區域內瀏覽超出可用空間的內容。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「在有限區域內瀏覽超出可用空間的內容」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-SYSTEM`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/foundation/layout/klp_scroll_viewport.dart`](../../lib/src/foundation/layout/klp_scroll_viewport.dart)

### `KlpSection`

- Consumer intent：以舊版標題與間距組成一段內容。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「以舊版標題與間距組成一段內容」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-VISUAL`
- 舊 Catalog：區塊與主題（`Block Layout & Theme`）
- 舊來源：[`lib/src/foundation/surface/legacy_components/klp_section.dart`](../../lib/src/foundation/surface/legacy_components/klp_section.dart)

### `KlpSidebarFrame`

- Consumer intent：在工作區中配置一般側邊內容區。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「在工作區中配置一般側邊內容區」只描述單一frame、pane或outlet的放置技術，必須吸收到Kallopis定義的完整layout內部。
- Secondary：`CAT-APP`、`CAT-NAV`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart`](../../lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart)

### `KlpSpacer`

- Consumer intent：在舊版線性布局中占用剩餘空間。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「在舊版線性布局中占用剩餘空間」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：無
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/foundation/layout/klp_spacer.dart`](../../lib/src/foundation/layout/klp_spacer.dart)

### `KlpSplitLayout`

- Consumer intent：把可用空間分配給兩個或多個相鄰區域。
- Role：`consumer-capability`
- Composition level：`layout`
- Composition rationale：「把可用空間分配給兩個或多個相鄰區域」屬畫面區域關係，只以具名typed roles承載核准的功能container，實際排列由Kallopis決定。
- Secondary：`CAT-APP`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/foundation/layout/klp_split_layout.dart`](../../lib/src/foundation/layout/klp_split_layout.dart)

### `KlpStack`

- Consumer intent：以舊版疊放規則安排多個內容。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「以舊版疊放規則安排多個內容」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：無
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/foundation/layout/klp_stack.dart`](../../lib/src/foundation/layout/klp_stack.dart)

### `KlpTranslate`

- Consumer intent：依舊版布局需求位移呈現內容。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「依舊版布局需求位移呈現內容」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-VISUAL`
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/foundation/layout/klp_translate.dart`](../../lib/src/foundation/layout/klp_translate.dart)

### `KlpWrap`

- Consumer intent：以舊版換行規則排列空間不足的多個內容。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「以舊版換行規則排列空間不足的多個內容」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：無
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/foundation/layout/klp_wrap.dart`](../../lib/src/foundation/layout/klp_wrap.dart)


## 導覽與探索 (`CAT-NAV`) — 16

### `KlpBreadcrumb`

- Consumer intent：呈現目前位置的階層路徑並允許返回上層。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「呈現目前位置的階層路徑並允許返回上層」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：無
- 舊 Catalog：動作與導覽（`Actions & Navigation`）
- 舊來源：[`lib/src/features/navigation/widgets/breadcrumb/klp_breadcrumb.dart`](../../lib/src/features/navigation/widgets/breadcrumb/klp_breadcrumb.dart)

### `KlpExplorer`

- Consumer intent：瀏覽階層資料並提交選取、展開與命令意圖。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「瀏覽階層資料並提交選取、展開與命令意圖」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-DATA`、`CAT-FILE`
- 舊 Catalog：檔案總管（`File Explorer`）
- 舊來源：[`lib/src/features/workspace/explorer/klp_explorer.dart`](../../lib/src/features/workspace/explorer/klp_explorer.dart)

### `KlpNavigationRail`

- Consumer intent：以垂直精簡入口切換應用主要位置。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「以垂直精簡入口切換應用主要位置」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-APP`
- 舊 Catalog：動作與導覽（`Actions & Navigation`）
- 舊來源：[`lib/src/features/navigation/widgets/rail/internal/klp_navigation_rail_widget.dart`](../../lib/src/features/navigation/widgets/rail/internal/klp_navigation_rail_widget.dart)

### `KlpNavigationRailFrame`

- Consumer intent：在工作區中配置垂直導覽列的邊界與位置。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「在工作區中配置垂直導覽列的邊界與位置」只描述單一frame、pane或outlet的放置技術，必須吸收到Kallopis定義的完整layout內部。
- Secondary：`CAT-LAYOUT`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/features/workspace/shell/composition/klp_navigation_rail_frame.dart`](../../lib/src/features/workspace/shell/composition/klp_navigation_rail_frame.dart)

### `KlpNavigator`

- Consumer intent：組織側邊導覽群組並回報位置切換意圖。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「組織側邊導覽群組並回報位置切換意圖」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-APP`
- 舊 Catalog：Navigator Sidebar 組合（`Sidebar Shell`）
- 舊來源：[`lib/src/features/navigation/widgets/navigator/internal/klp_navigator_widget.dart`](../../lib/src/features/navigation/widgets/navigator/internal/klp_navigator_widget.dart)

### `KlpPagination`

- Consumer intent：在分頁資料集合之間移動並顯示目前位置。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「在分頁資料集合之間移動並顯示目前位置」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-DATA`
- 舊 Catalog：動作與導覽（`Actions & Navigation`）
- 舊來源：[`lib/src/features/navigation/widgets/controls/klp_pagination.dart`](../../lib/src/features/navigation/widgets/controls/klp_pagination.dart)

### `KlpPreviewTree`

- Consumer intent：以舊版階層結構預覽可探索內容。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「以舊版階層結構預覽可探索內容」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-DATA`
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/features/navigation/widgets/preview_tree/klp_preview_tree.dart`](../../lib/src/features/navigation/widgets/preview_tree/klp_preview_tree.dart)

### `KlpPrimarySidebarFrame`

- Consumer intent：在應用工作區中配置主要側邊導覽區。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「在應用工作區中配置主要側邊導覽區」只描述單一frame、pane或outlet的放置技術，必須吸收到Kallopis定義的完整layout內部。
- Secondary：`CAT-APP`、`CAT-LAYOUT`
- 舊 Catalog：Navigator Sidebar 組合（`Sidebar Shell`）
- 舊來源：[`lib/src/features/workspace/shell/sidebar/klp_primary_sidebar_frame.dart`](../../lib/src/features/workspace/shell/sidebar/klp_primary_sidebar_frame.dart)

### `KlpRailItem`

- Consumer intent：描述垂直導覽列中的單一目的地。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「描述垂直導覽列中的單一目的地」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：無
- 舊 Catalog：動作與導覽（`Actions & Navigation`）
- 舊來源：[`lib/src/features/navigation/widgets/rail/internal/klp_rail_item_widget.dart`](../../lib/src/features/navigation/widgets/rail/internal/klp_rail_item_widget.dart)

### `KlpRouterOutlet`

- Consumer intent：在應用畫面中呈現目前導覽目的地的內容。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「在應用畫面中呈現目前導覽目的地的內容」只描述單一frame、pane或outlet的放置技術，必須吸收到Kallopis定義的完整layout內部。
- Secondary：`CAT-APP`
- 舊 Catalog：動作與導覽（`Actions & Navigation`）
- 舊來源：[`lib/src/features/navigation/legacy_router/klp_router_outlet.dart`](../../lib/src/features/navigation/legacy_router/klp_router_outlet.dart)

### `KlpSidebarNavigationButton`

- Consumer intent：在側邊導覽中提供單一目的地入口。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「在側邊導覽中提供單一目的地入口」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-ACTION`
- 舊 Catalog：動作與導覽（`Actions & Navigation`）
- 舊來源：[`lib/src/features/navigation/widgets/sidebar/klp_sidebar_navigation_button.dart`](../../lib/src/features/navigation/widgets/sidebar/klp_sidebar_navigation_button.dart)

### `KlpSidebarNavigationGroup`

- Consumer intent：把側邊導覽目的地整理成一個群組。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「把側邊導覽目的地整理成一個群組」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-LAYOUT`
- 舊 Catalog：Navigator Sidebar 組合（`Sidebar Shell`）
- 舊來源：[`lib/src/features/navigation/widgets/sidebar/klp_sidebar_navigation_group.dart`](../../lib/src/features/navigation/widgets/sidebar/klp_sidebar_navigation_group.dart)

### `KlpSidebarSectionLabel`

- Consumer intent：標示側邊導覽中一組目的地的名稱。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「標示側邊導覽中一組目的地的名稱」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-VISUAL`
- 舊 Catalog：動作與導覽（`Actions & Navigation`）
- 舊來源：[`lib/src/features/navigation/widgets/sidebar/klp_sidebar_section_label.dart`](../../lib/src/features/navigation/widgets/sidebar/klp_sidebar_section_label.dart)

### `KlpStageTab`

- Consumer intent：描述主要工作區中一個可切換的內容分頁。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「描述主要工作區中一個可切換的內容分頁」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-DOC`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/features/workspace/shell/stage/klp_stage_tab.dart`](../../lib/src/features/workspace/shell/stage/klp_stage_tab.dart)

### `KlpTabs`

- Consumer intent：在同一位置切換多個同層內容檢視。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「在同一位置切換多個同層內容檢視」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：無
- 舊 Catalog：動作與導覽（`Actions & Navigation`）
- 舊來源：[`lib/src/features/navigation/widgets/tabs/klp_tabs.dart`](../../lib/src/features/navigation/widgets/tabs/klp_tabs.dart)

### `KlpViewSwitcher`

- Consumer intent：切換同一資料的不同檢視方式。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「切換同一資料的不同檢視方式」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-DATA`
- 舊 Catalog：動作與導覽（`Actions & Navigation`）
- 舊來源：[`lib/src/features/navigation/widgets/controls/klp_view_switcher.dart`](../../lib/src/features/navigation/widgets/controls/klp_view_switcher.dart)


## 動作與命令 (`CAT-ACTION`) — 12

### `KlpActionGroup`

- Consumer intent：把彼此相關的操作整理為一組可辨識的控制。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「把彼此相關的操作整理為一組可辨識的控制」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：無
- 舊 Catalog：動作與導覽（`Actions & Navigation`）
- 舊來源：[`lib/src/features/navigation/widgets/controls/klp_action_group.dart`](../../lib/src/features/navigation/widgets/controls/klp_action_group.dart)

### `KlpActionRegion`

- Consumer intent：讓既有內容區域具備一致的啟用與命中行為。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「讓既有內容區域具備一致的啟用與命中行為」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-SYSTEM`
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/foundation/interaction/primitives/klp_action_region_widget.dart`](../../lib/src/foundation/interaction/primitives/klp_action_region_widget.dart)

### `KlpBulkActionBar`

- Consumer intent：對一批已選取資料提供共同操作。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「對一批已選取資料提供共同操作」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-DATA`
- 舊 Catalog：動作與導覽（`Actions & Navigation`）
- 舊來源：[`lib/src/features/actions/editor/klp_bulk_action_bar.dart`](../../lib/src/features/actions/editor/klp_bulk_action_bar.dart)

### `KlpButton`

- Consumer intent：提供具有文字語意的主要或次要操作入口。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「提供具有文字語意的主要或次要操作入口」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：無
- 舊 Catalog：動作與導覽（`Actions & Navigation`）
- 舊來源：[`lib/src/features/actions/button/internal/klp_button_widget.dart`](../../lib/src/features/actions/button/internal/klp_button_widget.dart)

### `KlpCommandMenu`

- Consumer intent：搜尋並執行目前上下文可用的命令。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「搜尋並執行目前上下文可用的命令」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-OVERLAY`、`CAT-SEARCH`
- 舊 Catalog：動作與導覽（`Actions & Navigation`）
- 舊來源：[`lib/src/features/actions/command_menu/internal/klp_command_menu_widget.dart`](../../lib/src/features/actions/command_menu/internal/klp_command_menu_widget.dart)

### `KlpEditorToolbar`

- Consumer intent：提供內容編輯器目前可用的格式與操作。
- Role：`composition-part`
- Composition level：`container`
- Composition rationale：「提供內容編輯器目前可用的格式與操作」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-DOC`
- 舊 Catalog：動作與導覽（`Actions & Navigation`）
- 舊來源：[`lib/src/features/actions/editor/klp_editor_toolbar.dart`](../../lib/src/features/actions/editor/klp_editor_toolbar.dart)

### `KlpFormActions`

- Consumer intent：呈現表單提交、取消或其他流程操作。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「呈現表單提交、取消或其他流程操作」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-FORM`
- 舊 Catalog：表單組裝與挑選器（`Form Assembly & Pickers`）
- 舊來源：[`lib/src/features/forms/core/klp_form_actions.dart`](../../lib/src/features/forms/core/klp_form_actions.dart)

### `KlpIconButton`

- Consumer intent：提供只以圖示呈現且具輔助標籤的操作。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「提供只以圖示呈現且具輔助標籤的操作」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-SYSTEM`
- 舊 Catalog：動作與導覽（`Actions & Navigation`）
- 舊來源：[`lib/src/features/actions/button/internal/klp_icon_button_widget.dart`](../../lib/src/features/actions/button/internal/klp_icon_button_widget.dart)

### `KlpMenu`

- Consumer intent：呈現一組目前上下文可選取或執行的操作。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「呈現一組目前上下文可選取或執行的操作」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-OVERLAY`
- 舊 Catalog：動作與導覽（`Actions & Navigation`）
- 舊來源：[`lib/src/features/overlays/menu/klp_menu_widget.dart`](../../lib/src/features/overlays/menu/klp_menu_widget.dart)

### `KlpMenuItem`

- Consumer intent：描述選單中的單一操作、狀態或子選單入口。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「描述選單中的單一操作、狀態或子選單入口」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-OVERLAY`
- 舊 Catalog：動作與導覽（`Actions & Navigation`）
- 舊來源：[`lib/src/features/overlays/menu/klp_menu_item.dart`](../../lib/src/features/overlays/menu/klp_menu_item.dart)

### `KlpSelectionToolbar`

- Consumer intent：為目前已選取內容提供上下文操作。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「為目前已選取內容提供上下文操作」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-DATA`、`CAT-OVERLAY`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/features/actions/selection_toolbar/internal/klp_selection_toolbar_widget.dart`](../../lib/src/features/actions/selection_toolbar/internal/klp_selection_toolbar_widget.dart)

### `KlpSidebarButtonGroup`

- Consumer intent：在側邊區把相關操作整理成舊版按鈕群組。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「在側邊區把相關操作整理成舊版按鈕群組」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-NAV`
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/features/navigation/widgets/sidebar/klp_sidebar_button_group.dart`](../../lib/src/features/navigation/widgets/sidebar/klp_sidebar_button_group.dart)


## 資料與集合 (`CAT-DATA`) — 18

### `KlpAccordion`

- Consumer intent：以可展開區段呈現需要逐段查看的資料。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「以可展開區段呈現需要逐段查看的資料」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：無
- 舊 Catalog：資料呈現（`Data Display`）
- 舊來源：[`lib/src/features/collections/accordion/internal/klp_accordion_widget.dart`](../../lib/src/features/collections/accordion/internal/klp_accordion_widget.dart)

### `KlpAvatar`

- Consumer intent：以圖像或替代標識呈現一個人物或主體。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「以圖像或替代標識呈現一個人物或主體」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-COLLAB`
- 舊 Catalog：資料呈現（`Data Display`）
- 舊來源：[`lib/src/features/collections/avatar/klp_avatar.dart`](../../lib/src/features/collections/avatar/klp_avatar.dart)

### `KlpAvatarGroup`

- Consumer intent：以緊湊集合呈現多個人物或主體。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「以緊湊集合呈現多個人物或主體」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-COLLAB`
- 舊 Catalog：資料呈現（`Data Display`）
- 舊來源：[`lib/src/features/collections/avatar/klp_avatar_group.dart`](../../lib/src/features/collections/avatar/klp_avatar_group.dart)

### `KlpBadge`

- Consumer intent：在資料旁呈現短小的分類、數量或狀態標記。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「在資料旁呈現短小的分類、數量或狀態標記」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-FEEDBACK`
- 舊 Catalog：資料呈現（`Data Display`）
- 舊來源：[`lib/src/features/collections/badge/internal/klp_badge_widget.dart`](../../lib/src/features/collections/badge/internal/klp_badge_widget.dart)

### `KlpCard`

- Consumer intent：以具邊界的摘要單位呈現一筆資料或內容。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「以具邊界的摘要單位呈現一筆資料或內容」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-LAYOUT`
- 舊 Catalog：區塊與主題（`Block Layout & Theme`）
- 舊來源：[`lib/src/features/collections/card/internal/klp_card_widget.dart`](../../lib/src/features/collections/card/internal/klp_card_widget.dart)

### `KlpDataTable`

- Consumer intent：以欄列結構呈現並操作多筆結構化資料。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「以欄列結構呈現並操作多筆結構化資料」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：無
- 舊 Catalog：資料呈現（`Data Display`）
- 舊來源：[`lib/src/features/collections/advanced/internal/klp_data_table.dart`](../../lib/src/features/collections/advanced/internal/klp_data_table.dart)

### `KlpJsonTree`

- Consumer intent：以可展開階層閱讀結構化鍵值資料。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「以可展開階層閱讀結構化鍵值資料」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-DOC`
- 舊 Catalog：等寬（`Monospace (data & logs)`）
- 舊來源：[`lib/src/features/collections/advanced/internal/klp_json_tree.dart`](../../lib/src/features/collections/advanced/internal/klp_json_tree.dart)

### `KlpKeyValueList`

- Consumer intent：以線性項目呈現名稱與值的對應。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「以線性項目呈現名稱與值的對應」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：無
- 舊 Catalog：資料呈現（`Data Display`）
- 舊來源：[`lib/src/features/collections/key_value/internal/klp_key_value_list_widget.dart`](../../lib/src/features/collections/key_value/internal/klp_key_value_list_widget.dart)

### `KlpKeyValueTable`

- Consumer intent：以欄列表格比較多組名稱與值。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「以欄列表格比較多組名稱與值」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：無
- 舊 Catalog：資料呈現（`Data Display`）
- 舊來源：[`lib/src/features/collections/key_value/internal/klp_key_value_table_widget.dart`](../../lib/src/features/collections/key_value/internal/klp_key_value_table_widget.dart)

### `KlpListTile`

- Consumer intent：以一致行格式呈現一筆可辨識的資料。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「以一致行格式呈現一筆可辨識的資料」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-ACTION`
- 舊 Catalog：資料呈現（`Data Display`）
- 舊來源：[`lib/src/features/collections/list_tile/internal/klp_list_tile_widget.dart`](../../lib/src/features/collections/list_tile/internal/klp_list_tile_widget.dart)

### `KlpMasonryGrid`

- Consumer intent：以高度不一的欄列排列預覽資料。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「以高度不一的欄列排列預覽資料」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-LAYOUT`
- 舊 Catalog：瀑布流與預覽卡（`Masonry`）
- 舊來源：[`lib/src/foundation/layout/klp_masonry_grid.dart`](../../lib/src/foundation/layout/klp_masonry_grid.dart)

### `KlpMetricCard`

- Consumer intent：突出呈現一個關鍵數值及其摘要脈絡。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「突出呈現一個關鍵數值及其摘要脈絡」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-CHART`
- 舊 Catalog：資料呈現（`Data Display`）
- 舊來源：[`lib/src/features/collections/card/internal/klp_metric_card_widget.dart`](../../lib/src/features/collections/card/internal/klp_metric_card_widget.dart)

### `KlpPreviewCard`

- Consumer intent：以卡片摘要預覽一項可開啟內容。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「以卡片摘要預覽一項可開啟內容」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-NAV`
- 舊 Catalog：瀑布流與預覽卡（`Masonry`）
- 舊來源：[`lib/src/features/collections/preview_card/internal/klp_preview_card_widget.dart`](../../lib/src/features/collections/preview_card/internal/klp_preview_card_widget.dart)

### `KlpTag`

- Consumer intent：以短文字標示資料的分類或屬性。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「以短文字標示資料的分類或屬性」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：無
- 舊 Catalog：資料呈現（`Data Display`）
- 舊來源：[`lib/src/features/collections/badge/internal/klp_tag_widget.dart`](../../lib/src/features/collections/badge/internal/klp_tag_widget.dart)

### `KlpTree`

- Consumer intent：以可展開階層呈現並操作結構化資料。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「以可展開階層呈現並操作結構化資料」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-NAV`
- 舊 Catalog：資料呈現（`Data Display`）
- 舊來源：[`lib/src/features/collections/advanced/internal/klp_tree.dart`](../../lib/src/features/collections/advanced/internal/klp_tree.dart)

### `KlpTreeItem`

- Consumer intent：描述階層資料中的單一節點與展開狀態。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「描述階層資料中的單一節點與展開狀態」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-NAV`
- 舊 Catalog：資料呈現（`Data Display`）
- 舊來源：[`lib/src/features/collections/advanced/internal/klp_tree_item.dart`](../../lib/src/features/collections/advanced/internal/klp_tree_item.dart)

### `KlpVirtualGrid`

- Consumer intent：以格狀方式有效瀏覽大量資料。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「以格狀方式有效瀏覽大量資料」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-LAYOUT`、`CAT-SYSTEM`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/foundation/layout/klp_virtual_grid.dart`](../../lib/src/foundation/layout/klp_virtual_grid.dart)

### `KlpVirtualList`

- Consumer intent：以線性方式有效瀏覽大量資料。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「以線性方式有效瀏覽大量資料」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-LAYOUT`、`CAT-SYSTEM`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/foundation/layout/klp_virtual_list.dart`](../../lib/src/foundation/layout/klp_virtual_list.dart)


## 搜尋與篩選 (`CAT-SEARCH`) — 3

### `KlpFilterBar`

- Consumer intent：集中呈現目前資料檢視可用的篩選條件。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「集中呈現目前資料檢視可用的篩選條件」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-DATA`、`CAT-FORM`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart`](../../lib/src/foundation/interaction/filter/internal/klp_filter_bar_widget.dart)

### `KlpSearchNavigator`

- Consumer intent：在搜尋結果之間移動並顯示目前命中位置。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「在搜尋結果之間移動並顯示目前命中位置」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-NAV`
- 舊 Catalog：動作與導覽（`Actions & Navigation`）
- 舊來源：[`lib/src/features/actions/editor/klp_search_navigator.dart`](../../lib/src/features/actions/editor/klp_search_navigator.dart)

### `KlpSortControl`

- Consumer intent：選擇資料集合目前的排序方式與方向。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「選擇資料集合目前的排序方式與方向」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-DATA`、`CAT-FORM`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/features/collections/sort_control/klp_sort_control.dart`](../../lib/src/features/collections/sort_control/klp_sort_control.dart)


## 表單與輸入 (`CAT-FORM`) — 42

### `KlpAffixedTextField`

- Consumer intent：輸入帶有固定前綴或後綴語意的文字值。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「輸入帶有固定前綴或後綴語意的文字值」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：無
- 舊 Catalog：表單控制項（`Form Controls`）
- 舊來源：[`lib/src/features/forms/input/klp_affixed_text_field.dart`](../../lib/src/features/forms/input/klp_affixed_text_field.dart)

### `KlpApprovalStepsField`

- Consumer intent：輸入並調整具有先後次序的核准步驟。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「輸入並調整具有先後次序的核准步驟」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-PLAN`
- 舊 Catalog：表單組裝與挑選器（`Form Assembly & Pickers`）
- 舊來源：[`lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart`](../../lib/src/features/forms/structured/internal/klp_approval_steps_field_widget.dart)

### `KlpCheckbox`

- Consumer intent：輸入一個可獨立選取或取消的布林值。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「輸入一個可獨立選取或取消的布林值」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：無
- 舊 Catalog：表單控制項（`Form Controls`）
- 舊來源：[`lib/src/features/forms/selection/internal/klp_checkbox_widget.dart`](../../lib/src/features/forms/selection/internal/klp_checkbox_widget.dart)

### `KlpCodeEditorField`

- Consumer intent：在表單中輸入並編輯結構化程式文字。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「在表單中輸入並編輯結構化程式文字」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-DOC`
- 舊 Catalog：表單組裝與挑選器（`Form Assembly & Pickers`）
- 舊來源：[`lib/src/features/forms/structured/internal/klp_code_editor_field_widget.dart`](../../lib/src/features/forms/structured/internal/klp_code_editor_field_widget.dart)

### `KlpCodeField`

- Consumer intent：輸入需要程式文字語意與驗證的值。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「輸入需要程式文字語意與驗證的值」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-DOC`
- 舊 Catalog：表單控制項（`Form Controls`）
- 舊來源：[`lib/src/features/forms/structured/internal/klp_code_field_widget.dart`](../../lib/src/features/forms/structured/internal/klp_code_field_widget.dart)

### `KlpColorRoleField`

- Consumer intent：從核准的語意色彩角色中選取一個值。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「從核准的語意色彩角色中選取一個值」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-VISUAL`
- 舊 Catalog：表單控制項（`Form Controls`）
- 舊來源：[`lib/src/features/forms/selection/klp_color_role_field.dart`](../../lib/src/features/forms/selection/klp_color_role_field.dart)

### `KlpCombobox`

- Consumer intent：透過輸入查找候選並選取一個值。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「透過輸入查找候選並選取一個值」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-SEARCH`
- 舊 Catalog：表單控制項（`Form Controls`）
- 舊來源：[`lib/src/features/forms/input/internal/klp_combobox_widget.dart`](../../lib/src/features/forms/input/internal/klp_combobox_widget.dart)

### `KlpCompactSwitch`

- Consumer intent：在狹窄空間輸入一個開關值。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「在狹窄空間輸入一個開關值」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：無
- 舊 Catalog：表單控制項（`Form Controls`）
- 舊來源：[`lib/src/features/forms/toggle/internal/klp_compact_switch_widget.dart`](../../lib/src/features/forms/toggle/internal/klp_compact_switch_widget.dart)

### `KlpCompoundField`

- Consumer intent：把多個彼此相依的輸入組成一個欄位值。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「把多個彼此相依的輸入組成一個欄位值」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：無
- 舊 Catalog：表單控制項（`Form Controls`）
- 舊來源：[`lib/src/features/forms/input/internal/klp_compound_field_widget.dart`](../../lib/src/features/forms/input/internal/klp_compound_field_widget.dart)

### `KlpConditionalFieldRegion`

- Consumer intent：依其他表單資料決定一組欄位是否出現。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「依其他表單資料決定一組欄位是否出現」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：無
- 舊 Catalog：表單組裝與挑選器（`Form Assembly & Pickers`）
- 舊來源：[`lib/src/features/forms/core/klp_conditional_field_region.dart`](../../lib/src/features/forms/core/klp_conditional_field_region.dart)

### `KlpDateField`

- Consumer intent：輸入或選取單一日期值。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「輸入或選取單一日期值」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-PLAN`
- 舊 Catalog：表單控制項（`Form Controls`）
- 舊來源：[`lib/src/features/forms/selection/klp_date_field.dart`](../../lib/src/features/forms/selection/klp_date_field.dart)

### `KlpDateRangeField`

- Consumer intent：輸入具有開始與結束的日期範圍。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「輸入具有開始與結束的日期範圍」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-PLAN`
- 舊 Catalog：表單控制項（`Form Controls`）
- 舊來源：[`lib/src/features/forms/selection/klp_date_range_field.dart`](../../lib/src/features/forms/selection/klp_date_range_field.dart)

### `KlpEntityPicker`

- Consumer intent：查找並選取產品資料中的一個主體。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「查找並選取產品資料中的一個主體」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-DATA`、`CAT-SEARCH`
- 舊 Catalog：表單組裝與挑選器（`Form Assembly & Pickers`）
- 舊來源：[`lib/src/features/workspace/entity_picker/internal/klp_entity_picker_widget.dart`](../../lib/src/features/workspace/entity_picker/internal/klp_entity_picker_widget.dart)

### `KlpField`

- Consumer intent：以一致標籤、說明與錯誤包裝一個輸入。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「以一致標籤、說明與錯誤包裝一個輸入」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：無
- 舊 Catalog：表單組裝與挑選器（`Form Assembly & Pickers`）
- 舊來源：[`lib/src/features/forms/core/klp_field.dart`](../../lib/src/features/forms/core/klp_field.dart)

### `KlpFieldDescription`

- Consumer intent：為表單輸入提供補充說明。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「為表單輸入提供補充說明」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-FEEDBACK`
- 舊 Catalog：表單組裝與挑選器（`Form Assembly & Pickers`）
- 舊來源：[`lib/src/features/forms/core/klp_field_description.dart`](../../lib/src/features/forms/core/klp_field_description.dart)

### `KlpFieldError`

- Consumer intent：在表單輸入旁呈現驗證錯誤。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「在表單輸入旁呈現驗證錯誤」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-FEEDBACK`
- 舊 Catalog：表單組裝與挑選器（`Form Assembly & Pickers`）
- 舊來源：[`lib/src/features/forms/core/klp_field_error.dart`](../../lib/src/features/forms/core/klp_field_error.dart)

### `KlpFieldGroup`

- Consumer intent：把語意相關的表單輸入組成一個區段。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「把語意相關的表單輸入組成一個區段」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-LAYOUT`
- 舊 Catalog：表單組裝與挑選器（`Form Assembly & Pickers`）
- 舊來源：[`lib/src/features/forms/core/klp_field_group.dart`](../../lib/src/features/forms/core/klp_field_group.dart)

### `KlpFieldLabel`

- Consumer intent：為表單輸入提供可關聯的名稱。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「為表單輸入提供可關聯的名稱」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-SYSTEM`
- 舊 Catalog：表單組裝與挑選器（`Form Assembly & Pickers`）
- 舊來源：[`lib/src/features/forms/core/klp_field_label.dart`](../../lib/src/features/forms/core/klp_field_label.dart)

### `KlpForm`

- Consumer intent：組織、驗證並提交一組結構化輸入。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「組織、驗證並提交一組結構化輸入」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-ACTION`
- 舊 Catalog：表單組裝與挑選器（`Form Assembly & Pickers`）
- 舊來源：[`lib/src/features/forms/core/klp_form.dart`](../../lib/src/features/forms/core/klp_form.dart)

### `KlpFormErrorSummary`

- Consumer intent：集中列出表單中需要修正的驗證問題。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「集中列出表單中需要修正的驗證問題」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-FEEDBACK`、`CAT-NAV`
- 舊 Catalog：表單組裝與挑選器（`Form Assembly & Pickers`）
- 舊來源：[`lib/src/features/forms/core/klp_form_error_summary.dart`](../../lib/src/features/forms/core/klp_form_error_summary.dart)

### `KlpFormSection`

- Consumer intent：把一組相關輸入整理成具名稱的表單區段。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「把一組相關輸入整理成具名稱的表單區段」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-LAYOUT`
- 舊 Catalog：表單組裝與挑選器（`Form Assembly & Pickers`）
- 舊來源：[`lib/src/features/forms/core/klp_form_section.dart`](../../lib/src/features/forms/core/klp_form_section.dart)

### `KlpKeyValueEditor`

- Consumer intent：新增、刪除並編輯成對的名稱與值。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「新增、刪除並編輯成對的名稱與值」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-DATA`
- 舊 Catalog：表單組裝與挑選器（`Form Assembly & Pickers`）
- 舊來源：[`lib/src/features/forms/structured/internal/klp_key_value_editor_widget.dart`](../../lib/src/features/forms/structured/internal/klp_key_value_editor_widget.dart)

### `KlpMultiSelectField`

- Consumer intent：從候選集合中輸入多個已選值。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「從候選集合中輸入多個已選值」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-DATA`
- 舊 Catalog：表單控制項（`Form Controls`）
- 舊來源：[`lib/src/features/forms/selection/klp_multi_select_field.dart`](../../lib/src/features/forms/selection/klp_multi_select_field.dart)

### `KlpNumberField`

- Consumer intent：輸入並驗證數值。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「輸入並驗證數值」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：無
- 舊 Catalog：表單控制項（`Form Controls`）
- 舊來源：[`lib/src/features/forms/input/klp_number_field.dart`](../../lib/src/features/forms/input/klp_number_field.dart)

### `KlpPasswordField`

- Consumer intent：安全輸入可隱藏與顯示的密碼文字。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「安全輸入可隱藏與顯示的密碼文字」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-SYSTEM`
- 舊 Catalog：表單控制項（`Form Controls`）
- 舊來源：[`lib/src/features/forms/input/internal/klp_password_field_widget.dart`](../../lib/src/features/forms/input/internal/klp_password_field_widget.dart)

### `KlpPhaseToggle`

- Consumer intent：在兩個具流程階段語意的值之間切換。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「在兩個具流程階段語意的值之間切換」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-PLAN`
- 舊 Catalog：表單控制項（`Form Controls`）
- 舊來源：[`lib/src/features/forms/toggle/internal/klp_phase_toggle_widget.dart`](../../lib/src/features/forms/toggle/internal/klp_phase_toggle_widget.dart)

### `KlpQuantityField`

- Consumer intent：輸入具有增減操作與界限的數量值。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「輸入具有增減操作與界限的數量值」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-ACTION`
- 舊 Catalog：表單控制項（`Form Controls`）
- 舊來源：[`lib/src/features/forms/input/klp_quantity_field.dart`](../../lib/src/features/forms/input/klp_quantity_field.dart)

### `KlpRadioGroup`

- Consumer intent：從一組互斥候選中輸入單一值。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「從一組互斥候選中輸入單一值」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：無
- 舊 Catalog：表單控制項（`Form Controls`）
- 舊來源：[`lib/src/features/forms/selection/internal/klp_radio_group_widget.dart`](../../lib/src/features/forms/selection/internal/klp_radio_group_widget.dart)

### `KlpReferencePicker`

- Consumer intent：搜尋並選取可被目前內容引用的主體。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「搜尋並選取可被目前內容引用的主體」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-DOC`、`CAT-SEARCH`
- 舊 Catalog：表單組裝與挑選器（`Form Assembly & Pickers`）
- 舊來源：[`lib/src/features/forms/picker/klp_reference_picker.dart`](../../lib/src/features/forms/picker/klp_reference_picker.dart)

### `KlpRepeaterField`

- Consumer intent：在表單中新增、移除與重排同型態輸入項目。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「在表單中新增、移除與重排同型態輸入項目」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-ACTION`、`CAT-DATA`
- 舊 Catalog：表單組裝與挑選器（`Form Assembly & Pickers`）
- 舊來源：[`lib/src/features/forms/structured/internal/klp_repeater_field_widget.dart`](../../lib/src/features/forms/structured/internal/klp_repeater_field_widget.dart)

### `KlpSegmentedControl`

- Consumer intent：從並列的少量互斥選項中輸入單一值。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「從並列的少量互斥選項中輸入單一值」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-ACTION`
- 舊 Catalog：表單控制項（`Form Controls`）
- 舊來源：[`lib/src/features/forms/selection/internal/klp_segmented_control_widget.dart`](../../lib/src/features/forms/selection/internal/klp_segmented_control_widget.dart)

### `KlpSelect`

- Consumer intent：從封閉候選清單中輸入單一值。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「從封閉候選清單中輸入單一值」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-OVERLAY`
- 舊 Catalog：表單控制項（`Form Controls`）
- 舊來源：[`lib/src/features/forms/selection/internal/klp_select_widget.dart`](../../lib/src/features/forms/selection/internal/klp_select_widget.dart)

### `KlpSelectField`

- Consumer intent：以具標籤與驗證的選擇器輸入單一值。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「以具標籤與驗證的選擇器輸入單一值」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-OVERLAY`
- 舊 Catalog：表單控制項（`Form Controls`）
- 舊來源：[`lib/src/features/forms/selection/internal/klp_select_field_widget.dart`](../../lib/src/features/forms/selection/internal/klp_select_field_widget.dart)

### `KlpSlider`

- Consumer intent：在連續或分段範圍內輸入數值。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「在連續或分段範圍內輸入數值」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-ACTION`
- 舊 Catalog：表單控制項（`Form Controls`）
- 舊來源：[`lib/src/features/forms/selection/internal/klp_slider_widget.dart`](../../lib/src/features/forms/selection/internal/klp_slider_widget.dart)

### `KlpSlidingSelection`

- Consumer intent：以可滑動指標在並列選項間輸入單一值。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「以可滑動指標在並列選項間輸入單一值」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-ACTION`
- 舊 Catalog：表單控制項（`Form Controls`）
- 舊來源：[`lib/src/features/forms/selection/internal/klp_sliding_selection_widget.dart`](../../lib/src/features/forms/selection/internal/klp_sliding_selection_widget.dart)

### `KlpTagChip`

- Consumer intent：呈現表單中一個可移除或操作的標籤值。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「呈現表單中一個可移除或操作的標籤值」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-DATA`
- 舊 Catalog：表單控制項（`Form Controls`）
- 舊來源：[`lib/src/features/forms/selection/klp_tag_chip.dart`](../../lib/src/features/forms/selection/klp_tag_chip.dart)

### `KlpTagInputField`

- Consumer intent：輸入、新增與移除多個文字標籤值。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「輸入、新增與移除多個文字標籤值」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-DATA`
- 舊 Catalog：表單控制項（`Form Controls`）
- 舊來源：[`lib/src/features/forms/selection/klp_tag_input_field.dart`](../../lib/src/features/forms/selection/klp_tag_input_field.dart)

### `KlpTextArea`

- Consumer intent：輸入可包含多行的純文字值。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「輸入可包含多行的純文字值」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-DOC`
- 舊 Catalog：表單控制項（`Form Controls`）
- 舊來源：[`lib/src/features/forms/input/klp_text_area.dart`](../../lib/src/features/forms/input/klp_text_area.dart)

### `KlpTextField`

- Consumer intent：輸入單行文字值。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「輸入單行文字值」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：無
- 舊 Catalog：表單控制項（`Form Controls`）
- 舊來源：[`lib/src/features/forms/input/internal/klp_text_field_widget.dart`](../../lib/src/features/forms/input/internal/klp_text_field_widget.dart)

### `KlpToggle`

- Consumer intent：輸入一個開啟或關閉的布林值。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「輸入一個開啟或關閉的布林值」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：無
- 舊 Catalog：表單控制項（`Form Controls`）
- 舊來源：[`lib/src/features/forms/toggle/internal/klp_toggle_widget.dart`](../../lib/src/features/forms/toggle/internal/klp_toggle_widget.dart)

### `KlpToggleIndicator`

- Consumer intent：在另一項控制內呈現布林選取狀態。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「在另一項控制內呈現布林選取狀態」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-VISUAL`
- 舊 Catalog：表單控制項（`Form Controls`）
- 舊來源：[`lib/src/features/forms/toggle/internal/klp_toggle_indicator_widget.dart`](../../lib/src/features/forms/toggle/internal/klp_toggle_indicator_widget.dart)

### `KlpTriStateToggle`

- Consumer intent：輸入是、否或未決三種狀態。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「輸入是、否或未決三種狀態」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：無
- 舊 Catalog：表單控制項（`Form Controls`）
- 舊來源：[`lib/src/features/forms/toggle/internal/klp_tri_state_toggle_widget.dart`](../../lib/src/features/forms/toggle/internal/klp_tri_state_toggle_widget.dart)


## 狀態與回饋 (`CAT-FEEDBACK`) — 16

### `KlpEmptyState`

- Consumer intent：在沒有可呈現資料時說明狀態與下一步。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「在沒有可呈現資料時說明狀態與下一步」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：無
- 舊 Catalog：檢視狀態與回饋（`View States & Feedback`）
- 舊來源：[`lib/src/features/feedback/empty_state/klp_empty_state_widget.dart`](../../lib/src/features/feedback/empty_state/klp_empty_state_widget.dart)

### `KlpErrorState`

- Consumer intent：在內容無法載入或操作失敗時提供說明與復原。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「在內容無法載入或操作失敗時提供說明與復原」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-ACTION`
- 舊 Catalog：檢視狀態與回饋（`View States & Feedback`）
- 舊來源：[`lib/src/features/feedback/view_states/klp_error_state.dart`](../../lib/src/features/feedback/view_states/klp_error_state.dart)

### `KlpGeometricSpinner`

- Consumer intent：以持續圖形動態表示短暫等待狀態。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「以持續圖形動態表示短暫等待狀態」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-VISUAL`
- 舊 Catalog：檢視狀態與回饋（`View States & Feedback`）
- 舊來源：[`lib/src/foundation/klp_geometric_spinner.dart`](../../lib/src/foundation/klp_geometric_spinner.dart)

### `KlpInlineNotice`

- Consumer intent：在目前內容流內呈現重要提示或警告。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「在目前內容流內呈現重要提示或警告」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-DOC`
- 舊 Catalog：檢視狀態與回饋（`View States & Feedback`）
- 舊來源：[`lib/src/features/feedback/klp_inline_notice.dart`](../../lib/src/features/feedback/klp_inline_notice.dart)

### `KlpLoadingState`

- Consumer intent：在主要內容仍在取得時呈現可理解的等待狀態。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「在主要內容仍在取得時呈現可理解的等待狀態」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：無
- 舊 Catalog：檢視狀態與回饋（`View States & Feedback`）
- 舊來源：[`lib/src/features/feedback/view_states/klp_loading_state.dart`](../../lib/src/features/feedback/view_states/klp_loading_state.dart)

### `KlpPermissionState`

- Consumer intent：說明目前權限不足並提供可行下一步。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「說明目前權限不足並提供可行下一步」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-ACTION`、`CAT-SYSTEM`
- 舊 Catalog：檢視狀態與回饋（`View States & Feedback`）
- 舊來源：[`lib/src/features/feedback/view_states/klp_permission_state.dart`](../../lib/src/features/feedback/view_states/klp_permission_state.dart)

### `KlpProgress`

- Consumer intent：呈現一項工作目前已完成的比例或狀態。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「呈現一項工作目前已完成的比例或狀態」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：無
- 舊 Catalog：資料呈現（`Data Display`）
- 舊來源：[`lib/src/features/collections/progress/internal/klp_progress_widget.dart`](../../lib/src/features/collections/progress/internal/klp_progress_widget.dart)

### `KlpProgressOverlay`

- Consumer intent：在工作進行期間以暫態表面阻止或限制其他操作。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「在工作進行期間以暫態表面阻止或限制其他操作」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-OVERLAY`
- 舊 Catalog：檢視狀態與回饋（`View States & Feedback`）
- 舊來源：[`lib/src/features/feedback/view_states/klp_progress_overlay.dart`](../../lib/src/features/feedback/view_states/klp_progress_overlay.dart)

### `KlpPublicationProgressOverlay`

- Consumer intent：在內容發布期間呈現進度並限制衝突操作。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「在內容發布期間呈現進度並限制衝突操作」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-DOC`、`CAT-OVERLAY`
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/features/navigation/widgets/preview_tree/klp_publication_progress_overlay.dart`](../../lib/src/features/navigation/widgets/preview_tree/klp_publication_progress_overlay.dart)

### `KlpRegionPlaceholder`

- Consumer intent：在內容區尚未提供資料時保留並說明其位置。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「在內容區尚未提供資料時保留並說明其位置」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-LAYOUT`
- 舊 Catalog：區域佔位（`Region placeholder`）
- 舊來源：[`lib/src/features/feedback/region_placeholder/klp_region_placeholder_widget.dart`](../../lib/src/features/feedback/region_placeholder/klp_region_placeholder_widget.dart)

### `KlpSaveStatusCard`

- Consumer intent：呈現內容目前的儲存結果、進度或錯誤。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「呈現內容目前的儲存結果、進度或錯誤」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-DOC`
- 舊 Catalog：表單組裝與挑選器（`Form Assembly & Pickers`）
- 舊來源：[`lib/src/features/workspace/page_chrome/internal/klp_save_status_card.dart`](../../lib/src/features/workspace/page_chrome/internal/klp_save_status_card.dart)

### `KlpSegmentedProgress`

- Consumer intent：以多個階段區段呈現工作進度。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「以多個階段區段呈現工作進度」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-PLAN`
- 舊 Catalog：資料呈現（`Data Display`）
- 舊來源：[`lib/src/foundation/klp_segmented_progress.dart`](../../lib/src/foundation/klp_segmented_progress.dart)

### `KlpSkeletonLine`

- Consumer intent：在文字資料尚未到達時保留可預期的內容形狀。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「在文字資料尚未到達時保留可預期的內容形狀」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-VISUAL`
- 舊 Catalog：檢視狀態與回饋（`View States & Feedback`）
- 舊來源：[`lib/src/features/feedback/empty_state/klp_skeleton_line.dart`](../../lib/src/features/feedback/empty_state/klp_skeleton_line.dart)

### `KlpStatusIndicator`

- Consumer intent：以精簡符號呈現一項資料目前的狀態。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「以精簡符號呈現一項資料目前的狀態」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-DATA`
- 舊 Catalog：資料呈現（`Data Display`）
- 舊來源：[`lib/src/features/feedback/klp_status_indicator.dart`](../../lib/src/features/feedback/klp_status_indicator.dart)

### `KlpToast`

- Consumer intent：短暫通知一項不需阻斷操作的結果。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「短暫通知一項不需阻斷操作的結果」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-OVERLAY`
- 舊 Catalog：檢視狀態與回饋（`View States & Feedback`）
- 舊來源：[`lib/src/features/feedback/toast/klp_toast_widget.dart`](../../lib/src/features/feedback/toast/klp_toast_widget.dart)

### `KlpToastStack`

- Consumer intent：依序管理並呈現多則短暫通知。
- Role：`system-contract`
- Composition level：`none`
- Composition rationale：「依序管理並呈現多則短暫通知」屬Kallopis安裝的跨切面宿主或互動契約，不是consumer可放置的結構。
- Secondary：`CAT-OVERLAY`
- 舊 Catalog：檢視狀態與回饋（`View States & Feedback`）
- 舊來源：[`lib/src/features/feedback/toast/klp_toast_stack.dart`](../../lib/src/features/feedback/toast/klp_toast_stack.dart)


## 浮層與暫態介面 (`CAT-OVERLAY`) — 11

### `KlpContextMenu`

- Consumer intent：在目前指向的內容旁顯示可執行操作。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「在目前指向的內容旁顯示可執行操作」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-ACTION`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/features/overlays/context_menu/klp_context_menu_widget.dart`](../../lib/src/features/overlays/context_menu/klp_context_menu_widget.dart)

### `KlpDialog`

- Consumer intent：以需要回應的暫態表面承載訊息或操作流程。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「以需要回應的暫態表面承載訊息或操作流程」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-ACTION`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/features/overlays/klp_dialog.dart`](../../lib/src/features/overlays/klp_dialog.dart)

### `KlpDrawer`

- Consumer intent：從畫面邊緣顯示可暫時開關的內容面板。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「從畫面邊緣顯示可暫時開關的內容面板」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-LAYOUT`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/features/overlays/drawer/klp_drawer_widget.dart`](../../lib/src/features/overlays/drawer/klp_drawer_widget.dart)

### `KlpModalFrame`

- Consumer intent：為需要阻斷背景互動的暫態內容提供舊版框架。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「為需要阻斷背景互動的暫態內容提供舊版框架」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-LAYOUT`
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/features/overlays/primitives/klp_modal_frame.dart`](../../lib/src/features/overlays/primitives/klp_modal_frame.dart)

### `KlpOverlayHost`

- Consumer intent：為目前畫面上的暫態介面提供共同承載區。
- Role：`system-contract`
- Composition level：`none`
- Composition rationale：「為目前畫面上的暫態介面提供共同承載區」屬Kallopis安裝的跨切面宿主或互動契約，不是consumer可放置的結構。
- Secondary：`CAT-APP`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/foundation/layout/klp_overlay_host.dart`](../../lib/src/foundation/layout/klp_overlay_host.dart)

### `KlpPopover`

- Consumer intent：在錨點旁暫時顯示補充內容或操作。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「在錨點旁暫時顯示補充內容或操作」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-ACTION`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/features/overlays/klp_popover.dart`](../../lib/src/features/overlays/klp_popover.dart)

### `KlpPopupBackground`

- Consumer intent：為舊版彈出內容提供標準背景表面。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「為舊版彈出內容提供標準背景表面」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-VISUAL`
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/features/overlays/popup/klp_popup_background.dart`](../../lib/src/features/overlays/popup/klp_popup_background.dart)

### `KlpPopupPanel`

- Consumer intent：為舊版彈出內容提供面板邊界與排列。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「為舊版彈出內容提供面板邊界與排列」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-LAYOUT`
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/features/overlays/popup/klp_popup_panel.dart`](../../lib/src/features/overlays/popup/klp_popup_panel.dart)

### `KlpTooltip`

- Consumer intent：在指向或聚焦操作時暫時顯示補充說明。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「在指向或聚焦操作時暫時顯示補充說明」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-SYSTEM`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/features/overlays/primitives/klp_tooltip_widget.dart`](../../lib/src/features/overlays/primitives/klp_tooltip_widget.dart)

### `KlpTooltipSurface`

- Consumer intent：為提示內容提供舊版視覺表面。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「為提示內容提供舊版視覺表面」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-VISUAL`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/features/overlays/tooltip/klp_tooltip_surface.dart`](../../lib/src/features/overlays/tooltip/klp_tooltip_surface.dart)

### `KlpVeil`

- Consumer intent：以舊版遮罩弱化背景並限制互動。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「以舊版遮罩弱化背景並限制互動」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-VISUAL`
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/foundation/surface/klp_veil.dart`](../../lib/src/foundation/surface/klp_veil.dart)


## 文件、內容與編輯 (`CAT-DOC`) — 14

### `KlpCodeViewer`

- Consumer intent：以適合程式文字的格式閱讀內容。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「以適合程式文字的格式閱讀內容」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：無
- 舊 Catalog：等寬（`Monospace (data & logs)`）
- 舊來源：[`lib/src/features/collections/code/internal/klp_code_viewer_widget.dart`](../../lib/src/features/collections/code/internal/klp_code_viewer_widget.dart)

### `KlpDiffViewer`

- Consumer intent：閱讀兩份文字內容之間的差異。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「閱讀兩份文字內容之間的差異」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-DATA`
- 舊 Catalog：等寬（`Monospace (data & logs)`）
- 舊來源：[`lib/src/features/collections/code/internal/klp_diff_viewer_widget.dart`](../../lib/src/features/collections/code/internal/klp_diff_viewer_widget.dart)

### `KlpDocumentEditActions`

- Consumer intent：提供目前文件內容可執行的編輯操作。
- Role：`composition-part`
- Composition level：`container`
- Composition rationale：「提供目前文件內容可執行的編輯操作」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-ACTION`
- 舊 Catalog：Canonical artifacts（`Artifact workspace`）
- 舊來源：[`lib/src/features/workspace/artifact/internal/klp_document_edit_actions.dart`](../../lib/src/features/workspace/artifact/internal/klp_document_edit_actions.dart)

### `KlpDocumentField`

- Consumer intent：在文件結構中呈現一個具名稱的資料欄位。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「在文件結構中呈現一個具名稱的資料欄位」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-DATA`
- 舊 Catalog：Canonical artifacts（`Artifact workspace`）
- 舊來源：[`lib/src/features/workspace/artifact/internal/klp_document_field.dart`](../../lib/src/features/workspace/artifact/internal/klp_document_field.dart)

### `KlpDocumentHeader`

- Consumer intent：呈現文件的身分、標題與主要狀態。
- Role：`composition-part`
- Composition level：`container`
- Composition rationale：「呈現文件的身分、標題與主要狀態」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-APP`
- 舊 Catalog：Canonical artifacts（`Artifact workspace`）
- 舊來源：[`lib/src/features/workspace/artifact/internal/klp_document_header.dart`](../../lib/src/features/workspace/artifact/internal/klp_document_header.dart)

### `KlpDocumentReferenceLink`

- Consumer intent：在文件中呈現並開啟另一項內容引用。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「在文件中呈現並開啟另一項內容引用」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-NAV`
- 舊 Catalog：Canonical artifacts（`Artifact workspace`）
- 舊來源：[`lib/src/features/workspace/artifact/internal/klp_document_reference_link.dart`](../../lib/src/features/workspace/artifact/internal/klp_document_reference_link.dart)

### `KlpDocumentSection`

- Consumer intent：把文件內容組成具語意的段落區域。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「把文件內容組成具語意的段落區域」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-LAYOUT`
- 舊 Catalog：Canonical artifacts（`Artifact workspace`）
- 舊來源：[`lib/src/features/workspace/artifact/internal/klp_document_section.dart`](../../lib/src/features/workspace/artifact/internal/klp_document_section.dart)

### `KlpInlineCode`

- Consumer intent：在段落文字中標示短小的程式或技術內容。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「在段落文字中標示短小的程式或技術內容」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-VISUAL`
- 舊 Catalog：文字與長文（`Prose / Text`）
- 舊來源：[`lib/src/foundation/klp_inline_code.dart`](../../lib/src/foundation/klp_inline_code.dart)

### `KlpPageBackgroundEditor`

- Consumer intent：為文件編輯畫面提供舊版頁面背景結構。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「為文件編輯畫面提供舊版頁面背景結構」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-LAYOUT`、`CAT-VISUAL`
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/foundation/surface/page_background/klp_page_background_editor.dart`](../../lib/src/foundation/surface/page_background/klp_page_background_editor.dart)

### `KlpPageChrome`

- Consumer intent：組成文件或資料頁面的標題、內容與操作區。
- Role：`consumer-capability`
- Composition level：`layout`
- Composition rationale：「組成文件或資料頁面的標題、內容與操作區」屬畫面區域關係，只以具名typed roles承載核准的功能container，實際排列由Kallopis決定。
- Secondary：`CAT-APP`、`CAT-LAYOUT`
- 舊 Catalog：表單組裝與挑選器（`Form Assembly & Pickers`）
- 舊來源：[`lib/src/features/workspace/page_chrome/internal/klp_page_chrome_widget.dart`](../../lib/src/features/workspace/page_chrome/internal/klp_page_chrome_widget.dart)

### `KlpPropertySummary`

- Consumer intent：摘要呈現目前文件或主體的重要屬性。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「摘要呈現目前文件或主體的重要屬性」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-DATA`
- 舊 Catalog：表單組裝與挑選器（`Form Assembly & Pickers`）
- 舊來源：[`lib/src/features/workspace/page_chrome/internal/klp_property_summary.dart`](../../lib/src/features/workspace/page_chrome/internal/klp_property_summary.dart)

### `KlpRichText`

- Consumer intent：閱讀包含多種行內語意與標記的文字內容。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「閱讀包含多種行內語意與標記的文字內容」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：無
- 舊 Catalog：文字與長文（`Prose / Text`）
- 舊來源：[`lib/src/foundation/content/klp_rich_text.dart`](../../lib/src/foundation/content/klp_rich_text.dart)

### `KlpTerminal`

- Consumer intent：閱讀命令、輸出與紀錄形成的終端內容。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「閱讀命令、輸出與紀錄形成的終端內容」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-DATA`
- 舊 Catalog：等寬（`Monospace (data & logs)`）
- 舊來源：[`lib/src/features/collections/code/internal/klp_terminal_widget.dart`](../../lib/src/features/collections/code/internal/klp_terminal_widget.dart)

### `KlpText`

- Consumer intent：以核准文字角色呈現一般短文內容。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「以核准文字角色呈現一般短文內容」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-VISUAL`
- 舊 Catalog：文字與長文（`Prose / Text`）
- 舊來源：[`lib/src/foundation/content/klp_text_widget.dart`](../../lib/src/foundation/content/klp_text_widget.dart)


## 規劃與時間 (`CAT-PLAN`) — 8

### `KlpCalendar`

- Consumer intent：以月曆結構瀏覽並選取日期。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「以月曆結構瀏覽並選取日期」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-FORM`
- 舊 Catalog：表單控制項（`Form Controls`）
- 舊來源：[`lib/src/features/forms/selection/internal/klp_calendar_widget.dart`](../../lib/src/features/forms/selection/internal/klp_calendar_widget.dart)

### `KlpDateGrid`

- Consumer intent：按日期格狀排列並瀏覽排程資料。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「按日期格狀排列並瀏覽排程資料」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-DATA`
- 舊 Catalog：日期、待辦與排程（`Agenda`）
- 舊來源：[`lib/src/features/collections/date_grid/internal/klp_date_grid_widget.dart`](../../lib/src/features/collections/date_grid/internal/klp_date_grid_widget.dart)

### `KlpScheduleList`

- Consumer intent：按時間順序呈現排程項目。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「按時間順序呈現排程項目」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-DATA`
- 舊 Catalog：日期、待辦與排程（`Agenda`）
- 舊來源：[`lib/src/features/collections/agenda/klp_schedule_list.dart`](../../lib/src/features/collections/agenda/klp_schedule_list.dart)

### `KlpStepper`

- Consumer intent：呈現並導引具有明確先後順序的流程步驟。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「呈現並導引具有明確先後順序的流程步驟」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-NAV`
- 舊 Catalog：資料呈現（`Data Display`）
- 舊來源：[`lib/src/features/collections/stepper/klp_stepper_widget.dart`](../../lib/src/features/collections/stepper/klp_stepper_widget.dart)

### `KlpTaskList`

- Consumer intent：呈現並操作具有完成狀態的任務集合。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「呈現並操作具有完成狀態的任務集合」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-DATA`
- 舊 Catalog：日期、待辦與排程（`Agenda`）
- 舊來源：[`lib/src/features/collections/agenda/klp_task_list.dart`](../../lib/src/features/collections/agenda/klp_task_list.dart)

### `KlpTimeline`

- Consumer intent：沿時間順序呈現事件、里程碑或活動。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「沿時間順序呈現事件、里程碑或活動」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-DATA`
- 舊 Catalog：資料呈現（`Data Display`）
- 舊來源：[`lib/src/features/collections/timeline/internal/klp_timeline_widget.dart`](../../lib/src/features/collections/timeline/internal/klp_timeline_widget.dart)

### `KlpWorkflowProgress`

- Consumer intent：呈現多階段工作流程目前的完成位置。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「呈現多階段工作流程目前的完成位置」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-FEEDBACK`
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/features/feedback/workflow/klp_workflow_progress.dart`](../../lib/src/features/feedback/workflow/klp_workflow_progress.dart)

### `KlpWorkflowStateSurface`

- Consumer intent：呈現工作流程某一狀態的內容與可用操作。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「呈現工作流程某一狀態的內容與可用操作」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-ACTION`、`CAT-FEEDBACK`
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/features/feedback/workflow/klp_workflow_state_surface.dart`](../../lib/src/features/feedback/workflow/klp_workflow_state_surface.dart)


## 設定與偏好 (`CAT-SETTINGS`) — 14

### `KlpSettingsActionBar`

- Consumer intent：呈現設定變更的套用、取消或重設操作。
- Role：`composition-part`
- Composition level：`container`
- Composition rationale：「呈現設定變更的套用、取消或重設操作」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-ACTION`
- 舊 Catalog：設定頁與外觀（`Settings`）
- 舊來源：[`lib/src/features/workspace/settings/klp_settings_action_bar.dart`](../../lib/src/features/workspace/settings/klp_settings_action_bar.dart)

### `KlpSettingsContentHeader`

- Consumer intent：呈現目前設定範圍的標題與說明。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「呈現目前設定範圍的標題與說明」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-LAYOUT`
- 舊 Catalog：設定頁與外觀（`Settings`）
- 舊來源：[`lib/src/features/workspace/settings/layout/klp_settings_content_header.dart`](../../lib/src/features/workspace/settings/layout/klp_settings_content_header.dart)

### `KlpSettingsContentPane`

- Consumer intent：承載目前選取設定頁的欄位內容。
- Role：`composition-part`
- Composition level：`container`
- Composition rationale：「承載目前選取設定頁的欄位內容」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-LAYOUT`
- 舊 Catalog：設定頁與外觀（`Settings`）
- 舊來源：[`lib/src/features/workspace/settings/layout/klp_settings_content_pane.dart`](../../lib/src/features/workspace/settings/layout/klp_settings_content_pane.dart)

### `KlpSettingsDialog`

- Consumer intent：在暫態視窗中完成應用或工作區設定。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「在暫態視窗中完成應用或工作區設定」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-OVERLAY`
- 舊 Catalog：設定頁與外觀（`Settings`）
- 舊來源：[`lib/src/features/workspace/settings/layout/klp_settings_dialog.dart`](../../lib/src/features/workspace/settings/layout/klp_settings_dialog.dart)

### `KlpSettingsField`

- Consumer intent：呈現並修改一項具名稱與說明的偏好值。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「呈現並修改一項具名稱與說明的偏好值」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-FORM`
- 舊 Catalog：設定頁與外觀（`Settings`）
- 舊來源：[`lib/src/features/workspace/settings/klp_settings_content.dart`](../../lib/src/features/workspace/settings/klp_settings_content.dart)

### `KlpSettingsNavigationGroup`

- Consumer intent：把相關設定目的地整理成具名稱的群組。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「把相關設定目的地整理成具名稱的群組」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-NAV`
- 舊 Catalog：設定頁與外觀（`Settings`）
- 舊來源：[`lib/src/features/workspace/settings/navigation/klp_settings_navigation_group.dart`](../../lib/src/features/workspace/settings/navigation/klp_settings_navigation_group.dart)

### `KlpSettingsNavigationHeader`

- Consumer intent：呈現設定導覽區的身分與說明。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「呈現設定導覽區的身分與說明」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-NAV`
- 舊 Catalog：設定頁與外觀（`Settings`）
- 舊來源：[`lib/src/features/workspace/settings/navigation/klp_settings_navigation_header.dart`](../../lib/src/features/workspace/settings/navigation/klp_settings_navigation_header.dart)

### `KlpSettingsNavigationItem`

- Consumer intent：描述一個可切換的設定目的地。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「描述一個可切換的設定目的地」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-NAV`
- 舊 Catalog：設定頁與外觀（`Settings`）
- 舊來源：[`lib/src/features/workspace/settings/navigation/klp_settings_navigation_item.dart`](../../lib/src/features/workspace/settings/navigation/klp_settings_navigation_item.dart)

### `KlpSettingsNavigationPane`

- Consumer intent：承載設定分類與頁面切換入口。
- Role：`composition-part`
- Composition level：`container`
- Composition rationale：「承載設定分類與頁面切換入口」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-NAV`
- 舊 Catalog：設定頁與外觀（`Settings`）
- 舊來源：[`lib/src/features/workspace/settings/layout/klp_settings_navigation_pane.dart`](../../lib/src/features/workspace/settings/layout/klp_settings_navigation_pane.dart)

### `KlpSettingsPage`

- Consumer intent：組成可瀏覽與修改的一頁設定內容。
- Role：`consumer-capability`
- Composition level：`layout`
- Composition rationale：「組成可瀏覽與修改的一頁設定內容」屬畫面區域關係，只以具名typed roles承載核准的功能container，實際排列由Kallopis決定。
- Secondary：`CAT-FORM`
- 舊 Catalog：設定頁與外觀（`Settings`）
- 舊來源：[`lib/src/features/workspace/settings/layout/klp_settings_page.dart`](../../lib/src/features/workspace/settings/layout/klp_settings_page.dart)

### `KlpSettingsScopeSwitcher`

- Consumer intent：切換目前正在修改的設定作用範圍。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「切換目前正在修改的設定作用範圍」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-FORM`
- 舊 Catalog：設定頁與外觀（`Settings`）
- 舊來源：[`lib/src/features/workspace/settings/navigation/klp_settings_scope_switcher.dart`](../../lib/src/features/workspace/settings/navigation/klp_settings_scope_switcher.dart)

### `KlpSettingsSearchField`

- Consumer intent：搜尋並定位符合文字的設定項目。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「搜尋並定位符合文字的設定項目」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-SEARCH`
- 舊 Catalog：設定頁與外觀（`Settings`）
- 舊來源：[`lib/src/features/workspace/settings/navigation/klp_settings_search_field.dart`](../../lib/src/features/workspace/settings/navigation/klp_settings_search_field.dart)

### `KlpThemeModePicker`

- Consumer intent：選擇應用偏好的明暗或跟隨系統模式。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「選擇應用偏好的明暗或跟隨系統模式」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-FORM`、`CAT-VISUAL`
- 舊 Catalog：設定頁與外觀（`Settings`）
- 舊來源：[`lib/src/features/workspace/settings/klp_theme_mode_picker.dart`](../../lib/src/features/workspace/settings/klp_theme_mode_picker.dart)

### `KlpThemeToggle`

- Consumer intent：在兩個核准的視覺模式間切換偏好。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「在兩個核准的視覺模式間切換偏好」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-ACTION`、`CAT-VISUAL`
- 舊 Catalog：區塊與主題（`Block Layout & Theme`）
- 舊來源：[`lib/src/features/workspace/shell/theme/klp_theme_toggle.dart`](../../lib/src/features/workspace/shell/theme/klp_theme_toggle.dart)


## 檔案與資產 (`CAT-FILE`) — 8

### `KlpFileDropzoneField`

- Consumer intent：透過拖放選取一個或多個檔案資產。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「透過拖放選取一個或多個檔案資產」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-FORM`、`CAT-SYSTEM`
- 舊 Catalog：表單組裝與挑選器（`Form Assembly & Pickers`）
- 舊來源：[`lib/src/features/forms/structured/internal/klp_file_dropzone_field_widget.dart`](../../lib/src/features/forms/structured/internal/klp_file_dropzone_field_widget.dart)

### `KlpFileExplorer`

- Consumer intent：以檔案階層瀏覽資料夾與資產。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「以檔案階層瀏覽資料夾與資產」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-NAV`
- 舊 Catalog：檔案總管（`File Explorer`）
- 舊來源：[`lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_widget.dart`](../../lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_widget.dart)

### `KlpFileExplorerFolderView`

- Consumer intent：在檔案階層中呈現一個資料夾節點。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「在檔案階層中呈現一個資料夾節點」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-NAV`
- 舊 Catalog：檔案總管（`File Explorer`）
- 舊來源：[`lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_folder_view.dart`](../../lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_folder_view.dart)

### `KlpFileExplorerItemView`

- Consumer intent：在檔案階層中呈現一個資產項目。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「在檔案階層中呈現一個資產項目」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-NAV`
- 舊 Catalog：檔案總管（`File Explorer`）
- 舊來源：[`lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_item_view.dart`](../../lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_item_view.dart)

### `KlpFileExplorerSection`

- Consumer intent：把檔案階層資料分成具名稱的區段。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「把檔案階層資料分成具名稱的區段」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-LAYOUT`
- 舊 Catalog：檔案總管（`File Explorer`）
- 舊來源：[`lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_section.dart`](../../lib/src/features/navigation/widgets/explorer/models/klp_file_explorer_section.dart)

### `KlpFileExplorerSectionView`

- Consumer intent：呈現檔案階層中的一個具名稱區段。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「呈現檔案階層中的一個具名稱區段」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-LAYOUT`
- 舊 Catalog：檔案總管（`File Explorer`）
- 舊來源：[`lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_section_view.dart`](../../lib/src/features/navigation/widgets/explorer/internal/klp_file_explorer_section_view.dart)

### `KlpFileField`

- Consumer intent：在表單中選取並顯示檔案值。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「在表單中選取並顯示檔案值」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-FORM`
- 舊 Catalog：表單控制項（`Form Controls`）
- 舊來源：[`lib/src/features/forms/structured/internal/klp_file_field_widget.dart`](../../lib/src/features/forms/structured/internal/klp_file_field_widget.dart)

### `KlpFilePreview`

- Consumer intent：在開啟前預覽檔案資產的內容或摘要。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「在開啟前預覽檔案資產的內容或摘要」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-DATA`
- 舊 Catalog：資料呈現（`Data Display`）
- 舊來源：[`lib/src/features/collections/advanced/internal/klp_file_preview.dart`](../../lib/src/features/collections/advanced/internal/klp_file_preview.dart)


## 溝通與協作 (`CAT-COLLAB`) — 5

### `KlpMessageBubble`

- Consumer intent：呈現單一參與者的一則訊息內容。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「呈現單一參與者的一則訊息內容」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-DATA`
- 舊 Catalog：訊息串與輸入器（`Conversation`）
- 舊來源：[`lib/src/features/collections/message_thread/internal/klp_message_bubble_widget.dart`](../../lib/src/features/collections/message_thread/internal/klp_message_bubble_widget.dart)

### `KlpMessageComposer`

- Consumer intent：撰寫並提交一則新訊息。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「撰寫並提交一則新訊息」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-FORM`
- 舊 Catalog：訊息串與輸入器（`Conversation`）
- 舊來源：[`lib/src/features/workspace/message_composer/internal/klp_message_composer_widget.dart`](../../lib/src/features/workspace/message_composer/internal/klp_message_composer_widget.dart)

### `KlpMessageConversation`

- Consumer intent：組成可閱讀與回覆的完整訊息對話。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「組成可閱讀與回覆的完整訊息對話」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-LAYOUT`
- 舊 Catalog：訊息串與輸入器（`Conversation`）
- 舊來源：[`lib/src/features/workspace/message_composer/internal/klp_message_conversation_widget.dart`](../../lib/src/features/workspace/message_composer/internal/klp_message_conversation_widget.dart)

### `KlpMessageThread`

- Consumer intent：按時間或回覆關係呈現一組訊息。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「按時間或回覆關係呈現一組訊息」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-DATA`
- 舊 Catalog：訊息串與輸入器（`Conversation`）
- 舊來源：[`lib/src/features/collections/message_thread/internal/klp_message_thread_widget.dart`](../../lib/src/features/collections/message_thread/internal/klp_message_thread_widget.dart)

### `KlpPresenceIndicator`

- Consumer intent：呈現參與者目前在線、離開或活動狀態。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「呈現參與者目前在線、離開或活動狀態」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-FEEDBACK`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/foundation/interaction/filter/internal/klp_presence_indicator_widget.dart`](../../lib/src/foundation/interaction/filter/internal/klp_presence_indicator_widget.dart)


## 畫布、圖解與手寫 (`CAT-CANVAS`) — 8

### `KlpCanvasDropIntent`

- Consumer intent：在空間畫布上回饋拖放目標與預定動作。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「在空間畫布上回饋拖放目標與預定動作」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-SYSTEM`
- 舊 Catalog：Screen and Flow canvas chrome（`Canvas workspace`）
- 舊來源：[`lib/src/features/infinite_canvas/internal/klp_canvas_drop_intent.dart`](../../lib/src/features/infinite_canvas/internal/klp_canvas_drop_intent.dart)

### `KlpCanvasMinimap`

- Consumer intent：以縮圖概覽大型空間畫布並協助定位。
- Role：`consumer-capability`
- Composition level：`element`
- Composition rationale：「以縮圖概覽大型空間畫布並協助定位」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-NAV`
- 舊 Catalog：Screen and Flow canvas chrome（`Canvas workspace`）
- 舊來源：[`lib/src/features/infinite_canvas/internal/klp_canvas_minimap.dart`](../../lib/src/features/infinite_canvas/internal/klp_canvas_minimap.dart)

### `KlpCanvasSelectionOverlay`

- Consumer intent：在空間畫布上標示目前選取範圍與控制點。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「在空間畫布上標示目前選取範圍與控制點」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-SYSTEM`
- 舊 Catalog：Screen and Flow canvas chrome（`Canvas workspace`）
- 舊來源：[`lib/src/features/infinite_canvas/internal/klp_canvas_selection_overlay.dart`](../../lib/src/features/infinite_canvas/internal/klp_canvas_selection_overlay.dart)

### `KlpCanvasToolbar`

- Consumer intent：提供空間畫布目前可用的工具與操作。
- Role：`composition-part`
- Composition level：`container`
- Composition rationale：「提供空間畫布目前可用的工具與操作」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-ACTION`
- 舊 Catalog：Screen and Flow canvas chrome（`Canvas workspace`）
- 舊來源：[`lib/src/features/infinite_canvas/internal/klp_canvas_toolbar.dart`](../../lib/src/features/infinite_canvas/internal/klp_canvas_toolbar.dart)

### `KlpCanvasViewport`

- Consumer intent：承載可平移與縮放的空間畫布內容。
- Role：`consumer-capability`
- Composition level：`container`
- Composition rationale：「承載可平移與縮放的空間畫布內容」需要獨立功能邊界，接收不可變projection並以單一intent回報操作，內部只投影自身element data。
- Secondary：`CAT-LAYOUT`
- 舊 Catalog：Screen and Flow canvas chrome（`Canvas workspace`）
- 舊來源：[`lib/src/features/infinite_canvas/internal/klp_canvas_viewport.dart`](../../lib/src/features/infinite_canvas/internal/klp_canvas_viewport.dart)

### `KlpFlowNodeCard`

- Consumer intent：在流程畫布上呈現一個可辨識的節點。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「在流程畫布上呈現一個可辨識的節點」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-DATA`
- 舊 Catalog：Screen and Flow canvas chrome（`Canvas workspace`）
- 舊來源：[`lib/src/features/infinite_canvas/internal/klp_flow_node_card.dart`](../../lib/src/features/infinite_canvas/internal/klp_flow_node_card.dart)

### `KlpFlowValidationPanel`

- Consumer intent：呈現流程畫布目前的結構問題與修正線索。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「呈現流程畫布目前的結構問題與修正線索」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-FEEDBACK`
- 舊 Catalog：Screen and Flow canvas chrome（`Canvas workspace`）
- 舊來源：[`lib/src/features/infinite_canvas/internal/klp_flow_validation_panel.dart`](../../lib/src/features/infinite_canvas/internal/klp_flow_validation_panel.dart)

### `KlpLayoutLens`

- Consumer intent：在空間畫布上檢查節點的布局關係。
- Role：`catalog-artifact`
- Composition level：`none`
- Composition rationale：「在空間畫布上檢查節點的布局關係」只供Catalog檢查契約，不參與consumer runtime composition。
- Secondary：`CAT-LAYOUT`、`CAT-VISUAL`
- 舊 Catalog：Screen and Flow canvas chrome（`Canvas workspace`）
- 舊來源：[`lib/src/features/infinite_canvas/internal/klp_layout_lens.dart`](../../lib/src/features/infinite_canvas/internal/klp_layout_lens.dart)


## 圖表與資料視覺化 (`CAT-CHART`) — 0

固定 254 項目前沒有此分類；這是完整能力地平線中的已知缺口。

## 無障礙、輸入與平台適應 (`CAT-SYSTEM`) — 19

### `KlpAccessibilityContractPanel`

- Consumer intent：檢查一項設計能力的無障礙要求與支援狀態。
- Role：`catalog-artifact`
- Composition level：`none`
- Composition rationale：「檢查一項設計能力的無障礙要求與支援狀態」只供Catalog檢查契約，不參與consumer runtime composition。
- Secondary：`CAT-VISUAL`
- 舊 Catalog：Canonical artifacts（`Artifact workspace`）
- 舊來源：[`lib/src/features/workspace/artifact/internal/klp_accessibility_contract_panel.dart`](../../lib/src/features/workspace/artifact/internal/klp_accessibility_contract_panel.dart)

### `KlpAdaptive`

- Consumer intent：依宿主平台與裝置環境選用已核准的結構策略。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「依宿主平台與裝置環境選用已核准的結構策略」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-LAYOUT`
- 舊 Catalog：Navigator Sidebar 組合（`Sidebar Shell`）
- 舊來源：[`lib/src/foundation/layout/klp_adaptive.dart`](../../lib/src/foundation/layout/klp_adaptive.dart)

### `KlpDragPreview`

- Consumer intent：在拖曳期間呈現目前搬移內容的預覽。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「在拖曳期間呈現目前搬移內容的預覽」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-VISUAL`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/foundation/interaction/klp_drag_drop.dart`](../../lib/src/foundation/interaction/klp_drag_drop.dart)

### `KlpDropIndicator`

- Consumer intent：在拖曳期間標示即將插入或放置的位置。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「在拖曳期間標示即將插入或放置的位置」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-VISUAL`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/foundation/interaction/klp_drag_drop.dart`](../../lib/src/foundation/interaction/klp_drag_drop.dart)

### `KlpDropTarget`

- Consumer intent：讓受控區域接收拖放輸入並回報語意事件。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「讓受控區域接收拖放輸入並回報語意事件」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-ACTION`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/foundation/interaction/klp_drag_drop.dart`](../../lib/src/foundation/interaction/klp_drag_drop.dart)

### `KlpExcludeSemantics`

- Consumer intent：避免重複或裝飾性內容進入輔助語意樹。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「避免重複或裝飾性內容進入輔助語意樹」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：無
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/foundation/interaction/klp_exclude_semantics.dart`](../../lib/src/foundation/interaction/klp_exclude_semantics.dart)

### `KlpFocusBoundary`

- Consumer intent：限制鍵盤焦點在一個受控互動範圍內移動。
- Role：`system-contract`
- Composition level：`none`
- Composition rationale：「限制鍵盤焦點在一個受控互動範圍內移動」屬Kallopis安裝的跨切面宿主或互動契約，不是consumer可放置的結構。
- Secondary：無
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/features/feedback/workflow/klp_focus_boundary.dart`](../../lib/src/features/feedback/workflow/klp_focus_boundary.dart)

### `KlpFocusRegion`

- Consumer intent：為一組互動內容建立可辨識的焦點區域。
- Role：`system-contract`
- Composition level：`none`
- Composition rationale：「為一組互動內容建立可辨識的焦點區域」屬Kallopis安裝的跨切面宿主或互動契約，不是consumer可放置的結構。
- Secondary：無
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/foundation/interaction/klp_focus_region.dart`](../../lib/src/foundation/interaction/klp_focus_region.dart)

### `KlpGestureRegion`

- Consumer intent：讓既有區域接收舊版指標與手勢輸入。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「讓既有區域接收舊版指標與手勢輸入」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-ACTION`
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/foundation/interaction/klp_gesture_region.dart`](../../lib/src/foundation/interaction/klp_gesture_region.dart)

### `KlpKeyBindingHost`

- Consumer intent：在指定範圍安裝並管理鍵盤命令對應。
- Role：`system-contract`
- Composition level：`none`
- Composition rationale：「在指定範圍安裝並管理鍵盤命令對應」屬Kallopis安裝的跨切面宿主或互動契約，不是consumer可放置的結構。
- Secondary：`CAT-ACTION`
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/foundation/interaction/keybinding/klp_key_binding_controller.dart`](../../lib/src/foundation/interaction/keybinding/klp_key_binding_controller.dart)

### `KlpKeyBindingRegion`

- Consumer intent：為局部互動區域限定可用鍵盤命令。
- Role：`system-contract`
- Composition level：`none`
- Composition rationale：「為局部互動區域限定可用鍵盤命令」屬Kallopis安裝的跨切面宿主或互動契約，不是consumer可放置的結構。
- Secondary：`CAT-ACTION`
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/foundation/interaction/keybinding/klp_key_binding_region.dart`](../../lib/src/foundation/interaction/keybinding/klp_key_binding_region.dart)

### `KlpLiveRegion`

- Consumer intent：向輔助技術宣告內容狀態的即時變化。
- Role：`system-contract`
- Composition level：`none`
- Composition rationale：「向輔助技術宣告內容狀態的即時變化」屬Kallopis安裝的跨切面宿主或互動契約，不是consumer可放置的結構。
- Secondary：`CAT-FEEDBACK`
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/features/feedback/klp_live_region.dart`](../../lib/src/features/feedback/klp_live_region.dart)

### `KlpPointerBlocker`

- Consumer intent：在指定狀態阻止指標輸入到達後方內容。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「在指定狀態阻止指標輸入到達後方內容」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-OVERLAY`
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/foundation/interaction/primitives/klp_pointer_blocker.dart`](../../lib/src/foundation/interaction/primitives/klp_pointer_blocker.dart)

### `KlpPressable`

- Consumer intent：讓內容區域具備一致的按壓、焦點與啟用狀態。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「讓內容區域具備一致的按壓、焦點與啟用狀態」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-ACTION`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/foundation/interaction/klp_pressable.dart`](../../lib/src/foundation/interaction/klp_pressable.dart)

### `KlpSemanticRegion`

- Consumer intent：為一段內容建立可被輔助技術辨識的語意區域。
- Role：`system-contract`
- Composition level：`none`
- Composition rationale：「為一段內容建立可被輔助技術辨識的語意區域」屬Kallopis安裝的跨切面宿主或互動契約，不是consumer可放置的結構。
- Secondary：無
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/foundation/interaction/klp_semantic_region.dart`](../../lib/src/foundation/interaction/klp_semantic_region.dart)

### `KlpShortcutHint`

- Consumer intent：在操作旁顯示可用的鍵盤快捷方式。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「在操作旁顯示可用的鍵盤快捷方式」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-ACTION`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/foundation/interaction/filter/internal/klp_shortcut_hint_widget.dart`](../../lib/src/foundation/interaction/filter/internal/klp_shortcut_hint_widget.dart)

### `KlpStateHighlight`

- Consumer intent：以一致視覺回饋呈現 hover、選取或焦點狀態。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「以一致視覺回饋呈現 hover、選取或焦點狀態」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-VISUAL`
- 舊 Catalog：版面與互動（`Layout & Interaction`）
- 舊來源：[`lib/src/foundation/interaction/klp_state_highlight.dart`](../../lib/src/foundation/interaction/klp_state_highlight.dart)

### `KlpWindowHeaderMacLayout`

- Consumer intent：依 macOS 規則排列舊版視窗標題與控制。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「依 macOS 規則排列舊版視窗標題與控制」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-APP`、`CAT-LAYOUT`
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/features/workspace/shell/window/klp_window_header_mac_layout.dart`](../../lib/src/features/workspace/shell/window/klp_window_header_mac_layout.dart)

### `KlpWindowHeaderWindowsLayout`

- Consumer intent：依 Windows 規則排列舊版視窗標題與控制。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「依 Windows 規則排列舊版視窗標題與控制」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-APP`、`CAT-LAYOUT`
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/features/workspace/shell/window/klp_window_header_windows_layout.dart`](../../lib/src/features/workspace/shell/window/klp_window_header_windows_layout.dart)


## 視覺語言與體驗 (`CAT-VISUAL`) — 17

### `KlpComponentDefinitionCard`

- Consumer intent：在設計目錄中檢查一項能力的定義摘要。
- Role：`catalog-artifact`
- Composition level：`none`
- Composition rationale：「在設計目錄中檢查一項能力的定義摘要」只供Catalog檢查契約，不參與consumer runtime composition。
- Secondary：無
- 舊 Catalog：Canonical artifacts（`Artifact workspace`）
- 舊來源：[`lib/src/features/workspace/artifact/internal/klp_component_definition_card.dart`](../../lib/src/features/workspace/artifact/internal/klp_component_definition_card.dart)

### `KlpComponentLibraryGrid`

- Consumer intent：在設計目錄中瀏覽多項能力定義。
- Role：`catalog-artifact`
- Composition level：`none`
- Composition rationale：「在設計目錄中瀏覽多項能力定義」只供Catalog檢查契約，不參與consumer runtime composition。
- Secondary：`CAT-DATA`
- 舊 Catalog：Canonical artifacts（`Artifact workspace`）
- 舊來源：[`lib/src/features/workspace/artifact/internal/klp_component_library_grid.dart`](../../lib/src/features/workspace/artifact/internal/klp_component_library_grid.dart)

### `KlpComponentStateSelector`

- Consumer intent：在設計目錄中切換要檢查的互動狀態。
- Role：`catalog-artifact`
- Composition level：`none`
- Composition rationale：「在設計目錄中切換要檢查的互動狀態」只供Catalog檢查契約，不參與consumer runtime composition。
- Secondary：`CAT-ACTION`
- 舊 Catalog：Canonical artifacts（`Artifact workspace`）
- 舊來源：[`lib/src/features/workspace/artifact/internal/klp_component_state_selector.dart`](../../lib/src/features/workspace/artifact/internal/klp_component_state_selector.dart)

### `KlpDashedBorder`

- Consumer intent：以虛線邊界表達指定的視覺分隔語意。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「以虛線邊界表達指定的視覺分隔語意」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-LAYOUT`
- 舊 Catalog：線條語言（`Stroke Language`）
- 舊來源：[`lib/src/foundation/surface/klp_dashed_border.dart`](../../lib/src/foundation/surface/klp_dashed_border.dart)

### `KlpDashedDivider`

- Consumer intent：以虛線在相鄰內容之間建立視覺分隔。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「以虛線在相鄰內容之間建立視覺分隔」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-LAYOUT`
- 舊 Catalog：線條語言（`Stroke Language`）
- 舊來源：[`lib/src/foundation/surface/klp_dashed_border.dart`](../../lib/src/foundation/surface/klp_dashed_border.dart)

### `KlpDivider`

- Consumer intent：在相鄰內容之間呈現標準分隔語意。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「在相鄰內容之間呈現標準分隔語意」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-LAYOUT`
- 舊 Catalog：線條語言（`Stroke Language`）
- 舊來源：[`lib/src/foundation/surface/klp_divider.dart`](../../lib/src/foundation/surface/klp_divider.dart)

### `KlpIcon`

- Consumer intent：以封閉圖示語意輔助辨識資料或操作。
- Role：`composition-part`
- Composition level：`element`
- Composition rationale：「以封閉圖示語意輔助辨識資料或操作」是功能container內的語意資料原子，不承載KLP結構child或renderer。
- Secondary：`CAT-ACTION`、`CAT-DATA`
- 舊 Catalog：資料呈現（`Data Display`）
- 舊來源：[`lib/src/foundation/klp_icon.dart`](../../lib/src/foundation/klp_icon.dart)

### `KlpOklchColorEditor`

- Consumer intent：以多個通道精確編輯感知一致的色彩值。
- Role：`catalog-artifact`
- Composition level：`none`
- Composition rationale：「以多個通道精確編輯感知一致的色彩值」只供Catalog檢查契約，不參與consumer runtime composition。
- Secondary：`CAT-FORM`
- 舊 Catalog：品牌色（`Brand`）
- 舊來源：[`lib/src/features/forms/color/internal/klp_oklch_color_editor_widget.dart`](../../lib/src/features/forms/color/internal/klp_oklch_color_editor_widget.dart)

### `KlpOklchColorPicker`

- Consumer intent：在感知一致色彩空間中挑選色彩值。
- Role：`catalog-artifact`
- Composition level：`none`
- Composition rationale：「在感知一致色彩空間中挑選色彩值」只供Catalog檢查契約，不參與consumer runtime composition。
- Secondary：`CAT-FORM`
- 舊 Catalog：品牌色（`Brand`）
- 舊來源：[`lib/src/features/forms/color/internal/klp_oklch_color_picker_widget.dart`](../../lib/src/features/forms/color/internal/klp_oklch_color_picker_widget.dart)

### `KlpPageBackground`

- Consumer intent：為整頁內容提供舊版標準背景表面。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「為整頁內容提供舊版標準背景表面」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-LAYOUT`
- 舊 Catalog：相容層基礎建構塊（`Compatibility building blocks`）
- 舊來源：[`lib/src/foundation/surface/page_background/klp_page_background.dart`](../../lib/src/foundation/surface/page_background/klp_page_background.dart)

### `KlpStatusRoleSwatches`

- Consumer intent：瀏覽並選取核准的語意狀態色角色。
- Role：`catalog-artifact`
- Composition level：`none`
- Composition rationale：「瀏覽並選取核准的語意狀態色角色」只供Catalog檢查契約，不參與consumer runtime composition。
- Secondary：`CAT-FORM`
- 舊 Catalog：表單控制項（`Form Controls`）
- 舊來源：[`lib/src/features/forms/selection/klp_status_role_swatches.dart`](../../lib/src/features/forms/selection/klp_status_role_swatches.dart)

### `KlpStrokeFrame`

- Consumer intent：以核准線條語言建立內容邊界。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「以核准線條語言建立內容邊界」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-LAYOUT`
- 舊 Catalog：線條語言（`Stroke Language`）
- 舊來源：[`lib/src/foundation/surface/klp_stroke.dart`](../../lib/src/foundation/surface/klp_stroke.dart)

### `KlpSurface`

- Consumer intent：以舊版表面語意承載一段內容。
- Role：`implementation-material`
- Composition level：`internal`
- Composition rationale：「以舊版表面語意承載一段內容」只描述排列、表面、狀態呈現或renderer技術，必須由Kallopis內部使用。
- Secondary：`CAT-LAYOUT`
- 舊 Catalog：區塊與主題（`Block Layout & Theme`）
- 舊來源：[`lib/src/foundation/surface/klp_surface.dart`](../../lib/src/foundation/surface/klp_surface.dart)

### `KlpThemePreviewTile`

- Consumer intent：在套用前預覽一組視覺主題。
- Role：`catalog-artifact`
- Composition level：`none`
- Composition rationale：「在套用前預覽一組視覺主題」只供Catalog檢查契約，不參與consumer runtime composition。
- Secondary：`CAT-SETTINGS`
- 舊 Catalog：區塊與主題（`Block Layout & Theme`）
- 舊來源：[`lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart`](../../lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart)

### `KlpTokenOverride`

- Consumer intent：在設計檢查情境中比較暫時替換的視覺原料。
- Role：`catalog-artifact`
- Composition level：`none`
- Composition rationale：「在設計檢查情境中比較暫時替換的視覺原料」只供Catalog檢查契約，不參與consumer runtime composition。
- Secondary：無
- 舊 Catalog：區塊與主題（`Block Layout & Theme`）
- 舊來源：[`lib/src/styling/legacy_theme/klp_theme_scope.dart`](../../lib/src/styling/legacy_theme/klp_theme_scope.dart)

### `KlpTokenTable`

- Consumer intent：在設計目錄中檢查視覺原料名稱與值。
- Role：`catalog-artifact`
- Composition level：`none`
- Composition rationale：「在設計目錄中檢查視覺原料名稱與值」只供Catalog檢查契約，不參與consumer runtime composition。
- Secondary：`CAT-DATA`
- 舊 Catalog：Canonical artifacts（`Artifact workspace`）
- 舊來源：[`lib/src/features/workspace/artifact/internal/klp_token_table.dart`](../../lib/src/features/workspace/artifact/internal/klp_token_table.dart)

### `KlpTokenValidationBanner`

- Consumer intent：在設計目錄中回報視覺原料驗證結果。
- Role：`catalog-artifact`
- Composition level：`none`
- Composition rationale：「在設計目錄中回報視覺原料驗證結果」只供Catalog檢查契約，不參與consumer runtime composition。
- Secondary：`CAT-FEEDBACK`
- 舊 Catalog：Canonical artifacts（`Artifact workspace`）
- 舊來源：[`lib/src/features/workspace/artifact/internal/klp_token_validation_banner.dart`](../../lib/src/features/workspace/artifact/internal/klp_token_validation_banner.dart)

