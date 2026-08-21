import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
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
}
