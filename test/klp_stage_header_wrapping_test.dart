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
              wrapTitle: true,
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

  testWidgets('wrapped long title keeps its width beside trailing actions', (
    tester,
  ) async {
    const title =
        '這是一份很長的舞台標題，需要在保留右側操作按鈕的同時使用其餘全部寬度，'
        '並且讓操作按鈕持續對齊完整標題列的中心';
    const actionKey = ValueKey('stage-action');

    await tester.pumpWidget(
      KlpApp(
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
              wrapTitle: true,
              actions: [
                KlpIconButton(
                  key: actionKey,
                  icon: KlpIcons.edit,
                  label: '編輯',
                  onPressed: () {},
                ),
              ],
            ),
            content: const SizedBox.expand(),
          ),
        ),
      ),
    );

    final titleRect = tester.getRect(find.text(title));
    final actionRect = tester.getRect(find.byKey(actionKey));

    expect(titleRect.width, greaterThan(100));
    expect(titleRect.right, lessThan(actionRect.left));
    expect(actionRect.center.dy, closeTo(titleRect.center.dy, 1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('single-line stage title remains the default', (tester) async {
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

    final header = tester.widget<KlpStageHeader>(find.byType(KlpStageHeader));
    expect(header.wrapTitle, isFalse);
  });
}
