part of 'klp_app.dart';

/// 管理 Kallopis 應用程式主題、快捷鍵與平台生命週期。
class _KlpAppState extends State<KlpApp>
    with WidgetsBindingObserver
    implements KlpAppController {
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
    if (!identical(
      widget.keyBindingController,
      oldWidget.keyBindingController,
    )) {
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
          themeAnimationDuration: Duration.zero,
          locale: widget.locale,
          localizationsDelegates: [
            ...?widget.localizationsDelegates,
            const KlpLocalizationsDelegate(),
          ],
          supportedLocales: widget.supportedLocales,
          builder: widget.builder,
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
