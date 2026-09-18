import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_drawing.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_intent.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_reply.dart';
import 'package:kallopis/src/features/editing/contracts/klp_editing_host_failure.dart';
import 'package:kallopis/src/rendering/flutter/klp_flutter_renderer.dart';

import 'support/klp_editing_lifecycle_fixture.dart';
import 'support/klp_renderer_fixture.dart';

void main() {
	for (final outcome in ['accepted', 'rejected', 'throw']) {
		for (final transition in ['swap', 'dispose', 'overlapping swaps', 'swap then dispose']) {
			testWidgets('$transition releases captured binding once after pending $outcome cancellation', (tester) async {
				final first = KlpLifecycleSource('first');
				final second = KlpLifecycleSource('second', composing: false, failures: first.failures);
				final third = KlpLifecycleSource('third', composing: false, failures: first.failures);
				for (final source in [first, second, third]) {
					addTearDown(source.disposeFixture);
				}
				final pending = Completer<KlpEditingReply>();
				final error = StateError('cancel transport failed');
				final stack = StackTrace.fromString('cancel-original-stack');
				first.onSubmit = (_) => pending.future;
				await mountKlpLifecycle(tester, first);
				final staleClient = klpLifecycleClient(tester);
				final firstBinding = first.bindings.single;

				// 中斷結果未決前，切换及卸載可以交錯，但不可重複取消。
				if (transition == 'dispose') {
					await tester.pumpWidget(const SizedBox.shrink());
				}
				else {
					await tester.pumpWidget(klpLifecycleHost(second));
					if (transition == 'overlapping swaps') await tester.pumpWidget(klpLifecycleHost(third));
					if (transition == 'swap then dispose') await tester.pumpWidget(const SizedBox.shrink());
				}
				expect(first.requests.map((request) => request.intent), [isA<KlpCancelCompositionIntent>()]);
				expect(firstBinding.closes, 0);
				if (outcome == 'throw') {
					pending.completeError(error, stack);
				}
				else {
					final decision = outcome == 'accepted' ? KlpEditingDecision.accepted : KlpEditingDecision.rejected;
					pending.complete(KlpEditingReply(decision, first.frame(revision: 1, composing: outcome == 'rejected')));
				}
				await tester.pump();
				await tester.pump();
				expect(firstBinding.closes, 1, reason: '中斷失敗仍須釋放捕捉的舊 binding；重疊觀察者只能共同釋放一次');
				expect(first.requests, hasLength(1), reason: '未知或拒絕的取消不可重試');
				if (outcome == 'accepted') {
					expect(first.failures, isEmpty);
				}
				else {
					expect(first.failures, hasLength(1));
					expect(first.failures.single.origin, KlpEditingHostOrigin.textInput);
					expect(first.failures.single.phase, KlpEditingHostPhase.interrupt);
					if (outcome == 'throw') {
						expect(first.failures.single.error, same(error));
						expect(first.failures.single.stackTrace, same(stack));
					}
				}

				// 最新來源只能綁定一組存活 handles，舊 continuation 不得釋放它。
				if (transition == 'swap' || transition == 'overlapping swaps') {
					final current = transition == 'swap' ? second : third;
					expect(current.bindings, hasLength(1));
					expect(current.bindings.single.closes, 0);
					if (transition == 'overlapping swaps') expect(second.bindings, isEmpty);
					await tester.pumpWidget(const SizedBox.shrink());
					await tester.pump();
					expect(current.bindings.single.closes, 1);
				}
				expect(tester.testTextInput.hasAnyClients, isFalse);
				staleClient.updateEditingValueWithDeltas(const [klpLifecycleInsert]);
				await tester.pump();
				expect(first.requests, hasLength(1));
				expect(firstBinding.closes, 1);
				for (final source in [first, second, third]) {
					expect(source.drawing.isDisposed, isFalse);
					expect((source.providerCloses, source.providerSaves), (0, 0));
				}
				expect(tester.takeException(), isNull);
			});
		}
	}

	for (final transition in ['swap', 'dispose']) {
		testWidgets('late accepted input after $transition cannot send final selection or another delta', (tester) async {
			final source = KlpLifecycleSource('old', composing: false);
			final next = KlpLifecycleSource('new', composing: false, failures: source.failures);
			addTearDown(source.disposeFixture);
			addTearDown(next.disposeFixture);
			final pending = Completer<KlpEditingReply>();
			source.onSubmit = (_) => pending.future;
			await mountKlpLifecycle(tester, source);
			final client = klpLifecycleClient(tester);
			client.updateEditingValueWithDeltas(const [klpLifecycleInsert, klpLifecycleInsert]);
			await tester.pump();
			expect(source.requests, hasLength(1));
			await tester.pumpWidget(transition == 'swap' ? klpLifecycleHost(next) : const SizedBox.shrink());
			expect(source.bindings.single.closes, 0);

			// 已開始的替換回覆確認後，舊世代仍不得提交游標修正或第二筆 delta。
			pending.complete(KlpEditingReply(KlpEditingDecision.accepted, source.frame(revision: 1, contentRevision: 1, text: 'xab', caret: 0)));
			await tester.pump();
			await tester.pump();
			expect(source.requests, hasLength(1));
			expect(source.bindings.single.closes, 1);
			expect(source.failures, isEmpty);
			if (transition == 'swap') {
				expect(next.bindings, hasLength(1));
				expect(next.bindings.single.closes, 0);
			}
			await tester.pumpWidget(const SizedBox.shrink());
			await tester.pump();
			expect(tester.testTextInput.hasAnyClients, isFalse);
			expect(tester.takeException(), isNull);
		});
	}

	testWidgets('focus lifecycle swap and dispose observers report one original interruption failure', (tester) async {
		final source = KlpLifecycleSource('old');
		final next = KlpLifecycleSource('new', composing: false, failures: source.failures);
		addTearDown(source.disposeFixture);
		addTearDown(next.disposeFixture);
		final pending = Completer<KlpEditingReply>();
		final error = StateError('unknown cancellation');
		final stack = StackTrace.fromString('shared-interrupt-stack');
		source.onSubmit = (_) => pending.future;
		await mountKlpLifecycle(tester, source);
		final interaction = source.bindings.single.interaction;
		final waiting = expectLater(interaction.interrupt(), throwsA(same(error)));
		FocusManager.instance.primaryFocus!.unfocus();
		tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
		await tester.pumpWidget(klpLifecycleHost(next));
		await tester.pumpWidget(const SizedBox.shrink());
		pending.completeError(error, stack);
		await tester.pump();
		await waiting;
		expect(source.requests, hasLength(1));
		expect(source.bindings.single.closes, 1);
		expect(source.failures, hasLength(1));
		expect(source.failures.single.error, same(error));
		expect(source.failures.single.stackTrace, same(stack));
		expect(source.failures.single.phase, KlpEditingHostPhase.interrupt);
		expect(next.bindings, isEmpty);
		expect(tester.testTextInput.hasAnyClients, isFalse);
		tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
		expect(tester.takeException(), isNull);
	});

	for (final outcome in ['throw', 'rejected']) {
		testWidgets('platform batch $outcome retains typed outcome and forwards original errors once', (tester) async {
			final source = KlpLifecycleSource('input', composing: false);
			addTearDown(source.disposeFixture);
			final error = StateError('input transport');
			final stack = StackTrace.fromString('input-original-stack');
			source.onSubmit = (_) {
				if (outcome == 'throw') Error.throwWithStackTrace(error, stack);
				return KlpEditingReply(KlpEditingDecision.rejected, source.drawing.value.projection);
			};
			await mountKlpLifecycle(tester, source);
			klpLifecycleClient(tester).updateEditingValueWithDeltas(const [klpLifecycleInsert, klpLifecycleInsert]);
			await tester.pump();
			expect(source.requests, hasLength(1));
			if (outcome == 'throw') {
				expect(source.failures, hasLength(1));
				expect(source.failures.single.error, same(error));
				expect(source.failures.single.stackTrace, same(stack));
				expect(source.failures.single.phase, KlpEditingHostPhase.input);
			}
			else {
				expect(source.failures, isEmpty, reason: '沒有 error 的 typed rejection 不得變成 exception');
			}
			await tester.pumpWidget(const SizedBox.shrink());
			await tester.pump();
			expect(source.bindings.single.closes, 1);
			expect(source.failures.where((failure) => identical(failure.error, error)), hasLength(outcome == 'throw' ? 1 : 0));
			expect(tester.takeException(), isNull);
		});
	}

	testWidgets('newer rejection reply waits for drawing publication without treating cached drawing as a regression', (tester) async {
		final source = KlpLifecycleSource('delayed-drawing', composing: false);
		addTearDown(source.disposeFixture);
		final initialDrawing = source.drawing.value;
		final rejection = source.frame(revision: 1);
		source.onSubmit = (_) => KlpEditingReply(KlpEditingDecision.rejected, rejection);
		await mountKlpLifecycle(tester, source);
		klpLifecycleClient(tester).updateEditingValueWithDeltas(const [klpLifecycleInsert]);
		await tester.pump();
		expect(source.requests, hasLength(1));
		expect(source.drawing.value, same(initialDrawing));
		expect(source.failures, isEmpty, reason: '新回覆已確認，但舊快取不是新發布；不可用它向後同步');

		// 合法的繪圖發布稍後追上回覆；同步後必須仍可繼續輸入。
		source.drawing.value = KlpEditingDrawing(projection: rejection, width: 800, height: 600, commands: const []);
		await tester.pump();
		expect(source.failures, isEmpty);
		final accepted = source.frame(revision: 2, contentRevision: 1, text: 'xab', caret: 1);
		source.onSubmit = (_) {
			source.drawing.value = KlpEditingDrawing(projection: accepted, width: 800, height: 600, commands: const []);
			return KlpEditingReply(KlpEditingDecision.accepted, accepted);
		};
		klpLifecycleClient(tester).updateEditingValueWithDeltas(const [klpLifecycleInsert]);
		await tester.pump();
		expect(source.requests, hasLength(2));
		expect(source.failures, isEmpty);

		// 真正發布較舊權威仍屬錯誤，不能以略過快取為由取消訂閱端驗證。
		source.drawing.value = initialDrawing;
		await tester.pump();
		expect(source.failures, hasLength(1));
		expect(source.failures.single.origin, KlpEditingHostOrigin.textInput);
		expect(source.failures.single.phase, KlpEditingHostPhase.input);
		expect(source.failures.single.error, isA<StateError>());
		await tester.pumpWidget(const SizedBox.shrink());
		await tester.pump();
		expect(source.bindings.single.closes, 1);
		expect(tester.testTextInput.hasAnyClients, isFalse);
		expect(tester.takeException(), isNull);
	});

	testWidgets('local binding close failure reports dispose and keeps replacement usable', (tester) async {
		final source = KlpLifecycleSource('old', composing: false);
		final next = KlpLifecycleSource('new', composing: false, failures: source.failures);
		addTearDown(source.disposeFixture);
		addTearDown(next.disposeFixture);
		final error = StateError('binding close');
		final stack = StackTrace.fromString('binding-close-original-stack');
		await mountKlpLifecycle(tester, source);
		source.bindings.single..closeError = error..closeStack = stack;
		await tester.pumpWidget(klpLifecycleHost(next));
		await tester.pump();
		expect(source.bindings.single.closes, 1);
		expect(source.failures, hasLength(1));
		expect(source.failures.single.error, same(error));
		expect(source.failures.single.stackTrace, same(stack));
		expect(source.failures.single.phase, KlpEditingHostPhase.dispose);
		expect(next.bindings, hasLength(1));
		expect(next.bindings.single.closes, 0);
		await tester.pumpWidget(const SizedBox.shrink());
		await tester.pump();
		expect(next.bindings.single.closes, 1);
		expect(tester.testTextInput.hasAnyClients, isFalse);
		expect(tester.takeException(), isNull);
	});

	testWidgets('mounted text host refreshes installed sink and uses it after detach', (tester) async {
		final source = KlpLifecycleSource('retained');
		addTearDown(source.disposeFixture);
		final replacementSink = <KlpEditingHostFailure>[];
		final pending = Completer<KlpEditingReply>();
		final error = StateError('late after sink replacement');
		final stack = StackTrace.fromString('replacement-sink-stack');
		source.onSubmit = (_) => pending.future;
		await mountKlpLifecycle(tester, source);
		await tester.pumpWidget(klpRendererHost(source.content, onEditingHostFailure: replacementSink.add));
		expect(source.bindings, hasLength(1));
		final waiting = expectLater(source.bindings.single.interaction.interrupt(), throwsA(same(error)));
		await tester.pump();
		await tester.pumpWidget(const SizedBox.shrink());
		pending.completeError(error, stack);
		await tester.pump();
		await waiting;
		expect(source.failures, isEmpty);
		expect(replacementSink, hasLength(1));
		expect(replacementSink.single.error, same(error));
		expect(replacementSink.single.stackTrace, same(stack));
		expect(replacementSink.single.phase, KlpEditingHostPhase.interrupt);
		expect(source.bindings.single.closes, 1);
		expect(tester.takeException(), isNull);
	});

	testWidgets('editing host without viewport capabilities fails explicitly', (tester) async {
		final source = KlpLifecycleSource('missing-host', composing: false);
		addTearDown(source.disposeFixture);
		await tester.pumpWidget(WidgetsApp(color: const Color(0xff000000), builder: (_, _) => KlpFlutterRenderer(content: source.content)));
		expect(tester.takeException(), isA<StateError>());
		await tester.pumpWidget(const SizedBox.shrink());
		await tester.pump();
		expect(tester.takeException(), isNull);
	});
}
