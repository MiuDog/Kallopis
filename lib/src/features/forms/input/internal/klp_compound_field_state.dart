part of '../klp_compound_field.dart';

class _KlpCompoundFieldState extends State<KlpCompoundField> {
	bool _expanded = false;

	void _toggleOptions() {
		if (!widget.enabled ||
				widget.readOnly ||
				widget.onOptionSelected == null) {
			return;
		}

		setState(() => _expanded = !_expanded);
	}

	void _selectOption(String id) {
		widget.onOptionSelected?.call(id);
		setState(() => _expanded = false);
	}

	@override
	Widget build(BuildContext context) {
		final labels = KlpLocalizations.of(context);
		final interactive =
				widget.enabled && !widget.readOnly && widget.onOptionSelected != null;

		return KlpColumn(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				KlpInputFrame(
					label: widget.label,
					enabled: widget.enabled,
					readOnly: widget.readOnly,
					error: widget.error,
					child: KlpRow(
						children: [
							KlpExpanded(
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
							_KlpCompoundFieldTrigger(
								semanticLabel:
										widget.optionsLabel ?? labels.formOptionsLabel,
								enabled: interactive,
								onTap: interactive ? _toggleOptions : null,
								child: KlpRow(
									mainAxisSize: MainAxisSize.min,
									children: [
										KlpText(
											widget.selectedOptionLabel,
											tone: widget.enabled
													? KlpTextTone.primary
													: KlpTextTone.faint,
										),
										const KlpGap.widthSize(KlpSpaceSize.tight),
										KlpIcon(
											KlpIcons.chevronDown,
											size: context.klp.space.iconSmall,
											color: widget.enabled
													? context.klp.color.textMuted
													: context.klp.color.textFaint,
										),
									],
								),
							),
						],
					),
				),
				if (_expanded) ...[
					const KlpGap.heightSize(KlpSpaceSize.tight),
					_KlpCompoundFieldOptionsPanel(
						child: KlpColumn(
							children: [
								for (final option in widget.options)
									_KlpCompoundFieldOption(
										option: option,
										onSelected: _selectOption,
									),
							],
						),
					),
				],
			],
		);
	}
}
