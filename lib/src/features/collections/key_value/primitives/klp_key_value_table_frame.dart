part of '../klp_key_value_table.dart';

class _KlpKeyValueTableFrame extends StatelessWidget {
	const _KlpKeyValueTableFrame({required this.child});

	final Widget child;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;

		return ClipRRect(
			borderRadius: BorderRadius.circular(klp.shape.card),
			child: KlpSurface(
				tone: KlpSurfaceTone.component,
				border: Border.all(
					color: klp.color.divider,
					width: klp.shape.hairline,
				),
				padding: EdgeInsets.all(klp.space.comfortable),
				child: child,
			),
		);
	}
}
