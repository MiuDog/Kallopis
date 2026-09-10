part of '../klp_advanced_data.dart';

class _KlpAdvancedSemantics extends StatelessWidget {
	const _KlpAdvancedSemantics({required this.label, required this.child});

	final String? label;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return Semantics(container: true, label: label, child: child);
	}
}
