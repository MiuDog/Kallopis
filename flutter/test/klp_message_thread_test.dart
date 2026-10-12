import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('message bubble 保留方向、背景與密集內距', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: const KlpColumn(
          children: [
            KlpMessageBubble(
              author: 'Assistant',
              timestamp: '10:00',
              emphasized: true,
              dense: true,
              child: KlpText('Leading message'),
            ),
            KlpMessageBubble(
              author: 'User',
              timestamp: '10:01',
              alignment: KlpMessageAlignment.trailing,
              child: KlpText('Trailing message'),
            ),
          ],
        ),
      ),
    );

    expect(
      tester.getCenter(find.text('Leading message')).dx,
      lessThan(tester.getCenter(find.text('Trailing message')).dx),
    );
    final bubble = find.ancestor(
      of: find.text('Leading message'),
      matching: find.byType(KlpMessageBubble),
    );
    final box = tester.widget<KlpBox>(
      find.descendant(of: bubble, matching: find.byType(KlpBox)),
    );
    final context = tester.element(bubble);
    expect(box.insets?.start, context.klp.space.contentInset);
  });

  testWidgets('message thread 依序呈現並派送載入較早內容事件', (tester) async {
    var loaded = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: KlpMessageThread(
          loadOlderLabel: 'Load older',
          onLoadOlder: () => loaded = true,
          messages: const [KlpText('First'), KlpText('Second')],
        ),
      ),
    );

    expect(find.text('First'), findsOneWidget);
    expect(find.text('Second'), findsOneWidget);
    await tester.tap(find.text('Load older'));
    expect(loaded, isTrue);
  });
}
