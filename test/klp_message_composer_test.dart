import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
	testWidgets('stacked composer 呈現 tags 並回報附件與送出事件', (tester) async {
		var attachCount = 0;
		var sendCount = 0;

		await tester.pumpWidget(
			MaterialApp(
				theme: buildKlpTheme(Brightness.light),
				home: KlpMessageComposer(
					tags: const ['Note', 'Project'],
					placeholder: 'Message',
					sendLabel: 'Send',
					attachLabel: 'Attach',
					onAttach: () => attachCount++,
					onSend: () => sendCount++,
				),
			),
		);

		expect(find.text('NOTE'), findsOneWidget);
		expect(find.text('PROJECT'), findsOneWidget);
		await tester.tap(find.bySemanticsLabel('Attach'));
		await tester.tap(find.text('Send'));
		expect(attachCount, 1);
		expect(sendCount, 1);
	});

	testWidgets('inline composer 保留文字輸入契約', (tester) async {
		String? changed;

		await tester.pumpWidget(
			MaterialApp(
				theme: buildKlpTheme(Brightness.light),
				home: KlpMessageComposer(
					placeholder: 'Message',
					sendLabel: 'Send',
					attachLabel: 'Attach',
					onAttach: () {},
					onSend: () {},
					onChanged: (value) => changed = value,
					inlineActions: true,
					minLines: 2,
					maxLines: 4,
					outlined: true,
				),
			),
		);

		final textArea = tester.widget<KlpTextArea>(find.byType(KlpTextArea));
		expect(textArea.minLines, 2);
		expect(textArea.maxLines, 4);
		expect(textArea.outlined, isTrue);

		await tester.enterText(find.byType(EditableText), 'Draft');
		expect(changed, 'Draft');
	});
}
