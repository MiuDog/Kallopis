part of '../klp_key_value_table.dart';

class KlpKeyValueList extends StatelessWidget {
	const KlpKeyValueList({
		super.key,
		required this.rows,
		this.labelWidth = KlpKeyValueLabelWidth.compact,
		this.onCopy,
		this.emptyState,
	});

	final List<KlpKeyValueItem> rows;
	final KlpKeyValueLabelWidth labelWidth;
	final ValueChanged<String>? onCopy;
	final Widget? emptyState;

	@override
	Widget build(BuildContext context) {
		if (rows.isEmpty) return emptyState ?? const KlpBox.shrink();

		return KlpColumn(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				for (final row in rows)
					_KlpKeyValueListRow(
						row: row,
						labelWidth: labelWidth,
						onCopy: onCopy,
					),
			],
		);
	}
}
