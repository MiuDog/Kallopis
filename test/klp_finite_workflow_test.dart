import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

import 'style_fixture.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
    MaterialApp(
      theme: buildKlpTheme(Brightness.light),
      home: Scaffold(body: SingleChildScrollView(child: child)),
    ),
  );

  testWidgets(
    'preview tree exposes caller-provided semantics and can be disabled',
    (tester) async {
      final semantics = tester.ensureSemantics();
      var selected = '';
      await pump(
        tester,
        KlpPreviewTree(
          label: 'Project preview',
          enabled: false,
          nodes: const [
            KlpPreviewTreeNode(
              id: 'home',
              label: 'Home',
              accessibilityLabel: 'Preview page Home',
            ),
          ],
          onSelected: (value) => selected = value,
        ),
      );

      expect(
        find.bySemanticsLabel(RegExp('Preview page Home')),
        findsOneWidget,
      );
      await tester.tap(find.text('Home'), warnIfMissed: false);
      expect(selected, isEmpty);
      semantics.dispose();
    },
  );

  testWidgets('preview tree forwards selection while enabled', (tester) async {
    var selected = '';
    await pump(
      tester,
      KlpPreviewTree(
        label: 'Project preview',
        nodes: const [
          KlpPreviewTreeNode(
            id: 'home',
            label: 'Home',
            accessibilityLabel: 'Preview page Home',
          ),
        ],
        onSelected: (value) => selected = value,
      ),
    );

    await tester.tap(find.text('Home'));
    expect(selected, 'home');
  });

  testWidgets(
    'publication overlay paints last and blocks preview hit testing',
    (tester) async {
      var presses = 0;
      Widget subject(bool visible) => SizedBox(
        height: 120,
        child: KlpPublicationProgressOverlay(
          visible: visible,
          progress: const KlpWorkflowProgress(
            stages: [
              KlpWorkflowStageData(
                label: 'Publish',
                statusLabel: 'Active',
                complete: false,
                active: true,
              ),
            ],
          ),
          child: KlpButton(
            label: 'Preview action',
            onPressed: () => presses += 1,
          ),
        ),
      );

      await pump(tester, subject(true));
      await tester.tap(
        find.widgetWithText(KlpButton, 'Preview action'),
        warnIfMissed: false,
      );
      expect(presses, 0);

      await pump(tester, subject(false));
      await tester.tap(find.widgetWithText(KlpButton, 'Preview action'));
      expect(presses, 1);
    },
  );

  for (final style in [KlpVisualStyle.defaultStyle, contrastingStyle]) {
    testWidgets('workflow surfaces resolve ${style.name} semantic tokens', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildKlpTheme(Brightness.light, style: style),
          home: Scaffold(
            body: ListView(
              children: const [
                KlpWorkflowStateSurface(
                  state: KlpWorkflowState.ready,
                  title: 'Proposal',
                  message: 'Ready',
                  statusLabel: 'Ready',
                ),
                SizedBox(
                  height: 120,
                  child: KlpCanvasViewport(child: KlpText('Canvas')),
                ),
              ],
            ),
          ),
        ),
      );

      final contentBox = tester.widget<KlpBox>(
        find
            .descendant(
              of: find.byType(KlpWorkflowStateSurface),
              matching: find.byType(KlpBox),
            )
            .first,
      );
      expect(contentBox.paddingSize, KlpSpaceSize.base);
      final canvas = tester.widget<ColoredBox>(
        find.descendant(
          of: find.byType(KlpCanvasViewport),
          matching: find.byType(ColoredBox),
        ),
      );
      expect(canvas.color, style.colors.stageSurface);
      expect(tester.takeException(), isNull);
    });
  }
}
