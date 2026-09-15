import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/features/editing/presentation/klp_editing_presentation.dart';
import 'package:krepis_block_note/krepis_block_note.dart';

import 'support/klp_web_editing_platform_fixture.dart';
import 'support/load_test_fonts.dart';

void main() {
	setUpAll(loadKlpTestFonts);
	late KlpWebPlatform platform;
	late InAppWebViewPlatform? original;
	setUp(() {
		original = InAppWebViewPlatform.instance;
		platform = KlpWebPlatform();
		InAppWebViewPlatform.instance = platform;
	});
	tearDown(() { InAppWebViewPlatform.instance = original ?? KlpWebPlatform(); });

	testWidgets('active session without retirement proof never opens a replacement host', (tester) async {
		final failures = <KlpEditingHostFailure>[];
		final fixture = _RetirementFixture('no-proof');
		await tester.pumpWidget(klpWebHost([fixture.content()], onFailure: failures.add));
		await settleWeb(tester);
		final originalView = platform.views.single;
		final originalHost = _FlowResponder(originalView, 'host-original');
		originalView.platform.send = originalHost.respond;
		originalView.loadStop();
		await _settleAsync(tester);
		expect(originalHost.commandsOf('open'), hasLength(1));
		expect(fixture.session.canDetachHost, isFalse);

		// Flutter dispose 已無法取消；重新出現的 widget 仍不能把舊 host 的 open 送給新宿主。
		await tester.pumpWidget(const SizedBox.shrink());
		await settleWeb(tester);
		await tester.pumpWidget(klpWebHost([fixture.content()], onFailure: failures.add));
		await settleWeb(tester);
		final replacementView = platform.views.last;
		final replacementHost = _FlowResponder(replacementView, 'host-replacement');
		replacementView.platform.send = replacementHost.respond;
		replacementView.loadStop();
		await _settleAsync(tester);

		expect(replacementHost.commandsOf('open'), isEmpty, reason: '沒有 retirement proof 不得主動重新 open');
		expect(fixture.session.canDetachHost, isFalse);
	});

	testWidgets('retirement proof reattaches the same session with its last saved document only after full ready receipt', (tester) async {
		final failures = <KlpEditingHostFailure>[];
		final fixture = _RetirementFixture('proof');
		var opened = 0;
		await tester.pumpWidget(klpWebHost([fixture.content(onOpened: () async { opened++; })], onFailure: failures.add));
		await settleWeb(tester);
		final oldView = platform.views.single;
		final oldHost = _FlowResponder(oldView, 'host-old');
		oldView.platform.send = oldHost.respond;
		oldView.loadStop();
		await _settleAsync(tester);
		expect(opened, 1);

		final saved = _document('latest saved body');
		oldHost.document = saved;
		await oldHost.changed();
		final close = fixture.session.requestClose();
		await _settleAsync(tester);
		expect(await close, KrepisBlockNoteCloseResult.closed);
		expect(fixture.persisted.single.toJson(), saved.toJson());
		expect(fixture.session.canDetachHost, isTrue);

		await tester.pumpWidget(const SizedBox.shrink());
		await settleWeb(tester);
		await tester.pumpWidget(klpWebHost([fixture.content(onOpened: () async { opened++; })], onFailure: failures.add));
		await settleWeb(tester);
		final newView = platform.views.last;
		final newHost = _FlowResponder(newView, 'host-new', autoReady: false);
		newView.platform.send = newHost.respond;
		newView.loadStop();
		await _settleAsync(tester);

		final reopened = newHost.commandsOf('open').single;
		expect(reopened['hostInstanceId'], 'host-new');
		expect(reopened['document'], saved.toJson(), reason: '新宿主只能使用 retirement proof 的最後保存正文');
		expect(opened, 1, reason: '完整 ready/readback 的 typed receipt 前不得宣告恢復');
		expect(fixture.session.operationState, KrepisBlockNoteOperationState.attaching);

		final receipt = await newHost.ready(reopened);
		expect(receipt, {
			'received': true,
			'lane': 'ordinary',
			'hostInstanceId': 'host-new',
			'messageType': 'ready',
			'deliverySeq': 1,
		});
		await _settleAsync(tester);
		expect(opened, 2);
		expect(fixture.session.operationState, KrepisBlockNoteOperationState.idle);
		expect(fixture.session.initialDocument.toJson(), saved.toJson());
		expect(failures, isEmpty);
	});

	testWidgets('page callback may request close without blocking its synchronous delivery receipt', (tester) async {
		final failures = <KlpEditingHostFailure>[];
		final fixture = _RetirementFixture('callback-close');
		final closeCompleted = Completer<KrepisBlockNoteCloseResult>();
		await tester.pumpWidget(klpWebHost([fixture.content(onOpenPage: (_) async {
			closeCompleted.complete(await fixture.session.requestClose());
		})], onFailure: failures.add));
		await settleWeb(tester);
		final view = platform.views.single;
		final host = _FlowResponder(view, 'host-callback');
		view.platform.send = host.respond;
		view.loadStop();
		await _settleAsync(tester);

		final receipt = await host.pageOpen().timeout(const Duration(seconds: 1));
		expect(receipt, {
			'received': true,
			'lane': 'ordinary',
			'hostInstanceId': 'host-callback',
			'messageType': 'page.open',
			'deliverySeq': 3,
		});
		await _settleAsync(tester);
		expect(await closeCompleted.future.timeout(const Duration(seconds: 1)), KrepisBlockNoteCloseResult.closed);
		expect(fixture.session.canDetachHost, isTrue);
		expect(failures, isEmpty);
	});
}

final class _RetirementFixture {
	final KlpBlockNoteBridgeChannel channel = KlpBlockNoteBridgeChannel();
	final persisted = <KlpBlockNoteDocument>[];
	late final KlpBlockNoteSessionController session;
	_RetirementFixture(String id) {
		session = KlpBlockNoteSessionController(
			documentId: id,
			sessionId: id,
			initialDocument: _document('initial body'),
			bridge: channel,
			persist: (document) async { persisted.add(KlpBlockNoteDocument.fromJson(document.toJson())); },
			operationTimeout: const Duration(milliseconds: 200),
		);
	}

	KlpBoundBlockNoteEditing content({Future<void> Function()? onOpened, Future<void> Function(KrepisPageOpenRequest)? onOpenPage}) => KlpBoundBlockNoteEditing(
		session,
		background: '#ffffff',
		text: '#000000',
		fontFamily: 'Test',
		fontSize: 14,
		onOpened: onOpened,
		onOpenPage: onOpenPage,
	);
}

final class _FlowResponder {
	final KlpWebView view;
	final String hostInstanceId;
	final bool autoReady;
	int deliverySeq = 0;
	int revision = 0;
	int eventSeq = 0;
	KlpBlockNoteDocument document = _document('initial body');
	_FlowResponder(this.view, this.hostInstanceId, {this.autoReady = true});

	Iterable<Map<String, Object?>> commandsOf(String type) => view.platform.commands.where((command) => command['type'] == type);

	Future<void> respond(Map<String, Object?> command) async {
		switch (command['type']) {
			case 'flow.capabilities.request':
				await _receive(command, 'flow.capabilities.response', control: true, fields: {
					'capabilities': {'pageLinksV1': true, 'databaseTableV1': true, 'operationGateV1': true},
					'lastDeliverySeq': 0,
				});
			case 'open':
				document = KlpBlockNoteDocument.fromJson(Map<String, Object?>.from(command['document'] as Map));
				revision = command['revision'] as int;
				eventSeq = 0;
				if (autoReady) await ready(command);
			case 'page.configure':
				await _receive(command, 'command.result', fields: {'commandType': 'page.configure', 'status': 'unchanged'});
			case 'operation.lock':
				await _receive(command, 'operation.locked', fields: {
					'lockId': command['lockId'],
					'barrierEventSeq': eventSeq,
					'document': document.toJson(),
					'outline': <Object?>[],
				});
			case 'operation.retire':
				await _receive(command, 'operation.retired', fields: {
					'lockId': command['lockId'],
					'retirementId': command['retirementId'],
					'document': document.toJson(),
					'outline': <Object?>[],
				});
		}
	}

	Future<Object?> ready(Map<String, Object?> open) => _receive(open, 'ready', fields: {'document': document.toJson(), 'outline': <Object?>[]});

	Future<void> changed() async {
		revision++;
		eventSeq++;
		await _receive({'requestId': 9000 + eventSeq}, 'changed', fields: {'outline': <Object?>[]});
	}

	Future<Object?> pageOpen() => _receive({'requestId': 8001}, 'page.open', fields: {
		'page': {'projectId': 'project', 'documentId': 'target'},
		'hostBlockId': 'link',
	});

	Future<Object?> _receive(Map<String, Object?> command, String type, {bool control = false, Map<String, Object?> fields = const {}}) {
		final identity = view.platform.commands.firstWhere((candidate) => candidate.containsKey('documentId'));
		return view.receive('KallopisBlockNote', [{
			'protocolVersion': 1,
			'flowProtocolVersion': 1,
			'type': type,
			'documentId': command['documentId'] ?? identity['documentId'],
			'sessionId': command['sessionId'] ?? identity['sessionId'],
			'requestId': command['requestId'],
			'hostInstanceId': hostInstanceId,
			'epoch': 0,
			'revision': revision,
			'eventSeq': eventSeq,
			'lane': control ? 'control' : 'ordinary',
			if (!control) 'deliverySeq': ++deliverySeq,
			...fields,
		}]);
	}
}

KlpBlockNoteDocument _document(String text) => KlpBlockNoteDocument(
	schemaVersion: 1,
	blockNoteVersion: '0.54.2',
	blocks: [{
		'id': 'paragraph',
		'type': 'paragraph',
		'props': <String, Object?>{},
		'content': [{'type': 'text', 'text': text, 'styles': <String, Object?>{}}],
		'children': <Object?>[],
	}],
);

Future<void> _settleAsync(WidgetTester tester) async {
	for (var turn = 0; turn < 8; turn++) {
		await tester.pump(Duration.zero);
	}
}
