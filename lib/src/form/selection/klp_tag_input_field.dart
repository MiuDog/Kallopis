import '../internal/klp_form_dependencies.dart';
import 'klp_tag_chip.dart';

/// 標籤輸入與群組欄位。支援新增、移除個別標籤與清空所有標籤。
class KlpTagInputField extends StatelessWidget {
	const KlpTagInputField({
		super.key,
		required this.label,
		required this.tags,
		this.onAdd,
		this.onRemove,
		this.onClearAll,
		this.maxCount,
	});

	final String label;
	final List<String> tags;
	final VoidCallback? onAdd;
	final ValueChanged<String>? onRemove;
	final VoidCallback? onClearAll;
	final int? maxCount;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;

		return Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				KlpText(label, role: KlpTextRole.caption),
				SizedBox(height: klp.space.tight),
				Wrap(
					spacing: klp.space.tight,
					runSpacing: klp.space.tight,
					crossAxisAlignment: WrapCrossAlignment.center,
					children: [
						for (final tag in tags)
							KlpTagChip(
								label: tag,
								onRemove: onRemove == null ? null : () => onRemove!(tag),
							),
						if (onAdd != null)
							GestureDetector(
								behavior: HitTestBehavior.opaque,
								onTap: onAdd,
								child: Container(
									padding: EdgeInsets.symmetric(
										horizontal: klp.space.controlInset,
										vertical: klp.space.tight,
									),
									decoration: BoxDecoration(
										color: context.klpColors.surfaceInset,
										borderRadius: BorderRadius.circular(klp.shape.control),
										border: Border.all(
											color: context.klpColors.border,
											width: klp.shape.hairline,
										),
									),
									child: const KlpText('+ Add', role: KlpTextRole.caption),
								),
							),
						if (maxCount != null || onClearAll != null) ...[
							SizedBox(width: klp.space.tight),
							if (maxCount != null)
								KlpText(
									'${tags.length}/$maxCount',
									role: KlpTextRole.caption,
									tone: KlpTextTone.faint,
								),
							if (onClearAll != null)
								GestureDetector(
									behavior: HitTestBehavior.opaque,
									onTap: onClearAll,
									child: const KlpText(
										' Clear all',
										role: KlpTextRole.caption,
										tone: KlpTextTone.muted,
									),
								),
						],
					],
				),
			],
		);
	}
}
