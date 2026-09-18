import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_block_note_load_error.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_block_note_web_session_loader.dart';

import 'support/load_test_fonts.dart';

final class _MountedEditor extends StatefulWidget {
	final VoidCallback onDispose;
	final VoidCallback onSave;
	const _MountedEditor({required this.onDispose, required this.onSave, super.key});

	@override
	State<_MountedEditor> createState() => _MountedEditorState();
}

final class _MountedEditorState extends State<_MountedEditor> {
	@override
	Widget build(BuildContext context) => Center(child: TextButton(onPressed: widget.onSave, child: const Text('既有正文與保存入口')));

	@override
	void dispose() {
		widget.onDispose();
		super.dispose();
	}
}

void main() {
	setUpAll(loadKlpTestFonts);
	testWidgets('rendered retry and runtime notice preserve the mounted editor', (tester) async {
		var attempts = 0;
		var disposals = 0;
		var saveClicks = 0;
		final loader = KlpBlockNoteWebSessionLoader(() async {
			if (++attempts == 1) throw StateError('bridge timeout');
		}, onFailure: (_, _) {});
		await loader.open();
		final editorKey = GlobalKey<_MountedEditorState>();
		late StateSetter refresh;
		await tester.pumpWidget(MaterialApp(theme: buildKlpTheme(Brightness.light), home: Scaffold(body: StatefulBuilder(builder: (context, setState) {
			refresh = setState;
			return ColoredBox(color: Theme.of(context).scaffoldBackgroundColor, child: KlpBlockNoteLoadSurface(loader: loader, child: _MountedEditor(key: editorKey, onDispose: () => disposals++, onSave: () => saveClicks++), onRetry: () async {
				await loader.retry();
				setState(() {});
			}));
		}))));
		await tester.pumpAndSettle();
		final mountedState = editorKey.currentState;
		expect(mountedState, isNotNull);
		expect(find.text('無法載入正文編輯器'), findsOneWidget);
		expect(find.text('本機編輯器尚未完成啟動，請再試一次。'), findsOneWidget);
		expect(find.text('重試'), findsOneWidget);
		expect(tester.getSize(find.byType(KlpBlockNoteLoadSurface)).shortestSide, greaterThan(0));

		// 點擊實際渲染的重試按鈕，不能移除或重建承載正文的 child。
		await tester.tap(find.text('重試'));
		await tester.pumpAndSettle();
		expect(attempts, 2);
		expect(loader.error, isNull);
		expect(find.text('重試'), findsNothing);
		expect(editorKey.currentState, same(mountedState));
		expect(disposals, 0);

		// 成功後故障只顯示提示，保留正文、保存入口及同一個 editor state。
		loader.reportFailure(StateError('runtime interrupted'));
		refresh(() {});
		await tester.pumpAndSettle();
		expect(find.text('編輯器已中斷。請保留此視窗並嘗試儲存；尚未儲存內容不會自動重載。'), findsOneWidget);
		expect(find.text('重試'), findsNothing);
		expect(find.text('既有正文與保存入口'), findsOneWidget);
		expect(editorKey.currentState, same(mountedState));
		expect((attempts, disposals), (2, 0));
		await tester.tap(find.text('既有正文與保存入口'));
		expect(saveClicks, 1, reason: 'Runtime notice must not cover the existing save control');
		await tester.pumpAndSettle();
		expect(tester.takeException(), isNull);
	});
}
