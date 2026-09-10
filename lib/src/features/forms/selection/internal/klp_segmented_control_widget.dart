part of '../klp_segmented_control.dart';

class KlpSegmentedControl extends StatelessWidget {
	const KlpSegmentedControl({
		super.key,
		required this.items,
		required this.selected,
		required this.onSelected,
		this.icons,
		this.itemKeys,
		this.expanded = false,
		this.dense = false,
	}) : assert(icons == null || icons.length == items.length),
			 assert(itemKeys == null || itemKeys.length == items.length);

	final List<String> items;
	final int selected;
	final ValueChanged<int> onSelected;
	final List<KlpIconData>? icons;
	final List<Key?>? itemKeys;
	final bool expanded;
	final bool dense;

	@override
	Widget build(BuildContext context) {
		return _KlpSegmentedControlFrame(
			style: _KlpSegmentedControlStyle.resolve(context.klp, dense: dense),
			child: KlpRow(
				mainAxisSize: MainAxisSize.min,
				children: [
					for (var index = 0; index < items.length; index++)
						if (expanded) KlpExpanded(child: _segment(index)) else _segment(index),
				],
			),
		);
	}

	Widget _segment(int index) {
		return _KlpSegment(
			key: itemKeys?[index],
			label: items[index],
			icon: icons?[index],
			selected: index == selected,
			dense: dense,
			onPressed: () => onSelected(index),
		);
	}
}
