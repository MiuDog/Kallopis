import 'package:flutter/widgets.dart';

import '../../controls/button/klp_button.dart';
import '../../surface/klp_dashed_border.dart';
import '../../surface/klp_surface.dart';
import '../../theme/klp_theme.dart';
import '../../typography/klp_text.dart';
import '../../interaction/klp_pressable.dart';
import 'klp_filter_models.dart';

/// 批次選取浮動／固定操作列。
class KlpSelectionToolbar extends StatelessWidget {
	const KlpSelectionToolbar({
		super.key,
		required this.count,
		required this.countLabel,
		required this.actions,
		this.onClear,
		this.clearLabel = 'Clear',
		this.dashed = true,
	});

	final int count;
	final String countLabel;
	final List<KlpSelectionAction> actions;
	final VoidCallback? onClear;
	final String? clearLabel;
	final bool dashed;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		Widget content = KlpSurface(
			tone: KlpSurfaceTone.component,
			padding: EdgeInsets.symmetric(
				horizontal: klp.space.base,
				vertical: klp.space.controlInset,
			),
			child: Row(
				children: [
					KlpText(countLabel, role: KlpTextRole.caption, tone: KlpTextTone.muted),
					SizedBox(width: klp.space.base),
					for (final action in actions) ...[
						KlpButton(
							label: action.label,
							compact: true,
							tone: action.danger ? KlpButtonTone.danger : KlpButtonTone.ghost,
							onPressed: action.onPressed,
						),
						SizedBox(width: klp.space.actionGap),
					],
					const Spacer(),
					if (onClear != null && clearLabel != null)
						KlpPressable(
							onPressed: onClear,
							borderRadius: BorderRadius.circular(klp.shape.control),
							child: Padding(
								padding: EdgeInsets.symmetric(
									horizontal: klp.space.controlInset,
									vertical: klp.space.hairline,
								),
								child: KlpText(
									clearLabel!,
									role: KlpTextRole.caption,
									tone: KlpTextTone.muted,
								),
							),
						),
				],
			),
		);
		return dashed ? KlpDashedBorder(radius: klp.shape.card, child: content) : content;
	}
}
