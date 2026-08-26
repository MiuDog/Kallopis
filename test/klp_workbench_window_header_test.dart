import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('keeps one header and aligns the primary pane toggle', (
    tester,
  ) async {
    var toggles = 0;

    await tester.pumpWidget(
      KlpApp(
        showWindowHeader: false,
        home: KlpAppScreen(
          child: SizedBox(
            width: 1000,
            child: KlpWorkbenchWindowHeader(
              titleText: 'Notist',
              primaryPaneWidth: 268,
              primaryVisible: true,
              onTogglePrimary: () => toggles += 1,
              collapseLabel: '收合側邊面板',
              expandLabel: '展開側邊面板',
            ),
          ),
        ),
      ),
    );

    expect(find.byType(KlpWindowHeader), findsOneWidget);
    expect(find.bySemanticsLabel('收合側邊面板'), findsOneWidget);
    expect(
      tester.widget<KlpIconButton>(find.byType(KlpIconButton)).tone,
      KlpIconButtonTone.inline,
    );

    await tester.tap(find.bySemanticsLabel('收合側邊面板'));
    expect(toggles, 1);

    final headerRect = tester.getRect(find.byType(KlpWorkbenchWindowHeader));
    final toggleRect = tester.getRect(find.bySemanticsLabel('收合側邊面板'));
    expect(toggleRect.center.dx, closeTo(headerRect.left + 268, 40));
  });
}
