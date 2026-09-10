import 'package:flutter/widgets.dart';

import '../platform/klp_app_platform.dart';
import '../platform/klp_environment_scope.dart';
import '../platform/klp_platform_info.dart';
import 'klp_adaptive_builder.dart';
import 'klp_panel_layout.dart';

/// 依明確覆寫、[KlpEnvironmentScope] 或實際執行平台選擇呈現分支。
///
/// 只處理平台差異，不依據視窗尺寸切換平台策略。分支內部可自行處理
/// 該平台的空間限制。
class KlpAdaptive extends StatelessWidget implements KlpPanelLayout {
	const KlpAdaptive({
		super.key,
		required this.windows,
		required this.android,
		this.platform,
		this.macos,
		this.linux,
		this.ios,
		this.other,
	});

	final KlpAdaptiveBuilder windows;
	final KlpAdaptiveBuilder android;
	final KlpAppPlatform? platform;
	final KlpAdaptiveBuilder? macos;
	final KlpAdaptiveBuilder? linux;
	final KlpAdaptiveBuilder? ios;
	final KlpAdaptiveBuilder? other;

	@override
	Widget build(BuildContext context) {
		final detectedPlatform = platform ?? KlpEnvironmentScope.maybeOf(context)?.platform ?? KlpPlatformInfo.current().platform;
		return switch (detectedPlatform) {
			KlpAppPlatform.windows => windows(context),
			KlpAppPlatform.android => android(context),
			KlpAppPlatform.macos => (macos ?? other ?? windows)(context),
			KlpAppPlatform.linux => (linux ?? other ?? windows)(context),
			KlpAppPlatform.ios => (ios ?? other ?? windows)(context),
			_ => other?.call(context) ?? windows(context),
		};
	}

	@override
	Widget buildPanelLayout(BuildContext context) => build(context);
}
