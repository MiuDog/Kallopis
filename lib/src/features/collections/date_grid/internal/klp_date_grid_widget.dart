part of '../klp_date_grid.dart';

/// 一列七欄的日期概覽格。
class KlpDateGrid extends StatelessWidget {
	const KlpDateGrid({
		super.key,
		required this.items,
		this.onSelected,
	});

	final List<KlpDateGridItem> items;
	final ValueChanged<int>? onSelected;

	@override
	Widget build(BuildContext context) {
		return _KlpDateGridViewport(
			itemCount: items.length,
			itemBuilder: (context, index) => _KlpDateGridCell(
				item: items[index],
				index: index,
				itemCount: items.length,
				onSelected: onSelected,
			),
		);
	}
}
