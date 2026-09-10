part of '../klp_select_field.dart';

class _KlpSelectFieldOption extends StatelessWidget {
	const _KlpSelectFieldOption({
		required this.option,
		required this.onSelected,
	});

	final KlpChoiceOption option;
	final VoidCallback onSelected;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;

		return KlpGestureRegion(
			behavior: HitTestBehavior.opaque,
			onTap: option.disabled ? null : onSelected,
			child: KlpConstrainedBox(
				constraints: KlpBoxConstraints(minHeight: klp.fieldHeight),
				child: KlpAlign(
					alignment: Alignment.centerLeft,
					child: KlpBox(
						insets: KlpBoxInsets.directional(
							start: klp.space.controlInset,
							end: klp.space.controlInset,
						),
						child: KlpText(
							option.label,
							tone: option.disabled
								? KlpTextTone.faint
								: KlpTextTone.primary,
						),
					),
				),
			),
		);
	}
}
