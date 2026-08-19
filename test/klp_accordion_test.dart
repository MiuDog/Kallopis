import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/data/klp_accordion.dart';
import 'package:kallopis/src/theme/klp_theme.dart';
import 'package:kallopis/src/typography/klp_text.dart';

// 這個測試檔刻意繞過 `package:kallopis/kallopis.dart` barrel，改直接 import
// 元件本身的原始檔。基線（HEAD 14a69b2）目前因為另一個 agent 正在進行中的
// `KlpTextRole` 角色改版而整個 barrel 編不過——barrel 匯出的其他檔案引用了
// 還沒 commit 的 enum 成員。直接 import 可以繞開那些無關檔案，只編譯這個元件
// 實際用到的依賴，藉此驗證元件本身是可運作的。barrel 匯出本身由
// `consumer_contract_test.dart` 把關，等基線修好後會自然涵蓋到這個元件。

void main() {
  List<KlpAccordionItemData> items() => [
    const KlpAccordionItemData(
      id: 'a',
      title: '第一項',
      child: KlpText('內容 A'),
    ),
    const KlpAccordionItemData(
      id: 'b',
      title: '第二項',
      child: KlpText('內容 B'),
    ),
  ];

  Future<void> pump(WidgetTester tester, Widget child) {
    return tester.pumpWidget(
      MaterialApp(theme: buildKlpTheme(Brightness.light), home: child),
    );
  }

  testWidgets('單開模式下展開一項會收合另一項', (tester) async {
    await pump(tester, KlpAccordion(items: items()));

    expect(find.text('內容 A'), findsNothing);
    expect(find.text('內容 B'), findsNothing);

    await tester.tap(find.text('第一項'));
    await tester.pumpAndSettle();
    expect(find.text('內容 A'), findsOneWidget);

    await tester.tap(find.text('第二項'));
    await tester.pumpAndSettle();
    expect(find.text('內容 A'), findsNothing);
    expect(find.text('內容 B'), findsOneWidget);
  });

  testWidgets('多開模式下各項互不影響', (tester) async {
    await pump(tester, KlpAccordion(items: items(), multiple: true));

    await tester.tap(find.text('第一項'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('第二項'));
    await tester.pumpAndSettle();

    expect(find.text('內容 A'), findsOneWidget);
    expect(find.text('內容 B'), findsOneWidget);
  });

  testWidgets('initialExpandedIds 決定初始展開項目，並透過 onExpandedChanged 回報變化', (
    tester,
  ) async {
    Set<String>? reported;

    await pump(
      tester,
      KlpAccordion(
        items: items(),
        initialExpandedIds: const {'a'},
        onExpandedChanged: (ids) => reported = ids,
      ),
    );

    expect(find.text('內容 A'), findsOneWidget);

    await tester.tap(find.text('第一項'));
    await tester.pumpAndSettle();

    expect(reported, isEmpty);
  });
}
