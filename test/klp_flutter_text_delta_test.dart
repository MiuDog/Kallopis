import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_stamp.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_text_window.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_text_delta.dart';

KlpEditingTextWindow window(String text) => KlpEditingTextWindow(
	stamp: KlpEditingStamp(documentId: 'd', pageId: 'p', generation: 0, projectionRevision: 1, contentRevision: 0, compositionRevision: 0, layoutRevision: 0, environmentId: 'e'),
	blockId: 'b', sourceStartUtf8: 20, text: text,
);

void main() {
	test('Unicode insertion preserves local byte ranges and reversed selection', () {
		final before = window('A😀B');
		final result = KlpFlutterTextDelta.decode(before, const TextEditingDeltaInsertion(oldText: 'A😀B', textInserted: '中', insertionOffset: 3, selection: TextSelection(baseOffset: 4, extentOffset: 1), composing: TextRange.empty));
		expect(result.before, same(before));
		expect(result.replacement, (startUtf8: 5, endUtf8: 5, text: '中'));
		expect(result.requested.text, 'A😀中B');
		expect((result.anchorUtf8, result.focusUtf8), (8, 1));
		expect(before.text, 'A😀B');
	});

	test('deletion and replacement keep exact platform ranges', () {
		final before = window('A中😀B');
		final deletion = KlpFlutterTextDelta.decode(before, const TextEditingDeltaDeletion(oldText: 'A中😀B', deletedRange: TextRange(start: 1, end: 4), selection: TextSelection.collapsed(offset: 1), composing: TextRange.empty));
		expect(deletion.replacement, (startUtf8: 1, endUtf8: 8, text: ''));
		expect(deletion.requested.text, 'AB');
		final replacement = KlpFlutterTextDelta.decode(before, const TextEditingDeltaReplacement(oldText: 'A中😀B', replacedRange: TextRange(start: 1, end: 4), replacementText: '知', selection: TextSelection.collapsed(offset: 2), composing: TextRange(start: 1, end: 2)));
		expect(replacement.requested.text, 'A知B');
		expect((replacement.composingStartUtf8, replacement.composingEndUtf8), (1, 4));
	});

	test('empty composition and absent selection have distinct meanings', () {
		final empty = KlpFlutterTextDelta.decode(window(''), const TextEditingDeltaNonTextUpdate(oldText: '', selection: TextSelection.collapsed(offset: 0), composing: TextRange.collapsed(0)));
		expect(empty.replacement, isNull);
		expect((empty.composingStartUtf8, empty.composingEndUtf8), (0, 0));
		final absent = KlpFlutterTextDelta.decode(window(''), const TextEditingDeltaNonTextUpdate(oldText: '', selection: TextSelection.collapsed(offset: -1), composing: TextRange.empty));
		expect(absent.anchorUtf8, isNull);
		expect(absent.composingStartUtf8, isNull);
	});

	test('stale text and surrogate splits are rejected before submission', () {
		const delta = TextEditingDeltaInsertion(oldText: '😀', textInserted: 'x', insertionOffset: 1, selection: TextSelection.collapsed(offset: 2), composing: TextRange.empty);
		expect(() => KlpFlutterTextDelta.decode(window('other'), delta), throwsStateError);
		expect(() => KlpFlutterTextDelta.decode(window('😀'), delta), throwsArgumentError);
		final malformed = TextEditingDeltaInsertion(oldText: '', textInserted: String.fromCharCode(0xd800), insertionOffset: 0, selection: const TextSelection.collapsed(offset: 1), composing: TextRange.empty);
		expect(() => KlpFlutterTextDelta.decode(window(''), malformed), throwsFormatException);
	});

	test('invalid result boundaries are rejected in non-text updates', () {
		for (final selection in [const TextSelection.collapsed(offset: 1), const TextSelection(baseOffset: -1, extentOffset: 0), const TextSelection.collapsed(offset: 3)]) {
			final delta = TextEditingDeltaNonTextUpdate(oldText: '😀', selection: selection, composing: TextRange.empty);
			expect(() => KlpFlutterTextDelta.decode(window('😀'), delta), throwsArgumentError);
		}
		for (final composing in [const TextRange(start: 1, end: 2), const TextRange(start: 2, end: 0), const TextRange(start: -1, end: 0)]) {
			final delta = TextEditingDeltaNonTextUpdate(oldText: '😀', selection: const TextSelection.collapsed(offset: 0), composing: composing);
			expect(() => KlpFlutterTextDelta.decode(window('😀'), delta), throwsArgumentError);
		}
	});
}
