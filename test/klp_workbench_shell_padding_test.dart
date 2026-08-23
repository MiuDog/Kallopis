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

  testWidgets(
    'default workbench starts panels directly below full-width header',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 720);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const KlpApp(
          title: 'Kallopis',
          appIcon: Icon(Icons.edit, key: ValueKey('app-icon')),
          home: KlpAppScreen(
            child: KlpWorkbenchShell(
              primary: SizedBox(key: ValueKey('primary')),
              stage: SizedBox(key: ValueKey('stage')),
              secondary: SizedBox(key: ValueKey('secondary')),
            ),
          ),
        ),
      );

      final shellFinder = find.byType(KlpWorkbenchShell);
      final compact = tester.element(shellFinder).klp.space.compact;
      final headerRect = tester.getRect(find.byType(KlpWindowHeader));
      final appIconRect = tester.getRect(
        find.byKey(const ValueKey('app-icon')),
      );
      final shellRect = tester.getRect(shellFinder);
      final primaryRect = tester.getRect(find.byKey(const ValueKey('primary')));
      final stageRect = tester.getRect(find.byKey(const ValueKey('stage')));
      final secondaryRect = tester.getRect(
        find.byKey(const ValueKey('secondary')),
      );

      expect(headerRect.left, shellRect.left);
      expect(headerRect.right, shellRect.right);
      expect(appIconRect.left, primaryRect.left);
      expect(primaryRect.left - shellRect.left, compact);
      expect(primaryRect.top, shellRect.top);
      expect(shellRect.bottom - primaryRect.bottom, compact);
      expect(stageRect.left - primaryRect.right, compact);
      expect(secondaryRect.left - stageRect.right, compact);
      expect(shellRect.right - secondaryRect.right, compact);
    },
  );

  testWidgets('sidebar and stage contents use base padding by default', (
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
    final base = context.klp.space.base;
    final headerHeight = context.klp.space.chromeHeader;

    expect(sidebarContent.left - sidebarBox.left, base);
    expect(sidebarBox.right - sidebarContent.right, base);
    expect(sidebarContent.top - sidebarBox.top, headerHeight + base);
    expect(sidebarBox.bottom - sidebarContent.bottom, base);
    expect(stageContent.left - stageBox.left, base);
    expect(stageBox.right - stageContent.right, base);
    expect(stageContent.top - stageBox.top, headerHeight + base);
    expect(stageBox.bottom - stageContent.bottom, base);
  });
}
