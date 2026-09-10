import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('status bar 在窄寬度只保留 leading 狀態', (tester) async {
    await tester.pumpWidget(
      const KlpApp(
        showWindowHeader: false,
        home: KlpPanelFrame(
          content: KlpAppScreen(
            child: KlpAlign(
              alignment: Alignment.topLeft,
              child: KlpBox(
                width: 120,
                child: KlpStatusBar(
                  data: KlpStatusBarData(
                    leading: [KlpStatusItemData(label: 'Local')],
                    trailing: [KlpStatusItemData(label: 'Details')],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Local'), findsOneWidget);
    expect(find.text('Details'), findsNothing);
    expect(find.byType(KlpLayoutBuilder), findsOneWidget);
  });
}
