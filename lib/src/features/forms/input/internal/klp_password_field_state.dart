part of '../klp_password_field.dart';

class _KlpPasswordFieldState extends State<KlpPasswordField> {
	bool _obscured = true;

	@override
	Widget build(BuildContext context) {
		final labels = KlpLocalizations.of(context);
		final requirements = widget.requirements;

		return KlpColumn(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				KlpRow(
					children: [
						KlpText(widget.label, role: KlpTextRole.caption),
						if (widget.required) ...[
							const KlpGap.tight(),
							const KlpText(
								'*',
								role: KlpTextRole.caption,
								tone: KlpTextTone.danger,
							),
						],
					],
				),
				const KlpGap.tight(),
				KlpTextField(
					initialValue: widget.value,
					placeholder: widget.placeholder,
					leadingIcon: KlpIcons.lock,
					leadingIconWeight: KlpIconWeight.thin,
					onChanged: widget.onChanged,
					enabled: widget.enabled,
					readOnly: widget.readOnly,
					conflict: widget.error != null,
					obscureText: _obscured,
					trailingActionIcon: _obscured ? KlpIcons.eyeCrossed : KlpIcons.eye,
					trailingActionIconWeight: KlpIconWeight.thin,
					trailingActionLabel: _obscured
							? labels.formPasswordShowLabel
							: labels.formPasswordHideLabel,
					onTrailingActionPressed: widget.enabled
							? () => setState(() => _obscured = !_obscured)
							: null,
				),
				if (requirements != null && requirements.isNotEmpty) ...[
					const KlpGap.tight(),
					KlpWrap(
						spacingSize: KlpSpaceSize.base,
						runSpacingSize: KlpSpaceSize.tight,
						children: [
							for (final requirement in requirements)
								KlpRow(
									mainAxisSize: MainAxisSize.min,
									children: [
										KlpText(
											requirement.satisfied ? '✓ ' : '○ ',
											role: KlpTextRole.caption,
											tone: requirement.satisfied
													? KlpTextTone.success
													: KlpTextTone.muted,
										),
										KlpText(
											requirement.label,
											role: KlpTextRole.caption,
											tone: requirement.satisfied
													? KlpTextTone.success
													: KlpTextTone.muted,
										),
									],
								),
						],
					),
				],
				if (widget.error != null) ...[
					const KlpGap.tight(),
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
