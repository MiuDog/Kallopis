import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  Widget testBed(Widget child) => MaterialApp(
    theme: buildKlpTheme(Brightness.light),
    home: Scaffold(body: child),
  );

  testWidgets('status indicator follows status bar typography and spacing', (
    tester,
  ) async {
    await tester.pumpWidget(
      testBed(const KlpStatusIndicator(label: 'Saved locally')),
    );

    final indicator = find.byType(KlpStatusIndicator);
    final label = find.descendant(
      of: indicator,
      matching: find.text('Saved locally'),
    );
    final text = tester.widget<KlpText>(
      find.descendant(of: indicator, matching: find.byType(KlpText)),
    );
    final marker = find.descendant(
      of: indicator,
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration! as BoxDecoration).shape == BoxShape.circle,
      ),
    );
    final compact = tester.element(indicator).klp.space.compact;

    expect(label, findsOneWidget);
    expect(find.text('SAVED LOCALLY'), findsNothing);
    expect(text.role, KlpTextRole.code);
    expect(text.tone, KlpTextTone.muted);
    expect(text.color, isNull);
		expect(tester.getRect(marker).left, tester.getRect(indicator).left);
    expect(tester.getRect(label).left - tester.getRect(marker).right, compact);
		expect(tester.getRect(label).right, tester.getRect(indicator).right);
  });

  testWidgets('status bar composes the shared status indicator', (
    tester,
  ) async {
    await tester.pumpWidget(
      testBed(
        const SizedBox(
          width: 600,
          child: KlpStatusBar(
            leading: 'Flutter · Design IR v0.1',
            trailing: '80% · 1 frame · 6 nodes',
          ),
        ),
      ),
    );

    expect(find.byType(KlpStatusIndicator), findsOneWidget);
    expect(find.text('Flutter · Design IR v0.1'), findsOneWidget);
    expect(find.text('80% · 1 frame · 6 nodes'), findsOneWidget);
    final barRect = tester.getRect(find.byType(KlpStatusBar));
    final indicatorRect = tester.getRect(find.byType(KlpStatusIndicator));
    final trailingRect = tester.getRect(find.text('80% · 1 frame · 6 nodes'));
    final compact = tester.element(find.byType(KlpStatusBar)).klp.space.compact;
    expect(indicatorRect.left, barRect.left);
    expect(barRect.right - trailingRect.right, compact);
  });
}
