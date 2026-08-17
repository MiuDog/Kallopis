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
}
