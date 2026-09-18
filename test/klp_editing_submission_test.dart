import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_projection.dart';
import 'support/klp_editing_fixture.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_intent.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_reply.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_request.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_stamp.dart';
import 'package:kallopis/src/capabilities/editing/klp_editing_submission.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_text_window.dart';

KlpEditingProjection window({int revision = 0, String text = '中', String page = 'page'}) => editingFixture(KlpEditingTextWindow(
	stamp: KlpEditingStamp(documentId: 'document', pageId: page, generation: 0, projectionRevision: revision, contentRevision: revision, compositionRevision: 0, layoutRevision: revision, environmentId: 'environment'),
	blockId: 'block', sourceStartUtf8: 0, text: text,
));

KlpEditingRequest request(KlpEditingProjection value, int sequence) => KlpEditingRequest(sequence: sequence, expected: value.stamp, blockId: value.window!.blockId, intent: KlpReplaceTextIntent(0, 0, 'a'));

void main() {
	test('reentrant duplicate dispatches once and shares the original future', () async {
		final initial = window();
		final next = window(revision: 1, text: 'a中');
		final intent = request(initial, 1);
		final authority = Completer<KlpEditingReply>();
		late KlpEditingSubmission submission;
		Future<KlpEditingReply>? reentrant;
		var calls = 0;
		submission = KlpEditingSubmission(initial, (value) {
			calls++;
			reentrant = submission.submit(value);
			return authority.future;
		});
		final result = submission.submit(intent);
		expect(reentrant, same(result));
		expect(submission.submit(intent), same(result));
		expect(() => submission.submit(request(initial, 2)), throwsStateError);
		expect(submission.window, same(initial.window));
		authority.complete(KlpEditingReply(KlpEditingDecision.accepted, next));
		await result;
		expect(submission.window, same(next.window));
		expect(submission.pending, isFalse);
		expect(submission.submit(intent), same(result));
		expect(calls, 1);
	});

	test('rejected operations preserve the authority projection', () async {
		final initial = window();
		final submission = KlpEditingSubmission(initial, (_) => KlpEditingReply(KlpEditingDecision.rejected, initial));
		final result = await submission.submit(request(initial, 1));
		expect(result.decision, KlpEditingDecision.rejected);
		expect(submission.window!.text, '中');
		expect(() => submission.submit(request(initial, 1)), throwsStateError);
	});

	test('unknown failure requires resync and never retries the old request', () async {
		var calls = 0;
		final initial = window();
		final submission = KlpEditingSubmission(initial, (_) {
			calls++;
			throw StateError('Transport outcome unknown');
		});
		final intent = request(initial, 1);
		await expectLater(submission.submit(intent), throwsStateError);
		expect(submission.requiresResync, isTrue);
		await expectLater(submission.submit(intent), throwsStateError);
		expect(calls, 1);
		expect(() => submission.submit(request(initial, 2)), throwsStateError);
		submission.resynchronize(window(revision: 1));
		expect(submission.requiresResync, isFalse);
	});

	test('changed text without a new projection and foreign replies are rejected', () async {
		for (final invalid in [window(text: 'changed'), window(revision: 1, page: 'other')]) {
			final initial = window();
			final submission = KlpEditingSubmission(initial, (_) => KlpEditingReply(KlpEditingDecision.accepted, invalid));
			await expectLater(submission.submit(request(initial, 1)), throwsStateError);
			expect(submission.window, same(initial.window));
			expect(submission.requiresResync, isTrue);
		}
	});

	test('closing does not claim to cancel an already submitted transaction', () async {
		final initial = window();
		final authority = Completer<KlpEditingReply>();
		final submission = KlpEditingSubmission(initial, (_) => authority.future);
		final result = submission.submit(request(initial, 1));
		submission.close();
		expect(() => submission.submit(request(initial, 2)), throwsStateError);
		authority.complete(KlpEditingReply(KlpEditingDecision.accepted, window(revision: 1)));
		expect((await result).decision, KlpEditingDecision.accepted);
		expect(submission.window, same(initial.window));
	});

	test('invalid boundaries never reach the authority', () {
		var calls = 0;
		final initial = window();
		final submission = KlpEditingSubmission(initial, (_) {
			calls++;
			return KlpEditingReply(KlpEditingDecision.accepted, initial);
		});
		final invalid = KlpEditingRequest(sequence: 1, expected: initial.stamp, blockId: initial.window!.blockId, intent: KlpSelectTextIntent(1, 3));
		expect(() => submission.submit(invalid), throwsArgumentError);
		expect(calls, 0);
		expect(submission.pending, isFalse);
	});
}

