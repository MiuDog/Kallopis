import 'package:flutter/widgets.dart';

import 'klp_rail_entry.dart';
import 'klp_rail_group_reorder_callback.dart';

export 'klp_rail_group_reorder_callback.dart';

@immutable
class KlpRailItemGroup {
	final String id;
	final List<KlpRailEntry> items;
	final KlpRailGroupReorderCallback? onReorder;

	/// 是否允許此群組內的項目拖曳排序。
	final bool isReorderable;

	const KlpRailItemGroup({
		required this.id,
		required this.items,
		this.onReorder,
		this.isReorderable = true,
	}) : assert(id != '');
}
