import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';
import 'package:kallopis/src/l10n/internal/klp_language_catalog.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Map<String, Object?> readLanguageFile(String languageTag) {
    final source = File('assets/l10n/$languageTag.json').readAsStringSync();
    return (jsonDecode(source) as Map).cast<String, Object?>();
  }

  test('所有內建語言檔具有相同文字鍵', () {
    final english = readLanguageFile('en-US').keys.toSet();
    final traditionalChinese = readLanguageFile('zh-TW').keys.toSet();

    expect(traditionalChinese, english);
    expect(english, hasLength(42));
  });

  test('語言檔可建立完整 KlpLocalizations', () {
    final english = KlpLocalizations.fromJson(readLanguageFile('en-US'));
    final traditionalChinese = KlpLocalizations.fromJson(
      readLanguageFile('zh-TW'),
    );

    expect(english.windowCloseLabel, 'Close window');
    expect(english.savedLabel('12:30'), 'Saved 12:30');
    expect(traditionalChinese.windowCloseLabel, '關閉視窗');
    expect(traditionalChinese.savedLabel('12:30'), '已儲存 12:30');
  });

  test('語言檔與同步編譯資源保持一致', () {
    expect(klpEnglishLanguage, readLanguageFile('en-US'));
    expect(klpTraditionalChineseLanguage, readLanguageFile('zh-TW'));
  });

  test('delegate 依 Locale 讀取套件語言檔', () async {
    const delegate = KlpLocalizationsDelegate();

    final english = await delegate.load(const Locale('en', 'GB'));
    final traditionalChinese = await delegate.load(const Locale('zh', 'TW'));

    expect(english.filterAddLabel, '+ Filter');
    expect(traditionalChinese.filterAddLabel, '+ 篩選條件');
  });

  testWidgets('固定元件依目前 Locale 顯示語言檔文字', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: KlpLocalizations.traditionalChineseLocale,
        supportedLocales: KlpLocalizations.supportedLocales,
        localizationsDelegates: const [
          KlpLocalizationsDelegate(),
          ...GlobalMaterialLocalizations.delegates,
        ],
        theme: buildKlpTheme(Brightness.light),
        home: KlpProgress(onCancel: () {}),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('取消'), findsOneWidget);
    expect(find.text('Cancel'), findsNothing);
  });

  test('savedLabel 缺少插值欄位時拒絕語言檔', () {
    final invalid = readLanguageFile('en-US')..['savedLabel'] = 'Saved';

    expect(
      () => KlpLocalizations.fromJson(invalid),
      throwsA(isA<FormatException>()),
    );
  });

  test('固定元件檔案不再包含已收納的 UI 文案', () {
    const forbiddenLiterals = <String>[
      "'Loading...'",
      "'Invalid structured data'",
      "'Open externally'",
      "'Loading preview...'",
      "'Preview failed to load'",
      "'No preview available for this type'",
      "'No preview content'",
      "'+ Add'",
      "'Clear all'",
      "'+ Add step'",
      "'Choose files'",
      "'Cancel'",
      "'同意'",
      "'拒絕'",
    ];
    final componentFiles = Directory('lib/src')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .where((file) => !file.path.replaceAll(r'\', '/').contains('/l10n/'));

    final violations = <String>[];
    for (final file in componentFiles) {
      final source = file.readAsStringSync();
      for (final literal in forbiddenLiterals) {
        if (source.contains(literal)) {
          violations.add('${file.path}: $literal');
        }
      }
    }

    expect(violations, isEmpty, reason: violations.join('\n'));
  });
}
