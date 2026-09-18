part of 'klp_editing_presentation.dart';

/// K04 所有確認與 viewport 操作共用 editor source 序號。
abstract interface class KlpBoundEditorModeActions {
	int issueCommandSequence();
	Future<KlpEditorModeReply> submitEditorMode(KlpEditorModeRequest request, {required int committedAtMs});
	Future<KlpEditorModeReply> submitEditorViewport(KlpEditorViewportRequest request, {required int committedAtMs});
}
