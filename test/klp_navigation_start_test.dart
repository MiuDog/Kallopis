import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/capabilities/navigation/internal/klp_navigation_commit_contract_exception.dart';
import 'package:kallopis/src/capabilities/navigation/internal/klp_navigation_commit_exception.dart';
import 'package:kallopis/src/capabilities/navigation/internal/klp_navigation_machine.dart';
import 'package:kallopis/src/capabilities/navigation/klp_destination.dart';
import 'package:kallopis/src/capabilities/navigation/klp_navigation_cancellation.dart';
import 'package:kallopis/src/capabilities/navigation/klp_navigation_outcome.dart';
import 'package:kallopis/src/capabilities/navigation/klp_navigation_snapshot.dart';
import 'package:kallopis/src/capabilities/navigation/klp_navigation_transition.dart';
import 'package:kallopis/src/capabilities/navigation/klp_route_policy.dart';

void main() {
  late KlpDestination<int, String> home;
  late List<KlpNavigationSnapshot> commits;
  setUp(() {
    home = KlpDestination('home');
    commits = [];
  });
  FutureOr<KlpNavigationStart> start({
    FutureOr<bool> Function(KlpNavigationTransition)? guard,
    Completer<void>? cancel,
    int parameter = 0,
    Iterable<KlpRoutePolicy>? policies,
  }) {
    final cancellation = cancel ?? Completer<void>();
    return KlpNavigationMachine.start(
      policies:
          policies ?? [KlpRoutePolicy(destination: home, beforeEnter: guard)],
      initial: home.location(parameter),
      commit: (snapshot, {required replaceRouteInformation}) =>
          commits.add(snapshot),
      cancellation: KlpNavigationCancellation(
        cancellation.future,
        () => cancellation.isCompleted,
      ),
    );
  }

  test('no guard starts synchronously and captures policies only once', () {
    var enumerations = 0;
    Iterable<KlpRoutePolicy> policies() sync* {
      enumerations++;
      yield KlpRoutePolicy(destination: home);
    }

    final result = start(policies: policies()) as KlpNavigationStart;
    addTearDown(result.machine!.dispose);
    expect(result.decision.committed, isTrue);
    expect(result.machine!.initialDecision, same(result.decision));
    expect(commits, hasLength(1));
    expect(enumerations, 1);
  });

  test(
    'synchronous initial guard sees absent origin and exact committed candidate',
    () {
      late KlpNavigationSnapshot candidate;
      final result =
          start(
                guard: (transition) {
                  expect(transition.isInitial, isTrue);
                  expect(transition.from, isNull);
                  expect(commits, isEmpty);
                  candidate = transition.to;
                  return true;
                },
              )
              as KlpNavigationStart;
      addTearDown(result.machine!.dispose);
      expect(result.machine!.state.value, same(candidate));
      expect(commits.single, same(candidate));
    },
  );

  test('synchronous denial and thrown guard never commit', () {
    final rejected = start(guard: (_) => false) as KlpNavigationStart;
    expect(rejected.machine, isNull);
    expect(rejected.decision.outcome, isA<KlpNavigationRejected<void>>());
    final error = StateError('guard');
    final failed = start(guard: (_) => throw error) as KlpNavigationStart;
    expect(failed.machine, isNull);
    expect(
      failed.decision.outcome,
      isA<KlpNavigationFailed<void>>().having(
        (value) => value.error,
        'error',
        same(error),
      ),
    );
    expect(commits, isEmpty);
  });

  test('asynchronous allow commits only after the guard completes', () async {
    final guard = Completer<bool>();
    final pending = start(guard: (_) => guard.future);
    expect(pending, isA<Future<KlpNavigationStart>>());
    expect(commits, isEmpty);
    guard.complete(true);
    final result = await pending;
    addTearDown(result.machine!.dispose);
    expect(result.decision.committed, isTrue);
    expect(commits, hasLength(1));
  });

  for (final throwsError in [false, true]) {
    test(
      'asynchronous guard rejection or failure does not commit $throwsError',
      () async {
        final guard = Completer<bool>();
        final pending = start(guard: (_) => guard.future);
        if (throwsError) {
          guard.completeError(StateError('guard'));
        } else {
          guard.complete(false);
        }
        final result = await pending;
        expect(result.machine, isNull);
        expect(
          result.decision.outcome,
          throwsError
              ? isA<KlpNavigationFailed<void>>()
              : isA<KlpNavigationRejected<void>>(),
        );
        expect(commits, isEmpty);
      },
    );
  }

  test('pre-cancelled bootstrap never invokes its guard', () {
    final cancel = Completer<void>()..complete();
    var guards = 0;
    final result =
        start(
              cancel: cancel,
              guard: (_) {
                guards++;
                return true;
              },
            )
            as KlpNavigationStart;
    expect(result.decision.outcome, isA<KlpNavigationCancelled<void>>());
    expect(guards, 0);
    expect(commits, isEmpty);
  });

  for (final lateError in [false, true]) {
    test(
      'new source commits while cancelled old guard cannot overwrite it $lateError',
      () async {
        final guard = Completer<bool>();
        final cancel = Completer<void>();
        final old = start(
          guard: (_) => guard.future,
          cancel: cancel,
          parameter: 1,
        );
        cancel.complete();
        final current = start(parameter: 2) as KlpNavigationStart;
        addTearDown(current.machine!.dispose);
        expect(
          (await old).decision.outcome,
          isA<KlpNavigationCancelled<void>>(),
        );
        if (lateError) {
          guard.completeError(StateError('late guard'));
        } else {
          guard.complete(true);
        }
        await Future<void>.delayed(Duration.zero);
        expect(commits, hasLength(1));
        expect(commits.single.current.location.parameters, 2);
      },
    );
  }

  test('cancellation inside a synchronous guard is checked before commit', () {
    final cancel = Completer<void>();
    final result =
        start(
              cancel: cancel,
              guard: (_) {
                cancel.complete();
                return true;
              },
            )
            as KlpNavigationStart;
    expect(result.machine, isNull);
    expect(result.decision.outcome, isA<KlpNavigationCancelled<void>>());
    expect(commits, isEmpty);
  });

  test(
    'initial commit failures preserve declared authority and reject unknown authority',
    () {
      final cancel = Completer<void>();
      final signal = KlpNavigationCancellation(
        cancel.future,
        () => cancel.isCompleted,
      );
      for (final committed in [false, true]) {
        final result =
            KlpNavigationMachine.start(
                  policies: [KlpRoutePolicy(destination: home)],
                  initial: home.location(0),
                  cancellation: signal,
                  commit: (_, {required replaceRouteInformation}) =>
                      throw KlpNavigationCommitException(
                        committed,
                        StateError('commit'),
                        StackTrace.current,
                      ),
                )
                as KlpNavigationStart;
        expect(result.decision.committed, committed);
        expect(result.decision.outcome, isA<KlpNavigationFailed<void>>());
        expect(result.machine == null, !committed);
        result.machine?.dispose();
      }
      expect(
        () => KlpNavigationMachine.start(
          policies: [KlpRoutePolicy(destination: home)],
          initial: home.location(0),
          cancellation: signal,
          commit: (_, {required replaceRouteInformation}) =>
              throw StateError('unknown'),
        ),
        throwsA(isA<KlpNavigationCommitContractException>()),
      );
    },
  );
}
