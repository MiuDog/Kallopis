part of '../klp_compound_field.dart';

class _KlpCompoundFieldOption extends StatelessWidget {
	const _KlpCompoundFieldOption({
		required this.option,
		required this.onSelected,
	});

	final KlpChoiceOption option;
	final ValueChanged<String> onSelected;

	@override
	Widget build(BuildContext context) {
		return _KlpCompoundFieldOptionFrame(
			enabled: !option.disabled,
			onTap: option.disabled ? null : () => onSelected(option.id),
			child: KlpText(
				option.label,
				tone: option.disabled ? KlpTextTone.faint : KlpTextTone.primary,
			),
		);
	}
}
