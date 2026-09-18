import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_composition_attribute.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_composition_segment.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_composition_text.dart';

void main() {
	test('mixed unicode segment annotations preserve order and are immutable', () {
		final segments = [
			KlpCompositionSegment(0, 3, KlpCompositionAttribute.converted),
			KlpCompositionSegment(3, 7, KlpCompositionAttribute.targetConverted),
			KlpCompositionSegment(7, 8, KlpCompositionAttribute.rawInput),
			KlpCompositionSegment(8, 10, KlpCompositionAttribute.inputError),
		];
		final text = KlpCompositionText('中😀e\u0301', 3, 7, segments: segments);
		segments.clear();
		expect(text.segments.map((segment) => segment.attribute), [
			KlpCompositionAttribute.converted,
			KlpCompositionAttribute.targetConverted,
			KlpCompositionAttribute.rawInput,
			KlpCompositionAttribute.inputError,
		]);
		expect(() => text.segments.clear(), throwsUnsupportedError);
	});

	test('segments cannot split unicode or overlap', () {
		for (final bounds in [(0, 1), (3, 5), (0, 8)]) {
			final segment = KlpCompositionSegment(bounds.$1, bounds.$2, KlpCompositionAttribute.rawInput);
			expect(() => KlpCompositionText('中😀', 0, 7, segments: [segment]), throwsArgumentError);
		}
		final later = KlpCompositionSegment(3, 7, KlpCompositionAttribute.converted);
		final earlier = KlpCompositionSegment(0, 3, KlpCompositionAttribute.rawInput);
		expect(() => KlpCompositionText('中😀', 0, 7, segments: [later, earlier]), throwsArgumentError);
		expect(() => KlpCompositionText('中😀', 0, 7, segments: [later, later]), throwsArgumentError);
	});

	test('empty annotations and gaps preserve core range semantics', () {
		final empty = KlpCompositionSegment(0, 0, KlpCompositionAttribute.rawInput);
		expect(KlpCompositionText('', 0, 0, segments: [empty]).segments.single, same(empty));
		final gap = KlpCompositionSegment(3, 7, KlpCompositionAttribute.converted);
		expect(KlpCompositionText('中😀', 0, 7, segments: [gap]).segments.single, same(gap));
		expect(() => KlpCompositionSegment(-1, 0, KlpCompositionAttribute.rawInput), throwsArgumentError);
		expect(() => KlpCompositionSegment(3, 0, KlpCompositionAttribute.rawInput), throwsArgumentError);
	});
}
