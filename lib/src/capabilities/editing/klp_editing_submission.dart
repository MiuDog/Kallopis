import 'dart:async';

import 'contracts/klp_editing_intent.dart';
import 'contracts/klp_editing_reply.dart';
import 'contracts/klp_editing_request.dart';
import 'contracts/klp_editing_projection.dart';
import 'contracts/klp_editing_text_window.dart';

/// 單一 session 的提交閘門；不自行修改文字，也不取消核心已開始的交易。
final class KlpEditingSubmission {

	final FutureOr<KlpEditingReply> Function(KlpEditingRequest request) _submit;
	KlpEditingProjection _projection;
	KlpEditingRequest? _lastRequest;
	Future<KlpEditingReply>? _lastFuture;
	bool _pending = false;
	bool _closed = false;
	bool _requiresResync = false;

	KlpEditingSubmission(this._projection, this._submit);

	KlpEditingProjection get projection => _projection;
	KlpEditingTextWindow? get window => _projection.window;
	bool get pending => _pending;
	bool get requiresResync => _requiresResync;

	Future<KlpEditingReply> submit(KlpEditingRequest request) {
		if (_closed) throw StateError('Editing submission is closed');

		// 同一事件取得原結果，不再次呼叫權威；只保留最後一筆，避免無界去重快取。
		if (identical(request, _lastRequest)) return _lastFuture!;
		if (_pending) throw StateError('Editing submission is busy; retain input until acknowledgement');
		if (_requiresResync) throw StateError('Editing submission requires authority resynchronization');
		if (_lastRequest != null && request.sequence <= _lastRequest!.sequence) throw StateError('Editing sequence must advance');

		_projection.stamp.requireExact(request.expected);
		final input = window;
		if (input == null) throw StateError('Single-block input is unavailable for this projection');
		if (request.blockId != input.blockId) throw StateError('Editing block does not match the input window');

		// 組字有獨立協定，不把一般替換或選取偷偷當成組字提交。
		final composing = input.composingStartUtf8 != null;
		switch (request.intent) {
			case KlpReplaceTextIntent intent:
				if (composing) throw StateError('Ordinary editing is unavailable during composition');
				input.offsets.toUtf16(intent.startUtf8);
				input.offsets.toUtf16(intent.endUtf8);
			case KlpSelectTextIntent intent:
				if (composing) throw StateError('Ordinary editing is unavailable during composition');
				input.offsets.toUtf16(intent.anchorUtf8);
				input.offsets.toUtf16(intent.focusUtf8);
			case KlpBeginCompositionIntent intent:
				if (composing) throw StateError('Composition is already active');
				input.offsets.toUtf16(intent.startUtf8);
				input.offsets.toUtf16(intent.endUtf8);
			case KlpUpdateCompositionIntent() || KlpCommitCompositionIntent() || KlpCancelCompositionIntent():
				if (!composing) throw StateError('Composition is not active');
			case KlpEditingCommandIntent():
				if (composing) throw StateError('Structural editing is unavailable during composition');
		}
		final completion = Completer<KlpEditingReply>();
		_lastRequest = request;
		_lastFuture = completion.future;
		_pending = true;

		// 先保存 pending 與結果，再呼叫可能同步回入的外部權威。
		Future<KlpEditingReply>.sync(() => _submit(request)).then((reply) {
			try {
				_validateSuccessor(reply.projection);
				if (reply.decision == KlpEditingDecision.accepted) _validateCompositionReply(request.intent, reply.projection);
				if (!_closed) {
					_projection = reply.projection;
				}
				_pending = false;
				completion.complete(reply);
			}
			catch (error, stack) {
				_fail(completion, error, stack);
			}
		}, onError: (Object error, StackTrace stack) => _fail(completion, error, stack));
		return completion.future;
	}

	void resynchronize(KlpEditingProjection next) {
		if (_closed || _pending) throw StateError('Cannot resynchronize a closed or pending submission');

		_validateSuccessor(next);
		_projection = next;
		_requiresResync = false;
	}

	void close() {
		// 晚到結果仍交還呼叫端，但不覆寫已關閉 session 的呈現投影。
		_closed = true;
	}

	void _validateSuccessor(KlpEditingProjection next) {
		final before = _projection.stamp;
		final after = next.stamp;
		if (!before.sameSession(after)) throw StateError('Authority reply belongs to another session');
		if (after.projectionRevision < before.projectionRevision || after.contentRevision < before.contentRevision || after.compositionRevision < before.compositionRevision || after.layoutRevision < before.layoutRevision) {
			throw StateError('Authority reply regressed');
		}
		if (after.projectionRevision == before.projectionRevision) {
			before.requireExact(after);
			if (!next.samePayload(_projection)) throw StateError('Authority changed input without advancing projection revision');
		}
	}
	void _fail(Completer<KlpEditingReply> completion, Object error, StackTrace stack) {
		_pending = false;
		_requiresResync = true;
		completion.completeError(error, stack);
	}

	void _validateCompositionReply(KlpEditingIntent intent, KlpEditingProjection next) {
		final active = next.window?.composingStartUtf8 != null;
		switch (intent) {
			case KlpBeginCompositionIntent() || KlpUpdateCompositionIntent():
				if (!active) throw StateError('Accepted composition must publish an active preview');
				if (next.stamp.contentRevision != _projection.stamp.contentRevision) throw StateError('Composition preview must not commit document content');
			case KlpCommitCompositionIntent() || KlpCancelCompositionIntent():
				if (active) throw StateError('Accepted composition termination must end the preview');
				if (intent is KlpCancelCompositionIntent && next.stamp.contentRevision != _projection.stamp.contentRevision) throw StateError('Composition cancellation must not commit document content');
			case KlpReplaceTextIntent() || KlpSelectTextIntent() || KlpEditingCommandIntent():
				if (active) throw StateError('Ordinary editing must not start composition');
		}
	}
}

