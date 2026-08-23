import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('arrow down moves the keyboard highlight through enabled items', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.dark),
        home: Scaffold(
          body: KlpMenu(
            label: 'Page actions',
            items: [
              KlpMenuItemData(label: 'First', onPressed: () {}),
              KlpMenuItemData(
                label: 'Second',
                enabled: false,
                onPressed: () {},
              ),
              KlpMenuItemData(label: 'Third', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    Material materialFor(String label) => tester.widget<Material>(
      find
          .ancestor(of: find.text(label), matching: find.byType(Material))
          .first,
    );
    final tokens = KlpThemeContext(
      tester.element(find.text('First')),
    ).klpColors;
    final selectionWash = KlpThemeContext(
      tester.element(find.text('First')),
    ).klp.selectionWash;

    // 尚未按方向鍵時沒有任何項目呈現高亮底色。
    expect(materialFor('First').color, tokens.clear);
    expect(materialFor('Third').color, tokens.clear);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(materialFor('First').color, selectionWash);
    expect(materialFor('Third').color, tokens.clear);

    // 停用項目會被跳過，直接落在下一個可用項目上。
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(materialFor('First').color, tokens.clear);
    expect(materialFor('Third').color, selectionWash);

    // 循環回到第一個可用項目。
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(materialFor('First').color, selectionWash);
    expect(materialFor('Third').color, tokens.clear);

    expect(materialFor('Second'), isNotNull);
  });

  testWidgets('enter invokes the highlighted item and space too', (
    tester,
  ) async {
    var firstCount = 0;
    var secondCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.dark),
        home: Scaffold(
          body: KlpMenu(
            label: 'Page actions',
            items: [
              KlpMenuItemData(label: 'First', onPressed: () => firstCount++),
              KlpMenuItemData(label: 'Second', onPressed: () => secondCount++),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(firstCount, 1);
    expect(secondCount, 0);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(secondCount, 1);
  });

  testWidgets('escape calls onEscape', (tester) async {
    var escaped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.dark),
        home: Scaffold(
          body: KlpMenu(
            label: 'Page actions',
            onEscape: () => escaped = true,
            items: [KlpMenuItemData(label: 'First', onPressed: () {})],
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect(escaped, isTrue);
  });

  testWidgets(
    'KlpCommandMenu arrow keys move highlight across sections and enter fires it',
    (tester) async {
      var runCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          theme: buildKlpTheme(Brightness.dark),
          home: Scaffold(
            body: KlpCommandMenu(
              sections: [
                KlpCommandSectionData(
                  label: 'Section A',
                  items: [KlpCommandItemData(label: 'Alpha', onPressed: () {})],
                ),
                KlpCommandSectionData(
                  label: 'Section B',
                  items: [
                    KlpCommandItemData(
                      label: 'Beta',
                      onPressed: () => runCount++,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      expect(runCount, 1);
    },
  );

  testWidgets('KlpCommandMenu escape calls onEscape', (tester) async {
    var escaped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.dark),
        home: Scaffold(
          body: KlpCommandMenu(
            onEscape: () => escaped = true,
            sections: [
              KlpCommandSectionData(
                label: 'Section A',
                items: [KlpCommandItemData(label: 'Alpha', onPressed: () {})],
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect(escaped, isTrue);
  });

  testWidgets('KlpTabs arrow right/left switches the selected tab and wraps', (
    tester,
  ) async {
    var selected = 0;

    Widget build(int selectedIndex) => MaterialApp(
      theme: buildKlpTheme(Brightness.dark),
      home: Scaffold(
        body: KlpTabs(
          tabs: const ['One', 'Two', 'Three'],
          selected: selectedIndex,
          onSelected: (value) => selected = value,
        ),
      ),
    );

    await tester.pumpWidget(build(selected));
    await tester.pump();

    // 分頁列不像彈出選單那樣自動取得焦點——它常駐在一般版面裡，搶焦點會打斷
    // 使用者原本在做的事。所以鍵盤操作前，先讓其中一個分頁像使用者用 Tab 鍵
    // 移動過來一樣取得焦點。
    Focus.of(tester.element(find.text('One'))).requestFocus();
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(selected, 1);
    await tester.pumpWidget(build(selected));

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(selected, 2);
    await tester.pumpWidget(build(selected));

    // 到達尾端後往同方向移動會循環回到開頭。
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(selected, 0);
    await tester.pumpWidget(build(selected));

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    expect(selected, 2);
  });
}
