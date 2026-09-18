import 'klp_editing_stamp.dart';

/// 以目前核心 frame 的局部座標選取文字。
final class KlpEditingPointRequest {
	final KlpEditingStamp expected;
	final double x;
	final double y;
	final bool extend;

	KlpEditingPointRequest({required this.expected, required this.x, required this.y, this.extend = false}) {
		if (!x.isFinite || !y.isFinite) throw ArgumentError('Invalid editing point');
	}
}
