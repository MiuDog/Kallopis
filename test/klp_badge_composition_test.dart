import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('badge 保留狀態文字、圓點與 typed variant', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: const KlpBadge(
          label: 'ready',
          tone: KlpFeedbackTone.success,
          variant: KlpBadgeVariant.outline,
          dot: true,
        ),
      ),
    );

    final badge = tester.widget<KlpBadge>(find.byType(KlpBadge));
    final label = tester.widget<KlpText>(
      find.byWidgetPredicate(
        (widget) => widget is KlpText && widget.data == 'READY',
      ),
    );

    expect(badge.variant, KlpBadgeVariant.outline);
    expect(badge.dot, isTrue);
    expect(label.role, KlpTextRole.caption);
    expect(find.byType(Container), findsNWidgets(2));
  });

  testWidgets('tag 呈現前綴並派送移除事件', (tester) async {
    var removed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: KlpTag(
          label: 'architecture',
          prefix: '#',
          onRemove: () => removed = true,
        ),
      ),
    );

    expect(find.text('#'), findsOneWidget);
    expect(find.text('architecture'), findsOneWidget);
    await tester.tap(find.text('×'));
    expect(removed, isTrue);
  });
}
