import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_choice.dart';

import 'support/klp_composite_test_definition.dart';
import 'support/klp_composite_test_node.dart';
import 'support/klp_test_primitives.dart';

final _compositeDestination = KlpDestination<Object?, Object?>(
  'fixture.composite',
);

void main() {
  testWidgets(
    'public bootstrap renders every nested slot once and selects each node once',
    (tester) async {
      final reads = <String, int>{};
      final deep = _node('deep');
      final nested = _node('nested', trailing: [deep]);
      final parent = _node(
        'parent',
        leading: [nested],
        trailing: [_node('last')],
      );
      final source = KlpMutableState(_app([parent], reads: reads));
      addTearDown(source.dispose);

      // 從公開啟動點驗證實際呈現，不能只檢查中間模板。
      runKlpApp(source.readOnly);
      await tester.pump();
      await tester.pump();
      for (final id in ['parent', 'nested', 'deep', 'last']) {
        expect(find.text(id), findsOneWidget);
        expect(reads[id], 1);
      }
      expect(
        tester.getTopLeft(find.text('parent')).dy,
        lessThan(tester.getTopLeft(find.text('nested')).dy),
      );
      expect(
        tester.getTopLeft(find.text('nested')).dy,
        lessThan(tester.getTopLeft(find.text('deep')).dy),
      );
      expect(
        tester.getTopLeft(find.text('deep')).dy,
        lessThan(tester.getTopLeft(find.text('last')).dy),
      );
      await tester.pump();
      expect(reads.values, everyElement(1));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'composite sibling reorder and style replacement preserve focus and selection',
    (tester) async {
      var calls = 0;
      final first = _node(
        'first',
        trailing: [_node('inside')],
        action: KlpCallbackAction(() => calls++),
      );
      final second = _node('second', action: KlpCallbackAction(() {}));
      final reads = <String, int>{};
      final source = KlpMutableState(_app([first, second], reads: reads));
      addTearDown(source.dispose);
      runKlpApp(source.readOnly);
      await tester.pump();
      await tester.pump();
      await tester.tap(find.byWidget(_choice(tester, 'first')));
      await tester.pump();
      final focus = FocusManager.instance.primaryFocus;
      final oldChoice = _choice(tester, 'first');
      final selection = oldChoice.content.selection;
      expect(focus, isNotNull);
      expect(
        selection.value,
        KlpPlacementId(
          scope: ['composite.router', 'route-1'],
          localId: 'first',
        ),
      );
      expect(calls, 1);

      // 保持識別但交換實例順序，並同步替換整套原料。
      source.value = _app([second, first], alternate: true, reads: reads);
      await tester.pump();
      expect(FocusManager.instance.primaryFocus, same(focus));
      expect(_choice(tester, 'first').content.selection, same(selection));
      expect(
        selection.value,
        KlpPlacementId(
          scope: ['composite.router', 'route-1'],
          localId: 'first',
        ),
      );
      expect(
        tester.getTopLeft(find.text('second')).dy,
        lessThan(tester.getTopLeft(find.text('first')).dy),
      );
      expect(find.text('inside'), findsOneWidget);
      expect(reads, {'first': 2, 'inside': 2, 'second': 2});
      expect(
        _choice(tester, 'first').content.style.selectedBackground,
        same(source.value.primitives.colors[2]),
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      expect(() => selection.value, throwsStateError);
    },
  );

  testWidgets(
    'invalid nested assignments preserve committed focus resources and actions',
    (tester) async {
      var calls = 0;
      final reads = <String, int>{};
      final valid = _node(
        'first',
        leading: [_node('inside')],
        action: KlpCallbackAction(() => calls++),
      );
      final source = KlpMutableState(_app([valid], reads: reads));
      addTearDown(source.dispose);
      runKlpApp(source.readOnly);
      await tester.pump();
      await tester.pump();
      await tester.tap(find.byWidget(_choice(tester, 'first')));
      await tester.pump();
      final focus = FocusManager.instance.primaryFocus;
      final old = _choice(tester, 'first').content;
      final invalid = KlpCompositeTestNode(
        'inside',
        KlpChildren([
          klpCompositeTrailing.assign([]),
          klpCompositeLeading.assign([]),
        ]),
      );
      final replacement = _node('first', leading: [invalid]);

      // 深層契約錯誤必須在任何新投影及安裝前拒絕。
      expect(
        () => source.value = _app([replacement], reads: reads),
        throwsA(isA<KlpContractError>()),
      );
      await tester.pump();
      expect(_choice(tester, 'first').content, same(old));
      expect(FocusManager.instance.primaryFocus, same(focus));
      expect(
        old.selection.value,
        KlpPlacementId(
          scope: ['composite.router', 'route-1'],
          localId: 'first',
        ),
      );
      expect(reads, {'first': 1, 'inside': 1});
      expect(find.text('inside'), findsOneWidget);
      old.onActivate!();
      expect(calls, 2);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      expect(() => old.selection.value, throwsStateError);
    },
  );
}

KlpCompositeTestNode _node(
  String id, {
  List<KlpRailItem> leading = const [],
  List<KlpRailItem> trailing = const [],
  KlpAction? action,
}) => KlpCompositeTestNode(
  id,
  klpCompositeChildren(leading: leading, trailing: trailing),
  label: id,
  action: action,
);

KlpApplication _app(
  List<KlpRailItem> items, {
  bool alternate = false,
  required Map<String, int> reads,
}) {
  return KlpApplication(
    title: 'Composite review',
    primitives: klpTestPrimitives(alternate: alternate),
    router: KlpRouter(
      id: 'composite.router',
      initial: _compositeDestination.location(null),
      routes: [
        KlpRoute(
          _compositeDestination,
          screen: (_) => KlpScreen(
            id: 'screen',
            accessibilityLabel: 'Composite review',
            child: KlpRail(id: 'rail', center: items),
          ),
        ),
      ],
    ),
    components: [
      klpCompositeTestDefinition(
        select: (node) {
          reads.update(node.id, (value) => value + 1, ifAbsent: () => 1);
          return node.label;
        },
      ),
    ],
  );
}

KlpFlutterChoice _choice(WidgetTester tester, String id) => tester
    .widgetList<KlpFlutterChoice>(find.byType(KlpFlutterChoice))
    .singleWhere(
      (choice) =>
          choice.content.id ==
          KlpPlacementId(scope: ['composite.router', 'route-1'], localId: id),
    );
