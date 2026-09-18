import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/kallopis_foundation.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_workspace_block.dart';

import 'support/klp_application_test_fixture.dart';

void main() {
	// 使用既有宣告式資料工廠，從真實 renderer 後代觀察宿主安裝的 scope。
	testWidgets('declarative host installs localization scope and retains defaults after rebuild', (tester) async {
		final source = KlpMutableState(klpApplicationTestFixture());
		addTearDown(source.dispose);
		runKlpApp(source.readOnly);
		await tester.pump();
		await tester.pump();
		expect(tester.takeException(), isNull);

		final context = tester.element(find.byType(KlpFlutterWorkspaceBlock));
		final installed = Localizations.of<KlpLocalizations>(context, KlpLocalizations);
		expect(installed, isNotNull, reason: '宣告式宿主必須實際安裝 KlpLocalizations；of 的 fallback 不能代替 scope。');
		expect(installed!.windowCloseLabel, 'Close window');
		expect(installed.editorSavedLabel, '已保存');
		expect(installed.savedLabel('09:30'), 'Saved 09:30');
		expect(KlpLocalizations.of(context), same(installed));

		// 宣告和樣式更新後重新取得後代 context，確認新畫面仍由同一套在地化提供。
		source.value = klpApplicationTestFixture(title: 'Rebuilt localization host', alternate: true);
		await tester.pump();
		await tester.pump();
		expect(tester.widget<WidgetsApp>(find.byType(WidgetsApp)).title, 'Rebuilt localization host');
		final rebuiltContext = tester.element(find.byType(KlpFlutterWorkspaceBlock));
		final rebuilt = Localizations.of<KlpLocalizations>(rebuiltContext, KlpLocalizations);
		expect(rebuilt, isNotNull, reason: '宿主重建不得移除已安裝的在地化 scope。');
		expect(rebuilt, installed);
		expect(rebuilt!.windowCloseLabel, 'Close window');
		expect(rebuilt.editorSavedLabel, '已保存');
		expect(rebuilt.savedLabel('10:05'), 'Saved 10:05');
		expect(KlpLocalizations.of(rebuiltContext), same(rebuilt));
		expect(tester.takeException(), isNull);
		await tester.pumpWidget(const SizedBox.shrink());
	});
}
