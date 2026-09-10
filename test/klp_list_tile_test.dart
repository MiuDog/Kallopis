import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('list tile 保留緊密高度、狀態表面與呼叫端事件', (tester) async {
    var pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: KlpColumn(
          children: [
            KlpListTile(
              title: 'Deploy',
              compact: true,
              tone: KlpFeedbackTone.warning,
              onPressed: () => pressed = true,
            ),
          ],
        ),
      ),
    );

    final tile = find.byType(KlpListTile);
    final context = tester.element(tile);
    expect(tester.getSize(tile).height, context.klp.space.controlHeightSmall);
    expect(find.text('Deploy'), findsOneWidget);

    final frame = tester.widget<Material>(
      find.descendant(of: tile, matching: find.byType(Material)),
    );
    expect(
      frame.color,
      context.klpColors.warning.withValues(
        alpha: context.klp.surface.listStatusOpacity,
      ),
    );

    await tester.tap(find.text('Deploy'));
    expect(pressed, isTrue);
  });
}
