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
    await tester.pumpWidget(
      KlpApp(
        showWindowHeader: false,
        home: KlpAppScreen(
          child: KlpStageHeader(
            projectName: 'Notist',
            sectionLabel: 'Flow',
            title: '第一份筆記',
            typeLabel: 'FLOW',
            actions: [
              KlpIconButton(icon: KlpIcons.edit, label: '編輯', onPressed: () {}),
            ],
          ),
        ),
      ),
    );

    expect(find.bySemanticsLabel('編輯'), findsOneWidget);
  });
}
