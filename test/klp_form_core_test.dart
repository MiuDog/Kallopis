import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('form preserves semantic gaps between optional regions', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: const Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 300,
            child: KlpForm(
              errorSummary: SizedBox(key: ValueKey('error-summary'), height: 8),
              sections: [
                SizedBox(key: ValueKey('section-a'), height: 10),
                SizedBox(key: ValueKey('section-b'), height: 12),
              ],
              actions: SizedBox(key: ValueKey('actions'), height: 14),
            ),
          ),
        ),
      ),
    );

    final error = find.byKey(const ValueKey('error-summary'));
    final sectionA = find.byKey(const ValueKey('section-a'));
    final sectionB = find.byKey(const ValueKey('section-b'));
    final actions = find.byKey(const ValueKey('actions'));
    final theme = tester.element(sectionA).klp;

    expect(
      tester.getTopLeft(sectionA).dy - tester.getBottomLeft(error).dy,
      theme.space.base,
    );
    expect(
      tester.getTopLeft(sectionB).dy - tester.getBottomLeft(sectionA).dy,
      theme.space.comfortable,
    );
    expect(
      tester.getTopLeft(actions).dy - tester.getBottomLeft(sectionB).dy,
      theme.space.comfortable,
    );
  });

  testWidgets('form section preserves content and controlled collapse', (
    tester,
  ) async {
    var toggles = 0;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 300,
            child: KlpFormSection(
              title: 'Profile',
              description: 'Public details',
              onToggle: () => toggles += 1,
              children: const [KlpText('Display name')],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Public details'), findsOneWidget);
    expect(find.text('Display name'), findsOneWidget);
    await tester.tap(find.text('Profile'));
    expect(toggles, 1);

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: const KlpFormSection(
          title: 'Profile',
          collapsed: true,
          children: [KlpText('Display name')],
        ),
      ),
    );

    expect(find.text('Display name'), findsNothing);
  });

  testWidgets('error summary preserves order and reports selected field', (
    tester,
  ) async {
    String? selected;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: KlpFormErrorSummary(
          title: 'Please review',
          errors: const {
            'name': 'Name is required',
            'email': 'Email is invalid',
          },
          onSelected: (field) => selected = field,
        ),
      ),
    );

    expect(
      tester.getTopLeft(find.text('Name is required')).dy,
      lessThan(tester.getTopLeft(find.text('Email is invalid')).dy),
    );
    await tester.tap(find.text('Email is invalid'));
    expect(selected, 'email');
  });

  testWidgets('form actions preserve callbacks and submitting lock', (
    tester,
  ) async {
    var resetCount = 0;
    var cancelCount = 0;
    var submitCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: KlpFormActions(
          resetLabel: 'Reset',
          onReset: () => resetCount += 1,
          cancelLabel: 'Cancel',
          onCancel: () => cancelCount += 1,
          submitLabel: 'Save',
          onSubmit: () => submitCount += 1,
        ),
      ),
    );
    await tester.tap(find.text('Reset'));
    await tester.tap(find.text('Cancel'));
    await tester.tap(find.text('Save'));
    expect((resetCount, cancelCount, submitCount), (1, 1, 1));

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: KlpFormActions(
          resetLabel: 'Reset',
          onReset: () => resetCount += 1,
          cancelLabel: 'Cancel',
          onCancel: () => cancelCount += 1,
          submitLabel: 'Save',
          onSubmit: () => submitCount += 1,
          submitting: true,
        ),
      ),
    );
    await tester.tap(find.text('Reset'));
    await tester.tap(find.text('Cancel'));
    await tester.tap(find.text('Save'));
    expect((resetCount, cancelCount, submitCount), (1, 1, 1));
  });

  testWidgets(
    'conditional field swaps content through its primitive boundary',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildKlpTheme(Brightness.light),
          home: const KlpConditionalFieldRegion(
            visible: false,
            child: KlpText('Conditional content'),
          ),
        ),
      );

      expect(find.text('Conditional content'), findsNothing);

      await tester.pumpWidget(
        MaterialApp(
          theme: buildKlpTheme(Brightness.light),
          home: const KlpConditionalFieldRegion(
            visible: true,
            child: KlpText('Conditional content'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Conditional content'), findsOneWidget);
    },
  );
}
