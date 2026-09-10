part of '../klp_pane_collapse_control.dart';

/// 將 Pane 收合圖示限制在 theme 擁有的正方形控制範圍。
class _KlpPaneCollapseIconFrame extends StatelessWidget {
	const _KlpPaneCollapseIconFrame({required this.child});

	final Widget child;

	@override
	Widget build(BuildContext context) => SizedBox.square(
		dimension: context.klp.space.controlHeightSmall,
		child: Center(child: child),
	);
}
