part of '../klp_tri_state_toggle.dart';

class KlpTriStateToggle extends StatelessWidget {
	const KlpTriStateToggle({super.key, required this.value, required this.label, required this.onChanged});

	final KlpTriState value;
	final String label;
	final ValueChanged<KlpTriState>? onChanged;

	@override
	Widget build(BuildContext context) {
		return KlpRow(
			mainAxisSize: MainAxisSize.min,
			crossAxisAlignment: CrossAxisAlignment.center,
			children: [
				KlpSlidingSelection(
					label: label,
					selectedIndex: value.index,
					options: const [
						KlpSelectionOption(icon: KlpIcons.x, tone: KlpSelectionTone.danger),
						KlpSelectionOption(icon: KlpIcons.minus, tone: KlpSelectionTone.warning),
						KlpSelectionOption(icon: KlpIcons.check, tone: KlpSelectionTone.success),
					],
					onSelected: onChanged == null ? null : (index) => onChanged!(KlpTriState.values[index]),
				),
				const KlpGap.widthSize(KlpSpaceSize.contentInline),
				KlpText(label, tone: onChanged == null ? KlpTextTone.faint : KlpTextTone.primary),
			],
		);
	}
}
