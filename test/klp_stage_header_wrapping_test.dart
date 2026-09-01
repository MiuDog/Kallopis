import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('wrapped stage title expands the header above its minimum', (
    tester,
  ) async {
    const title =
        '這是一個需要依照舞台可用寬度完整自動換行而且不能顯示省略號的文件標題，'
        '即使標題需要三行以上也必須完整保留所有內容';

    await tester.pumpWidget(
      const KlpApp(
        showWindowHeader: false,
        home: SizedBox(
          width: 220,
          height: 400,
          child: KlpStageFrame(
            header: KlpStageHeader(
              projectName: 'Notist',
              sectionLabel: 'Flow',
              title: title,
              typeLabel: 'FLOW',
            ),
            content: SizedBox.expand(),
          ),
        ),
      ),
    );

    final headerFinder = find.byType(KlpStageHeader);
    final minimumHeight = tester.element(headerFinder).klp.space.chromeHeader;
    final headerWidth = tester.getSize(headerFinder).width;
    final titleWidth = tester.getSize(find.text(title)).width;
    expect(tester.getSize(headerFinder).height, greaterThan(minimumHeight));
    expect(titleWidth, greaterThan(headerWidth * 0.5));
    expect(find.text(title), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('wrapped long title automatically uses the available width', (
    tester,
  ) async {
    const title =
        '這是一份很長的舞台標題，必須由 Kallopis 自動使用可用寬度並完整換行，'
        '不要求產品選擇任何排版模式';

    await tester.pumpWidget(
      const KlpApp(
        showWindowHeader: false,
        home: SizedBox(
          width: 280,
          height: 400,
          child: KlpStageFrame(
            header: KlpStageHeader(
              projectName: 'Notist',
              sectionLabel: 'Flow',
              title: title,
              typeLabel: 'FLOW',
            ),
            content: SizedBox.expand(),
          ),
        ),
      ),
    );

    final titleRect = tester.getRect(find.text(title));
    final headerRect = tester.getRect(find.byType(KlpStageHeader));
    expect(titleRect.width, greaterThan(headerRect.width * 0.7));
    expect(find.byType(KlpIconButton), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('short stage title stays on one line automatically', (
    tester,
  ) async {
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

    expect(tester.getSize(find.text('第一份筆記')).height, lessThan(30));
  });
}
