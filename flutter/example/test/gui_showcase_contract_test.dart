import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_foundation.dart';
import 'package:kallopis_catalog/gui_scenario_metadata.dart';
import 'package:kallopis_catalog/gui_scenarios.dart';

void main() {
	testWidgets('網站 Flutter 場景使用公開工作台元件並接收注入的風格', (tester) async {
		// 依網站實際發布的場景清單逐一掛載消費端。
		final source = await tester.runAsync(() => rootBundle.loadString('assets/gui-scenarios.json'));
		final scenes = GuiScenarioMetadata.fromJson(jsonDecode(source!));
		await tester.binding.setSurfaceSize(const Size(1440, 1200));
		addTearDown(() => tester.binding.setSurfaceSize(null));

		for (final scene in scenes) {
			// 等候真實資產 future，避免測試時鐘在載入畫面先停止。
			await tester.runAsync(() async {
				await tester.pumpWidget(GuiScenarioApp(key: ValueKey(scene.id), id: scene.id));
				await rootBundle.loadString('assets/gui-scenarios.json');
			});
			await tester.pumpAndSettle();

			final dock = find.byType(KlpDockLayout);
			expect(dock, findsOneWidget, reason: scene.id);
			expect(find.descendant(of: dock, matching: find.byType(KlpPanelFrame)), findsWidgets, reason: scene.id);
			expect(find.descendant(of: dock, matching: find.byType(KlpFileExplorer)), findsOneWidget, reason: scene.id);

			// 在公開元件的 context 觀察語意值，確認切換風格確實抵達場景。
			final packSwitch = find.widgetWithText(KlpButton, '風格：預設');
			final initialGap = tester.element(dock).klp.space.contentStackGap;
			await tester.tap(packSwitch);
			await tester.pumpAndSettle();
			expect(find.widgetWithText(KlpButton, '風格：寬鬆'), findsOneWidget, reason: scene.id);
			expect(tester.element(dock).klp.space.contentStackGap, greaterThan(initialGap), reason: scene.id);
		}
	});
}
