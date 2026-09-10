part of '../klp_key_value_table.dart';

class _KlpKeyValueValueStyle extends StatelessWidget {
	const _KlpKeyValueValueStyle({
		required this.verbatim,
		required this.child,
	});

	final bool verbatim;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;

		return DefaultTextStyle.merge(
			style: TextStyle(
				fontFamily: verbatim ? klp.type.monoFamily : null,
				fontFamilyFallback: verbatim ? klp.type.monoFallback : null,
				color: klp.color.text,
				fontSize: klp.type.caption,
			),
			child: child,
		);
	}
}
