import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';

void main() {
	group('KlpAsyncData', () {
		test('starts idle and exposes a stable read only source', () async {
			final owner = KlpAsyncData<int?>();
			addTearDown(owner.dispose);
			expect(owner.state.value, isA<KlpDataIdle<int?>>());
			expect(identical(owner.state, owner.state), isTrue);
			expect(owner.state, isNot(isA<KlpMutableState<KlpDataState<int?>>>()));
			await owner.load(() async => null);
			expect((owner.state.value as KlpDataValue<int?>).value, isNull);
		});

		test('loading replaces old data and completion follows publication', () async {
			final owner = KlpAsyncData<int>();
			addTearDown(owner.dispose);
			await owner.load(() async => 1);
			final events = <KlpDataState<int>>[];
			owner.state.subscribe(events.add);
			final request = Completer<int>();
			final done = owner.load(() => request.future);
			expect(owner.state.value, isA<KlpDataLoading<int>>());
			expect(events, hasLength(1));
			request.complete(2);
			await done;
			expect((owner.state.value as KlpDataValue<int>).value, 2);
			expect(events.last, same(owner.state.value));
		});

		test('latest request wins even when old request finishes last', () async {
			final owner = KlpAsyncData<int>();
			addTearDown(owner.dispose);
			final first = Completer<int>();
			final old = owner.load(() => first.future);
			await owner.load(() async => 2);
			final adopted = owner.state.value;
			first.complete(1);
			await old;
			expect(owner.state.value, same(adopted));
			expect((adopted as KlpDataValue<int>).value, 2);
		});

		test('cancel invalidates late errors without cancelling operation', () async {
			final owner = KlpAsyncData<int>();
			addTearDown(owner.dispose);
			final request = Completer<int>();
			var finished = false;
			final done = owner.load(() => request.future).then((_) => finished = true);
			owner.cancel();
			owner.cancel();
			await Future<void>.value();
			expect(finished, isFalse);
			expect(owner.state.value, isA<KlpDataIdle<int>>());
			await owner.load(() async => 3);
			request.completeError(StateError('late'));
			await done;
			expect((owner.state.value as KlpDataValue<int>).value, 3);
			owner.cancel();
			expect((owner.state.value as KlpDataValue<int>).value, 3);
		});

		test('sync and async operation errors preserve original traces', () async {
			final owner = KlpAsyncData<int>();
			addTearDown(owner.dispose);
			final error = StateError('source');
			final trace = StackTrace.fromString('original source');
			await owner.load(() => Error.throwWithStackTrace(error, trace));
			var failure = owner.state.value as KlpDataFailure<int>;
			expect(failure.error, same(error));
			expect(failure.stackTrace, same(trace));
			await owner.load(() => Future<int>.error(error, trace));
			failure = owner.state.value as KlpDataFailure<int>;
			expect(failure.error, same(error));
			expect(failure.stackTrace, same(trace));
			await owner.load(() async => 4);
			expect((owner.state.value as KlpDataValue<int>).value, 4);
		});

		test('dispose cancels subscriptions and rejects subsequent use', () async {
			final owner = KlpAsyncData<int>();
			final events = <KlpDataState<int>>[];
			final subscription = owner.state.subscribe(events.add);
			final request = Completer<int>();
			final done = owner.load(() => request.future);
			owner.dispose();
			owner.dispose();
			request.complete(1);
			await done;
			expect(events, hasLength(1));
			expect(subscription.isCancelled, isTrue);
			expect(owner.isDisposed, isTrue);
			expect(() => owner.state.value, throwsStateError);
			expect(owner.cancel, throwsStateError);
			await expectLater(owner.load(() async => 2), throwsStateError);
		});

		test('cancel or disposal during loading notification prevents start', () async {
			for (final dispose in [false, true]) {
				final owner = KlpAsyncData<int>();
				addTearDown(owner.dispose);
				var started = false;
				owner.state.subscribe((value) {
					if (value is! KlpDataLoading<int>) return;

					if (dispose) {
						owner.dispose();
					}
					else {
						owner.cancel();
					}
				});
				await owner.load(() async {
					started = true;
					return 1;
				});
				expect(started, isFalse);
			}
		});

		test('publication listener errors are not data operation failures', () async {
			final owner = KlpAsyncData<int>();
			addTearDown(owner.dispose);
			owner.state.subscribe((value) {
				if (value is KlpDataValue<int>) throw StateError('listener');
			});
			await expectLater(owner.load(() async => 1), throwsStateError);
			expect((owner.state.value as KlpDataValue<int>).value, 1);
		});

		test('replacement during notification prevents superseded operation', () async {
			final owner = KlpAsyncData<int>();
			addTearDown(owner.dispose);
			var replaced = false;
			var staleStarted = false;
			late Future<void> replacement;
			owner.state.subscribe((value) {
				if (value is! KlpDataLoading<int> || replaced) return;

				replaced = true;
				replacement = owner.load(() async => 8);
			});
			await owner.load(() async {
				staleStarted = true;
				return 1;
			});
			await replacement;
			expect(staleStarted, isFalse);
			expect((owner.state.value as KlpDataValue<int>).value, 8);
		});
	});
}
