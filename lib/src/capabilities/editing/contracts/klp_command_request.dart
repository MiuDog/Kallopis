import 'klp_command_anchor.dart';
import 'klp_editing_stamp.dart';

/// 單次確認攜帶候選 revision、完整 stamp 與同幀 typed anchor。
final class KlpCommandRequest {
	final int sequence;
	final KlpEditingStamp expected;
	final int commandRevision;
	final KlpCommandAnchor anchor;
	final String commandId;

	KlpCommandRequest({required this.sequence, required this.expected, required this.commandRevision, required this.anchor, required this.commandId}) {
		if (sequence <= 0 || commandRevision < 0 || commandId.trim().isEmpty) throw ArgumentError('Invalid anchored command request');
		expected.requireExact(anchor.stamp);
	}
}
