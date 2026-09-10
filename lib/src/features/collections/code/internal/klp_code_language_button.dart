part of '../klp_code_viewer.dart';

class _KlpCodeLanguageButton extends StatelessWidget {
	const _KlpCodeLanguageButton({
		super.key,
		required this.label,
		required this.enabled,
		required this.onPressed,
		required this.style,
	});

	final String label;
	final bool enabled;
	final ValueChanged<BuildContext> onPressed;
	final _KlpCodeStyle style;

	@override
	Widget build(BuildContext context) {
		return KlpAlign(
			alignment: Alignment.centerLeft,
			shrinkWidth: true,
			child: _KlpCodeActionFrame(
				kind: _KlpCodeActionKind.language,
				label: label,
				onPressed: enabled ? onPressed : null,
				style: style,
				builder: (context, foreground) {
					return KlpRow(
						mainAxisSize: MainAxisSize.min,
						children: [
							KlpText(label, role: KlpTextRole.code, color: foreground),
							if (enabled) ...[
								const KlpGap.widthSize(KlpSpaceSize.tight),
								KlpIcon(
									KlpIcons.chevronDown,
									size: style.disclosureSize,
									color: foreground,
								),
							],
						],
					);
				},
			),
		);
	}
}
