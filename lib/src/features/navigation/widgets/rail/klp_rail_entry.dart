import 'package:flutter/widgets.dart';

/// 導覽軌可接受內容的共同資料契約。
abstract base class KlpRailEntry {
	final String id;

	const KlpRailEntry({required this.id}) : assert(id != '');

	bool get isDraggable => true;

	Widget build(BuildContext context);
}
