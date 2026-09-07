import '../internal/klp_form_dependencies.dart';

/// [KlpRepeaterField] 裡的一個項目：識別碼加上該項目自己的輸入內容。
///
/// [child] 是整個項目的內容 widget（例如一組欄位），[id] 只用來在
/// [KlpRepeaterField.onRemove] 回報要刪除哪一項，與顯示內容無關。
@immutable
class KlpRepeaterItem {
	const KlpRepeaterItem({required this.id, required this.child});

	final String id;
	final Widget child;
}
/// 可新增／刪除項目的重複欄位群組（例如「新增一組聯絡方式」）。
///
/// 不維護項目清單的狀態——[items] 由呼叫端持有，新增／刪除都只是透過
/// [onAdd]／[onRemove] 回報意圖，實際要不要新增一項、刪哪一項由呼叫端決定
/// 並重新傳入新的 [items]。
class KlpRepeaterField extends StatelessWidget {
	const KlpRepeaterField({
		super.key,
		required this.label,
		required this.addLabel,
		required this.removeLabel,
		required this.items,
		required this.onAdd,
		required this.onRemove,
	});

	final String label;
	final String addLabel;
	final String removeLabel;
	final List<KlpRepeaterItem> items;
	final VoidCallback? onAdd;
	final ValueChanged<String>? onRemove;

	@override
	Widget build(BuildContext context) {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				KlpText(label, role: KlpTextRole.caption),
				SizedBox(height: context.klp.space.tight),
				for (final item in items) ...[
					KlpSurface(
						tone: KlpSurfaceTone.component,
						padding: EdgeInsets.all(context.klp.space.contentInset),
						child: Row(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Expanded(child: item.child),
								SizedBox(width: context.klp.space.contentInlineGap),
								KlpButton(
									label: removeLabel,
									compact: true,
									tone: KlpButtonTone.ghost,
									onPressed: onRemove == null ? null : () => onRemove!(item.id),
								),
							],
						),
					),
					SizedBox(height: context.klp.space.tight),
				],
				Align(
					alignment: Alignment.centerLeft,
					child: KlpButton(label: addLabel, compact: true, onPressed: onAdd),
				),
			],
		);
	}
}
