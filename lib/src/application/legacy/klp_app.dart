import 'package:flutter/material.dart';

import '../localization/klp_localizations.dart';
import '../../foundation/platform/klp_environment_scope.dart';
import '../../foundation/platform/klp_platform_info.dart';
import '../../foundation/layout/klp_panel_layout.dart';
import '../../foundation/layout/klp_box.dart';
import '../../foundation/layout/klp_column.dart';
import '../../foundation/layout/klp_directional_position.dart';
import '../../foundation/layout/klp_directional_positioned.dart';
import '../../foundation/layout/klp_box_insets.dart';
import '../../foundation/layout/klp_stack.dart';
import '../../features/overlays/klp_popup.dart';
import '../../features/navigation/legacy_router/klp_router.dart';
import '../../features/workspace/shell/window/klp_window_header.dart';
import '../../features/workspace/shell/window/klp_window_action.dart';
import '../../features/workspace/shell/window/klp_window_header_height.dart';
import '../../styling/legacy_theme/klp_theme.dart';
import '../../styling/legacy_theme/klp_visual_style.dart';
import '../../foundation/interaction/keybinding/klp_key_binding_controller.dart';
import '../../foundation/surface/klp_surface.dart';
import 'klp_app_controller.dart';
import 'klp_app_scope.dart';

export 'klp_app_controller.dart';
export 'klp_app_scope.dart';

part 'klp_app_frame.dart';
part 'klp_app_state.dart';

/// `MaterialApp` 的接入層，收掉每個消費者都得自己組一次的樣板。
///
/// 沒有它時，消費者要自己：套 `buildKlpTheme` 的亮／暗兩份 `ThemeData`、記得把
/// `themeAnimationDuration` 歸零（否則主題切換的動畫中途會有半數幀停在舊值上，
/// 見 README「深淺切換不做過場」）、決定明暗狀態放哪裡並手刻切換入口、如果用了
/// [KlpRouter] 還要自己架 [KlpRouterScope]。這些細節不涉及任何產品語意，每個
/// `-ist` 產品各刻一次只會讓實作各自漂移——因此收進庫。
///
/// ## 最小用法
///
/// ```dart
/// KlpApp(
///   home: KlpPanelFrame(content: const MyHomePage()),
/// )
/// ```
///
/// ## 搭配 router
///
/// 給了 [router] 但沒給 [home] 時，自動以 [KlpRouterOutlet] 當作首頁；
/// 兩者都給時，[home] 仍會被包在 [KlpRouterScope] 之下，因此 [home] 的子樹
/// 裡任何位置都能用 `context.klpRouter`（[KlpRouterOutlet] 放在哪一層由消費者
/// 自己決定）。
///
/// ```dart
/// KlpApp(
///   router: KlpRouter(
///     routes: [
///       KlpRoute(
///         id: 'home',
///         builder: (_) => KlpPanelFrame(content: const HomePage()),
///       ),
///     ],
///     initialId: 'home',
///   ),
/// )
/// ```
///
/// ## 切換明暗
///
/// ```dart
/// KlpApp.of(context).toggleBrightness();
/// ```
///
/// ## 換視覺風格
///
/// [style] 是向後相容的共用基底，依目前明暗換上內建色彩。需要完整控制亮／暗風格時，
/// 改傳 [lightStyle] 與 [darkStyle]；對應模式一旦有完整風格，[KlpApp] 就不會改寫其中任一層。
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
		this.appIcon,
		this.showWindowHeader = true,
		this.headerActions,
		this.windowHeader,
		this.onMinimize,
		this.onToggleMaximize,
		this.onClose,
		this.isMaximized = false,
		this.showWindowControls = true,
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

	/// 選擇性的 App 層 popup；顯示時仍會讓視窗標題列保有拖動與雙擊優先權。
	final KlpPopupBackground? popup;

	final String title;

	/// 應用程式圖示內容；標題列尺寸由目前 [style] 的 shell geometry 決定。
	final Widget? appIcon;

	/// 是否顯示自帶的頂部視窗標題列（預設為 true）。
	final bool showWindowHeader;

	/// 標題列頂部自訂快捷按鈕。
	final List<Widget>? headerActions;

	/// 完全自訂的視窗標題列 Widget（提供時覆蓋預設產生的 [KlpWindowHeader]）。
	final Widget? windowHeader;

	/// 視窗最小化回呼。
	final VoidCallback? onMinimize;

	/// 視窗最大化／還原回呼。
	final VoidCallback? onToggleMaximize;

	/// 視窗關閉回呼。
	final VoidCallback? onClose;

	/// 視窗是否處於最大化狀態。
	final bool isMaximized;

	/// 是否在標題列展示視窗管理控制鈕。
	final bool showWindowControls;

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
	/// `InheritedWidget` 的標準行為，不需要另外訂閱。
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
