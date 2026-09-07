import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {

	test('KlpIcons 全部指向 Flaticon UIcons 字碼', () {
		final source = File('lib/src/foundation/klp_icons.dart').readAsStringSync();
		final codePoints = RegExp(
			r'(?:KlpIconData\(|thinCodePoint: )0x([a-f0-9]+)',
		).allMatches(source).map((match) => int.parse(match.group(1)!, radix: 16));

		expect(codePoints, isNotEmpty, reason: '沒有解析到任何 Flaticon UIcons 字碼');
		expect(
			codePoints.every((codePoint) => codePoint >= 0xf000),
			isTrue,
			reason: 'UIcons 應使用官方 icon font 的私用區字碼',
		);
		expect(source, isNot(contains('assets/icons/')));
		expect(source, isNot(contains('lucide')));
	});

	test('Flaticon UIcons 雙粗細字型與授權原文隨套件散佈', () {
		final regularFont = File('assets/fonts/FlaticonUIcons-RegularRounded.ttf');
		final thinFont = File('assets/fonts/FlaticonUIcons-ThinRounded.ttf');
		final license = File('assets/fonts/LICENSE-FLATICON-UICONS.txt').readAsStringSync();

		expect(regularFont.existsSync(), isTrue);
		expect(regularFont.lengthSync(), greaterThan(1000000));
		expect(thinFont.existsSync(), isTrue);
		expect(thinFont.lengthSync(), greaterThan(1000000));
		expect(license, contains('Flaticon License'));
		expect(license, contains('crediting'));
	});

	test('圖示尺寸與粗細採公開語意 API', () {
		final source = File('lib/src/foundation/klp_icon.dart').readAsStringSync();

		expect(source, contains('this.size,'), reason: 'size 不再是可選參數');
		expect(source, contains('size ?? context.klp.space.icon'), reason: 'KlpIcon 沒有在 build 時從 theme 解析尺寸');
		expect(source, contains('this.weight = KlpIconWeight.regular'));
		expect(source, contains('icon.supports(weight)'));
		expect(source, contains("fontPackage: 'kallopis'"));
	});
}
