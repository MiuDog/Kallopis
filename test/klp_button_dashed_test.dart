import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('dashed tone keeps a transparent fill and latent border', (
    tester,
  ) async {
    await tester.pumpWidget(
      KlpApp(
        showWindowHeader: false,
        home: KlpAppScreen(
          child: KlpButton(
            leading: const KlpIcon(KlpIcons.edit),
            label: 'Edit',
            tone: KlpButtonTone.dashed,
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.byType(KlpDashedBorder), findsOneWidget);
    expect(find.byType(KlpIcon), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);
  });
}
