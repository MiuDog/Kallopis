import 'package:flutter/widgets.dart';

import '../../surface/klp_dashed_border.dart';
import 'klp_rail_entry.dart';

/// Rail 專用的固定分隔 Entry。
final class KlpRailDivider extends KlpRailEntry {
	const KlpRailDivider({required super.id});

	@override
	bool get isDraggable => false;

	@override
	Widget build(BuildContext context) => const KlpDashedDivider();
}
