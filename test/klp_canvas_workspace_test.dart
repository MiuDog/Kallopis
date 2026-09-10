import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) {
    return tester.pumpWidget(
      MaterialApp(theme: buildKlpTheme(Brightness.light), home: child),
    );
  }

  testWidgets('canvas viewport 保留 controller 與平移縮放政策', (tester) async {
    final controller = TransformationController();
    addTearDown(controller.dispose);
    await pump(
      tester,
      KlpCanvasViewport(
        transformationController: controller,
        panEnabled: false,
        scaleEnabled: false,
        child: const KlpText('Canvas'),
      ),
    );

    final viewer = tester.widget<InteractiveViewer>(
      find.descendant(
        of: find.byType(KlpCanvasViewport),
        matching: find.byType(InteractiveViewer),
      ),
    );
    expect(viewer.transformationController, same(controller));
    expect(viewer.panEnabled, isFalse);
    expect(viewer.scaleEnabled, isFalse);
  });

  testWidgets('selection overlay 只在選取且要求時呈現四個 handles', (tester) async {
    await pump(
      tester,
      const KlpCanvasSelectionOverlay(
        showHandles: true,
        child: KlpText('Selected node'),
      ),
    );

    expect(
      find.descendant(
        of: find.byType(KlpCanvasSelectionOverlay),
        matching: find.byType(Container),
      ),
      findsNWidgets(4),
    );

    await pump(
      tester,
      const KlpCanvasSelectionOverlay(
        selected: false,
        showHandles: true,
        child: KlpText('Selected node'),
      ),
    );
    expect(find.byType(Container), findsNothing);
  });

  testWidgets('toolbar 與 drop intent 保留動作和 live-region 語意', (tester) async {
    var pressed = false;
    await pump(
      tester,
      KlpColumn(
        children: [
          KlpCanvasToolbar(
            actions: [
              KlpButton(label: 'Insert', onPressed: () => pressed = true),
            ],
          ),
          const KlpCanvasDropIntent(
            label: 'Insert after',
            child: KlpText('Drop target'),
          ),
        ],
      ),
    );

    await tester.tap(find.text('Insert'));
    expect(pressed, isTrue);
    expect(find.bySemanticsLabel(RegExp('Insert after')), findsOneWidget);
  });

  testWidgets('layout lens 與 flow 元件只投影呼叫端資料和事件', (tester) async {
    var nodePressed = false;
    var recovered = false;
    var minimapPressed = false;
    await pump(
      tester,
      KlpColumn(
        children: [
          const KlpLayoutLens(
            label: 'Layout lens',
            diagnostics: [
              KlpLayoutDiagnosticData(label: 'Width', value: 'Fill'),
            ],
          ),
          KlpFlowNodeCard(
            title: 'Confirm order',
            typeLabel: 'Decision',
            selected: true,
            onPressed: () => nodePressed = true,
            child: const KlpText('Success / Failure'),
          ),
          KlpFlowValidationPanel(
            title: 'Flow validation',
            issues: const [
              ('Failure path needs recovery', KlpFeedbackTone.warning),
            ],
            recoveryActions: [
              KlpButton(label: 'Recover', onPressed: () => recovered = true),
            ],
          ),
          KlpCanvasMinimap(
            label: 'Flow minimap',
            onPressed: () => minimapPressed = true,
            child: const KlpText('Overview'),
          ),
        ],
      ),
    );

    expect(find.text('Width'), findsOneWidget);
    expect(find.text('FILL'), findsOneWidget);
    expect(find.text('Failure path needs recovery'), findsOneWidget);
    await tester.tap(find.text('Confirm order'));
    await tester.tap(find.text('Recover'));
    await tester.tap(find.text('Overview'));
    expect(nodePressed, isTrue);
    expect(recovered, isTrue);
    expect(minimapPressed, isTrue);
  });
}
