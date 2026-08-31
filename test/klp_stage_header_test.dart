import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

import 'test_fonts.dart';

void main() {
  setUpAll(loadKlpIconFont);

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

    final firstLine = tester.getRect(find.text('Notist'));
    final secondLine = tester.getRect(find.text('第一份筆記'));
    final hairline = tester.element(find.text('第一份筆記')).klp.space.hairline;
    expect(secondLine.top - firstLine.bottom, lessThanOrEqualTo(hairline / 2));
  });

  testWidgets('keeps stage chrome fully owned by the shared header', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(420, 64));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      const KlpApp(
        showWindowHeader: false,
        home: KlpStageHeader(
          projectName: 'Notist',
          sectionLabel: 'Flow',
          title: '第一份筆記',
          typeLabel: 'FLOW',
        ),
      ),
    );

    expect(find.byType(KlpIconButton), findsNothing);
    final title = tester.getRect(find.text('第一份筆記'));
    final breadcrumb = tester.getRect(find.text('Notist'));
    expect(title.center.dy, greaterThan(breadcrumb.center.dy));

    await expectLater(
      find.byType(KlpStageHeader),
      matchesGoldenFile('goldens/klp_stage_header_actions_light.png'),
    );
  });

  testWidgets('workbench stage owns header and status composition', (
    tester,
  ) async {
    await tester.pumpWidget(
      KlpApp(
        showWindowHeader: false,
        home: SizedBox(
          width: 420,
          height: 240,
          child: KlpStageFrame.workbench(
            projectName: 'Notist',
            sectionLabel: 'Flow',
            title: '第一份筆記',
            typeLabel: 'FLOW',
            content: const SizedBox.expand(),
            statusLeading: 'Saved locally',
            statusTrailing: '100% · 1 frame',
          ),
        ),
      ),
    );

    expect(find.byType(KlpStageHeader), findsOneWidget);
    expect(find.byType(KlpStatusBar), findsOneWidget);
    expect(find.text('Saved locally'), findsOneWidget);
  });
}
