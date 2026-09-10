import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
	testWidgets('compound field 展開選項、忽略 disabled 並在選取後收合', (
		tester,
	) async {
		String? selectedId;
		await tester.pumpWidget(
			MaterialApp(
				theme: buildKlpTheme(Brightness.light),
				home: KlpCompoundField(
					label: 'Role',
					selectedOptionLabel: 'Choose',
					options: const [
						KlpChoiceOption(id: 'admin', label: 'Admin'),
						KlpChoiceOption(id: 'owner', label: 'Owner', disabled: true),
					],
					onOptionSelected: (id) => selectedId = id,
				),
			),
		);

		expect(find.text('Admin'), findsNothing);
		await tester.tap(find.text('Choose'));
		await tester.pump();
		expect(find.text('Admin'), findsOneWidget);
		expect(find.text('Owner'), findsOneWidget);

		await tester.tap(find.text('Owner'));
		await tester.pump();
		expect(selectedId, isNull);
		expect(find.text('Admin'), findsOneWidget);

		await tester.tap(find.text('Admin'));
		await tester.pump();
		expect(selectedId, 'admin');
		expect(find.text('Admin'), findsNothing);
	});

	testWidgets('compound field 保留文字事件與選項可及性標籤', (tester) async {
		String? value;
		await tester.pumpWidget(
			MaterialApp(
				theme: buildKlpTheme(Brightness.light),
				home: KlpCompoundField(
					label: 'User',
					selectedOptionLabel: 'Admin',
					options: const [KlpChoiceOption(id: 'admin', label: 'Admin')],
					onChanged: (next) => value = next,
					onOptionSelected: (_) {},
					optionsLabel: 'Choose role',
				),
			),
		);

		await tester.enterText(find.byType(TextFormField), 'Daniel');
		expect(value, 'Daniel');
		final semantics = tester.getSemantics(find.text('Admin'));
		expect(semantics.label, contains('Choose role'));
		expect(semantics.label, contains('Admin'));
		expect(semantics.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
		expect(
			semantics.getSemanticsData().flagsCollection.isButton,
			isTrue,
		);
		expect(
			semantics.getSemanticsData().flagsCollection.isEnabled,
			Tristate.isTrue,
		);
	});

	testWidgets('read-only compound field 不展開並保留錯誤文案', (
		tester,
	) async {
		await tester.pumpWidget(
			MaterialApp(
				theme: buildKlpTheme(Brightness.light),
				home: KlpCompoundField(
					label: 'Role',
					selectedOptionLabel: 'Choose',
					options: const [
						KlpChoiceOption(id: 'admin', label: 'Admin'),
					],
					onOptionSelected: (_) {},
					readOnly: true,
					error: 'Required',
				),
			),
		);

		await tester.tap(find.text('Choose'));
		await tester.pump();
		expect(find.text('Admin'), findsNothing);
		expect(find.text('Required'), findsOneWidget);
	});
}
