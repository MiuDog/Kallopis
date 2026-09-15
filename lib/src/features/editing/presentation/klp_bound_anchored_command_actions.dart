part of 'klp_editing_presentation.dart';

/// 定位命令只接受候選 ID、typed anchor 與完整 stamp。
abstract interface class KlpBoundAnchoredCommandActions {
	int issueCommandSequence();
	Future<KlpCommandReply> submitAnchoredCommand(KlpCommandRequest request, {required int committedAtMs});
}
