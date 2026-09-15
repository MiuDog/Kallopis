import 'klp_adaptive_mode.dart';
import 'klp_app_platform.dart';
import 'klp_device_class.dart';
import 'klp_display_mode.dart';
import 'klp_orientation.dart';

/// 由宿主採樣後解析的純環境快照；不持有平台來源或訂閱。
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

	/// 依原平台、尺寸與網址優先序推導環境，不讀取全域來源。
	factory KlpEnvironmentSnapshot.resolve({
		required KlpAppPlatform platform,
		required bool isWebRuntime,
		double? width,
		double? height,
		Map<String, String> queryParameters = const {},
	}) {
		// 步驟 1：建立原生平台預設；只有 Web 解讀模擬參數。
		final isMobileOs = platform == KlpAppPlatform.android || platform == KlpAppPlatform.ios;
		var deviceClass = !isWebRuntime && isMobileOs ? KlpDeviceClass.phone : KlpDeviceClass.desktop;
		var orientation = KlpOrientation.landscape;
		var displayMode = isWebRuntime ? KlpDisplayMode.browser : KlpDisplayMode.nativeApp;
		String? forcedMode;
		if (isWebRuntime) {
			try {
				final modeParam = queryParameters['mode'];
				final simulateParam = queryParameters['simulate'];
				final displayParam = queryParameters['display'];
				if (displayParam == 'standalone') {
					displayMode = KlpDisplayMode.standalone;
				}
				if (modeParam != null && modeParam.trim().isNotEmpty) {
					forcedMode = modeParam.trim();
					if (forcedMode.contains('tablet')) {
						deviceClass = KlpDeviceClass.tablet;
					}
					else if (forcedMode.contains('phone') || forcedMode.contains('mobile')) {
						deviceClass = KlpDeviceClass.phone;
					}
				}
				else if (simulateParam != null) {
					final sim = simulateParam.toLowerCase().trim();
					if (sim == 'ipad' || sim == 'tablet') {
						deviceClass = KlpDeviceClass.tablet;
					}
					else if (sim == 'iphone' || sim == 'mobile' || sim == 'phone') {
						deviceClass = KlpDeviceClass.phone;
					}
				}
			}
			catch (_) {
				// 保留原解析遇到參數讀取異常時的預設及已解析值。
			}
		}

		// 步驟 2：有效尺寸決定方向，強制模式僅阻止 Web 裝置形態覆寫。
		if (width != null && height != null && width > 0 && height > 0) {
			orientation = width >= height ? KlpOrientation.landscape : KlpOrientation.portrait;
			final shortestSide = width < height ? width : height;
			if (isWebRuntime && forcedMode == null) {
				if (shortestSide < 600) {
					deviceClass = KlpDeviceClass.phone;
				}
				else if (shortestSide < 1024) {
					deviceClass = KlpDeviceClass.tablet;
				}
				else {
					deviceClass = KlpDeviceClass.desktop;
				}
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

	String get effectiveAdaptiveMode => adaptiveMode.isNotEmpty ? adaptiveMode : KlpAdaptiveMode.resolveDefault(deviceClass: deviceClass, orientation: orientation);
	bool get isAndroid => platform == KlpAppPlatform.android;
	bool get isWindows => platform == KlpAppPlatform.windows;
	bool get isDesktop => deviceClass == KlpDeviceClass.desktop || (!isWebRuntime && (platform == KlpAppPlatform.windows || platform == KlpAppPlatform.macos || platform == KlpAppPlatform.linux));
	bool get isMobile => deviceClass == KlpDeviceClass.phone || (!isWebRuntime && (platform == KlpAppPlatform.android || platform == KlpAppPlatform.ios));
	bool get isTablet => deviceClass == KlpDeviceClass.tablet;
}
