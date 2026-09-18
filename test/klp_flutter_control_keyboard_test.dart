import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_control_style.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_text_style.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_control.dart';
import 'package:kallopis/src/styling/primitives/klp_style_value.dart';
import 'package:kallopis/src/styling/semantics/klp_control_density.dart';

final _style = KlpBoundControlStyle(
	density: KlpControlDensity(KlpDistance(32)),
	radius: KlpRadius(4),
	background: KlpColor(0, 0, 0),
	focus: KlpColor(0, 0, 0),
	text: KlpBoundTextStyle(
		color: KlpColor(0, 0, 0),
		fontSize: KlpFontSize(14),
		fontFamily: KlpFontFamily('test'),
		fontWeight: KlpFontWeight(400),
		lineHeight: KlpLineHeight(1),
		letterSpacing: KlpLetterSpacing(0),
	),
);

void main() {
	testWidgets(
		'custom keys fall back on ignored Enter and stop handled Space',
		(tester) async {
			final events = <LogicalKeyboardKey>[];
			var actions = 0;

			await tester.pumpWidget(
				Directionality(
					textDirection: TextDirection.ltr,
					child: KlpFlutterControl(
						style: _style,
						icon: null,
						caption: 'Grip',
						label: 'Grip',
						selected: false,
						touch: false,
						action: () => actions += 1,
						onKeyEvent: (_, event) {
							if (event is KeyDownEvent) {
								events.add(event.logicalKey);
							}
							return event.logicalKey == LogicalKeyboardKey.space ? KeyEventResult.handled : KeyEventResult.ignored;
						},
					),
				),
			);

			await tester.tap(find.text('Grip'));
			await tester.pump();
			expect(actions, 1);

			await tester.sendKeyEvent(LogicalKeyboardKey.enter);
			expect(events, [LogicalKeyboardKey.enter]);
			expect(actions, 2);

			await tester.sendKeyEvent(LogicalKeyboardKey.space);
			expect(events, [LogicalKeyboardKey.enter, LogicalKeyboardKey.space]);
			expect(actions, 2);
		},
	);

	testWidgets('ordinary controls activate with Enter and Space', (
		tester,
	) async {
		var actions = 0;

		await tester.pumpWidget(
			Directionality(
				textDirection: TextDirection.ltr,
				child: KlpFlutterControl(
					style: _style,
					icon: null,
					caption: 'Button',
					label: 'Button',
					selected: false,
					touch: false,
					action: () => actions += 1,
				),
			),
		);

		Focus.of(tester.element(find.text('Button'))).requestFocus();
		await tester.pump();
		await tester.sendKeyEvent(LogicalKeyboardKey.enter);
		await tester.sendKeyEvent(LogicalKeyboardKey.space);
		expect(actions, 2);
	});

	testWidgets('disabled controls do not activate', (tester) async {
		var actions = 0;

		await tester.pumpWidget(
			Directionality(
				textDirection: TextDirection.ltr,
				child: KlpFlutterControl(
					style: _style,
					icon: null,
					caption: 'Disabled',
					label: 'Disabled',
					selected: false,
					touch: false,
					enabled: false,
					action: () => actions += 1,
				),
			),
		);

		await tester.tap(find.text('Disabled'));
		Focus.of(tester.element(find.text('Disabled'))).requestFocus();
		await tester.sendKeyEvent(LogicalKeyboardKey.enter);
		await tester.sendKeyEvent(LogicalKeyboardKey.space);
		expect(actions, 0);
	});

	testWidgets('Tab traversal has one stop per control', (tester) async {
		final firstKey = GlobalKey();
		final secondKey = GlobalKey();

		await tester.pumpWidget(
			Directionality(
				textDirection: TextDirection.ltr,
				child: FocusTraversalGroup(
					policy: WidgetOrderTraversalPolicy(),
					child: Row(children: [
						KlpFlutterControl(key: firstKey, style: _style, icon: null, caption: 'First', label: 'First', selected: false, touch: false, action: () {}),
						KlpFlutterControl(key: secondKey, style: _style, icon: null, caption: 'Second', label: 'Second', selected: false, touch: false, action: () {}),
					]),
				),
			),
		);

		final first = tester.widgetList<Focus>(find.descendant(of: find.byKey(firstKey), matching: find.byType(Focus))).first.focusNode!;
		final second = tester.widgetList<Focus>(find.descendant(of: find.byKey(secondKey), matching: find.byType(Focus))).first.focusNode!;
		first.requestFocus();
		await tester.pump();
		expect(first.hasPrimaryFocus, isTrue);
		expect(first.nextFocus(), isTrue);
		await tester.pump();
		expect(second.hasPrimaryFocus, isTrue);
	});
}
