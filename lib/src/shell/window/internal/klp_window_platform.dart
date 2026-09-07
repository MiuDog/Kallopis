import 'package:flutter/material.dart';

import '../../../app/klp_environment_scope.dart';
import '../../../app/klp_platform_info.dart';

/// 視窗 chrome 優先採用 Kallopis 環境；缺少環境時才相容舊有 Material theme。
bool klpUsesMacOSWindowChrome(BuildContext context, {TargetPlatform? platform}) {
	if (platform != null) return platform == TargetPlatform.macOS;

	final environment = KlpEnvironmentScope.maybeOf(context);
	if (environment != null) return environment.platform == KlpAppPlatform.macos;

	return Theme.of(context).platform == TargetPlatform.macOS;
}
