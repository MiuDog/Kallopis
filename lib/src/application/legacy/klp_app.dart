import 'package:flutter/material.dart';

import 'package:kallopis/src/foundation/localization/klp_localizations.dart';
import 'package:kallopis/src/foundation/platform/klp_environment_scope.dart';
import 'package:kallopis/src/foundation/platform/klp_platform_info.dart';
import 'package:kallopis/src/foundation/layout/klp_panel_layout.dart';
import 'package:kallopis/src/foundation/layout/klp_directional_position.dart';
import 'package:kallopis/src/foundation/layout/klp_directional_positioned.dart';
import 'package:kallopis/src/foundation/layout/klp_stack.dart';
import 'package:kallopis/src/features/overlays/klp_popup.dart';
import 'package:kallopis/src/features/navigation/legacy_router/klp_router.dart';
import 'package:kallopis/src/features/workspace/shell/window/klp_window_action.dart';
import 'package:kallopis/src/styling/legacy_theme/klp_theme.dart';
import 'package:kallopis/src/styling/legacy_theme/klp_visual_style.dart';
import 'package:kallopis/src/foundation/interaction/keybinding/klp_key_binding_controller.dart';
import 'package:kallopis/src/foundation/surface/klp_surface.dart';
import 'klp_app_controller.dart';
import 'klp_app_scope.dart';

export 'klp_app_controller.dart';
export 'klp_app_scope.dart';

part 'klp_app_frame.dart';
part 'klp_app_state.dart';

/// \MaterialApp\ 的接入層，收掉每個消費者都得自己組一次的樣板。
class KlpApp extends StatefulWidget {
  const KlpApp({
    super.key,
    this.style = KlpVisualStyle.defaultStyle,
    this.lightStyle,
    this.darkStyle,
    this.initialThemeMode = ThemeMode.light,
    this.keyBindingController,
    this.router,
    this.home,
    this.popup,
    this.title = '',
    this.startMaximized = true,
    this.minWidth,
    this.minHeight,
    this.locale,
    this.localizationsDelegates,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.builder,
    this.debugShowCheckedModeBanner = true,
  }) : assert(minWidth == null || minWidth > 0),
       assert(minHeight == null || minHeight > 0);

  /// 向後相容的共用風格基底；未提供對應的完整風格時，色彩仍隨明暗套用內建值。
  final KlpVisualStyle style;

  /// 淺色模式的完整視覺風格；提供後不會被 [style] 或內建色彩改寫。
  final KlpVisualStyle? lightStyle;

  /// 深色模式的完整視覺風格；提供後不會被 [style] 或內建色彩改寫。
  final KlpVisualStyle? darkStyle;

  /// 啟動時的明暗狀態。
  final ThemeMode initialThemeMode;

  /// 可選的快捷鍵 controller；未提供時由 [KlpApp] 建立並管理生命週期。
  final KlpKeyBindingController? keyBindingController;

  /// 選擇性的分發器。給了就自動架好 [KlpRouterScope]，見類別 dartdoc。
  final KlpRouter? router;

  /// 首頁內容。[router] 存在且這裡未給值時，退回 [KlpRouterOutlet]。
  final KlpPanelLayout? home;

  /// 選擇性的 App 層 popup；顯示時覆蓋於最外層。
  final KlpPopupBackground? popup;

  final String title;

  /// 是否在首次建立時確保原生視窗最大化；已最大化時不會切換回視窗化。
  final bool startMaximized;

  /// 視窗最小允許寬度（邏輯像素）。
  final double? minWidth;

  /// 視窗最小允許高度（邏輯像素）。
  final double? minHeight;

  final Locale? locale;

  /// 額外的 localization delegate。[KlpApp] 會把這些 delegate 排在內建預設值前面，
  /// 因此消費者提供的 [KlpLocalizationsDelegate] 會優先覆寫預設字串；其他資源型別也會合併載入。
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Iterable<Locale> supportedLocales;
  final TransitionBuilder? builder;
  final bool debugShowCheckedModeBanner;

  /// 取得目前的 [KlpAppController]，通常用來切換明暗。
  ///
  /// 呼叫端會在 [brightness] 或 [themeMode] 改變時自動重建——這是
  /// \InheritedWidget\ 的標準行為，不需要另外訂閱。
  static KlpAppController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<KlpAppScope>();
    if (scope == null) {
      throw StateError('這個 context 之上沒有 KlpApp。KlpApp.of 只能在其子樹裡呼叫。');
    }
    return scope.controller;
  }

  @override
  State<KlpApp> createState() => _KlpAppState();
}
