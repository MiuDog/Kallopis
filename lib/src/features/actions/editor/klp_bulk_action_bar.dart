part of 'klp_editor_action_bars.dart';

/// 以摘要標籤與可換行動作呈現批次操作列。
class KlpBulkActionBar extends StatelessWidget {
	const KlpBulkActionBar({
		super.key,
		required this.label,
		required this.actions,
	});

	final String label;
	final List<KlpEditorActionData> actions;

	@override
	Widget build(BuildContext context) {
		return _KlpEditorActionSurface(
			child: KlpWrap(
				crossAxisAlignment: WrapCrossAlignment.center,
				spacingSize: KlpSpaceSize.action,
				runSpacingSize: KlpSpaceSize.tight,
				children: [
					KlpText(label, role: KlpTextRole.code),
					for (final action in actions) _KlpEditorAction(data: action),
				],
			),
		);
	}
}
