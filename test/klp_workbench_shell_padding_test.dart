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
          appIcon: const KlpIcon(KlpIcons.edit, key: ValueKey('app-icon')),
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
      expect(primaryRect.left - shellRect.left, compact / 2);
      expect(primaryRect.top - shellRect.top, compact / 2);
      expect(shellRect.bottom - primaryRect.bottom, compact / 2);
      expect(stageRect.left - primaryRect.right, compact);
      expect(secondaryRect.left - stageRect.right, compact);
      expect(shellRect.right - secondaryRect.right, compact / 2);

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

  testWidgets('resize drag accumulates every pointer update in one frame', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    double? committedWidth;
    var primaryBuilds = 0;
    final primary = Builder(
      builder: (_) {
        primaryBuilds += 1;
        return const SizedBox.shrink();
      },
    );
    await tester.pumpWidget(
      KlpApp(
        showWindowHeader: false,
        home: KlpAppScreen(
          child: KlpWorkbenchShell(
            primaryWidth: 280,
            onPrimaryWidthChangeEnd: (value) => committedWidth = value,
            primary: primary,
            stage: const SizedBox.shrink(),
            secondary: const SizedBox.shrink(),
          ),
        ),
      ),
    );

    final handle = find.byKey(const ValueKey('primary-pane-resize-handle'));
    final detector = tester.widget<GestureDetector>(
      find.descendant(of: handle, matching: find.byType(GestureDetector)),
    );
    final initialCenter = tester.getRect(handle).center.dx;

    detector.onHorizontalDragStart!(DragStartDetails());
    detector.onHorizontalDragUpdate!(
      DragUpdateDetails(
        globalPosition: Offset.zero,
        delta: const Offset(12, 0),
        primaryDelta: 12,
      ),
    );
    detector.onHorizontalDragUpdate!(
      DragUpdateDetails(
        globalPosition: Offset.zero,
        delta: const Offset(18, 0),
        primaryDelta: 18,
      ),
    );

    expect(committedWidth, isNull);
    await tester.pump();
    expect(tester.getRect(handle).center.dx, initialCenter + 30);
    expect(primaryBuilds, 1);

    detector.onHorizontalDragEnd!(DragEndDetails());
    expect(committedWidth, 310);
  });

  testWidgets('product pane constraints limit preview and committed width', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    double? previewWidth;
    double? committedWidth;
    await tester.pumpWidget(
      KlpApp(
        showWindowHeader: false,
        home: KlpAppScreen(
          child: KlpWorkbenchShell(
            primaryWidth: 280,
            primaryWidthConstraints: const KlpPaneWidthConstraints(
              minWidth: 220,
              maxWidth: 380,
            ),
            onPrimaryWidthChanged: (value) => previewWidth = value,
            onPrimaryWidthChangeEnd: (value) => committedWidth = value,
            primary: const SizedBox.shrink(),
            stage: const SizedBox.shrink(),
            secondary: const SizedBox.shrink(),
          ),
        ),
      ),
    );

    final handle = find.byKey(const ValueKey('primary-pane-resize-handle'));
    final detector = tester.widget<GestureDetector>(
      find.descendant(of: handle, matching: find.byType(GestureDetector)),
    );
    final initialCenter = tester.getRect(handle).center.dx;

    detector.onHorizontalDragStart!(DragStartDetails());
    detector.onHorizontalDragUpdate!(
      DragUpdateDetails(
        globalPosition: Offset.zero,
        delta: const Offset(-100, 0),
        primaryDelta: -100,
      ),
    );
    await tester.pump();

    expect(previewWidth, 220);
    expect(tester.getRect(handle).center.dx, initialCenter - 60);
    detector.onHorizontalDragEnd!(DragEndDetails());
    expect(committedWidth, 220);
  });

  testWidgets('sidebar and stage frames only apply horizontal padding', (
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
    expect(sidebarContent.top, sidebarBox.top);
    expect(sidebarContent.bottom, sidebarBox.bottom);
    expect(stageContent.left - stageBox.left, compact);
    expect(stageBox.right - stageContent.right, compact);
    expect(stageContent.top - stageBox.top, headerHeight);
    expect(stageContent.bottom, stageBox.bottom);
  });

  testWidgets('sidebar keeps footer flush without vertical padding', (
    tester,
  ) async {
    await tester.pumpWidget(
      const KlpApp(
        showWindowHeader: false,
        home: KlpAppScreen(
          child: SizedBox(
            key: ValueKey('sidebar-regions'),
            width: 300,
            height: 320,
            child: KlpPrimarySidebarFrame(
              header: SizedBox(key: ValueKey('sidebar-header')),
              navigation: SizedBox(key: ValueKey('sidebar-navigation')),
              explorer: SizedBox(key: ValueKey('sidebar-body')),
              footer: SizedBox(key: ValueKey('sidebar-footer')),
            ),
          ),
        ),
      ),
    );

    final frame = tester.getRect(find.byKey(const ValueKey('sidebar-regions')));
    final header = tester.getRect(find.byKey(const ValueKey('sidebar-header')));
    final navigation = tester.getRect(
      find.byKey(const ValueKey('sidebar-navigation')),
    );
    final content = tester.getRect(find.byKey(const ValueKey('sidebar-body')));
    final footer = tester.getRect(find.byKey(const ValueKey('sidebar-footer')));
    final compact = tester
        .element(find.byKey(const ValueKey('sidebar-regions')))
        .klp
        .space
        .compact;

    expect(header.left - frame.left, compact);
    expect(frame.right - header.right, compact);
    expect(header.top - frame.top, compact);
    expect(content.left - frame.left, compact);
    expect(frame.right - content.right, compact);
    expect(navigation.top, header.bottom);
    expect(content.top - navigation.bottom, compact);
    expect(footer.top, content.bottom);
    expect(footer.left - frame.left, compact);
    expect(frame.right - footer.right, compact);
    expect(footer.bottom, frame.bottom);
  });

  testWidgets('panel and stage apply regional padding rules', (tester) async {
    await tester.pumpWidget(
      const KlpApp(
        showWindowHeader: false,
        home: KlpAppScreen(
          child: Row(
            children: [
              SizedBox(
                key: ValueKey('panel-box'),
                width: 300,
                height: 320,
                child: KlpPanelFrame(
                  header: SizedBox(key: ValueKey('panel-header')),
                  content: SizedBox(key: ValueKey('panel-content')),
                  footer: SizedBox(key: ValueKey('panel-footer')),
                ),
              ),
              SizedBox(
                key: ValueKey('stage-frame-box'),
                width: 300,
                height: 320,
                child: KlpStageFrame(
                  header: SizedBox(key: ValueKey('stage-header')),
                  content: SizedBox(key: ValueKey('stage-body')),
                  status: SizedBox(key: ValueKey('stage-status')),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final compact = tester
        .element(find.byKey(const ValueKey('panel-box')))
        .klp
        .space
        .compact;
    for (final pair in const [
      ('panel-box', 'panel-header'),
      ('panel-box', 'panel-content'),
      ('panel-box', 'panel-footer'),
      ('stage-frame-box', 'stage-header'),
      ('stage-frame-box', 'stage-body'),
    ]) {
      final frame = tester.getRect(find.byKey(ValueKey(pair.$1)));
      final region = tester.getRect(find.byKey(ValueKey(pair.$2)));
      expect(region.left - frame.left, compact, reason: pair.$2);
      expect(frame.right - region.right, compact, reason: pair.$2);
    }

    final panel = tester.getRect(find.byKey(const ValueKey('panel-box')));
    final panelHeader = tester.getRect(
      find.byKey(const ValueKey('panel-header')),
    );
    final panelFooter = tester.getRect(
      find.byKey(const ValueKey('panel-footer')),
    );
    expect(panelHeader.top, panel.top);
    expect(panelFooter.bottom, panel.bottom);

    final stage = tester.getRect(find.byKey(const ValueKey('stage-frame-box')));
    final stageHeader = tester.getRect(
      find.byKey(const ValueKey('stage-header')),
    );
    final stageStatus = tester.getRect(
      find.byKey(const ValueKey('stage-status')),
    );
    expect(stageHeader.top, stage.top);
    expect(stageStatus.left - stage.left, compact);
    expect(stage.right - stageStatus.right, compact);
    expect(stageStatus.bottom, stage.bottom);
    final stageBody = tester.getRect(find.byKey(const ValueKey('stage-body')));
    expect(stageStatus.top, stageBody.bottom);
  });

	testWidgets('stage and panel headers own their axis-specific compact padding', (
    tester,
  ) async {
    await tester.pumpWidget(
      const KlpApp(
        showWindowHeader: false,
        home: KlpAppScreen(
          child: Column(
            children: [
              KlpPanelHeader(title: 'Inspector'),
              KlpStageHeader(
                projectName: 'Project',
                sectionLabel: 'Design',
                title: 'Canvas',
                typeLabel: 'FRAME',
              ),
            ],
          ),
        ),
      ),
    );

    EdgeInsets resolvedPadding(Finder owner) {
      final padding = tester.widget<Padding>(
        find.descendant(of: owner, matching: find.byType(Padding)).first,
      );
      return padding.padding.resolve(TextDirection.ltr);
    }

    final compact = tester
        .element(find.byType(KlpPanelHeader))
        .klp
        .space
        .compact;
		final panelPadding = resolvedPadding(find.byType(KlpPanelHeader));
		expect(panelPadding.left, compact);
		expect(panelPadding.top, 0);
		expect(panelPadding.right, compact);
		expect(panelPadding.bottom, 0);

		final stagePadding = resolvedPadding(find.byType(KlpStageHeader));
		expect(stagePadding.left, 0);
		expect(stagePadding.top, compact);
		expect(stagePadding.right, 0);
		expect(stagePadding.bottom, compact);
  });
}
