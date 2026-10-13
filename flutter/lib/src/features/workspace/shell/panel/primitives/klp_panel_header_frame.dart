part of '../klp_panel_header.dart';

/// 標題列內距先限制至有限預算，不把子槽移出面板。
class _KlpPanelHeaderFrame extends StatelessWidget {
	const _KlpPanelHeaderFrame({required this.child});

	/// 同一內容節點在尺寸與 theme 更新時保留。
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return LayoutBuilder(builder: (context, constraints) {
			final horizontal = constraints.hasBoundedWidth
					? context.klp.space.chromePanelInset.clamp(0.0, constraints.maxWidth / 2).toDouble()
					: context.klp.space.chromePanelInset;
			final vertical = constraints.hasBoundedHeight
					? context.klp.space.tight.clamp(0.0, constraints.maxHeight / 2).toDouble()
					: context.klp.space.tight;
			return ClipRect(child: Padding(
				padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
				child: child,
			));
		});
	}
}
