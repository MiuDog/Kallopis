import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

/// `tone` 是 [KlpBadge] 存在的理由——徽章的職責就是標示狀態。
///
/// 這個檔案的由來：`filled`（**預設**變體）原本完全丟棄 `tone`，只有選用的圓點會用到它。
/// 也就是說 `KlpBadge(label: 'X', tone: success)` 這個最自然的寫法什麼都不做，而且
/// 不會有任何錯誤訊息。目錄裡只示範了 `outline` 變體，所以這件事一直看不見——連目錄
/// 自己頁首那顆「完成度」徽章都踩到：完成該是綠、未完成該是琥珀，實際兩種一模一樣。
void main() {
  Future<Color?> fillOf(WidgetTester tester, KlpBadge badge) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: Scaffold(body: Center(child: badge)),
      ),
    );

    final container = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(KlpBadge),
            matching: find.byType(Container),
          )
          .first,
    );
    return (container.decoration as BoxDecoration?)?.color;
  }

  group('filled 變體必須表現出 tone', () {
    for (final (a, b) in const [
      (KlpFeedbackTone.success, KlpFeedbackTone.danger),
      (KlpFeedbackTone.warning, KlpFeedbackTone.info),
      (KlpFeedbackTone.success, KlpFeedbackTone.neutral),
    ]) {
      testWidgets('${a.name} 與 ${b.name} 不得長得一樣', (tester) async {
        final first = await fillOf(tester, KlpBadge(label: 'X', tone: a));
        final second = await fillOf(tester, KlpBadge(label: 'X', tone: b));

        expect(
          first?.toARGB32(),
          isNot(second?.toARGB32()),
          reason:
              '預設變體丟棄了 tone。徽章不表現狀態就沒有存在的必要，'
              '而且這個失效不會有任何錯誤訊息。',
        );
      });
    }
  });

  testWidgets('filled 的語意色是疊層，不是實色', (tester) async {
    final fill = await fillOf(
      tester,
      const KlpBadge(label: 'X', tone: KlpFeedbackTone.success),
    );

    expect(
      fill!.a,
      lessThan(1.0),
      reason:
          '語意色的明度都在中段，直接當實色底會讓標籤文字在亮態下掉出 AA。'
          '疊層才能同時保住色相與對比。',
    );
  });

  testWidgets('neutral 不套語意色', (tester) async {
    late KlpThemeData tokens;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: Builder(
          builder: (context) {
            tokens = context.klp.color;
            return const Scaffold(
              body: Center(child: KlpBadge(label: 'X')),
            );
          },
        ),
      ),
    );

    final container = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(KlpBadge),
            matching: find.byType(Container),
          )
          .first,
    );

    expect(
      (container.decoration as BoxDecoration).color?.toARGB32(),
      tokens.component.toARGB32(),
      reason: 'neutral 沒有語意色可疊，應維持中性表面',
    );
  });
}
