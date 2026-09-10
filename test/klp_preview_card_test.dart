import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

import 'style_fixture.dart';

void main() {
	testWidgets('PreviewCard 只在預覽區呈現語意虛線邊框', (tester) async {
		await tester.pumpWidget(
			MaterialApp(
				key: ValueKey(KlpVisualStyle.defaultStyle.name),
				theme: buildKlpTheme(Brightness.light),
				home: const KlpCenter(
					child: KlpConstrainedBox(
						constraints: KlpBoxConstraints(maxWidth: 320),
						child: KlpPreviewCard(
							title: 'Asset title',
							metadata: ['Image'],
							preview: KlpCenter(child: KlpText('PREVIEW')),
						),
					),
				),
			),
		);

		final border = find.byType(KlpDashedBorder);
		expect(border, findsOneWidget);
		expect(find.descendant(of: border, matching: find.text('PREVIEW')), findsOneWidget);
		expect(find.descendant(of: border, matching: find.text('Asset title')), findsNothing);
	});

	testWidgets('PreviewCard 虛線邊框會解析對照風格 token', (tester) async {
		await tester.pumpWidget(
			MaterialApp(
				key: ValueKey(KlpVisualStyle.defaultStyle.name),
				theme: buildKlpTheme(Brightness.light),
				home: const KlpPreviewCard(
					title: 'Asset title',
					preview: KlpText('PREVIEW'),
				),
			),
		);
		final defaultPaint = find.descendant(
			of: find.byType(KlpDashedBorder),
			matching: find.byType(CustomPaint),
		);
		final defaultPainter = tester.widget<CustomPaint>(defaultPaint).foregroundPainter!;

		await tester.pumpWidget(
			MaterialApp(
				key: ValueKey(contrastingStyle.name),
				theme: buildKlpTheme(Brightness.light, style: contrastingStyle),
				home: const KlpPreviewCard(
					title: 'Asset title',
					preview: KlpText('PREVIEW'),
				),
			),
		);
		final contrastingPaint = find.descendant(
			of: find.byType(KlpDashedBorder),
			matching: find.byType(CustomPaint),
		);
		final contrastingPainter =
				tester.widget<CustomPaint>(contrastingPaint).foregroundPainter!;

		expect(contrastingPainter.shouldRepaint(defaultPainter), isTrue);
	});

	testWidgets('PreviewCard typed size 會解析 geometry data token', (tester) async {
		final style = KlpVisualStyleJson.decode({
			'geometry': {
				'data': {'previewCardCompactHeight': 72},
			},
		});

		await tester.pumpWidget(
			MaterialApp(
				theme: buildKlpTheme(Brightness.light, style: style),
				home: const KlpPreviewCard(
					title: 'Asset title',
					previewSize: KlpPreviewCardSize.compact,
					preview: KlpText('PREVIEW'),
				),
			),
		);

		expect(tester.getSize(find.byType(KlpDashedBorder)).height, 72);
	});
}
