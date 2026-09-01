import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

import 'style_fixture.dart';

void main() {
	testWidgets('KlpPhaseToggle 使用 xSmall 語意尺寸並跟隨風格', (tester) async {
		for (final style in [KlpVisualStyle.defaultStyle, contrastingStyle]) {
			await tester.pumpWidget(_specimen(style));

			final size = tester.getSize(find.byKey(const ValueKey('phase-toggle')));
			final spacing = style.spacing;
			final chrome = spacing.hairline * 4 + style.shape.hairline * 2;
			expect(size.height, spacing.controlHeightXSmall + chrome);
			expect(size.width, spacing.controlHeightXSmall * 2 + chrome);
			expect(size.height, lessThan(spacing.controlHeightSmall + chrome));
		}
	});
}

Widget _specimen(KlpVisualStyle style) {
	final toggle = KlpPhaseToggle<int>(
		key: const ValueKey('phase-toggle'),
		options: const [
			KlpPhaseOption(value: 0, label: '0'),
			KlpPhaseOption(value: 1, label: '1'),
		],
		selected: 1,
	);
	final home = Center(child: toggle);
	return MaterialApp(key: ValueKey(style.name), theme: buildKlpTheme(Brightness.light, style: style), home: home);
}
