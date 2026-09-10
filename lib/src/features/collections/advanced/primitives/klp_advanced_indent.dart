part of '../klp_advanced_data.dart';

class _KlpAdvancedIndent extends StatelessWidget {
	const _KlpAdvancedIndent({required this.extent, required this.child});

	final double extent;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return Padding(
			padding: EdgeInsets.only(left: extent),
			child: child,
		);
	}
}
