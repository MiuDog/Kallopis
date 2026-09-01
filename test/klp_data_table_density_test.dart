import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

import 'style_fixture.dart';

void main() {
	testWidgets('KlpDataTable 短內容列由 MD 高度與 tight padding 控制', (tester) async {
		for (final style in [KlpVisualStyle.defaultStyle, contrastingStyle]) {
			await tester.pumpWidget(_specimen(style));

			final lineContainers = _lineContainers();
			expect(lineContainers, findsNWidgets(2));
			for (final container in tester.widgetList<Container>(lineContainers)) {
				expect(container.constraints!.minHeight, style.spacing.controlHeight);
				expect(tester.getSize(find.byWidget(container)).height, lessThan(style.spacing.controlHeightLarge));
			}

			final cellPaddings = tester.widgetList<Padding>(_cellPaddings());
			expect(cellPaddings, isNotEmpty);
			for (final padding in cellPaddings) {
				final insets = padding.padding as EdgeInsets;
				expect(insets.vertical, style.spacing.tight * 2);
			}
			expect(tester.takeException(), isNull);
		}
	});

	testWidgets('KlpDataTable 降低密度後仍容納 checkbox、badge 與雙行內容', (tester) async {
		for (final style in [KlpVisualStyle.defaultStyle, contrastingStyle]) {
			await tester.pumpWidget(_contentSpecimen(style));

			final rowRect = tester.getRect(_tableLines().at(1));
			final badgeRect = tester.getRect(find.byType(KlpBadge));
			expect(rowRect.contains(badgeRect.topLeft), isTrue);
			expect(rowRect.contains(badgeRect.bottomRight), isTrue);
			expect(find.byType(KlpCheckbox), findsNWidgets(2));
			expect(tester.takeException(), isNull);
		}
	});
}

Widget _specimen(KlpVisualStyle style) {
	final table = KlpDataTable(
		columns: const [KlpDataColumn(id: 'name', label: 'Name')],
		rows: const [KlpDataRow(id: 'row', cells: {'name': 'Value'})],
	);
	return MaterialApp(key: ValueKey(style.name), theme: buildKlpTheme(Brightness.dark, style: style), home: table);
}

Widget _contentSpecimen(KlpVisualStyle style) {
	final table = KlpDataTable(
		selectable: true,
		columns: const [KlpDataColumn(id: 'name', label: 'Name'), KlpDataColumn(id: 'status', label: 'Status')],
		rows: const [KlpDataRow(id: 'row', cells: {'name': 'A deliberately wrapping two-line value for density verification', 'status': KlpBadge(label: 'Canonical')})],
	);
	final home = Center(child: SizedBox(width: 420, child: table));
	return MaterialApp(key: ValueKey('content-${style.name}'), theme: buildKlpTheme(Brightness.dark, style: style), home: home);
}

Finder _tableLines() => find.byWidgetPredicate((widget) => widget.runtimeType.toString() == '_KlpTableLine');

Finder _lineContainers() => find.descendant(of: _tableLines(), matching: find.byWidgetPredicate((widget) => widget is Container && widget.constraints is BoxConstraints && widget.constraints!.minHeight > 0));

Finder _cellPaddings() => find.byWidgetPredicate((widget) => widget is Padding && widget.padding is EdgeInsets && (widget.padding as EdgeInsets).horizontal > 0);
