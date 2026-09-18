import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('stage top bar renders tab and action controls', (
    tester,
  ) async {
    await tester.pumpWidget(
      KlpApp(
        showWindowHeader: false,
        home: KlpPanelFrame(
          content: KlpAppScreen(
            child: SizedBox(
              width: 600,
              height: 48,
              child: KlpStageTopBar(
                tab: const KlpStageTab(label: 'notes.md'),
                actions: [
                  KlpButton(
                    key: const ValueKey('action'),
                    leading: const KlpIcon(KlpIcons.edit),
                    label: 'Edit',
                    tone: KlpButtonTone.dashed,
                    size: KlpControlSize.xs,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(KlpStageTopBar), findsOneWidget);
    expect(find.byType(KlpStageTab), findsOneWidget);
    expect(find.byKey(const ValueKey('action')), findsOneWidget);
  });

  testWidgets('uses a lower end corner to connect the tab to the stage', (
    tester,
  ) async {
    await tester.pumpWidget(
      const KlpApp(
        showWindowHeader: false,
        home: KlpPanelFrame(
          content: KlpAppScreen(child: KlpStageTab(label: 'notes.md')),
        ),
      ),
    );

    final decoration =
        tester
                .widgetList<DecoratedBox>(
                  find.descendant(
                    of: find.byType(KlpStageTab),
                    matching: find.byType(DecoratedBox),
                  ),
                )
                .first
                .decoration
            as BoxDecoration;
    final radius = decoration.borderRadius!.resolve(TextDirection.ltr);

    expect(radius.topLeft.x, greaterThan(0));
    expect(radius.topRight.x, greaterThan(0));
    expect(
      radius.topLeft.x,
      tester.element(find.byType(KlpStageTab)).klp.buttonRadius,
    );
    expect(radius.bottomLeft, Radius.zero);
    expect(
      radius.bottomRight.x,
      tester.element(find.byType(KlpStageTab)).klp.shape.panel,
    );

    final text = tester.widget<Text>(
      find.descendant(
        of: find.byType(KlpStageTab),
        matching: find.text('notes.md'),
      ),
    );
    expect(text.style?.decoration, TextDecoration.none);
  });
}
