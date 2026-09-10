part of '../klp_key_value_table.dart';

class _KlpKeyValueTableRow extends StatelessWidget {
	const _KlpKeyValueTableRow({
		required this.row,
		required this.labelWidth,
	});

	final KlpKeyValueRowData row;
	final KlpKeyValueLabelWidth labelWidth;

	@override
	Widget build(BuildContext context) {
		return _KlpKeyValueRowFrame(
			child: KlpRow(
				children: [
					_KlpKeyValueLabelSlot(
						width: labelWidth,
						child: KlpText(
							row.label,
							role: KlpTextRole.body,
							tone: KlpTextTone.muted,
						),
					),
					KlpExpanded(
						child: KlpText(row.value, role: KlpTextRole.body),
					),
				],
			),
		);
	}
}
