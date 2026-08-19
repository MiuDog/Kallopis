import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  setUpAll(() async {
    if (KlpTypography.monoFamily.isNotEmpty) {
      final mono = FontLoader(KlpTypography.monoFamily)
        ..addFont(rootBundle.load('assets/fonts/IBMPlexMono-Regular.ttf'));
      await mono.load();
    }
  });

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

  testWidgets('Code viewer matches the compact terminal specimen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(580, 170);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildKlpTheme(Brightness.dark),
        home: Scaffold(
          body: RepaintBoundary(
            key: const ValueKey('pln-code-viewer-golden'),
            child: ColoredBox(
              color: KlpThemeData.dark.app,
              child: const Padding(
                padding: EdgeInsets.all(KlpSpace.md),
                child: KlpCodeViewer(
                  code:
                      'agent> reading 42 files in src/components\n'
                      'agent> applying codemod react-19-upgrade\n'
                      '+218 -96 across 42 files\n'
                      r'$',
                  language: 'shell',
                  labels: KlpCodeViewerLabels(
                    copy: '複製',
                    menu: '程式碼選單',
                    toggleView: '切換視圖',
                    languageMenu: '程式語言',
                    wrap: '自動換行',
                    lineNumbers: '顯示行號',
                  ),
                  onLanguageChanged: _ignoreLanguage,
                  onCopy: _noop,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byKey(const ValueKey('pln-code-viewer-golden')),
      matchesGoldenFile('goldens/klp_code_viewer_dark.png'),
    );
  });
}

void _noop() {}

void _ignoreLanguage(String value) {}
