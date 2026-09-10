part of '../klp_key_value_table.dart';

class _KlpKeyValueRowFrame extends StatelessWidget {
	const _KlpKeyValueRowFrame({required this.child});

	final Widget child;

	@override
	Widget build(BuildContext context) {
		return Padding(
			padding: EdgeInsets.symmetric(vertical: context.klp.space.tight),
			child: child,
		);
	}
}
