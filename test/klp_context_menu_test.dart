import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('controller 可由六點操作鈕在指定位置開啟選單', (tester) async {
    final controller = KlpContextMenuController();

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.dark),
        home: Scaffold(
          body: KlpContextMenu(
            controller: controller,
            label: 'Block actions',
            items: [KlpMenuItemData(label: 'Duplicate', onPressed: () {})],
            child: GestureDetector(
              key: const ValueKey('menu-trigger'),
              behavior: HitTestBehavior.opaque,
              onTapDown: (details) => controller.openAt(details.globalPosition),
              child: const SizedBox(width: 40, height: 40),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('menu-trigger')));
    await tester.pump();

    expect(find.byType(KlpMenu), findsOneWidget);
    expect(find.text('Duplicate'), findsOneWidget);
  });

  testWidgets('右鍵點擊子樹會彈出重用 KlpMenu 的選單', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.dark),
        home: Scaffold(
          body: KlpContextMenu(
            label: '動作',
            items: [
              KlpMenuItemData(label: '重新命名', onPressed: () {}),
              KlpMenuItemData(label: '刪除', onPressed: () {}),
            ],
            child: const SizedBox(width: 200, height: 100, child: Text('目標區域')),
          ),
        ),
      ),
    );

    expect(find.byType(KlpMenu), findsNothing);

    await tester.tapAt(
      tester.getCenter(find.text('目標區域')),
      buttons: kSecondaryButton,
    );
    await tester.pump();

    expect(find.byType(KlpMenu), findsOneWidget);
    expect(find.text('重新命名'), findsOneWidget);
  });

  testWidgets('選到項目後選單關閉且動作被呼叫', (tester) async {
    var renamed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.dark),
        home: Scaffold(
          body: KlpContextMenu(
            label: '動作',
            items: [
              KlpMenuItemData(label: '重新命名', onPressed: () => renamed = true),
            ],
            child: const SizedBox(width: 200, height: 100, child: Text('目標區域')),
          ),
        ),
      ),
    );

    await tester.tapAt(
      tester.getCenter(find.text('目標區域')),
      buttons: kSecondaryButton,
    );
    await tester.pump();
    expect(find.byType(KlpMenu), findsOneWidget);

    await tester.tap(find.text('重新命名'));
    await tester.pump();

    expect(renamed, isTrue);
    expect(find.byType(KlpMenu), findsNothing);
  });

  testWidgets('點選單以外的區域會關閉選單', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.dark),
        home: Scaffold(
          body: KlpContextMenu(
            label: '動作',
            items: [KlpMenuItemData(label: '重新命名', onPressed: () {})],
            child: const SizedBox(width: 200, height: 100, child: Text('目標區域')),
          ),
        ),
      ),
    );

    await tester.tapAt(
      tester.getCenter(find.text('目標區域')),
      buttons: kSecondaryButton,
    );
    await tester.pump();
    expect(find.byType(KlpMenu), findsOneWidget);

    await tester.tapAt(const Offset(750, 550));
    await tester.pump();

    expect(find.byType(KlpMenu), findsNothing);
  });
}
