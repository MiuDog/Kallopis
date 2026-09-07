import 'package:flutter/material.dart';

import '../l10n/klp_localizations.dart';
import '../overlay/klp_popup.dart';
import '../routing/klp_router.dart';
import '../shell/window/klp_window_header.dart';
import '../theme/klp_theme.dart';
import '../shell/panel/klp_panel_layout.dart';
import 'klp_platform_info.dart';
import 'klp_environment_scope.dart';
import '../theme/klp_visual_style.dart';
import '../interaction/keybinding/klp_key_binding_controller.dart';

/// [KlpApp] 對外的控制面。
///
/// 只暴露「目前是什麼」與「切換」，不暴露 [KlpVisualStyle] 或 `ThemeData` 本身；
/// 消費者透過 [KlpApp.lightStyle] 與 [KlpApp.darkStyle] 注入完整風格。
abstract class KlpAppController {
	/// 目前實際套用的明暗（[ThemeMode.system] 時已解析成 [Brightness.light]
	/// 或 [Brightness.dark]）。
	Brightness get brightness;

	/// 目前的 [ThemeMode]。與 [brightness] 的差別：這個可能是 [ThemeMode.system]。
	ThemeMode get themeMode;

	/// 在淺色／深色之間切換。若目前是 [ThemeMode.system]，切換後固定為明確的
	/// [ThemeMode.light] 或 [ThemeMode.dark]（切換到目前 [brightness] 的反面）——
	/// 「切換」是使用者的明確動作，不該切完又被系統設定蓋回去。
	void toggleBrightness();

	/// 直接指定 [ThemeMode]，包含切回 [ThemeMode.system]。
	void setThemeMode(ThemeMode mode);

	/// App 內集中管理 app／page／region 快捷鍵的 controller。
	KlpKeyBindingController get keyBindings;
}

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

class _KlpAppState extends State<KlpApp> with WidgetsBindingObserver implements KlpAppController {
	late ThemeMode _themeMode = widget.initialThemeMode;
	late KlpKeyBindingController _keyBindings;
	bool _ownsKeyBindings = false;

	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addObserver(this);
		_keyBindings = widget.keyBindingController ?? KlpKeyBindingController();
		_ownsKeyBindings = widget.keyBindingController == null;
		if (widget.startMaximized) KlpWindowAction.maximize();

		if (widget.minWidth != null || widget.minHeight != null) {
			KlpWindowAction.setMinSize(
				minWidth: widget.minWidth,
				minHeight: widget.minHeight,
			);
		}
	}

	@override
	void dispose() {
		WidgetsBinding.instance.removeObserver(this);
		if (_ownsKeyBindings) _keyBindings.dispose();
		super.dispose();
	}

	@override
	void didChangePlatformBrightness() {
		if (_themeMode != ThemeMode.system) return;

		setState(() {});
	}

	@override
	void didUpdateWidget(covariant KlpApp oldWidget) {
		super.didUpdateWidget(oldWidget);
		if (!identical(widget.keyBindingController, oldWidget.keyBindingController)) {
			if (_ownsKeyBindings) _keyBindings.dispose();
			_keyBindings = widget.keyBindingController ?? KlpKeyBindingController();
			_ownsKeyBindings = widget.keyBindingController == null;
		}
		if (widget.minWidth != oldWidget.minWidth ||
				widget.minHeight != oldWidget.minHeight) {
			KlpWindowAction.setMinSize(
				minWidth: widget.minWidth,
				minHeight: widget.minHeight,
			);
		}
	}

	@override
	ThemeMode get themeMode => _themeMode;

	@override
	KlpKeyBindingController get keyBindings => _keyBindings;

	@override
	Brightness get brightness => switch (_themeMode) {
		ThemeMode.light => Brightness.light,
		ThemeMode.dark => Brightness.dark,
		ThemeMode.system =>
			WidgetsBinding.instance.platformDispatcher.platformBrightness,
	};

	@override
	void toggleBrightness() {
		setState(() {
			_themeMode = brightness == Brightness.dark
					? ThemeMode.light
					: ThemeMode.dark;
		});
	}

	@override
	void setThemeMode(ThemeMode mode) {
		setState(() => _themeMode = mode);
	}

	@override
	Widget build(BuildContext context) {
		final effectiveStyle = _styleFor(brightness);

		Widget? content = widget.home;
		final router = widget.router;
		if (router != null) {
			content = KlpRouterScope(
				router: router,
				child: content ?? const KlpRouterOutlet(),
			);
		}

		if (content != null && (widget.showWindowHeader || widget.popup != null)) {
			final toolbarHeight = widget.showWindowHeader
					? klpWindowHeaderHeight(
							effectiveStyle.geometry,
							windowHeaderMargin: effectiveStyle.spacing.windowHeaderMargin,
						)
					: 0.0;
			final header = !widget.showWindowHeader
					? null
					: widget.windowHeader ??
						KlpWindowHeader(
							appIcon: widget.appIcon,
							titleText: widget.title.isNotEmpty ? widget.title : null,
							height: toolbarHeight,
							actions: widget.headerActions,
							onMinimize: widget.onMinimize,
							onToggleMaximize: widget.onToggleMaximize,
							onClose: widget.onClose,
							isMaximized: widget.isMaximized,
							showWindowControls: widget.showWindowControls,
						);
			content = _KlpAppFrame(
				header: header,
				body: content,
				toolbarHeight: toolbarHeight,
				popup: widget.popup,
			);
		}

		final platform = KlpPlatformInfo.current();
		return KlpEnvironmentScope(
			platform: platform,
			child: KlpAppScope(
				controller: this,
				platform: platform,
				brightness: brightness,
				themeMode: _themeMode,
				child: MaterialApp(
					title: widget.title,
					debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
					theme: buildKlpTheme(brightness, style: effectiveStyle),
					// 深淺切換不做過場：見 README「深淺切換不做過場」與
					// `lib/kallopis.dart` barrel dartdoc 的說明。
					themeAnimationDuration: Duration.zero,
					locale: widget.locale,
					// Flutter 對相同資源型別採用第一個支援的 delegate，消費端必須排在內建值前面。
					localizationsDelegates: [
						...?widget.localizationsDelegates,
						const KlpLocalizationsDelegate(),
					],
					supportedLocales: widget.supportedLocales,
					builder: widget.builder,
					// Panel Tree 的文字與互動共用透明 Material，隔離 MaterialApp 的警示文字樣式。
					home: content == null
							? null
							: KlpKeyBindingHost(
									controller: _keyBindings,
									child: Material(
										type: MaterialType.transparency,
										child: content,
									),
								),
				),
			),
		);
	}

	KlpVisualStyle _styleFor(Brightness brightness) {
		final completeStyle = brightness == Brightness.dark
				? widget.darkStyle
				: widget.lightStyle;
		if (completeStyle != null) return completeStyle;

		return widget.style.copyWith(
			colors: brightness == Brightness.dark
					? KlpThemeData.dark
					: KlpThemeData.light,
		);
	}
}

/// 鋪設 App background，並以 appFrameInset padding 包住 Header 與產品主內容。
class _KlpAppFrame extends StatelessWidget {
	const _KlpAppFrame({
		required this.header,
		required this.body,
		required this.toolbarHeight,
		this.popup,
	});

	final Widget? header;
	final Widget body;
	final double toolbarHeight;
	final KlpPopupBackground? popup;

	@override
	Widget build(BuildContext context) {
		final headerHeight = toolbarHeight;

		return ColoredBox(
			key: const ValueKey('klp-app-frame-background'),
			color: context.klpColors.app,

			child: Padding(
				padding: EdgeInsets.all(context.klp.space.appFrameInset),

				child: LayoutBuilder(
					builder: (context, constraints) {
						var effectiveHeaderHeight = headerHeight;
						if (constraints.hasBoundedHeight) {
							effectiveHeaderHeight = constraints.maxHeight
									.clamp(0.0, headerHeight)
									.toDouble();
						}

						if (!constraints.hasBoundedHeight) {
							return Column(
								crossAxisAlignment: CrossAxisAlignment.stretch,
								children: [
									if (header != null)
										SizedBox(height: effectiveHeaderHeight, child: header),
									body,
								],
							);
						}

						return KlpPopupInteractionScope(
							topInset: effectiveHeaderHeight,
							child: Stack(
								clipBehavior: Clip.hardEdge,
								children: [
									Positioned.fill(top: effectiveHeaderHeight, child: body),
									if (header != null)
										Positioned(
											top: 0,
											left: 0,
											right: 0,
											height: effectiveHeaderHeight,
											child: header!,
										),
									if (popup != null) Positioned.fill(child: popup!),
								],
							),
						);
					},
				),
			),
		);
	}
}

/// 供 [KlpApp.of] 查找的 `InheritedWidget`。
///
/// [brightness] 與 [themeMode] 是資料欄位而非只有 [controller] 一個引用，
/// 這樣 [updateShouldNotify] 才能在它們改變時真正回傳 `true`，讓依賴它的
/// 子樹重建——只放 controller 引用的話，同一個物件永遠 `==` 自己，不會觸發重建。
class KlpAppScope extends InheritedWidget {
	const KlpAppScope({
		super.key,
		required this.controller,
		required this.platform,
		required this.brightness,
		required this.themeMode,
		required super.child,
	});

	final KlpAppController controller;
	/// 舊版 scope 的相容欄位；新平台讀取由 KlpEnvironmentScope 提供。
	final KlpPlatformInfo platform;
	final Brightness brightness;
	final ThemeMode themeMode;

	/// 相容入口：優先訂閱平台環境，舊有獨立 AppScope 仍可讀取其平台。
	static KlpPlatformInfo platformOf(BuildContext context) {
		final platform = KlpEnvironmentScope.maybeOf(context);
		if (platform != null) return platform;
		final scope = context.dependOnInheritedWidgetOfExactType<KlpAppScope>();
		if (scope == null) {
			throw StateError('這個 context 之上沒有 KlpAppScope。');
		}
		return scope.platform;
	}

	@override
	bool updateShouldNotify(KlpAppScope oldWidget) =>
			!identical(controller, oldWidget.controller) ||
			platform.platform != oldWidget.platform.platform ||
			brightness != oldWidget.brightness ||
			themeMode != oldWidget.themeMode;
}
