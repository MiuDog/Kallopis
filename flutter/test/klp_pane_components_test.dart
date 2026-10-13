import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets(
    'responsive pane coordinator resolves the standard theme breakpoint',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1200, 800);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          theme: buildKlpTheme(Brightness.light),
          home: const Center(
            child: SizedBox(
              width: 959,
              child: KlpResponsivePaneCoordinator(
                wide: Text('Wide pane'),
                compact: Text('Compact pane'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Compact pane'), findsOneWidget);
      expect(find.text('Wide pane'), findsNothing);

      await tester.pumpWidget(
        MaterialApp(
          theme: buildKlpTheme(Brightness.light),
          home: const Center(
            child: SizedBox(
              width: 960,
              child: KlpResponsivePaneCoordinator(
                wide: Text('Wide pane'),
                compact: Text('Compact pane'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Wide pane'), findsOneWidget);
      expect(find.text('Compact pane'), findsNothing);
    },
  );

  testWidgets(
    'pane collapse control exposes expansion semantics and dispatches toggle',
    (tester) async {
      final semantics = tester.ensureSemantics();
      var presses = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: buildKlpTheme(Brightness.light),
          home: Scaffold(
            body: KlpPaneCollapseControl(
              label: 'Toggle pane',
              collapsed: false,
              onToggle: () => presses += 1,
            ),
          ),
        ),
      );

      final node = tester.getSemantics(find.bySemanticsLabel('Toggle pane'));
      expect(node.flagsCollection.isExpanded, Tristate.isTrue);
      await tester.tap(find.byType(KlpPaneCollapseControl));
      expect(presses, 1);
      semantics.dispose();
    },
  );
}
