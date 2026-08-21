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
}
