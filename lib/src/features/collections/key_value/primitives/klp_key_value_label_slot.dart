part of '../klp_key_value_table.dart';

class _KlpKeyValueLabelSlot extends StatelessWidget {
	const _KlpKeyValueLabelSlot({required this.width, required this.child});

	final KlpKeyValueLabelWidth width;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		final geometry = context.klp.geometry.data;
		final resolvedWidth = switch (width) {
			KlpKeyValueLabelWidth.compact => geometry.keyValueLabelWidthCompact,
			KlpKeyValueLabelWidth.standard => geometry.keyValueLabelWidthStandard,
		};

		return SizedBox(width: resolvedWidth, child: child);
	}
}
