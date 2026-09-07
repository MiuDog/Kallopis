import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets('side panel moves between left and right areas', (tester) async {
    await tester.pumpWidget(const _DockHarness());

    await _dragPanelToStageSide(tester, right: true);
    var state = tester.state<_DockHarnessState>(find.byType(_DockHarness));
    expect(state.layout.left.groups, isEmpty);
    expect(state.layout.right.groups.single.panelIds, const ['navigation']);

    await _dragPanelToStageSide(tester, right: false);
    state = tester.state<_DockHarnessState>(find.byType(_DockHarness));
    expect(state.layout.left.groups.single.panelIds, const ['navigation']);
    expect(state.layout.right.groups, isEmpty);
  });

  testWidgets('dock header keeps its title at the code line height', (
    tester,
  ) async {
    await tester.pumpWidget(const _DockHarness());

    final header = find.byType(KlpDockHeader);
    final title = find.text('NAVIGATION');
    final type = tester.element(header).klp.type;
    final definition = KlpTextStyles.definitionOf(KlpTextRole.code, type);

    expect(
      tester.getRect(title).height,
      closeTo(definition.fontSize * definition.lineHeight, 0.01),
    );
    expect(
      tester.getRect(title).center.dy,
      closeTo(tester.getRect(header).center.dy, 1),
    );
  });

  testWidgets('window header toggles the active side area visibility', (
    tester,
  ) async {
    await tester.pumpWidget(const _DockHarness());

    await tester.tap(_headerButton('收合導覽'));
    await tester.pumpAndSettle();
    var state = tester.state<_DockHarnessState>(find.byType(_DockHarness));
    expect(state.layout.left.isVisible, isFalse);
    expect(find.byKey(const ValueKey('navigation-content')), findsNothing);

    await tester.tap(_headerButton('展開導覽'));
    await tester.pumpAndSettle();
    state = tester.state<_DockHarnessState>(find.byType(_DockHarness));
    expect(state.layout.left.isVisible, isTrue);
    expect(find.byKey(const ValueKey('navigation-content')), findsOneWidget);
  });

  testWidgets('area resize reports changes and clamps to side constraints', (
    tester,
  ) async {
    await tester.pumpWidget(const _DockHarness());
    final handle = find.byKey(const ValueKey('dock-area-left-resize-handle'));

    await tester.drag(handle, const Offset(-80, 0));
    await tester.pumpAndSettle();
    var state = tester.state<_DockHarnessState>(find.byType(_DockHarness));
    expect(state.layout.left.extent, _sideConstraints.minExtent);
    expect(state.changeCount, greaterThan(0));

    await tester.drag(handle, const Offset(600, 0));
    await tester.pumpAndSettle();
    state = tester.state<_DockHarnessState>(find.byType(_DockHarness));
    expect(state.layout.left.extent, _sideConstraints.maxExtent);
  });
}

Finder _headerButton(String label) {
  return find.byWidgetPredicate(
    (widget) => widget is KlpIconButton && widget.label == label,
  );
}

Future<void> _dragPanelToStageSide(
  WidgetTester tester, {
  required bool right,
}) async {
  final header = find.text('NAVIGATION');
  final stageRect = tester.getRect(find.byKey(const ValueKey('dock-stage')));
  final target = Offset(
    right ? stageRect.right - 20 : stageRect.left + 20,
    stageRect.center.dy,
  );
  final gesture = await tester.startGesture(tester.getCenter(header));
  await gesture.moveTo(target);
  await tester.pump();
  await gesture.up();
  await tester.pumpAndSettle();
}

class _DockHarness extends StatefulWidget {
  const _DockHarness();

  @override
  State<_DockHarness> createState() => _DockHarnessState();
}

class _DockHarnessState extends State<_DockHarness> {
  KlpDockLayoutData layout = _initialLayout;
  var changeCount = 0;

  bool get navigationVisible {
    return layout.left.groups.isNotEmpty
        ? layout.left.isVisible
        : layout.right.isVisible;
  }

  double get navigationExtent {
    return layout.left.groups.isNotEmpty
        ? layout.left.extent
        : layout.right.extent;
  }

  void _setLayout(KlpDockLayoutData next) {
    setState(() {
      layout = next;
      changeCount += 1;
    });
  }

  void _toggleNavigation() {
    if (layout.left.groups.isNotEmpty) {
      _setLayout(
        layout.copyWith(
          left: layout.left.copyWith(isVisible: !layout.left.isVisible),
        ),
      );
      return;
    }

    _setLayout(
      layout.copyWith(
        right: layout.right.copyWith(isVisible: !layout.right.isVisible),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KlpApp(
      startMaximized: false,
      showWindowControls: false,
      windowHeader: KlpWorkbenchWindowHeader(
        titleText: 'Dock test',
        primaryPaneWidth: navigationExtent,
        primaryVisible: navigationVisible,
        onTogglePrimary: _toggleNavigation,
        collapseLabel: '收合導覽',
        expandLabel: '展開導覽',
        showWindowControls: false,
      ),
      home: KlpDockLayout(
        stage: KlpPanelFrame(
          padding: EdgeInsets.zero,
          content: const SizedBox.expand(key: ValueKey('dock-stage')),
        ),
        panels: const [
          KlpDockPanel(
            id: 'navigation',
            header: KlpText('NAVIGATION', role: KlpTextRole.code),
            content: SizedBox.expand(key: ValueKey('navigation-content')),
            allowSide: true,
            allowBottom: false,
          ),
        ],
        layout: layout,
        onLayoutChanged: _setLayout,
        leftConstraints: _sideConstraints,
        rightConstraints: _sideConstraints,
      ),
    );
  }
}

const _sideConstraints = KlpDockAreaConstraints(minExtent: 200, maxExtent: 460);

const _initialLayout = KlpDockLayoutData(
  left: KlpDockAreaData(
    axis: Axis.vertical,
    groups: [
      KlpDockGroupData(
        id: 'navigation-group',
        panelIds: ['navigation'],
        activePanelId: 'navigation',
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
