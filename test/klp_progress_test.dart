import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
	testWidgets('progress 截斷比例並派送呼叫端提供的取消動作', (tester) async {
		var cancelled = false;

		await tester.pumpWidget(
			MaterialApp(
				theme: buildKlpTheme(Brightness.light),
				home: KlpProgress(
					value: 1.4,
					label: 'Uploading',
					detail: 'Finalizing',
					cancelLabel: 'Stop',
					onCancel: () => cancelled = true,
				),
			),
		);

		expect(find.text('Uploading'), findsOneWidget);
		expect(find.text('100%'), findsOneWidget);
		expect(find.text('Finalizing'), findsOneWidget);
		final fill = tester.widget<FractionallySizedBox>(
			find.descendant(
				of: find.byType(KlpProgress),
				matching: find.byType(FractionallySizedBox),
			),
		);
		expect(fill.widthFactor, 1);

		await tester.tap(find.text('Stop'));
		expect(cancelled, isTrue);
	});

	testWidgets('indeterminate progress 由 data geometry 決定填滿比例', (tester) async {
		final style = KlpVisualStyleJson.decode({
			'geometry': {
				'data': {'progressIndeterminateFraction': 0.42},
			},
		});

		await tester.pumpWidget(
			MaterialApp(
				theme: buildKlpTheme(Brightness.light, style: style),
				home: const KlpProgress(label: 'Working'),
			),
		);

		final fill = tester.widget<FractionallySizedBox>(
			find.descendant(
				of: find.byType(KlpProgress),
				matching: find.byType(FractionallySizedBox),
			),
		);
		expect(fill.widthFactor, 0.42);
	});

	test('progress indeterminate fraction 必須落在零到一之間', () {
		expect(
			() => KlpVisualStyleJson.decode({
				'geometry': {
					'data': {'progressIndeterminateFraction': 1.1},
				},
			}),
			throwsA(
				isA<FormatException>().having(
					(error) => error.message,
					'path',
					contains('geometry.data.progressIndeterminateFraction'),
				),
			),
		);
	});
}
