import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/features/editing/contracts/klp_editing_host_failure.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_workspace_block.dart';
import 'package:kallopis/src/rendering/flutter/klp_viewport_capabilities.dart';

import 'support/klp_application_test_fixture.dart';
import 'support/klp_component_test_item.dart';
import 'support/klp_test_primitives.dart';

void main() {
	testWidgets('initial navigation failure renders its underlying error', (
		tester,
	) async {
		final destination = KlpDestination<Object?, Object?>(
			KlpId.parse('failed.initial'),
		);
		final error = StateError('initial navigation failure');
		final source = KlpMutableState(
			KlpApplication(
				title: 'Failed initial navigation',
				primitives: klpTestPrimitives(),
				router: KlpRouter(
					id: KlpId.parse('failed.router'),
					initial: destination.location(null),
					routes: [
						KlpRoute(
							destination,
							beforeEnter: (_) => throw error,
							screen: (_) => KlpScreen(
								id: KlpId.parse('failed.screen'),
								accessibilityLabel: 'Failed initial navigation',
								child: KlpAppLayout(
									id: KlpId.parse('failed.layout'),
									child: KlpAppFrame(
										id: KlpId.parse('failed.frame'),
										child: KlpFrameGroups(
											id: KlpId.parse('failed.groups'),
											groups: const [],
										),
									),
								),
							),
						),
					],
				),
			),
		);
		addTearDown(source.dispose);
		final originalHandler = FlutterError.onError;
		final reports = <FlutterErrorDetails>[];
		FlutterError.onError = reports.add;
		try {
			runKlpApp(source.readOnly);
			await tester.pump();
			await tester.pump();
			expect(reports.single.exception, same(error));
			expect(
				tester.widget<ErrorWidget>(find.byType(ErrorWidget)).message,
				error.toString(),
			);
		}
		finally {
			FlutterError.onError = originalHandler;
		}
	});

	testWidgets('runKlpApp installs typed editing failure sink into the existing recovery route', (tester) async {
		final source = KlpMutableState(klpApplicationTestFixture());
		addTearDown(source.dispose);
		runKlpApp(source.readOnly);
		await tester.pump();
		await tester.pump();
		final viewport = tester.widget<KlpViewportCapabilities>(find.byType(KlpViewportCapabilities));
		final originalHandler = FlutterError.onError;
		final reports = <FlutterErrorDetails>[];
		FlutterError.onError = reports.add;
		try {
			for (final origin in KlpEditingHostOrigin.values) {
				final error = StateError('original ${origin.name}');
				final stack = StackTrace.fromString('original ${origin.name} stack');
				final failure = KlpEditingHostFailure(origin: origin, phase: KlpEditingHostPhase.interrupt, error: error, stackTrace: stack);
				viewport.onEditingHostFailure(failure);
				expect(reports, hasLength(origin.index + 1));
				expect(reports.last.exception, same(error));
				expect(reports.last.stack, same(stack));
				expect(reports.last.library, 'kallopis application');
				expect(reports.last.context.toString(), contains(origin.name));
				expect(reports.last.context.toString(), contains('interrupt'));
			}
		}
		finally {
			FlutterError.onError = originalHandler;
		}
		await tester.pumpWidget(const SizedBox.shrink());
		expect(source.isDisposed, isFalse);
		expect(tester.takeException(), isNull);
	});

	testWidgets('viewport sink identity change notifies mounted dependents', (tester) async {
		final first = <KlpEditingHostFailure>[];
		final second = <KlpEditingHostFailure>[];
		KlpEditingHostFailureSink? installed;
		var builds = 0;
		final dependent = Builder(builder: (context) {
			builds++;
			installed = KlpViewportCapabilities.of(context)!.onEditingHostFailure;
			return const SizedBox.shrink();
		});
		Widget host(KlpEditingHostFailureSink sink) => KlpViewportCapabilities(desktop: true, backHandlers: const [], onEditingHostFailure: sink, child: dependent);
		await tester.pumpWidget(host(first.add));
		expect(builds, 1);
		await tester.pumpWidget(host(second.add));
		expect(builds, 2);
		final failure = KlpEditingHostFailure(origin: KlpEditingHostOrigin.canva, phase: KlpEditingHostPhase.input, error: Object(), stackTrace: StackTrace.current);
		installed!(failure);
		expect(first, isEmpty);
		expect(second, [same(failure)]);
	});

	testWidgets(
		'public bootstrap mounts data and style replacement retains focus',
		(tester) async {
			var calls = 0;
			final item = KlpComponentTestItem(
				id: KlpId.parse('a'),
				label: 'A',
				action: KlpCallbackAction(() => calls++),
			);
			final source = KlpMutableState(klpApplicationTestFixture(items: [item]));
			addTearDown(source.dispose);
			runKlpApp(source.readOnly);
			await tester.pump();
			await tester.pump();
			expect(tester.takeException(), isNull);
		await tester.tap(find.byType(KlpFlutterWorkspaceBlock));
			await tester.pump();
			expect(calls, 1);
			final focus = FocusManager.instance.primaryFocus;
			expect(focus, isNotNull);
			expect(focus!.hasPrimaryFocus, isTrue);

			source.value = klpApplicationTestFixture(
				title: 'Replaced style',
				items: [item],
				alternate: true,
			);
			await tester.pump();
		final updated = tester.widget<KlpFlutterWorkspaceBlock>(
		find.byType(KlpFlutterWorkspaceBlock),
			);
		expect(updated.content.title, 'A');
			expect(FocusManager.instance.primaryFocus, same(focus));
			expect(
		(
			updated.content.selectedBackground.red,
			updated.content.selectedBackground.green,
			updated.content.selectedBackground.blue,
			updated.content.selectedBackground.alpha,
		),
		(
			source.value.primitives.colors[5].red,
			source.value.primitives.colors[5].green,
			source.value.primitives.colors[5].blue,
			source.value.primitives.colors[5].alpha,
		),
			);
			expect(
				tester.widget<WidgetsApp>(find.byType(WidgetsApp)).title,
				'Replaced style',
			);
			expect(tester.takeException(), isNull);
			await tester.pumpWidget(const SizedBox.shrink());
			expect(source.value.title, 'Replaced style');
		},
	);

	testWidgets(
		'invalid declaration preserves committed presentation title and actions',
		(tester) async {
			var calls = 0;
			final item = KlpComponentTestItem(
				id: KlpId.parse('a'),
				label: 'A',
				action: KlpCallbackAction(() => calls++),
			);
			final source = KlpMutableState(klpApplicationTestFixture(items: [item]));
			addTearDown(source.dispose);
			runKlpApp(source.readOnly);
			await tester.pump();
			await tester.pump();
		final old = tester
			.widget<KlpFlutterWorkspaceBlock>(
				find.byType(KlpFlutterWorkspaceBlock),
			)
			.content;
			expect(
				() => source.value = klpApplicationTestFixture(
					title: 'Invalid',
					items: [item, item],
				),
				throwsA(isA<KlpContractError>()),
			);
			await tester.pump();
			expect(
				tester.widget<WidgetsApp>(find.byType(WidgetsApp)).title,
				'Initial application',
			);
			expect(
			tester
				.widget<KlpFlutterWorkspaceBlock>(
					find.byType(KlpFlutterWorkspaceBlock),
				)
				.content,
				same(old),
			);
		await tester.tap(find.byType(KlpFlutterWorkspaceBlock));
			await tester.pump();
			expect(calls, 1);
			expect(tester.takeException(), isNull);
			await tester.pumpWidget(const SizedBox.shrink());
		},
	);

	testWidgets(
		'removal revokes stale built-in actions',
		(tester) async {
			var calls = 0;
			final item = KlpComponentTestItem(
				id: KlpId.parse('a'),
				label: 'A',
				action: KlpCallbackAction(() => calls++),
			);
			final source = KlpMutableState(klpApplicationTestFixture(items: [item]));
			addTearDown(source.dispose);
			runKlpApp(source.readOnly);
			await tester.pump();
			await tester.pump();
		final previous = tester
			.widget<KlpFlutterWorkspaceBlock>(
				find.byType(KlpFlutterWorkspaceBlock),
			)
			.content;
		await tester.tap(find.byType(KlpFlutterWorkspaceBlock));
			await tester.pump();
			source.value = klpApplicationTestFixture();
		previous.onPressed!();
			expect(calls, 1);
			await tester.pump();
		expect(find.text('A'), findsNothing);
			expect(tester.takeException(), isNull);
			await tester.pumpWidget(const SizedBox.shrink());
		},
	);

	testWidgets(
		'replacing source detaches old subscription without disposing borrowed sources',
		(tester) async {
			final first = KlpMutableState(
				klpApplicationTestFixture(title: 'First source'),
			);
			final second = KlpMutableState(
				klpApplicationTestFixture(title: 'Second source'),
			);
			addTearDown(first.dispose);
			addTearDown(second.dispose);
			runKlpApp(first.readOnly);
			await tester.pump();
			await tester.pump();
			runKlpApp(second.readOnly);
			await tester.pump();
			await tester.pump();
			first.value = klpApplicationTestFixture(title: 'Detached update');
			await tester.pump();
			expect(
				tester.widget<WidgetsApp>(find.byType(WidgetsApp)).title,
				'Second source',
			);
			second.value = klpApplicationTestFixture(title: 'Current update');
			await tester.pump();
			expect(
				tester.widget<WidgetsApp>(find.byType(WidgetsApp)).title,
				'Current update',
			);
			await tester.pumpWidget(const SizedBox.shrink());
			expect(first.isDisposed, isFalse);
			expect(second.isDisposed, isFalse);
			expect(tester.takeException(), isNull);
		},
	);

	testWidgets('initial projection does not lose a source update', (
		tester,
	) async {
		late final KlpMutableState<KlpApplication> source;
		var updated = false;
		final first = KlpComponentTestItem(id: KlpId.parse('a'), label: 'A');
		final next = KlpComponentTestItem(id: KlpId.parse('a'), label: 'B');
		source = KlpMutableState(
			klpApplicationTestFixture(
				items: [first],
				select: (item) {
					if (!updated) {
						updated = true;
						source.value = klpApplicationTestFixture(
							title: 'Queued application',
							items: [next],
						);
					}
					return item.label;
				},
			),
		);
		addTearDown(source.dispose);
		runKlpApp(source.readOnly);
		await tester.pump();
		await tester.pump();
		expect(
			tester.widget<WidgetsApp>(find.byType(WidgetsApp)).title,
			'Queued application',
		);
		expect(
		find.text('B'),
		findsOneWidget,
		);
		expect(find.text('A'), findsNothing);
		expect(tester.takeException(), isNull);
		await tester.pumpWidget(const SizedBox.shrink());
	});

	testWidgets(
		'system motion preference rebuilds presentation without reinstalling state',
		(tester) async {
			var calls = 0;
			final source = KlpMutableState(
				klpApplicationTestFixture(
					items: [
						KlpComponentTestItem(
							id: KlpId.parse('a'),
							label: 'A',
							action: KlpCallbackAction(() => calls++),
						),
					],
				),
			);
			addTearDown(source.dispose);
			addTearDown(
				tester.binding.platformDispatcher.clearAccessibilityFeaturesTestValue,
			);
			runKlpApp(source.readOnly);
			await tester.pump();
			await tester.pump();
		final context = tester.element(find.byType(KlpFlutterWorkspaceBlock));
		final content = tester
			.widget<KlpFlutterWorkspaceBlock>(
				find.byType(KlpFlutterWorkspaceBlock),
			)
			.content;
			expect(MediaQuery.disableAnimationsOf(context), isFalse);

			tester.binding.platformDispatcher.accessibilityFeaturesTestValue =
					const FakeAccessibilityFeatures(disableAnimations: true);
			await tester.pump();
			expect(
				MediaQuery.disableAnimationsOf(
			tester.element(find.byType(KlpFlutterWorkspaceBlock)),
				),
				isTrue,
			);
		expect(
			tester
				.widget<KlpFlutterWorkspaceBlock>(
					find.byType(KlpFlutterWorkspaceBlock),
				)
				.content,
			same(content),
		);
			expect(
				find.byWidgetPredicate(
					(widget) => widget is TickerMode && !widget.enabled,
				),
				findsOneWidget,
			);

			tester.binding.platformDispatcher.accessibilityFeaturesTestValue =
					const FakeAccessibilityFeatures(reduceMotion: true);
			await tester.pump();
			expect(
				MediaQuery.disableAnimationsOf(
			tester.element(find.byType(KlpFlutterWorkspaceBlock)),
				),
				isFalse,
			);
			expect(
				find.byWidgetPredicate(
					(widget) => widget is TickerMode && widget.enabled,
				),
				findsAtLeastNWidgets(1),
			);
		await tester.tap(find.byType(KlpFlutterWorkspaceBlock));
			await tester.pump();
			expect(calls, 1);
			expect(tester.takeException(), isNull);
		},
	);
}
