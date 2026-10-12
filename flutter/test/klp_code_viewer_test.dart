import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

import 'support/load_test_fonts.dart';

void main() {
  setUpAll(loadKlpTestFonts);

  testWidgets('Code viewer exposes language, copy, menu, and view intents', (
    tester,
  ) async {
    var language = 'markdown';
    var copied = false;
    var viewToggled = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.dark),
        home: StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              body: KlpCodeViewer(
                code: '# Planist',
                language: language,
                languageOptions: const [
                  KlpCodeLanguageOption(id: 'dart', label: 'Dart'),
                  KlpCodeLanguageOption(
                    id: 'markdown',
                    label: 'Markdown',
                    supportsView: true,
                  ),
                ],
                labels: const KlpCodeViewerLabels(
                  copy: '複製',
                  menu: '程式碼選單',
                  toggleView: '切換視圖',
                  languageMenu: '程式語言',
                  wrap: '自動換行',
                  lineNumbers: '顯示行號',
                ),
                onLanguageChanged: (value) {
                  setState(() => language = value);
                },
                onCopy: () => copied = true,
                onToggleView: () => viewToggled = true,
              ),
            );
          },
        ),
      ),
    );

    expect(find.byKey(const ValueKey('pln-code-view-toggle')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('pln-code-view-toggle')));
    expect(viewToggled, isTrue);

    await tester.tap(find.byKey(const ValueKey('pln-code-language')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dart'));
    await tester.pumpAndSettle();

    expect(language, 'dart');
    expect(find.byKey(const ValueKey('pln-code-view-toggle')), findsNothing);

    await tester.tap(find.byKey(const ValueKey('pln-code-copy')));
    await tester.tap(find.byKey(const ValueKey('pln-code-menu')));
    await tester.pumpAndSettle();

    expect(copied, isTrue);
    expect(find.text('自動換行'), findsOneWidget);
    expect(find.text('顯示行號'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('pln-code-menu-wrap')));
    await tester.pumpAndSettle();
  });

  testWidgets('wrapped code uses the available narrow width', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.dark),
        home: const Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 248,
              child: KlpCodeViewer(
                code:
                    'A long command that must stay inside the inspector width',
                language: 'json',
                wrapped: true,
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(KlpCodeViewer)).width, 248);
  });
}
