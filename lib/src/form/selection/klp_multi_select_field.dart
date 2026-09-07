import '../internal/klp_form_dependencies.dart';
import 'klp_choice_option.dart';

/// 多選欄位：所有選項以可切換的標籤（chip）形式平鋪展示，不像
/// [KlpSelectField] 需要展開／收合。
///
/// [selectedIds] 由呼叫端持有——這個元件本身無狀態，點擊某個選項只會透過
/// [onChanged] 回報「切換後應該是這個集合」，不會自己更新畫面。
class KlpMultiSelectField extends StatelessWidget {
	const KlpMultiSelectField({
		super.key,
		required this.label,
		required this.options,
		required this.selectedIds,
		required this.onChanged,
		this.enabled = true,
		this.readOnly = false,
		this.error,
	});

	final String label;
	final List<KlpChoiceOption> options;
	final Set<String> selectedIds;
	final ValueChanged<Set<String>>? onChanged;
	final bool enabled;
	final bool readOnly;
	final String? error;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		final interactive = enabled && !readOnly && onChanged != null;
		final fillState = !enabled
			? KlpFieldFillState.disabled
			: error != null
				? KlpFieldFillState.error
				: KlpFieldFillState.rest;
		final fill = KlpFieldStyle.colorFor(klp.color, fillState, surface: klp.surface);

		return Column(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				KlpText(label, role: KlpTextRole.caption),
			SizedBox(height: klp.space.tight),
			Semantics(
				enabled: enabled,
				readOnly: readOnly,
				label: label,
				child: Container(
					constraints: BoxConstraints(minHeight: klp.fieldHeight),
					padding: EdgeInsets.all(klp.space.tight),
					decoration: BoxDecoration(
						color: fill,
						borderRadius: BorderRadius.circular(klp.fieldRadius),
					),
					child: Wrap(
						spacing: klp.space.tight,
						runSpacing: klp.space.tight,
						children: [
							for (final option in options)
								Material(
									color: selectedIds.contains(option.id) ? klp.color.selection : klp.color.surfaceInset,
									borderRadius: BorderRadius.circular(klp.shape.pill),
									clipBehavior: Clip.antiAlias,
									child: InkWell(
										onTap: !interactive || option.disabled
											? null
											: () {
												final next = Set<String>.from(selectedIds);
												if (next.contains(option.id)) {
													next.remove(option.id);
												}
												else {
													next.add(option.id);
												}
												onChanged!(next);
												},
										overlayColor: WidgetStatePropertyAll(klp.color.interactionSoft),
										child: Padding(
											padding: EdgeInsets.symmetric(
												horizontal: klp.space.controlInset,
												vertical: klp.space.tight,
											),
											child: KlpText(
												option.label,
												role: KlpTextRole.caption,
												color: !enabled || option.disabled
													? klp.color.textFaint
													: selectedIds.contains(option.id)
														? klp.color.onSelection
														: klp.color.text,
											),
										),
									),
								),
						],
					),
				),
			),
			if (error != null) ...[
				SizedBox(height: klp.space.tight),
				KlpText(error!, role: KlpTextRole.caption, tone: KlpTextTone.danger),
			],
			],
		);
	}
}
