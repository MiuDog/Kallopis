import 'dart:async';

import 'package:kallopis/src/features/editing/presentation/klp_editing_presentation.dart';
import 'package:krepis_block_note/krepis_block_note.dart';

/// 同步交付回條與非同步產品互動分離，避免保存或操作鎖阻塞宿主 outbox。
final class KlpBlockNoteFlowTransport {

	final KlpBlockNoteSessionController session;
	final KlpBoundBlockNoteEditing Function() content;
	final Future<void> Function(Map<String, Object?>) send;
	final void Function(Object, StackTrace) onFailure;
	final void Function() onStatusChanged;
	late final StreamSubscription<KrepisBlockNoteOperationStatus> _subscription;
	String? _hostInstanceId;
	int _statusVersion = -1;
	int _barrierVersion = -1;
	bool _disposed = false;

	KlpBlockNoteFlowTransport({required this.session, required this.content, required this.send, required this.onFailure, required this.onStatusChanged}) {
		// 先訂閱再讀目前值；保留 registry 原有的 onChanged 所有權。
		_subscription = session.operationChanges.listen(_observe);
		_observe(session.operationStatus);
	}

	bool get blocked => session.operationStatus.state != KrepisBlockNoteOperationState.idle;
	bool get acceptsPageDrop => !_disposed && !blocked && content().onDatabaseDrop != null;

	Object? receive(Map<String, Object?> message) {
		if (_disposed) return null;

		if (!message.containsKey('flowProtocolVersion')) {
			session.accept(message);
			return null;
		}
		final receipt = session.acceptFlowMessage(message);
		if (receipt.received) _hostInstanceId = receipt.hostInstanceId;
		_trackBarrier(session.operationStatus);
		final interaction = receipt.interaction;
		if (interaction != null) {
			final barrier = _barrierVersion;
			// 使用事件佇列而非同步 callback，讓平台先取得完整 typed receipt。
			unawaited(Future<void>(() => _dispatch(interaction, barrier)));
		}
		return receipt.toJson();
	}

	Future<void> configurePages() async {
		if (_disposed) throw StateError('BlockNote attachment is closed');

		final result = await session.configurePages(projections: content().pageProjections);
		switch (result) {
			case KrepisBlockNoteEditRejected(:final failure):
			case KrepisBlockNoteEditUncertain(:final failure):
				throw KrepisBlockNoteOperationException(failure: failure);
			case KrepisBlockNoteEditApplied():
			case KrepisBlockNoteEditUnchanged():
				return;
		}
	}

	void dispose() {
		if (_disposed) return;

		_disposed = true;
		unawaited(_subscription.cancel());
	}

	void _trackBarrier(KrepisBlockNoteOperationStatus status) {
		if (status.state != KrepisBlockNoteOperationState.idle && status.statusVersion > _barrierVersion) _barrierVersion = status.statusVersion;
	}

	void _observe(KrepisBlockNoteOperationStatus status) {
		if (_disposed) return;

		_trackBarrier(status);
		final current = session.operationStatus;
		_trackBarrier(current);
		if (current.statusVersion <= _statusVersion) return;

		_statusVersion = current.statusVersion;
		onStatusChanged();
	}

	bool _valid(KrepisBlockNoteInteraction interaction, int barrier) {
		_trackBarrier(session.operationStatus);
		return !_disposed && !blocked && _hostInstanceId == interaction.hostInstanceId && barrier == _barrierVersion;
	}

	Future<void> _dispatch(KrepisBlockNoteInteraction interaction, int barrier) async {
		if (!_valid(interaction, barrier)) return;

		final response = <String, Object?>{};
		try {
			switch (interaction) {
				case KrepisPageOpenInteraction(:final request):
					final callback = content().onOpenPage;
					if (callback == null) throw StateError('BlockNote page opener is unavailable');

					await callback(request);
				case KrepisDatabaseDropInteraction(:final request):
					final callback = content().onDatabaseDrop;
					if (callback == null) throw StateError('BlockNote database drop handler is unavailable');

					response['editResult'] = _editJson(await callback(request));
			}
			response['status'] = 'completed';
		}
		catch (error, stack) {
			// 舊世代 callback 已失效，不能在新 attachment 上回報或重播。
			if (!_valid(interaction, barrier)) return;

			onFailure(error, stack);
			response['status'] = 'failed';
			response['failure'] = {'code': 'transportFailure', 'detail': 'interactionCallbackFailed'};
		}
		if (!_valid(interaction, barrier)) return;

		final version = session.currentVersion;
		try {
			await send({
				'protocolVersion': KlpBlockNoteSessionController.protocolVersion,
				'flowProtocolVersion': 1,
				'type': 'interaction.result',
				'documentId': session.documentId,
				'sessionId': session.sessionId,
				'hostInstanceId': interaction.hostInstanceId,
				'epoch': version.epoch,
				'revision': version.revision,
				'requestId': interaction.requestId,
				'interactionRequestId': interaction.requestId,
				'interactionDeliverySeq': interaction.deliverySeq,
				'interactionType': interaction is KrepisPageOpenInteraction ? 'page.open' : 'database.drop',
				...response,
			});
		}
		catch (error, stack) {
			if (!_disposed) onFailure(error, stack);
		}
	}

	Map<String, Object?> _editJson(KrepisBlockNoteEditResult result) {
		final value = <String, Object?>{'operation': result.operation, 'requestId': result.requestId};
		switch (result) {
			case KrepisBlockNoteEditApplied():
				value.addAll({'status': 'applied', 'version': {'epoch': result.version.epoch, 'revision': result.version.revision}, if (result.database != null) 'databaseId': result.database!.databaseId, if (result.view != null) 'viewId': result.view!.viewId, if (result.referenceId != null) 'referenceId': result.referenceId, if (result.rowIndex != null) 'rowIndex': result.rowIndex});
			case KrepisBlockNoteEditUnchanged():
				value.addAll({'status': 'unchanged', 'version': {'epoch': result.version.epoch, 'revision': result.version.revision}, if (result.database != null) 'databaseId': result.database!.databaseId, if (result.view != null) 'viewId': result.view!.viewId, if (result.referenceId != null) 'referenceId': result.referenceId, if (result.rowIndex != null) 'rowIndex': result.rowIndex});
			case KrepisBlockNoteEditRejected(:final failure):
				value.addAll({'status': 'rejected', 'failure': _failureJson(failure)});
			case KrepisBlockNoteEditUncertain(:final failure):
				value.addAll({'status': 'uncertain', 'failure': _failureJson(failure)});
		}
		return value;
	}

	Map<String, Object?> _failureJson(KrepisBlockNoteFailure failure) => {'code': failure.code.name, if (failure.detail != null) 'detail': failure.detail};
}
