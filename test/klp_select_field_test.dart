import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('select field 展開、忽略 disabled option 並在選取後收合', (tester) async {
    String? selectedId;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: KlpSelectField(
          label: 'Model',
          valueLabel: 'Choose',
          options: const [
            KlpChoiceOption(id: 'audi', label: 'Audi'),
            KlpChoiceOption(id: 'volvo', label: 'Volvo', disabled: true),
          ],
          onSelected: (id) => selectedId = id,
        ),
      ),
    );

    expect(find.text('Audi'), findsNothing);
    await tester.tap(find.text('Choose'));
    await tester.pump();
    expect(find.text('Audi'), findsOneWidget);
    expect(find.text('Volvo'), findsOneWidget);

    await tester.tap(find.text('Volvo'));
    await tester.pump();
    expect(selectedId, isNull);
    expect(find.text('Audi'), findsOneWidget);

    await tester.tap(find.text('Audi'));
    await tester.pump();
    expect(selectedId, 'audi');
    expect(find.text('Audi'), findsNothing);
  });

  testWidgets('read-only select field 不展開並保留錯誤文案', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: KlpSelectField(
          label: 'Model',
          valueLabel: 'Choose',
          options: const [KlpChoiceOption(id: 'audi', label: 'Audi')],
          onSelected: (_) {},
          readOnly: true,
          error: 'Required',
        ),
      ),
    );

    await tester.tap(find.text('Choose'));
    await tester.pump();
    expect(find.text('Audi'), findsNothing);
    expect(find.text('Required'), findsOneWidget);
  });
}
