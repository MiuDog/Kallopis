import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_text_offsets.dart';

void main() {
	test('mixed text keeps exact byte and code unit boundaries', () {
		final offsets = KlpTextOffsets('A中😀e\u0301');
		final boundaries = {0: 0, 1: 1, 2: 4, 4: 8, 5: 9, 6: 11};
		for (final entry in boundaries.entries) {
			expect(offsets.toUtf8(entry.key), entry.value);
			expect(offsets.toUtf16(entry.value), entry.key);
		}
		expect(offsets.utf8Length, 11);
		expect(offsets.utf16Length, 6);
		expect(() => offsets.toUtf8(3), throwsArgumentError);
		for (final byte in [2, 3, 5, 6, 7, 10]) {
			expect(() => offsets.toUtf16(byte), throwsArgumentError);
		}
	});

	test('empty text and range errors do not silently clamp', () {
		final offsets = KlpTextOffsets('');
		expect(offsets.toUtf8(0), 0);
		expect(offsets.toUtf16(0), 0);
		for (final position in [-1, 1]) {
			expect(() => offsets.toUtf8(position), throwsRangeError);
			expect(() => offsets.toUtf16(position), throwsRangeError);
		}
	});

	test('malformed UTF16 is rejected instead of replaced', () {
		for (final units in [[0xd800], [0xdc00], [0xd800, 65], [0xd800, 0xd800]]) {
			expect(() => KlpTextOffsets(String.fromCharCodes(units)), throwsFormatException);
		}
	});

	test('random Unicode boundaries match the standard UTF8 encoder', () {
		final random = Random(713);
		for (var sample = 0; sample < 100; sample++) {
			final scalars = <int>[0, 0x7f, 0x80, 0x7ff, 0x800, 0xd7ff, 0xe000, 0xffff, 0x10000, 0x10ffff];
			for (var index = 0; index < 40; index++) {
				final scalar = random.nextInt(0x110000);
				if (scalar >= 0xd800 && scalar <= 0xdfff) continue;

				scalars.add(scalar);
			}
			final text = String.fromCharCodes(scalars);
			final offsets = KlpTextOffsets(text);
			var codeUnits = 0;
			var bytes = 0;
			for (final scalar in scalars) {
				final character = String.fromCharCode(scalar);
				codeUnits += character.length;
				bytes += utf8.encode(character).length;
				expect(offsets.toUtf8(codeUnits), bytes);
				expect(offsets.toUtf16(bytes), codeUnits);
			}
			expect(offsets.utf8Length, utf8.encode(text).length);
		}
	});
}
