import 'package:flutter/widgets.dart';

import '../surface/klp_dashed_border.dart';
import '../../styling/legacy_theme/klp_theme.dart';
import 'klp_expanded.dart';
import 'klp_gap.dart';
import 'klp_row.dart';
import 'klp_space_size.dart';
import 'klp_split_pane_size.dart';

part 'primitives/klp_split_divider_frame.dart';
part 'primitives/klp_split_pane_frame.dart';

/// 分割版面元件。支援左／中／右或左右分割，以及虛線分隔線。
class KlpSplitLayout extends StatelessWidget {
	const KlpSplitLayout({
		super.key,
		required this.leading,
		required this.trailing,
		this.center,
		this.leadingSize = KlpSplitPaneSize.primary,
		this.trailingSize,
		this.gapSize = KlpSpaceSize.base,
		this.showDashedDivider = false,
	});

	final Widget leading;
	final Widget trailing;
	final Widget? center;
	final KlpSplitPaneSize leadingSize;
	final KlpSplitPaneSize? trailingSize;
	final KlpSpaceSize gapSize;
	final bool showDashedDivider;

	@override
	Widget build(BuildContext context) {
		return KlpRow(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				_KlpSplitPaneFrame(
					size: leadingSize,
					child: leading,
				),
				_KlpSplitDividerFrame(
					gapSize: gapSize,
					showDashedDivider: showDashedDivider,
				),
				KlpExpanded(child: center ?? trailing),
				if (center != null) ...[
					_KlpSplitDividerFrame(
						gapSize: gapSize,
						showDashedDivider: showDashedDivider,
					),
					_KlpSplitPaneFrame(
						size: trailingSize ?? leadingSize,
						child: trailing,
					),
				],
			],
		);
	}
}
