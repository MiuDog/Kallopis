import '../internal/klp_form_dependencies.dart';
import '../internal/klp_input_action.dart';
import '../internal/klp_input_frame.dart';
import '../internal/klp_input_segment_divider.dart';

/// 以欄位等高的減少／增加操作調整數量。
class KlpQuantityField extends StatelessWidget {
	final String label;
	final num value;
	final num step;
	final num? minimum;
	final num? maximum;
	final ValueChanged<num>? onChanged;
	final bool enabled;
	final bool readOnly;
	final String? error;
	final String? decreaseLabel;
	final String? increaseLabel;

	const KlpQuantityField({
		super.key,
		required this.label,
		required this.value,
		this.step = 1,
		this.minimum,
		this.maximum,
		this.onChanged,
		this.enabled = true,
		this.readOnly = false,
		this.error,
		this.decreaseLabel,
		this.increaseLabel,
	}) : assert(step > 0);

	bool get _canDecrease => enabled && !readOnly && onChanged != null && (minimum == null || value - step >= minimum!);
	bool get _canIncrease => enabled && !readOnly && onChanged != null && (maximum == null || value + step <= maximum!);

	@override
	Widget build(BuildContext context) {
		final labels = KlpLocalizations.of(context);

		return KlpInputFrame(
			label: label,
			enabled: enabled,
			readOnly: readOnly,
			error: error,
			child: Row(
				children: [
					KlpInputAction(
						icon: KlpIcons.minus,
						label: decreaseLabel ?? labels.formQuantityDecreaseLabel,
						onPressed: _canDecrease ? () => onChanged!(value - step) : null,
					),
					const KlpInputSegmentDivider(),
					Expanded(
						child: Center(
							child: KlpText(
								value.toString(),
								role: KlpTextRole.code,
								tone: enabled ? KlpTextTone.primary : KlpTextTone.faint,
							),
						),
					),
					const KlpInputSegmentDivider(),
					KlpInputAction(
						icon: KlpIcons.plus,
						label: increaseLabel ?? labels.formQuantityIncreaseLabel,
						onPressed: _canIncrease ? () => onChanged!(value + step) : null,
					),
				],
			),
		);
	}
}
