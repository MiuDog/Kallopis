import 'dart:convert';
import 'dart:io';
import 'dart:ui' show AppExitResponse;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis_catalog/catalog_declarative/catalog_application.dart';

import 'block_note_file_store.dart';

Future<void> main() async {
	WidgetsFlutterBinding.ensureInitialized();
	final store = BlockNoteFileStore(File(_documentPath()));
	final saved = await store.read();
	final initial = saved ?? await _sampleDocument();
	final session = KlpBlockNoteSessionController.hosted(
		documentId: 'catalog.blocknote.document',
		sessionId: 'catalog.blocknote.${DateTime.now().microsecondsSinceEpoch}',
		initialDocument: initial,
		persist: store.write,
	);
	installBlockNoteExitListener(session);
	runCatalog(stage: KlpBlockNoteEditingContent(id: KlpId.parse('catalog.blocknote.editor'), controller: session));
}

AppLifecycleListener installBlockNoteExitListener(KlpBlockNoteSessionController session) {
	return AppLifecycleListener(onExitRequested: () async {
		final result = await session.requestClose();
		return result == KlpBlockNoteCloseResult.closed ? AppExitResponse.exit : AppExitResponse.cancel;
	});
}

String _documentPath() {
	const configured = String.fromEnvironment('BLOCKNOTE_DOCUMENT');
	if (configured.isNotEmpty) return configured;
	final localData = Platform.environment['LOCALAPPDATA'];
	if (localData == null || localData.isEmpty) throw StateError('LOCALAPPDATA is required when BLOCKNOTE_DOCUMENT is not set');
	return '$localData\\Kallopis\\blocknote-catalog.json';
}

Future<KlpBlockNoteDocument> _sampleDocument() async {
	// 將套件內本地圖片轉成自包含資料，重開不依賴暫時 URL 或外部服務。
	final image = await rootBundle.load('packages/kallopis/assets/blocknote_editor/sample-image.png');
	final imageData = base64Encode(image.buffer.asUint8List(image.offsetInBytes, image.lengthInBytes));
	return KlpBlockNoteDocument(
		schemaVersion: 1,
		blockNoteVersion: '0.54.2',
		blocks: [
			{'type': 'paragraph', 'content': '這是 Kallopis 的 BlockNote 正式接入切片。'},
			{'type': 'bulletListItem', 'content': '第一層清單', 'children': [{'type': 'bulletListItem', 'content': '第二層清單'}]},
			{'type': 'table', 'content': {'type': 'tableContent', 'headerRows': 1, 'rows': [{'cells': ['欄位', '內容']}, {'cells': ['保存', '由 Flutter host 原子寫入']}]}},
			{'type': 'image', 'props': {'url': 'data:image/png;base64,$imageData', 'caption': '本地打包圖片'}},
		],
	);
}
