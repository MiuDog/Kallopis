import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('keeps one header and aligns the primary pane toggle', (
    tester,
  ) async {
    var toggles = 0;
    var settingsOpens = 0;

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
              secondaryPaneWidth: 300,
              secondaryVisible: true,
              onToggleSecondary: () => toggles += 1,
              collapseSecondaryLabel: '收合檢查器',
              expandSecondaryLabel: '展開檢查器',
              appIconButton: KlpIconButton(
                icon: KlpIcons.edit,
                label: '設定',
                size: KlpIconButtonSize.window,
                tone: KlpIconButtonTone.inline,
                onPressed: () => settingsOpens += 1,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(KlpWindowHeader), findsOneWidget);
    expect(find.bySemanticsLabel('收合側邊面板'), findsOneWidget);
    expect(find.bySemanticsLabel('收合檢查器'), findsOneWidget);
    final settingsButton = find.byWidgetPredicate(
      (widget) => widget is KlpIconButton && widget.label == '設定',
    );
    expect(settingsButton, findsOneWidget);
    expect(find.bySemanticsLabel('設定'), findsOneWidget);
    final collapseButton = find.byWidgetPredicate(
      (widget) => widget is KlpIconButton && widget.label == '收合側邊面板',
    );
    expect(
      tester.widget<KlpIconButton>(collapseButton).tone,
      KlpIconButtonTone.inline,
    );

    final appIconSlot = find.byKey(const ValueKey(klpWindowAppIconSlotKey));
    expect(
      find.descendant(of: appIconSlot, matching: settingsButton),
      findsOneWidget,
    );
    await tester.tap(settingsButton);
    expect(settingsOpens, 1);

    await tester.tap(find.bySemanticsLabel('收合側邊面板'));
    expect(toggles, 1);

    final headerRect = tester.getRect(find.byType(KlpWorkbenchWindowHeader));
    final toggleRect = tester.getRect(find.bySemanticsLabel('收合側邊面板'));
    final compact = tester
        .element(find.byType(KlpWorkbenchWindowHeader))
        .klp
        .space
        .compact;
    expect(toggleRect.right, headerRect.left + 268 - compact / 2);
    final secondaryToggleRect = tester.getRect(find.bySemanticsLabel('收合檢查器'));
    expect(secondaryToggleRect.left, headerRect.right - 300 + compact / 2);
  });

  testWidgets('collapsed pane controls remain next to title and actions', (
    tester,
  ) async {
    var primaryExpansions = 0;

    await tester.pumpWidget(
      KlpApp(
        showWindowHeader: false,
        home: KlpAppScreen(
          child: SizedBox(
            width: 1000,
            child: KlpWorkbenchWindowHeader(
              titleText: 'Notist',
              primaryPaneWidth: 268,
              primaryVisible: false,
              onTogglePrimary: () => primaryExpansions += 1,
              collapseLabel: '收合側邊面板',
              expandLabel: '展開側邊面板',
              secondaryPaneWidth: 300,
              secondaryVisible: false,
              onToggleSecondary: () {},
              collapseSecondaryLabel: '收合檢查器',
              expandSecondaryLabel: '展開檢查器',
              showWindowControls: false,
            ),
          ),
        ),
      ),
    );

    final titleRect = tester.getRect(find.text('Notist'));
    final primaryToggle = find.byWidgetPredicate(
      (widget) => widget is KlpIconButton && widget.label == '展開側邊面板',
    );
    final secondaryToggle = find.byWidgetPredicate(
      (widget) => widget is KlpIconButton && widget.label == '展開檢查器',
    );
    final primaryToggleRect = tester.getRect(primaryToggle);
    final secondaryToggleRect = tester.getRect(secondaryToggle);

		final identityGap = tester
				.element(find.byType(KlpWorkbenchWindowHeader))
				.klp
				.geometry
				.layout
				.windowIdentityGap;
		expect(primaryToggleRect.left - titleRect.right, identityGap);
    expect(secondaryToggleRect.left, greaterThan(primaryToggleRect.right));

    final gesture = await tester.startGesture(primaryToggleRect.center);
    await gesture.up();
    expect(primaryExpansions, 1);
  });

  testWidgets('collapsed secondary pane reserves header action space', (
    tester,
  ) async {
    const stageActionKey = ValueKey('stage-action');
    const headerActionKey = ValueKey('header-action');

    await tester.pumpWidget(
      KlpApp(
        showWindowHeader: false,
        home: KlpAppScreen(
          child: SizedBox(
            width: 1000,
            child: KlpWorkbenchWindowHeader(
              titleText: 'Notist',
              primaryPaneWidth: 268,
              primaryVisible: false,
              onTogglePrimary: () {},
              collapseLabel: '收合側邊面板',
              expandLabel: '展開側邊面板',
              secondaryPaneWidth: 300,
              secondaryVisible: false,
              onToggleSecondary: () {},
              collapseSecondaryLabel: '收合檢查器',
              expandSecondaryLabel: '展開檢查器',
              stageTopBar: const KlpStageTopBar(
                tab: SizedBox(width: 80),
                actions: [
                  SizedBox(key: stageActionKey, width: 240, height: 24),
                ],
              ),
              actions: const [
                SizedBox(key: headerActionKey, width: 80, height: 24),
              ],
            ),
          ),
        ),
      ),
    );

    final stageActionRect = tester.getRect(find.byKey(stageActionKey));
    final headerActionRect = tester.getRect(find.byKey(headerActionKey));
    final secondaryToggleRect = tester.getRect(find.bySemanticsLabel('展開檢查器'));
    final windowControlsRect = tester.getRect(find.byType(KlpWindowControls));
    final headerRect = tester.getRect(find.byType(KlpWorkbenchWindowHeader));
    final compact = tester
        .element(find.byType(KlpWorkbenchWindowHeader))
        .klp
        .space
        .compact;

    expect(headerActionRect.left - stageActionRect.right, compact);
    expect(secondaryToggleRect.left - headerActionRect.right, compact);
    expect(windowControlsRect.left - secondaryToggleRect.right, compact);
    expect(secondaryToggleRect.center.dy, headerRect.center.dy);
  });
}
