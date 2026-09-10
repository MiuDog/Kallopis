import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';

void main() {
  KlpScreen screen(KlpRouteInput<int, String> input) => KlpScreen(
    id: 'screen',
    accessibilityLabel: 'Screen',
    child: KlpRail(id: 'rail'),
  );

  test(
    'router freezes declarations and preserves exact destination identity',
    () {
      final destination = KlpDestination<int, String>('main');
      final route = KlpRoute(destination, screen: screen);
      final routes = <KlpRoute<Object?, Object?>>[route];
      final initial = destination.location(7);
      final router = KlpRouter(id: 'router', initial: initial, routes: routes);
      routes.clear();
      expect(router.routes.single, same(route));
      expect(router.routes.single.destination, same(destination));
      expect(router.initial, same(initial));
      expect(router.initial.parameters, 7);
      expect(() => router.routes.clear(), throwsUnsupportedError);
    },
  );

  test('same named destination cannot impersonate initial registration', () {
    final destination = KlpDestination<int, String>('main');
    final impostor = KlpDestination<int, String>('main');
    expect(
      () => KlpRouter(
        id: 'router',
        initial: impostor.location(7),
        routes: [KlpRoute<int, String>(destination, screen: screen)],
      ),
      throwsArgumentError,
    );
  });

  test(
    'duplicate names and duplicate destination registrations are rejected',
    () {
      final destination = KlpDestination<int, String>('main');
      final route = KlpRoute(destination, screen: screen);
      final sameName = KlpRoute(
        KlpDestination<int, String>('main'),
        screen: screen,
      );
      for (final routes in [
        [route, route],
        [route, sameName],
      ]) {
        expect(
          () => KlpRouter(
            id: 'router',
            initial: destination.location(7),
            routes: routes,
          ),
          throwsArgumentError,
        );
      }
    },
  );

  test('empty router identity and missing initial route are rejected', () {
    final destination = KlpDestination<int, String>('main');
    expect(
      () => KlpRouter(
        id: ' ',
        initial: destination.location(7),
        routes: [KlpRoute<int, String>(destination, screen: screen)],
      ),
      throwsArgumentError,
    );
    expect(
      () =>
          KlpRouter(id: 'router', initial: destination.location(7), routes: []),
      throwsArgumentError,
    );
  });
}
