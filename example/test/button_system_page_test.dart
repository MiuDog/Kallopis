import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';
import 'package:kallopis_catalog/catalog/registry.dart';
import 'package:kallopis_catalog/catalog_shell.dart';

void main() {
	testWidgets('Button system 在固定 Catalog viewport 不溢出', (tester) async {
		tester.view.physicalSize = const Size(1400, 900);
		tester.view.devicePixelRatio = 1;
		addTearDown(tester.view.resetPhysicalSize);
		addTearDown(tester.view.resetDevicePixelRatio);

		final selected = catalogPages.indexWhere((page) => page.label == 'Button system');
		await tester.pumpWidget(
			MaterialApp(
				theme: buildKlpTheme(Brightness.dark),
				home: CatalogShell(groups: catalogGroups, pages: catalogPages, selected: selected, onSelected: (_) {}),
			),
		);
		await tester.pump(const Duration(milliseconds: 200));

		expect(tester.takeException(), isNull);
	});
}
