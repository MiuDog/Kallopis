import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('reference picker 派送查詢與可用選項事件', (tester) async {
    String? query;
    String? selectedId;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: KlpReferencePicker(
          title: 'References',
          query: '',
          queryPlaceholder: 'Search',
          results: const [
            KlpReferenceOption(
              id: 'note-1',
              label: 'Architecture',
              kind: 'Note',
              metadata: 'Updated',
            ),
          ],
          onQueryChanged: (value) => query = value,
          onSelected: (id) => selectedId = id,
        ),
      ),
    );

    await tester.enterText(find.byType(EditableText), 'arch');
    expect(query, 'arch');
    await tester.tap(find.text('Architecture'));
    expect(selectedId, 'note-1');
  });

  testWidgets('reference picker 不派送 disabled 選項', (tester) async {
    String? selectedId;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: KlpReferencePicker(
          title: 'References',
          query: '',
          queryPlaceholder: 'Search',
          results: const [
            KlpReferenceOption(
              id: 'note-1',
              label: 'Unavailable',
              disabled: true,
            ),
          ],
          onQueryChanged: (_) {},
          onSelected: (id) => selectedId = id,
        ),
      ),
    );

    await tester.tap(find.text('Unavailable'));
    expect(selectedId, isNull);
  });

  testWidgets('reference picker loading 時不呈現結果', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: KlpReferencePicker(
          title: 'References',
          query: '',
          queryPlaceholder: 'Search',
          results: const [
            KlpReferenceOption(id: 'note-1', label: 'Hidden result'),
          ],
          onQueryChanged: (_) {},
          onSelected: null,
          loading: true,
        ),
      ),
    );

    expect(find.text('...'), findsOneWidget);
    expect(find.text('Hidden result'), findsNothing);
    expect(
      tester.widget<KlpSurface>(find.byType(KlpSurface).first).tone,
      KlpSurfaceTone.component,
    );
  });
}
