import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  for (final brightness in Brightness.values) {
    testWidgets(
      'KlpDivider uses the semantic divider color in ${brightness.name}',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: buildKlpTheme(brightness),
            home: const Scaffold(body: KlpDivider()),
          ),
        );

        final context = tester.element(find.byType(KlpDivider));
        final coloredBox = tester.widget<ColoredBox>(
          find.descendant(
            of: find.byType(KlpDivider),
            matching: find.byType(ColoredBox),
          ),
        );

        expect(coloredBox.color, context.klpColors.divider);
        expect(coloredBox.color.a, greaterThan(0));
      },
    );
  }

  testWidgets(
    'KlpDashedDivider supports custom width, color, and vertical layout',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildKlpTheme(Brightness.light),
          home: const Scaffold(
            body: Column(
              children: [
                KlpDashedDivider(
                  width: 3.0,
                  color: Color(0xFFBD3341),
                  dashLength: 8.0,
                  gapLength: 4.0,
                ),
                SizedBox(
                  height: 100,
                  child: KlpDashedDivider(
                    vertical: true,
                    width: 2.0,
                    color: Color(0xFF00773F),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      final horizontalSizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(KlpDashedDivider).first,
          matching: find.byType(SizedBox),
        ),
      );
      expect(horizontalSizedBox.height, 3.0);
      expect(horizontalSizedBox.width, double.infinity);

      final verticalSizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(KlpDashedDivider).last,
          matching: find.byType(SizedBox),
        ),
      );
      expect(verticalSizedBox.width, 2.0);
      expect(verticalSizedBox.height, double.infinity);
    },
  );

  testWidgets('KlpDashedBorder supports custom width, color, and radius', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: const Scaffold(
          body: KlpDashedBorder(
            width: 2.5,
            color: Color(0xFFBD3341),
            radius: 12.0,
            child: Text('Dashed block'),
          ),
        ),
      ),
    );

    expect(find.text('Dashed block'), findsOneWidget);
    expect(find.byType(KlpDashedBorder), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
  });
}
