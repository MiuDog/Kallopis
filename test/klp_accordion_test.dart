import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
	List<KlpAccordionItemData> items() => [
		const KlpAccordionItemData(
			id: 'a',
			title: '第一項',
			child: KlpText('內容 A'),
		),
		const KlpAccordionItemData(
			id: 'b',
			title: '第二項',
			child: KlpText('內容 B'),
		),
	];

	Future<void> pump(WidgetTester tester, Widget child) {
		return tester.pumpWidget(
			MaterialApp(theme: buildKlpTheme(Brightness.light), home: child),
		);
	}

	testWidgets('單開模式下展開一項會收合另一項', (tester) async {
		await pump(tester, KlpAccordion(items: items()));

		expect(find.text('內容 A'), findsNothing);
		expect(find.text('內容 B'), findsNothing);

		await tester.tap(find.text('第一項'));
		await tester.pumpAndSettle();
		expect(find.text('內容 A'), findsOneWidget);

		await tester.tap(find.text('第二項'));
		await tester.pumpAndSettle();
		expect(find.text('內容 A'), findsNothing);
		expect(find.text('內容 B'), findsOneWidget);
	});

	testWidgets('多開模式下各項互不影響', (tester) async {
		await pump(tester, KlpAccordion(items: items(), multiple: true));

		await tester.tap(find.text('第一項'));
		await tester.pumpAndSettle();
		await tester.tap(find.text('第二項'));
		await tester.pumpAndSettle();

		expect(find.text('內容 A'), findsOneWidget);
		expect(find.text('內容 B'), findsOneWidget);
	});

	testWidgets('initialExpandedIds 決定初始展開項目並回報變化', (tester) async {
		Set<String>? reported;

		await pump(
			tester,
			KlpAccordion(
				items: items(),
				initialExpandedIds: const {'a'},
				onExpandedChanged: (ids) => reported = ids,
			),
		);

		expect(find.text('內容 A'), findsOneWidget);

		await tester.tap(find.text('第一項'));
		await tester.pumpAndSettle();

		expect(reported, isEmpty);
	});

	testWidgets('標題、子標題與內容維持各自角色', (tester) async {
		await pump(
			tester,
			const KlpAccordion(
				initialExpandedIds: {'a'},
				items: [
					KlpAccordionItemData(
						id: 'a',
						title: 'Metadata',
						subtitle: 'Optional details',
						child: KlpText('Content'),
					),
				],
			),
		);

		expect(find.text('Metadata'), findsOneWidget);
		expect(find.text('Optional details'), findsOneWidget);
		expect(find.text('Content'), findsOneWidget);
	});
}
