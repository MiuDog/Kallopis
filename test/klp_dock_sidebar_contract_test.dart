import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('file explorer uses the panel scroll controller', (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      KlpApp(
        showWindowHeader: false,
        startMaximized: false,
				home: KlpPanelFrame(content: KlpFileExplorer(scrollController: controller, sections: const [])),
      ),
    );

    expect(
      tester.widget<ListView>(find.byType(ListView)).controller,
      controller,
    );
  });

  testWidgets('side-only dock does not require bottom constraints', (
    tester,
  ) async {
    const panelId = 'navigation';
    const layout = KlpDockLayoutData(
      left: KlpDockAreaData(
        axis: Axis.vertical,
        groups: [
          KlpDockGroupData(
            id: 'navigation-group',
            panelIds: [panelId],
            activePanelId: panelId,
            mainAxisExtent: 220,
          ),
        ],
        extent: 220,
      ),
      right: KlpDockAreaData(
        axis: Axis.vertical,
        groups: [],
        extent: 220,
        isVisible: false,
      ),
      bottom: KlpDockAreaData(
        axis: Axis.horizontal,
        groups: [],
        extent: 0,
        isVisible: false,
      ),
    );

    await tester.pumpWidget(
      KlpApp(
        showWindowHeader: false,
        startMaximized: false,
        home: KlpDockLayout(
					stage: KlpPanelFrame(content: const SizedBox.expand()),
          panels: const [
            KlpDockPanel(
              id: panelId,
              content: SizedBox.expand(),
              allowSide: true,
              allowBottom: false,
            ),
          ],
          layout: layout,
          onLayoutChanged: _ignoreLayout,
          leftConstraints: _sideConstraints,
          rightConstraints: _sideConstraints,
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(KlpDockLayout), findsOneWidget);
  });
}

const _sideConstraints = KlpDockAreaConstraints(minExtent: 200, maxExtent: 460);

void _ignoreLayout(KlpDockLayoutData layout) {}
