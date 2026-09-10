part of '../klp_select_field.dart';

class _KlpSelectFieldState extends State<KlpSelectField> {
	bool _expanded = false;
	bool _hovered = false;
	bool _focused = false;

	bool get _interactive =>
			widget.enabled && !widget.readOnly && widget.onSelected != null;

	void _setHovered(bool value) {
		if (_hovered == value) return;

		setState(() => _hovered = value);
	}

	void _setFocused(bool value) {
		if (_focused == value) return;

		setState(() => _focused = value);
	}

	void _toggleExpanded() {
		setState(() => _expanded = !_expanded);
	}

	void _selectOption(KlpChoiceOption option) {
		widget.onSelected?.call(option.id);
		setState(() => _expanded = false);
	}

	@override
	Widget build(BuildContext context) {
		final fillState = !widget.enabled
			? KlpFieldFillState.disabled
			: widget.error != null
				? KlpFieldFillState.error
				: _expanded || _focused
					? KlpFieldFillState.focused
					: _hovered
						? KlpFieldFillState.hovered
						: KlpFieldFillState.rest;

		return KlpColumn(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				KlpText(widget.label, role: KlpTextRole.caption),
				const KlpGap.heightSize(KlpSpaceSize.tight),
				_KlpSelectFieldTrigger(
					fillState: fillState,
					enabled: _interactive,
					readOnly: widget.readOnly,
					expanded: _expanded,
					onTap: _interactive ? _toggleExpanded : null,
					onHoverChanged: _setHovered,
					onFocusChanged: _setFocused,
					child: KlpRow(
						children: [
							KlpExpanded(
								child: KlpText(
									widget.valueLabel,
									tone: widget.enabled
										? KlpTextTone.primary
										: KlpTextTone.faint,
								),
							),
							_KlpSelectFieldChevron(enabled: widget.enabled),
						],
					),
				),
				if (_expanded) ...[
					const KlpGap.heightSize(KlpSpaceSize.tight),
					KlpSurface(
						tone: KlpSurfaceTone.component,
						child: KlpBox(
							paddingSize: KlpSpaceSize.tight,
							child: KlpColumn(
								crossAxisAlignment: CrossAxisAlignment.center,
								children: [
									for (final option in widget.options)
										_KlpSelectFieldOption(
											option: option,
											onSelected: () => _selectOption(option),
										),
								],
							),
						),
					),
				],
				if (widget.error != null) ...[
					const KlpGap.heightSize(KlpSpaceSize.tight),
					KlpText(
						widget.error!,
						role: KlpTextRole.caption,
						tone: KlpTextTone.danger,
					),
				],
			],
		);
	}
}
