import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/capabilities/navigation/internal/klp_navigation_commit_exception.dart';
import 'package:kallopis/src/capabilities/navigation/internal/klp_navigation_commit_contract_exception.dart';
import 'package:kallopis/src/capabilities/navigation/klp_destination.dart';
import 'package:kallopis/src/capabilities/navigation/klp_location.dart';
import 'package:kallopis/src/capabilities/navigation/klp_navigation_decision.dart';
import 'package:kallopis/src/capabilities/navigation/klp_navigation_outcome.dart';
import 'package:kallopis/src/capabilities/navigation/klp_route_policy.dart';

import 'support/klp_navigation_fixture.dart';

void main() {
	test('public location retains original parameter validator after explicit widening', () {
		final narrow = KlpDestination<int, String>('detail');
		final KlpDestination<Object?, Object?> wide = narrow;
		expect(() => KlpLocation<Object?>(wide, 'wrong'), throwsArgumentError);
		expect(() => KlpLocation<Object?>(wide, null), throwsArgumentError);
		final location = KlpLocation<Object?>(wide, 42);
		expect(location.destination, same(narrow));
		expect(location.parameters, 42);
	});

	test('unclassified removal failure settles the current retained ticket', () async {
		final home = KlpDestination<int, String>('home');
		final detail = KlpDestination<int, String>('detail');
		final machine = klpNavigationTestMachine(policies: [KlpRoutePolicy(destination: home), KlpRoutePolicy(destination: detail)], initial: home.location(0), commit: (snapshot) {
			if (snapshot.revision == 2) throw StateError('unknown removal status');
		});
		addTearDown(machine.dispose);
		final current = machine.push(detail.location(1));
		await current.decision;
		await expectLater(machine.complete(detail, 'saved'), throwsA(isA<KlpNavigationCommitContractException>()));
		expect(machine.isDisposed, isTrue);
		expect(await current.result, isA<KlpNavigationCancelled<String>>().having((value) => value.reason, 'reason', 'disposed'));
		current.cancel();
	});

	for (final committed in [false, true]) {
		test('complete failure settles results according to commit authority $committed', () async {
			final home = KlpDestination<int, String>('home');
			final detail = KlpDestination<int, String>('detail');
			var fail = false;
			final machine = klpNavigationTestMachine(policies: [KlpRoutePolicy(destination: home), KlpRoutePolicy(destination: detail)], initial: home.location(0), commit: (_) {
				if (fail) throw KlpNavigationCommitException(committed, StateError('remove'), StackTrace.current);
			});
			addTearDown(machine.dispose);
			final ticket = machine.push(detail.location(1));
			await ticket.decision;
			var resultCount = 0;
			ticket.result.then((_) => resultCount++);
			fail = true;
			final decision = await machine.complete(detail, 'saved');
			expect(decision.committed, committed);
			expect(decision.outcome, isA<KlpNavigationFailed<void>>());
			expect(machine.state.value.entries.length, committed ? 1 : 2);
			await Future<void>.delayed(Duration.zero);
			expect(resultCount, committed ? 1 : 0);
			if (!committed) {
				fail = false;
				expect((await machine.complete(detail, 'retried')).committed, isTrue);
			}
			final outcome = await ticket.result;
			expect(outcome, isA<KlpNavigationCompleted<String>>().having((value) => value.value, 'value', committed ? 'saved' : 'retried'));
			ticket.cancel();
			machine.dispose();
			await Future<void>.delayed(Duration.zero);
			expect(resultCount, 1);
		});
	}

	test('cancelled pending pop preserves retained result until a later valid removal', () async {
		final home = KlpDestination<int, String>('home');
		final detail = KlpDestination<int, String>('detail');
		final gate = Completer<bool>();
		final machine = klpNavigationTestMachine(policies: [KlpRoutePolicy(destination: home), KlpRoutePolicy(destination: detail, beforeLeave: (_) => gate.future)], initial: home.location(0), commit: (_) {});
		addTearDown(machine.dispose);
		final retained = machine.push(detail.location(1));
		await retained.decision;
		var resultCount = 0;
		retained.result.then((_) => resultCount++);
		final removal = machine.pop();
		machine.invalidatePending();
		expect((await removal).outcome, isA<KlpNavigationCancelled<void>>());
		gate.completeError(StateError('late failure'));
		await Future<void>.delayed(Duration.zero);
		expect(resultCount, 0);
		expect(machine.state.value.entries, hasLength(2));
		machine.replacePolicies([KlpRoutePolicy(destination: home), KlpRoutePolicy(destination: detail)]);
		expect((await machine.complete(detail, 'saved')).committed, isTrue);
		expect(await retained.result, isA<KlpNavigationCompleted<String>>());
	});

	test('cancelled leave guard cannot invoke an enter guard after replacement', () async {
		final home = KlpDestination<int, String>('home');
		final detail = KlpDestination<int, String>('detail');
		final leave = Completer<bool>();
		var enterCalls = 0;
		var commitCalls = 0;
		final machine = klpNavigationTestMachine(policies: [KlpRoutePolicy(destination: home, beforeLeave: (_) => leave.future), KlpRoutePolicy(destination: detail, beforeEnter: (_) { enterCalls++; return true; })], initial: home.location(0), commit: (_) => commitCalls++);
		addTearDown(machine.dispose);
		final stale = machine.push(detail.location(1));
		machine.replacePolicies([KlpRoutePolicy(destination: home), KlpRoutePolicy(destination: detail)]);
		final current = machine.push(detail.location(2));
		expect((await current.decision).committed, isTrue);
		leave.complete(true);
		await Future<void>.delayed(Duration.zero);
		expect((await stale.decision).committed, isFalse);
		expect(await stale.result, isA<KlpNavigationCancelled<String>>());
		expect(enterCalls, 0);
		expect(commitCalls, 2);
		expect(machine.state.value.current.location.parameters, 2);
	});

	test('commit notification cannot reenter removal or dispose the active transaction', () async {
		final home = KlpDestination<int, String>('home');
		final detail = KlpDestination<int, String>('detail');
		final machine = klpNavigationTestMachine(policies: [KlpRoutePolicy(destination: home), KlpRoutePolicy(destination: detail)], initial: home.location(0), commit: (_) {});
		addTearDown(machine.dispose);
		final nested = <Future<KlpNavigationDecision>>[];
		final subscription = machine.state.subscribe((_) {
			nested.add(machine.pop());
			machine.dispose();
		});
		final ticket = machine.push(detail.location(1));
		final decision = await ticket.decision;
		expect(decision.committed, isTrue);
		expect(decision.outcome, isA<KlpNavigationFailed<void>>());
		expect((await nested.single).outcome, isA<KlpNavigationRejected<void>>().having((value) => value.reason, 'reason', 'busy'));
		expect(machine.isDisposed, isFalse);
		expect(machine.state.value.entries, hasLength(2));
		subscription.cancel();
		expect((await machine.complete(detail, 'saved')).committed, isTrue);
		expect(await ticket.result, isA<KlpNavigationCompleted<String>>());
	});
}
