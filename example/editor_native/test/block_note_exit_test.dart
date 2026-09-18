import 'dart:async';
import 'dart:ui' show AppExitResponse;

import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/capabilities/block_note/internal/klp_block_note_bridge_port.dart';

import '../lib/block_note_main.dart';

final class _Port implements KlpBlockNoteBridgePort {
	final commands = <Map<String, Object?>>[];

	@override
	Future<void> send(Map<String, Object?> command) async {
		commands.add(command);
	}
}

void main() {
	final binding = TestWidgetsFlutterBinding.ensureInitialized();
	test('Catalog lifecycle cancels dirty and pending saves and exits only after confirmation', () async {
		final document = KlpBlockNoteDocument(schemaVersion: 1, blockNoteVersion: '0.54.2', blocks: [{'id': 'p', 'type': 'paragraph', 'content': '未存中文'}]);
		final port = _Port();
		final persisted = Completer<void>();
		final session = KlpBlockNoteSessionController(documentId: 'catalog-test', sessionId: 'exit-session', initialDocument: document, bridge: port, persist: (_) => persisted.future);
		final listener = installBlockNoteExitListener(session);
		try {
			await session.open();
			session.accept({'protocolVersion': 1, 'type': 'ready', 'sessionId': 'exit-session', 'requestId': port.commands.last['requestId'], 'revision': 0});
			session.accept({'protocolVersion': 1, 'type': 'changed', 'sessionId': 'exit-session', 'requestId': 100, 'revision': 1});
			expect(await binding.handleRequestAppExit(), AppExitResponse.cancel);
			expect(port.commands.where((command) => command['type'] == 'close'), isEmpty);

			// 使用真正註冊的 AppLifecycleListener；保存快照回覆仍不足以允許關閉。
			final save = session.save();
			await Future<void>.delayed(Duration.zero);
			session.accept({'protocolVersion': 1, 'type': 'snapshot.response', 'sessionId': 'exit-session', 'requestId': port.commands.last['requestId'], 'revision': 1, 'document': document.toJson()});
			expect(await binding.handleRequestAppExit(), AppExitResponse.cancel);
			expect(port.commands.where((command) => command['type'] == 'close'), isEmpty);
			persisted.complete();
			await save;
			expect(await binding.handleRequestAppExit(), AppExitResponse.exit);
			expect(port.commands.where((command) => command['type'] == 'close'), hasLength(1));
		}
		finally {
			listener.dispose();
		}
	});
}
