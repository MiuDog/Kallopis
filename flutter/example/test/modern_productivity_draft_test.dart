import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_foundation.dart';
import 'package:kallopis_catalog/modern_productivity_starter.dart';

// 透過 Flutter 正式文字輸入路徑驗證產品草稿，不以瀏覽器 textarea 值推論 controller。
void main() {
	testWidgets('兩個側欄草稿經 A-B-A 與 mode 重建仍保留', (tester) async {
		Future<void> pump(KlpThemeVariant variant) async {
			await tester.pumpWidget(MaterialApp(
				theme: buildKlpThemeVariant(variant),
				localizationsDelegates: const [KlpLocalizationsDelegate()],
				home: const Scaffold(body: Align(
					alignment: Alignment.topLeft,
					child: SizedBox(width: 800, height: 500, child: ModernProductivityStarter()),
				)),
			));
			await tester.pumpAndSettle();
		}
		final switcher = find.descendant(of: find.byType(KlpModernProductivityLayout), matching: find.byType(KlpButton));
		Future<void> select(int index) async {
			expect(switcher, findsNWidgets(2));
			await tester.tap(switcher.at(index));
			await tester.pumpAndSettle();
		}
		EditableText currentEditor() {
			expect(find.byType(EditableText), findsOneWidget, reason: '只有作用面板的草稿參與互動');
			return tester.widget<EditableText>(find.byType(EditableText));
		}

		await pump(KlpThemeVariant.light);
		await select(0);
		await tester.enterText(find.byType(EditableText), '導航尚未保存的草稿');
		final first = currentEditor().controller;
		expect(first.text, '導航尚未保存的草稿', reason: '輸入事件必須真正提交給 Flutter controller');
		await select(1);
		await tester.enterText(find.byType(EditableText), '工具尚未保存的草稿');
		final second = currentEditor().controller;
		expect(second.text, '工具尚未保存的草稿');
		await select(0);
		expect(currentEditor().controller.text, '導航尚未保存的草稿');
		expect(currentEditor().controller, same(first));
		await pump(KlpThemeVariant.dark);
		expect(currentEditor().controller.text, '導航尚未保存的草稿');
		await select(1);
		expect(currentEditor().controller.text, '工具尚未保存的草稿');
		expect(currentEditor().controller, same(second));
		await select(0);
		expect(currentEditor().controller.text, '導航尚未保存的草稿');
		expect(second.text, '工具尚未保存的草稿');
		expect(tester.takeException(), isNull);
		await tester.pumpWidget(const SizedBox());
		await tester.pumpAndSettle();
	});
}
