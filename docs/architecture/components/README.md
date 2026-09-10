# Kallopis 元件樹架構全覽

> 本目錄遵循 `/focused-architecture-diagram` 規範，精確繪製 Kallopis 全部 260 個 Widget 元件之內部組成架構。

## 架構分層與展開規範

1. **同構分類**：嚴格對齊 `lib/src/` 的領域目錄分層。
2. **原生原語展開**：Flutter 原生元件（如 `Container`, `Row`, `Column`, `Padding`, `Material` 等）持續向下繪製到底。
3. **純容器中繼**：`KlpSurface`、`KlpStrokeFrame`、`KlpRegion` 等純容器型別不中斷，持續展開其內部 child。
4. **跨元件引用邊界**：遇到本專案之其他功能性元件（如 `KlpButton`, `KlpTextField`, `KlpIcon`, `KlpText` 等）即刻停步，標記為 `:::reference` 節點並提供超連結引用。

## 領域分類索引

- [foundation — 圖示、色盤、度量 (62)](#foundation)

<a id="foundation"></a>
### foundation — 圖示、色盤、度量 (62)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpActionRegion` | `Stateless` | 統一封裝按鈕語意、hover、focus 與可點擊表面的互動原語。 | [klp_action_region.md](./foundation/klp_action_region.md) |
| `KlpAdaptive` | `Stateless` | 依明確覆寫、[KlpEnvironmentScope] 或實際執行平台選擇呈現分支。  只處理平台差異，不依據視窗尺寸切換平台策略。分支內部可自行處理 該平台的空間限制。 | [klp_adaptive.md](./foundation/klp_adaptive.md) |
| `KlpAlign` | `Stateless` | 對齊排版原語。取代產品端直接使用 Align。 | [klp_align.md](./foundation/klp_align.md) |
| `KlpBox` | `Stateless` | 基礎尺寸與邊距容器排版原語。取代 Container 與 SizedBox。 支援風格介面、風格枚舉（KlpSpaceSize）與傳統尺寸邊距設定。 | [klp_box.md](./foundation/klp_box.md) |
| `KlpCenter` | `Stateless` | 置中排版原語。取代 Center。 | [klp_center.md](./foundation/klp_center.md) |
| `KlpColumn` | `Stateless` | 垂直排列排版原語。取代 Column，支援自動間距設定。 | [klp_column.md](./foundation/klp_column.md) |
| `KlpConstrainedBox` | `Stateless` | 套用型別化幾何限制的基礎排版原語。 | [klp_constrained_box.md](./foundation/klp_constrained_box.md) |
| `KlpDashedBorder` | `Stateless` | 虛線邊框容器。為子元件提供自訂粗細、圓角、顏色與虛線間距的虛線外框。  預設使用 theme 的 [KlpShapeTheme.dashedOpacity] 輔助線顏色與 [KlpShapeTheme.control] 圓角。 | [klp_dashed_border.md](./foundation/klp_dashed_border.md) |
| `KlpDashedDivider` | `Stateless` | 虛線分隔線。支援水平與垂直兩種方向，以及自訂線寬、顏色與虛線間距。  預設使用 theme 的 [KlpShapeTheme.hairline] 粗細與 [KlpShapeTheme.dashedOpacity] 輔助線顏色。 | [klp_dashed_divider.md](./foundation/klp_dashed_divider.md) |
| `KlpDirectionalPositioned` | `Stateless` | 依文字方向解析 start／end 的定位排版原語。 | [klp_directional_positioned.md](./foundation/klp_directional_positioned.md) |
| `KlpDivider` | `Stateless` | Kallopis KlpDivider 元件 | [klp_divider.md](./foundation/klp_divider.md) |
| `KlpDragPreview` | `Stateless` | Kallopis KlpDragPreview 元件 | [klp_drag_preview.md](./foundation/klp_drag_preview.md) |
| `KlpDropIndicator` | `Stateless` | Kallopis KlpDropIndicator 元件 | [klp_drop_indicator.md](./foundation/klp_drop_indicator.md) |
| `KlpDropTarget` | `Stateless` | Kallopis KlpDropTarget 元件 | [klp_drop_target.md](./foundation/klp_drop_target.md) |
| `KlpEnvironmentScope` | `Stateless` | 注入執行平台；視窗尺寸、語系與互動狀態仍由各自的來源提供。 | [klp_environment_scope.md](./foundation/klp_environment_scope.md) |
| `KlpExcludeSemantics` | `Stateless` | 將純裝飾內容排除於語意樹之外。 | [klp_exclude_semantics.md](./foundation/klp_exclude_semantics.md) |
| `KlpExpanded` | `Stateless` | 彈性延伸排版原語。取代 Expanded。 | [klp_expanded.md](./foundation/klp_expanded.md) |
| `KlpFilterBar` | `Stateless` | 篩選工具列。支援標籤、鍵值對、移除按鈕與新增篩選動作。 | [klp_filter_bar.md](./foundation/klp_filter_bar.md) |
| `KlpFit` | `Stateless` | 依型別化縮放策略調整子元件尺寸的排版原語。 | [klp_fit.md](./foundation/klp_fit.md) |
| `KlpFlexible` | `Stateless` | 彈性調整排版原語。取代 Flexible。 | [klp_flexible.md](./foundation/klp_flexible.md) |
| `KlpFocusRegion` | `Stateless` | 集中鍵盤焦點與按鍵事件的基礎互動原語。 | [klp_focus_region.md](./foundation/klp_focus_region.md) |
| `KlpGap` | `Stateless` | 間距排版原語。取代 SizedBox 進行彈性與固定距離佔位。 支援風格介面與風格枚舉（KlpSpaceSize）為第一優先真相。 | [klp_gap.md](./foundation/klp_gap.md) |
| `KlpGeometricSpinner` | `Stateful` | 幾何圖案載入動畫。  由四個對稱的小方塊圍繞中心旋轉，並伴隨對比色進行平滑色彩動畫， 適合用於載入狀態、資料請求或背景處理中指示。 | [klp_geometric_spinner.md](./foundation/klp_geometric_spinner.md) |
| `KlpGestureRegion` | `Stateless` | 將產品事件接線隔離於 Kallopis 互動邊界內。 | [klp_gesture_region.md](./foundation/klp_gesture_region.md) |
| `KlpIcon` | `Stateless` | Kallopis KlpIcon 元件 | [klp_icon.md](./foundation/klp_icon.md) |
| `KlpInlineCode` | `Stateless` | 行內程式碼片段。帶有圓角背景與等寬字體，適合在段落文字中呈現指令、變數或路徑。 | [klp_inline_code.md](./foundation/klp_inline_code.md) |
| `KlpInteractionSettings` | `Stateless` | 長按門檻的區域覆寫。  門檻的**預設值來自 theme**（`KlpMotionTheme.longPressThreshold`），這個 InheritedWidget 只負責「某一小塊 UI 要用不一樣的門檻」。原本它自己持有一份 `defaultThreshold` 常數， 與 theme 構成同一條規則的兩份實作——兩份實作必然靜默分岔，改了 theme 卻沒改這裡時 不會有任何錯誤，只是門檻沒變。 | [klp_interaction_settings.md](./foundation/klp_interaction_settings.md) |
| `KlpKeyBindingHost` | `Stateless` | 將 controller 的目前 scope 接到 Flutter Shortcuts／Actions。 | [klp_key_binding_host.md](./foundation/klp_key_binding_host.md) |
| `KlpKeyBindingRegion` | `Stateless` | 宣告一個可成為快捷鍵 active scope 的畫面區域。 | [klp_key_binding_region.md](./foundation/klp_key_binding_region.md) |
| `KlpLayoutBuilder` | `Stateless` | 將 Flutter constraint 建構邊界集中於排版原語層。 | [klp_layout_builder.md](./foundation/klp_layout_builder.md) |
| `KlpMasonryGrid` | `Stateless` | 將高度不同的內容依序分配到多欄的瀑布流版面。 | [klp_masonry_grid.md](./foundation/klp_masonry_grid.md) |
| `KlpOverlayHost` | `Stateless` | 浮層容器掛載點。 | [klp_overlay_host.md](./foundation/klp_overlay_host.md) |
| `KlpPageBackgroundEditor` | `Stateful` | 編輯受限 point／line 背景 recipe 的受控視覺元件。 | [klp_page_background_editor.md](./foundation/klp_page_background_editor.md) |
| `KlpPageBackgroundPainter` | `Stateless` | 所有頁面背景 recipe 共用的 renderer。 | [klp_page_background_painter.md](./foundation/klp_page_background_painter.md) |
| `KlpPointerBlocker` | `Stateless` | 阻擋子樹指標事件、但保留其布局與繪製的基礎互動原語。 | [klp_pointer_blocker.md](./foundation/klp_pointer_blocker.md) |
| `KlpPositioned` | `Stateless` | 絕對/相對定位排版原語。取代 Positioned。 | [klp_positioned.md](./foundation/klp_positioned.md) |
| `KlpPresenceIndicator` | `Stateless` | 協作者在線／連線狀態標記。 | [klp_presence_indicator.md](./foundation/klp_presence_indicator.md) |
| `KlpPressable` | `Stateful` | 可按壓表面的 hover／focus 視覺。 | [klp_pressable.md](./foundation/klp_pressable.md) |
| `KlpRegion` | `Stateless` | 區域容器。包裝標題、主要內容與頁尾。 | [klp_region.md](./foundation/klp_region.md) |
| `KlpResizablePane` | `Stateless` | 寬度可調節面板容器。 | [klp_resizable_pane.md](./foundation/klp_resizable_pane.md) |
| `KlpResizeHandle` | `Stateless` | 拖曳調整水平或垂直尺寸的把手。 | [klp_resize_handle.md](./foundation/klp_resize_handle.md) |
| `KlpRichText` | `Stateless` | 行內混排文字：連結、mention、粗斜體、行內程式碼可以出現在同一段落裡。  [spans] 與 [nodes] 是兩種不同精細度的輸入，二擇一——給了 [nodes]（非空） 就完全忽略 [spans]；只需要簡單加粗／換色時用 [spans] 即可，不需要為此 組出完整的節點樹。[onOpenLink]／[onOpenMention] 為 null 時，對應的連結與 mention 仍會照樣顯示，只是不可點擊。 | [klp_rich_text.md](./foundation/klp_rich_text.md) |
| `KlpRotate` | `Stateless` | 只接受型別化直角方向的旋轉排版原語。 | [klp_rotate.md](./foundation/klp_rotate.md) |
| `KlpRow` | `Stateless` | 水平排列排版原語。取代 Row，支援自動間距設定。 | [klp_row.md](./foundation/klp_row.md) |
| `KlpScrollViewport` | `Stateless` | 具備主題捲軸樣式的單向捲動容器。 | [klp_scroll_viewport.md](./foundation/klp_scroll_viewport.md) |
| `KlpSection` | `Stateless` | 帶標題的內容分段。`label` 是標題上方的小型分類文字。 | [klp_section.md](./foundation/klp_section.md) |
| `KlpSegmentedProgress` | `Stateless` | Kallopis KlpSegmentedProgress 元件 | [klp_segmented_progress.md](./foundation/klp_segmented_progress.md) |
| `KlpSelectionToolbar` | `Stateless` | 批次選取浮動／固定操作列。 | [klp_selection_toolbar.md](./foundation/klp_selection_toolbar.md) |
| `KlpSemanticRegion` | `Stateless` | 將一般內容群組的可及性語意限制在基礎互動原語。 | [klp_semantic_region.md](./foundation/klp_semantic_region.md) |
| `KlpShortcutHint` | `Stateless` | 鍵盤快捷鍵提示標籤。 | [klp_shortcut_hint.md](./foundation/klp_shortcut_hint.md) |
| `KlpSpacer` | `Stateless` | 彈性留白排版原語。取代 Spacer。 | [klp_spacer.md](./foundation/klp_spacer.md) |
| `KlpSplitLayout` | `Stateless` | 分割版面元件。支援左／中／右或左右分割，以及虛線分隔線。 | [klp_split_layout.md](./foundation/klp_split_layout.md) |
| `KlpStack` | `Stateless` | 重疊排列排版原語。取代 Stack。 | [klp_stack.md](./foundation/klp_stack.md) |
| `KlpStateHighlight` | `Stateless` | 疊在內容上的狀態高亮。  **hover 與 selected 一律以高亮色表達，不畫邊框。** 先前這兩個狀態在庫裡有兩套 語彙——`KlpPressable` 用高亮、表單與 explorer 用虛線框——同一件事兩種畫法， 消費者無從預期。  高亮以 [Stack] 疊在內容之上而不是換掉內容的底色：後者會逼每個元件自己知道 「我原本的底色是什麼、混上去之後該是什麼」，而那正是元件不該知道的事。 | [klp_state_highlight.md](./foundation/klp_state_highlight.md) |
| `KlpStrokeFrame` | `Stateless` | Kallopis KlpStrokeFrame 元件 | [klp_stroke_frame.md](./foundation/klp_stroke_frame.md) |
| `KlpSurface` | `Stateless` | 有底色的容器，是所有區塊的基底。`tone` 指定它在表面階層中的位置， 支援邊框、微漸層、外發光與霧化透明（毛玻璃）等多種原生 Box 視覺效果。 | [klp_surface.md](./foundation/klp_surface.md) |
| `KlpText` | `Stateless` | 以語意角色指定樣式的文字原語。 | [klp_text.md](./foundation/klp_text.md) |
| `KlpTranslate` | `Stateless` | 依型別化幾何介面平移內容的排版原語。 | [klp_translate.md](./foundation/klp_translate.md) |
| `KlpVeil` | `Stateless` | 以目前 surface 語意建立阻擋內容的半透明覆層。 | [klp_veil.md](./foundation/klp_veil.md) |
| `KlpVirtualGrid` | `Stateless` | 格狀虛擬化捲動檢視。 | [klp_virtual_grid.md](./foundation/klp_virtual_grid.md) |
| `KlpVirtualList` | `Stateless` | 長清單虛擬化捲動檢視。 | [klp_virtual_list.md](./foundation/klp_virtual_list.md) |
| `KlpWrap` | `Stateless` | 可換行排版原語。間距僅接受 Kallopis 語意尺寸。 | [klp_wrap.md](./foundation/klp_wrap.md) |
