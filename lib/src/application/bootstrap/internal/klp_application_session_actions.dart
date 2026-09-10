part of '../../structure/klp_application.dart';

final class _KlpApplicationEpoch {

	bool committed = false;
}

/// 操作借用綁定完整 entry 與已提交世代，舊輸入與隱藏頁不能啟動交易。
final class _KlpSessionRouteActions implements _KlpRouteActions {

	final _KlpApplicationSession session;
	final _KlpApplicationEpoch epoch;
	final KlpNavigationEntry entry;

	const _KlpSessionRouteActions(this.session, this.epoch, this.entry);

	bool get _valid => !session._disposed && !session._terminal && !session._projecting && !session._processing && epoch.committed && identical(session._epoch, epoch) && session._machine?.isDisposed == false && session._machine?.state.value.current.id == entry.id;

	@override
	KlpNavigationTicket<T> push<T>(KlpLocation<T> location) {
		if (_valid) return session._machine!.push(location);
		return KlpNavigationTicket(Future.value(const KlpNavigationDecision(false, KlpNavigationRejected('inactiveEntry'))), Future.value(KlpNavigationRejected<T>('inactiveEntry')), () {});
	}

	@override
	Future<KlpNavigationDecision> complete(Object? result) {
		if (_valid) return session._machine!.complete(entry.location.destination, result);
		return Future.value(const KlpNavigationDecision(false, KlpNavigationRejected('inactiveEntry')));
	}

	@override
	Future<KlpNavigationDecision> cancel() {
		if (_valid) return session._machine!.pop();
		return Future.value(const KlpNavigationDecision(false, KlpNavigationRejected('inactiveEntry')));
	}
}

/// application 是唯一能理解 route action 的層；feature 僅依賴 action handler 介面。
final class _KlpApplicationActionHandler implements KlpActionHandler {

	final _KlpApplicationSession session;

	const _KlpApplicationActionHandler(this.session);

	@override
	bool accepts(KlpAction action) => switch (action) {
		KlpCallbackAction() || _KlpRouteAction() => true,
		_ => false,
	};

	@override
	Future<KlpActionActivation> activate(KlpAction action, KlpPlacementId source) async {
		switch (action) {
			case KlpCallbackAction(:final callback):
				callback();
				return const KlpActionActivation(true);
			case _KlpRouteAction():
				return action.activate(this);
			default:
				return const KlpActionActivation(false);
		}
	}

	Future<KlpActionActivation> push<T>(_KlpPushAction<T> action) async {
		final ticket = action.actions.push(action.location);
		unawaited(_deliverResult(ticket, action.onResult));
		return KlpActionActivation((await ticket.decision).committed);
	}

	Future<KlpActionActivation> finish(_KlpFinishAction action) async => KlpActionActivation((await action.actions.complete(action.result)).committed);

	Future<KlpActionActivation> back(_KlpBackAction action) async => KlpActionActivation((await action.actions.cancel()).committed);

	Future<void> _deliverResult<T>(KlpNavigationTicket<T> ticket, void Function(T value)? onResult) async {
		if (onResult == null) return;
		try {
			final outcome = await ticket.result;
			if (outcome case KlpNavigationCompleted<T>(:final value)) onResult(value);
		}
		catch (error, stackTrace) {
			session.onAsyncError(error, stackTrace);
		}
	}
}
