import 'package:flutter/widgets.dart';

import '../../../foundation/klp_icon.dart';
import '../../../foundation/klp_icons.dart';
import '../../../foundation/interaction/klp_gesture_region.dart';
import '../../../foundation/layout/klp_gap.dart';
import '../../../foundation/layout/klp_row.dart';
import '../../../foundation/layout/klp_space_size.dart';
import '../../../styling/legacy_theme/klp_theme.dart';
import '../../../foundation/content/klp_text.dart';

/// 顯示目前方向並將排序切換事件交還呼叫端的中性控制項。
class KlpSortControl extends StatelessWidget {
	const KlpSortControl({
		super.key,
		required this.label,
		required this.ascending,
		required this.onPressed,
		this.icon,
	});

	final String label;
	final bool ascending;
	final VoidCallback? onPressed;
	final KlpIconData? icon;

	@override
	Widget build(BuildContext context) {
		final effectiveIcon =
				icon ?? (ascending ? KlpIcons.chevronUp : KlpIcons.chevronDown);

		return KlpGestureRegion(
			behavior: HitTestBehavior.opaque,
			onTap: onPressed,
			child: KlpRow(
				mainAxisSize: MainAxisSize.min,
				children: [
					KlpText(label, role: KlpTextRole.caption),
					const KlpGap.widthSize(KlpSpaceSize.tight),
					KlpIcon(effectiveIcon, size: context.klp.space.iconSmall),
				],
			),
		);
	}
}
