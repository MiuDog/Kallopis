import 'package:flutter/widgets.dart';

import '../../../../../styling/legacy_theme/klp_theme.dart';

/// Pane 協調器可選用的 theme breakpoint。
enum KlpResponsivePaneBreakpoint {
	primary,
	content,
	standard,
	secondary;

	double resolve(BuildContext context) => switch (this) {
		KlpResponsivePaneBreakpoint.primary =>
			context.klp.geometry.layout.primaryPaneBreakpoint,
		KlpResponsivePaneBreakpoint.content =>
			context.klp.geometry.layout.primaryPaneContentBreakpoint,
		KlpResponsivePaneBreakpoint.standard =>
			context.klp.geometry.layout.responsivePaneBreakpoint,
		KlpResponsivePaneBreakpoint.secondary =>
			context.klp.geometry.layout.secondaryPaneBreakpoint,
	};
}
