import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
	testWidgets('date field without calendar remains editable', (tester) async {
		String? changed;

		await tester.pumpWidget(
			MaterialApp(
				theme: buildKlpTheme(Brightness.light),
				home: KlpDateField(
					label: 'Due date',
					value: '2026-09-09',
					onChanged: (value) => changed = value,
				),
			),
		);

		await tester.enterText(find.byType(TextFormField), '2026-09-10');
		expect(changed, '2026-09-10');
	});

	testWidgets('date field opens controlled calendar and closes after selection', (tester) async {
		DateTime? selected;
		var previousCount = 0;
		var nextCount = 0;

		await tester.pumpWidget(
			MaterialApp(
				theme: buildKlpTheme(Brightness.light),
				home: Align(
					alignment: Alignment.topLeft,
					child: SizedBox(
						width: 360,
						child: KlpDateField(
							label: 'Due date',
							value: '2026-09-09',
							onChanged: null,
							calendar: KlpDateFieldCalendar(
								month: DateTime(2026, 9),
								monthLabel: 'September 2026',
								weekdayLabels: ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
								previousMonthLabel: 'Previous month',
								nextMonthLabel: 'Next month',
								onPreviousMonth: () => previousCount += 1,
								onNextMonth: () => nextCount += 1,
								onDateSelected: (date) => selected = date,
							),
						),
					),
				),
			),
		);

		expect(find.text('September 2026'), findsNothing);
		final trigger = find.ancestor(
			of: find.byType(KlpPointerBlocker),
			matching: find.byType(GestureDetector),
		);
		expect(trigger, findsOneWidget);
		await tester.tap(trigger);
		await tester.pump();

		expect(find.text('September 2026'), findsOneWidget);
		await tester.tap(find.bySemanticsLabel('Previous month'));
		await tester.tap(find.bySemanticsLabel('Next month'));
		expect((previousCount, nextCount), (1, 1));

		await tester.tap(find.text('15'));
		await tester.pump();
		expect(selected, DateTime(2026, 9, 15));
		expect(find.text('September 2026'), findsNothing);
	});
}
