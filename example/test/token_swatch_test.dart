import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';
import 'package:kallopis_catalog/catalog/token_views.dart';

void main() {
  testWidgets('色票填色與中央色階標籤描述同一個顏色', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.dark),
        home: const Scaffold(
          body: Swatch(role: 'onInteraction', color: KlpPalette.ink900),
        ),
      ),
    );

    final swatchBox = tester.widget<Container>(
      find.descendant(
        of: find.byType(Swatch),
        matching: find.byType(Container),
      ),
    );
    final decoration = swatchBox.decoration! as BoxDecoration;
    final inkLabel = tester.widget<KlpText>(
      find.ancestor(of: find.text('ink900'), matching: find.byType(KlpText)),
    );

    expect(decoration.color, KlpPalette.ink900);
    expect(inkLabel.color, KlpPalette.ink50);
  });
}
