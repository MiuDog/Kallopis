part of '../klp_canvas_workspace.dart';

/// Flow 節點卡；節點種類與風險文字由呼叫端提供。
class KlpFlowNodeCard extends StatelessWidget {
	const KlpFlowNodeCard({
		super.key,
		required this.title,
		required this.typeLabel,
		required this.child,
		this.selected = false,
		this.onPressed,
	});

	final String title;
	final String typeLabel;
	final Widget child;
	final bool selected;
	final VoidCallback? onPressed;

	@override
	Widget build(BuildContext context) {
		return _KlpFlowNodeFrame(
			selected: selected,
			onPressed: onPressed,
			child: KlpColumn(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					KlpRow(
						children: [
							KlpExpanded(
								child: KlpText(title, role: KlpTextRole.bodyStrong),
							),
							KlpBadge(label: typeLabel),
						],
					),
					const KlpGap.heightSize(KlpSpaceSize.contentStack),
					child,
				],
			),
		);
	}
}
