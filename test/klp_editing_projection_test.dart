import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_endpoint.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_intent.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_projection.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_reply.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_request.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_stamp.dart';
import 'package:kallopis/src/capabilities/editing/klp_editing_submission.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_text_window.dart';

KlpEditingStamp stamp(int revision) => KlpEditingStamp(documentId: 'd', pageId: 'p', generation: 0, projectionRevision: revision, contentRevision: 0, compositionRevision: 0, layoutRevision: 0, environmentId: 'e');

KlpEditingEndpoint endpoint(String block, int position) => KlpEditingEndpoint(block, position, KlpEditingAffinity.downstream);

KlpEditingProjection local(int revision) => KlpEditingProjection(
	stamp: stamp(revision), anchor: endpoint('a', 0), focus: endpoint('a', 0), blockSelection: false,
	window: KlpEditingTextWindow(stamp: stamp(revision), blockId: 'a', sourceStartUtf8: 0, text: '中', anchorUtf8: 0, focusUtf8: 0),
);

KlpEditingProjection across(int revision, {bool blocks = false}) => KlpEditingProjection(
	stamp: stamp(revision), anchor: endpoint('b', 2), focus: endpoint('a', 0), blockSelection: blocks,
);

KlpEditingRequest request(KlpEditingProjection projection, int sequence) => KlpEditingRequest(sequence: sequence, expected: projection.stamp, blockId: 'a', intent: KlpSelectTextIntent(0, 0));

void main() {
	test('cross-block authority reply preserves direction and disables local input', () async {
		final initial = local(0);
		final next = across(1);
		var calls = 0;
		final submission = KlpEditingSubmission(initial, (_) {
			calls++;
			return KlpEditingReply(KlpEditingDecision.rejected, next);
		});
		await submission.submit(request(initial, 1));
		expect(submission.projection, same(next));
		expect(submission.projection.anchor.blockId, 'b');
		expect(submission.projection.focus.blockId, 'a');
		expect(submission.window, isNull);
		expect(() => submission.submit(request(next, 2)), throwsStateError);
		expect(calls, 1);
		submission.resynchronize(local(2));
		expect(submission.window!.text, '中');
	});

	test('block mode cannot masquerade as an empty text window', () {
		final projection = across(1, blocks: true);
		final submission = KlpEditingSubmission(projection, (_) => throw StateError('Must not dispatch'));
		expect(submission.projection.blockSelection, isTrue);
		expect(() => submission.submit(request(projection, 1)), throwsStateError);
	});

	test('unchanged revision cannot hide selection or mode changes', () {
		final submission = KlpEditingSubmission(across(1), (_) => throw StateError('Must not dispatch'));
		expect(() => submission.resynchronize(across(1, blocks: true)), throwsStateError);
		final changed = KlpEditingProjection(stamp: stamp(1), anchor: endpoint('b', 3), focus: endpoint('a', 0), blockSelection: false);
		expect(() => submission.resynchronize(changed), throwsStateError);
	});

	test('foreign or cross-block windows are rejected at construction', () {
		for (final blockMode in [false, true]) {
			expect(() => KlpEditingProjection(stamp: stamp(0), anchor: endpoint('b', 2), focus: endpoint('a', 0), blockSelection: blockMode, window: local(0).window), throwsArgumentError);
		}
		expect(() => KlpEditingProjection(stamp: stamp(1), anchor: endpoint('a', 0), focus: endpoint('a', 0), blockSelection: false, window: local(0).window), throwsStateError);
	});
}
