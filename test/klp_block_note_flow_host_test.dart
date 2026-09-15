import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'klp_page_reference_drop_test.dart' show FlowHostFixture;
import 'package:krepis_block_note/krepis_block_note.dart';

void main() {
	// 正式 Session 與 transport 共用公開 wire；fake 僅代替 Web handler 與保存 I/O。
	test('typed receipt returns before callback and callback save cannot block snapshot delivery', () async {
		final persisted = Completer<void>();
		final started = Completer<void>();
		final harness = FlowHostFixture(persist: (_) { started.complete(); return persisted.future; });
		addTearDown(harness.dispose);
		await harness.open();
		var callbacks = 0;
		harness.content = harness.bound(onOpenPage: (request) async {
			callbacks++;
			expect(request.page, KrepisPageReference(projectId: 'project-A', documentId: 'page-A'));
			expect(await harness.session.save(), KlpBlockNoteSaveResult.saved);
		});
		final message = harness.interaction('page.open', {'page': {'projectId': 'project-A', 'documentId': 'page-A'}, 'hostBlockId': 'link'});
		final receipt = harness.transport.receive(message);
		expect(receipt, _receipt(message));
		expect(receipt, isNot(isA<Future<Object?>>()));
		expect(callbacks, 0, reason: 'Consumer callback must not start inside receive');
		expect(harness.transport.receive(message), receipt);
		await started.future.timeout(const Duration(seconds: 2));
		expect(callbacks, 1);
		expect(harness.commands.where((value) => value['type'] == 'snapshot.request'), hasLength(1));
		expect(harness.results, isEmpty);
		persisted.complete();
		await pumpEventQueue(times: 3);
		expect(harness.results, hasLength(1));
		final result = harness.results.single;
		expect(result['type'], 'interaction.result');
		expect(result['interactionType'], 'page.open');
		expect(result['status'], 'completed');
		expect(result['requestId'], message['requestId']);
		expect(result['interactionRequestId'], message['requestId']);
		expect(result['interactionDeliverySeq'], message['deliverySeq']);
		expect(result['hostInstanceId'], 'host-A');
		expect(result.containsKey('editResult'), isFalse);
		expect(harness.failures, isEmpty);
	});

	test('database callback result is encoded without executing a second body command', () async {
		final harness = FlowHostFixture();
		addTearDown(harness.dispose);
		await harness.open();
		final database = KrepisDatabaseReference(databaseId: 'database');
		final view = KrepisDatabaseViewReference(database: database, viewId: 'table');
		final version = KrepisBlockNoteVersion(epoch: 0, revision: 1);
		final failure = KrepisBlockNoteFailure(code: KrepisBlockNoteFailureCode.staleVersion, operation: 'database.reference.insert', requestId: 44, detail: '版本已變更', cause: StateError('不應序列化'));
		final cases = <(KrepisBlockNoteEditResult, Map<String, Object?>)>[
			(KrepisBlockNoteEditApplied(operation: 'database.reference.insert', requestId: 42, version: version, database: database, view: view, referenceId: 'row', rowIndex: 2), {'operation': 'database.reference.insert', 'requestId': 42, 'status': 'applied', 'version': {'epoch': 0, 'revision': 1}, 'databaseId': 'database', 'viewId': 'table', 'referenceId': 'row', 'rowIndex': 2}),
			(KrepisBlockNoteEditUnchanged(operation: 'database.reference.move', requestId: 43, version: version, database: database, view: view, referenceId: 'row', rowIndex: 2), {'operation': 'database.reference.move', 'requestId': 43, 'status': 'unchanged', 'version': {'epoch': 0, 'revision': 1}, 'databaseId': 'database', 'viewId': 'table', 'referenceId': 'row', 'rowIndex': 2}),
			(KrepisBlockNoteEditRejected(failure: failure), {'operation': 'database.reference.insert', 'requestId': 44, 'status': 'rejected', 'failure': {'code': 'staleVersion', 'detail': '版本已變更'}}),
			(KrepisBlockNoteEditUncertain(failure: failure), {'operation': 'database.reference.insert', 'requestId': 44, 'status': 'uncertain', 'failure': {'code': 'staleVersion', 'detail': '版本已變更'}}),
		];
		for (final entry in cases) {
			harness.content = harness.bound(onDatabaseDrop: (request) async {
				expect(request.placement.view, view);
				expect(request.placement.rowIndex, 2);
				expect(request.page.projectId, 'project-B');
				expect(request.expectedVersion, KrepisBlockNoteVersion(epoch: 0, revision: 0));
				return entry.$1;
			});
			final message = harness.interaction('database.drop', {'page': {'projectId': 'project-B', 'documentId': 'same'}, 'databaseId': 'database', 'viewId': 'table', 'rowIndex': 2, 'expectedVersion': {'epoch': 0, 'revision': 0}});
			expect(harness.transport.receive(message), _receipt(message));
			await pumpEventQueue(times: 3);
			expect(harness.results.last['editResult'], entry.$2);
			expect(harness.results.last['status'], 'completed');
			expect(harness.results.last['interactionDeliverySeq'], message['deliverySeq']);
		}
		expect(harness.commands.where((value) => (value['type'] as String).startsWith('database.')), isEmpty);
		expect(harness.session.currentVersion, KrepisBlockNoteVersion(epoch: 0, revision: 0));
		expect(harness.failures, isEmpty);
	});

	test('callback failures retain original error and stack while returning one failed interaction result', () async {
		final harness = FlowHostFixture();
		addTearDown(harness.dispose);
		await harness.open();
		final error = StateError('consumer callback failed');
		final stack = StackTrace.fromString('original consumer stack');
		harness.content = harness.bound(onOpenPage: (_) async { Error.throwWithStackTrace(error, stack); });
		final message = harness.interaction('page.open', {'page': {'projectId': 'p', 'documentId': 'd'}, 'hostBlockId': 'link'});
		expect(harness.transport.receive(message), _receipt(message));
		await pumpEventQueue(times: 3);
		expect(harness.failures, hasLength(1));
		expect(harness.failures.single.$1, same(error));
		expect(harness.failures.single.$2, same(stack));
		expect(harness.results, hasLength(1));
		expect(harness.results.single['status'], 'failed');
		expect(harness.results.single['failure'], isA<Map<String, Object?>>());
		expect((harness.results.single['failure'] as Map).containsKey('cause'), isFalse);
		expect(harness.transport.receive(message), _receipt(message));
		await pumpEventQueue(times: 2);
		expect(harness.failures, hasLength(1));
		expect(harness.results, hasLength(1));
	});

	for (final boundary in ['dispose', 'barrier']) {
		for (final started in [false, true]) {
			test('$boundary cancels ${started ? 'late completion' : 'undispatched callback'} without replay', () async {
				final harness = FlowHostFixture();
				addTearDown(harness.dispose);
				await harness.open();
				final gate = Completer<void>();
				var callbacks = 0;
				harness.content = harness.bound(onOpenPage: (_) async { callbacks++; await gate.future; });
				final message = harness.interaction('page.open', {'page': {'projectId': 'p', 'documentId': 'd'}, 'hostBlockId': 'link'});
				harness.transport.receive(message);
				if (started) await pumpEventQueue(times: 2);
				expect(callbacks, started ? 1 : 0);
				KrepisBlockNoteOperationLock? lock;
				if (boundary == 'dispose') harness.detachTransport();
				else lock = await harness.session.acquireOperationLock();
				gate.complete();
				await pumpEventQueue(times: 3);
				expect(callbacks, started ? 1 : 0);
				expect(harness.results, isEmpty, reason: 'Completion from an invalid attachment/operation generation must not send interaction.result');
				if (lock != null) await harness.session.cancelOperationLock(lock);
				await pumpEventQueue(times: 2);
				expect(callbacks, started ? 1 : 0, reason: 'Unlock cannot replay the old callback');
			});
		}
	}

	test('operation observer keeps registry ownership, deduplicates status and stops after dispose', () async {
		final harness = FlowHostFixture();
		addTearDown(harness.dispose);
		await harness.open();
		final registry = harness.session.onChanged;
		harness.content = harness.bound(onDatabaseDrop: (_) async => KrepisBlockNoteEditRejected(failure: KrepisBlockNoteFailure(code: KrepisBlockNoteFailureCode.invalidTarget, operation: 'database.reference.insert', requestId: null)));
		expect(harness.transport.blocked, isFalse);
		expect(harness.transport.acceptsPageDrop, isTrue);
		final locking = harness.session.acquireOperationLock();
		expect(harness.transport.blocked, isTrue, reason: 'Getter must read acquiring state before asynchronous stream delivery');
		expect(harness.transport.acceptsPageDrop, isFalse);
		final lock = await locking;
		await pumpEventQueue(times: 2);
		expect(harness.session.onChanged, same(registry));
		expect(harness.registryNotices, greaterThan(0));
		final count = harness.statusVersions.length;
		final message = harness.responses.lastWhere((value) => value['type'] == 'operation.locked');
		harness.transport.receive(message);
		await pumpEventQueue(times: 2);
		expect(harness.statusVersions.length, count);
		harness.detachTransport();
		expect(harness.transport.acceptsPageDrop, isFalse);
		await harness.session.cancelOperationLock(lock);
		await pumpEventQueue(times: 2);
		expect(harness.statusVersions.length, count);
		expect(harness.session.onChanged, same(registry));
	});

	test('configure reads latest immutable projections and rejects unsuccessful result without reopening', () async {
		final harness = FlowHostFixture();
		addTearDown(harness.dispose);
		await harness.open();
		final page = KrepisPageReference(projectId: 'project-A', documentId: 'page-A');
		final source = [KrepisPageProjection(page: page, title: '第一版', availability: KrepisPageAvailability.available)];
		harness.content = harness.bound(projections: source);
		source.clear();
		await harness.transport.configurePages();
		expect(harness.commands.last['projections'], [{'page': {'projectId': 'project-A', 'documentId': 'page-A'}, 'title': '第一版', 'availability': 'available'}]);
		harness.content = harness.bound(projections: [KrepisPageProjection(page: page, title: '最新名稱', availability: KrepisPageAvailability.unavailable)]);
		await harness.transport.configurePages();
		expect((harness.commands.last['projections'] as List).single['title'], '最新名稱');
		harness.rejectConfiguration = true;
		await expectLater(harness.transport.configurePages(), throwsA(isA<KrepisBlockNoteOperationException>()));
		expect(harness.commands.where((value) => value['type'] == 'open'), hasLength(1));
		expect(harness.session.dirty, isFalse);
		expect(harness.session.currentVersion, KrepisBlockNoteVersion(epoch: 0, revision: 0));
	});

	test('legacy receive returns null and invalid host cannot dispatch or change the session', () async {
		final harness = FlowHostFixture();
		addTearDown(harness.dispose);
		final legacy = {'protocolVersion': 1, 'type': 'changed', 'documentId': 'document', 'sessionId': 'session', 'requestId': 1000, 'revision': 1, 'outline': <Object?>[]};
		expect(harness.transport.receive(legacy), isNull);
		expect(harness.session.dirty, isTrue);
		final flow = FlowHostFixture();
		addTearDown(flow.dispose);
		await flow.open();
		var callbacks = 0;
		flow.content = flow.bound(onOpenPage: (_) async { callbacks++; });
		final invalid = {...flow.interaction('page.open', {'page': {'projectId': 'p', 'documentId': 'd'}, 'hostBlockId': 'link'}), 'hostInstanceId': 'unexpected-host'};
		Object? receipt;
		try { receipt = flow.transport.receive(invalid); }
		on FormatException { /* 上游封套驗證拒絕，不採納錯誤 host。 */ }
		expect(receipt is Map && receipt['received'] == true, isFalse);
		await pumpEventQueue(times: 2);
		expect(callbacks, 0);
		expect(flow.results, isEmpty);
		expect(flow.session.currentVersion, KrepisBlockNoteVersion(epoch: 0, revision: 0));
	});
}

Map<String, Object?> _receipt(Map<String, Object?> message) => {'received': true, 'lane': 'ordinary', 'hostInstanceId': message['hostInstanceId'], 'messageType': message['type'], 'deliverySeq': message['deliverySeq']};
