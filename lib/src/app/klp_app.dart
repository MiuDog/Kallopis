import 'package:flutter/material.dart';

import '../l10n/klp_localizations.dart';
import '../routing/klp_router.dart';
import '../shell/klp_window_header.dart';
import '../theme/klp_theme.dart';
import '../theme/klp_visual_style.dart';

/// [KlpApp] 對外的控制面。
///
/// 只暴露「目前是什麼」與「切換」，不暴露 [KlpVisualStyle] 或 `ThemeData` 本身——
/// 消費者要客製色彩以外的東西，走 `buildKlpTheme` 自己組 `MaterialApp`，
/// 不透過 [KlpApp]。
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
///   home: const MyHomePage(),
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
///     routes: [KlpRoute(id: 'home', builder: (_) => const HomePage())],
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
/// [style] 決定字體、間距、圓角、動態、分層手法等**除了色彩以外**的每一層；
/// 色彩固定由 [KlpApp] 依目前明暗在 `KlpThemeData.light` 與 `KlpThemeData.dark`
/// 之間切換——這樣「切換明暗」才有事可做。要自訂色彩（例如品牌色），改用
/// `buildKlpTheme` 自己組 `MaterialApp`，而不是透過 [KlpApp]。
class KlpApp extends StatefulWidget {
  const KlpApp({
    super.key,
    this.style = KlpVisualStyle.defaultStyle,
    this.initialThemeMode = ThemeMode.light,
    this.router,
    this.home,
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

  /// 除色彩外的每一層視覺風格。預設值是庫出貨的唯一一套 [KlpVisualStyle.defaultStyle]。
  final KlpVisualStyle style;

  /// 啟動時的明暗狀態。
  final ThemeMode initialThemeMode;

  /// 選擇性的分發器。給了就自動架好 [KlpRouterScope]，見類別 dartdoc。
  final KlpRouter? router;

  /// 首頁內容。[router] 存在且這裡未給值時，退回 [KlpRouterOutlet]。
  final Widget? home;

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

  /// 額外的 localization delegate。[KlpApp] 一律自動掛上內建預設值的
  /// [KlpLocalizationsDelegate]（見類別 dartdoc「換字串」）並排在這裡給的值之前，
  /// 因此消費者可以在這裡放自己的 [KlpLocalizationsDelegate] 覆寫預設字串，
  /// 也可以放 `GlobalMaterialLocalizations.delegates` 之類其他 delegate——
  /// 兩者都會與內建那份合併，不會互相覆蓋。
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Iterable<Locale> supportedLocales;
  final TransitionBuilder? builder;
  final bool debugShowCheckedModeBanner;

  /// 取得目前的 [KlpAppController]，通常用來切換明暗。
  ///
  /// 呼叫端會在 [brightness] 或 [themeMode] 改變時自動重建——這是
  /// `InheritedWidget` 的標準行為，不需要另外訂閱。
  static KlpAppController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_KlpAppScope>();
    if (scope == null) {
      throw StateError('這個 context 之上沒有 KlpApp。KlpApp.of 只能在其子樹裡呼叫。');
    }
    return scope.controller;
  }

  @override
  State<KlpApp> createState() => _KlpAppState();
}

class _KlpAppState extends State<KlpApp> implements KlpAppController {
  late ThemeMode _themeMode = widget.initialThemeMode;

  @override
  void initState() {
    super.initState();
    if (widget.startMaximized) KlpWindowAction.maximize();

    if (widget.minWidth != null || widget.minHeight != null) {
      KlpWindowAction.setMinSize(
        minWidth: widget.minWidth,
        minHeight: widget.minHeight,
      );
    }
  }

  @override
  void didUpdateWidget(covariant KlpApp oldWidget) {
    super.didUpdateWidget(oldWidget);
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
    final effectiveStyle = widget.style.copyWith(
      colors: brightness == Brightness.dark
          ? KlpThemeData.dark
          : KlpThemeData.light,
    );

    Widget? content = widget.home;
    final router = widget.router;
    if (router != null) {
      content = KlpRouterScope(
        router: router,
        child: content ?? const KlpRouterOutlet(),
      );
    }

    if (widget.showWindowHeader && content != null) {
      final toolbarHeight = klpWindowHeaderHeight(effectiveStyle.spacing);
      final header =
          widget.windowHeader ??
          KlpWindowHeader(
            appIcon: widget.appIcon == null
                ? null
                : _KlpAppIcon(
                    size: effectiveStyle.geometry.layout.windowAppIconSize,
                    child: widget.appIcon!,
                  ),
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
      );
    }

    return _KlpAppScope(
      controller: this,
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
        // 內建的 KlpLocalizations 預設值放最前面：Localizations 依序載入 delegates，
        // 同一個型別後面的會覆蓋前面的，因此消費者自己在 widget.localizationsDelegates
        // 裡放一份 KlpLocalizationsDelegate 覆寫時，蓋掉的會是這裡的預設值而不是反過來。
        localizationsDelegates: [
          const KlpLocalizationsDelegate(),
          ...?widget.localizationsDelegates,
        ],
        supportedLocales: widget.supportedLocales,
        builder: widget.builder,
        home: content,
      ),
    );
  }
}

/// 統一管理 App 外圈與縮短後的 Header 高度，並在視窗轉場時遵守父層約束。
class _KlpAppFrame extends StatelessWidget {
  const _KlpAppFrame({
    required this.header,
    required this.body,
    required this.toolbarHeight,
  });

  final Widget header;
  final Widget body;
  final double toolbarHeight;

  @override
  Widget build(BuildContext context) {
    final appInset = context.klp.space.compact / 2;
    final headerHeight = toolbarHeight;

    return ColoredBox(
      key: const ValueKey('klp-app-frame-background'),
      color: context.klpColors.app,
      child: Padding(
        padding: EdgeInsets.all(appInset),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final effectiveHeaderHeight = constraints.hasBoundedHeight
                ? constraints.maxHeight.clamp(0.0, headerHeight).toDouble()
                : headerHeight;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: effectiveHeaderHeight,
                  child: ClipRect(child: header),
                ),
                if (constraints.hasBoundedHeight)
                  Expanded(child: body)
                else
                  body,
              ],
            );
          },
        ),
      ),
    );
  }
}

/// 將消費端提供的圖示收斂到 Kallopis 的標題列尺寸。
class _KlpAppIcon extends StatelessWidget {
  const _KlpAppIcon({required this.size, required this.child});

  final double size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: IconTheme.merge(
        data: IconThemeData(size: size),
        child: FittedBox(fit: BoxFit.contain, child: child),
      ),
    );
  }
}

/// 供 [KlpApp.of] 查找的 `InheritedWidget`。
///
/// [brightness] 與 [themeMode] 是資料欄位而非只有 [controller] 一個引用，
/// 這樣 [updateShouldNotify] 才能在它們改變時真正回傳 `true`，讓依賴它的
/// 子樹重建——只放 controller 引用的話，同一個物件永遠 `==` 自己，不會觸發重建。
class _KlpAppScope extends InheritedWidget {
  const _KlpAppScope({
    required this.controller,
    required this.brightness,
    required this.themeMode,
    required super.child,
  });

  final KlpAppController controller;
  final Brightness brightness;
  final ThemeMode themeMode;

  @override
  bool updateShouldNotify(_KlpAppScope oldWidget) =>
      brightness != oldWidget.brightness || themeMode != oldWidget.themeMode;
}
