import 'package:flutter/widgets.dart';

import '../../../../foundation/klp_icon.dart';
import 'klp_rail_entry.dart';
import 'klp_rail_item.dart';

/// 一般 Rail 動作的結構化資料。
final class KlpRailButtonEntry extends KlpRailEntry {
	final KlpIconData icon;
	final String label;
	final VoidCallback onPressed;
	final bool selected;
	final String? badge;

	const KlpRailButtonEntry({
		required super.id,
		required this.icon,
		required this.label,
		required this.onPressed,
		this.selected = false,
		this.badge,
	});

	@override
	Widget build(BuildContext context) {
		return KlpRailItem(
			key: ValueKey(id),
			icon: icon,
			label: label,
			onPressed: onPressed,
			selected: selected,
			badge: badge,
		);
	}
}
