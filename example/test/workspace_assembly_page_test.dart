import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';
import 'package:kallopis_catalog/catalog/workspace_assembly_page.dart';

void main() {
	testWidgets('workspace assembly exposes every reference composition', (tester) async {
		tester.view.physicalSize = const Size(1200, 900);
		tester.view.devicePixelRatio = 1;
		addTearDown(tester.view.resetPhysicalSize);
		addTearDown(tester.view.resetDevicePixelRatio);

		await tester.pumpWidget(
			MaterialApp(
				theme: buildKlpTheme(Brightness.light),
				home: Scaffold(
					body: SingleChildScrollView(
						child: Builder(builder: workspaceAssemblyPage.tokenView!),
					),
				),
			),
		);
		await tester.pump();

		expect(find.byType(KlpWorkflowComposer), findsOneWidget);
		expect(find.byType(KlpProposalReview), findsOneWidget);

		await _select(tester, 'Docs');
		expect(find.byType(KlpDocumentHeader), findsOneWidget);

		await _select(tester, 'Tokens');
		expect(find.byType(KlpTokenTable), findsOneWidget);

		await _select(tester, 'Components');
		expect(find.byType(KlpComponentLibraryGrid), findsOneWidget);

		await _select(tester, 'Screen');
		expect(find.byType(KlpCanvasViewport), findsOneWidget);
		expect(find.byType(KlpCanvasSelectionOverlay), findsOneWidget);
		expect(tester.takeException(), isNull);
	});
}

Future<void> _select(WidgetTester tester, String label) async {
	await tester.tap(find.text(label));
	await tester.pump();
	expect(tester.takeException(), isNull, reason: label);
}
