import 'package:flutter/widgets.dart';

import '../../../../styling/legacy_theme/klp_theme.dart';
import '../panel/klp_panel_frame.dart';

/// Workbench 左側導覽區域：並排獨立的 Rail 與 Sidebar surface。
///
/// 本層只決定兩個同層區域的寬度與間距；完整的 Panel Tree 由 Dock layout 擁有。
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
				SizedBox(width: context.klp.space.chromeGap),
				Expanded(child: sidebar),
			],
		);
	}
}

/// Workbench Rail 的獨立表面。
class KlpNavigationRailFrame extends KlpPanelFrame {
	const KlpNavigationRailFrame({super.key, required Widget child})
		: super(content: child);
}
