import 'klp_editing_stamp.dart';

/// K02 拖曳期間的 viewport 位移；只移動視窗，不改變文件或落點權威。
final class KlpBlockViewportRequest {
	final int sequence;
	final KlpEditingStamp expected;
	final String blockId;
	final double deltaY;

	KlpBlockViewportRequest({required this.sequence, required this.expected, required this.blockId, required this.deltaY}) {
		if (sequence <= 0 || blockId.trim().isEmpty || !deltaY.isFinite || deltaY == 0) throw ArgumentError('Invalid block viewport request');
	}
}
