import 'package:flutter/foundation.dart';

import 'klp_app_platform.dart';

/// 由 Kallopis 環境 scope 注入子樹的執行平台資訊。
@immutable
class KlpPlatformInfo {
	const KlpPlatformInfo({required this.platform});

	factory KlpPlatformInfo.current() {
		if (kIsWeb) return const KlpPlatformInfo(platform: KlpAppPlatform.web);
		return KlpPlatformInfo(
			platform: switch (defaultTargetPlatform) {
				TargetPlatform.android => KlpAppPlatform.android,
				TargetPlatform.iOS => KlpAppPlatform.ios,
				TargetPlatform.windows => KlpAppPlatform.windows,
				TargetPlatform.macOS => KlpAppPlatform.macos,
				TargetPlatform.linux => KlpAppPlatform.linux,
				TargetPlatform.fuchsia => KlpAppPlatform.other,
			},
		);
	}

	final KlpAppPlatform platform;
	bool get isAndroid => platform == KlpAppPlatform.android;
	bool get isWindows => platform == KlpAppPlatform.windows;
	bool get isDesktop => platform == KlpAppPlatform.windows || platform == KlpAppPlatform.macos || platform == KlpAppPlatform.linux;
	bool get isMobile => platform == KlpAppPlatform.android || platform == KlpAppPlatform.ios;
}
