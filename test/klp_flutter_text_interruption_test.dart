import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_editing_provider.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_text_delta.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_text_input_session.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_text_plan.dart';

import 'support/klp_editing_fixture.dart';

KlpEditingProjection snapshot(int revision, {String text = 'A中', bool composing = true, int content = 0}) => editingFixture(KlpEditingTextWindow(
	stamp: KlpEditingStamp(documentId: 'd', pageId: 'p', generation: 0, projectionRevision: revision, contentRevision: content, compositionRevision: revision, layoutRevision: 0, environmentId: 'e'),
	blockId: 'b', sourceStartUtf8: 0, text: text,
	anchorUtf8: KlpTextOffsets(text).utf8Length, focusUtf8: KlpTextOffsets(text).utf8Length,
	composingStartUtf8: composing ? 1 : null, composingEndUtf8: composing ? KlpTextOffsets(text).utf8Length : null,
));

KlpFlutterTextPlan finalCandidate(KlpFlutterTextInputSession session) => KlpFlutterTextPlan.fromDelta(
	KlpFlutterTextDelta.decode(session.projection.window!, const TextEditingDeltaReplacement(
		oldText: 'A中', replacementText: '文', replacedRange: TextRange(start: 1, end: 2),
		selection: TextSelection.collapsed(offset: 2), composing: TextRange.empty,
	)),
	resolution: KlpCompositionResolution.commit,
);

void main() {
	test('interruption cancels once and blocks input until explicitly resumed', () async {
		final requests = <KlpEditingRequest>[];
		final session = KlpFlutterTextInputSession(snapshot(0), (request) {
			requests.add(request);
			return KlpEditingReply(KlpEditingDecision.accepted, snapshot(1, text: 'A', composing: false));
		});
		final plan = finalCandidate(session);
		final interruption = session.interrupt();
		expect(session.interrupt(), same(interruption));
		expect(() => session.resynchronize(snapshot(2)), throwsStateError);
		expect(() => session.resume(), throwsStateError);
		await expectLater(session.submit(plan), throwsStateError);
		final result = await interruption;
		expect(result.synchronized, isTrue);
		expect(result.projection.window!.text, 'A');
		expect(result.projection.stamp.contentRevision, 0);
		expect(requests.single.intent, isA<KlpCancelCompositionIntent>());
		session.resume();
		expect((await session.interrupt()).synchronized, isTrue);
		expect(requests, hasLength(1));
	});

	test('interruption waits for pending candidate and cancels instead of committing', () async {
		final pending = Completer<KlpEditingReply>();
		final requests = <KlpEditingRequest>[];
		final session = KlpFlutterTextInputSession(snapshot(0), (request) {
			requests.add(request);
			if (requests.length == 1) return pending.future;

			return KlpEditingReply(KlpEditingDecision.accepted, snapshot(2, text: 'A', composing: false));
		});
		final editing = session.submit(finalCandidate(session));
		final interruption = session.interrupt();
		expect(requests, hasLength(1));
		pending.complete(KlpEditingReply(KlpEditingDecision.accepted, snapshot(1, text: 'A文')));
		expect((await editing).synchronized, isFalse);
		final result = await interruption;
		expect(result.synchronized, isTrue);
		expect(requests.map((request) => request.intent.runtimeType), [KlpUpdateCompositionIntent, KlpCancelCompositionIntent]);
		expect(requests.last.expected.projectionRevision, 1);
		expect(result.projection.window!.text, 'A');
		expect(session.requiresResync, isFalse);
	});

	test('interruption preserves a commit already accepted by authority', () async {
		final pending = Completer<KlpEditingReply>();
		var calls = 0;
		final session = KlpFlutterTextInputSession(snapshot(0), (_) { calls++; return pending.future; });
		final delta = KlpFlutterTextDelta.decode(session.projection.window!, const TextEditingDeltaNonTextUpdate(oldText: 'A中', selection: TextSelection.collapsed(offset: 2), composing: TextRange.empty));
		final editing = session.submit(KlpFlutterTextPlan.fromDelta(delta, resolution: KlpCompositionResolution.commit));
		final interruption = session.interrupt();
		pending.complete(KlpEditingReply(KlpEditingDecision.accepted, snapshot(1, composing: false, content: 1)));
		await editing;
		final result = await interruption;
		expect(result.synchronized, isTrue);
		expect(result.projection.window!.text, 'A中');
		expect(result.projection.stamp.contentRevision, 1);
		expect(calls, 1);
	});

	test('unknown pending outcome requires synchronization before cancellation', () async {
		final pending = Completer<KlpEditingReply>();
		var calls = 0;
		final session = KlpFlutterTextInputSession(snapshot(0), (_) {
			if (++calls == 1) return pending.future;

			return KlpEditingReply(KlpEditingDecision.accepted, snapshot(3, text: 'A', composing: false));
		});
		final editing = session.submit(finalCandidate(session));
		final interruption = session.interrupt();
		pending.completeError(StateError('Unknown accepted state'));
		await editing;
		expect((await interruption).synchronized, isFalse);
		expect(calls, 1);
		expect(() => session.resume(), throwsStateError);
		session.resynchronize(snapshot(2, text: 'A文'));
		expect((await session.interrupt()).synchronized, isTrue);
		expect(calls, 2);
	});

	test('rejected cancellation remains unresolved and is not automatically retried', () async {
		var calls = 0;
		final session = KlpFlutterTextInputSession(snapshot(0), (_) { calls++; return KlpEditingReply(KlpEditingDecision.rejected, snapshot(1)); });
		final result = await session.interrupt();
		expect(result.synchronized, isFalse);
		expect(session.requiresResync, isTrue);
		expect(await session.interrupt(), same(result));
		expect(calls, 1);
		expect(() => session.resume(), throwsStateError);
	});
}
