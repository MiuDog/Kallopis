/// 來源回報的保存作業階段；階段本身不證明特定修訂已落盤。
enum KlpEditingSavePhase { idle, saving, saved, failed }

/// 保存失敗的具型別原因；結果是否確定另由保存投影表達。
enum KlpEditingSaveError { rejected, conflict, unavailable, ioFailure, unknown }

/// 同一 editor source 的只讀保存作業狀態；不公開路徑或原生 fingerprint。
final class KlpEditingSaveProjection {
	final String documentId;
	final String pageId;
	final String sessionId;
	final int generation;
	final int stateRevision;
	final int jobId;
	final int requestedContentRevision;
	final int? confirmedSavedContentRevision;
	final KlpEditingSavePhase phase;
	final KlpEditingSaveError? error;
	final bool outcomeKnown;
	final bool retryAllowed;

	KlpEditingSaveProjection({
		required this.documentId,
		required this.pageId,
		required this.sessionId,
		required this.generation,
		required this.stateRevision,
		required this.jobId,
		required this.requestedContentRevision,
		required this.confirmedSavedContentRevision,
		required this.phase,
		required this.error,
		required this.outcomeKnown,
		required this.retryAllowed,
	}) {
		if (documentId.trim().isEmpty || pageId.trim().isEmpty || sessionId.trim().isEmpty || generation < 0 || stateRevision < 0 || jobId < 0 || requestedContentRevision < 0 || (confirmedSavedContentRevision ?? 0) < 0) throw ArgumentError('Invalid save projection identity or revision');
		if (jobId == 0 && phase != KlpEditingSavePhase.idle || confirmedSavedContentRevision != null && confirmedSavedContentRevision! > requestedContentRevision) throw ArgumentError('Save job or confirmed revision is inconsistent');
		if (phase == KlpEditingSavePhase.saved && (error != null || !outcomeKnown || retryAllowed || confirmedSavedContentRevision != requestedContentRevision)) throw ArgumentError('Saved projection must confirm its requested content revision');
		if (phase == KlpEditingSavePhase.failed && error == null || phase != KlpEditingSavePhase.failed && error != null) throw ArgumentError('Only failed projections carry an error');
		if (phase == KlpEditingSavePhase.failed && ((error == KlpEditingSaveError.unknown) != !outcomeKnown)) throw ArgumentError('Unknown save errors and outcome authority must agree');
		if (retryAllowed && (phase != KlpEditingSavePhase.failed || !outcomeKnown)) throw ArgumentError('Only a known failure may allow retry');
		if ((phase == KlpEditingSavePhase.idle || phase == KlpEditingSavePhase.saving) && (retryAllowed || phase == KlpEditingSavePhase.idle && !outcomeKnown)) throw ArgumentError('Invalid idle or saving save projection');
		if (phase == KlpEditingSavePhase.saving && outcomeKnown) throw ArgumentError('Saving cannot claim a settled outcome');
	}
}
