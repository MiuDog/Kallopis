import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_workspace_block.dart';

import 'support/klp_test_primitives.dart';

final class _IntCodec implements KlpRouteCodec<int> {
	const _IntCodec();

	@override
	int decode(Map<String, String> values) => int.parse(values['value']!);

	@override
	Map<String, String> encode(int parameters) => {'value': '$parameters'};
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
						content: [
							KlpWorkspaceBlock(
								id: KlpId.parse('item'),
								kind: KlpWorkspaceBlockKind.action,
								title: label,
								action: action,
							),
						],
					),
				],
			),
		),
	),
);

Future<void> _activate(WidgetTester tester) async {
	await tester.tap(find.byType(KlpFlutterWorkspaceBlock));
}

KlpApplication _restoredApplication({
	required KlpDestination<int, String> home,
	required void Function(KlpNavigationRestoration) observer,
}) {
	return KlpApplication(
		title: 'Restoration observer',
		primitives: klpTestPrimitives(),
		router: KlpRouter(
			id: KlpId.root('router'),
			initial: home.location(0),
			restoration: KlpNavigationRestoration(
				routerId: 'router',
				stack: [
					KlpRouteAddress(
						destinationId: 'home',
						parameters: {'value': '2'},
					),
				],
			),
			routes: [
				KlpRoute<int, String>(home, screen: (_) => _screen('Home')),
			],
		),
		onNavigationRestorationChanged: observer,
	);
}

void main() {
	testWidgets(
		'restores a typed retained stack and publishes every committed stack',
		(tester) async {
			final home = KlpDestination<int, String>(
				KlpId.parse('home'),
				codec: const _IntCodec(),
			);
			final detail = KlpDestination<int, String>(
				KlpId.parse('detail'),
				codec: const _IntCodec(),
			);
			final restorations = <KlpNavigationRestoration>[];
			final application = KlpApplication(
				title: 'Restoration',
				primitives: klpTestPrimitives(),
				router: KlpRouter(
					id: KlpId.root('router'),
					initial: home.location(0),
					restoration: KlpNavigationRestoration(
						routerId: 'router',
						stack: [
							KlpRouteAddress(
								destinationId: 'home',
								parameters: {'value': '2'},
							),
							KlpRouteAddress(
								destinationId: 'detail',
								parameters: {'value': '7'},
							),
						],
					),
					routes: [
						KlpRoute<int, String>(home, screen: (_) => _screen('Home')),
						KlpRoute<int, String>(
							detail,
							screen: (input) =>
									_screen('Detail ${input.parameters}', action: input.back()),
						),
					],
				),
				onNavigationRestorationChanged: restorations.add,
			);
			final source = KlpMutableState(application);
			addTearDown(source.dispose);
			runKlpApp(source.readOnly);
			await tester.pump();
			await tester.pump();
		expect(find.text('Detail 7'), findsOneWidget);
		expect(
			restorations,
			hasLength(1),
			reason: restorations
				.map(
					(restoration) => restoration.stack
						.map((entry) => entry.destinationId)
						.toList(),
				)
				.toString(),
		);
		expect(restorations.single.stack.map((entry) => entry.destinationId), [
				'home',
				'detail',
			]);
			await _activate(tester);
			await tester.pump();
		expect(find.text('Home'), findsOneWidget);
			expect(restorations.last.stack.map((entry) => entry.destinationId), [
				'home',
			]);
			expect(tester.takeException(), isNull);
		},
	);

	test('rejects restoration data that belongs to a different router', () {
		final home = KlpDestination<int, String>(
			KlpId.parse('home'),
			codec: const _IntCodec(),
		);
		expect(
			() => KlpRouter(
				id: KlpId.root('router'),
				initial: home.location(0),
				restoration: KlpNavigationRestoration(
					routerId: 'other',
					stack: [
						KlpRouteAddress(destinationId: 'home', parameters: {'value': '0'}),
					],
				),
				routes: [KlpRoute<int, String>(home, screen: (_) => _screen('Home'))],
			),
			throwsArgumentError,
		);
	});

	testWidgets('publishes the current stack to a replacement observer', (
		tester,
	) async {
		final home = KlpDestination<int, String>(
			KlpId.parse('home'),
			codec: const _IntCodec(),
		);
		final first = <KlpNavigationRestoration>[];
		final second = <KlpNavigationRestoration>[];
		final source = KlpMutableState(
			_restoredApplication(home: home, observer: first.add),
		);
		addTearDown(source.dispose);
		runKlpApp(source.readOnly);
		await tester.pump();
		await tester.pump();
		expect(first, hasLength(1));

		source.value = _restoredApplication(home: home, observer: second.add);
		await tester.pump();
		await tester.pump();
		expect(first, hasLength(1));
		expect(second, hasLength(1));
		expect(second.single.stack.single.destinationId, 'home');
		expect(tester.takeException(), isNull);
	});

	testWidgets('retries an unchanged stack after an observer throws', (
		tester,
	) async {
		final home = KlpDestination<int, String>(
			KlpId.parse('home'),
			codec: const _IntCodec(),
		);
		var calls = 0;
		void observer(KlpNavigationRestoration restoration) {
			calls++;
			if (calls == 1) {
				throw StateError('observer failure');
			}
		}

		final source = KlpMutableState(
			_restoredApplication(home: home, observer: observer),
		);
		addTearDown(source.dispose);
		runKlpApp(source.readOnly);
		await tester.pump();
		await tester.pump();
		expect(calls, 2);
		expect(tester.takeException(), isA<StateError>());
	});

	testWidgets(
		'runs each restored route enter guard before installing retained pages',
		(tester) async {
			final home = KlpDestination<int, String>(
				KlpId.parse('home'),
				codec: const _IntCodec(),
			);
			final detail = KlpDestination<int, String>(
				KlpId.parse('detail'),
				codec: const _IntCodec(),
			);
			var homeGuardCalls = 0;
			final restorations = <KlpNavigationRestoration>[];
			final source = KlpMutableState(
				KlpApplication(
					title: 'Rejected restoration',
					primitives: klpTestPrimitives(),
					router: KlpRouter(
						id: KlpId.root('router'),
						initial: home.location(0),
						restoration: KlpNavigationRestoration(
							routerId: 'router',
							stack: [
								KlpRouteAddress(
									destinationId: 'home',
									parameters: {'value': '2'},
								),
								KlpRouteAddress(
									destinationId: 'detail',
									parameters: {'value': '7'},
								),
							],
						),
						routes: [
							KlpRoute<int, String>(
								home,
								beforeEnter: (_) {
									homeGuardCalls++;
									return false;
								},
								screen: (_) => _screen('Home'),
							),
							KlpRoute<int, String>(detail, screen: (_) => _screen('Detail')),
						],
					),
					onNavigationRestorationChanged: restorations.add,
				),
			);
			addTearDown(source.dispose);
			runKlpApp(source.readOnly);
			await tester.pump();
			await tester.pump();
			expect(homeGuardCalls, 1);
			expect(restorations, isEmpty);
		expect(find.byType(KlpFlutterWorkspaceBlock), findsNothing);
			expect(tester.takeException(), isNull);
		},
	);
}
