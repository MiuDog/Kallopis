import 'dart:async';

import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_intent.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_projection.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_reply.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_request.dart';
import 'package:kallopis/src/capabilities/editing/klp_editing_submission.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_text_offsets.dart';
import 'klp_flutter_text_input_result.dart';
import 'klp_flutter_text_plan.dart';
import 'klp_editing_command_sequence.dart';

/// 同一平台事件依序提交，收到權威回覆後才決定是否送出後續選取。
final class KlpFlutterTextInputSession {

	final KlpEditingSubmission _submission;
	final KlpEditingCommandSequence _sequence;
	bool _busy = false;
	bool _closed = false;
	bool _requiresResync = false;
	bool _interrupted = false;
	bool _interruptionSucceeded = false;
	bool _interrupting = false;
	Completer<void>? _settled;
	Future<KlpFlutterTextInputResult>? _interruption;

	KlpFlutterTextInputSession(KlpEditingProjection initial, FutureOr<KlpEditingReply> Function(KlpEditingRequest) submit, {KlpEditingCommandSequence? sequence})
		: _submission = KlpEditingSubmission(initial, submit),
			_sequence = sequence ?? KlpEditingCommandSequence();

	KlpEditingProjection get projection => _submission.projection;
	bool get requiresResync => _requiresResync || _submission.requiresResync;

	Future<KlpFlutterTextInputResult> submit(KlpFlutterTextPlan plan) async {
		if (_closed || _busy || _interrupted || requiresResync) throw StateError('Platform input session is unavailable');
		if (!identical(plan.delta.before, projection.window)) throw StateError('Platform input does not belong to the current publication');

		_busy = true;
		_settled = Completer<void>();
		final replies = <KlpEditingReply>[];
		KlpFlutterTextInputResult result(bool synchronized, [Object? error, StackTrace? stack]) => KlpFlutterTextInputResult(projection: projection, replies: replies, synchronized: synchronized, error: error, stackTrace: stack);
		try {
			// 操作不組成假交易；拒絕、關閉或前後文變更即停止，保留已接受的回覆。
			for (final intent in plan.edits) {
				final reply = await _send(intent);
				replies.add(reply);
				if (_closed || reply.decision != KlpEditingDecision.accepted || !_matchesStep(plan, intent)) {
					_requiresResync = true;
					return result(false);
				}
				if (_interrupted) return result(false);
			}

			// 核心替換後的游標可能不同；只在文字與視窗仍吻合時套用平台最終選取。
			if (!_matchesText(plan)) {
				_requiresResync = true;
				return result(false);
			}
			final delta = plan.delta;
			var window = projection.window!;
			if (delta.composingStartUtf8 == null && delta.anchorUtf8 != null && (window.anchorUtf8 != delta.anchorUtf8 || window.focusUtf8 != delta.focusUtf8)) {
				final reply = await _send(KlpSelectTextIntent(delta.anchorUtf8!, delta.focusUtf8!));
				replies.add(reply);
				if (_closed || reply.decision != KlpEditingDecision.accepted || !_matchesText(plan)) {
					_requiresResync = true;
					return result(false);
				}
				window = projection.window!;
				if (_interrupted) return result(false);
			}
			final synchronized = window.composingStartUtf8 == delta.composingStartUtf8 && window.composingEndUtf8 == delta.composingEndUtf8
				&& (delta.anchorUtf8 == null || (window.anchorUtf8 == delta.anchorUtf8 && window.focusUtf8 == delta.focusUtf8));
			_requiresResync = !synchronized;
			return result(synchronized);
		}
		catch (error, stack) {
			_requiresResync = true;
			return result(false, error, stack);
		}
		finally {
			_busy = false;
			_settled!.complete();
			_settled = null;
		}
	}

	/// 失焦、切頁與切模式共用：先停止新輸入，等在途命令確認後取消剩餘組字。
	Future<KlpFlutterTextInputResult> interrupt() {
		if (_closed) throw StateError('Platform input session is closed');
		if (_interruption != null) return _interruption!;

		_interrupted = true;
		_interruptionSucceeded = false;
		_interrupting = true;
		return _interruption = _interruptAfterPending().whenComplete(() => _interrupting = false);
	}

	Future<KlpFlutterTextInputResult> _interruptAfterPending() async {
		await _settled?.future;
		final replies = <KlpEditingReply>[];
		KlpFlutterTextInputResult result(bool synchronized, [Object? error, StackTrace? stack]) => KlpFlutterTextInputResult(projection: projection, replies: replies, synchronized: synchronized, error: error, stackTrace: stack);
		if (_closed || requiresResync) return result(false, StateError('Interruption requires an available synchronized authority'));

		_busy = true;
		try {
			// 不猜測未知命令結果，也不撤回已確認的提交；僅取消權威仍標示的組字。
			if (projection.window?.composingStartUtf8 != null) {
				final reply = await _send(const KlpCancelCompositionIntent());
				replies.add(reply);
				if (_closed || reply.decision != KlpEditingDecision.accepted) {
					_requiresResync = true;
					return result(false);
				}
			}
			_interruptionSucceeded = true;
			return result(true);
		}
		catch (error, stack) {
			_requiresResync = true;
			return result(false, error, stack);
		}
		finally { _busy = false; }
	}

	/// 平台重新取得焦點前，必須已確認前次中斷完成並同步目前投影。
	void resume() {
		if (_closed || _busy || _interrupting || requiresResync || (_interrupted && !_interruptionSucceeded)) throw StateError('Cannot resume unresolved platform input');

		_interrupted = false;
		_interruption = null;
		_interruptionSucceeded = false;
	}

	void resynchronize(KlpEditingProjection next) {
		if (_closed || _busy || _interrupting) throw StateError('Cannot resynchronize an active or closed platform event');

		_submission.resynchronize(next);
		_requiresResync = false;
		_interruption = null;
		_interruptionSucceeded = false;
	}

	void close() {
		_closed = true;
		_submission.close();
	}

	Future<KlpEditingReply> _send(KlpEditingIntent intent) {
		if (_closed) throw StateError('Platform input session is closed');

		final window = projection.window;
		if (window == null) throw StateError('Platform input lost its text window');

		return _submission.submit(KlpEditingRequest(sequence: _sequence.next(), expected: projection.stamp, blockId: window.blockId, intent: intent));
	}

	bool _matchesText(KlpFlutterTextPlan plan) {
		final window = projection.window;
		return window != null && window.blockId == plan.delta.before.blockId && window.sourceStartUtf8 == plan.delta.before.sourceStartUtf8 && window.text == plan.delta.requested.text;
	}

	bool _matchesStep(KlpFlutterTextPlan plan, KlpEditingIntent intent) {
		if (!_matchesText(plan)) return false;

		final window = projection.window!;
		final provisional = switch (intent) {
			KlpBeginCompositionIntent value => value.provisional,
			KlpUpdateCompositionIntent value => value.provisional,
			_ => null,
		};
		if (provisional == null) return window.composingStartUtf8 == null;

		final start = plan.delta.composingStartUtf8 ?? plan.delta.before.composingStartUtf8!;
		return window.composingStartUtf8 == start && window.composingEndUtf8 == start + KlpTextOffsets(provisional.text).utf8Length
			&& window.anchorUtf8 == start + provisional.anchorUtf8 && window.focusUtf8 == start + provisional.focusUtf8;
	}
}
