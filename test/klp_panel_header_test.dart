import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('panel header 只讓拖曳區包住標題並保留 actions', (tester) async {
    await tester.pumpWidget(
      KlpApp(
        showWindowHeader: false,
        home: KlpPanelFrame(
          content: KlpAppScreen(
            child: KlpPanelHeader(
              title: 'Project',
              label: 'Workspace',
              leading: const KlpText('L'),
              actions: const [KlpText('A', key: ValueKey('panel-action'))],
              dragRegionBuilder: (child) => KlpBox(
                key: const ValueKey('panel-drag-region'),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Project'), findsOneWidget);
    expect(find.text('Workspace'), findsOneWidget);
    expect(find.text('L'), findsOneWidget);
    expect(find.byKey(const ValueKey('panel-action')), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('panel-drag-region')),
        matching: find.byKey(const ValueKey('panel-action')),
      ),
      findsNothing,
    );
  });
}
