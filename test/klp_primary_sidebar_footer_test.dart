import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('primary sidebar footer adds no vertical padding', (
    tester,
  ) async {
    await tester.pumpWidget(
      const KlpApp(
        showWindowHeader: false,
        home: KlpPanelFrame(
          content: KlpAppScreen(
            child: SizedBox(
              key: ValueKey('sidebar-frame'),
              width: 300,
              height: 320,
              child: KlpPrimarySidebarFrame(
                header: SizedBox.shrink(),
                navigation: SizedBox.shrink(),
                explorer: SizedBox(key: ValueKey('sidebar-explorer')),
                status: KlpStatusItemData(label: 'Saved locally'),
              ),
            ),
          ),
        ),
      ),
    );

    final frameRect = tester.getRect(
      find.byKey(const ValueKey('sidebar-frame')),
    );
    final explorerRect = tester.getRect(
      find.byKey(const ValueKey('sidebar-explorer')),
    );
    final indicator = find.byType(KlpStatusIndicator);
    final indicatorRect = tester.getRect(indicator);
    final theme = tester.element(indicator).klp;

    expect(indicatorRect.top, explorerRect.bottom);
    expect(indicatorRect.bottom, frameRect.bottom - theme.space.dockMargin);
    expect(indicatorRect.height, theme.space.chromeStatusBar);
    expect(indicatorRect.left, explorerRect.left);
    expect(indicatorRect.right, explorerRect.right);
  });

  testWidgets('primary sidebar resolves typed content and header spacing', (
    tester,
  ) async {
    await tester.pumpWidget(
      const KlpApp(
        showWindowHeader: false,
        home: KlpPanelFrame(
          content: KlpAppScreen(
            child: SizedBox(
              key: ValueKey('typed-sidebar-frame'),
              width: 300,
              height: 320,
              child: KlpPrimarySidebarFrame(
                contentInset: KlpSidebarInset.content,
                headerInset: KlpPrimarySidebarHeaderInset.none,
                headerNavigationGap: KlpSpaceSize.tight,
                header: SizedBox(
                  key: ValueKey('typed-sidebar-header'),
                  height: 20,
                ),
                navigation: SizedBox(
                  key: ValueKey('typed-sidebar-navigation'),
                  height: 24,
                ),
                explorer: SizedBox(key: ValueKey('typed-sidebar-explorer')),
              ),
            ),
          ),
        ),
      ),
    );

    final frame = find.byKey(const ValueKey('typed-sidebar-frame'));
    final header = find.byKey(const ValueKey('typed-sidebar-header'));
    final navigation = find.byKey(const ValueKey('typed-sidebar-navigation'));
    final explorer = find.byKey(const ValueKey('typed-sidebar-explorer'));
    final frameRect = tester.getRect(frame);
    final headerRect = tester.getRect(header);
    final navigationRect = tester.getRect(navigation);
    final explorerRect = tester.getRect(explorer);
    final theme = tester.element(frame).klp;

    expect(
      headerRect.left,
      frameRect.left + theme.space.dockMargin + theme.space.contentInset,
    );
    expect(headerRect.top, frameRect.top + theme.space.dockMargin);
    expect(navigationRect.top, headerRect.bottom + theme.space.tight);
    expect(explorerRect.top, navigationRect.bottom);
  });
}
