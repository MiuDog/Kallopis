part of '../klp_card.dart';

class _KlpMetricCardValueFit extends StatelessWidget {
	const _KlpMetricCardValueFit({required this.child});

	final Widget child;

	@override
	Widget build(BuildContext context) {
		return FittedBox(
			fit: BoxFit.scaleDown,
			alignment: Alignment.centerLeft,
			child: child,
		);
	}
}
