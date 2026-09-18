part of '../structure/klp_application.dart';

/// 唯一應用宿主使用的無狀態環境採樣器；不增加訂閱或快取。
final class _KlpApplicationEnvironmentObserver {

	const _KlpApplicationEnvironmentObserver();

	KlpEnvironmentSnapshot observe({Size? viewportSize}) {
		// 採樣 Flutter 平台與當次網址，將推導責任交給純能力快照。
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
				// 非瀏覽器環境或網址不可讀時沿用原空參數回退。
				queryParameters = Uri.base.queryParameters;
			}
			catch (_) {
				// 保留原網址讀取失敗的預設行為。
			}
		}
		return KlpEnvironmentSnapshot.resolve(
			platform: platform,
			isWebRuntime: kIsWeb,
			width: viewportSize?.width,
			height: viewportSize?.height,
			queryParameters: queryParameters,
		);
	}

	KlpApplicationEnvironment environment(KlpEnvironmentSnapshot snapshot) {
		// 從同一個 dispatcher 採樣視覺與輔助偏好，避免建立第二份環境權威。
		final dispatcher = WidgetsBinding.instance.platformDispatcher;
		final features = dispatcher.accessibilityFeatures;
		var motion = KlpMotionPolicy.standard;
		if (features.disableAnimations) {
			motion = KlpMotionPolicy.immediate;
		}
		else if (features.reduceMotion) {
			motion = KlpMotionPolicy.reduced;
		}
		return KlpApplicationEnvironment._(
			platform: switch (snapshot.platform) {
				KlpAppPlatform.android => KlpApplicationPlatform.android,
				KlpAppPlatform.ios => KlpApplicationPlatform.ios,
				KlpAppPlatform.windows => KlpApplicationPlatform.windows,
				KlpAppPlatform.macos => KlpApplicationPlatform.macos,
				KlpAppPlatform.linux => KlpApplicationPlatform.linux,
				KlpAppPlatform.web => KlpApplicationPlatform.web,
				KlpAppPlatform.other => KlpApplicationPlatform.other,
			},
			appearance: dispatcher.platformBrightness == Brightness.dark ? KlpApplicationAppearance.dark : KlpApplicationAppearance.light,
			accessibility: KlpAccessibilityPreferences._(accessibleNavigation: features.accessibleNavigation, boldText: features.boldText, highContrast: features.highContrast),
			motion: motion,
		);
	}
}
