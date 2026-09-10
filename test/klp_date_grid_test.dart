import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
	testWidgets('date grid 保留七欄狀態表面並回傳選取索引', (tester) async {
		int? selectedIndex;

		await tester.pumpWidget(
			MaterialApp(
				theme: buildKlpTheme(Brightness.light),
				home: KlpDateGrid(
					items: const [
						KlpDateGridItem(label: '0'),
						KlpDateGridItem(label: '1'),
						KlpDateGridItem(label: '2', selected: true),
						KlpDateGridItem(label: '3'),
						KlpDateGridItem(label: '4'),
						KlpDateGridItem(label: '5'),
						KlpDateGridItem(label: '6'),
					],
					onSelected: (index) => selectedIndex = index,
				),
			),
		);

		final weekendSurface = tester.widget<KlpSurface>(
			find.ancestor(of: find.text('0'), matching: find.byType(KlpSurface)).first,
		);
		final selectedSurface = tester.widget<KlpSurface>(
			find.ancestor(of: find.text('2'), matching: find.byType(KlpSurface)).first,
		);
		expect(weekendSurface.tone, KlpSurfaceTone.muted);
		expect(selectedSurface.tone, KlpSurfaceTone.component);

		await tester.tap(find.text('4'));
		expect(selectedIndex, 4);
	});

	testWidgets('date grid cell 高度由 geometry data token 決定', (tester) async {
		final style = KlpVisualStyleJson.decode({
			'geometry': {
				'data': {'dateGridCellHeight': 140},
			},
		});

		await tester.pumpWidget(
			MaterialApp(
				theme: buildKlpTheme(Brightness.light, style: style),
				home: const KlpColumn(
					children: [
						KlpDateGrid(
							items: [
								KlpDateGridItem(label: '0'),
								KlpDateGridItem(label: '1'),
								KlpDateGridItem(label: '2'),
								KlpDateGridItem(label: '3'),
								KlpDateGridItem(label: '4'),
								KlpDateGridItem(label: '5'),
								KlpDateGridItem(label: '6'),
								KlpDateGridItem(label: '7'),
							],
						),
					],
				),
			),
		);

		expect(tester.getSize(find.byType(GridView)).height, 280);
	});
}
