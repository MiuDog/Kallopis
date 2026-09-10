part of '../klp_text_field.dart';

class _KlpTextFieldSuffix extends StatelessWidget {
	const _KlpTextFieldSuffix({
		required this.style,
		required this.clearable,
		required this.stepper,
		required this.suffixText,
		required this.trailingActionIcon,
		required this.trailingActionIconWeight,
		required this.trailingActionLabel,
		required this.onTrailingActionPressed,
		required this.onClear,
		required this.onStepUp,
		required this.onStepDown,
	});

	final _KlpTextFieldStyle style;
	final bool clearable;
	final bool stepper;
	final String? suffixText;
	final KlpIconData? trailingActionIcon;
	final KlpIconWeight trailingActionIconWeight;
	final String? trailingActionLabel;
	final VoidCallback? onTrailingActionPressed;
	final VoidCallback? onClear;
	final VoidCallback? onStepUp;
	final VoidCallback? onStepDown;

	@override
	Widget build(BuildContext context) {
		if (clearable) {
			return _KlpTextFieldActionFrame(
				horizontalInset: style.controlInset,
				onTap: onClear,
				child: KlpIcon(
					KlpIcons.x,
					size: context.klp.space.iconSmall,
					color: style.iconColor,
				),
			);
		}

		return KlpRow(
			mainAxisSize: MainAxisSize.min,
			children: [
				if (suffixText != null) ...[
					KlpText(
						suffixText!,
						role: KlpTextRole.caption,
						tone: KlpTextTone.muted,
					),
					const KlpGap.widthSize(KlpSpaceSize.tight),
				],
				if (trailingActionIcon != null)
					_KlpTextFieldActionFrame(
						semanticLabel: trailingActionLabel,
						onTap: onTrailingActionPressed,
						child: KlpBox(
							insets: KlpBoxInsets.uniform(style.controlInset),
							child: KlpIcon(
								trailingActionIcon!,
								weight: trailingActionIconWeight,
								color: style.iconColor,
							),
						),
					),
				if (stepper)
					KlpColumn(
						mainAxisAlignment: MainAxisAlignment.center,
						crossAxisAlignment: CrossAxisAlignment.center,
						children: [
							_KlpTextFieldActionFrame(
								height: style.stepActionHeight,
								onTap: onStepUp,
								child: const KlpText(
									'⌃',
									role: KlpTextRole.caption,
									tone: KlpTextTone.muted,
								),
							),
							_KlpTextFieldActionFrame(
								height: style.stepActionHeight,
								onTap: onStepDown,
								child: const KlpText(
									'⌄',
									role: KlpTextRole.caption,
									tone: KlpTextTone.muted,
								),
							),
						],
					),
				const KlpGap.widthSize(KlpSpaceSize.tight),
			],
		);
	}
}
