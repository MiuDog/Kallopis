import 'package:flutter/widgets.dart';

import '../theme/klp_theme.dart';
import 'klp_panel_frame.dart';

/// Workbench 左側導覽區域：並排獨立的 Rail 與 Sidebar surface。
///
/// 本層只決定兩個同層區域的寬度與間距；顯示、收合與整體 resize 仍由
/// [KlpWorkbenchShell] 擁有。
class KlpWorkbenchNavigationRegion extends StatelessWidget {
	const KlpWorkbenchNavigationRegion({
		super.key,
		required this.rail,
		required this.sidebar,
	});

	final Widget rail;
	final Widget sidebar;

	@override
	Widget build(BuildContext context) {
		return Row(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				SizedBox(width: context.klp.space.chromeRail, child: rail),
				SizedBox(width: context.klp.space.compact),
				Expanded(child: sidebar),
			],
		);
	}
}

/// Workbench Rail 的獨立表面。
class KlpNavigationRailFrame extends StatelessWidget {
	const KlpNavigationRailFrame({super.key, required this.child});

	final Widget child;

	@override
	Widget build(BuildContext context) {
		return KlpPanelFrame(
			padding: EdgeInsets.zero,
			background: context.klpColors.surface,
			content: child,
		);
	}
}
