import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/capabilities/block_note/internal/klp_block_note_bridge_port.dart';
import 'package:kallopis/src/capabilities/block_note/internal/klp_block_note_document.dart';
import 'package:kallopis/src/capabilities/block_note/internal/klp_block_note_session_controller.dart';

final class _Port implements KlpBlockNoteBridgePort {
	final commands = <Map<String, Object?>>[];

	@override
	Future<void> send(Map<String, Object?> command) async {
		commands.add(Map<String, Object?>.from(command));
	}
}

KlpBlockNoteDocument _document(String text) => KlpBlockNoteDocument(schemaVersion: 1, blockNoteVersion: '0.54.2', blocks: [
	{'id': 'paragraph-a', 'type': 'paragraph', 'props': <String, Object?>{}, 'content': [{'type': 'text', 'text': text, 'styles': {'bold': true}}], 'children': <Object?>[]},
]);

Map<String, Object?> _message(String type, int requestId, int revision, {String sessionId = 'session-a', KlpBlockNoteDocument? document}) => {
	'protocolVersion': 1, 'type': type, 'sessionId': sessionId, 'requestId': requestId, 'revision': revision,
	if (document != null) 'document': document.toJson(),
};

Future<void> _open(KlpBlockNoteSessionController controller, _Port port) async {
	await controller.open();
	final command = port.commands.single;
	expect(command['type'], 'open');
	expect(command['protocolVersion'], 1);
	expect(command['sessionId'], 'session-a');
	expect(command['requestId'], isPositive);
	expect(command['revision'], 0);
	expect(command['messageIdStart'], 1000);
	controller.accept(_message('ready', command['requestId']! as int, 0));
}

void main() {
	test('versioned BlockNote JSON preserves content and rejects other formats', () {
		final document = _document('中文與粗體');
		final json = document.toJson();
		expect(json['format'], 'kallopis.blocknote');
		expect(KlpBlockNoteDocument.fromJson(Map<String, Object?>.from(jsonDecode(jsonEncode(json)) as Map)).toJson(), json);
		for (final invalid in [
			{...json, 'format': 'krepis'},
			{...json, 'schemaVersion': 2},
			{...json, 'blockNoteVersion': '0.0.0'},
			{...json, 'blocks': 'lost document'},
		]) {
			expect(() => KlpBlockNoteDocument.fromJson(invalid), throwsFormatException);
		}
	});

	test('only a matching snapshot may save and later edits remain dirty', () async {
		final port = _Port();
		final committed = Completer<void>();
		final persisted = <KlpBlockNoteDocument>[];
		final controller = KlpBlockNoteSessionController(documentId: 'document', sessionId: 'session-a', initialDocument: _document('original'), bridge: port, persist: (document) {
			persisted.add(document);
			return committed.future;
		});
		await _open(controller, port);
		expect((controller.revision, controller.confirmedSavedRevision, controller.dirty, controller.canClose), (0, 0, false, true));
		controller.accept(_message('changed', 100, 1));
		expect((controller.revision, controller.dirty, controller.canClose), (1, true, false));
		for (final message in [
			_message('changed', 100, 2),
			_message('changed', 101, 0),
			_message('changed', 101, 2, sessionId: 'old-session'),
			{..._message('changed', 101, 2), 'protocolVersion': 2},
		]) {
			try { controller.accept(message); }
			on FormatException { /* 未通過封包驗證不得改變現行版本。 */ }
			on StateError { /* 未通過封包驗證不得改變現行版本。 */ }
			expect(controller.revision, 1);
		}
		await controller.requestClose();
		expect(port.commands.where((command) => command['type'] == 'close'), isEmpty);
		final save = controller.save();
		await Future<void>.delayed(Duration.zero);
		final request = port.commands.last;
		expect(request['type'], 'snapshot.request');
		expect(request['revision'], 1);
		final requestId = request['requestId']! as int;
		expect(controller.saving, isTrue);

		// 異 session、錯誤 request 與舊快照不得觸發寫入或消耗待處理要求。
		for (final message in [
			_message('snapshot.response', requestId, 1, sessionId: 'old-session', document: _document('wrong session')),
			_message('snapshot.response', requestId + 1000, 1, document: _document('wrong request')),
			_message('snapshot.response', requestId, 0, document: _document('stale snapshot')),
		]) {
			try { controller.accept(message); }
			on FormatException { /* 明確拒絕同樣符合 fail closed。 */ }
			on StateError { /* 明確拒絕同樣符合 fail closed。 */ }
		}
		expect(persisted, isEmpty);
		expect((controller.dirty, controller.saving), (true, true));
		controller.accept(_message('snapshot.response', requestId, 1, document: _document('saved revision one')));
		await Future<void>.delayed(Duration.zero);
		expect(persisted.single.toJson(), _document('saved revision one').toJson());
		controller.accept(_message('changed', 101, 2));
		committed.complete();
		await save;
		expect((controller.revision, controller.confirmedSavedRevision, controller.dirty, controller.saving, controller.canClose), (2, 1, true, false, false));
		await controller.requestClose();
		expect(port.commands.where((command) => command['type'] == 'close'), isEmpty);
	});

	test('reopening uses the saved snapshot and a fresh message sequence without accepting stale changes', () async {
		final port = _Port();
		var failSave = false;
		final controller = KlpBlockNoteSessionController(documentId: 'document', sessionId: 'session-a', initialDocument: _document('original'), bridge: port, persist: (_) async {
			if (failSave) throw StateError('save failed');
		});
		await _open(controller, port);
		controller.accept(_message('changed', 1000, 1));
		final save = controller.save();
		await Future<void>.delayed(Duration.zero);
		controller.accept(_message('snapshot.response', port.commands.last['requestId']! as int, 1, document: _document('durable latest')));
		await save;
		await controller.open();
		final reopen = port.commands.last;
		expect(reopen['document'], _document('durable latest').toJson());
		expect(reopen['messageIdStart'], 1001);
		controller.accept(_message('ready', reopen['requestId']! as int, 1));
		expect(() => controller.accept(_message('changed', 1000, 2)), throwsStateError);
		expect((controller.revision, controller.dirty), (1, false));
		controller.accept(_message('changed', reopen['messageIdStart']! as int, 2));
		expect((controller.revision, controller.dirty), (2, true));

		// 失敗保存不能改寫下一次安全重開的 durable snapshot。
		failSave = true;
		final failed = controller.save();
		await Future<void>.delayed(Duration.zero);
		controller.accept(_message('snapshot.response', port.commands.last['requestId']! as int, 2, document: _document('not durable')));
		await failed;
		expect(controller.initialDocument.toJson(), _document('durable latest').toJson());
		expect((controller.confirmedSavedRevision, controller.dirty), (1, true));
	});

	test('missing snapshot releases saving and allows retry without losing edits', () async {
		final port = _Port();
		final persisted = <KlpBlockNoteDocument>[];
		final controller = KlpBlockNoteSessionController(documentId: 'document', sessionId: 'session-a', initialDocument: _document('original'), bridge: port, snapshotTimeout: const Duration(milliseconds: 10), persist: (document) async {
			persisted.add(document);
		});
		await _open(controller, port);
		controller.accept(_message('changed', 100, 1));
		await controller.save();
		final expiredRequestId = port.commands.last['requestId']! as int;
		expect((controller.revision, controller.confirmedSavedRevision, controller.saving, controller.dirty, controller.canClose), (1, 0, false, true, false));
		expect(controller.lastSaveError, isNotNull);
		expect(persisted, isEmpty);

		// 超時要求的遲到回覆不得佔用重試；新要求仍可保存同一版正文。
		final retry = controller.save();
		await Future<void>.delayed(Duration.zero);
		final retryRequestId = port.commands.last['requestId']! as int;
		expect(retryRequestId, isNot(expiredRequestId));
		try { controller.accept(_message('snapshot.response', expiredRequestId, 1, document: _document('late'))); }
		on FormatException { /* 遲到回覆必須維持未確認狀態。 */ }
		on StateError { /* 遲到回覆必須維持未確認狀態。 */ }
		expect(persisted, isEmpty);
		controller.accept(_message('snapshot.response', retryRequestId, 1, document: _document('retry retained edits')));
		await retry;
		expect(persisted.single.toJson(), _document('retry retained edits').toJson());
		expect((controller.confirmedSavedRevision, controller.saving, controller.dirty, controller.canClose), (1, false, false, true));
		expect(controller.lastSaveError, isNull);
	});

	test('failed save retains edits and successful retry can close and reopen the saved JSON', () async {
		final port = _Port();
		String? durableJson;
		var attempts = 0;
		final controller = KlpBlockNoteSessionController(documentId: 'document', sessionId: 'session-a', initialDocument: _document('original'), bridge: port, persist: (document) async {
			if (++attempts == 1) throw StateError('disk unavailable');
			durableJson = jsonEncode(document.toJson());
		});
		await _open(controller, port);
		controller.accept(_message('changed', 100, 1));
		var save = controller.save();
		await Future<void>.delayed(Duration.zero);
		controller.accept(_message('snapshot.response', port.commands.last['requestId']! as int, 1, document: _document('未存的中文')));
		await save;
		expect((controller.confirmedSavedRevision, controller.dirty, controller.saving, controller.canClose), (0, true, false, false));
		expect(controller.lastSaveError, isNotNull);
		expect(durableJson, isNull);
		await controller.requestClose();
		expect(port.commands.where((command) => command['type'] == 'close'), isEmpty);
		save = controller.save();
		await Future<void>.delayed(Duration.zero);
		controller.accept(_message('snapshot.response', port.commands.last['requestId']! as int, 1, document: _document('未存的中文')));
		await save;
		expect((attempts, controller.confirmedSavedRevision, controller.dirty, controller.canClose), (2, 1, false, true));
		expect(controller.lastSaveError, isNull);
		await controller.requestClose();
		expect(port.commands.where((command) => command['type'] == 'close'), hasLength(1));
		final reopenedPort = _Port();
		final reopened = KlpBlockNoteSessionController(documentId: 'document', sessionId: 'session-a', initialDocument: KlpBlockNoteDocument.fromJson(Map<String, Object?>.from(jsonDecode(durableJson!) as Map)), bridge: reopenedPort, persist: (_) async {});
		await _open(reopened, reopenedPort);
		expect(reopenedPort.commands.single['document'], _document('未存的中文').toJson());
		expect(reopened.dirty, isFalse);
	});
}
