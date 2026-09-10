import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_choice.dart';

import 'support/klp_component_test_definition.dart';
import 'support/klp_component_test_item.dart';
import 'support/klp_test_primitives.dart';

final class _IntCodec implements KlpRouteCodec<int> {
  const _IntCodec();

  @override
  int decode(Map<String, String> values) => int.parse(values['value']!);

  @override
  Map<String, String> encode(int parameters) => {'value': '$parameters'};
}

KlpScreen _screen(String label, {KlpAction? action}) => KlpScreen(
  id: 'screen',
  accessibilityLabel: label,
  child: KlpRail(
    id: 'rail',
    center: [KlpComponentTestItem(id: 'item', label: label, action: action)],
  ),
);

Future<void> _activate(WidgetTester tester) async {
  await tester
      .widget<KlpFlutterChoice>(find.byType(KlpFlutterChoice))
      .content
      .onActivate!();
}

void main() {
  testWidgets(
    'restores a typed retained stack and publishes every committed stack',
    (tester) async {
      final home = KlpDestination<int, String>(
        'home',
        codec: const _IntCodec(),
      );
      final detail = KlpDestination<int, String>(
        'detail',
        codec: const _IntCodec(),
      );
      final restorations = <KlpNavigationRestoration>[];
      final application = KlpApplication(
        title: 'Restoration',
        primitives: klpTestPrimitives(),
        router: KlpRouter(
          id: 'router',
          initial: home.location(0),
          restoration: KlpNavigationRestoration(
            routerId: 'router',
            stack: [
              KlpRouteAddress(
                destinationId: 'home',
                parameters: {'value': '2'},
              ),
              KlpRouteAddress(
                destinationId: 'detail',
                parameters: {'value': '7'},
              ),
            ],
          ),
          routes: [
            KlpRoute<int, String>(home, screen: (_) => _screen('Home')),
            KlpRoute<int, String>(
              detail,
              screen: (input) =>
                  _screen('Detail ${input.parameters}', action: input.back()),
            ),
          ],
        ),
        components: [klpComponentTestDefinition()],
        onNavigationRestorationChanged: restorations.add,
      );
      final source = KlpMutableState(application);
      addTearDown(source.dispose);
      runKlpApp(source.readOnly);
      await tester.pump();
      await tester.pump();
      expect(
        tester
            .widget<KlpFlutterChoice>(find.byType(KlpFlutterChoice))
            .content
            .label,
        'Detail 7',
      );
      expect(restorations.single.stack.map((entry) => entry.destinationId), [
        'home',
        'detail',
      ]);
      await _activate(tester);
      await tester.pump();
      expect(
        tester
            .widget<KlpFlutterChoice>(find.byType(KlpFlutterChoice))
            .content
            .label,
        'Home',
      );
      expect(restorations.last.stack.map((entry) => entry.destinationId), [
        'home',
      ]);
      expect(tester.takeException(), isNull);
    },
  );

  test('rejects restoration data that belongs to a different router', () {
    final home = KlpDestination<int, String>('home', codec: const _IntCodec());
    expect(
      () => KlpRouter(
        id: 'router',
        initial: home.location(0),
        restoration: KlpNavigationRestoration(
          routerId: 'other',
          stack: [
            KlpRouteAddress(destinationId: 'home', parameters: {'value': '0'}),
          ],
        ),
        routes: [KlpRoute<int, String>(home, screen: (_) => _screen('Home'))],
      ),
      throwsArgumentError,
    );
  });

  testWidgets(
    'runs each restored route enter guard before installing retained pages',
    (tester) async {
      final home = KlpDestination<int, String>(
        'home',
        codec: const _IntCodec(),
      );
      final detail = KlpDestination<int, String>(
        'detail',
        codec: const _IntCodec(),
      );
      var homeGuardCalls = 0;
      final restorations = <KlpNavigationRestoration>[];
      final source = KlpMutableState(
        KlpApplication(
          title: 'Rejected restoration',
          primitives: klpTestPrimitives(),
          router: KlpRouter(
            id: 'router',
            initial: home.location(0),
            restoration: KlpNavigationRestoration(
              routerId: 'router',
              stack: [
                KlpRouteAddress(
                  destinationId: 'home',
                  parameters: {'value': '2'},
                ),
                KlpRouteAddress(
                  destinationId: 'detail',
                  parameters: {'value': '7'},
                ),
              ],
            ),
            routes: [
              KlpRoute<int, String>(
                home,
                beforeEnter: (_) {
                  homeGuardCalls++;
                  return false;
                },
                screen: (_) => _screen('Home'),
              ),
              KlpRoute<int, String>(detail, screen: (_) => _screen('Detail')),
            ],
          ),
          components: [klpComponentTestDefinition()],
          onNavigationRestorationChanged: restorations.add,
        ),
      );
      addTearDown(source.dispose);
      runKlpApp(source.readOnly);
      await tester.pump();
      await tester.pump();
      expect(homeGuardCalls, 1);
      expect(restorations, isEmpty);
      expect(find.byType(KlpFlutterChoice), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
