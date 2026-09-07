import '../internal/klp_form_dependencies.dart';
import '../internal/klp_input_editor.dart';
import '../internal/klp_input_frame.dart';
import '../internal/klp_input_segment_divider.dart';
import '../selection/klp_choice_option.dart';

/// 在單一控制框內組合主要文字與受控尾端選項。
class KlpCompoundField extends StatefulWidget {
	final String label;
	final TextEditingController? controller;
	final String? initialValue;
	final String? placeholder;
	final String selectedOptionLabel;
	final List<KlpChoiceOption> options;
	final ValueChanged<String>? onChanged;
	final ValueChanged<String>? onOptionSelected;
	final bool enabled;
	final bool readOnly;
	final String? error;
	final String? optionsLabel;

	const KlpCompoundField({
		super.key,
		required this.label,
		required this.selectedOptionLabel,
		required this.options,
		this.controller,
		this.initialValue,
		this.placeholder,
		this.onChanged,
		this.onOptionSelected,
		this.enabled = true,
		this.readOnly = false,
		this.error,
		this.optionsLabel,
	}) : assert(controller == null || initialValue == null);

	@override
	State<KlpCompoundField> createState() => _KlpCompoundFieldState();
}
class _KlpCompoundFieldState extends State<KlpCompoundField> {
	bool _expanded = false;

	void _toggleOptions() {
		if (!widget.enabled || widget.readOnly || widget.onOptionSelected == null) return;

		setState(() => _expanded = !_expanded);
	}

	void _selectOption(String id) {
		widget.onOptionSelected?.call(id);
		setState(() => _expanded = false);
	}

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		final labels = KlpLocalizations.of(context);
		final interactive = widget.enabled && !widget.readOnly && widget.onOptionSelected != null;

		return Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				KlpInputFrame(
					label: widget.label,
					enabled: widget.enabled,
					readOnly: widget.readOnly,
					error: widget.error,
					child: Row(
						children: [
							Expanded(
								child: KlpInputEditor(
									controller: widget.controller,
									initialValue: widget.initialValue,
									placeholder: widget.placeholder,
									onChanged: widget.onChanged,
									enabled: widget.enabled,
									readOnly: widget.readOnly,
								),
							),
							const KlpInputSegmentDivider(),
							Semantics(
								button: true,
								enabled: interactive,
								label: widget.optionsLabel ?? labels.formOptionsLabel,
								child: InkWell(
									onTap: interactive ? _toggleOptions : null,
									overlayColor: WidgetStatePropertyAll(klp.color.clear),
									child: Padding(
										padding: EdgeInsets.symmetric(horizontal: klp.space.controlInset),
										child: Row(
											mainAxisSize: MainAxisSize.min,
											children: [
												KlpText(
													widget.selectedOptionLabel,
													tone: widget.enabled ? KlpTextTone.primary : KlpTextTone.faint,
												),
												SizedBox(width: klp.space.tight),
												KlpIcon(
													KlpIcons.chevronDown,
													size: klp.space.iconSmall,
													color: widget.enabled ? klp.color.textMuted : klp.color.textFaint,
												),
											],
										),
									),
								),
							),
						],
					),
				),
				if (_expanded) ...[
					SizedBox(height: klp.space.tight),
					Container(
						padding: EdgeInsets.all(klp.space.tight),
						decoration: BoxDecoration(
							color: klp.color.component,
							borderRadius: BorderRadius.circular(klp.shape.card),
						),
						child: Column(
							children: [
								for (final option in widget.options)
									InkWell(
										onTap: option.disabled ? null : () => _selectOption(option.id),
										overlayColor: WidgetStatePropertyAll(klp.color.clear),
										child: SizedBox(
											height: klp.fieldHeight,
											child: Align(
												alignment: Alignment.centerLeft,
												child: Padding(
													padding: EdgeInsets.symmetric(horizontal: klp.space.controlInset),
													child: KlpText(
														option.label,
														tone: option.disabled ? KlpTextTone.faint : KlpTextTone.primary,
													),
												),
											),
										),
									),
							],
						),
					),
				],
			],
		);
	}
}
