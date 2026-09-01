import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

import 'style_fixture.dart';

void main() {
	Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
		MaterialApp(
			theme: buildKlpTheme(Brightness.light),
			home: Scaffold(body: SingleChildScrollView(child: child)),
		),
	);

	testWidgets('proposal actions remain three distinct typed callbacks', (tester) async {
		var confirmations = 0;
		var rejections = 0;
		var revisions = 0;
		await pump(
			tester,
			KlpProposalReview(
				title: 'Proposal',
				summary: 'Summary',
				versionLabel: 'v1',
				statusLabel: 'Ready',
				affectedLabel: '1 artifact',
				changes: const [KlpProposalChangeData(path: 'screens/Home', kindLabel: 'Create', reason: 'New screen', kind: KlpProposalChangeKind.create)],
				confirmLabel: 'Confirm',
				rejectLabel: 'Reject',
				reviseLabel: 'Revise',
				onConfirm: () => confirmations += 1,
				onReject: () => rejections += 1,
				onRevise: () => revisions += 1,
			),
		);

		await tester.tap(find.widgetWithText(KlpButton, 'Confirm'));
		await tester.tap(find.widgetWithText(KlpButton, 'Reject'));
		await tester.tap(find.widgetWithText(KlpButton, 'Revise'));
		expect((confirmations, rejections, revisions), (1, 1, 1));
	});

	testWidgets('stale proposal disables confirmation but keeps recovery actions', (tester) async {
		var confirmations = 0;
		var revisions = 0;
		await pump(
			tester,
			KlpProposalReview(
				title: 'Proposal',
				summary: 'Summary',
				versionLabel: 'v1',
				statusLabel: 'Stale',
				affectedLabel: '1 artifact',
				changes: const [],
				confirmLabel: 'Confirm',
				rejectLabel: 'Reject',
				reviseLabel: 'Revise',
				staleMessage: 'The base revision changed.',
				onConfirm: () => confirmations += 1,
				onRevise: () => revisions += 1,
			),
		);

		final confirm = tester.widget<KlpButton>(find.widgetWithText(KlpButton, 'Confirm'));
		expect(confirm.onPressed, isNull);
		await tester.tap(find.widgetWithText(KlpButton, 'Revise'));
		expect((confirmations, revisions), (0, 1));
	});

	testWidgets('proposal header wraps without overflowing a narrow panel', (tester) async {
		await pump(
			tester,
			const SizedBox(
				width: 200,
				child: KlpProposalReview(
					title: 'Checkout application proposal',
					summary: 'Summary',
					versionLabel: 'Revision 3',
					statusLabel: 'Awaiting confirmation',
					affectedLabel: '4 artifacts',
					changes: [],
					confirmLabel: 'Confirm',
					rejectLabel: 'Reject',
					reviseLabel: 'Revise',
				),
			),
		);

		expect(tester.takeException(), isNull);
	});

	testWidgets('preview tree exposes proposal-specific semantics and can be disabled', (tester) async {
		final semantics = tester.ensureSemantics();
		var selected = '';
		await pump(
			tester,
			KlpPreviewTree(
				label: 'Proposed project',
				enabled: false,
				nodes: const [KlpPreviewTreeNode(id: 'home', label: 'Home', accessibilityLabel: 'Proposed page Home')],
				onSelected: (value) => selected = value,
			),
		);

		expect(find.bySemanticsLabel(RegExp('Proposed page Home')), findsOneWidget);
		await tester.tap(find.text('Home'), warnIfMissed: false);
		expect(selected, isEmpty);
		semantics.dispose();
	});

	testWidgets('publication overlay paints last and blocks preview hit testing', (tester) async {
		var presses = 0;
		Widget subject(bool visible) => SizedBox(
			height: 120,
			child: KlpPublicationProgressOverlay(
				visible: visible,
				progress: const KlpWorkflowProgress(stages: [KlpWorkflowStageData(label: 'Publish', statusLabel: 'Active', complete: false, active: true)]),
				child: KlpButton(label: 'Preview action', onPressed: () => presses += 1),
			),
		);

		await pump(tester, subject(true));
		await tester.tap(find.widgetWithText(KlpButton, 'Preview action'), warnIfMissed: false);
		expect(presses, 0);

		await pump(tester, subject(false));
		await tester.tap(find.widgetWithText(KlpButton, 'Preview action'));
		expect(presses, 1);
	});

	for (final style in [KlpVisualStyle.defaultStyle, contrastingStyle]) {
		testWidgets('workflow surfaces resolve ${style.name} semantic tokens', (tester) async {
			await tester.pumpWidget(
				MaterialApp(
					theme: buildKlpTheme(Brightness.light, style: style),
					home: Scaffold(
						body: ListView(
							children: const [
								KlpWorkflowStateSurface(state: KlpWorkflowState.ready, title: 'Proposal', message: 'Ready', statusLabel: 'Ready'),
								SizedBox(height: 120, child: KlpCanvasViewport(child: KlpText('Canvas'))),
							],
						),
					),
				),
			);

			final surface = tester.widget<KlpSurface>(
				find.descendant(of: find.byType(KlpWorkflowStateSurface), matching: find.byType(KlpSurface)),
			);
			expect(surface.padding, EdgeInsets.all(style.spacing.base));
			final canvas = tester.widget<ColoredBox>(
				find.descendant(of: find.byType(KlpCanvasViewport), matching: find.byType(ColoredBox)),
			);
			expect(canvas.color, style.colors.stageSurface);
			expect(tester.takeException(), isNull);
		});
	}
}
