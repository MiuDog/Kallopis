import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/capabilities/actions/klp_action.dart';

KlpWorkspaceBlock _actionBlock(
	String label, {
	KlpAction? action,
}) {
	return KlpWorkspaceBlock(
		id: KlpId.parse('action'),
		kind: KlpWorkspaceBlockKind.action,
		title: label,
		action: action,
	);
}

KlpScreen _screen(String label, {KlpAction? action}) => KlpScreen(
	id: KlpId.parse('screen'),
	accessibilityLabel: label,
	child: KlpAppLayout(
		id: KlpId.parse('layout'),
		child: KlpAppFrame(
			id: KlpId.parse('frame'),
			child: KlpFrameGroups(
				id: KlpId.parse('groups'),
				groups: [
					KlpFrameGroup(
						id: KlpId.parse('group'),
						content: [_actionBlock(label, action: action)],
					),
				],
			),
		),
	),
);

KlpApplication _app(
	KlpDestination<int, String> home,
	List<KlpRoute<Object?, Object?>> routes, {
	String title = 'Review',
}) => KlpApplication(
	title: title,
	router: KlpRouter(
		id: KlpId.root('router'),
		initial: home.location(0),
		routes: routes,
	),
);

void main() {
	test('built-in workspace action rejects a second callback authority', () {
		expect(
			() => KlpWorkspaceBlock(
				id: KlpId.parse('action'),
				kind: KlpWorkspaceBlockKind.action,
				title: 'Action',
				action: const KlpCallbackAction(_noop),
				onPressed: _noop,
			),
			throwsArgumentError,
		);
	});

	test('built-in workspace action rejects a non-action block kind', () {
		expect(
			() => KlpWorkspaceBlock(
				id: KlpId.parse('paper'),
				kind: KlpWorkspaceBlockKind.paper,
				title: 'Paper',
				action: const KlpCallbackAction(_noop),
			),
			throwsArgumentError,
		);
	});

	testWidgets('built-in workspace action commits navigation', (tester) async {
		final home = KlpDestination<int, String>(KlpId.parse('home'));
		final detail = KlpDestination<int, String>(KlpId.parse('detail'));
		final source = KlpMutableState(
			_app(home, [
				KlpRoute<int, String>(
					home,
					screen: (input) => _screen(
						'Home',
						action: input.navigate(detail.location(1)),
					),
				),
				KlpRoute<int, String>(
					detail,
					screen: (_) => _screen('Detail'),
				),
			]),
		);
		addTearDown(source.dispose);
		runKlpApp(source.readOnly);
		await tester.pump();
		await tester.pump();
		await tester.tap(find.text('Home'));
		await tester.pump();
		expect(find.text('Detail'), findsOneWidget);
		expect(tester.takeException(), isNull);
	});

	testWidgets('built-in workspace root back action is rejected', (
		tester,
	) async {
		final home = KlpDestination<int, String>(KlpId.parse('home'));
		final source = KlpMutableState(
			_app(home, [
				KlpRoute<int, String>(
					home,
					screen: (input) => _screen('Home', action: input.back()),
				),
			]),
		);
		addTearDown(source.dispose);
		runKlpApp(source.readOnly);
		await tester.pump();
		await tester.pump();
		await tester.tap(find.text('Home'));
		await tester.pump();
		expect(find.text('Home'), findsOneWidget);
		expect(tester.takeException(), isNull);
	});

	testWidgets('refresh revokes the prior built-in workspace callback', (
		tester,
	) async {
		final home = KlpDestination<int, String>(KlpId.parse('home'));
		final detail = KlpDestination<int, String>(KlpId.parse('detail'));
		final detailRoute = KlpRoute<int, String>(
			detail,
			screen: (_) => _screen('Detail'),
		);
		final source = KlpMutableState(
			_app(home, [
				KlpRoute<int, String>(
					home,
					screen: (input) => _screen(
						'First',
						action: input.navigate(detail.location(1)),
					),
				),
				detailRoute,
			]),
		);
		addTearDown(source.dispose);
		runKlpApp(source.readOnly);
		await tester.pump();
		await tester.pump();
		final stale = tester
			.widget<GestureDetector>(
				find.ancestor(
					of: find.text('First'),
					matching: find.byType(GestureDetector),
				).first,
			)
			.onTap!;
		source.value = _app(
			home,
			[
				KlpRoute<int, String>(
					home,
					screen: (input) => _screen('Fresh', action: input.back()),
				),
				detailRoute,
			],
			title: 'Fresh',
		);
		await tester.pump();
		stale();
		await tester.pump();
		expect(find.text('Fresh'), findsOneWidget);
		expect(find.text('Detail'), findsNothing);
		expect(tester.takeException(), isNull);
	});
}

void _noop() {}
