import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('KlpMenuItem exposes button/enabled/selected semantics', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.dark),
        home: Scaffold(
          body: KlpMenu(
            label: 'Page actions',
            items: [
              KlpMenuItemData(label: 'Enabled', onPressed: () {}),
              KlpMenuItemData(
                label: 'Disabled',
                enabled: false,
                onPressed: () {},
              ),
              KlpMenuItemData(
                label: 'Picked',
                selected: true,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(
      tester.getSemantics(find.text('Enabled')),
      matchesSemantics(
        label: 'Enabled',
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        // 每個選單項目都「可以」被選取，即使目前沒被選,也要回報
        // hasSelectedState，螢幕閱讀器才分得出「未選取」跟「這個概念不適用」。
        hasSelectedState: true,
        isSelected: false,
        hasTapAction: true,
        hasFocusAction: true,
        isFocusable: true,
      ),
    );

    expect(
      tester.getSemantics(find.text('Disabled')),
      matchesSemantics(
        label: 'Disabled',
        isButton: true,
        hasEnabledState: true,
        isEnabled: false,
        hasSelectedState: true,
        isSelected: false,
      ),
    );

    expect(
      tester.getSemantics(find.text('Picked')),
      matchesSemantics(
        label: 'Picked',
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        hasSelectedState: true,
        isSelected: true,
        hasTapAction: true,
        hasFocusAction: true,
        isFocusable: true,
      ),
    );

    handle.dispose();
  });

  testWidgets('KlpTabs tabs expose button/selected semantics', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.dark),
        home: Scaffold(
          body: KlpTabs(
            tabs: const ['One', 'Two'],
            selected: 0,
            onSelected: (_) {},
          ),
        ),
      ),
    );
    await tester.pump();

    expect(
      tester.getSemantics(find.text('One')),
      matchesSemantics(
        label: 'One',
        isButton: true,
        hasSelectedState: true,
        isSelected: true,
        hasTapAction: true,
        hasFocusAction: true,
        isFocusable: true,
      ),
    );

    expect(
      tester.getSemantics(find.text('Two')),
      matchesSemantics(
        label: 'Two',
        isButton: true,
        hasSelectedState: true,
        isSelected: false,
        hasTapAction: true,
        hasFocusAction: true,
        isFocusable: true,
      ),
    );

    handle.dispose();
  });

  testWidgets('KlpListTile exposes button/enabled/selected semantics', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.dark),
        home: Scaffold(
          body: Column(
            children: [
              KlpListTile(
                title: 'Actionable',
                selected: true,
                onPressed: () {},
              ),
              const KlpListTile(title: 'Static'),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(
      tester.getSemantics(find.text('Actionable')),
      matchesSemantics(
        label: 'Actionable',
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        hasSelectedState: true,
        isSelected: true,
        hasTapAction: true,
        hasFocusAction: true,
        isFocusable: true,
      ),
    );

    expect(
      tester.getSemantics(find.text('Static')),
      matchesSemantics(
        label: 'Static',
        isButton: false,
        // 沒有 onPressed 時完全不回應互動，不該回報 enabled 狀態
        // （hasEnabledState 保持預設的 false）。selected 仍然是這個元件一直
        // 都有的視覺概念，所以照樣回報。
        hasSelectedState: true,
        isSelected: false,
      ),
    );

    handle.dispose();
  });
}
