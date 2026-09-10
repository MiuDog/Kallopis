part of '../../structure/klp_application.dart';

class _KlpApplicationHostState extends State<_KlpApplicationHost> with WidgetsBindingObserver {

	late final _KlpApplicationSession _session;
	KlpSubscription? _subscription;
	int _sourceGeneration = 0;

	@override
	void initState() {
		super.initState();
		_session = _KlpApplicationSession(
			onChanged: _changed,
			onAsyncError: _reportError,
			onRouteInformationChanged: _reportRouteInformation,
		);
		WidgetsBinding.instance.addObserver(this);
		try {
			_subscribe();
			_accept(widget.source.value);
		}
		catch (error, stackTrace) {
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

	void _reportError(Object error, StackTrace stack) {
		FlutterError.reportError(FlutterErrorDetails(exception: error, stack: stack, library: 'kallopis application'));
	}

	void _reportRouteInformation(Uri uri, bool replace) {
		unawaited(
			SystemNavigator.routeInformationUpdated(uri: uri, replace: replace).catchError((Object error, StackTrace stack) {
				_reportError(error, stack);
			}),
		);
	}

	void _receive(KlpApplication application) {
		try {
			_accept(application);
		}
		finally {
			if (mounted) setState(() {});
		}
	}

	void _accept(KlpApplication application) => _session.accept(application);

	@override
	Future<bool> didPopRoute() => _session.handleBack();

	@override
	Future<bool> didPushRouteInformation(RouteInformation routeInformation) async {
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
		}
		catch (error, stackTrace) {
			// 更新生命週期需完成重建，錯誤交由框架報告而非摧毀已提交的宿主。
			FlutterError.reportError(FlutterErrorDetails(exception: error, stack: stackTrace, library: 'kallopis application'));
		}
	}

	@override
	Widget build(BuildContext context) {
		final frame = _session.frame;
		if (frame == null) {
			if (_session.isPending) return const SizedBox.expand();

			return ErrorWidget(_session.startupError ?? StateError('Application has no committed presentation.'));
		}

		final background = _background(frame.content);
		final environment = _environment();
		return WidgetsApp(
			title: _session.title,
			color: Color.fromARGB(background.alpha, background.red, background.green, background.blue),
			debugShowCheckedModeBanner: false,
			builder: (context, child) {
				final media = MediaQuery.maybeOf(context);
				final rendered = KlpFlutterRenderer(key: ValueKey(frame.rootId), content: frame.content);
				if (media == null) return rendered;
				return MediaQuery(
					data: media.copyWith(disableAnimations: environment.motion == KlpMotionPolicy.immediate),
					child: TickerMode(enabled: environment.motion != KlpMotionPolicy.immediate, child: rendered),
				);
			},
		);
	}

	KlpApplicationEnvironment _environment() {
		final features = WidgetsBinding.instance.platformDispatcher.accessibilityFeatures;
		return KlpApplicationEnvironment._(
			platform: switch (KlpPlatformInfo.current().platform) {
				KlpAppPlatform.android => KlpApplicationPlatform.android,
				KlpAppPlatform.ios => KlpApplicationPlatform.ios,
				KlpAppPlatform.windows => KlpApplicationPlatform.windows,
				KlpAppPlatform.macos => KlpApplicationPlatform.macos,
				KlpAppPlatform.linux => KlpApplicationPlatform.linux,
				KlpAppPlatform.web => KlpApplicationPlatform.web,
				KlpAppPlatform.other => KlpApplicationPlatform.other,
			},
			accessibility: KlpAccessibilityPreferences._(
				accessibleNavigation: features.accessibleNavigation,
				boldText: features.boldText,
				highContrast: features.highContrast,
			),
			motion: features.disableAnimations
				? KlpMotionPolicy.immediate
				: features.reduceMotion
					? KlpMotionPolicy.reduced
					: KlpMotionPolicy.standard,
		);
	}

	KlpColor _background(KlpBoundTemplate content) {
		// 直接沿已提交的目前頁取得同一份表面風格，避免應用根另存預設值。
		while (true) {
			switch (content) {
				case KlpBoundPlacement value: content = value.content;
				case KlpBoundScreen value: content = value.child;
				case KlpBoundRetainedStack value: content = value.pages.singleWhere((page) => page.id == value.activeId);
				case KlpBoundSurface value: return value.background;
				default: throw StateError('Committed screen has no surface.');
			}
		}
	}

	@override
	void dispose() {
		_sourceGeneration++;
		klpRunLifecycleActions([() => WidgetsBinding.instance.removeObserver(this), () => _subscription?.cancel(), _session.dispose, super.dispose]);
	}
}
