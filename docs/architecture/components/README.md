# Kallopis 元件樹架構全覽

> 本目錄遵循 `/focused-architecture-diagram` 規範，繪製 Kallopis 所有元件之內部 Widget Tree 架構。

## 分類與規範原則

1. **同構分類**：嚴格依照 `lib/src/` 領域目錄進行分類。
2. **原生展開**：Flutter 原生元件（如 `Container`, `Row`, `Column`, `Padding`, `Material` 等）持續向下繪製到底。
3. **純容器中繼**：`KlpSurface`、`KlpStrokeFrame` 等純容器元件不中斷，持續展開其內部 child。
4. **引用停步**：遇到本專案之其他非純容器元件（如 `KlpButton`, `KlpTextField`, `KlpIcon` 等）即刻停下，並提供文件超連結引用。

## 領域分類索引

- [foundation — 圖示、色盤、度量 (14)](#foundation)
- [typography — 文字 (1)](#typography)
- [surface — 表面與描邊 (6)](#surface)
- [layout — 版面原語 (8)](#layout)
- [interaction — 互動 (6)](#interaction)
- [controls — 控制項 (12)](#controls)
- [form — 表單 (22)](#form)
- [data — 資料呈現 (13)](#data)
- [feedback — 狀態與回饋 (10)](#feedback)
- [overlay — 浮層 (5)](#overlay)
- [navigation — 導覽元件 (7)](#navigation)
- [editor — 編輯器周邊 (8)](#editor)
- [shell — 應用外殼 (12)](#shell)
- [routing — 分發 (2)](#routing)

<a id="foundation"></a>
### foundation — 圖示、色盤、度量 (14)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpAvatar` | `Stateless` | Kallopis KlpAvatar 元件 | [klp_avatar.md](./foundation/klp_avatar.md) |
| `KlpAvatarGroup` | `Stateless` | Kallopis KlpAvatarGroup 元件 | [klp_avatar_group.md](./foundation/klp_avatar_group.md) |
| `KlpBlock` | `Stateless` | Kallopis KlpBlock 元件 | [klp_block.md](./foundation/klp_block.md) |
| `KlpBlockCanvas` | `Stateless` | Kallopis KlpBlockCanvas 元件 | [klp_block_canvas.md](./foundation/klp_block_canvas.md) |
| `KlpDragPreview` | `Stateless` | Kallopis KlpDragPreview 元件 | [klp_drag_preview.md](./foundation/klp_drag_preview.md) |
| `KlpDropIndicator` | `Stateless` | Kallopis KlpDropIndicator 元件 | [klp_drop_indicator.md](./foundation/klp_drop_indicator.md) |
| `KlpDropTarget` | `Stateless` | Kallopis KlpDropTarget 元件 | [klp_drop_target.md](./foundation/klp_drop_target.md) |
| `KlpIcon` | `Stateless` | Kallopis KlpIcon 元件 | [klp_icon.md](./foundation/klp_icon.md) |
| `KlpPopover` | `Stateless` | Kallopis KlpPopover 元件 | [klp_popover.md](./foundation/klp_popover.md) |
| `KlpRichText` | `Stateless` | Kallopis KlpRichText 元件 | [klp_rich_text.md](./foundation/klp_rich_text.md) |
| `KlpSegmentedProgress` | `Stateless` | Kallopis KlpSegmentedProgress 元件 | [klp_segmented_progress.md](./foundation/klp_segmented_progress.md) |
| `KlpSortControl` | `Stateless` | Kallopis KlpSortControl 元件 | [klp_sort_control.md](./foundation/klp_sort_control.md) |
| `KlpStatusIndicator` | `Stateless` | Kallopis KlpStatusIndicator 元件 | [klp_status_indicator.md](./foundation/klp_status_indicator.md) |
| `KlpThemeToggle` | `Stateless` | Kallopis KlpThemeToggle 元件 | [klp_theme_toggle.md](./foundation/klp_theme_toggle.md) |

<a id="typography"></a>
### typography — 文字 (1)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpText` | `Stateless` | 文字。以**角色**指定樣式（`role`），不指定字級與字體——實際的字級、行高與 家族由 theme 的 typography 層決定，因此換風格時整體會一起變。 | [klp_text.md](./typography/klp_text.md) |

<a id="surface"></a>
### surface — 表面與描邊 (6)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpDashedBorder` | `Stateless` | Kallopis KlpDashedBorder 元件 | [klp_dashed_border.md](./surface/klp_dashed_border.md) |
| `KlpDashedDivider` | `Stateless` | Kallopis KlpDashedDivider 元件 | [klp_dashed_divider.md](./surface/klp_dashed_divider.md) |
| `KlpDivider` | `Stateless` | Kallopis KlpDivider 元件 | [klp_divider.md](./surface/klp_divider.md) |
| `KlpSection` | `Stateless` | 帶標題的內容分段。`label` 是標題上方的小型分類文字。 | [klp_section.md](./surface/klp_section.md) |
| `KlpStrokeFrame` | `Stateless` | Kallopis KlpStrokeFrame 元件 | [klp_stroke_frame.md](./surface/klp_stroke_frame.md) |
| `KlpSurface` | `Stateless` | 有底色的容器，是所有區塊的基底。`tone` 指定它在表面階層中的位置， 實際色值與圓角由 theme 決定。 | [klp_surface.md](./surface/klp_surface.md) |

<a id="layout"></a>
### layout — 版面原語 (8)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpOverlayHost` | `Stateless` | Kallopis KlpOverlayHost 元件 | [klp_overlay_host.md](./layout/klp_overlay_host.md) |
| `KlpRegion` | `Stateless` | Kallopis KlpRegion 元件 | [klp_region.md](./layout/klp_region.md) |
| `KlpResizablePane` | `Stateless` | Kallopis KlpResizablePane 元件 | [klp_resizable_pane.md](./layout/klp_resizable_pane.md) |
| `KlpResizeHandle` | `Stateless` | Kallopis KlpResizeHandle 元件 | [klp_resize_handle.md](./layout/klp_resize_handle.md) |
| `KlpScrollViewport` | `Stateless` | Kallopis KlpScrollViewport 元件 | [klp_scroll_viewport.md](./layout/klp_scroll_viewport.md) |
| `KlpSplitLayout` | `Stateless` | Kallopis KlpSplitLayout 元件 | [klp_split_layout.md](./layout/klp_split_layout.md) |
| `KlpVirtualGrid` | `Stateless` | Kallopis KlpVirtualGrid 元件 | [klp_virtual_grid.md](./layout/klp_virtual_grid.md) |
| `KlpVirtualList` | `Stateless` | Kallopis KlpVirtualList 元件 | [klp_virtual_list.md](./layout/klp_virtual_list.md) |

<a id="interaction"></a>
### interaction — 互動 (6)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpFilterBar` | `Stateless` | Kallopis KlpFilterBar 元件 | [klp_filter_bar.md](./interaction/klp_filter_bar.md) |
| `KlpInteractionSettings` | `Stateless` | 長按門檻的區域覆寫。  門檻的**預設值來自 theme**（`KlpMotionTheme.longPressThreshold`），這個 InheritedWidget 只負責「某一小塊 UI 要用不一樣的門檻」。原本它自己持有一份 `defaultThreshold` 常數， 與 theme 構成同一條規則的兩份實作——兩份實作必然靜默分岔，改了 theme 卻沒改這裡時 不會有任何錯誤，只是門檻沒變。 | [klp_interaction_settings.md](./interaction/klp_interaction_settings.md) |
| `KlpPresenceIndicator` | `Stateless` | Kallopis KlpPresenceIndicator 元件 | [klp_presence_indicator.md](./interaction/klp_presence_indicator.md) |
| `KlpPressable` | `Stateful` | Kallopis KlpPressable 元件 | [klp_pressable.md](./interaction/klp_pressable.md) |
| `KlpSelectionToolbar` | `Stateless` | Kallopis KlpSelectionToolbar 元件 | [klp_selection_toolbar.md](./interaction/klp_selection_toolbar.md) |
| `KlpShortcutHint` | `Stateless` | Kallopis KlpShortcutHint 元件 | [klp_shortcut_hint.md](./interaction/klp_shortcut_hint.md) |

<a id="controls"></a>
### controls — 控制項 (12)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpButton` | `Stateful` | 主要動作按鈕。`tone` 決定語意強度（primary／secondary／ghost／danger）， 圓角、內距、高度與邊框皆取自 theme。 | [klp_button.md](./controls/klp_button.md) |
| `KlpCheckbox` | `Stateless` | Kallopis KlpCheckbox 元件 | [klp_checkbox.md](./controls/klp_checkbox.md) |
| `KlpCompactSwitch` | `Stateless` | Kallopis KlpCompactSwitch 元件 | [klp_compact_switch.md](./controls/klp_compact_switch.md) |
| `KlpIconButton` | `Stateful` | 只有圖示的按鈕。`label` 為必填且用於無障礙標註——圖示本身沒有可讀文字， 沒有 label 的圖示按鈕對螢幕閱讀器等於不存在。 | [klp_icon_button.md](./controls/klp_icon_button.md) |
| `KlpSegmentedControl` | `Stateless` | Kallopis KlpSegmentedControl 元件 | [klp_segmented_control.md](./controls/klp_segmented_control.md) |
| `KlpSelect` | `Stateful` | 下拉選擇的觸發器。**它只負責顯示目前的值與觸發 `onPressed`**，選單本身由呼叫端 以 `KlpMenu` 開啟——選項來源是產品資料，不屬於視覺層。 | [klp_select.md](./controls/klp_select.md) |
| `KlpSlider` | `Stateless` | Kallopis KlpSlider 元件 | [klp_slider.md](./controls/klp_slider.md) |
| `KlpSlidingSelection` | `Stateless` | Kallopis KlpSlidingSelection 元件 | [klp_sliding_selection.md](./controls/klp_sliding_selection.md) |
| `KlpTextField` | `Stateless` | 單行或多行文字輸入。內部使用 `TextFormField`，所需的 `Material` 祖先由本元件 自行提供，消費者不需要另外包一層。 | [klp_text_field.md](./controls/klp_text_field.md) |
| `KlpToggle` | `Stateless` | Kallopis KlpToggle 元件 | [klp_toggle.md](./controls/klp_toggle.md) |
| `KlpToggleIndicator` | `Stateless` | Kallopis KlpToggleIndicator 元件 | [klp_toggle_indicator.md](./controls/klp_toggle_indicator.md) |
| `KlpTriStateToggle` | `Stateless` | Kallopis KlpTriStateToggle 元件 | [klp_tri_state_toggle.md](./controls/klp_tri_state_toggle.md) |

<a id="form"></a>
### form — 表單 (22)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpCodeField` | `Stateless` | Kallopis KlpCodeField 元件 | [klp_code_field.md](./form/klp_code_field.md) |
| `KlpColorRoleField` | `Stateless` | Kallopis KlpColorRoleField 元件 | [klp_color_role_field.md](./form/klp_color_role_field.md) |
| `KlpConditionalFieldRegion` | `Stateless` | Kallopis KlpConditionalFieldRegion 元件 | [klp_conditional_field_region.md](./form/klp_conditional_field_region.md) |
| `KlpDateField` | `Stateless` | Kallopis KlpDateField 元件 | [klp_date_field.md](./form/klp_date_field.md) |
| `KlpField` | `Stateless` | Kallopis KlpField 元件 | [klp_field.md](./form/klp_field.md) |
| `KlpFieldDescription` | `Stateless` | Kallopis KlpFieldDescription 元件 | [klp_field_description.md](./form/klp_field_description.md) |
| `KlpFieldError` | `Stateless` | Kallopis KlpFieldError 元件 | [klp_field_error.md](./form/klp_field_error.md) |
| `KlpFieldGroup` | `Stateless` | Kallopis KlpFieldGroup 元件 | [klp_field_group.md](./form/klp_field_group.md) |
| `KlpFieldLabel` | `Stateless` | Kallopis KlpFieldLabel 元件 | [klp_field_label.md](./form/klp_field_label.md) |
| `KlpFileField` | `Stateless` | Kallopis KlpFileField 元件 | [klp_file_field.md](./form/klp_file_field.md) |
| `KlpForm` | `Stateless` | Kallopis KlpForm 元件 | [klp_form.md](./form/klp_form.md) |
| `KlpFormActions` | `Stateless` | Kallopis KlpFormActions 元件 | [klp_form_actions.md](./form/klp_form_actions.md) |
| `KlpFormErrorSummary` | `Stateless` | Kallopis KlpFormErrorSummary 元件 | [klp_form_error_summary.md](./form/klp_form_error_summary.md) |
| `KlpFormSection` | `Stateless` | Kallopis KlpFormSection 元件 | [klp_form_section.md](./form/klp_form_section.md) |
| `KlpKeyValueEditor` | `Stateless` | Kallopis KlpKeyValueEditor 元件 | [klp_key_value_editor.md](./form/klp_key_value_editor.md) |
| `KlpMultiSelectField` | `Stateless` | Kallopis KlpMultiSelectField 元件 | [klp_multi_select_field.md](./form/klp_multi_select_field.md) |
| `KlpNumberField` | `Stateless` | Kallopis KlpNumberField 元件 | [klp_number_field.md](./form/klp_number_field.md) |
| `KlpPasswordField` | `Stateless` | Kallopis KlpPasswordField 元件 | [klp_password_field.md](./form/klp_password_field.md) |
| `KlpReferencePicker` | `Stateless` | Kallopis KlpReferencePicker 元件 | [klp_reference_picker.md](./form/klp_reference_picker.md) |
| `KlpRepeaterField` | `Stateless` | Kallopis KlpRepeaterField 元件 | [klp_repeater_field.md](./form/klp_repeater_field.md) |
| `KlpSelectField` | `Stateful` | Kallopis KlpSelectField 元件 | [klp_select_field.md](./form/klp_select_field.md) |
| `KlpTextArea` | `Stateless` | Kallopis KlpTextArea 元件 | [klp_text_area.md](./form/klp_text_area.md) |

<a id="data"></a>
### data — 資料呈現 (13)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpBadge` | `Stateless` | Kallopis KlpBadge 元件 | [klp_badge.md](./data/klp_badge.md) |
| `KlpCard` | `Stateless` | Kallopis KlpCard 元件 | [klp_card.md](./data/klp_card.md) |
| `KlpCodeViewer` | `Stateful` | Kallopis KlpCodeViewer 元件 | [klp_code_viewer.md](./data/klp_code_viewer.md) |
| `KlpDataTable` | `Stateless` | Kallopis KlpDataTable 元件 | [klp_data_table.md](./data/klp_data_table.md) |
| `KlpFilePreview` | `Stateless` | Kallopis KlpFilePreview 元件 | [klp_file_preview.md](./data/klp_file_preview.md) |
| `KlpJsonTree` | `Stateless` | Kallopis KlpJsonTree 元件 | [klp_json_tree.md](./data/klp_json_tree.md) |
| `KlpKeyValueList` | `Stateless` | Kallopis KlpKeyValueList 元件 | [klp_key_value_list.md](./data/klp_key_value_list.md) |
| `KlpKeyValueTable` | `Stateless` | Kallopis KlpKeyValueTable 元件 | [klp_key_value_table.md](./data/klp_key_value_table.md) |
| `KlpListTile` | `Stateful` | Kallopis KlpListTile 元件 | [klp_list_tile.md](./data/klp_list_tile.md) |
| `KlpProgress` | `Stateless` | Kallopis KlpProgress 元件 | [klp_progress.md](./data/klp_progress.md) |
| `KlpTag` | `Stateless` | Kallopis KlpTag 元件 | [klp_tag.md](./data/klp_tag.md) |
| `KlpTree` | `Stateless` | Kallopis KlpTree 元件 | [klp_tree.md](./data/klp_tree.md) |
| `KlpTreeItem` | `Stateless` | Kallopis KlpTreeItem 元件 | [klp_tree_item.md](./data/klp_tree_item.md) |

<a id="feedback"></a>
### feedback — 狀態與回饋 (10)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpEmptyState` | `Stateless` | Kallopis KlpEmptyState 元件 | [klp_empty_state.md](./feedback/klp_empty_state.md) |
| `KlpErrorState` | `Stateless` | Kallopis KlpErrorState 元件 | [klp_error_state.md](./feedback/klp_error_state.md) |
| `KlpInlineNotice` | `Stateless` | Kallopis KlpInlineNotice 元件 | [klp_inline_notice.md](./feedback/klp_inline_notice.md) |
| `KlpLoadingState` | `Stateless` | Kallopis KlpLoadingState 元件 | [klp_loading_state.md](./feedback/klp_loading_state.md) |
| `KlpPermissionState` | `Stateless` | Kallopis KlpPermissionState 元件 | [klp_permission_state.md](./feedback/klp_permission_state.md) |
| `KlpProgressOverlay` | `Stateless` | Kallopis KlpProgressOverlay 元件 | [klp_progress_overlay.md](./feedback/klp_progress_overlay.md) |
| `KlpRegionPlaceholder` | `Stateless` | Kallopis KlpRegionPlaceholder 元件 | [klp_region_placeholder.md](./feedback/klp_region_placeholder.md) |
| `KlpSkeletonLine` | `Stateless` | Kallopis KlpSkeletonLine 元件 | [klp_skeleton_line.md](./feedback/klp_skeleton_line.md) |
| `KlpToast` | `Stateless` | 短暫通知。**不負責排程與消失**——停留時間取自 `theme.motion.toastDwell`， 但實際的顯示與收起由呼叫端控制。 | [klp_toast.md](./feedback/klp_toast.md) |
| `KlpToastStack` | `Stateless` | Kallopis KlpToastStack 元件 | [klp_toast_stack.md](./feedback/klp_toast_stack.md) |

<a id="overlay"></a>
### overlay — 浮層 (5)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpDialog` | `Stateless` | 對話框內容。**不負責彈出**——呼叫端自行決定用 `showDialog` 或其他方式呈現。 `secondaryLabel` 為必填：庫不替產品決定用什麼語言說「取消」。 | [klp_dialog.md](./overlay/klp_dialog.md) |
| `KlpMenu` | `Stateless` | Kallopis KlpMenu 元件 | [klp_menu.md](./overlay/klp_menu.md) |
| `KlpMenuItem` | `Stateful` | Kallopis KlpMenuItem 元件 | [klp_menu_item.md](./overlay/klp_menu_item.md) |
| `KlpTooltip` | `Stateless` | Kallopis KlpTooltip 元件 | [klp_tooltip.md](./overlay/klp_tooltip.md) |
| `KlpTooltipSurface` | `Stateless` | Kallopis KlpTooltipSurface 元件 | [klp_tooltip_surface.md](./overlay/klp_tooltip_surface.md) |

<a id="navigation"></a>
### navigation — 導覽元件 (7)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpActionGroup` | `Stateless` | Kallopis KlpActionGroup 元件 | [klp_action_group.md](./navigation/klp_action_group.md) |
| `KlpBreadcrumb` | `Stateless` | Kallopis KlpBreadcrumb 元件 | [klp_breadcrumb.md](./navigation/klp_breadcrumb.md) |
| `KlpPagination` | `Stateless` | Kallopis KlpPagination 元件 | [klp_pagination.md](./navigation/klp_pagination.md) |
| `KlpRailItem` | `Stateful` | Kallopis KlpRailItem 元件 | [klp_rail_item.md](./navigation/klp_rail_item.md) |
| `KlpSidebarSectionLabel` | `Stateless` | Kallopis KlpSidebarSectionLabel 元件 | [klp_sidebar_section_label.md](./navigation/klp_sidebar_section_label.md) |
| `KlpTabs` | `Stateless` | 分頁列。`selected` 是索引，`tabs` 是顯示文字；本元件不持有狀態。 | [klp_tabs.md](./navigation/klp_tabs.md) |
| `KlpViewSwitcher` | `Stateless` | Kallopis KlpViewSwitcher 元件 | [klp_view_switcher.md](./navigation/klp_view_switcher.md) |

<a id="editor"></a>
### editor — 編輯器周邊 (8)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpBulkActionBar` | `Stateless` | Kallopis KlpBulkActionBar 元件 | [klp_bulk_action_bar.md](./editor/klp_bulk_action_bar.md) |
| `KlpCommandMenu` | `Stateless` | Kallopis KlpCommandMenu 元件 | [klp_command_menu.md](./editor/klp_command_menu.md) |
| `KlpEditorToolbar` | `Stateless` | Kallopis KlpEditorToolbar 元件 | [klp_editor_toolbar.md](./editor/klp_editor_toolbar.md) |
| `KlpEntityPicker` | `Stateless` | Kallopis KlpEntityPicker 元件 | [klp_entity_picker.md](./editor/klp_entity_picker.md) |
| `KlpPageChrome` | `Stateless` | Kallopis KlpPageChrome 元件 | [klp_page_chrome.md](./editor/klp_page_chrome.md) |
| `KlpPropertySummary` | `Stateless` | Kallopis KlpPropertySummary 元件 | [klp_property_summary.md](./editor/klp_property_summary.md) |
| `KlpSaveStatusCard` | `Stateless` | Kallopis KlpSaveStatusCard 元件 | [klp_save_status_card.md](./editor/klp_save_status_card.md) |
| `KlpSearchNavigator` | `Stateless` | Kallopis KlpSearchNavigator 元件 | [klp_search_navigator.md](./editor/klp_search_navigator.md) |

<a id="shell"></a>
### shell — 應用外殼 (12)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpAppScreen` | `Stateless` | 應用程式最外層：鋪滿 app 底色，並在頂端保留自訂視窗標題列的位置。  它同時提供整個子樹所需的 `Material` 祖先。少了它，`MaterialApp` 會在每一段文字下方 畫黃色雙底線——那是 Flutter 對「文字沒有 Material 祖先」的除錯提示。**由庫負責提供， 因為消費者沒有理由知道 Kallopis 的哪些元件需要它。** | [klp_app_screen.md](./shell/klp_app_screen.md) |
| `KlpAppWindowHeader` | `Stateless` | Kallopis KlpAppWindowHeader 元件 | [klp_app_window_header.md](./shell/klp_app_window_header.md) |
| `KlpPaneCollapseControl` | `Stateless` | Kallopis KlpPaneCollapseControl 元件 | [klp_pane_collapse_control.md](./shell/klp_pane_collapse_control.md) |
| `KlpPanelFrame` | `Stateless` | 通用面板：header 與 content，選用 footer。高度預設沿用 theme 的外殼密度。 | [klp_panel_frame.md](./shell/klp_panel_frame.md) |
| `KlpPanelHeader` | `Stateless` | Kallopis KlpPanelHeader 元件 | [klp_panel_header.md](./shell/klp_panel_header.md) |
| `KlpResponsivePaneCoordinator` | `Stateless` | 依可用寬度決定面板顯示與否的協調器。斷點來自版面常數，不隨風格改變。 | [klp_responsive_pane_coordinator.md](./shell/klp_responsive_pane_coordinator.md) |
| `KlpSidebarFrame` | `Stateless` | 側邊欄：header、rail（圖示軌）、content 與選用的 footer。 | [klp_sidebar_frame.md](./shell/klp_sidebar_frame.md) |
| `KlpStageFrame` | `Stateless` | 舞台區：頂部 header、中央 content、底部選用的 status 列。 | [klp_stage_frame.md](./shell/klp_stage_frame.md) |
| `KlpStatusBar` | `Stateless` | Kallopis KlpStatusBar 元件 | [klp_status_bar.md](./shell/klp_status_bar.md) |
| `KlpThemePreviewTile` | `Stateless` | Kallopis KlpThemePreviewTile 元件 | [klp_theme_preview_tile.md](./shell/klp_theme_preview_tile.md) |
| `KlpWindowControls` | `Stateless` | Kallopis KlpWindowControls 元件 | [klp_window_controls.md](./shell/klp_window_controls.md) |
| `KlpWorkbenchShell` | `Stateless` | 三欄工作區外殼：主要面板、舞台、次要面板，兩側可拖曳調寬並依斷點自動收合。 這是桌面型應用最外層的版面骨架。 | [klp_workbench_shell.md](./shell/klp_workbench_shell.md) |

<a id="routing"></a>
### routing — 分發 (2)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpRouterOutlet` | `Stateless` | 渲染目前的目的地。  它只做一件事：呼叫 `router.current.builder`。**不做轉場動畫**——轉場屬於產品外殼 的決定（有些頁該滑入，有些該直接換），庫替它決定就等於替所有產品決定。 | [klp_router_outlet.md](./routing/klp_router_outlet.md) |
| `KlpRouterScope` | `Stateless` | 把 [KlpRouter] 供給子樹。 | [klp_router_scope.md](./routing/klp_router_scope.md) |

