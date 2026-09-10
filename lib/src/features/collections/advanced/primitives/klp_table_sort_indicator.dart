part of '../klp_advanced_data.dart';

class _KlpTableSortIndicator extends StatelessWidget {
	const _KlpTableSortIndicator({required this.descending, required this.child});

	final bool descending;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return RotatedBox(quarterTurns: descending ? 2 : 0, child: child);
	}
}
