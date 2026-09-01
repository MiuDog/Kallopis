import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

import 'style_fixture.dart';

void main() {
	testWidgets('PreviewCard 只在預覽區呈現語意虛線邊框', (tester) async {
		await tester.pumpWidget(_specimen(KlpVisualStyle.defaultStyle));

		final border = find.byType(KlpDashedBorder);
		expect(border, findsOneWidget);
		expect(find.descendant(of: border, matching: find.text('PREVIEW')), findsOneWidget);
		expect(find.descendant(of: border, matching: find.text('Asset title')), findsNothing);
	});

	testWidgets('PreviewCard 虛線邊框會解析對照風格 token', (tester) async {
		await tester.pumpWidget(_specimen(KlpVisualStyle.defaultStyle));
		final defaultPainter = _borderPainter(tester);

		await tester.pumpWidget(_specimen(contrastingStyle));
		final contrastingPainter = _borderPainter(tester);

		expect(contrastingPainter.shouldRepaint(defaultPainter), isTrue);
	});
}

Widget _specimen(KlpVisualStyle style) {
	return MaterialApp(
		key: ValueKey(style.name),
		theme: buildKlpTheme(Brightness.light, style: style),
		home: const Center(
			child: SizedBox(
				width: 320,
				child: KlpPreviewCard(
					title: 'Asset title',
					metadata: ['Image'],
					preview: Center(child: KlpText('PREVIEW')),
				),
			),
		),
	);
}

CustomPainter _borderPainter(WidgetTester tester) {
	final paint = find.descendant(of: find.byType(KlpDashedBorder), matching: find.byType(CustomPaint));
	return tester.widget<CustomPaint>(paint).foregroundPainter!;
}
