part of '../klp_key_value_table.dart';

class KlpKeyValueTable extends StatelessWidget {
	const KlpKeyValueTable({
		super.key,
		required this.rows,
		this.title,
		this.labelWidth = KlpKeyValueLabelWidth.standard,
	});

	final List<KlpKeyValueRowData> rows;
	final String? title;
	final KlpKeyValueLabelWidth labelWidth;

	@override
	Widget build(BuildContext context) {
		return _KlpKeyValueTableFrame(
			child: KlpColumn(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					if (title case final title?) ...[
						KlpText(title, role: KlpTextRole.label),
						const KlpGap.heightSize(KlpSpaceSize.base),
					],
					for (final row in rows)
						_KlpKeyValueTableRow(row: row, labelWidth: labelWidth),
				],
			),
		);
	}
}
