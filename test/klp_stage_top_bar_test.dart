import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('window header owns the stage top bar above the stage body', (
    tester,
  ) async {
    await tester.pumpWidget(
      KlpApp(
        showWindowHeader: false,
        home: KlpAppScreen(
          child: SizedBox(
            width: 1000,
            height: 240,
            child: Column(
              children: [
                KlpWorkbenchWindowHeader(
                  titleText: 'Notist',
                  primaryPaneWidth: 260,
                  primaryVisible: true,
                  onTogglePrimary: () {},
                  collapseLabel: 'Collapse navigation',
                  expandLabel: 'Expand navigation',
                  secondaryPaneWidth: 300,
                  secondaryVisible: true,
                  showWindowControls: false,
                  stageTopBar: KlpStageTopBar(
                    tab: const KlpStageTab(label: 'notes.md'),
                    actions: [
                      KlpButton(
                        key: const ValueKey('action'),
                        leading: const KlpIcon(KlpIcons.edit),
                        label: 'Edit',
                        tone: KlpButtonTone.dashed,
                        size: KlpControlSize.xs,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  child: ColoredBox(
                    key: ValueKey('stage'),
                    color: Color(0xff000000),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final topBarRect = tester.getRect(find.byType(KlpStageTopBar));
    final tabRect = tester.getRect(find.byType(KlpStageTab));
    final stageRect = tester.getRect(find.byKey(const ValueKey('stage')));
    final actionRect = tester.getRect(find.byKey(const ValueKey('action')));
    final headerRect = tester.getRect(find.byType(KlpWorkbenchWindowHeader));
    final klp = tester.element(find.byType(KlpStageTopBar)).klp;
    final compact = klp.space.compact;

    expect(stageRect.top, headerRect.bottom);
    expect(
      topBarRect.bottom,
      headerRect.bottom + compact / 2 + klp.shape.panel,
    );
    expect(tabRect.left, headerRect.left + 260 + compact / 2);
    expect(actionRect.right, headerRect.right - 300 - compact / 2);
    expect(actionRect.bottom, lessThanOrEqualTo(headerRect.bottom));
    expect(
      actionRect.height,
      tester
          .element(find.byKey(const ValueKey('action')))
          .klp
          .space
          .controlHeightXSmall,
    );
  });

	testWidgets('uses a lower end corner to connect the tab to the stage', (
    tester,
  ) async {
    await tester.pumpWidget(
      const KlpApp(
        showWindowHeader: false,
        home: KlpAppScreen(child: KlpStageTab(label: 'notes.md')),
      ),
    );

    final decoration =
        tester
                .widgetList<DecoratedBox>(
                  find.descendant(
                    of: find.byType(KlpStageTab),
                    matching: find.byType(DecoratedBox),
                  ),
                )
                .first
                .decoration
            as BoxDecoration;
		final radius = decoration.borderRadius!.resolve(TextDirection.ltr);

    expect(radius.topLeft.x, greaterThan(0));
    expect(radius.topRight.x, greaterThan(0));
    expect(
      radius.topLeft.x,
      tester.element(find.byType(KlpStageTab)).klp.buttonRadius,
    );
    expect(radius.bottomLeft, Radius.zero);
		expect(
			radius.bottomRight.x,
			tester.element(find.byType(KlpStageTab)).klp.shape.panel,
		);

    final text = tester.widget<Text>(
      find.descendant(
        of: find.byType(KlpStageTab),
        matching: find.text('notes.md'),
      ),
    );
    expect(text.style?.decoration, TextDecoration.none);
  });

  testWidgets(
    'collapsed primary pane places the tab after its expand control',
    (tester) async {
      await tester.pumpWidget(
        KlpApp(
          showWindowHeader: false,
          home: KlpAppScreen(
            child: SizedBox(
              width: 1000,
              child: KlpWorkbenchWindowHeader(
                titleText: 'Designist',
                primaryPaneWidth: 260,
                primaryVisible: false,
                onTogglePrimary: () {},
                collapseLabel: 'Collapse navigation',
                expandLabel: 'Expand navigation',
                secondaryPaneWidth: 300,
                secondaryVisible: true,
                showWindowControls: false,
                stageTopBar: const KlpStageTopBar(
                  tab: KlpStageTab(label: '流程'),
                ),
              ),
            ),
          ),
        ),
      );

      final toggleRect = tester.getRect(
        find.byWidgetPredicate(
          (widget) =>
              widget is KlpIconButton && widget.label == 'Expand navigation',
        ),
      );
      final tabRect = tester.getRect(find.byType(KlpStageTab));
      final compact = tester
          .element(find.byType(KlpWorkbenchWindowHeader))
          .klp
          .space
          .compact;

      expect(tabRect.left, toggleRect.right + compact / 2);
    },
  );
}
