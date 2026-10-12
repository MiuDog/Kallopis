import 'klp_adaptive_mode.dart';
import 'klp_app_platform.dart';
import 'klp_device_class.dart';
import 'klp_display_mode.dart';
import 'klp_orientation.dart';

/// 由宿主採樣後解析的純環境快照。
final class KlpEnvironmentSnapshot {
	final KlpAppPlatform platform;
	final KlpDeviceClass deviceClass;
	final KlpOrientation orientation;
	final KlpDisplayMode displayMode;
	final String adaptiveMode;
	final bool isWebRuntime;

	const KlpEnvironmentSnapshot({
		required this.platform,
		this.deviceClass = KlpDeviceClass.desktop,
		this.orientation = KlpOrientation.landscape,
		this.displayMode = KlpDisplayMode.browser,
		this.adaptiveMode = '',
		required this.isWebRuntime,
	});

	factory KlpEnvironmentSnapshot.resolve({
		required KlpAppPlatform platform,
		required bool isWebRuntime,
		double? width,
		double? height,
		Map<String, String> queryParameters = const {},
	}) {
		final isMobileOs =
			platform == KlpAppPlatform.android || platform == KlpAppPlatform.ios;
		var deviceClass = !isWebRuntime && isMobileOs
			? KlpDeviceClass.phone
			: KlpDeviceClass.desktop;
		var orientation = KlpOrientation.landscape;
		var displayMode = isWebRuntime
			? KlpDisplayMode.browser
			: KlpDisplayMode.nativeApp;
		String? forcedMode;
		if (isWebRuntime) {
			final mode = queryParameters['mode']?.trim();
			final simulation = queryParameters['simulate']?.toLowerCase().trim();
			if (queryParameters['display'] == 'standalone') {
				displayMode = KlpDisplayMode.standalone;
			}
			if (mode != null && mode.isNotEmpty) {
				forcedMode = mode;
				if (mode.contains('tablet')) deviceClass = KlpDeviceClass.tablet;
				if (mode.contains('phone') || mode.contains('mobile')) {
					deviceClass = KlpDeviceClass.phone;
				}
			}
			else if (simulation == 'ipad' || simulation == 'tablet') {
				deviceClass = KlpDeviceClass.tablet;
			}
			else if (simulation == 'iphone' ||
				simulation == 'mobile' ||
				simulation == 'phone') {
				deviceClass = KlpDeviceClass.phone;
			}
		}

		if (width != null && height != null && width > 0 && height > 0) {
			orientation = width >= height
				? KlpOrientation.landscape
				: KlpOrientation.portrait;
			final shortestSide = width < height ? width : height;
			if (isWebRuntime && forcedMode == null) {
				deviceClass = shortestSide < 600
					? KlpDeviceClass.phone
					: shortestSide < 1024
						? KlpDeviceClass.tablet
						: KlpDeviceClass.desktop;
			}
			else if (!isWebRuntime && isMobileOs && shortestSide >= 600) {
				deviceClass = KlpDeviceClass.tablet;
			}
		}

		return KlpEnvironmentSnapshot(
			platform: isWebRuntime ? KlpAppPlatform.web : platform,
			deviceClass: deviceClass,
			orientation: orientation,
			displayMode: displayMode,
			adaptiveMode: forcedMode ?? '',
			isWebRuntime: isWebRuntime,
		);
	}

	String get effectiveAdaptiveMode => adaptiveMode.isNotEmpty
		? adaptiveMode
		: KlpAdaptiveMode.resolveDefault(
			deviceClass: deviceClass,
			orientation: orientation,
		);
	bool get isAndroid => platform == KlpAppPlatform.android;
	bool get isWindows => platform == KlpAppPlatform.windows;
	bool get isDesktop => deviceClass == KlpDeviceClass.desktop ||
		(!isWebRuntime &&
			(platform == KlpAppPlatform.windows ||
				platform == KlpAppPlatform.macos ||
				platform == KlpAppPlatform.linux));
	bool get isMobile => deviceClass == KlpDeviceClass.phone ||
		(!isWebRuntime &&
			(platform == KlpAppPlatform.android || platform == KlpAppPlatform.ios));
	bool get isTablet => deviceClass == KlpDeviceClass.tablet;
}
