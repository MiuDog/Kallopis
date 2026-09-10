part of '../klp_advanced_data.dart';

/// 結構化資料表格：固定欄位、可選排序與多選。
///
/// 不做分頁或虛擬捲動。選取與排序狀態由呼叫端持有，元件只回報意圖。
class KlpDataTable extends StatelessWidget {
	const KlpDataTable({
		super.key,
		required this.columns,
		required this.rows,
		this.onRowPressed,
		this.selectable = false,
		this.selectedIds = const {},
		this.sort,
		this.onSelected,
		this.onSort,
	});

	final List<KlpDataColumn> columns;
	final List<KlpDataRow> rows;
	final ValueChanged<String>? onRowPressed;
	final bool selectable;
	final Set<String> selectedIds;
	final KlpDataSort? sort;
	final ValueChanged<Set<String>>? onSelected;
	final ValueChanged<String>? onSort;

	@override
	Widget build(BuildContext context) {
		final style = _KlpAdvancedStyle.from(context);
		final children = <Widget>[
			_KlpTableLine(
				columns: columns,
				values: {for (final column in columns) column.id: column.label},
				header: true,
				selectable: selectable,
				selected: rows.isNotEmpty && selectedIds.length == rows.length,
				sort: sort,
				onSelectionChanged: onSelected == null ? null : _selectAll,
				onSort: onSort,
			),
		];

		if (rows.isNotEmpty) children.add(const KlpDashedDivider());
		for (var index = 0; index < rows.length; index++) {
			final row = rows[index];
			children.add(
				_KlpTableLine(
					columns: columns,
					values: row.cells,
					rowId: row.id,
					selectable: selectable,
					selected: selectedIds.contains(row.id),
					onPressed: onRowPressed == null ? null : () => onRowPressed!(row.id),
					onSelectionChanged: onSelected == null
							? null
							: (selected) => _selectRow(row.id, selected),
				),
			);
			if (index < rows.length - 1) children.add(const KlpDashedDivider());
		}

		return _KlpDataTableFrame(
			style: style,
			child: KlpColumn(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: children,
			),
		);
	}

	void _selectAll(bool selected) {
		if (selectedIds.length == rows.length) {
			onSelected!(<String>{});
			return;
		}

		onSelected!({for (final row in rows) row.id});
	}

	void _selectRow(String rowId, bool selected) {
		final next = {...selectedIds};
		if (selected) {
			next.add(rowId);
		} else {
			next.remove(rowId);
		}

		onSelected!(next);
	}
}
