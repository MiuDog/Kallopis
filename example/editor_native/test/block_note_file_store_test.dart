import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';

import '../lib/block_note_file_store.dart';

KlpBlockNoteDocument _document(String text) => KlpBlockNoteDocument(schemaVersion: 1, blockNoteVersion: '0.54.2', blocks: [
	{'id': 'saved-paragraph', 'type': 'paragraph', 'content': [{'type': 'text', 'text': text, 'styles': {'bold': true}}], 'children': <Object?>[]},
]);

void main() {
	test('Windows durable replacement and failed readonly save preserve the original document', () async {
		// 所有操作只落在本次建立的專用暫存目錄，不觸碰既有文件。
		final directory = await Directory.systemTemp.createTemp('kallopis-blocknote-store-test-');
		final destination = File('${directory.path}${Platform.pathSeparator}document.json');
		final store = BlockNoteFileStore(destination);
		try {
			expect(await store.read(), isNull);
			await store.write(_document('第一次中文保存'));
			expect((await BlockNoteFileStore(destination).read())!.toJson(), _document('第一次中文保存').toJson());
			await store.write(_document('替換後的粗體中文'));
			final savedBytes = await destination.readAsBytes();
			expect((await BlockNoteFileStore(destination).read())!.toJson(), _document('替換後的粗體中文').toJson());

			// 由 Windows 唯讀旗標產生真實 replace 失敗，原文不得被預先刪除。
			final readonly = await Process.run('attrib.exe', ['+R', destination.path]);
			expect(readonly.exitCode, 0);
			await expectLater(store.write(_document('不應覆蓋原文')), throwsA(isA<Object>()));
			expect(await destination.readAsBytes(), savedBytes);
			expect((await BlockNoteFileStore(destination).read())!.toJson(), _document('替換後的粗體中文').toJson());
			expect((await directory.list().toList()).map((entry) => entry.path).toList(), [destination.path]);
		}
		finally {
			if (await destination.exists()) await Process.run('attrib.exe', ['-R', destination.path]);
			final temporaryRoot = Directory.systemTemp.absolute.path;
			if (!directory.absolute.path.startsWith('$temporaryRoot${Platform.pathSeparator}kallopis-blocknote-store-test-')) throw StateError('Refuse cleanup outside the dedicated test directory');
			await directory.delete(recursive: true);
		}
	});
}
