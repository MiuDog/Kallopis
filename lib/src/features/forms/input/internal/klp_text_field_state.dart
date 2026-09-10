part of '../klp_text_field.dart';

class _KlpTextFieldState extends State<KlpTextField> {
	bool _focused = false;

	void _handleFocusChanged(bool value) {
		if (_focused == value) return;
		setState(() => _focused = value);
	}

	@override
	Widget build(BuildContext context) {
		final hasError = widget.error != null;
		final style = _KlpTextFieldStyle.resolve(
			context.klp,
			size: widget.size,
			enabled: widget.enabled,
			invalid: hasError || widget.conflict,
			multiline: widget.multiline,
			outlined: widget.outlined,
			focused: _focused,
		);
		var minLines = 1;
		int? maxLines = 1;
		if (widget.multiline) {
			minLines = widget.minLines ?? style.defaultMinLines;
			maxLines = widget.unboundedLines
					? null
					: widget.maxLines ?? style.defaultMaxLines;
		}

		final suffix =
				widget.clearable ||
						widget.stepper ||
						widget.suffixText != null ||
						widget.trailingActionIcon != null
				? _KlpTextFieldSuffix(
						style: style,
						clearable: widget.clearable,
						stepper: widget.stepper,
						suffixText: widget.suffixText,
						trailingActionIcon: widget.trailingActionIcon,
						trailingActionIconWeight: widget.trailingActionIconWeight,
						trailingActionLabel: widget.trailingActionLabel,
						onTrailingActionPressed: widget.onTrailingActionPressed,
						onClear: widget.onClear,
						onStepUp: widget.onStepUp,
						onStepDown: widget.onStepDown,
					)
				: null;
		final field = _KlpTextFieldFrame(
			style: style,
			controller: widget.controller,
			initialValue: widget.controller == null ? widget.initialValue : null,
			focusNode: widget.focusNode,
			autofocus: widget.autofocus,
			enabled: widget.enabled,
			readOnly: widget.readOnly,
			obscureText: widget.obscureText,
			multiline: widget.multiline,
			minLines: minLines,
			maxLines: maxLines,
			maxLength: widget.maxLength,
			placeholder: widget.placeholder,
			leadingIcon: widget.leadingIcon,
			leadingIconWeight: widget.leadingIconWeight,
			suffix: suffix,
			onChanged: widget.onChanged,
			onSubmitted: widget.onSubmitted,
			onFocusChanged: _handleFocusChanged,
		);

		return KlpColumn(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				if (widget.label != null) ...[
					KlpText(widget.label!, role: KlpTextRole.caption),
					const KlpGap.heightSize(KlpSpaceSize.tight),
				],
				field,
				if (hasError || widget.helper != null) ...[
					const KlpGap.heightSize(KlpSpaceSize.tight),
					KlpText(
						widget.error ?? widget.helper!,
						role: KlpTextRole.caption,
						tone: hasError ? KlpTextTone.danger : KlpTextTone.muted,
					),
				],
			],
		);
	}
}
