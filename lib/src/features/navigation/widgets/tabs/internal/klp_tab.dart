part of '../klp_tabs.dart';

/// 單一分頁的內容組裝。
class _KlpTab extends StatelessWidget {
	const _KlpTab({
		required this.label,
		required this.selected,
		required this.onPressed,
	});

	final String label;
	final bool selected;
	final VoidCallback onPressed;

	@override
	Widget build(BuildContext context) {
		return _KlpTabFrame(
			selected: selected,
			onPressed: onPressed,
			child: KlpText(
				label,
				role: KlpTextRole.body,
				tone: selected ? KlpTextTone.primary : KlpTextTone.muted,
			),
		);
	}
}
