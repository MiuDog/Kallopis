import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
	testWidgets('tag input 以 Kallopis 排版並派送新增、移除與清空事件', (tester) async {
		var added = false;
		var cleared = false;
		String? removed;

		await tester.pumpWidget(
			KlpApp(
				showWindowHeader: false,
				home: KlpPanelFrame(
					content: KlpAppScreen(
						child: KlpTagInputField(
							label: 'Tags',
							tags: const ['schema', 'ci'],
							maxCount: 5,
							onAdd: () => added = true,
							onRemove: (tag) => removed = tag,
							onClearAll: () => cleared = true,
						),
					),
				),
			),
		);

		final field = find.byType(KlpTagInputField);
		expect(find.descendant(of: field, matching: find.byType(KlpColumn)), findsOneWidget);
		expect(find.descendant(of: field, matching: find.byType(KlpWrap)), findsOneWidget);
		expect(find.text('2/5'), findsOneWidget);

		await tester.tap(find.text('+ Add'));
		await tester.tap(find.text('×').first);
		await tester.tap(find.text(' Clear all'));

		expect(added, isTrue);
		expect(removed, 'schema');
		expect(cleared, isTrue);
	});

	testWidgets('tag chip 沒有移除事件時不呈現移除動作', (tester) async {
		await tester.pumpWidget(
			const KlpApp(
				showWindowHeader: false,
				home: KlpPanelFrame(
					content: KlpAppScreen(
						child: KlpTagChip(label: 'stable'),
					),
				),
			),
		);

		expect(find.text('stable'), findsOneWidget);
		expect(find.text('×'), findsNothing);
	});
}
