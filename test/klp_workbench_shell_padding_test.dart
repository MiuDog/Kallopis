import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  test('pane gap rejects invalid geometry', () {
    Widget buildShell(double paneGap) => KlpWorkbenchShell(
      paneGap: paneGap,
      primary: const SizedBox.shrink(),
      stage: const SizedBox.shrink(),
      secondary: const SizedBox.shrink(),
    );

    expect(() => buildShell(-1), throwsAssertionError);
    expect(() => buildShell(double.nan), throwsAssertionError);
    expect(() => buildShell(double.infinity), throwsAssertionError);
  });

  testWidgets('consumer can remove the workbench top gutter', (tester) async {
    const padding = EdgeInsets.fromLTRB(16, 0, 16, 16);
    const shell = KlpWorkbenchShell(
      padding: padding,
      primary: SizedBox.shrink(),
      stage: SizedBox.shrink(),
      secondary: SizedBox.shrink(),
    );

    await tester.pumpWidget(
      const KlpApp(showWindowHeader: false, home: KlpAppScreen(child: shell)),
    );

    expect(shell.padding, padding);
    expect(tester.takeException(), isNull);
  });

  testWidgets('consumer can keep pane gap equal to outer padding', (
    tester,
  ) async {
    const paneGap = 4.0;
    const shell = KlpWorkbenchShell(
      paneGap: paneGap,
      primary: SizedBox.shrink(),
      stage: SizedBox.shrink(),
      secondary: SizedBox.shrink(),
    );

    await tester.pumpWidget(
      const KlpApp(showWindowHeader: false, home: KlpAppScreen(child: shell)),
    );

    expect(shell.paneGap, paneGap);
    expect(
      tester
          .getSize(find.byKey(const ValueKey('primary-pane-resize-handle')))
          .width,
      paneGap,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('each pane can own four-sided padding without extra gap', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      KlpApp(
        showWindowHeader: false,
        home: KlpAppScreen(
          child: KlpWorkbenchShell(
            padding: EdgeInsets.zero,
            panePadding: const EdgeInsets.all(8),
            primaryWidth: 280,
            secondaryWidth: 300,
            onPrimaryWidthChanged: (_) {},
            onSecondaryWidthChanged: (_) {},
            primary: const SizedBox(key: ValueKey('padded-primary')),
            stage: const SizedBox(key: ValueKey('padded-stage')),
            secondary: const SizedBox(key: ValueKey('padded-secondary')),
          ),
        ),
      ),
    );

    final shellRect = tester.getRect(find.byType(KlpWorkbenchShell));
    final primaryRect = tester.getRect(
      find.byKey(const ValueKey('padded-primary')),
    );
    final stageRect = tester.getRect(
      find.byKey(const ValueKey('padded-stage')),
    );
    final secondaryRect = tester.getRect(
      find.byKey(const ValueKey('padded-secondary')),
    );

    expect(primaryRect.left - shellRect.left, 8);
    expect(primaryRect.top - shellRect.top, 8);
    expect(shellRect.bottom - primaryRect.bottom, 8);
    expect(stageRect.left - primaryRect.right, 16);
    expect(secondaryRect.left - stageRect.right, 16);
    expect(shellRect.right - secondaryRect.right, 8);
    expect(
      tester
          .getSize(find.byKey(const ValueKey('primary-pane-resize-handle')))
          .width,
      tester.element(find.byType(KlpWorkbenchShell)).klp.space.compact,
    );
    expect(
      tester
          .getSize(find.byKey(const ValueKey('secondary-pane-resize-handle')))
          .width,
      tester.element(find.byType(KlpWorkbenchShell)).klp.space.compact,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'default workbench starts panels directly below full-width header',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 720);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        KlpApp(
          title: 'Kallopis',
          appIcon: const Icon(Icons.edit, key: ValueKey('app-icon')),
          home: KlpAppScreen(
            child: KlpWorkbenchShell(
              onPrimaryWidthChanged: (_) {},
              onSecondaryWidthChanged: (_) {},
              primary: const SizedBox(key: ValueKey('primary')),
              stage: const SizedBox(key: ValueKey('stage')),
              secondary: const SizedBox(key: ValueKey('secondary')),
            ),
          ),
        ),
      );

      final shellFinder = find.byType(KlpWorkbenchShell);
      final compact = tester.element(shellFinder).klp.space.compact;
      final headerRect = tester.getRect(find.byType(KlpWindowHeader));
      final shellRect = tester.getRect(shellFinder);
      final primaryRect = tester.getRect(find.byKey(const ValueKey('primary')));
      final stageRect = tester.getRect(find.byKey(const ValueKey('stage')));
      final secondaryRect = tester.getRect(
        find.byKey(const ValueKey('secondary')),
      );

      expect(headerRect.left, shellRect.left);
      expect(headerRect.right, shellRect.right);
      expect(primaryRect.left - shellRect.left, compact * 2);
      expect(primaryRect.top - shellRect.top, compact * 2);
      expect(shellRect.bottom - primaryRect.bottom, compact * 2);
      expect(stageRect.left - primaryRect.right, compact * 2);
      expect(secondaryRect.left - stageRect.right, compact * 2);
      expect(shellRect.right - secondaryRect.right, compact * 2);

      final primaryHandleRect = tester.getRect(
        find.byKey(const ValueKey('primary-pane-resize-handle')),
      );
      final secondaryHandleRect = tester.getRect(
        find.byKey(const ValueKey('secondary-pane-resize-handle')),
      );
      expect(
        primaryHandleRect.center.dx,
        (primaryRect.right + stageRect.left) / 2,
      );
      expect(
        secondaryHandleRect.center.dx,
        (stageRect.right + secondaryRect.left) / 2,
      );
    },
  );

  testWidgets('sidebar and stage contents use compact padding by default', (
    tester,
  ) async {
    await tester.pumpWidget(
      const KlpApp(
        showWindowHeader: false,
        home: KlpAppScreen(
          child: Row(
            children: [
              SizedBox(
                key: ValueKey('sidebar-box'),
                width: 300,
                height: 320,
                child: KlpSidebarFrame(
                  header: SizedBox.shrink(),
                  content: SizedBox(key: ValueKey('sidebar-content')),
                ),
              ),
              SizedBox(
                key: ValueKey('stage-box'),
                width: 300,
                height: 320,
                child: KlpStageFrame(
                  header: SizedBox.shrink(),
                  content: SizedBox(key: ValueKey('stage-content')),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final sidebarBox = tester.getRect(
      find.byKey(const ValueKey('sidebar-box')),
    );
    final sidebarContent = tester.getRect(
      find.byKey(const ValueKey('sidebar-content')),
    );
    final stageBox = tester.getRect(find.byKey(const ValueKey('stage-box')));
    final stageContent = tester.getRect(
      find.byKey(const ValueKey('stage-content')),
    );
    final context = tester.element(find.byKey(const ValueKey('stage-content')));
    final compact = context.klp.space.compact;
    final headerHeight = context.klp.space.chromeHeader;

    expect(sidebarContent.left - sidebarBox.left, compact);
    expect(sidebarBox.right - sidebarContent.right, compact);
    expect(sidebarContent.top - sidebarBox.top, headerHeight + compact);
    expect(sidebarBox.bottom - sidebarContent.bottom, compact);
    expect(stageContent.left - stageBox.left, compact);
    expect(stageBox.right - stageContent.right, compact);
    expect(stageContent.top - stageBox.top, headerHeight + compact);
    expect(stageBox.bottom - stageContent.bottom, compact);
  });
}
