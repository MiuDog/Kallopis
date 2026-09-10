import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_choice.dart';

import 'support/klp_component_test_definition.dart';
import 'support/klp_component_test_item.dart';
import 'support/klp_test_primitives.dart';

KlpScreen _screen(String label, {KlpAction? action}) => KlpScreen(
  id: 'screen',
  accessibilityLabel: label,
  child: KlpRail(
    id: 'rail',
    center: [KlpComponentTestItem(id: 'item', label: label, action: action)],
  ),
);
KlpApplication _app(
  KlpDestination<int, String> initial,
  List<KlpRoute<Object?, Object?>> routes, {
  String title = 'Application',
}) => KlpApplication(
  title: title,
  primitives: klpTestPrimitives(),
  router: KlpRouter(id: 'router', initial: initial.location(0), routes: routes),
  components: [klpComponentTestDefinition()],
);

Future<void> _activate(WidgetTester tester) async {
  await tester
      .widget<KlpFlutterChoice>(find.byType(KlpFlutterChoice))
      .content
      .onActivate!();
}

final class _IntCodec implements KlpRouteCodec<int> {
  const _IntCodec();

  @override
  int decode(Map<String, String> values) => int.parse(values['value']!);

  @override
  Map<String, String> encode(int parameters) => {'value': '$parameters'};
}

void main() {
  testWidgets(
    'route actions commit navigation and deliver typed results without exposing an imperative input',
    (tester) async {
      final home = KlpDestination<int, String>('home');
      final detail = KlpDestination<int, String>('detail');
      late KlpRouteInput<int, String> homeInput;
      late KlpRouteInput<int, String> detailInput;
      String? result;
      late KlpAction oldHomeAction;
      final routes = <KlpRoute<Object?, Object?>>[
        KlpRoute<int, String>(
          home,
          screen: (input) {
            homeInput = input;
            oldHomeAction = input.navigate(
              detail.location(1),
              onResult: (value) => result = value,
            );
            return _screen('Home', action: oldHomeAction);
          },
        ),
        KlpRoute<int, String>(
          detail,
          screen: (input) {
            detailInput = input;
            return _screen(
              'Detail ${input.parameters}',
              action: input.finish('saved'),
            );
          },
        ),
      ];
      final source = KlpMutableState(_app(home, routes));
      addTearDown(source.dispose);
      runKlpApp(source.readOnly);
      await tester.pump();
      await tester.pump();
      final oldChoice = tester
          .widget<KlpFlutterChoice>(find.byType(KlpFlutterChoice))
          .content;
      await _activate(tester);
      await tester.pump();
      expect(
        tester
            .widget<KlpFlutterChoice>(find.byType(KlpFlutterChoice))
            .content
            .label,
        'Detail 1',
      );
      await oldChoice.onActivate!();
      await tester.pump();
      expect(
        tester
            .widget<KlpFlutterChoice>(find.byType(KlpFlutterChoice))
            .content
            .label,
        'Detail 1',
      );
      await _activate(tester);
      await tester.pump();
      expect(
        tester
            .widget<KlpFlutterChoice>(find.byType(KlpFlutterChoice))
            .content
            .label,
        'Home',
      );
      expect(result, 'saved');
      expect(homeInput.parameters, 0);
      expect(detailInput.parameters, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('rejected navigation action keeps rail selection unchanged', (
    tester,
  ) async {
    final home = KlpDestination<int, String>('home');
    final detail = KlpDestination<int, String>('detail');
    final source = KlpMutableState(
      _app(home, [
        KlpRoute<int, String>(
          home,
          screen: (input) =>
              _screen('Home', action: input.navigate(detail.location(1))),
        ),
        KlpRoute<int, String>(
          detail,
          beforeEnter: (_) => false,
          screen: (_) => _screen('Detail'),
        ),
      ]),
    );
    addTearDown(source.dispose);
    runKlpApp(source.readOnly);
    await tester.pump();
    await tester.pump();
    final choice = tester
        .widget<KlpFlutterChoice>(find.byType(KlpFlutterChoice))
        .content;
    expect(choice.selection.value, isNull);
    await _activate(tester);
    await tester.pump();
    expect(choice.selection.value, isNull);
    expect(
      tester
          .widget<KlpFlutterChoice>(find.byType(KlpFlutterChoice))
          .content
          .label,
      'Home',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'pending bootstrap replacement cancels old guard before creating screens',
    (tester) async {
      final home = KlpDestination<int, String>('home');
      final gate = Completer<bool>();
      var oldProjections = 0;
      var newProjections = 0;
      final source = KlpMutableState(
        _app(home, [
          KlpRoute(
            home,
            beforeEnter: (_) => gate.future,
            screen: (_) {
              oldProjections++;
              return _screen('Old');
            },
          ),
        ]),
      );
      addTearDown(source.dispose);
      runKlpApp(source.readOnly);
      await tester.pump();
      expect(oldProjections, 0);
      expect(find.byType(KlpFlutterChoice), findsNothing);
      source.value = _app(home, [
        KlpRoute(
          home,
          screen: (_) {
            newProjections++;
            return _screen('New');
          },
        ),
      ]);
      await tester.pump();
      gate.complete(true);
      await tester.pump();
      expect(oldProjections, 0);
      expect(newProjections, 1);
      expect(
        tester
            .widget<KlpFlutterChoice>(find.byType(KlpFlutterChoice))
            .content
            .label,
        'New',
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('committed typed navigation reports the current platform URI', (
    tester,
  ) async {
    final updates = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.navigation, (call) async {
          updates.add(call);
          return null;
        });
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.navigation, null),
    );
    final home = KlpDestination<int, String>('home', codec: const _IntCodec());
    final detail = KlpDestination<int, String>(
      'detail',
      codec: const _IntCodec(),
    );
    final source = KlpMutableState(
      KlpApplication(
        title: 'URI',
        primitives: klpTestPrimitives(),
        router: KlpRouter(
          id: 'router',
          initial: home.location(0),
          routes: [
            KlpRoute<int, String>(
              home,
              screen: (input) =>
                  _screen('Home', action: input.navigate(detail.location(7))),
            ),
            KlpRoute<int, String>(detail, screen: (_) => _screen('Detail')),
          ],
        ),
        components: [klpComponentTestDefinition()],
      ),
    );
    addTearDown(source.dispose);
    runKlpApp(source.readOnly);
    await tester.pump();
    await tester.pump();
    expect(updates.last.method, 'routeInformationUpdated');
    final firstArguments = updates.last.arguments as Map<Object?, Object?>;
    final firstRestoration = KlpRouteUri.decode(
      Uri.parse(firstArguments['uri']! as String),
    );
    expect(firstRestoration!.stack.single.destinationId, 'home');
    expect(firstRestoration.stack.single.parameters, {'value': '0'});
    expect(firstArguments['replace'], isFalse);
    await _activate(tester);
    await tester.pump();
    final nextArguments = updates.last.arguments as Map<Object?, Object?>;
    final nextRestoration = KlpRouteUri.decode(
      Uri.parse(nextArguments['uri']! as String),
    );
    expect(nextRestoration!.stack.map((entry) => entry.destinationId), [
      'home',
      'detail',
    ]);
    expect(nextRestoration.stack.last.parameters, {'value': '7'});
    expect(nextArguments['replace'], isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'platform URI replaces the committed stack through router guards',
    (tester) async {
      final updates = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.navigation, (call) async {
            updates.add(call);
            return null;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.navigation, null),
      );
      final home = KlpDestination<int, String>(
        'home',
        codec: const _IntCodec(),
      );
      final detail = KlpDestination<int, String>(
        'detail',
        codec: const _IntCodec(),
      );
      final source = KlpMutableState(
        KlpApplication(
          title: 'URI input',
          primitives: klpTestPrimitives(),
          router: KlpRouter(
            id: 'router',
            initial: home.location(0),
            routes: [
              KlpRoute<int, String>(home, screen: (_) => _screen('Home')),
              KlpRoute<int, String>(
                detail,
                screen: (input) => _screen('Detail ${input.parameters}'),
              ),
            ],
          ),
          components: [klpComponentTestDefinition()],
        ),
      );
      addTearDown(source.dispose);
      runKlpApp(source.readOnly);
      await tester.pump();
      await tester.pump();
      await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .handlePlatformMessage(
            SystemChannels.navigation.name,
            SystemChannels.navigation.codec.encodeMethodCall(
              MethodCall('pushRouteInformation', {
                'location': '/router/detail?value=7',
                'state': null,
              }),
            ),
            null,
          );
      await tester.pump();
      expect(
        tester
            .widget<KlpFlutterChoice>(find.byType(KlpFlutterChoice))
            .content
            .label,
        'Detail 7',
      );
      final arguments = updates.last.arguments as Map<Object?, Object?>;
      final restoration = KlpRouteUri.decode(
        Uri.parse(arguments['uri']! as String),
      );
      expect(restoration!.stack.single.destinationId, 'detail');
      expect(restoration.stack.single.parameters, {'value': '7'});
      expect(arguments['replace'], isTrue);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('platform complete-stack URI restores every retained entry', (
    tester,
  ) async {
    final home = KlpDestination<int, String>('home', codec: const _IntCodec());
    final detail = KlpDestination<int, String>(
      'detail',
      codec: const _IntCodec(),
    );
    final guarded = <String>[];
    final source = KlpMutableState(
      KlpApplication(
        title: 'URI stack input',
        primitives: klpTestPrimitives(),
        router: KlpRouter(
          id: 'router',
          initial: home.location(0),
          routes: [
            KlpRoute<int, String>(
              home,
              beforeEnter: (_) {
                guarded.add('home');
                return true;
              },
              screen: (input) => _screen('Home ${input.parameters}'),
            ),
            KlpRoute<int, String>(
              detail,
              beforeEnter: (_) {
                guarded.add('detail');
                return true;
              },
              screen: (input) => _screen('Detail ${input.parameters}'),
            ),
          ],
        ),
        components: [klpComponentTestDefinition()],
      ),
    );
    addTearDown(source.dispose);
    runKlpApp(source.readOnly);
    await tester.pump();
    await tester.pump();
    guarded.clear();
    final uri = KlpRouteUri.encodeRestoration(
      KlpNavigationRestoration(
        routerId: 'router',
        stack: [
          KlpRouteAddress(destinationId: 'home', parameters: {'value': '2'}),
          KlpRouteAddress(destinationId: 'detail', parameters: {'value': '7'}),
        ],
      ),
    );
    await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .handlePlatformMessage(
          SystemChannels.navigation.name,
          SystemChannels.navigation.codec.encodeMethodCall(
            MethodCall('pushRouteInformation', {
              'location': uri.toString(),
              'state': null,
            }),
          ),
          null,
        );
    await tester.pump();
    expect(
      tester
          .widget<KlpFlutterChoice>(find.byType(KlpFlutterChoice))
          .content
          .label,
      'Detail 7',
    );
    expect(guarded, ['home', 'detail']);
    expect(tester.takeException(), isNull);
  });

  testWidgets('screen label becomes the controlled named-route semantics', (
    tester,
  ) async {
    final home = KlpDestination<int, String>('home');
    final source = KlpMutableState(
      _app(home, [
        KlpRoute<int, String>(home, screen: (_) => _screen('Accessible home')),
      ]),
    );
    addTearDown(source.dispose);
    runKlpApp(source.readOnly);
    await tester.pump();
    await tester.pump();
    final semantics = tester.widget<Semantics>(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.namesRoute == true,
      ),
    );
    expect(semantics.properties.label, 'Accessible home');
    expect(semantics.properties.namesRoute, isTrue);
    expect(tester.takeException(), isNull);
  });

  test('screen rejects an empty accessibility label', () {
    expect(
      () => KlpScreen(
        id: 'screen',
        accessibilityLabel: ' ',
        child: KlpRail(id: 'rail'),
      ),
      throwsArgumentError,
    );
  });

  testWidgets(
    'component definition projects its controlled accessibility label',
    (tester) async {
      final home = KlpDestination<int, String>('home');
      final source = KlpMutableState(
        KlpApplication(
          title: 'Component semantics',
          primitives: klpTestPrimitives(),
          router: KlpRouter(
            id: 'router',
            initial: home.location(0),
            routes: [
              KlpRoute<int, String>(
                home,
                screen: (_) => KlpScreen(
                  id: 'screen',
                  accessibilityLabel: 'Home',
                  child: KlpRail(
                    id: 'rail',
                    center: [KlpComponentTestItem(id: 'item', label: 'Item')],
                  ),
                ),
              ),
            ],
          ),
          components: [
            klpComponentTestDefinition(
              accessibilityLabel: (item) => 'Component ${item.label}',
            ),
          ],
        ),
      );
      addTearDown(source.dispose);
      runKlpApp(source.readOnly);
      await tester.pump();
      await tester.pump();
      final semantics = tester.widget<Semantics>(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == 'Component Item',
        ),
      );
      expect(semantics.properties.label, 'Component Item');
      expect(tester.takeException(), isNull);
    },
  );
}
