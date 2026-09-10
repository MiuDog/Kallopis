import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/capabilities/navigation/internal/klp_navigation_machine.dart';
import 'package:kallopis/src/capabilities/navigation/klp_destination.dart';
import 'package:kallopis/src/capabilities/navigation/klp_location.dart';
import 'package:kallopis/src/capabilities/navigation/klp_navigation_outcome.dart';
import 'package:kallopis/src/capabilities/navigation/klp_navigation_snapshot.dart';
import 'package:kallopis/src/capabilities/navigation/klp_route_policy.dart';

import 'support/klp_navigation_fixture.dart';

void main() {
	late KlpDestination<int, String?> home;
	late KlpDestination<int, String?> detail;
	late List<KlpNavigationSnapshot> commits;
	late KlpNavigationMachine machine;

	setUp(() {
		home = KlpDestination('home');
		detail = KlpDestination('detail');
		commits = [];
		machine = klpNavigationTestMachine(policies: [KlpRoutePolicy(destination: home), KlpRoutePolicy(destination: detail)], initial: home.location(0), commit: commits.add);
	});

	tearDown(() => machine.dispose());

	test('retains entry identity and completes nullable results exactly once', () async {
		final original = machine.state.value.current;
		final first = machine.push(detail.location(1));
		expect((await first.decision).committed, isTrue);
		final second = machine.push(detail.location(2));
		expect((await second.decision).committed, isTrue);
		expect(machine.state.value.entries.map((entry) => entry.id).toSet(), hasLength(3));
		expect(() => machine.state.value.entries.clear(), throwsUnsupportedError);
		expect((await machine.complete(detail, null)).committed, isTrue);
		expect(await second.result, isA<KlpNavigationCompleted<String?>>().having((outcome) => outcome.value, 'value', isNull));
		expect((await machine.pop()).committed, isTrue);
		expect(await first.result, isA<KlpNavigationCancelled<String?>>());
		expect(machine.state.value.current, same(original));
		expect((await machine.pop()).committed, isFalse);
		expect(commits, hasLength(5));
	});

	test('validates original generic types after widening', () async {
		final KlpDestination<Object?, Object?> widened = detail;
		expect(widened.acceptsParameters('bad'), isFalse);
		expect(() => widened.location('bad'), throwsA(anything));
		expect(() => KlpLocation(widened, 'bad'), throwsArgumentError);
		final ticket = machine.push(detail.location(1));
		await ticket.decision;
		final decision = await machine.complete<Object?>(widened, 42);
		expect(decision.committed, isFalse);
		expect(decision.outcome, isA<KlpNavigationRejected<void>>());
		expect(machine.state.value.entries, hasLength(2));
		expect((await machine.complete(home, 'wrong destination')).committed, isFalse);
	});

	test('same text identity does not impersonate a registered destination', () async {
		final impostor = KlpDestination<int, String?>('detail');
		final ticket = machine.push(impostor.location(1));
		expect((await ticket.decision).committed, isFalse);
		expect(await ticket.result, isA<KlpNavigationFailed<String?>>());
		expect(commits, hasLength(1));
	});

	test('pending guards preserve state and reject concurrent requests', () async {
		final guard = Completer<bool>();
		machine.replacePolicies([KlpRoutePolicy(destination: home), KlpRoutePolicy(destination: detail, beforeEnter: (_) => guard.future)]);
		final ticket = machine.push(detail.location(1));
		final busy = machine.push(detail.location(2));
		expect((await busy.decision).outcome, isA<KlpNavigationRejected<void>>().having((outcome) => outcome.reason, 'reason', 'busy'));
		expect(await busy.result, isA<KlpNavigationRejected<String?>>());
		expect(machine.state.value.entries, hasLength(1));
		expect(commits, hasLength(1));
		guard.complete(false);
		expect((await ticket.decision).committed, isFalse);
		expect(await ticket.result, isA<KlpNavigationRejected<String?>>());
	});

	test('explicit cancellation settles without waiting for a guard', () async {
		final guard = Completer<bool>();
		machine.replacePolicies([KlpRoutePolicy(destination: home), KlpRoutePolicy(destination: detail, beforeEnter: (_) => guard.future)]);
		final ticket = machine.push(detail.location(1));
		ticket.cancel();
		expect((await ticket.decision).outcome, isA<KlpNavigationCancelled<void>>());
		expect(await ticket.result, isA<KlpNavigationCancelled<String?>>());
		guard.complete(true);
		await Future<void>.delayed(Duration.zero);
		expect(commits, hasLength(1));
	});

	test('source replacement invalidates pending guards and ignores late failures', () async {
		final guard = Completer<bool>();
		machine.replacePolicies([KlpRoutePolicy(destination: home), KlpRoutePolicy(destination: detail, beforeEnter: (_) => guard.future)]);
		final ticket = machine.push(detail.location(1));
		machine.replacePolicies([KlpRoutePolicy(destination: home), KlpRoutePolicy(destination: detail)]);
		expect((await ticket.decision).outcome, isA<KlpNavigationCancelled<void>>());
		final next = machine.push(detail.location(2));
		expect((await next.decision).committed, isTrue);
		guard.completeError(StateError('late'));
		await Future<void>.delayed(Duration.zero);
		expect(machine.state.value.current.location.parameters, 2);
		expect(commits, hasLength(2));
	});

	test('registry replacement cannot remove retained destinations or duplicate IDs', () async {
		final ticket = machine.push(detail.location(1));
		await ticket.decision;
		expect(() => machine.replacePolicies([KlpRoutePolicy(destination: home)]), throwsArgumentError);
		expect(() => machine.replacePolicies([KlpRoutePolicy(destination: home), KlpRoutePolicy(destination: home)]), throwsArgumentError);
		expect(machine.state.value.entries, hasLength(2));
		expect((await machine.pop()).committed, isTrue);
	});

	test('leave guard rejection does not complete the retained screen result', () async {
		final ticket = machine.push(detail.location(1));
		await ticket.decision;
		var completed = false;
		ticket.result.then((_) => completed = true);
		machine.replacePolicies([KlpRoutePolicy(destination: home), KlpRoutePolicy(destination: detail, beforeLeave: (_) => false)]);
		expect((await machine.pop()).committed, isFalse);
		await Future<void>.delayed(Duration.zero);
		expect(completed, isFalse);
		expect(machine.state.value.entries, hasLength(2));
	});

	test('restoration runs every candidate guard and cancels replaced results', () async {
		final entered = <int>[];
		machine.replacePolicies([
			KlpRoutePolicy(destination: home, beforeEnter: (transition) {
				entered.add(transition.to.entries.last.location.parameters as int);
				return true;
			}),
			KlpRoutePolicy(destination: detail, beforeEnter: (transition) {
				entered.add(transition.to.entries.last.location.parameters as int);
				return true;
			}),
		]);
		final retained = machine.push(detail.location(1));
		await retained.decision;
		final restored = await machine.restore([home.location(2), detail.location(3)]);
		expect(restored.committed, isTrue);
		expect(machine.state.value.entries.map((entry) => entry.location.parameters), [2, 3]);
		expect(entered, [1, 3, 3]);
		expect(await retained.result, isA<KlpNavigationCancelled<String?>>().having((outcome) => outcome.reason, 'reason', 'restored'));
	});

	test('dispose settles pending and retained results and revokes the state', () async {
		final retained = machine.push(detail.location(1));
		await retained.decision;
		final guard = Completer<bool>();
		machine.replacePolicies([KlpRoutePolicy(destination: home), KlpRoutePolicy(destination: detail, beforeEnter: (_) => guard.future)]);
		final pending = machine.push(detail.location(2));
		machine.dispose();
		expect(await retained.result, isA<KlpNavigationCancelled<String?>>());
		expect(await pending.result, isA<KlpNavigationCancelled<String?>>());
		expect((await pending.decision).committed, isFalse);
		expect(() => machine.state.value, throwsStateError);
		guard.complete(true);
		await Future<void>.delayed(Duration.zero);
		expect(commits, hasLength(2));
	});
}
