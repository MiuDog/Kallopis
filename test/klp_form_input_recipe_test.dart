import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets(
    'affixed input preserves geometry, editing, and action semantics',
    (tester) async {
      String? changed;
      var actionCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          theme: buildKlpTheme(Brightness.light),
          home: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 360,
              child: KlpAffixedTextField(
                label: 'Website',
                initialValue: 'example.com',
                prefixText: 'https://',
                actionIcon: KlpIcons.copy,
                actionLabel: 'Copy address',
                onChanged: (value) => changed = value,
                onAction: () => actionCount += 1,
              ),
            ),
          ),
        ),
      );

      final editor = find.byType(TextFormField);
      final theme = tester.element(editor).klp;
      final fieldSurface = find.descendant(
        of: find.byType(KlpAffixedTextField),
        matching: find.byType(Material),
      );
      expect(tester.getSize(fieldSurface).height, theme.fieldHeight);
      expect(find.text('https://'), findsOneWidget);

      await tester.enterText(editor, 'kallopis.dev');
      expect(changed, 'kallopis.dev');
      await tester.tap(find.bySemanticsLabel('Copy address'));
      expect(actionCount, 1);
    },
  );

  testWidgets(
    'quantity input preserves bounds and dispatches allowed changes',
    (tester) async {
      final values = <num>[];

      await tester.pumpWidget(
        MaterialApp(
          theme: buildKlpTheme(Brightness.light),
          home: KlpQuantityField(
            label: 'Seats',
            value: 2,
            minimum: 1,
            maximum: 3,
            decreaseLabel: 'Decrease seats',
            increaseLabel: 'Increase seats',
            onChanged: values.add,
          ),
        ),
      );

      await tester.tap(find.bySemanticsLabel('Decrease seats'));
      await tester.tap(find.bySemanticsLabel('Increase seats'));
      expect(values, [1, 3]);
    },
  );

  testWidgets('date range preserves both editors and calendar callback', (
    tester,
  ) async {
    String? start;
    String? end;
    var calendarCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: KlpDateRangeField(
          label: 'Schedule',
          initialStartValue: '2026-09-09',
          initialEndValue: '2026-09-10',
          calendarLabel: 'Open calendar',
          onStartChanged: (value) => start = value,
          onEndChanged: (value) => end = value,
          onCalendarPressed: () => calendarCount += 1,
        ),
      ),
    );

    final editors = find.byType(TextFormField);
    expect(editors, findsNWidgets(2));
    await tester.enterText(editors.at(0), '2026-10-01');
    await tester.enterText(editors.at(1), '2026-10-02');
    expect((start, end), ('2026-10-01', '2026-10-02'));

    await tester.tap(find.bySemanticsLabel('Open calendar'));
    expect(calendarCount, 1);
  });
}
