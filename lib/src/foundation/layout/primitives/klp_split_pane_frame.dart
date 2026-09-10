part of '../klp_split_layout.dart';

/// 分割版面內部的固定寬度 pane 框架。
class _KlpSplitPaneFrame extends StatelessWidget {
	const _KlpSplitPaneFrame({
		required this.size,
		required this.child,
	});

	final KlpSplitPaneSize size;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		final width = switch (size) {
			KlpSplitPaneSize.primary => context.klp.geometry.layout.primaryPaneWidth,
			KlpSplitPaneSize.secondary => context.klp.geometry.layout.secondaryPaneWidth,
		};

		return SizedBox(width: width, child: child);
	}
}
