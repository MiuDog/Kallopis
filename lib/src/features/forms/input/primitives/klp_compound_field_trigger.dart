part of '../klp_compound_field.dart';

class _KlpCompoundFieldTrigger extends StatelessWidget {
	const _KlpCompoundFieldTrigger({
		required this.semanticLabel,
		required this.enabled,
		required this.onTap,
		required this.child,
	});

	final String semanticLabel;
	final bool enabled;
	final VoidCallback? onTap;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;

		return Semantics(
			button: true,
			enabled: enabled,
			label: semanticLabel,
			child: InkWell(
				onTap: onTap,
				overlayColor: WidgetStatePropertyAll(klp.color.clear),
				child: Padding(
					padding: EdgeInsets.symmetric(horizontal: klp.space.controlInset),
					child: child,
				),
			),
		);
	}
}
