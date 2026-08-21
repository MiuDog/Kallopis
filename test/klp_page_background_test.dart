import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';
import 'package:kallopis/src/editor/internal/klp_page_background_painter.dart';

import 'style_fixture.dart';

void main() {
  Future<void> pumpBackground(
    WidgetTester tester,
    KlpPageBackgroundStyle style, {
    KlpVisualStyle? visualStyle,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        themeAnimationDuration: Duration.zero,
        theme: buildKlpTheme(
          Brightness.light,
          style: visualStyle ?? KlpVisualStyle.defaultStyle,
        ),
        home: SizedBox(
          width: 320,
          height: 240,
          child: KlpPageBackground(
            style: style,
            child: const Text('note content'),
          ),
        ),
      ),
    );
  }

  testWidgets('all page background styles render their child', (tester) async {
    for (final style in KlpPageBackgroundStyle.values) {
      await pumpBackground(tester, style);

      expect(find.text('note content'), findsOneWidget);
      expect(tester.takeException(), isNull, reason: style.name);
    }
  });

  testWidgets('resolved painter responds to visual style changes', (
    tester,
  ) async {
    await pumpBackground(tester, KlpPageBackgroundStyle.dots);
    final backgroundPaint = find.descendant(
      of: find.byType(KlpPageBackground),
      matching: find.byType(CustomPaint),
    );
    final original = tester.widget<CustomPaint>(backgroundPaint).painter!;

    await pumpBackground(
      tester,
      KlpPageBackgroundStyle.dots,
      visualStyle: contrastingStyle,
    );
    final contrasting = tester.widget<CustomPaint>(backgroundPaint).painter!;

    expect(contrasting.shouldRepaint(original), isTrue);
  });

  testWidgets('built-in patterns resolve one semantic page color', (
    tester,
  ) async {
    for (final style in const [
      KlpPageBackgroundStyle.ruled,
      KlpPageBackgroundStyle.dots,
      KlpPageBackgroundStyle.grid,
    ]) {
      await pumpBackground(tester, style);
      final backgroundPaint = find.descendant(
        of: find.byType(KlpPageBackground),
        matching: find.byType(CustomPaint),
      );
      final painter = tester.widget<CustomPaint>(backgroundPaint).painter!;
      final resolved = painter as KlpPageBackgroundPainter;
      final context = tester.element(find.byType(KlpPageBackground));

      expect(resolved.visuals.pattern, context.klp.color.pagePattern);
    }
  });

  testWidgets('dots resolve a stronger theme mark than background lines', (
    tester,
  ) async {
    await pumpBackground(tester, KlpPageBackgroundStyle.dots);
    final backgroundPaint = find.descendant(
      of: find.byType(KlpPageBackground),
      matching: find.byType(CustomPaint),
    );
    final painter = tester.widget<CustomPaint>(backgroundPaint).painter!;
    final resolved = painter as KlpPageBackgroundPainter;
    final context = tester.element(find.byType(KlpPageBackground));

    expect(resolved.visuals.dotWidth, context.klp.shape.stroke);
    expect(resolved.visuals.markWidth, context.klp.shape.hairline);
  });

  test('stroke behavior controls only the resolved mark width', () {
    final painter = KlpPageBackgroundPainter(
      recipe: KlpGridPageBackgroundRecipe(),
      viewport: KlpPageBackgroundViewport(scale: 2),
      visuals: const KlpPageBackgroundVisuals(
        surface: Colors.white,
        pattern: Colors.black,
        spacing: 20,
        markWidth: 1,
        dotWidth: 2,
      ),
    );
    final axis = KlpPageBackgroundAxisStyle(width: 3);

    expect(
      painter.resolveMarkWidth(axis, KlpPageBackgroundStrokeBehavior.fixed),
      3,
    );
    expect(
      painter.resolveMarkWidth(axis, KlpPageBackgroundStrokeBehavior.scaled),
      6,
    );
  });

  testWidgets('zero-size backgrounds do not throw', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: const SizedBox.shrink(
          child: KlpPageBackground(
            style: KlpPageBackgroundStyle.grid,
            child: SizedBox.shrink(),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
