import 'dart:async';

import 'package:kallopis/src/kernel/diagnostics/klp_contract_error.dart';
import 'klp_editing_draw_command.dart';
import 'klp_editing_drawing.dart';
import 'klp_editing_source.dart';
import 'klp_handwriting_state.dart';

/// 同一 editor source 擁有的獨立暫態筆跡通道；null 表示沒有未確認 capture。
abstract interface class KlpHandwritingStateSource implements KlpEditingSource {
	KlpHandwritingState? get inkState;
	Stream<KlpHandwritingState?> get inkStates;
}

/// 提供者內使用的有界 publication 狀態；不持有 editor source 或平台資源。
final class KlpHandwritingStatePublisher {
	final KlpEditingDrawing Function() _drawing;
	final StreamController<KlpHandwritingState?> _states = StreamController<KlpHandwritingState?>.broadcast(sync: false);
	KlpHandwritingState? _state;
	int _lastGeneration = 0;
	KlpHandwritingPhase? _lastKnownPhase;
	bool _closed = false;

	KlpHandwritingStatePublisher(this._drawing);

	KlpHandwritingState? get state => _state;
	Stream<KlpHandwritingState?> get states => _states.stream;

	KlpHandwritingState publish(KlpHandwritingState next) {
		if (_closed) throw const KlpContractError('closed_handwriting_publisher', 'Handwriting publisher is closed');
		final current = _state;
		if (identical(current, next)) return next;
		if (current == null) {
			if (next.phase != KlpHandwritingPhase.capturing || next.capture.generation <= _lastGeneration || !identical(next.drawing, _drawing())) throw const KlpContractError('invalid_handwriting_capture', 'New handwriting capture must start capturing with the source current drawing and a fresh generation');
		}
		else {
			_validateAdvance(current, next);
		}

		_state = next;
		_lastGeneration = next.capture.generation;
		if (next.phase != KlpHandwritingPhase.unknown) {
			_lastKnownPhase = next.phase;
		}
		_states.add(next);
		return next;
	}

	void clear(KlpHandwritingCaptureIdentity capture) {
		if (_closed) throw const KlpContractError('closed_handwriting_publisher', 'Handwriting publisher is closed');
		final current = _state;
		if (current == null || current.capture != capture || !current.terminal) throw const KlpContractError('invalid_handwriting_clear', 'Only the current confirmed terminal capture may be cleared');
		_state = null;
		_lastKnownPhase = null;
		_states.add(null);
	}

	Future<void> close() async {
		if (_closed) return;
		_closed = true;
		await _states.close();
	}

	void _validateAdvance(KlpHandwritingState current, KlpHandwritingState next) {
		if (next.capture != current.capture || !identical(next.drawing, current.drawing)) throw const KlpContractError('handwriting_capture_mismatch', 'Handwriting updates must retain capture identity and frozen drawing');
		if (current.terminal || next.acceptedBatchSequence < current.acceptedBatchSequence || next.previewRevision < current.previewRevision) throw const KlpContractError('handwriting_state_regression', 'Handwriting state cannot regress or revive a terminal capture');
		if (next.sampleCapacity != current.sampleCapacity) throw const KlpContractError('handwriting_capacity_mismatch', 'Handwriting sample capacity is fixed for one capture');
		final known = _lastKnownPhase ?? current.phase;
		if (!_allows(known, next.phase)) throw const KlpContractError('invalid_handwriting_transition', 'Handwriting phase transition is invalid');
		if (next.phase == KlpHandwritingPhase.unknown && (next.acceptedBatchSequence != current.acceptedBatchSequence || next.previewRevision != current.previewRevision || next.bufferedSampleCount != current.bufferedSampleCount || next.remainingSampleCapacity != current.remainingSampleCapacity || !_sameCommands(current.previewCommands, next.previewCommands))) throw const KlpContractError('invalid_handwriting_unknown', 'Unknown handwriting state must retain the last known receipt');
		if (!next.terminal && next.bufferedSampleCount < current.bufferedSampleCount) throw const KlpContractError('handwriting_sample_regression', 'Buffered handwriting samples cannot regress before a confirmed terminal result');
		if (next.previewRevision == current.previewRevision && !next.terminal && !_sameCommands(current.previewCommands, next.previewCommands)) throw const KlpContractError('handwriting_preview_revision_mismatch', 'Changed preview geometry requires a new revision');
		if (next.phase == current.phase && next.acceptedBatchSequence == current.acceptedBatchSequence && next.previewRevision == current.previewRevision &&
			(next.bufferedSampleCount != current.bufferedSampleCount || next.remainingSampleCapacity != current.remainingSampleCapacity)) {
			throw const KlpContractError('handwriting_receipt_mismatch', 'Changed sample receipt requires a version advance');
		}
	}
}

bool _allows(KlpHandwritingPhase current, KlpHandwritingPhase next) => switch (current) {
	KlpHandwritingPhase.capturing => true,
	KlpHandwritingPhase.overloaded => next == KlpHandwritingPhase.overloaded || next == KlpHandwritingPhase.canceled || next == KlpHandwritingPhase.unknown,
	KlpHandwritingPhase.unknown => false,
	KlpHandwritingPhase.committed || KlpHandwritingPhase.canceled => false,
};

bool _sameCommands(List<KlpEditingDrawCommand> left, List<KlpEditingDrawCommand> right) {
	if (left.length != right.length) return false;
	for (var index = 0; index < left.length; ++index) {
		if (!identical(left[index], right[index])) return false;
	}
	return true;
}
