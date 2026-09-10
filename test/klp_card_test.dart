import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('card 呈現所有內容插槽並使用 typed surface tone', (tester) async {
    late KlpThemeData tokens;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: Builder(
          builder: (context) {
            tokens = context.klpColors;
            return const KlpCard(
              title: 'Title',
              label: 'Label',
              leading: KlpText('Leading'),
              trailing: KlpText('Trailing'),
              footer: KlpText('Footer'),
              tone: KlpCardTone.muted,
              child: KlpText('Body'),
            );
          },
        ),
      ),
    );

    for (final text in [
      'Title',
      'Label',
      'Leading',
      'Trailing',
      'Footer',
      'Body',
    ]) {
      expect(find.text(text), findsOneWidget);
    }

    final decoration =
        tester
                .widget<DecoratedBox>(
                  find
                      .descendant(
                        of: find.byType(KlpCard),
                        matching: find.byType(DecoratedBox),
                      )
                      .first,
                )
                .decoration
            as BoxDecoration;
    expect(decoration.color?.toARGB32(), tokens.surfaceMuted.toARGB32());
  });

  testWidgets('selected card 疊加 selection wash', (tester) async {
    late KlpThemeData tokens;
    late Color selectionWash;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: Builder(
          builder: (context) {
            tokens = context.klpColors;
            selectionWash = context.klp.selectionWash;
            return const KlpCard(
              title: 'Selected',
              selected: true,
              child: KlpText('Body'),
            );
          },
        ),
      ),
    );

    final decoration =
        tester
                .widget<DecoratedBox>(
                  find
                      .descendant(
                        of: find.byType(KlpCard),
                        matching: find.byType(DecoratedBox),
                      )
                      .first,
                )
                .decoration
            as BoxDecoration;
    expect(
      decoration.color?.toARGB32(),
      Color.alphaBlend(selectionWash, tokens.component).toARGB32(),
    );
  });

  testWidgets('danger metric card 以語意 tone 呈現數值與說明', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: const KlpMetricCard(
          label: 'Latency',
          value: '1420',
          unit: 'ms',
          trend: '↑',
          subtitle: 'Breached',
          tone: KlpFeedbackTone.danger,
        ),
      ),
    );

    for (final text in ['1420', 'ms', '↑', 'Breached']) {
      final widget = tester.widget<KlpText>(
        find.byWidgetPredicate(
          (candidate) => candidate is KlpText && candidate.data == text,
        ),
      );
      expect(widget.tone, KlpTextTone.danger);
    }
  });
}
