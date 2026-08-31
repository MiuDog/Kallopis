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
          child: Align(
            alignment: Alignment.topCenter,
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
      ),
    );

    expect(find.byType(KlpWindowHeader), findsOneWidget);
    expect(find.bySemanticsLabel('收合側邊面板'), findsOneWidget);
    expect(
      tester.widget<KlpIconButton>(find.byType(KlpIconButton)).tone,
      KlpIconButtonTone.inline,
    );
    final layout = tester
        .element(find.byType(KlpWorkbenchWindowHeader))
        .klp
        .geometry
        .layout;
    expect(
      tester.getSize(find.bySemanticsLabel('收合側邊面板')),
      Size.square(layout.windowHeaderControlSize),
    );

    await tester.tap(find.bySemanticsLabel('收合側邊面板'));
    expect(toggles, 1);

    final headerRect = tester.getRect(find.byType(KlpWindowHeader));
    expect(
      headerRect.height,
      layout.windowHeaderHeight +
          tester
              .element(find.byType(KlpWorkbenchWindowHeader))
              .klp
              .space
              .compact,
    );
    final toggleRect = tester.getRect(find.bySemanticsLabel('收合側邊面板'));
    expect(toggleRect.center.dx, closeTo(headerRect.left + 268, 40));
  });

  testWidgets('secondary pane toggle follows the live pane width', (
    tester,
  ) async {
    var secondaryWidth = 300.0;
    late StateSetter updateHeader;

    await tester.pumpWidget(
      KlpApp(
        showWindowHeader: false,
        home: StatefulBuilder(
          builder: (context, setState) {
            updateHeader = setState;
            return SizedBox(
              width: 1000,
              child: KlpWorkbenchWindowHeader(
                titleText: 'Notist',
                primaryPaneWidth: 268,
                primaryVisible: true,
                onTogglePrimary: () {},
                collapseLabel: '收合側邊面板',
                expandLabel: '展開側邊面板',
                secondaryPaneWidth: secondaryWidth,
                secondaryVisible: true,
                onToggleSecondary: () {},
                collapseSecondaryLabel: '收合檢查器',
                expandSecondaryLabel: '展開檢查器',
                showWindowControls: false,
              ),
            );
          },
        ),
      ),
    );

    final secondaryToggle = find.bySemanticsLabel('收合檢查器');
    expect(secondaryToggle, findsOneWidget);
    final before = tester.getRect(secondaryToggle);

    updateHeader(() => secondaryWidth = 360);
    await tester.pump();

    final after = tester.getRect(secondaryToggle);
    expect(after.left, closeTo(before.left - 60, 0.01));
  });
}
