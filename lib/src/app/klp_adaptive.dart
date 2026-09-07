import 'package:flutter/widgets.dart';

import 'klp_app.dart';
import 'klp_environment_scope.dart';
import 'klp_platform_info.dart';
import '../shell/panel/klp_panel_layout.dart';

typedef KlpAdaptiveBuilder = KlpPanelLayout Function(BuildContext context);

/// 依 [KlpApp] 注入的平台選擇呈現分支。
///
/// 只處理平台差異，不依據視窗尺寸切換平台策略。分支內部可自行處理
/// 該平台的空間限制。
class KlpAdaptive extends StatelessWidget implements KlpPanelLayout {
	const KlpAdaptive({
		super.key,
		required this.windows,
		required this.android,
		this.other,
	});

	final KlpAdaptiveBuilder windows;
	final KlpAdaptiveBuilder android;
	final KlpAdaptiveBuilder? other;

	@override
	Widget build(BuildContext context) {
		final platform =
				KlpEnvironmentScope.maybeOf(context) ?? KlpAppScope.platformOf(context);
		return switch (platform.platform) {
			KlpAppPlatform.windows => windows(context),
			KlpAppPlatform.android => android(context),
			_ => other?.call(context) ?? windows(context),
		};
	}

	@override
	Widget buildPanelLayout(BuildContext context) => build(context);
}
