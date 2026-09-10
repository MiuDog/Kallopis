import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
	testWidgets('sort control 顯示受控方向並派送切換事件', (tester) async {
		var pressed = false;

		await tester.pumpWidget(
			MaterialApp(
				theme: buildKlpTheme(Brightness.light),
				home: KlpSortControl(
					label: 'Updated',
					ascending: true,
					onPressed: () => pressed = true,
				),
			),
		);

		expect(find.text('Updated'), findsOneWidget);
		expect(tester.widget<KlpIcon>(find.byType(KlpIcon)).icon, KlpIcons.chevronUp);
		await tester.tap(find.text('Updated'));
		expect(pressed, isTrue);
	});

	testWidgets('sort control 允許以 Kallopis icon 覆寫方向圖示', (tester) async {
		await tester.pumpWidget(
			MaterialApp(
				theme: buildKlpTheme(Brightness.light),
				home: const KlpSortControl(
					label: 'Updated',
					ascending: true,
					onPressed: null,
					icon: KlpIcons.chevronDown,
				),
			),
		);

		expect(tester.widget<KlpIcon>(find.byType(KlpIcon)).icon, KlpIcons.chevronDown);
	});
}
