import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_intent.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_endpoint.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_projection.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_reply.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_request.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_stamp.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_text_window.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_text_delta.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_text_input_session.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_text_plan.dart';

import 'support/klp_editing_fixture.dart';

KlpEditingProjection frame(int revision, {String text = '中', int caret = 0, bool composing = false, int content = 0}) => editingFixture(KlpEditingTextWindow(
	stamp: KlpEditingStamp(documentId: 'd', pageId: 'p', generation: 0, projectionRevision: revision, contentRevision: content, compositionRevision: revision, layoutRevision: 0, environmentId: 'e'),
	blockId: 'b', sourceStartUtf8: 0, text: text, anchorUtf8: caret, focusUtf8: caret,
	composingStartUtf8: composing ? 1 : null, composingEndUtf8: composing ? 4 : null,
));

KlpFlutterTextPlan insertion(KlpFlutterTextInputSession session) => KlpFlutterTextPlan.fromDelta(KlpFlutterTextDelta.decode(session.projection.window!, const TextEditingDeltaInsertion(oldText: '中', textInserted: 'a', insertionOffset: 0, selection: TextSelection.collapsed(offset: 0), composing: TextRange.empty)));

void main() {
	test('confirmed interruption resynchronizes to block mode before reuse', () async {
		final session = KlpFlutterTextInputSession(frame(0), (_) => throw StateError('No command expected'));
		final oldPlan = insertion(session);
		expect((await session.interrupt()).synchronized, isTrue);
		session.resume();
		final stamp = KlpEditingStamp(documentId: 'd', pageId: 'p', generation: 0, projectionRevision: 1, contentRevision: 0, compositionRevision: 1, layoutRevision: 0, environmentId: 'e');
		final endpoint = KlpEditingEndpoint('b', 0, KlpEditingAffinity.downstream);
		session.resynchronize(KlpEditingProjection(stamp: stamp, anchor: endpoint, focus: endpoint, blockSelection: true));
		expect(session.projection.window, isNull);
		await expectLater(session.submit(oldPlan), throwsStateError);
	});

	test('replacement is acknowledged before final selection and uses fresh stamp', () async {
		final requests = <KlpEditingRequest>[];
		final replies = [frame(1, text: 'a中', caret: 1, content: 1), frame(2, text: 'a中', content: 1)];
		final session = KlpFlutterTextInputSession(frame(0), (request) {
			requests.add(request);
			return KlpEditingReply(KlpEditingDecision.accepted, replies[requests.length - 1]);
		});
		final plan = insertion(session);
		final result = await session.submit(plan);
		expect(result.synchronized, isTrue);
		expect(requests.first.intent, isA<KlpReplaceTextIntent>());
		expect(requests.last.intent, isA<KlpSelectTextIntent>());
		expect(requests.last.expected, replies.first.stamp);
		expect(requests.map((item) => item.sequence), [1, 2]);
		expect(() => result.replies.clear(), throwsUnsupportedError);
		await expectLater(session.submit(plan), throwsStateError);
	});

	test('rejection and mismatched authority stop before selection', () async {
		for (final decision in KlpEditingDecision.values) {
			var calls = 0;
			final session = KlpFlutterTextInputSession(frame(0), (_) {
				calls++;
				return KlpEditingReply(decision, frame(1, text: 'different'));
			});
			final result = await session.submit(insertion(session));
			expect(result.synchronized, isFalse);
			expect(calls, 1);
			expect(result.replies.single.decision, decision);
			expect(session.requiresResync, isTrue);
			session.resynchronize(frame(2));
			expect(session.requiresResync, isFalse);
		}
	});

	test('partial success survives a failure of the final selection', () async {
		var calls = 0;
		final session = KlpFlutterTextInputSession(frame(0), (_) {
			if (++calls == 2) throw StateError('Unknown transport outcome');

			return KlpEditingReply(KlpEditingDecision.accepted, frame(1, text: 'a中', caret: 1, content: 1));
		});
		final result = await session.submit(insertion(session));
		expect(result.synchronized, isFalse);
		expect(result.replies.single.decision, KlpEditingDecision.accepted);
		expect(result.error, isA<StateError>());
		expect(result.projection.window!.text, 'a中');
	});

	test('pending and closed events do not dispatch later steps', () async {
		final authority = Completer<KlpEditingReply>();
		var calls = 0;
		final session = KlpFlutterTextInputSession(frame(0), (_) {
			calls++;
			return authority.future;
		});
		final plan = insertion(session);
		final future = session.submit(plan);
		await expectLater(session.submit(plan), throwsStateError);
		session.close();
		authority.complete(KlpEditingReply(KlpEditingDecision.accepted, frame(1, text: 'a中', caret: 1, content: 1)));
		final result = await future;
		expect(result.synchronized, isFalse);
		expect(result.replies.single.decision, KlpEditingDecision.accepted);
		expect(calls, 1);
		expect(session.projection.window!.text, '中');
	});

	test('composition begins with atomic replacement and relative selection', () async {
		KlpEditingRequest? captured;
		final session = KlpFlutterTextInputSession(frame(0, text: 'A中B'), (request) {
			captured = request;
			return KlpEditingReply(KlpEditingDecision.accepted, frame(1, text: 'A知B', caret: 4, composing: true));
		});
		final delta = KlpFlutterTextDelta.decode(session.projection.window!, const TextEditingDeltaReplacement(oldText: 'A中B', replacedRange: TextRange(start: 1, end: 2), replacementText: '知', selection: TextSelection.collapsed(offset: 2), composing: TextRange(start: 1, end: 2)));
		final result = await session.submit(KlpFlutterTextPlan.fromDelta(delta));
		final begin = captured!.intent as KlpBeginCompositionIntent;
		expect((begin.startUtf8, begin.endUtf8), (1, 4));
		expect((begin.provisional.text, begin.provisional.anchorUtf8), ('知', 3));
		expect(result.synchronized, isTrue);
	});

	test('explicit commit updates final candidate before committing once', () async {
		final requests = <KlpEditingRequest>[];
		final session = KlpFlutterTextInputSession(frame(0, text: 'A知B', caret: 4, composing: true), (request) {
			requests.add(request);
			return KlpEditingReply(KlpEditingDecision.accepted, frame(requests.length, text: 'A識B', caret: 4, composing: requests.length == 1, content: requests.length == 1 ? 0 : 1));
		});
		final delta = KlpFlutterTextDelta.decode(session.projection.window!, const TextEditingDeltaReplacement(oldText: 'A知B', replacedRange: TextRange(start: 1, end: 2), replacementText: '識', selection: TextSelection.collapsed(offset: 2), composing: TextRange.empty));
		expect(() => KlpFlutterTextPlan.fromDelta(delta), throwsStateError);
		final result = await session.submit(KlpFlutterTextPlan.fromDelta(delta, resolution: KlpCompositionResolution.commit));
		expect(result.synchronized, isTrue);
		expect(requests.map((request) => request.intent.runtimeType), [KlpUpdateCompositionIntent, KlpCommitCompositionIntent]);
	});

	test('explicit cancellation validates restored authority text', () async {
		final session = KlpFlutterTextInputSession(frame(0, text: 'A知B', caret: 4, composing: true), (request) {
			expect(request.intent, isA<KlpCancelCompositionIntent>());
			return KlpEditingReply(KlpEditingDecision.accepted, frame(1, text: 'A中B', caret: 4));
		});
		final delta = KlpFlutterTextDelta.decode(session.projection.window!, const TextEditingDeltaReplacement(oldText: 'A知B', replacedRange: TextRange(start: 1, end: 2), replacementText: '中', selection: TextSelection.collapsed(offset: 2), composing: TextRange.empty));
		expect((await session.submit(KlpFlutterTextPlan.fromDelta(delta, resolution: KlpCompositionResolution.cancel))).synchronized, isTrue);
	});

	test('unexpected preview selection prevents the following commit', () async {
		var calls = 0;
		final session = KlpFlutterTextInputSession(frame(0, text: 'A知B', caret: 4, composing: true), (_) {
			calls++;
			return KlpEditingReply(KlpEditingDecision.accepted, frame(1, text: 'A識B', caret: 1, composing: true));
		});
		final delta = KlpFlutterTextDelta.decode(session.projection.window!, const TextEditingDeltaReplacement(oldText: 'A知B', replacedRange: TextRange(start: 1, end: 2), replacementText: '識', selection: TextSelection.collapsed(offset: 2), composing: TextRange.empty));
		final result = await session.submit(KlpFlutterTextPlan.fromDelta(delta, resolution: KlpCompositionResolution.commit));
		expect(result.synchronized, isFalse);
		expect(calls, 1);
		expect(result.projection.window!.composingStartUtf8, 1);
	});
}
