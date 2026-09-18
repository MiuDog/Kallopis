import 'dart:async';

import 'package:kallopis/src/capabilities/state/klp_mutable_state.dart';
import 'package:kallopis/src/capabilities/state/klp_state.dart';
import 'klp_editing_save_projection.dart';
import 'klp_editing_save_reply.dart';
import 'klp_editing_save_request.dart';
import 'klp_editing_source.dart';

abstract interface class KlpEditingSaveSource implements KlpEditingSource {
	KlpState<KlpEditingSaveProjection> get saveState;
	int issueCommandSequence();
	FutureOr<KlpEditingSaveReply> submitSave(KlpEditingSaveRequest request);
}

/// 提供者持有的單一保存狀態；只接受相同頁面且嚴格前進的 publication。
final class KlpEditingSaveStatePublisher {
	final KlpMutableState<KlpEditingSaveProjection> _state;
	bool _closed = false;

	KlpEditingSaveStatePublisher(KlpEditingSaveProjection initial) : _state = KlpMutableState(initial);

	KlpState<KlpEditingSaveProjection> get state => _state.readOnly;
	KlpEditingSaveProjection get value => _state.value;

	void publish(KlpEditingSaveProjection next) {
		if (_closed) throw StateError('Save state publisher is closed');
		final current = _state.value;
		if (next.documentId != current.documentId || next.pageId != current.pageId || next.sessionId != current.sessionId || next.generation != current.generation || next.stateRevision != current.stateRevision + 1 || next.jobId < current.jobId) throw StateError('Save state publication is stale or belongs to another source');
		if (current.phase == KlpEditingSavePhase.failed && !current.outcomeKnown) throw StateError('An unknown save result cannot be cleared without authority');
		if (current.phase == KlpEditingSavePhase.saving && next.jobId != current.jobId) throw StateError('A save job must settle before another job starts');
		if (current.phase == KlpEditingSavePhase.saving && next.jobId == current.jobId && next.phase != KlpEditingSavePhase.saved && next.phase != KlpEditingSavePhase.failed) throw StateError('A save job must settle as saved or failed');
		if (next.jobId > current.jobId && (next.jobId != current.jobId + 1 || next.phase != KlpEditingSavePhase.saving || next.confirmedSavedContentRevision != current.confirmedSavedContentRevision)) throw StateError('A new save job must begin in saving phase and preserve prior confirmation');
		if (next.jobId == current.jobId && current.phase == KlpEditingSavePhase.saving && (next.requestedContentRevision != current.requestedContentRevision || next.confirmedSavedContentRevision != current.confirmedSavedContentRevision && next.phase != KlpEditingSavePhase.saved)) throw StateError('A save result must retain its job authority');
		if (next.jobId == current.jobId && current.phase != KlpEditingSavePhase.saving && next.phase != KlpEditingSavePhase.idle) throw StateError('A settled job cannot produce another result');
		if (next.jobId == current.jobId && current.phase != KlpEditingSavePhase.saving && next.phase == KlpEditingSavePhase.idle && (next.requestedContentRevision <= current.requestedContentRevision || next.confirmedSavedContentRevision != current.confirmedSavedContentRevision)) throw StateError('Only newer edited content may return a settled save to idle');
		if (current.confirmedSavedContentRevision != null && next.confirmedSavedContentRevision == null) throw StateError('Confirmed saved content cannot be cleared');
		if (current.confirmedSavedContentRevision != null && next.confirmedSavedContentRevision != null && next.confirmedSavedContentRevision! < current.confirmedSavedContentRevision!) throw StateError('Confirmed saved content cannot regress');
		_state.value = next;
	}

	void close() {
		if (_closed) return;
		_closed = true;
		_state.dispose();
	}
}
