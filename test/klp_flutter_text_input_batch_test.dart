import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_editing_provider.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_text_input_batch.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_text_input_session.dart';

import 'support/klp_editing_fixture.dart';

KlpEditingProjection _frame(int revision, String text, int caret) {
	final stamp = KlpEditingStamp(
		documentId: 'd', pageId: 'p', generation: 0, projectionRevision: revision,
		contentRevision: revision, compositionRevision: 0, layoutRevision: 0, environmentId: 'e',
	);
	return editingFixture(KlpEditingTextWindow(
		stamp: stamp, blockId: 'b', sourceStartUtf8: 0, text: text,
		anchorUtf8: caret, focusUtf8: caret,
	));
}

TextEditingDeltaInsertion _insert(String before, String text, int offset, int caret) => TextEditingDeltaInsertion(
	oldText: before,
	textInserted: text,
	insertionOffset: offset,
	selection: TextSelection.collapsed(offset: caret),
	composing: TextRange.empty,
);

void main() {
	test('delta batch awaits each authority reply and uses its latest window', () async {
		final first = Completer<KlpEditingReply>();
		final requests = <KlpEditingRequest>[];
		final session = KlpFlutterTextInputSession(_frame(0, '中', 0), (request) {
			requests.add(request);
			if (requests.length == 1) return first.future;
			return KlpEditingReply(KlpEditingDecision.accepted, _frame(2, 'ab中', 2));
		});
		final batch = KlpFlutterTextInputBatch(session);
		final running = batch.submit([
			_insert('中', 'a', 0, 1),
			_insert('a中', 'b', 1, 2),
		], interrupted: () => false);
		expect(requests, hasLength(1));
		await expectLater(batch.submit([], interrupted: () => false), throwsStateError);

		first.complete(KlpEditingReply(KlpEditingDecision.accepted, _frame(1, 'a中', 1)));
		final result = await running;
		expect(result!.synchronized, isTrue);
		expect(requests, hasLength(2));
		expect(requests.last.expected.projectionRevision, 1);
		expect(requests.last.intent, isA<KlpReplaceTextIntent>());
	});

	test('rejected first delta stops the remaining callback batch', () async {
		var calls = 0;
		final session = KlpFlutterTextInputSession(_frame(0, '中', 0), (_) {
			calls++;
			return KlpEditingReply(KlpEditingDecision.rejected, _frame(1, '中', 0));
		});
		final result = await KlpFlutterTextInputBatch(session).submit([
			_insert('中', 'a', 0, 1),
			_insert('a中', 'b', 1, 2),
		], interrupted: () => false);
		expect(result!.synchronized, isFalse);
		expect(calls, 1);
	});

	test('interruption boundary stops before the next delta', () async {
		var interrupted = false;
		var calls = 0;
		final session = KlpFlutterTextInputSession(_frame(0, '中', 0), (_) {
			calls++;
			interrupted = true;
			return KlpEditingReply(KlpEditingDecision.accepted, _frame(1, 'a中', 1));
		});
		final result = await KlpFlutterTextInputBatch(session).submit([
			_insert('中', 'a', 0, 1),
			_insert('a中', 'b', 1, 2),
		], interrupted: () => interrupted);
		expect(result!.synchronized, isTrue);
		expect(calls, 1);
	});
}
