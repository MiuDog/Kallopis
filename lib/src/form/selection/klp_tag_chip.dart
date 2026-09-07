import '../internal/klp_form_dependencies.dart';

/// 標籤膠囊元件。呈現單一標籤並支援移除操作。
class KlpTagChip extends StatelessWidget {
	const KlpTagChip({super.key, required this.label, this.onRemove});

	final String label;
	final VoidCallback? onRemove;

	@override
	Widget build(BuildContext context) {
		final tokens = context.klpColors;
		final klp = context.klp;

		return Container(
			padding: EdgeInsets.symmetric(
				horizontal: klp.space.controlInset,
				vertical: klp.space.tight,
			),
			decoration: BoxDecoration(
				color: tokens.surfaceInset,
				borderRadius: BorderRadius.circular(klp.shape.control),
				border: Border.all(color: tokens.border, width: klp.shape.hairline),
			),
			child: Row(
				mainAxisSize: MainAxisSize.min,
				children: [
					KlpText(label, role: KlpTextRole.code),
					if (onRemove != null) ...[
						SizedBox(width: klp.space.tight),
						GestureDetector(
							behavior: HitTestBehavior.opaque,
							onTap: onRemove,
							child: const KlpText(
								'×',
								role: KlpTextRole.caption,
								tone: KlpTextTone.muted,
							),
						),
					],
				],
			),
		);
	}
}
