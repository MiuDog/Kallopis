import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_foundation.dart';

Widget _section(bool collapsed, VoidCallback? onToggle) {
	return MaterialApp(
		theme: buildKlpTheme(Brightness.light),
		home: Align(
			alignment: Alignment.topLeft,
			child: SizedBox(
				width: 300,
				child: KlpFormSection(
					title: 'Profile',
					collapsed: collapsed,
					onToggle: onToggle,
					children: const [KlpText('Display name')],
				),
			),
		),
	);
}

void main() {
	for (final key in [LogicalKeyboardKey.enter, LogicalKeyboardKey.space]) {
		final label = key == LogicalKeyboardKey.enter ? 'Enter' : 'Space';
		testWidgets('Tab reaches heading and $label toggles once', (tester) async {
			var toggles = 0;
			await tester.pumpWidget(_section(false, () => toggles += 1));

			// 由鍵盤巡覽取得焦點，避免以程式指定焦點掩蓋 Tab 契約。
			await tester.sendKeyEvent(LogicalKeyboardKey.tab);
			await tester.pump();
			expect(toggles, 0);
			await tester.sendKeyEvent(key);
			await tester.pump();

			expect(toggles, 1);
			// 回呼本身不改變 consumer 持有的收合狀態。
			expect(find.text('Display name'), findsOneWidget);
		});
	}

	testWidgets('consumer controls expanded collapsed expanded content', (tester) async {
		var toggles = 0;
		void onToggle() => toggles += 1;

		await tester.pumpWidget(_section(false, onToggle));
		expect(find.text('Display name'), findsOneWidget);
		await tester.tap(find.text('Profile'));
		await tester.pump();
		expect(toggles, 1);
		expect(find.text('Display name'), findsOneWidget);

		await tester.pumpWidget(_section(true, onToggle));
		expect(find.text('Display name'), findsNothing);
		await tester.tap(find.text('Profile'));
		await tester.pump();
		expect(toggles, 2);
		expect(find.text('Display name'), findsNothing);

		await tester.pumpWidget(_section(false, onToggle));
		expect(find.text('Display name'), findsOneWidget);
		expect(tester.takeException(), isNull);
	});

	testWidgets('null toggle is safe for pointer and keyboard input', (tester) async {
		await tester.pumpWidget(_section(false, null));
		await tester.tap(find.text('Profile'));
		await tester.sendKeyEvent(LogicalKeyboardKey.tab);
		await tester.sendKeyEvent(LogicalKeyboardKey.enter);
		await tester.sendKeyEvent(LogicalKeyboardKey.space);
		await tester.pump();

		expect(find.text('Display name'), findsOneWidget);
		expect(tester.takeException(), isNull);
		await tester.pumpWidget(_section(true, null));
		expect(find.text('Display name'), findsNothing);
		expect(tester.takeException(), isNull);
	});
}
