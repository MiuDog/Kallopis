import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('entity picker 投影結果並派送查詢、選取與動作事件', (tester) async {
    String? query;
    int? selectedIndex;
    var cleared = false;
    var applied = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: KlpEntityPicker(
          title: 'Select entity',
          initialQuery: 'ADR',
          results: const [
            KlpEntityResultData(kind: 'spec', label: 'ADR-0001'),
            KlpEntityResultData(
              kind: 'page',
              label: 'Architecture',
              trailing: 'Updated today',
              selected: true,
            ),
          ],
          onQueryChanged: (value) => query = value,
          onResultSelected: (index) => selectedIndex = index,
          onClear: () => cleared = true,
          onApply: () => applied = true,
        ),
      ),
    );

    expect(find.text('SELECT ENTITY'), findsOneWidget);
    expect(find.text('ADR-0001'), findsOneWidget);
    expect(find.text('Architecture'), findsOneWidget);
    expect(find.text('Updated today'), findsOneWidget);
    await tester.enterText(find.byType(EditableText), 'KLP');
    await tester.tap(find.text('Architecture'));
    await tester.tap(
      find.byWidgetPredicate(
        (widget) => widget is KlpButton && widget.label == 'Remove',
      ),
    );
    await tester.tap(
      find.byWidgetPredicate(
        (widget) => widget is KlpButton && widget.label == 'Apply',
      ),
    );

    expect(query, 'KLP');
    expect(selectedIndex, 1);
    expect(cleared, isTrue);
    expect(applied, isTrue);
  });

  testWidgets('selected entity result 使用目前主題的 muted surface', (tester) async {
    late KlpThemeData tokens;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: Builder(
          builder: (context) {
            tokens = context.klpColors;
            return KlpEntityPicker(
              title: 'Select entity',
              initialQuery: '',
              results: const [
                KlpEntityResultData(
                  kind: 'spec',
                  label: 'Selected',
                  selected: true,
                ),
              ],
              onQueryChanged: (_) {},
              onClear: () {},
              onApply: () {},
            );
          },
        ),
      ),
    );

    final selectedSurface = tester.widget<Material>(
      find.byWidgetPredicate(
        (widget) =>
            widget is Material &&
            widget.color?.toARGB32() == tokens.surfaceMuted.toARGB32(),
      ),
    );
    expect(selectedSurface.borderRadius, isNotNull);
  });
}
