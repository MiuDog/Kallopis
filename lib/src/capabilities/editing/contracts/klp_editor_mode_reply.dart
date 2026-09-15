import 'klp_editing_projection.dart';
import 'klp_editing_reply.dart';
import 'klp_editor_mode_projection.dart';

/// 已知結果同時攜帶模式與文件投影；未知結果以 error 表示。
final class KlpEditorModeReply {
	final KlpEditingDecision decision;
	final KlpEditingProjection editing;
	final KlpEditorModeProjection modes;

	KlpEditorModeReply(this.decision, this.editing, this.modes) {
		editing.stamp.requireExact(modes.stamp);
	}
}
