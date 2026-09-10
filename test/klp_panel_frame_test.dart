import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('panel frame resolves semantic tone and header size', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      KlpApp(
        showWindowHeader: false,
        home: KlpPanelFrame(
          tone: KlpPanelTone.stage,
          headerSize: KlpPanelHeaderSize.dock,
          contentScrollController: controller,
          header: const KlpBox.expand(key: ValueKey('panel-header')),
          content: const KlpBox.expand(),
          footer: const KlpBox.expand(key: ValueKey('panel-footer')),
        ),
      ),
    );

    final frame = find.byType(KlpPanelFrame);
    final context = tester.element(frame);
    final decoration =
        tester
                .widget<DecoratedBox>(
                  find
                      .descendant(
                        of: frame,
                        matching: find.byType(DecoratedBox),
                      )
                      .first,
                )
                .decoration
            as BoxDecoration;

    expect(tester.widget<KlpPanelFrame>(frame).tone, KlpPanelTone.stage);
    expect(decoration.color, context.klpColors.stageSurface);
    expect(
      tester.getSize(find.byKey(const ValueKey('panel-header'))).height,
      context.klp.space.chromeTab,
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('panel-footer'))).height,
      context.klp.space.chromeStatusBar,
    );
    expect(find.byType(Scrollbar), findsOneWidget);
  });
}
