import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_foundation.dart';

void main() {
	testWidgets('KlpWrap resolves semantic spacing', (tester) async {
		await tester.pumpWidget(
			MaterialApp(
				theme: buildKlpTheme(Brightness.light),
				home: KlpWrap(
					spacingSize: KlpSpaceSize.action,
					runSpacingSize: KlpSpaceSize.tight,
					children: const [KlpBox.square(dimension: 8), KlpBox.square(dimension: 8)],
				),
			),
		);

		final wrap = tester.widget<Wrap>(find.byType(Wrap));
		final context = tester.element(find.byType(KlpWrap));
		expect(wrap.spacing, context.klp.space.actionGap);
		expect(wrap.runSpacing, context.klp.space.tight);
	});

	testWidgets('KlpGestureRegion forwards tap events', (tester) async {
		var taps = 0;
		await tester.pumpWidget(
			Directionality(
				textDirection: TextDirection.ltr,
				child: KlpGestureRegion(
					behavior: HitTestBehavior.opaque,
					onTap: () => taps += 1,
					child: const KlpBox.square(dimension: 24),
				),
			),
		);

		await tester.tap(find.byType(KlpGestureRegion));
		expect(taps, 1);
	});

	testWidgets('KlpGap resolves chrome toolbar semantic spacing', (tester) async {
		await tester.pumpWidget(
			MaterialApp(
				theme: buildKlpTheme(Brightness.light),
				home: const KlpGap.widthSize(KlpSpaceSize.chromeToolbar),
			),
		);

		final context = tester.element(find.byType(KlpGap));
		final gap = tester.widget<SizedBox>(
			find.descendant(
				of: find.byType(KlpGap),
				matching: find.byType(SizedBox),
			),
		);
		expect(gap.width, context.klp.space.chromeToolbarGap);
	});

	testWidgets('KlpGap resolves the exact xxs spacing token', (tester) async {
		await tester.pumpWidget(
			MaterialApp(
				theme: buildKlpTheme(Brightness.light),
				home: const KlpGap.widthSize(KlpSpaceSize.xxs),
			),
		);

		final context = tester.element(find.byType(KlpGap));
		final gap = tester.widget<SizedBox>(
			find.descendant(
				of: find.byType(KlpGap),
				matching: find.byType(SizedBox),
			),
		);
		expect(gap.width, context.klp.space.xxs);
	});

	testWidgets('KlpGap resolves navigation rail item spacing', (tester) async {
		await tester.pumpWidget(
			MaterialApp(
				theme: buildKlpTheme(Brightness.light),
				home: const KlpGap.heightSize(KlpSpaceSize.navigationRailItem),
			),
		);

		final context = tester.element(find.byType(KlpGap));
		final gap = tester.widget<SizedBox>(
			find.descendant(
				of: find.byType(KlpGap),
				matching: find.byType(SizedBox),
			),
		);
		expect(gap.height, context.klp.space.navigationRailItemGap);
	});

	testWidgets('KlpBox resolves navigation rail control size', (tester) async {
		await tester.pumpWidget(
			MaterialApp(
				theme: buildKlpTheme(Brightness.light),
				home: const KlpBox(
					widthSize: KlpSpaceSize.navigationRailControl,
					heightSize: KlpSpaceSize.navigationRailControl,
				),
			),
		);

		final context = tester.element(find.byType(KlpBox));
		final box = tester.widget<SizedBox>(
			find.descendant(
				of: find.byType(KlpBox),
				matching: find.byType(SizedBox),
			).first,
		);
		expect(box.width, context.klp.space.railItem);
		expect(box.height, context.klp.space.railItem);
	});
}
