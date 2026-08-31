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
        home: KlpAppScreen(
          child: SizedBox(
            key: ValueKey('sidebar-frame'),
            width: 300,
            height: 320,
            child: KlpPrimarySidebarFrame(
              header: SizedBox.shrink(),
              navigation: SizedBox.shrink(),
              explorer: SizedBox(key: ValueKey('sidebar-explorer')),
              footer: KlpStatusIndicator(label: 'Saved locally'),
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
    final padding = tester.widget<Padding>(
      find.descendant(
        of: indicator,
        matching: find.byWidgetPredicate(
          (widget) => widget is Padding && widget.child is Row,
        ),
      ),
    );
    final resolvedPadding = padding.padding.resolve(TextDirection.ltr);

    expect(indicatorRect.top, explorerRect.bottom);
    expect(indicatorRect.bottom, frameRect.bottom);
    expect(indicatorRect.height, theme.space.chromeStatusBar);
    expect(
      resolvedPadding,
      EdgeInsets.symmetric(horizontal: theme.space.compact),
    );
  });
}
