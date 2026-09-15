import 'dart:ui' show Size;
import 'package:flutter/foundation.dart';

import 'package:kallopis/src/capabilities/environment/klp_environment_snapshot.dart';
import 'klp_app_platform.dart';
import 'klp_device_class.dart';
import 'klp_display_mode.dart';
import 'klp_orientation.dart';

/// 由 Kallopis 環境 scope 注入子樹的執行平台與自適應環境資訊。
@immutable
class KlpPlatformInfo {

	final KlpAppPlatform platform;
	final KlpDeviceClass deviceClass;
	final KlpOrientation orientation;
	final KlpDisplayMode displayMode;
	final String adaptiveMode;

	const KlpPlatformInfo({
		required this.platform,
		this.deviceClass = KlpDeviceClass.desktop,
		this.orientation = KlpOrientation.landscape,
		this.displayMode = KlpDisplayMode.browser,
		this.adaptiveMode = '',
	});

	/// 初始環境解析：支援 Web 尺寸、模擬參數與原生平台。
	factory KlpPlatformInfo.current({Size? viewportSize}) {
		// 採樣 Flutter 平台及網址；所有環境推導由能力層負責。
		var platform = KlpAppPlatform.web;
		if (!kIsWeb) {
			platform = switch (defaultTargetPlatform) {
				TargetPlatform.android => KlpAppPlatform.android,
				TargetPlatform.iOS => KlpAppPlatform.ios,
				TargetPlatform.windows => KlpAppPlatform.windows,
				TargetPlatform.macOS => KlpAppPlatform.macos,
				TargetPlatform.linux => KlpAppPlatform.linux,
				TargetPlatform.fuchsia => KlpAppPlatform.other,
			};
		}
		var queryParameters = const <String, String>{};
		if (kIsWeb) {
			try {
				// 非瀏覽器環境或網址不可讀時維持原空參數回退。
				queryParameters = Uri.base.queryParameters;
			}
			catch (_) {
				// 保留原網址讀取失敗的預設行為。
			}
		}
		final snapshot = KlpEnvironmentSnapshot.resolve(
			platform: platform,
			isWebRuntime: kIsWeb,
			width: viewportSize?.width,
			height: viewportSize?.height,
			queryParameters: queryParameters,
		);
		return KlpPlatformInfo(
			platform: snapshot.platform,
			deviceClass: snapshot.deviceClass,
			orientation: snapshot.orientation,
			displayMode: snapshot.displayMode,
			adaptiveMode: snapshot.adaptiveMode,
		);
	}

	KlpEnvironmentSnapshot get _snapshot => KlpEnvironmentSnapshot(
		platform: platform,
		deviceClass: deviceClass,
		orientation: orientation,
		displayMode: displayMode,
		adaptiveMode: adaptiveMode,
		isWebRuntime: kIsWeb,
	);

	String get effectiveAdaptiveMode => _snapshot.effectiveAdaptiveMode;
	bool get isAndroid => _snapshot.isAndroid;
	bool get isWindows => _snapshot.isWindows;
	bool get isDesktop => _snapshot.isDesktop;
	bool get isMobile => _snapshot.isMobile;
	bool get isTablet => _snapshot.isTablet;
}
