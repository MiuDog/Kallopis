import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
	const steps = [
		KlpStepData(label: '建立'),
		KlpStepData(label: '審核', description: '待負責人確認'),
		KlpStepData(label: '完成'),
	];

	Future<void> pump(
		WidgetTester tester,
		Widget child, {
		KlpVisualStyle? style,
	}) async {
		await tester.pumpWidget(
			MaterialApp(
				theme: buildKlpTheme(Brightness.light, style: style),
				home: child,
			),
		);
		await tester.pumpAndSettle();
	}

	testWidgets('水平排列會畫出每一個步驟的標籤', (tester) async {
		await pump(tester, const KlpStepper(steps: steps, currentIndex: 1));

		expect(find.text('建立'), findsOneWidget);
		expect(find.text('審核'), findsOneWidget);
		expect(find.text('完成'), findsOneWidget);
		expect(find.text('待負責人確認'), findsOneWidget);
	});

	testWidgets('垂直排列一樣渲染全部步驟', (tester) async {
		await pump(
			tester,
			const KlpStepper(
				steps: steps,
				currentIndex: 0,
				direction: KlpStepperDirection.vertical,
			),
		);

		expect(find.text('建立'), findsOneWidget);
		expect(find.text('完成'), findsOneWidget);
	});

	testWidgets('已完成的步驟用打勾圖示，未完成的步驟顯示序號', (tester) async {
		await pump(tester, const KlpStepper(steps: steps, currentIndex: 1));

		// index 0 已完成 → 打勾圖示；index 1、2 顯示序號文字。
		expect(find.byType(KlpIcon), findsOneWidget);
		expect(find.text('2'), findsOneWidget);
		expect(find.text('3'), findsOneWidget);
	});

	testWidgets('marker 與水平標籤寬度由 data geometry 解析', (tester) async {
		await pump(tester, const KlpStepper(steps: steps, currentIndex: 1));

		final markers = find.byWidgetPredicate(
			(widget) => widget.runtimeType.toString() == '_KlpStepMarker',
		);
		expect(tester.getSize(markers.first), const Size.square(24));
		expect(
			find.byWidgetPredicate(
				(widget) => widget is KlpBox && widget.width == 60,
			),
			findsNWidgets(3),
		);

		final style = KlpVisualStyleJson.decode({
			'geometry': {
				'data': {
					'stepperMarkerSize': 30,
					'stepperLabelWidth': 72,
				},
			},
		});
		await pump(
			tester,
			const KlpStepper(steps: steps, currentIndex: 1),
			style: style,
		);

		expect(tester.getSize(markers.first), const Size.square(30));
		expect(
			find.byWidgetPredicate(
				(widget) => widget is KlpBox && widget.width == 72,
			),
			findsNWidgets(3),
		);
	});
}
