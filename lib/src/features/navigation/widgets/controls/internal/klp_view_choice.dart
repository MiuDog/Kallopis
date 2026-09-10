part of '../klp_view_switcher.dart';

class _KlpViewChoice extends StatelessWidget {
	const _KlpViewChoice({
		required this.option,
		required this.selected,
		required this.onPressed,
	});

	final KlpViewOption option;
	final bool selected;
	final VoidCallback? onPressed;

	@override
	Widget build(BuildContext context) {
		return KlpGestureRegion(
			behavior: HitTestBehavior.opaque,
			onTap: onPressed,
			child: _KlpViewChoiceFrame(
				selected: selected,
				child: KlpRow(
					mainAxisSize: MainAxisSize.min,
					children: [
						if (option.icon != null) ...[
							KlpIcon(
								option.icon!,
								size: context.klp.space.iconSmall,
							),
							const KlpGap.widthSize(KlpSpaceSize.tight),
						],
						KlpText(
							option.label,
							role: KlpTextRole.caption,
							tone: selected ? KlpTextTone.primary : KlpTextTone.muted,
						),
					],
				),
			),
		);
	}
}
