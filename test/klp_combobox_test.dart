import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  const options = [
    KlpComboboxOption(id: 'a', label: 'Alpha'),
    KlpComboboxOption(id: 'b', label: 'Beta'),
    KlpComboboxOption(id: 'c', label: 'Gamma'),
  ];

  Future<void> pumpCombobox(
    WidgetTester tester, {
    required String query,
    required ValueChanged<String> onQueryChanged,
    required ValueChanged<KlpComboboxOption> onSelected,
    bool allowFreeText = false,
    ValueChanged<String>? onFreeTextSubmitted,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.dark),
        home: Scaffold(
          body: KlpCombobox(
            label: '負責人',
            query: query,
            menuLabel: '成員',
            options: options,
            onQueryChanged: onQueryChanged,
            onSelected: onSelected,
            allowFreeText: allowFreeText,
            onFreeTextSubmitted: onFreeTextSubmitted,
          ),
        ),
      ),
    );
  }

  testWidgets('typing calls onQueryChanged with the new text', (
    tester,
  ) async {
    String? latestQuery;

    await pumpCombobox(
      tester,
      query: '',
      onQueryChanged: (value) => latestQuery = value,
      onSelected: (_) {},
    );

    await tester.tap(find.byType(TextFormField));
    await tester.pump();
    await tester.enterText(find.byType(TextFormField), 'ga');
    await tester.pump();

    expect(latestQuery, 'ga');
  });

  testWidgets('a non-empty query filters the dropdown to matching options', (
    tester,
  ) async {
    // 元件是受控元件——這裡直接以呼叫端已經把 query 寫回之後的狀態 pump，
    // 驗證面板依 query 過濾出的結果，而不是模擬打字這個動作本身。
    await pumpCombobox(
      tester,
      query: 'ga',
      onQueryChanged: (_) {},
      onSelected: (_) {},
    );

    await tester.tap(find.byType(TextFormField));
    await tester.pump();

    expect(find.text('Gamma'), findsOneWidget);
    expect(find.text('Alpha'), findsNothing);
    expect(find.text('Beta'), findsNothing);
  });

  testWidgets('tapping an option in the dropdown calls onSelected', (
    tester,
  ) async {
    KlpComboboxOption? selected;

    await pumpCombobox(
      tester,
      query: '',
      onQueryChanged: (_) {},
      onSelected: (option) => selected = option,
    );

    await tester.tap(find.byType(TextFormField));
    await tester.pump();

    expect(find.text('Beta'), findsOneWidget);
    await tester.tap(find.text('Beta'));
    await tester.pump();

    expect(selected?.id, 'b');
  });

  testWidgets('arrow-down highlights the next option and Enter selects it', (
    tester,
  ) async {
    KlpComboboxOption? selected;

    await pumpCombobox(
      tester,
      query: '',
      onQueryChanged: (_) {},
      onSelected: (option) => selected = option,
    );

    await tester.tap(find.byType(TextFormField));
    await tester.pump();

    // 第一次 ↓ 選中第一個選項（Alpha），Enter 選定它。
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(selected?.id, 'a');
  });

  testWidgets(
    'arrow-down twice highlights the second option and Enter selects it',
    (tester) async {
      KlpComboboxOption? selected;

      await pumpCombobox(
        tester,
        query: '',
        onQueryChanged: (_) {},
        onSelected: (option) => selected = option,
      );

      await tester.tap(find.byType(TextFormField));
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      expect(selected?.id, 'b');
    },
  );

  testWidgets(
    'Enter with no highlighted option and allowFreeText submits free text',
    (tester) async {
      String? freeText;

      await pumpCombobox(
        tester,
        query: 'not in the list',
        onQueryChanged: (_) {},
        onSelected: (_) {},
        allowFreeText: true,
        onFreeTextSubmitted: (value) => freeText = value,
      );

      await tester.tap(find.byType(TextFormField));
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      expect(freeText, 'not in the list');
    },
  );
}
