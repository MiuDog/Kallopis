import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 有限宿主與正式語意主題讓測試只觀察公開空集合契約。
Widget _host(List<Widget> children) {
	final grid = KlpMasonryGrid(children: children);
	final bounds = SizedBox(width: 640, height: 360, child: grid);
	return MaterialApp(theme: buildKlpTheme(Brightness.light), home: Center(child: bounds));
}

void main() {
	testWidgets('KlpMasonryGrid renders an initially empty collection', (tester) async {
		await tester.pumpWidget(_host(const []));

		expect(tester.takeException(), isNull);
		expect(find.byType(KlpMasonryGrid), findsOneWidget);
	});

	testWidgets('KlpMasonryGrid restores children after becoming empty', (tester) async {
		const first = SizedBox(width: 80, height: 40, child: Text('first child'));
		const second = SizedBox(width: 80, height: 60, child: Text('second child'));
		const children = <Widget>[first, second];

		await tester.pumpWidget(_host(children));
		expect(tester.takeException(), isNull);
		expect(find.byWidget(first), findsOneWidget);
		expect(find.byWidget(second), findsOneWidget);

		await tester.pumpWidget(_host(const []));
		expect(tester.takeException(), isNull);
		expect(find.byWidget(first), findsNothing);
		expect(find.byWidget(second), findsNothing);

		// 同一組公開 child 必須能在空狀態後再次呈現。
		await tester.pumpWidget(_host(children));
		expect(tester.takeException(), isNull);
		expect(find.byWidget(first), findsOneWidget);
		expect(find.byWidget(second), findsOneWidget);
	});
}
