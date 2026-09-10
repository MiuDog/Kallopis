part of '../klp_navigation_rail.dart';

class _KlpNavigationRailLayout extends StatelessWidget {
	const _KlpNavigationRailLayout({
		required this.top,
		required this.center,
		required this.bottom,
		required this.showTop,
		required this.showBottom,
	});

	final Widget top;
	final Widget center;
	final Widget bottom;
	final bool showTop;
	final bool showBottom;

	@override
	Widget build(BuildContext context) {
		final inset = context.klp.space.navigationRailInset;

		return KlpBox(
			insets: KlpBoxInsets.uniform(inset),
			child: KlpColumn(
				children: [
					if (showTop) ...[
						top,
						const _KlpRailGroupDivider(),
					],
					KlpExpanded(child: _KlpRailScrollableCenter(child: center)),
					if (showBottom) ...[
						const _KlpRailGroupDivider(),
						bottom,
					],
				],
			),
		);
	}
}
