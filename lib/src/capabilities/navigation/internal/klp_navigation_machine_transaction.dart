part of 'klp_navigation_machine.dart';

extension _NavigationTransaction on KlpNavigationMachine {

	Future<void> _execute(_NavigationPending pending) async {
		try {
			// 步驟 1：所有非同步守衛完成前不改動已提交堆疊或畫面資源。
			final from = _state.value;
			final transition = KlpNavigationTransition(from, pending.candidate, pending.signal);
			final guards = [
				_policies[from.current.location.destination]!.beforeLeave,
				if (pending.beforeEnter.isEmpty)
					_policies[pending.candidate.current.location.destination]!.beforeEnter,
				...pending.beforeEnter.map((policy) => policy.beforeEnter),
			];
			for (final guard in guards) {
				if (guard == null) continue;

				final allowed = await Future.any<bool>([Future<bool>.sync(() => guard(transition)), pending.signal.whenCancelled.then((_) => false)]);
				if (!_current(pending)) return;
				if (!allowed) {
					_finishRejected(pending, const KlpNavigationRejected('guard'));
					return;
				}
			}
			if (!_current(pending)) return;

			// 步驟 2：提交埠必須標示不可回退的失敗，堆疊與結果跟隨實際提交。
			_committing = true;
			Object? failure;
			StackTrace? failureStack;
			try {
				commit(
					pending.candidate,
					replaceRouteInformation: pending.replaceRouteInformation,
				);
			}
			on KlpNavigationCommitException catch (error) {
				if (!error.committed) rethrow;

				failure = error.cause;
				failureStack = error.stackTrace;
			}
			catch (error, stack) {
				// 接點未交代提交狀態時停止此核心，不虛構回退或繼續導覽。
				_pending = null;
				_committing = false;
				pending.onRejected(KlpNavigationFailed(error, stack));
				dispose();
				pending.decision.completeError(KlpNavigationCommitContractException(error, stack), stack);
				return;
			}
			try {
				_state.value = pending.candidate;
			}
			catch (error, stack) {
				failure ??= error;
				failureStack ??= stack;
			}
			pending.onCommitted?.call();
			_pending = null;
			final outcome = failure == null ? const KlpNavigationCompleted<void>(null) : KlpNavigationFailed<void>(failure, failureStack!);
			pending.decision.complete(KlpNavigationDecision(true, outcome));
		}
		catch (error, stack) {
			if (_current(pending)) _finishRejected(pending, KlpNavigationFailed(error, stack));
		}
		finally {
			_committing = false;
		}
	}

	bool _current(_NavigationPending pending) => !_disposed && identical(_pending, pending) && !pending.signal.isCancelled;

	void _cancel(_NavigationPending pending, String reason) {
		if (!_current(pending) || _committing) return;

		pending.cancellation.complete();
		_finishRejected(pending, KlpNavigationCancelled(reason));
	}

	void _finishRejected(_NavigationPending pending, KlpNavigationOutcome<void> outcome) {
		_pending = null;
		pending.onRejected(outcome);
		pending.decision.complete(KlpNavigationDecision(false, outcome));
	}
}
