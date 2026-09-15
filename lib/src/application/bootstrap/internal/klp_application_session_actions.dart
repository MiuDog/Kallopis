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

	bool get _valid =>
			!session._disposed &&
			!session._terminal &&
			!session._projecting &&
			!session._processing &&
			epoch.committed &&
			identical(session._epoch, epoch) &&
			session._machine?.isDisposed == false &&
			session._machine?.state.value.current.id == entry.id;

	@override
	KlpNavigationTicket<T> push<T>(KlpLocation<T> location) {
		if (_valid) return session._machine!.push(location);
		return KlpNavigationTicket(
			Future.value(
				const KlpNavigationDecision(
					false,
					KlpNavigationRejected('inactiveEntry'),
				),
			),
			Future.value(KlpNavigationRejected<T>('inactiveEntry')),
			() {},
		);
	}

	@override
	Future<KlpNavigationDecision> complete(Object? result) {
		if (_valid) {
			return session._machine!.complete(entry.location.destination, result);
		}
		return Future.value(
			const KlpNavigationDecision(
				false,
				KlpNavigationRejected('inactiveEntry'),
			),
		);
	}

	@override
	Future<KlpNavigationDecision> cancel() {
		if (_valid) return session._machine!.pop();
		return Future.value(
			const KlpNavigationDecision(
				false,
				KlpNavigationRejected('inactiveEntry'),
			),
		);
	}
}

/// application 是唯一能理解 route action 的層；feature 僅依賴 action handler 介面。
final class _KlpApplicationActionHandler implements KlpActionHandler {
	final _KlpApplicationSession session;

	const _KlpApplicationActionHandler(this.session);

	@override
	bool accepts(KlpAction action) => switch (action) {
		KlpCallbackAction() || _KlpRouteAction() || KlpPickFileAction() => true,
		_ => false,
	};

	@override
	Future<KlpActionActivation> activate(
		KlpAction action,
		KlpPlacementId source,
	) async {
		switch (action) {
			case KlpCallbackAction(:final callback):
				callback();
				return const KlpActionActivation(true);
			case KlpPickFileAction():
				return _pickFile(action);
			case _KlpRouteAction():
				return action.activate(this);
			default:
				return const KlpActionActivation(false);
		}
	}


	Future<KlpActionActivation> _pickFile(KlpPickFileAction action) async {
		// 步驟 1：保留本次啟動的完整世代與事件身分，不能以 placement 重找新動作。
		final frame = session.frame;
		final epoch = session._epoch;
		final entryId = session._machine?.state.value.current.id;
		if (frame == null || epoch == null || entryId == null || session._disposed || session._terminal || session._projecting || !epoch.committed || !frame.lease.isActive) {
			return const KlpActionActivation(false);
		}

		final lease = frame.lease;
		final onPicked = action.onPicked;
		final request = KlpFileSelectionRequest(acceptedExtensions: action.acceptedExtensions);
		try {
			// 步驟 2：唯一宿主能力執行平台選檔，每次有效啟動各有獨立請求。
			final result = await session.fileSelection.select(request);
			if (result case KlpFileSelectionFailed(:final error, :final stackTrace)) {
				session.onAsyncError(error, stackTrace);
				return const KlpActionActivation(false);
			}

			// 步驟 3：等待後重新驗證原影格；晚到成功不能送入更新後的應用。
			if (session._disposed || session._terminal || !identical(session.frame, frame) || !identical(session._epoch, epoch) || !epoch.committed || !lease.isActive || session._machine?.state.value.current.id != entryId) {
				return const KlpActionActivation(false);
			}

			if (result case KlpFileSelected(:final path)) {
				onPicked(path);
				return const KlpActionActivation(true);
			}

			return const KlpActionActivation(false);
		}
		catch (error, stackTrace) {
			session.onAsyncError(error, stackTrace);
			return const KlpActionActivation(false);
		}
	}

	Future<KlpActionActivation> push<T>(_KlpPushAction<T> action) async {
		final ticket = action.actions.push(action.location);
		unawaited(_deliverResult(ticket, action.onResult));
		return KlpActionActivation((await ticket.decision).committed);
	}

	Future<KlpActionActivation> finish(_KlpFinishAction action) async =>
			KlpActionActivation(
				(await action.actions.complete(action.result)).committed,
			);

	Future<KlpActionActivation> back(_KlpBackAction action) async =>
			KlpActionActivation((await action.actions.cancel()).committed);

	Future<void> _deliverResult<T>(
		KlpNavigationTicket<T> ticket,
		void Function(T value)? onResult,
	) async {
		if (onResult == null) return;
		try {
			final outcome = await ticket.result;
			if (outcome case KlpNavigationCompleted<T>(:final value)) onResult(value);
		} catch (error, stackTrace) {
			session.onAsyncError(error, stackTrace);
		}
	}
}
