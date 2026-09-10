part of '../structure/klp_application.dart';

/// 單一或多畫面皆透過路由資料宣告，消費端不建立導覽控制器。
final class KlpRouter {
  final String id;
  final KlpLocation<Object?> initial;
  final List<KlpRoute<Object?, Object?>> routes;
  final KlpNavigationRestoration? restoration;
  late final List<KlpLocation<Object?>> _initialStack;

  KlpRouter({
    required this.id,
    required this.initial,
    required List<KlpRoute<Object?, Object?>> routes,
    this.restoration,
  }) : routes = List.unmodifiable(routes) {
    if (id.trim().isEmpty) {
      throw ArgumentError.value(id, 'id', 'Router identity cannot be empty.');
    }
    final names = <String>{};
    var initialRegistered = false;
    final destinations = <String, KlpDestination<Object?, Object?>>{};
    for (final route in this.routes) {
      if (!names.add(route.destination.id)) {
        throw ArgumentError('Duplicate destination: ${route.destination.id}.');
      }
      destinations[route.destination.id] = route.destination;
      if (identical(route.destination, initial.destination)) {
        initialRegistered = true;
      }
    }
    if (!initialRegistered) {
      throw ArgumentError('Initial destination is not registered.');
    }
    if (!initial.destination.acceptsParameters(initial.parameters)) {
      throw ArgumentError('Invalid initial destination parameters.');
    }
    final restored = restoration;
    if (restored == null) {
      _initialStack = List.unmodifiable([initial]);
    } else {
      _initialStack = _decodeRestoration(restored, destinations);
    }
  }

  bool get supportsRestoration =>
      routes.every((route) => route.destination.supportsRestoration);

  List<KlpLocation<Object?>> _decodeRestoration(
    KlpNavigationRestoration value,
    Map<String, KlpDestination<Object?, Object?>> destinations,
  ) {
    if (value.routerId != id) {
      throw ArgumentError('Restoration belongs to a different router.');
    }
    return List.unmodifiable(
      value.stack.map((address) {
        final destination = destinations[address.destinationId];
        if (destination == null) {
          throw ArgumentError(
            'Restoration destination is not registered: ${address.destinationId}.',
          );
        }
        return destination.decodeAddress(address);
      }),
    );
  }

  List<KlpLocation<Object?>> _restore(
    KlpNavigationRestoration value,
  ) => _decodeRestoration(
    value,
    {for (final route in routes) route.destination.id: route.destination},
  );
}
