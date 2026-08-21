import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';
import 'package:kallopis_catalog/catalog/note_background_editor.dart';

void main() {
  testWidgets('runtime editor updates RGBA and viewport controls', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: const SingleChildScrollView(child: NoteBackgroundRuntimeEditor()),
      ),
    );

    final swatch = find.byKey(const ValueKey('background-color-swatch'));
    final before = tester.widget<Container>(swatch).decoration as BoxDecoration;
    final red = find.descendant(
      of: find.byKey(const ValueKey('background-r')),
      matching: find.byType(Slider),
    );
    final alpha = find.descendant(
      of: find.byKey(const ValueKey('background-a')),
      matching: find.byType(Slider),
    );

    await tester.drag(red, const Offset(-120, 0));
    await tester.drag(alpha, const Offset(-120, 0));
    await tester.pump();

    final after = tester.widget<Container>(swatch).decoration as BoxDecoration;
    expect(after.color, isNot(before.color));
    expect(after.color!.a, lessThan(before.color!.a));
    expect(find.byKey(const ValueKey('background-zoom')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('background-stroke-behavior')),
      findsOneWidget,
    );
  });

  testWidgets('custom editor exposes connect select and delete tools', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: const SingleChildScrollView(child: NoteBackgroundCustomEditor()),
      ),
    );

    expect(find.text('點連'), findsOneWidget);
    expect(find.text('選取'), findsOneWidget);
    expect(find.text('刪除'), findsOneWidget);

    final editor = find.byType(KlpPageBackgroundEditor);
    await tester.tapAt(tester.getTopLeft(editor) + const Offset(37, 43));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('清除背景'), findsOneWidget);
  });
}
