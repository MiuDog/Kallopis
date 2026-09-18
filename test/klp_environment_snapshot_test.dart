import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/capabilities/environment/klp_adaptive_mode.dart' as canonical;
import 'package:kallopis/src/capabilities/environment/klp_app_platform.dart' as canonical;
import 'package:kallopis/src/capabilities/environment/klp_environment_snapshot.dart';
import 'package:kallopis/src/foundation/platform/klp_adaptive_mode.dart';
import 'package:kallopis/src/foundation/platform/klp_app_platform.dart';
import 'package:kallopis/src/foundation/platform/klp_device_class.dart';
import 'package:kallopis/src/foundation/platform/klp_display_mode.dart';
import 'package:kallopis/src/foundation/platform/klp_orientation.dart';

void main() {
	test('moved environment types retain identity, enum order and adaptive constants', () {
		expect(KlpAppPlatform.values.map((value) => value.name), ['android', 'ios', 'windows', 'macos', 'linux', 'web', 'other']);
		expect(identical(KlpAppPlatform, canonical.KlpAppPlatform), isTrue);
		expect(identical(KlpAdaptiveMode, canonical.KlpAdaptiveMode), isTrue);
		expect([KlpAdaptiveMode.tabletLandscape, KlpAdaptiveMode.tabletPortrait, KlpAdaptiveMode.desktop, KlpAdaptiveMode.phone, KlpAdaptiveMode.fallback], ['tablet_landscape', 'tablet_portrait', 'desktop', 'phone', 'fallback']);
	});

	test('value constructor preserves supplied values and original defaults', () {
		const defaults = KlpEnvironmentSnapshot(platform: KlpAppPlatform.android, isWebRuntime: false);
		expect(defaults.platform, KlpAppPlatform.android);
		expect(defaults.isWebRuntime, isFalse);
		expect(defaults.deviceClass, KlpDeviceClass.desktop);
		expect(defaults.orientation, KlpOrientation.landscape);
		expect(defaults.displayMode, KlpDisplayMode.browser);
		expect(defaults.adaptiveMode, '');
		expect(defaults.effectiveAdaptiveMode, KlpAdaptiveMode.desktop);
		const manual = KlpEnvironmentSnapshot(platform: KlpAppPlatform.web, isWebRuntime: true, deviceClass: KlpDeviceClass.phone, orientation: KlpOrientation.portrait, displayMode: KlpDisplayMode.standalone, adaptiveMode: '  ');
		expect(manual.effectiveAdaptiveMode, '  ');
		expect(manual.orientation, KlpOrientation.portrait);
		expect(manual.displayMode, KlpDisplayMode.standalone);
	});

	for (final platform in KlpAppPlatform.values.where((value) => value != KlpAppPlatform.web)) {
		test('native ${platform.name} ignores web query and preserves native classification', () {
			final mobile = platform == KlpAppPlatform.android || platform == KlpAppPlatform.ios;
			final initial = KlpEnvironmentSnapshot.resolve(platform: platform, isWebRuntime: false, queryParameters: const {'mode': 'tablet_portrait', 'simulate': 'phone', 'display': 'standalone'});
			expect(initial.platform, platform);
			expect(initial.deviceClass, mobile ? KlpDeviceClass.phone : KlpDeviceClass.desktop);
			expect(initial.orientation, KlpOrientation.landscape);
			expect(initial.displayMode, KlpDisplayMode.nativeApp);
			expect(initial.adaptiveMode, '');
			for (final width in [599.0, 600.0, 1024.0]) {
				final sized = KlpEnvironmentSnapshot.resolve(platform: platform, isWebRuntime: false, width: width, height: 1500, queryParameters: const {'mode': 'phone'});
				expect(sized.deviceClass, mobile && width >= 600 ? KlpDeviceClass.tablet : initial.deviceClass);
				expect(sized.orientation, KlpOrientation.portrait);
				expect(sized.displayMode, KlpDisplayMode.nativeApp);
				expect(sized.adaptiveMode, '');
			}
		});
	}

	for (final item in [(599.999, KlpDeviceClass.phone), (600.0, KlpDeviceClass.tablet), (1023.999, KlpDeviceClass.tablet), (1024.0, KlpDeviceClass.desktop)]) {
		test('web shortest side ${item.$1} preserves exact threshold in either orientation', () {
			final portrait = _web(width: item.$1, height: 1600);
			final landscape = _web(width: 1600, height: item.$1);
			expect(portrait.deviceClass, item.$2);
			expect(landscape.deviceClass, item.$2);
			expect(portrait.orientation, KlpOrientation.portrait);
			expect(landscape.orientation, KlpOrientation.landscape);
			expect(portrait.platform, KlpAppPlatform.web);
			expect(portrait.displayMode, KlpDisplayMode.browser);
		});
	}

	test('square is landscape and infinity retains positive-dimension semantics', () {
		expect(_web(width: 600, height: 600).effectiveAdaptiveMode, KlpAdaptiveMode.tabletLandscape);
		expect(_web(width: double.infinity, height: 600).deviceClass, KlpDeviceClass.tablet);
		expect(_web(width: double.infinity, height: double.infinity).deviceClass, KlpDeviceClass.desktop);
		expect(_web(width: double.infinity, height: double.infinity).orientation, KlpOrientation.landscape);
	});

	for (final dimensions in <(double?, double?)>[(null, null), (null, 900), (700, null), (0, 900), (700, 0), (-1, 900), (700, -1), (double.nan, 900), (700, double.nan)]) {
		test('invalid dimensions $dimensions preserve defaults and simulated shape', () {
			final plain = _web(width: dimensions.$1, height: dimensions.$2);
			final simulated = _web(width: dimensions.$1, height: dimensions.$2, query: const {'simulate': 'ipad'});
			final native = KlpEnvironmentSnapshot.resolve(platform: KlpAppPlatform.android, isWebRuntime: false, width: dimensions.$1, height: dimensions.$2);
			expect(plain.deviceClass, KlpDeviceClass.desktop);
			expect(plain.orientation, KlpOrientation.landscape);
			expect(simulated.deviceClass, KlpDeviceClass.tablet);
			expect(simulated.orientation, KlpOrientation.landscape);
			expect(native.deviceClass, KlpDeviceClass.phone);
			expect(native.orientation, KlpOrientation.landscape);
		});
	}

	for (final mode in [(' tablet_portrait ', KlpDeviceClass.tablet, 'tablet_portrait'), ('phone_tablet', KlpDeviceClass.tablet, 'phone_tablet'), ('my_mobile_mode', KlpDeviceClass.phone, 'my_mobile_mode'), ('phone', KlpDeviceClass.phone, 'phone'), ('TABLET', KlpDeviceClass.desktop, 'TABLET'), ('custom', KlpDeviceClass.desktop, 'custom')]) {
		test('forced mode ${mode.$1} wins simulation and size but not orientation', () {
			final value = _web(width: 400, height: 900, query: {'mode': mode.$1, 'simulate': 'ipad'});
			expect(value.deviceClass, mode.$2);
			expect(value.adaptiveMode, mode.$3);
			expect(value.effectiveAdaptiveMode, mode.$3);
			expect(value.orientation, KlpOrientation.portrait);
		});
	}

	for (final simulation in [(' iPaD ', KlpDeviceClass.tablet), ('tablet', KlpDeviceClass.tablet), ('IPHONE', KlpDeviceClass.phone), (' mobile ', KlpDeviceClass.phone), ('phone', KlpDeviceClass.phone), ('android', KlpDeviceClass.desktop), ('ipad_pro', KlpDeviceClass.desktop)]) {
		test('simulation ${simulation.$1} normalizes exact names and valid size overrides it', () {
			final query = {'mode': ' \t ', 'simulate': simulation.$1};
			final initial = _web(query: query);
			final sized = _web(width: 1200, height: 1400, query: query);
			expect(initial.deviceClass, simulation.$2);
			expect(initial.adaptiveMode, '');
			expect(sized.deviceClass, KlpDeviceClass.desktop);
			expect(sized.effectiveAdaptiveMode, KlpAdaptiveMode.desktop);
		});
	}

	test('display requires exact standalone and each resolution reads current query', () {
		final query = {'display': 'standalone', 'mode': 'phone'};
		final first = _web(query: query);
		query['mode'] = 'tablet_landscape';
		query['display'] = 'Standalone';
		final second = _web(query: query);
		expect(first.displayMode, KlpDisplayMode.standalone);
		expect(first.effectiveAdaptiveMode, KlpAdaptiveMode.phone);
		expect(second.displayMode, KlpDisplayMode.browser);
		expect(second.effectiveAdaptiveMode, KlpAdaptiveMode.tabletLandscape);
		expect(_web(query: const {'display': ' standalone '}).displayMode, KlpDisplayMode.browser);
	});

	for (final web in [false, true]) {
		test('manual getters use explicit web runtime $web rather than process globals', () {
			final android = KlpEnvironmentSnapshot(platform: KlpAppPlatform.android, isWebRuntime: web, deviceClass: KlpDeviceClass.tablet);
			final windows = KlpEnvironmentSnapshot(platform: KlpAppPlatform.windows, isWebRuntime: web, deviceClass: KlpDeviceClass.phone);
			expect(android.isAndroid, isTrue);
			expect(android.isWindows, isFalse);
			expect(android.isMobile, !web);
			expect(android.isTablet, isTrue);
			expect(android.isDesktop, isFalse);
			expect(windows.isWindows, isTrue);
			expect(windows.isAndroid, isFalse);
			expect(windows.isDesktop, !web);
			expect(windows.isMobile, isTrue);
			expect(windows.isTablet, isFalse);
		});
	}
}

KlpEnvironmentSnapshot _web({double? width, double? height, Map<String, String> query = const {}}) => KlpEnvironmentSnapshot.resolve(platform: KlpAppPlatform.web, isWebRuntime: true, width: width, height: height, queryParameters: query);
