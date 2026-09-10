import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
	testWidgets('editor toolbar 呈現動作並派送事件', (tester) async {
		var pressed = false;

		await tester.pumpWidget(
			KlpApp(
				showWindowHeader: false,
				home: KlpPanelFrame(
					content: KlpAppScreen(
						child: KlpEditorToolbar(
							actions: [
								KlpEditorActionData(
									label: 'Format',
									onPressed: () => pressed = true,
								),
							],
						),
					),
				),
			),
		);

		expect(find.byType(KlpWrap), findsOneWidget);
		await tester.tap(find.text('Format'));
		expect(pressed, isTrue);
	});

	testWidgets('bulk action bar 保留摘要與 danger 文字語意', (tester) async {
		await tester.pumpWidget(
			const KlpApp(
				showWindowHeader: false,
				home: KlpPanelFrame(
					content: KlpAppScreen(
						child: KlpBulkActionBar(
							label: '2 selected',
							actions: [
								KlpEditorActionData(
									label: 'Delete',
									onPressed: null,
									danger: true,
								),
							],
						),
					),
				),
			),
		);

		expect(find.text('2 selected'), findsOneWidget);
		final actionText = tester.widget<KlpText>(
			find.byWidgetPredicate(
				(widget) => widget is KlpText && widget.data == 'Delete',
			),
		);
		expect(actionText.tone, KlpTextTone.danger);
	});

	testWidgets('search navigator 派送查詢與三個導覽事件', (tester) async {
		String? query;
		var previous = false;
		var next = false;
		var closed = false;

		await tester.pumpWidget(
			KlpApp(
				showWindowHeader: false,
				home: KlpPanelFrame(
					content: KlpAppScreen(
						child: KlpSearchNavigator(
							initialQuery: 'old',
							current: 2,
							total: 5,
							onPrevious: () => previous = true,
							onNext: () => next = true,
							onClose: () => closed = true,
							onQueryChanged: (value) => query = value,
						),
					),
				),
			),
		);

		expect(find.text('2/5'), findsOneWidget);
		expect(
			tester.widget<KlpRotate>(find.byType(KlpRotate)).turn,
			KlpQuarterTurn.half,
		);
		await tester.enterText(find.byType(EditableText), 'new');
		expect(query, 'new');
		await tester.tap(find.byType(KlpIconButton).at(0));
		await tester.tap(find.byType(KlpIconButton).at(1));
		await tester.tap(find.byType(KlpIconButton).at(2));
		expect(previous, isTrue);
		expect(next, isTrue);
		expect(closed, isTrue);
	});
}
