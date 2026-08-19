/// Kallopis — `-ist` 產品家族共用的 Flutter 視覺層。
///
/// 這個 barrel 是唯一的公開入口；`lib/src/` 不對外。
///
/// ## 最短用法
///
/// ```dart
/// MaterialApp(
///   theme: buildKlpTheme(Brightness.light),
///   home: const KlpAppScreen(child: MyScreen()),
/// )
/// ```
///
/// ## 換一套視覺風格
///
/// 庫只出貨 `modern` 一套。要換風格是取它再逐層 `copyWith`——風格是一個必須整組給定
/// 的物件，因此不會出現「只換了一半」的狀態：
///
/// ```dart
/// final squared = KlpVisualStyle.modern.copyWith(
///   name: 'squared',
///   shape: KlpShapeTheme.standardShape.copyWith(
///     control: 0,
///     card: 0,
///     panel: 0,
///   ),
/// );
/// theme: buildKlpTheme(Brightness.dark, style: squared)
/// ```
///
/// ## 套用品牌色
///
/// 取一套現成風格，只覆寫需要的那一層。**傳入 `style` 時 `style.colors` 就是色彩的
/// 唯一來源**，`brightness` 不再干涉：
///
/// ```dart
/// final brand = KlpVisualStyle.modern.copyWith(
///   colors: KlpThemeData.light.copyWith(accent: myBrandColor),
/// );
/// theme: buildKlpTheme(Brightness.light, style: brand)
/// ```
///
/// ## 深淺切換不要有過場
///
/// `MaterialApp` 預設會跑 200ms 的 theme 動畫。Kallopis 的每一層 token 都在中點
/// 原子性翻轉（不內插），但動畫期間仍有半數幀停在舊值上——看起來會像「某些元件沒有
/// 跟著變」。**切換主題是狀態改變，不是動作**：
///
/// ```dart
/// MaterialApp(
///   theme: buildKlpTheme(brightness),
///   themeAnimationDuration: Duration.zero,
///   home: const MyApp(),
/// )
/// ```
///
/// ## 元件取值
///
/// 元件一律透過 `context.klp` 取已解析的 token，不使用編譯期常數——後者換 theme 時
/// 不會跟著變，而且不會有任何錯誤訊息告訴你它沒變：
///
/// ```dart
/// Padding(padding: EdgeInsets.all(context.klp.space.base), child: ...)
/// ```
library;

export 'src/app/klp_app.dart';
export 'src/controls/klp_button.dart';
export 'src/controls/klp_control_size.dart';
export 'src/controls/klp_checkbox.dart';
export 'src/controls/klp_icon_button.dart';
export 'src/controls/klp_phase_toggle.dart';
export 'src/controls/klp_radio_group.dart';
export 'src/controls/klp_segmented_control.dart';
export 'src/controls/klp_select.dart';
export 'src/controls/klp_sliding_selection.dart';
export 'src/controls/klp_slider.dart';
export 'src/controls/klp_switch.dart';
export 'src/controls/klp_toggle.dart';
export 'src/controls/klp_tri_state_toggle.dart';
export 'src/controls/klp_text_field.dart';
export 'src/theme/klp_data_visualization_theme.dart';
export 'src/data/klp_accordion.dart';
export 'src/data/klp_badge.dart';
export 'src/data/klp_card.dart';
export 'src/data/klp_list_tile.dart';
export 'src/data/klp_key_value_table.dart';
export 'src/data/klp_progress.dart';
export 'src/data/klp_advanced_data.dart';
export 'src/data/klp_code_viewer.dart';
export 'src/data/klp_stepper.dart';
export 'src/data/klp_timeline.dart';
export 'src/editor/klp_command_menu.dart';
export 'src/editor/klp_editor_action_bars.dart';
export 'src/editor/klp_entity_picker.dart';
export 'src/editor/klp_page_chrome.dart';
export 'src/feedback/klp_empty_state.dart';
export 'src/feedback/klp_feedback_tone.dart';
export 'src/feedback/klp_inline_notice.dart';
export 'src/feedback/klp_region_placeholder.dart';
export 'src/feedback/klp_toast.dart';
export 'src/feedback/klp_view_states.dart';
export 'src/form/klp_form.dart';
export 'src/form/klp_form_controls.dart';
export 'src/form/klp_reference_picker.dart';
export 'src/form/klp_structured_fields.dart';
export 'src/foundation/klp_icon.dart';
export 'src/foundation/klp_icons.dart';
export 'src/foundation/klp_palette.dart';
export 'src/foundation/klp_accent.dart';
export 'src/foundation/klp_metrics.dart';
export 'src/foundation/klp_foundation_extras.dart';
export 'src/foundation/klp_geometric_spinner.dart';
export 'src/foundation/klp_inline_code.dart';
export 'src/navigation/klp_breadcrumb.dart';
export 'src/navigation/klp_rail_item.dart';
export 'src/navigation/klp_tabs.dart';
export 'src/interaction/klp_filter_bar.dart';
export 'src/interaction/klp_interaction_settings.dart';
export 'src/interaction/klp_pressable.dart';
export 'src/layout/klp_layout.dart';
export 'src/navigation/klp_navigation_controls.dart';
export 'src/overlay/klp_dialog.dart';
export 'src/overlay/klp_menu.dart';
export 'src/overlay/klp_tooltip.dart';
export 'src/shell/klp_panel_frame.dart';
export 'src/shell/klp_panel_header.dart';
export 'src/shell/klp_sidebar_frame.dart';
export 'src/shell/klp_stage_frame.dart';
export 'src/shell/klp_status_bar.dart';
export 'src/shell/klp_theme_preview_tile.dart';
export 'src/shell/klp_workbench_shell.dart';
export 'src/shell/klp_shell_extras.dart';
export 'src/shell/klp_window_controls.dart';
export 'src/surface/klp_divider.dart';
export 'src/surface/klp_dashed_border.dart';
export 'src/surface/klp_section.dart';
export 'src/surface/klp_stroke.dart';
export 'src/surface/klp_surface.dart';
export 'src/theme/klp_theme.dart';
export 'src/typography/klp_text.dart';
export 'src/tokens/klp_scale.dart';
export 'src/theme/klp_component_theme.dart';
export 'src/theme/klp_motion_theme.dart';
export 'src/theme/klp_shape_theme.dart';
export 'src/theme/klp_spacing_theme.dart';
export 'src/theme/klp_surface_theme.dart';
export 'src/theme/klp_theme_scope.dart';
export 'src/theme/klp_typography_theme.dart';
export 'src/theme/klp_visual_style.dart';
export 'src/routing/klp_router.dart';
