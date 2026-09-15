import 'klp_editing_stamp.dart';

/// 導覽 handler 送出的真實垂直 delta；來源依核心 extent 限制結果。
final class KlpEditorViewportRequest {
	final int sequence;
	final KlpEditingStamp expected;
	final int modeRevision;
	final double deltaY;

	KlpEditorViewportRequest({required this.sequence, required this.expected, required this.modeRevision, required this.deltaY}) {
		if (sequence <= 0 || modeRevision < 0 || !deltaY.isFinite || deltaY == 0) throw ArgumentError('Invalid editor viewport request');
	}
}
