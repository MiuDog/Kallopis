import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/kallopis_foundation.dart' as stable;
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_workspace_block.dart';
import 'package:kallopis/src/rendering/flutter/klp_viewport_capabilities.dart';

import 'support/klp_environment_host_fixture.dart';

void main() {
	tearDown(() => debugDefaultTargetPlatformOverride = null);

	test('Stable constructor keeps defaults and runtime-sensitive manual getters', () {
		const info = stable.KlpPlatformInfo(platform: stable.KlpAppPlatform.android);
		expect(info.deviceClass, KlpDeviceClass.desktop);
		expect(info.orientation, KlpOrientation.landscape);
		expect(info.displayMode, KlpDisplayMode.browser);
		expect(info.adaptiveMode, '');
		expect(info.effectiveAdaptiveMode, KlpAdaptiveMode.desktop);
		expect(info.isAndroid, isTrue);
		expect(info.isWindows, isFalse);
		expect(info.isDesktop, isTrue);
		expect(info.isMobile, !kIsWeb);
		const windows = stable.KlpPlatformInfo(platform: stable.KlpAppPlatform.windows, deviceClass: KlpDeviceClass.tablet, adaptiveMode: '  ');
		expect(windows.effectiveAdaptiveMode, '  ');
		expect(windows.isWindows, isTrue);
		expect(windows.isTablet, isTrue);
		expect(windows.isDesktop, !kIsWeb);
		expect(windows.isMobile, isFalse);
	});

	for (final pair in [(TargetPlatform.android, stable.KlpAppPlatform.android), (TargetPlatform.iOS, stable.KlpAppPlatform.ios), (TargetPlatform.windows, stable.KlpAppPlatform.windows), (TargetPlatform.macOS, stable.KlpAppPlatform.macos), (TargetPlatform.linux, stable.KlpAppPlatform.linux), (TargetPlatform.fuchsia, stable.KlpAppPlatform.other)]) {
		test('Stable current maps ${pair.$1.name} and preserves optional viewport', () {
			debugDefaultTargetPlatformOverride = pair.$1;
			final initial = stable.KlpPlatformInfo.current();
			final sized = stable.KlpPlatformInfo.current(viewportSize: const Size(600, 900));
			final mobile = pair.$1 == TargetPlatform.android || pair.$1 == TargetPlatform.iOS;
			expect(initial.platform, pair.$2);
			expect(initial.deviceClass, mobile ? KlpDeviceClass.phone : KlpDeviceClass.desktop);
			expect(initial.orientation, KlpOrientation.landscape);
			expect(sized.platform, pair.$2);
			expect(sized.deviceClass, mobile ? KlpDeviceClass.tablet : KlpDeviceClass.desktop);
			expect(sized.orientation, KlpOrientation.portrait);
			expect(sized.displayMode, KlpDisplayMode.nativeApp);
		}, skip: kIsWeb);
	}

	testWidgets('real host samples null on init and source update, logical view on postframe and metrics', (tester) async {
		// 物理尺寸必須除以倍率；600 是手機轉平板的邊界。
		tester.view.devicePixelRatio = 2;
		tester.view.physicalSize = const Size(1400, 1200);
		addTearDown(tester.view.resetPhysicalSize);
		addTearDown(tester.view.resetDevicePixelRatio);
		final fixture = KlpEnvironmentHostFixture();
		final source = KlpMutableState(fixture.application());
		addTearDown(source.dispose);
		runKlpApp(source.readOnly);
		await tester.pump();
		await tester.pump();
		expect(fixture.observations.first.deviceClass, KlpDeviceClass.phone);
		expect(fixture.observations.first.orientation, KlpOrientation.landscape);
		expect(fixture.observations.last.deviceClass, KlpDeviceClass.tablet);
		expect(fixture.observations.last.displayMode, KlpDisplayMode.nativeApp);
		var viewport = tester.widget<KlpViewportCapabilities>(find.byType(KlpViewportCapabilities));
		expect(viewport.adaptiveMode, KlpAdaptiveMode.tabletLandscape);
		expect(viewport.desktop, isFalse);
		expect(viewport.nativeWindows, isFalse);

		// 已採樣的大畫面不能取代來源更新事件原有的空 viewport。
		fixture.observations.clear();
		source.value = fixture.application(title: 'Updated');
		expect(fixture.observations, isNotEmpty);
		expect(fixture.observations.last.deviceClass, KlpDeviceClass.phone);
		await tester.pump();
		viewport = tester.widget<KlpViewportCapabilities>(find.byType(KlpViewportCapabilities));
		expect(viewport.adaptiveMode, KlpAdaptiveMode.tabletLandscape);
		expect(tester.widget<WidgetsApp>(find.byType(WidgetsApp)).title, 'Updated');

		// 尺寸事件改用當下 view，旋轉與形態都必須重新判定。
		tester.view.physicalSize = const Size(1198, 1800);
		await tester.pump();
		expect(fixture.observations.last.deviceClass, KlpDeviceClass.phone);
		expect(fixture.observations.last.orientation, KlpOrientation.portrait);
		expect(tester.widget<KlpViewportCapabilities>(find.byType(KlpViewportCapabilities)).adaptiveMode, KlpAdaptiveMode.phone);
		tester.view.physicalSize = const Size(1200, 1800);
		await tester.pump();
		expect(fixture.observations.last.deviceClass, KlpDeviceClass.tablet);
		expect(fixture.observations.last.orientation, KlpOrientation.portrait);
		expect(tester.widget<KlpViewportCapabilities>(find.byType(KlpViewportCapabilities)).adaptiveMode, KlpAdaptiveMode.tabletPortrait);

		// 零倍率事件必須當作未知尺寸，不能沿用先前平板快照。
		fixture.observations.clear();
		tester.view.devicePixelRatio = 0;
		expect(fixture.observations, isNotEmpty);
		expect(fixture.observations.last.deviceClass, KlpDeviceClass.phone);
		expect(fixture.observations.last.orientation, KlpOrientation.landscape);
		tester.view.devicePixelRatio = 2;
		await tester.pump();

		await tester.pumpWidget(const SizedBox.shrink());
		fixture.observations.clear();
		source.value = fixture.application(title: 'After disposal');
		tester.view.physicalSize = const Size(1000, 1000);
		await tester.pump();
		expect(fixture.observations, isEmpty);
		expect(source.isDisposed, isFalse);
		expect(tester.takeException(), isNull);
	}, skip: kIsWeb);

	testWidgets('real host maps platform consistently into strategy and viewport', (tester) async {
		final fixture = KlpEnvironmentHostFixture();
		final source = KlpMutableState(fixture.application());
		addTearDown(source.dispose);
		runKlpApp(source.readOnly);
		await tester.pump();
		await tester.pump();
		final expected = switch (defaultTargetPlatform) {
			TargetPlatform.android => KlpAdaptivePlatform.android,
			TargetPlatform.iOS => KlpAdaptivePlatform.ios,
			TargetPlatform.windows => KlpAdaptivePlatform.windows,
			TargetPlatform.macOS => KlpAdaptivePlatform.macos,
			TargetPlatform.linux => KlpAdaptivePlatform.linux,
			TargetPlatform.fuchsia => KlpAdaptivePlatform.other,
		};
		expect(fixture.observations, isNotEmpty);
		expect(fixture.observations.map((context) => context.platform), everyElement(expected));
		final viewport = tester.widget<KlpViewportCapabilities>(find.byType(KlpViewportCapabilities));
		expect(viewport.nativeWindows, expected == KlpAdaptivePlatform.windows);
		expect(viewport.desktop, expected != KlpAdaptivePlatform.android && expected != KlpAdaptivePlatform.ios);
		await tester.pumpWidget(const SizedBox.shrink());
		expect(tester.takeException(), isNull);
	}, variant: TargetPlatformVariant(TargetPlatform.values.toSet()), skip: kIsWeb);

	testWidgets('platform brightness reprojects the current application with an owned preset', (tester) async {
		final fixture = KlpEnvironmentHostFixture();
		final source = KlpMutableState(fixture.application());
		addTearDown(source.dispose);
		addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
		tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
		runKlpApp(source.readOnly);
		await tester.pump();
		await tester.pump();
		final light = tester.widget<WidgetsApp>(find.byType(WidgetsApp)).color;
		final title = tester.widget<WidgetsApp>(find.byType(WidgetsApp)).title;

		// 平台亮度事件只重新投影同一份應用，不要求 consumer 提供 theme 或重送來源。
		tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
		await tester.pump();
		final dark = tester.widget<WidgetsApp>(find.byType(WidgetsApp)).color;
		expect(dark, isNot(light));
		expect(tester.widget<WidgetsApp>(find.byType(WidgetsApp)).title, title);
		expect(source.value.title, title);
		expect(tester.takeException(), isNull);
	});

	testWidgets('accessibility transitions preserve installed content, focus and action ownership', (tester) async {
		final fixture = KlpEnvironmentHostFixture();
		final source = KlpMutableState(fixture.application());
		addTearDown(source.dispose);
		addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
		runKlpApp(source.readOnly);
		await tester.pump();
		await tester.pump();
		await tester.tap(find.byType(KlpFlutterWorkspaceBlock));
		await tester.pump();
		final focus = FocusManager.instance.primaryFocus;
		final content = tester.widget<KlpFlutterWorkspaceBlock>(find.byType(KlpFlutterWorkspaceBlock)).content;
		fixture.observations.clear();

		// 同時設定兩個動態偏好，驗證 disableAnimations 優先且能復原。
		for (final flags in [const FakeAccessibilityFeatures(accessibleNavigation: true, boldText: true, highContrast: true, disableAnimations: true, reduceMotion: true), const FakeAccessibilityFeatures(reduceMotion: true), const FakeAccessibilityFeatures()]) {
			tester.platformDispatcher.accessibilityFeaturesTestValue = flags;
			await tester.pump();
			final context = tester.element(find.byType(KlpFlutterWorkspaceBlock));
			final media = MediaQuery.of(context);
			expect(media.disableAnimations, flags.disableAnimations);
			expect(media.accessibleNavigation, flags.accessibleNavigation);
			expect(media.boldText, flags.boldText);
			expect(media.highContrast, flags.highContrast);
			expect(TickerMode.valuesOf(context).enabled, !flags.disableAnimations);
			expect(tester.widget<KlpFlutterWorkspaceBlock>(find.byType(KlpFlutterWorkspaceBlock)).content, same(content));
			expect(FocusManager.instance.primaryFocus, same(focus));
			expect(fixture.observations, isEmpty);
		}
		content.onPressed!();
		expect(fixture.activations, 2);
		await tester.pumpWidget(const SizedBox.shrink());
		content.onPressed!();
		expect(fixture.activations, 2);
		expect(source.isDisposed, isFalse);
		expect(tester.takeException(), isNull);
	});
}
