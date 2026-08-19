import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('關閉時內容存在但不接受點擊', (tester) async {
    var scrimTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.dark),
        home: Scaffold(
          body: KlpDrawer(
            open: false,
            edge: KlpDrawerEdge.right,
            onScrimTap: () => scrimTapped = true,
            child: const Text('面板內容'),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('面板內容'), findsOneWidget);

    final ignorePointer = tester.widget<IgnorePointer>(
      find.byType(IgnorePointer).first,
    );
    expect(ignorePointer.ignoring, isTrue);

    await tester.tapAt(const Offset(10, 10));
    await tester.pump();
    expect(scrimTapped, isFalse);
  });

  testWidgets('展開時點遮罩觸發 onScrimTap', (tester) async {
    var scrimTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.dark),
        home: Scaffold(
          body: KlpDrawer(
            open: true,
            edge: KlpDrawerEdge.right,
            onScrimTap: () => scrimTapped = true,
            child: const Text('面板內容'),
          ),
        ),
      ),
    );
    await tester.pump();

    final ignorePointer = tester.widget<IgnorePointer>(
      find.byType(IgnorePointer).first,
    );
    expect(ignorePointer.ignoring, isFalse);

    // 面板本身位於右緣，點左上角（遮罩區域）應觸發關閉。
    await tester.tapAt(const Offset(5, 5));
    await tester.pump();
    expect(scrimTapped, isTrue);
  });

  testWidgets('barrierDismissible 為 false 時點遮罩不觸發', (tester) async {
    var scrimTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.dark),
        home: Scaffold(
          body: KlpDrawer(
            open: true,
            barrierDismissible: false,
            onScrimTap: () => scrimTapped = true,
            child: const Text('面板內容'),
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tapAt(const Offset(5, 5));
    await tester.pump();
    expect(scrimTapped, isFalse);
  });

  testWidgets('四個方向都能渲染而不拋例外', (tester) async {
    for (final edge in KlpDrawerEdge.values) {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildKlpTheme(Brightness.light),
          home: Scaffold(
            body: KlpDrawer(
              open: true,
              edge: edge,
              size: 120,
              child: const Text('內容'),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull, reason: 'edge=$edge');
    }
  });
}
