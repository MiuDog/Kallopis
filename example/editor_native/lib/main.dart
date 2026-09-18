import 'dart:ui' show AppExitResponse;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis_catalog/catalog_declarative/catalog_application.dart';
import 'package:krepis_kallopis/krepis_kallopis.dart';

const _fontAsset = 'packages/kallopis/assets/fonts/NotoSansTC-Variable.ttf';
const _dllPath = String.fromEnvironment('KREPIS_DLL');
const _documentPath = String.fromEnvironment('KREPIS_DOCUMENT');
const _savePath = String.fromEnvironment('KREPIS_SAVE_DESTINATION');
const _commandLabels = KrepisKallopisCommandLabels(
	movePrevious: '向前移動區塊',
	moveNext: '向後移動區塊',
	undo: '復原',
	redo: '重做',
	unavailable: '目前無法執行',
	empty: '沒有可用命令',
);
const _modeLabels = KrepisKallopisModeLabels(
	textMode: '文字',
	textTool: '文字游標',
	navigationMode: '導覽',
	navigationTool: '捲動',
	handwritingMode: '手寫',
	handwritingTool: '筆',
	handwritingUnavailable: '手寫輸入尚未完成',
);

Future<void> main() async {
	WidgetsFlutterBinding.ensureInitialized();
	if (_dllPath.isEmpty) throw StateError('Pass the Krepis DLL with --dart-define=KREPIS_DLL=<path>');
	if (_documentPath.isNotEmpty && _savePath.isNotEmpty) throw StateError('Choose an existing document or a new save destination, not both.');

	final font = await rootBundle.load(_fontAsset);
	final fontBytes = font.buffer.asUint8List(font.offsetInBytes, font.lengthInBytes);
	final KrepisKallopisEditorOwner owner;
	if (_documentPath.isEmpty) {
		owner = KrepisKallopisEditorOwner.openWindows(
			dllPath: _dllPath,
			fontBytes: fontBytes,
			initialMarkdown: '<details open>\n<summary>今日規劃</summary>\n\n- [ ] 完成 Kallopis 筆記元件\n\n保持 A 密度與受控組裝。\n</details>\n',
			savePath: _savePath.isEmpty ? null : _savePath,
			documentId: 'catalog.document',
			pageId: 'catalog.editor',
			width: 800,
			height: 600,
			commandLabels: _commandLabels,
			modeLabels: _modeLabels,
		);
	}
	else {
		owner = KrepisKallopisEditorOwner.openFileWindows(
			dllPath: _dllPath,
			fontBytes: fontBytes,
			path: _documentPath,
			documentId: 'catalog.document',
			pageId: 'catalog.editor',
			width: 800,
			height: 600,
			commandLabels: _commandLabels,
			modeLabels: _modeLabels,
		);
	}
	AppLifecycleListener(
		onExitRequested: () async {
			debugPrint('Kallopis editor exit: request received');
			try {
				await owner.close();
				debugPrint('Kallopis editor exit: owner settled');
				return AppExitResponse.exit;
			}
			catch (error, stack) {
				debugPrint('Kallopis editor exit: owner failed: $error\n$stack');
				return AppExitResponse.cancel;
			}
		},
	);
	final rootScope = KlpId.parse('catalog.editor');
	runCatalog(stage: KlpEditingContent(
		id: rootScope,
		source: owner.source,
		blockControls: KlpBlockControls(id: rootScope / 'blocks'),
		anchoredCommands: KlpAnchoredCommands(id: rootScope / 'commands'),
		modeToolbar: KlpModeToolbar(id: rootScope / 'modes'),
	));
}
