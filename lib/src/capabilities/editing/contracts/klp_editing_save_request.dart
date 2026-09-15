import 'klp_editing_stamp.dart';

/// 提供者支援的保存請求種類；實際保存與確認修訂由來源掌管。
enum KlpEditingSaveIntent { save, retry }

/// Manual save 與明確重試共用 editor 命令序號；目的地由 owner 持有。
final class KlpEditingSaveRequest {
	final int sequence;
	final KlpEditingStamp expected;
	final KlpEditingSaveIntent intent;
	final int? expectedStateRevision;
	final int? failedJobId;

	KlpEditingSaveRequest({required this.sequence, required this.expected, required this.intent, this.expectedStateRevision, this.failedJobId}) {
		if (sequence <= 0) throw ArgumentError('Save command sequence must be positive');
		final retry = intent == KlpEditingSaveIntent.retry;
		final hasAnyRetryField = expectedStateRevision != null || failedJobId != null;
		final hasBothRetryFields = expectedStateRevision != null && failedJobId != null;
		if (retry && (!hasBothRetryFields || expectedStateRevision! < 0 || failedJobId! <= 0) || !retry && hasAnyRetryField) throw ArgumentError('Retry requires the failed save state and job identity');
	}
}
