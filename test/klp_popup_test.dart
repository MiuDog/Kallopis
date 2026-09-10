import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets(
    'popup background preserves the window header interaction range',
    (tester) async {
      var dismissCount = 0;
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        KlpApp(
          home: const KlpPanelFrame(content: SizedBox.expand()),
          popup: KlpPopupBackground(
            onDismiss: () => dismissCount += 1,
            child: const KlpPopupPanel(
              kind: KlpPopupPanelKind.standard,
              child: SizedBox(key: ValueKey('popup-content')),
            ),
          ),
        ),
      );

      await tester.tapAt(const Offset(8, 8));
      await tester.pump(const Duration(milliseconds: 50));
      expect(dismissCount, 0);

      await tester.tapAt(const Offset(20, 200));
      expect(dismissCount, 1);
    },
  );

  testWidgets('large popup panel fills a constrained popup region', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: KlpPopupInteractionScope(
          topInset: 40,
          child: KlpPopupBackground(
            onDismiss: () {},
            child: const KlpPopupPanel(
              kind: KlpPopupPanelKind.large,
              child: SizedBox(key: ValueKey('large-popup-content')),
            ),
          ),
        ),
      ),
    );

    final panelRect = tester.getRect(find.byType(KlpPopupPanel));
    expect(panelRect.size, const Size(800, 560));
  });

  testWidgets('standard popup panel keeps its fixed size', (tester) async {
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: const SizedBox(
          width: 1280,
          height: 1000,
          child: Center(
            child: KlpPopupPanel(
              kind: KlpPopupPanelKind.standard,
              child: SizedBox(),
            ),
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(KlpPopupPanel)), const Size(600, 816));
  });
}
