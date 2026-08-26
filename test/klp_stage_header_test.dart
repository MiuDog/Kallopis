import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('renders the shared two-line stage identity', (tester) async {
    await tester.pumpWidget(
      const KlpApp(
        showWindowHeader: false,
        home: KlpAppScreen(
          child: KlpStageHeader(
            projectName: 'Notist',
            sectionLabel: 'Flow',
            title: '第一份筆記',
            typeLabel: 'FLOW',
          ),
        ),
      ),
    );

    expect(find.text('Notist'), findsOneWidget);
    expect(find.text('/'), findsOneWidget);
    expect(find.text('Flow'), findsOneWidget);
    expect(find.text('第一份筆記'), findsOneWidget);
    expect(find.text('FLOW'), findsOneWidget);
  });

  testWidgets('keeps trailing actions inside the shared header', (
    tester,
  ) async {
    const actionKey = ValueKey('stage-action');

    await tester.binding.setSurfaceSize(const Size(420, 64));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      KlpApp(
        showWindowHeader: false,
        home: KlpStageHeader(
          projectName: 'Notist',
          sectionLabel: 'Flow',
          title: '第一份筆記',
          typeLabel: 'FLOW',
          actions: [
            KlpIconButton(
              key: actionKey,
              icon: KlpIcons.edit,
              label: '編輯',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );

    expect(find.bySemanticsLabel('編輯'), findsOneWidget);
    final title = tester.getRect(find.text('第一份筆記'));
    final breadcrumb = tester.getRect(find.text('Notist'));
    final action = tester.getRect(find.byKey(actionKey));

    expect(action.center.dy, closeTo(title.center.dy, 1));
    expect(action.center.dy, greaterThan(breadcrumb.center.dy));

    await expectLater(
      find.byType(KlpStageHeader),
      matchesGoldenFile('goldens/klp_stage_header_actions_light.png'),
    );
  });
}
