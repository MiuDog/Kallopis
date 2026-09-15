import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_projection.dart';
import 'support/klp_editing_fixture.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_composition_text.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_intent.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_reply.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_request.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_stamp.dart';
import 'package:kallopis/src/capabilities/editing/klp_editing_submission.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_text_window.dart';

KlpEditingProjection frame(int projection, {String text = '', bool composing = false, int content = 0}) => editingFixture(KlpEditingTextWindow(
	stamp: KlpEditingStamp(documentId: 'd', pageId: 'p', generation: 0, projectionRevision: projection, contentRevision: content, compositionRevision: projection, layoutRevision: projection, environmentId: 'e'),
	blockId: 'b', sourceStartUtf8: 0, text: text, anchorUtf8: 0, focusUtf8: 0,
	composingStartUtf8: composing ? 0 : null, composingEndUtf8: composing ? 0 : null,
));

KlpEditingRequest request(KlpEditingSubmission submission, int sequence, KlpEditingIntent intent) => KlpEditingRequest(
	sequence: sequence, expected: submission.window!.stamp, blockId: 'b', intent: intent,
);

void main() {
	test('empty composition remains active until explicit commit', () async {
		final replies = [frame(1, composing: true), frame(2, composing: true), frame(3, text: '中', content: 1)];
		var calls = 0;
		final submission = KlpEditingSubmission(frame(0), (_) => KlpEditingReply(KlpEditingDecision.accepted, replies[calls++]));
		await submission.submit(request(submission, 1, KlpBeginCompositionIntent(0, 0, KlpCompositionText('', 0, 0))));
		expect(submission.window!.composingStartUtf8, 0);
		expect(() => submission.submit(request(submission, 2, KlpReplaceTextIntent(0, 0, 'wrong'))), throwsStateError);
		await submission.submit(request(submission, 2, KlpUpdateCompositionIntent(KlpCompositionText('', 0, 0))));
		final commit = request(submission, 3, const KlpCommitCompositionIntent());
		final result = submission.submit(commit);
		await result;
		expect(submission.submit(commit), same(result));
		expect(submission.window!.text, '中');
		expect(submission.window!.composingStartUtf8, isNull);
		expect(calls, 3);
	});

	test('cancel ends preview without advancing content revision', () async {
		final submission = KlpEditingSubmission(frame(1, composing: true), (_) => KlpEditingReply(KlpEditingDecision.accepted, frame(2)));
		await submission.submit(request(submission, 1, const KlpCancelCompositionIntent()));
		expect(submission.window!.stamp.contentRevision, 0);
		expect(submission.window!.composingStartUtf8, isNull);
		expect(() => submission.submit(request(submission, 2, const KlpCancelCompositionIntent())), throwsStateError);
	});

	test('invalid composition transitions cannot reach authority', () {
		var calls = 0;
		final initial = frame(0);
		final submission = KlpEditingSubmission(initial, (_) {
			calls++;
			return KlpEditingReply(KlpEditingDecision.rejected, initial);
		});
		for (final intent in [const KlpCommitCompositionIntent(), const KlpCancelCompositionIntent(), KlpUpdateCompositionIntent(KlpCompositionText('中', 0, 3))]) {
			expect(() => submission.submit(request(submission, 1, intent)), throwsStateError);
		}
		expect(calls, 0);
		expect(() => KlpCompositionText('😀', 0, 2), throwsArgumentError);
	});

	test('preview or cancellation that commits content is rejected', () async {
		for (final intent in [KlpUpdateCompositionIntent(KlpCompositionText('中', 0, 3)), const KlpCancelCompositionIntent()]) {
			final initial = frame(1, composing: true);
			final submission = KlpEditingSubmission(initial, (_) => KlpEditingReply(KlpEditingDecision.accepted, frame(2, composing: intent is KlpUpdateCompositionIntent, content: 1)));
			await expectLater(submission.submit(request(submission, 1, intent)), throwsStateError);
			expect(submission.window, same(initial.window));
			expect(submission.requiresResync, isTrue);
		}
	});
}

