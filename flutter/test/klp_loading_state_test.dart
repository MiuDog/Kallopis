import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('KlpLoadingState renders geometric spinner and label', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: const Scaffold(body: KlpLoadingState(label: '載入中...')),
      ),
    );

    expect(find.text('載入中...'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(KlpGeometricSpinner),
        matching: find.byType(CustomPaint),
      ),
      findsOneWidget,
    );
  });

  testWidgets('KlpGeometricSpinner respects reduced motion', (tester) async {
    final style = KlpVisualStyle.defaultStyle.withReducedMotion(true);
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light, style: style),
        home: const Scaffold(body: KlpGeometricSpinner()),
      ),
    );

    expect(
      find.descendant(
        of: find.byType(KlpGeometricSpinner),
        matching: find.byType(CustomPaint),
      ),
      findsOneWidget,
    );
  });
}
