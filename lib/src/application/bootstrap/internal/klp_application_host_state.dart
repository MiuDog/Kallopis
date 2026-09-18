part of '../../structure/klp_application.dart';

class _KlpApplicationHostState extends State<_KlpApplicationHost>
		with WidgetsBindingObserver {
	final _KlpApplicationEnvironmentObserver _environmentObserver = const _KlpApplicationEnvironmentObserver();
	late final _KlpApplicationSession _session;
	final KlpFileSelectionPort _fileSelection = const KlpFileSelectionAdapter();
	KlpSubscription? _subscription;
	int _sourceGeneration = 0;
	final List<bool Function()> _layoutBackHandlers = [];

	@override
	void initState() {
		super.initState();
		_session = _KlpApplicationSession(
			fileSelection: _fileSelection,
			onChanged: _changed,
			onAsyncError: _reportError,
			onRouteInformationChanged: _reportRouteInformation,
		);
		WidgetsBinding.instance.addObserver(this);
		try {
			_subscribe();
			_accept(widget.source.value);
			WidgetsBinding.instance.addPostFrameCallback((_) {
				final application = _session.application;
				if (mounted && application != null) {
					_accept(application, viewportSize: _viewportSize());
				}
			});
		} catch (error, stackTrace) {
			_sourceGeneration++;
			klpRunLifecycleActions([
				() => Error.throwWithStackTrace(error, stackTrace),
				() => _subscription?.cancel(),
				_session.dispose,
				() => WidgetsBinding.instance.removeObserver(this),
			]);
		}
	}

	void _subscribe() {
		final generation = ++_sourceGeneration;
		_subscription = widget.source.subscribe((value) {
			if (mounted && generation == _sourceGeneration) _receive(value);
		});
	}

	void _changed() {
		if (mounted) setState(() {});
	}

	void _reportEditingHostFailure(KlpEditingHostFailure failure) {
		_reportError(failure.error, failure.stackTrace, context: ErrorDescription('Editing host ${failure.origin.name}: ${failure.phase.name}'));
	}

	void _reportError(Object error, StackTrace stack, {DiagnosticsNode? context}) {
		FlutterError.reportError(
			FlutterErrorDetails(
				exception: error,
				stack: stack,
				library: 'kallopis application',
				context: context,
			),
		);
	}

	void _reportRouteInformation(Uri uri, bool replace) {
		unawaited(
			SystemNavigator.routeInformationUpdated(
				uri: uri,
				replace: replace,
			).catchError((Object error, StackTrace stack) {
				_reportError(error, stack);
			}),
		);
	}

	void _receive(KlpApplication application) {
		try {
			_accept(application);
		} finally {
			if (mounted) setState(() {});
		}
	}

	void _accept(KlpApplication application, {Size? viewportSize}) {
		final info = _environmentObserver.observe(viewportSize: viewportSize);
		final environment = _environmentObserver.environment(info);
		_session.accept(
			application,
			appearance: environment.appearance,
			adaptiveContext: KlpAdaptiveContext(
				platform: switch (info.platform) {
					KlpAppPlatform.android => KlpAdaptivePlatform.android,
					KlpAppPlatform.ios => KlpAdaptivePlatform.ios,
					KlpAppPlatform.windows => KlpAdaptivePlatform.windows,
					KlpAppPlatform.macos => KlpAdaptivePlatform.macos,
					KlpAppPlatform.linux => KlpAdaptivePlatform.linux,
					KlpAppPlatform.web => KlpAdaptivePlatform.web,
					KlpAppPlatform.other => KlpAdaptivePlatform.other,
				},
				deviceClass: info.deviceClass,
				orientation: info.orientation,
				displayMode: info.displayMode,
			),
		);
	}

	Size? _viewportSize() {
		final views = WidgetsBinding.instance.platformDispatcher.views;
		if (views.isEmpty) return null;
		final view = views.first;
		if (view.devicePixelRatio == 0) return null;
		return Size(
			view.physicalSize.width / view.devicePixelRatio,
			view.physicalSize.height / view.devicePixelRatio,
		);
	}

	@override
	void didChangeMetrics() {
		final application = _session.application;
		if (mounted && application != null) {
			_accept(application, viewportSize: _viewportSize());
		}
	}

	@override
	void didChangePlatformBrightness() {
		final application = _session.application;
		if (mounted && application != null) {
			_accept(application, viewportSize: _viewportSize());
		}
	}

	@override
	Future<bool> didPopRoute() {
		for (final handler in _layoutBackHandlers.reversed.toList()) {
			if (handler()) return Future.value(true);
		}
		return _session.handleBack();
	}

	@override
	Future<bool> didPushRouteInformation(
		RouteInformation routeInformation,
	) async {
		final restoration = KlpRouteUri.decode(routeInformation.uri);
		if (restoration == null) {
			return false;
		}
		return _session.restore(restoration);
	}

	@override
	void didChangeAccessibilityFeatures() {
		// 偏好改變只重建受控呈現，不重新安裝資料、狀態或導覽資源。
		_changed();
	}

	@override
	void didUpdateWidget(_KlpApplicationHost oldWidget) {
		super.didUpdateWidget(oldWidget);
		if (identical(oldWidget.source, widget.source)) return;

		final previous = _subscription;
		_subscription = null;
		_sourceGeneration++;
		try {
			klpRunLifecycleActions([
				() => previous?.cancel(),
				() {
					_subscribe();
					_accept(widget.source.value);
				},
			]);
		} catch (error, stackTrace) {
			// 更新生命週期需完成重建，錯誤交由框架報告而非摧毀已提交的宿主。
			FlutterError.reportError(
				FlutterErrorDetails(
					exception: error,
					stack: stackTrace,
					library: 'kallopis application',
				),
			);
		}
	}

	@override
	Widget build(BuildContext context) {
		final frame = _session.frame;
		if (frame == null) {
			if (_session.isPending) return const SizedBox.expand();

			return ErrorWidget(
				_session.startupError ??
						StateError('Application has no committed presentation.'),
			);
		}

		final background = _background(frame.content);
		return WidgetsApp(
			localizationsDelegates: const [KlpLocalizationsDelegate()],
			title: _session.title,
			color: Color.fromARGB(
				background.alpha,
				background.red,
				background.green,
				background.blue,
			),
			debugShowCheckedModeBanner: false,
			builder: (context, child) {
				final media = MediaQuery.maybeOf(context);
				final platformInfo = _environmentObserver.observe(viewportSize: media?.size);
				final environment = _environmentObserver.environment(platformInfo);
				final rendered = KlpViewportCapabilities(
					onEditingHostFailure: _reportEditingHostFailure,
					backHandlers: _layoutBackHandlers,
					adaptiveMode: platformInfo.effectiveAdaptiveMode,
					nativeWindows: environment.platform == KlpApplicationPlatform.windows,
					desktop: switch (environment.platform) {
						KlpApplicationPlatform.android || KlpApplicationPlatform.ios => false,
						_ => platformInfo.isDesktop,
					},
					// 宿主提供穩定浮層，讓提示可跨畫面更新並沿用環境設定。
					child: Overlay.wrap(
						child: KlpIdScope(
							id: _scopeId(frame.rootId),
							child: KlpFlutterRenderer(key: ValueKey(frame.rootId), content: frame.content),
						),
					),
				);
				// 無 Navigator 的 WidgetsApp 不會建立初始焦點範圍；宿主統一補上，
				// 讓所有宣告式控制都能從鍵盤巡覽進入。
				final focused = FocusScope(autofocus: true, child: rendered);
				if (media == null) return focused;
				return MediaQuery(
					data: media.copyWith(
						disableAnimations: environment.motion == KlpMotionPolicy.immediate,
					),
					child: TickerMode(
						enabled: environment.motion != KlpMotionPolicy.immediate,
						child: focused,
					),
				);
			},
		);
	}

	KlpId _scopeId(KlpPlacementId placement) {
		final segments = <String>[
			for (final value in placement.scope) ...value.split('.'),
			...placement.localId.split('.'),
		];
		return KlpId.from(segments);
	}

	KlpColor _background(KlpBoundTemplate content) {
		// 直接沿已提交的目前頁取得同一份表面風格，避免應用根另存預設值。
		while (true) {
			switch (content) {
				case KlpBoundPlacement value:
					content = value.content;
				case KlpBoundScreen value:
					content = value.child;
				case KlpBoundRetainedStack value:
					content = value.pages.singleWhere(
						(page) => page.id == value.activeId,
					);
				case KlpBoundSurface value:
					return value.background;
				default:
					throw StateError('Committed screen has no surface.');
			}
		}
	}

	@override
	void dispose() {
		_sourceGeneration++;
		klpRunLifecycleActions([
			() => WidgetsBinding.instance.removeObserver(this),
			() => _subscription?.cancel(),
			_session.dispose,
			super.dispose,
		]);
	}
}
