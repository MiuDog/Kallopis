import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/capabilities/navigation/internal/klp_navigation_commit_exception.dart';
import 'package:kallopis/src/capabilities/navigation/internal/klp_navigation_commit_contract_exception.dart';
import 'package:kallopis/src/capabilities/navigation/internal/klp_navigation_machine.dart';
import 'package:kallopis/src/capabilities/navigation/klp_destination.dart';
import 'package:kallopis/src/capabilities/navigation/klp_navigation_outcome.dart';
import 'package:kallopis/src/capabilities/navigation/klp_route_policy.dart';

import 'support/klp_navigation_fixture.dart';

void main() {
	for (final committed in [false, true]) {
		test('commit failure preserves actual commit status $committed', () async {
			final home = KlpDestination<int, String>('home');
			final detail = KlpDestination<int, String>('detail');
			final machine = klpNavigationTestMachine(policies: [KlpRoutePolicy(destination: home), KlpRoutePolicy(destination: detail)], initial: home.location(0), commit: (snapshot) {
				if (snapshot.revision > 0) throw KlpNavigationCommitException(committed, StateError('commit'), StackTrace.current);
			});
			addTearDown(machine.dispose);
			final ticket = machine.push(detail.location(1));
			final decision = await ticket.decision;
			expect(decision.committed, committed);
			expect(decision.outcome, isA<KlpNavigationFailed<void>>());
			expect(machine.state.value.entries, hasLength(committed ? 2 : 1));
			machine.dispose();
			expect(await ticket.result, committed ? isA<KlpNavigationCancelled<String>>() : isA<KlpNavigationFailed<String>>());
		});
	}

	test('state listener failure still commits stack and preserves result delivery', () async {
		final home = KlpDestination<int, String>('home');
		final detail = KlpDestination<int, String>('detail');
		final machine = klpNavigationTestMachine(policies: [KlpRoutePolicy(destination: home), KlpRoutePolicy(destination: detail)], initial: home.location(0), commit: (_) {});
		addTearDown(machine.dispose);
		var observed = 0;
		machine.state.subscribe((_) => throw StateError('listener'));
		machine.state.subscribe((_) => observed++);
		final ticket = machine.push(detail.location(1));
		final decision = await ticket.decision;
		expect(decision.committed, isTrue);
		expect(decision.outcome, isA<KlpNavigationFailed<void>>());
		expect(observed, 1);
		expect((await machine.complete(detail, 'saved')).committed, isTrue);
		expect(await ticket.result, isA<KlpNavigationCompleted<String>>().having((outcome) => outcome.value, 'value', 'saved'));
		expect(observed, 2);
	});

	test('guard failure leaves stack and commit port unchanged', () async {
		final home = KlpDestination<int, String>('home');
		final detail = KlpDestination<int, String>('detail');
		var commits = 0;
		final machine = klpNavigationTestMachine(policies: [KlpRoutePolicy(destination: home), KlpRoutePolicy(destination: detail, beforeEnter: (_) => throw StateError('guard'))], initial: home.location(0), commit: (_) => commits++);
		addTearDown(machine.dispose);
		final ticket = machine.push(detail.location(1));
		expect((await ticket.decision).committed, isFalse);
		expect(await ticket.result, isA<KlpNavigationFailed<String>>());
		expect(commits, 1);
	});

	test('initial committed notification error retains usable initial state', () {
		final home = KlpDestination<int, String>('home');
		final machine = klpNavigationTestMachine(policies: [KlpRoutePolicy(destination: home)], initial: home.location(0), commit: (_) => throw KlpNavigationCommitException(true, StateError('notification'), StackTrace.current));
		addTearDown(machine.dispose);
		expect(machine.initialDecision.committed, isTrue);
		expect(machine.initialDecision.outcome, isA<KlpNavigationFailed<void>>());
		expect(machine.state.value.current.location.destination, same(home));
	});

	test('unclassified commit failure revokes the machine without claiming rollback', () async {
		final home = KlpDestination<int, String>('home');
		final detail = KlpDestination<int, String>('detail');
		final machine = klpNavigationTestMachine(policies: [KlpRoutePolicy(destination: home), KlpRoutePolicy(destination: detail)], initial: home.location(0), commit: (snapshot) {
			if (snapshot.revision > 1) throw StateError('unclassified commit');
		});
		final retained = machine.push(detail.location(1));
		await retained.decision;
		final ticket = machine.push(detail.location(2));
		await expectLater(ticket.decision, throwsA(isA<KlpNavigationCommitContractException>()));
		expect(await ticket.result, isA<KlpNavigationFailed<String>>());
		expect(await retained.result, isA<KlpNavigationCancelled<String>>());
		expect(machine.isDisposed, isTrue);
		expect(() => machine.state.value, throwsStateError);
	});

	test('guard reentry is busy and repeated cancellation resolves once', () async {
		final home = KlpDestination<int, String>('home');
		final detail = KlpDestination<int, String>('detail');
		late KlpNavigationMachine machine;
		machine = klpNavigationTestMachine(policies: [KlpRoutePolicy(destination: home), KlpRoutePolicy(destination: detail, beforeEnter: (_) async {
			final nested = machine.push(detail.location(2));
			expect((await nested.decision).outcome, isA<KlpNavigationRejected<void>>());
			return true;
		})], initial: home.location(0), commit: (_) {});
		addTearDown(machine.dispose);
		final ticket = machine.push(detail.location(1));
		var results = 0;
		ticket.result.then((_) => results++);
		ticket.cancel();
		ticket.cancel();
		expect((await ticket.decision).committed, isFalse);
		await ticket.result;
		expect(results, 1);
		expect(machine.state.value.entries, hasLength(1));
	});
}
