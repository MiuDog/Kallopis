import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
	testWidgets('rail item 使用共用 action region 並保留 selected 視覺', (
		tester,
	) async {
		var pressed = false;
		await tester.pumpWidget(
			MaterialApp(
				theme: buildKlpTheme(Brightness.light),
				home: KlpRailItem(
					icon: KlpIcons.inbox,
					label: 'Inbox',
					onPressed: () => pressed = true,
					selected: true,
					badge: '3',
				),
			),
		);

		final context = tester.element(find.byType(KlpRailItem));
		final action = find.byType(KlpActionRegion);
		final material = tester.widget<Material>(
			find.descendant(of: action, matching: find.byType(Material)).first,
		);
		final icon = tester.widget<KlpIcon>(find.byType(KlpIcon));
		expect(material.color, context.klpColors.selectionBackground);
		expect(icon.color, context.klpColors.selectionForeground);

		await tester.tap(find.byType(KlpRailItem));
		await tester.pump();
		expect(pressed, isTrue);
	});

	testWidgets('rail item hover 顯示 Kallopis tooltip surface', (tester) async {
		await tester.pumpWidget(
			MaterialApp(
				theme: buildKlpTheme(Brightness.light),
				home: Center(
					child: KlpRailItem(
						icon: KlpIcons.inbox,
						label: 'Inbox',
						onPressed: () {},
					),
				),
			),
		);

		final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
		await mouse.addPointer(location: Offset.zero);
		await mouse.moveTo(tester.getCenter(find.byType(KlpRailItem)));
		await tester.pump();

		expect(
			find.byKey(const ValueKey('rail-hover-label-Inbox')),
			findsOneWidget,
		);

		await mouse.moveTo(Offset.zero);
		await tester.pump();
		expect(
			find.byKey(const ValueKey('rail-hover-label-Inbox')),
			findsNothing,
		);
	});

	testWidgets('rail menu entry 透過既有 context menu 開啟動作', (tester) async {
		var selected = false;
		final entry = KlpRailMenuEntry(
			id: 'more',
			icon: KlpIcons.settings,
			label: 'More',
			items: [
				KlpMenuItemData(
					label: 'Archive',
					onPressed: () => selected = true,
				),
			],
		);
		await tester.pumpWidget(
			MaterialApp(
				theme: buildKlpTheme(Brightness.light),
				home: Builder(builder: entry.build),
			),
		);

		await tester.tap(find.byType(KlpRailItem));
		await tester.pump();
		expect(find.text('Archive'), findsOneWidget);

		await tester.tap(find.text('Archive'));
		await tester.pump();
		expect(selected, isTrue);
	});
}
