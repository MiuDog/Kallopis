import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
	testWidgets('command menu 由 theme 解析寬度並保留 item 視覺', (tester) async {
		var pressed = false;
		final base = KlpVisualStyle.defaultStyle;
		final style = base.copyWith(
			geometry: base.geometry.copyWith(
				layout: base.geometry.layout.copyWith(commandMenuWidth: 344),
			),
		);
		await tester.pumpWidget(
			MaterialApp(
				theme: buildKlpTheme(Brightness.light, style: style),
				home: Scaffold(
					body: KlpCommandMenu(
						sections: [
							KlpCommandSectionData(
								label: 'Actions',
								items: [
									KlpCommandItemData(
										label: 'Archive',
										onPressed: () => pressed = true,
										selected: true,
									),
								],
							),
						],
					),
				),
			),
		);

		final widthBox = find.byWidgetPredicate(
			(widget) =>
					widget is KlpBox &&
					widget.widthSize == KlpSpaceSize.commandMenuWidth,
		);
		final sizedBox = tester.widget<SizedBox>(
			find.descendant(of: widthBox, matching: find.byType(SizedBox)).first,
		);
		final context = tester.element(find.byType(KlpCommandMenu));
		expect(sizedBox.width, 344);
		expect(
			context.klp.geometry.layout.commandMenuWidth,
			344,
		);
		expect(
			find.byWidgetPredicate(
				(widget) =>
						widget is Material &&
						widget.color == context.klpColors.surfaceMuted,
			),
			findsOneWidget,
		);

		await tester.tap(find.text('Archive'));
		await tester.pump();
		expect(pressed, isTrue);
	});
}
