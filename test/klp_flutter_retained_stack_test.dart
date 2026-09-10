import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/capabilities/state/klp_mutable_state.dart';
import 'package:kallopis/src/foundation/binding/internal/klp_bound_template.dart';
import 'package:kallopis/src/kernel/identity/klp_placement_id.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_choice.dart';

import 'support/klp_renderer_fixture.dart';

KlpPlacementId _id(String scope, [String local = 'same']) =>
    KlpPlacementId(scope: [scope], localId: local);
Finder _choice(String scope) => find.byWidgetPredicate(
  (widget) => widget is KlpFlutterChoice && widget.content.id == _id(scope),
  skipOffstage: false,
);
FocusNode _focus(WidgetTester tester, String scope) => tester
    .widget<FocusableActionDetector>(
      find.descendant(
        of: _choice(scope),
        matching: find.byType(FocusableActionDetector, skipOffstage: false),
        skipOffstage: false,
      ),
    )
    .focusNode!;

void main() {
  late KlpMutableState<KlpPlacementId?> selection;
  late List<String> activations;
  KlpBoundPlacement page(
    String scope, {
    bool enabled = true,
    bool removed = false,
  }) {
    final content = removed
        ? klpRendererText('Removed')
        : klpRendererChoice(
            id: _id(scope),
            selection: selection.readOnly,
            onActivate: enabled ? () => activations.add(scope) : null,
          );
    return KlpBoundPlacement(_id(scope, 'page'), content);
  }

  Widget host(String active, List<KlpBoundPlacement> pages) => klpRendererHost(
    KlpBoundRetainedStack(pages: pages, activeId: _id(active, 'page')),
  );
  setUp(() {
    selection = KlpMutableState(null);
    activations = [];
  });
  tearDown(() => selection.dispose());

  test('retained stack rejects empty pages and a missing active identity', () {
    expect(
      () => KlpBoundRetainedStack(pages: [], activeId: _id('a', 'page')),
      throwsArgumentError,
    );
    expect(
      () =>
          KlpBoundRetainedStack(pages: [page('a')], activeId: _id('b', 'page')),
      throwsArgumentError,
    );
  });

  test('retained stack rejects duplicate complete identities', () {
    expect(
      () => KlpBoundRetainedStack(
        pages: [page('a'), page('a')],
        activeId: _id('a', 'page'),
      ),
      throwsArgumentError,
    );
  });

  test('retained stack accepts equal local identities in different scopes', () {
    final pages = [page('a'), page('b')];
    final stack = KlpBoundRetainedStack(
      pages: pages,
      activeId: _id('b', 'page'),
    );
    pages.clear();
    expect(stack.pages, hasLength(2));
    expect(() => stack.pages.clear(), throwsUnsupportedError);
  });

  testWidgets(
    'same local IDs retain separate elements across visibility and reordering',
    (tester) async {
      await tester.pumpWidget(host('a', [page('a'), page('b')]));
      final first = tester.element(_choice('a'));
      final second = tester.element(_choice('b'));
      expect(first, isNot(same(second)));
      await tester.pumpWidget(host('b', [page('b'), page('a')]));
      expect(tester.element(_choice('a')), same(first));
      expect(tester.element(_choice('b')), same(second));
      await tester.tap(find.byType(KlpFlutterChoice));
      expect(activations, ['b']);
      await tester.pumpWidget(host('a', [page('a'), page('b')]));
      expect(tester.element(_choice('a')), same(first));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'hidden page excludes focus pointer semantics and ticker participation',
    (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        await tester.pumpWidget(host('a', [page('a'), page('b')]));
        final mode = TickerMode.getValuesNotifier(tester.element(_choice('b')));
        final changes = <bool>[];
        void recordMode() => changes.add(mode.value.enabled);
        mode.addListener(recordMode);
        addTearDown(() => mode.removeListener(recordMode));
        final hiddenFocus = _focus(tester, 'b');
        expect(hiddenFocus.canRequestFocus, isFalse);
        hiddenFocus.requestFocus();
        await tester.pump();
        expect(hiddenFocus.hasFocus, isFalse);
        await tester.tap(find.byType(KlpFlutterChoice));
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        expect(activations, ['a', 'a']);
        expect(find.bySemanticsLabel('Action same'), findsOneWidget);
        expect(
          TickerMode.valuesOf(tester.element(_choice('a'))).enabled,
          isTrue,
        );
        expect(
          TickerMode.valuesOf(tester.element(_choice('b'))).enabled,
          isFalse,
        );
        await tester.pumpWidget(host('b', [page('a'), page('b')]));
        expect(
          TickerMode.valuesOf(tester.element(_choice('a'))).enabled,
          isFalse,
        );
        expect(
          TickerMode.valuesOf(tester.element(_choice('b'))).enabled,
          isTrue,
        );
        expect(changes, [true]);
        await tester.pumpWidget(host('a', [page('a'), page('b')]));
        expect(changes, [true, false]);
        expect(find.bySemanticsLabel('Action same'), findsOneWidget);
        expect(tester.takeException(), isNull);
      } finally {
        semantics.dispose();
      }
    },
  );

  testWidgets('return restores the previously focused valid leaf', (
    tester,
  ) async {
    await tester.pumpWidget(host('a', [page('a'), page('b')]));
    await tester.tap(find.byType(KlpFlutterChoice));
    await tester.pump();
    final previous = _focus(tester, 'a');
    expect(previous.hasPrimaryFocus, isTrue);
    await tester.pumpWidget(host('b', [page('a'), page('b')]));
    await tester.tap(find.byType(KlpFlutterChoice));
    await tester.pump();
    expect(previous.hasFocus, isFalse);
    await tester.pumpWidget(host('a', [page('a'), page('b')]));
    await tester.pump();
    expect(FocusManager.instance.primaryFocus, same(previous));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'pending old focus cannot land on a hidden page when a new page mounts',
    (tester) async {
      await tester.pumpWidget(host('a', [page('a')]));
      final oldFocus = _focus(tester, 'a');
      // 焦點要求與切頁之間刻意不 pump，涵蓋尚未套用的舊要求。
      oldFocus.requestFocus();
      await tester.pumpWidget(host('b', [page('a'), page('b')]));
      await tester.pump();
      expect(oldFocus.hasFocus, isFalse);
      expect(oldFocus.canRequestFocus, isFalse);
      final currentScope = FocusScope.of(tester.element(_choice('b')));
      expect(currentScope.hasFocus, isTrue);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('rapid visibility changes leave only the final page focusable', (
    tester,
  ) async {
    await tester.pumpWidget(host('a', [page('a'), page('b')]));
    final first = _focus(tester, 'a');
    first.requestFocus();
    await tester.pumpWidget(host('b', [page('a'), page('b')]));
    await tester.pumpWidget(host('a', [page('a'), page('b')]));
    await tester.pump();
    expect(first.hasPrimaryFocus, isTrue);
    expect(_focus(tester, 'b').canRequestFocus, isFalse);
    expect(tester.takeException(), isNull);
  });

  for (final removed in [false, true]) {
    testWidgets(
      'return ignores a hidden leaf that becomes ${removed ? 'removed' : 'disabled'}',
      (tester) async {
        await tester.pumpWidget(host('a', [page('a'), page('b')]));
        await tester.tap(find.byType(KlpFlutterChoice));
        await tester.pump();
        final previous = _focus(tester, 'a');
        await tester.pumpWidget(host('b', [page('a'), page('b')]));
        await tester.pumpWidget(
          host('b', [page('a', enabled: false, removed: removed), page('b')]),
        );
        await tester.pumpWidget(
          host('a', [page('a', enabled: false, removed: removed), page('b')]),
        );
        await tester.pump();
        expect(FocusManager.instance.primaryFocus, isNot(same(previous)));
        expect(_focus(tester, 'b').hasFocus, isFalse);
        expect(FocusManager.instance.primaryFocus, isA<FocusScopeNode>());
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'removing an entry unmounts its choice and detaches its owned focus',
    (tester) async {
      await tester.pumpWidget(host('a', [page('a'), page('b')]));
      final removedElement = tester.element(_choice('a'));
      final retainedElement = tester.element(_choice('b'));
      final removedFocus = _focus(tester, 'a');
      await tester.pumpWidget(host('b', [page('b')]));
      expect(removedElement.mounted, isFalse);
      expect(removedFocus.parent, isNull);
      expect(tester.element(_choice('b')), same(retainedElement));
      await tester.pumpWidget(const SizedBox.shrink());
      expect(retainedElement.mounted, isFalse);
      expect(selection.isDisposed, isFalse);
      expect(tester.takeException(), isNull);
    },
  );
}
