import 'klp_editing_stamp.dart';

/// 模式確認只攜帶註冊 ID、完整 stamp 與全 editor 共用序號。
final class KlpEditorModeRequest {
	final int sequence;
	final KlpEditingStamp expected;
	final int modeRevision;
	final String modeId;
	final String toolId;

	KlpEditorModeRequest({required this.sequence, required this.expected, required this.modeRevision, required this.modeId, required this.toolId}) {
		if (sequence <= 0 || modeRevision < 0 || modeId.trim().isEmpty || toolId.trim().isEmpty) throw ArgumentError('Invalid editor mode request');
	}
}
