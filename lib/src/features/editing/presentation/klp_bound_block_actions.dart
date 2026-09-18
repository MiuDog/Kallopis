part of 'klp_editing_presentation.dart';

/// 區塊命令只接受完整 stamp 與 stable ID，不暴露核心或平台物件。
abstract interface class KlpBoundBlockActions {
	int issueCommandSequence();
	Future<KlpEditingReply> submitBlock(KlpBlockRequest request, {required int committedAtMs});
	Future<KlpEditingReply> submitBlockViewport(KlpBlockViewportRequest request, {required int committedAtMs});
}
