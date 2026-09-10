part of '../klp_entity_picker.dart';

class _KlpEntityResult extends StatelessWidget {
	const _KlpEntityResult({required this.data, required this.onPressed});

	final KlpEntityResultData data;
	final VoidCallback? onPressed;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;

		return _KlpEntityResultFrame(
			selected: data.selected,
			onPressed: onPressed,
			child: KlpBox(
				insets: KlpBoxInsets.uniform(klp.space.tight),
				child: KlpRow(
					children: [
						KlpBadge(label: data.kind),
						const KlpGap.tight(),
						KlpExpanded(child: KlpText(data.label)),
						if (data.trailing != null)
							KlpText(
								data.trailing!,
								role: KlpTextRole.caption,
								tone: KlpTextTone.faint,
							),
					],
				),
			),
		);
	}
}
