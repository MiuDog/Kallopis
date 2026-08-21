import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('KlpInlineCode renders rounded box with mono font', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: const Scaffold(body: KlpInlineCode('hello_world()')),
      ),
    );

    expect(find.text('hello_world()'), findsOneWidget);
    final textWidget = tester.widget<Text>(find.text('hello_world()'));
    expect(textWidget.style?.fontFamily, 'packages/kallopis/IBM Plex Mono');
    expect(textWidget.style?.fontSize, 14.0);

    final container = tester.widget<Container>(
      find.ancestor(
        of: find.text('hello_world()'),
        matching: find.byType(Container),
      ),
    );
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.borderRadius, isNotNull);
  });

  testWidgets('KlpRichText with code node renders KlpInlineCode', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: const Scaffold(
          body: KlpRichText(
            nodes: [
              KlpRichTextNode(text: 'Run '),
              KlpRichTextNode(text: 'flutter test', kind: KlpRichTextKind.code),
            ],
          ),
        ),
      ),
    );

    expect(find.text('flutter test'), findsOneWidget);
    expect(find.byType(KlpInlineCode), findsOneWidget);
  });
}
