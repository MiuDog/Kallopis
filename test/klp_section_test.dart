import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('section 以 Kallopis 排版標題、標籤、動作與內容', (tester) async {
    await tester.pumpWidget(
      const KlpApp(
        showWindowHeader: false,
        home: KlpPanelFrame(
          content: KlpAppScreen(
            child: KlpSection(
              title: 'Overview',
              label: 'draft',
              trailing: KlpText('Action'),
              child: KlpText('Body'),
            ),
          ),
        ),
      ),
    );

    final section = find.byType(KlpSection);
    expect(
      find.descendant(of: section, matching: find.byType(KlpColumn)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: section, matching: find.byType(KlpRow)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: section, matching: find.byType(KlpWrap)),
      findsOneWidget,
    );
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('DRAFT'), findsOneWidget);
    expect(find.text('Action'), findsOneWidget);
    expect(find.text('Body'), findsOneWidget);
  });
}
