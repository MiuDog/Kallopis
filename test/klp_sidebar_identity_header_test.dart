import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('renders workspace identity with Klp-owned chrome', (
    tester,
  ) async {
    await tester.pumpWidget(
      const KlpApp(
        showWindowHeader: false,
        home: KlpAppScreen(
          child: KlpSidebarIdentityHeader(
            icon: KlpIcons.folder,
            title: 'Flows',
            trailing: KlpAvatar(label: 'C', semanticLabel: 'Chia-Yu'),
          ),
        ),
      ),
    );

    expect(find.text('Flows'), findsOneWidget);
    expect(find.byType(KlpIcon), findsOneWidget);
    expect(find.byType(KlpAvatar), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('Chia-Yu')), findsOneWidget);
  });
}
