import 'package:flutter/widgets.dart';

import 'package:kallopis/src/foundation/platform/klp_device_class.dart';
import 'package:kallopis/src/foundation/platform/klp_environment_scope.dart';
import 'package:kallopis/src/foundation/platform/klp_platform_info.dart';
import 'klp_adaptive_builder.dart';
import 'klp_panel_layout.dart';

/// 依 Kallopis 裝置分類選擇 desktop、tablet 或 phone 呈現策略。
class KlpDeviceAdaptive extends StatelessWidget implements KlpPanelLayout {

	const KlpDeviceAdaptive({
		super.key,
		required this.desktop,
		required this.tablet,
		required this.phone,
	});

	final KlpAdaptiveBuilder desktop;
	final KlpAdaptiveBuilder tablet;
	final KlpAdaptiveBuilder phone;

	@override
	Widget build(BuildContext context) {
		return LayoutBuilder(
			builder: (context, constraints) {
				final environment = KlpEnvironmentScope.maybeOf(context) ?? KlpPlatformInfo.current(viewportSize: constraints.biggest);

				return switch (environment.deviceClass) {
					KlpDeviceClass.desktop => desktop(context),
					KlpDeviceClass.tablet => tablet(context),
					KlpDeviceClass.phone => phone(context),
				};
			},
		);
	}

	@override
	Widget buildPanelLayout(BuildContext context) => build(context);
}
