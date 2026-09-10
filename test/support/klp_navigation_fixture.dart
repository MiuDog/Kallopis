import 'dart:async';

import 'package:kallopis/src/capabilities/navigation/internal/klp_navigation_machine.dart';
import 'package:kallopis/src/capabilities/navigation/klp_location.dart';
import 'package:kallopis/src/capabilities/navigation/klp_navigation_cancellation.dart';
import 'package:kallopis/src/capabilities/navigation/klp_navigation_snapshot.dart';
import 'package:kallopis/src/capabilities/navigation/klp_route_policy.dart';

/// 非啟動案例經過相同安全入口，只接受測試提供的同步允許政策。
KlpNavigationMachine klpNavigationTestMachine({
  required Iterable<KlpRoutePolicy> policies,
  required KlpLocation<Object?> initial,
  required void Function(KlpNavigationSnapshot) commit,
}) {
  final signal = KlpNavigationCancellation(
    Completer<void>().future,
    () => false,
  );
  final started = KlpNavigationMachine.start(
    policies: policies,
    initial: initial,
    commit: (snapshot, {required replaceRouteInformation}) => commit(snapshot),
    cancellation: signal,
  );
  if (started is! KlpNavigationStart || started.machine == null) {
    throw StateError(
      'Fixture requires successful synchronous navigation startup.',
    );
  }

  return started.machine!;
}
