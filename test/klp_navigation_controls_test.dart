import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
	testWidgets('action group 使用 Kallopis wrap 保留換行間距', (tester) async {
		await tester.pumpWidget(
			MaterialApp(
				theme: buildKlpTheme(Brightness.light),
				home: const KlpActionGroup(
					children: [KlpText('A'), KlpText('B')],
				),
			),
		);

		final wrap = tester.widget<KlpWrap>(find.byType(KlpWrap));
		expect(wrap.spacingSize, KlpSpaceSize.tight);
		expect(wrap.runSpacingSize, KlpSpaceSize.tight);
	});

	testWidgets('pagination 在有效範圍內派送受控頁碼', (tester) async {
		int? selectedPage;

		await tester.pumpWidget(
			MaterialApp(
				theme: buildKlpTheme(Brightness.light),
				home: KlpPagination(
					page: 1,
					pageCount: 3,
					previousLabel: 'Previous',
					nextLabel: 'Next',
					onPageChanged: (page) => selectedPage = page,
				),
			),
		);

		expect(find.text('1 / 3'), findsOneWidget);
		await tester.tap(find.text('Previous'));
		expect(selectedPage, isNull);
		await tester.tap(find.text('Next'));
		expect(selectedPage, 2);
	});

	testWidgets('view switcher 呈現選取狀態並回傳識別碼', (tester) async {
		String? selectedId;

		await tester.pumpWidget(
			MaterialApp(
				theme: buildKlpTheme(Brightness.light),
				home: KlpViewSwitcher(
					options: const [
						KlpViewOption(id: 'list', label: 'List'),
						KlpViewOption(id: 'grid', label: 'Grid'),
					],
					selectedId: 'list',
					onSelected: (id) => selectedId = id,
				),
			),
		);

		final selectedText = tester.widget<KlpText>(
			find.byWidgetPredicate(
				(widget) => widget is KlpText && widget.data == 'List',
			),
		);
		expect(selectedText.tone, KlpTextTone.primary);
		await tester.tap(find.text('Grid'));
		expect(selectedId, 'grid');
	});
}
