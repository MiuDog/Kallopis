import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_choice.dart';

import 'support/klp_application_test_fixture.dart';
import 'support/klp_component_test_item.dart';

void main() {
	testWidgets('public bootstrap mounts data and style replacement retains focus and selection', (tester) async {
		var calls = 0;
		final item = KlpComponentTestItem(id: 'a', label: 'A', action: KlpCallbackAction(() => calls++));
		final source = KlpMutableState(klpApplicationTestFixture(items: [item]));
		addTearDown(source.dispose);
		runKlpApp(source.readOnly);
		await tester.pump();
		await tester.pump();
		expect(tester.takeException(), isNull);
		final choice = tester.widget<KlpFlutterChoice>(find.byType(KlpFlutterChoice));
		final selection = choice.content.selection;
		await tester.tap(find.byType(KlpFlutterChoice));
		await tester.pump();
		expect(calls, 1);
		expect(selection.value, KlpPlacementId(scope: ['fixture.router', 'route-1'], localId: 'a'));
		final focus = FocusManager.instance.primaryFocus;
		expect(focus, isNotNull);
		expect(focus!.hasPrimaryFocus, isTrue);

		source.value = klpApplicationTestFixture(title: 'Replaced style', items: [item], alternate: true);
		await tester.pump();
		final updated = tester.widget<KlpFlutterChoice>(find.byType(KlpFlutterChoice));
		expect(updated.content.selection, same(selection));
		expect(updated.content.selection.value, KlpPlacementId(scope: ['fixture.router', 'route-1'], localId: 'a'));
		expect(FocusManager.instance.primaryFocus, same(focus));
		expect(updated.content.style.selectedBackground, same(source.value.primitives.colors[2]));
		expect(tester.widget<WidgetsApp>(find.byType(WidgetsApp)).title, 'Replaced style');
		expect(tester.takeException(), isNull);
		await tester.pumpWidget(const SizedBox.shrink());
		expect(() => selection.value, throwsStateError);
		expect(source.value.title, 'Replaced style');
	});

	testWidgets('invalid declaration preserves committed presentation title and actions', (tester) async {
		var calls = 0;
		final item = KlpComponentTestItem(id: 'a', label: 'A', action: KlpCallbackAction(() => calls++));
		final source = KlpMutableState(klpApplicationTestFixture(items: [item]));
		addTearDown(source.dispose);
		runKlpApp(source.readOnly);
		await tester.pump();
		await tester.pump();
		final old = tester.widget<KlpFlutterChoice>(find.byType(KlpFlutterChoice)).content;
		expect(() => source.value = klpApplicationTestFixture(title: 'Invalid', items: [item, item]), throwsA(isA<KlpContractError>()));
		await tester.pump();
		expect(tester.widget<WidgetsApp>(find.byType(WidgetsApp)).title, 'Initial application');
		expect(tester.widget<KlpFlutterChoice>(find.byType(KlpFlutterChoice)).content, same(old));
		await tester.tap(find.byType(KlpFlutterChoice));
		await tester.pump();
		expect(calls, 1);
		expect(old.selection.value, KlpPlacementId(scope: ['fixture.router', 'route-1'], localId: 'a'));
		expect(tester.takeException(), isNull);
		await tester.pumpWidget(const SizedBox.shrink());
	});

	testWidgets('removal clears selection and stale actions cannot reach removed callbacks', (tester) async {
		var calls = 0;
		final item = KlpComponentTestItem(id: 'a', label: 'A', action: KlpCallbackAction(() => calls++));
		final source = KlpMutableState(klpApplicationTestFixture(items: [item]));
		addTearDown(source.dispose);
		runKlpApp(source.readOnly);
		await tester.pump();
		await tester.pump();
		final previous = tester.widget<KlpFlutterChoice>(find.byType(KlpFlutterChoice)).content;
		await tester.tap(find.byType(KlpFlutterChoice));
		await tester.pump();
		source.value = klpApplicationTestFixture();
		expect(previous.selection.value, isNull);
		previous.onActivate!();
		expect(calls, 1);
		await tester.pump();
		expect(find.byType(KlpFlutterChoice), findsNothing);
		expect(tester.takeException(), isNull);
		await tester.pumpWidget(const SizedBox.shrink());
		expect(() => previous.selection.value, throwsStateError);
	});

	testWidgets('replacing source detaches old subscription without disposing borrowed sources', (tester) async {
		final first = KlpMutableState(klpApplicationTestFixture(title: 'First source'));
		final second = KlpMutableState(klpApplicationTestFixture(title: 'Second source'));
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
		expect(tester.widget<WidgetsApp>(find.byType(WidgetsApp)).title, 'Second source');
		second.value = klpApplicationTestFixture(title: 'Current update');
		await tester.pump();
		expect(tester.widget<WidgetsApp>(find.byType(WidgetsApp)).title, 'Current update');
		await tester.pumpWidget(const SizedBox.shrink());
		expect(first.isDisposed, isFalse);
		expect(second.isDisposed, isFalse);
		expect(tester.takeException(), isNull);
	});

	testWidgets('initial projection does not lose a source update', (tester) async {
		late final KlpMutableState<KlpApplication> source;
		var updated = false;
		final first = KlpComponentTestItem(id: 'a', label: 'A');
		final next = KlpComponentTestItem(id: 'a', label: 'B');
		source = KlpMutableState(klpApplicationTestFixture(items: [first], select: (item) {
			if (!updated) {
				updated = true;
				source.value = klpApplicationTestFixture(title: 'Queued application', items: [next]);
			}
			return item.label;
		}));
		addTearDown(source.dispose);
		runKlpApp(source.readOnly);
		await tester.pump();
		await tester.pump();
		expect(tester.widget<WidgetsApp>(find.byType(WidgetsApp)).title, 'Queued application');
		expect(tester.widget<KlpFlutterChoice>(find.byType(KlpFlutterChoice)).content.label, 'B');
		expect(find.text('A'), findsNothing);
		expect(tester.takeException(), isNull);
		await tester.pumpWidget(const SizedBox.shrink());
	});

	testWidgets('system motion preference rebuilds presentation without reinstalling state', (tester) async {
		var calls = 0;
		final source = KlpMutableState(klpApplicationTestFixture(items: [KlpComponentTestItem(id: 'a', label: 'A', action: KlpCallbackAction(() => calls++))]));
		addTearDown(source.dispose);
		addTearDown(tester.binding.platformDispatcher.clearAccessibilityFeaturesTestValue);
		runKlpApp(source.readOnly);
		await tester.pump();
		await tester.pump();
		final choice = tester.widget<KlpFlutterChoice>(find.byType(KlpFlutterChoice));
		final selection = choice.content.selection;
		final context = tester.element(find.byType(KlpFlutterChoice));
		expect(MediaQuery.disableAnimationsOf(context), isFalse);

		tester.binding.platformDispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(disableAnimations: true);
		await tester.pump();
		expect(MediaQuery.disableAnimationsOf(tester.element(find.byType(KlpFlutterChoice))), isTrue);
		expect(tester.widget<KlpFlutterChoice>(find.byType(KlpFlutterChoice)).content.selection, same(selection));
		expect(find.byWidgetPredicate((widget) => widget is TickerMode && !widget.enabled), findsOneWidget);

		tester.binding.platformDispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(reduceMotion: true);
		await tester.pump();
		expect(MediaQuery.disableAnimationsOf(tester.element(find.byType(KlpFlutterChoice))), isFalse);
		expect(find.byWidgetPredicate((widget) => widget is TickerMode && widget.enabled), findsAtLeastNWidgets(1));
		await tester.tap(find.byType(KlpFlutterChoice));
		await tester.pump();
		expect(calls, 1);
		expect(selection.value, KlpPlacementId(scope: ['fixture.router', 'route-1'], localId: 'a'));
		expect(tester.takeException(), isNull);
	});
}
