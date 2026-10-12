import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('page chrome 投影麵包屑、狀態、協作者與標題', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: const KlpPageChrome(
          breadcrumb: ['Workspace', 'Project'],
          title: 'Architecture',
          status: 'Editing',
          collaborator: 'Miu',
        ),
      ),
    );

    for (final text in ['Workspace / Project', 'Architecture', 'Editing']) {
      expect(find.text(text), findsOneWidget);
    }
    final collaborator = tester.widget<KlpBadge>(
      find.byWidgetPredicate(
        (widget) => widget is KlpBadge && widget.label == 'Miu',
      ),
    );
    expect(collaborator.tone, KlpFeedbackTone.neutral);
    expect(find.byType(KlpColumn), findsOneWidget);
    expect(find.byType(KlpWrap), findsOneWidget);
  });

  testWidgets('save status card 保留格式化時間與訊息 tone', (tester) async {
    late KlpThemeData tokens;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: Builder(
          builder: (context) {
            tokens = context.klpColors;
            return const KlpSaveStatusCard(
              savedAt: '2 minutes ago',
              messages: [
                KlpStatusMessageData(label: 'Synced'),
                KlpStatusMessageData(
                  label: 'Validation failed',
                  tone: KlpFeedbackTone.danger,
                ),
              ],
            );
          },
        ),
      ),
    );

    expect(find.textContaining('2 minutes ago'), findsOneWidget);
    final neutral = tester.widget<KlpText>(
      find.byWidgetPredicate(
        (widget) => widget is KlpText && widget.data == 'Synced',
      ),
    );
    final danger = tester.widget<KlpText>(
      find.byWidgetPredicate(
        (widget) => widget is KlpText && widget.data == 'Validation failed',
      ),
    );
    expect(neutral.color?.toARGB32(), tokens.textMuted.toARGB32());
    expect(danger.color?.toARGB32(), tokens.danger.toARGB32());
  });

  testWidgets('property summary 依序投影 badges、tags 與 metadata', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: const KlpPropertySummary(
          badges: [
            KlpPropertyBadgeData(
              label: 'Ready',
              tone: KlpFeedbackTone.success,
              dot: true,
            ),
          ],
          tags: ['Architecture', 'Flutter'],
          metadata: 'Updated today',
        ),
      ),
    );

    final badge = tester.widget<KlpBadge>(
      find.byWidgetPredicate(
        (widget) => widget is KlpBadge && widget.label == 'Ready',
      ),
    );
    expect(badge.tone, KlpFeedbackTone.success);
    expect(badge.dot, isTrue);
    for (final tag in ['Architecture', 'Flutter']) {
      expect(
        find.byWidgetPredicate(
          (widget) => widget is KlpTag && widget.label == tag,
        ),
        findsOneWidget,
      );
    }
    expect(find.text('Updated today'), findsOneWidget);
    expect(find.byType(KlpWrap), findsNWidgets(2));
  });
}
