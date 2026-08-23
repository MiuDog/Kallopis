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
    expect(tester.getSize(headerFinder).height, greaterThan(minimumHeight));
    expect(find.text(title), findsOneWidget);
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
