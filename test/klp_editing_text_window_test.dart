import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_stamp.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_text_window.dart';

KlpEditingStamp stamp({int projection = 3, int composition = 2, int generation = 1, String page = 'page', String environment = 'environment', int layout = 4, int content = 1, String document = 'document'}) => KlpEditingStamp(
	documentId: document,
	pageId: page,
	generation: generation,
	projectionRevision: projection,
	contentRevision: content,
	compositionRevision: composition,
	layoutRevision: layout,
	environmentId: environment,
);

void main() {
	test('window maps reversed selection and composition without editing text', () {
		final version = stamp();
		final window = KlpEditingTextWindow(
			stamp: version,
			blockId: 'block',
			sourceStartUtf8: 8,
			text: '中😀文',
			anchorUtf8: 7,
			focusUtf8: 3,
			composingStartUtf8: 3,
			composingEndUtf8: 7,
		);
		expect(window.anchorUtf16, 3);
		expect(window.focusUtf16, 1);
		expect(window.composingStartUtf16, 1);
		expect(window.composingEndUtf16, 3);
		expect(window.toSourceUtf8(3, stamp()), 15);
		expect(window.toLocalUtf16(15, stamp()), 3);
		expect(window.text, '中😀文');
	});

	test('each version dimension prevents stale coordinate conversion', () {
		final window = KlpEditingTextWindow(stamp: stamp(), blockId: 'block', sourceStartUtf8: 0, text: '中');
		for (final version in [stamp(projection: 4), stamp(composition: 3), stamp(generation: 2), stamp(page: 'other'), stamp(environment: 'new'), stamp(layout: 5), stamp(content: 2), stamp(document: 'other')]) {
			expect(() => window.toSourceUtf8(0, version), throwsStateError);
			expect(() => window.toLocalUtf16(0, version), throwsStateError);
		}
		expect(stamp(), stamp());
		expect(stamp().hashCode, stamp().hashCode);
	});

	test('absent selection supports an unfocused window', () {
		final window = KlpEditingTextWindow(stamp: stamp(), blockId: 'block', sourceStartUtf8: 0, text: '');
		expect(window.anchorUtf16, isNull);
		expect(window.focusUtf16, isNull);
		expect(window.composingStartUtf16, isNull);
		expect(window.toSourceUtf8(0, stamp()), 0);
	});

	test('malformed selection and composition fail before platform input', () {
		KlpEditingTextWindow window({int? anchor, int? focus, int? start, int? end}) => KlpEditingTextWindow(
			stamp: stamp(), blockId: 'block', sourceStartUtf8: 0, text: '😀',
			anchorUtf8: anchor, focusUtf8: focus, composingStartUtf8: start, composingEndUtf8: end,
		);
		for (final create in <KlpEditingTextWindow Function()>[
			() => window(anchor: 0),
			() => window(focus: 0),
			() => window(anchor: 0, focus: 2),
			() => window(start: 0),
			() => window(start: 0, end: 4),
			() => window(anchor: 0, focus: 0, start: 4, end: 0),
			() => window(anchor: 0, focus: 0, start: 1, end: 4),
		]) {
			expect(create, throwsArgumentError);
		}
	});

	test('source offsets outside the snapshot are rejected', () {
		final window = KlpEditingTextWindow(stamp: stamp(), blockId: 'block', sourceStartUtf8: 5, text: '中');
		expect(() => window.toLocalUtf16(4, stamp()), throwsRangeError);
		expect(() => window.toLocalUtf16(9, stamp()), throwsRangeError);
		expect(() => window.toLocalUtf16(6, stamp()), throwsArgumentError);
		expect(() => stamp(projection: -1), throwsArgumentError);
		expect(() => stamp(page: ' '), throwsArgumentError);
	});
}
