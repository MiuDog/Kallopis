import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
	Future<void> pump(WidgetTester tester, Widget child) {
		return tester.pumpWidget(
			MaterialApp(theme: buildKlpTheme(Brightness.light), home: child),
		);
	}

	testWidgets('document 組件保留標頭、章節、欄位與參照事件', (tester) async {
		var referencePressed = false;
		await pump(
			tester,
			KlpColumn(
				children: [
					const KlpDocumentHeader(
						title: 'Project brief',
						revisionLabel: 'r12',
						statusLabel: 'Current',
						stale: true,
					),
					const KlpDocumentSection(
						title: 'Audience',
						description: 'Primary users',
						child: KlpDocumentField(
							label: 'Name',
							help: 'Canonical name',
							value: KlpText('Operations'),
						),
					),
					KlpDocumentReferenceLink(
						label: 'Home screen',
						detail: 'screens/Home',
						onPressed: () => referencePressed = true,
					),
				],
			),
		);

		for (final label in [
			'Project brief',
			'R12',
			'CURRENT',
			'Audience',
			'Primary users',
			'Name',
			'Canonical name',
			'Operations',
		]) {
			expect(find.text(label), findsOneWidget);
		}

		await tester.tap(find.text('Home screen · screens/Home'));
		expect(referencePressed, isTrue);
	});

	testWidgets('document edit actions 只呈現目前有限狀態的動作', (tester) async {
		var saved = false;
		var cancelled = false;
		await pump(
			tester,
			KlpDocumentEditActions(
				editing: true,
				editLabel: 'Edit',
				saveLabel: 'Save',
				cancelLabel: 'Cancel',
				onSave: () => saved = true,
				onCancel: () => cancelled = true,
			),
		);

		expect(find.text('Edit'), findsNothing);
		await tester.tap(find.text('Save'));
		await tester.tap(find.text('Cancel'));
		expect(saved, isTrue);
		expect(cancelled, isTrue);
	});

	testWidgets('token table 與 validation banner 只呈現呼叫端投影', (
		tester,
	) async {
		await pump(
			tester,
			KlpColumn(
				children: [
					const KlpTokenTable(
						nameLabel: 'Name',
						typeLabel: 'Type',
						valueLabel: 'Value',
						referenceLabel: 'Reference',
						statusLabel: 'Status',
						tokens: [
							KlpTokenDefinitionData(
								name: 'color.action',
								typeLabel: 'Color',
								valueLabel: 'brand.primary',
								referenceLabel: 'blue.600',
								statusLabel: 'Valid',
								preview: KlpText('●'),
							),
						],
					),
					const KlpTokenValidationBanner(
						title: 'Token graph',
						message: 'All references resolve.',
						valid: true,
					),
				],
			),
		);

		for (final label in [
			'color.action',
			'Color',
			'brand.primary',
			'blue.600',
			'VALID',
			'Token graph',
			'All references resolve.',
		]) {
			expect(find.text(label), findsOneWidget);
		}
	});

	testWidgets('component library、state selector 與 accessibility 保留事件', (
		tester,
	) async {
		String? selectedId;
		int? selectedState;
		await pump(
			tester,
			KlpColumn(
				children: [
					KlpComponentLibraryGrid(
						components: const [
							KlpComponentDefinitionData(
								id: 'button',
								name: 'Button',
								statusLabel: 'Ready',
								description: 'Primary action',
								preview: KlpText('Preview'),
							),
						],
						onSelected: (id) => selectedId = id,
					),
					KlpComponentStateSelector(
						labels: const ['Default', 'Focus'],
						selectedIndex: 0,
						onSelected: (index) => selectedState = index,
					),
					const KlpAccessibilityContractPanel(
						title: 'Accessibility',
						items: {'Role': 'button'},
					),
				],
			),
		);

		await tester.tap(find.text('Preview'));
		await tester.tap(find.text('Focus'));
		expect(selectedId, 'button');
		expect(selectedState, 1);
		expect(find.text('Accessibility'), findsOneWidget);
		expect(find.text('Role'), findsOneWidget);
		expect(find.text('button'), findsOneWidget);
	});
}
