import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/capabilities/state/klp_mutable_state.dart';
import 'package:kallopis/src/foundation/binding/internal/klp_bound_template.dart';
import 'package:kallopis/src/foundation/templates/klp_axis.dart';
import 'package:kallopis/src/kernel/identity/klp_placement_id.dart';
import 'package:kallopis/src/rendering/flutter/internal/klp_flutter_choice.dart';
import 'package:kallopis/src/styling/primitives/klp_style_value.dart';

import 'support/klp_renderer_fixture.dart';

void main() {
	testWidgets('pointer and keyboard share selection activation', (tester) async {
		final selection = KlpMutableState<KlpPlacementId?>(null);
		addTearDown(selection.dispose);
		var activated = 0;
		final choice = klpRendererChoice(id: KlpPlacementId(localId: 'one'), selection: selection.readOnly, onActivate: () { activated++; selection.value = KlpPlacementId(localId: 'one'); });
		await tester.pumpWidget(klpRendererHost(choice));
		await tester.tap(find.byType(KlpFlutterChoice));
		await tester.pump();
		expect(activated, 1);
		expect(selection.value, KlpPlacementId(localId: 'one'));
		await tester.sendKeyEvent(LogicalKeyboardKey.enter);
		await tester.sendKeyEvent(LogicalKeyboardKey.space);
		expect(activated, 3);
	});

	testWidgets('style replacement retains selection and focus identity', (tester) async {
		final selection = KlpMutableState<KlpPlacementId?>(null);
		addTearDown(selection.dispose);
		void activate() => selection.value = KlpPlacementId(localId: 'one');
		await tester.pumpWidget(klpRendererHost(klpRendererChoice(id: KlpPlacementId(localId: 'one'), selection: selection.readOnly, onActivate: activate)));
		await tester.tap(find.byType(KlpFlutterChoice));
		await tester.pump();
		final focus = FocusManager.instance.primaryFocus;
		final element = tester.element(find.byType(KlpFlutterChoice));
		await tester.pumpWidget(klpRendererHost(klpRendererChoice(id: KlpPlacementId(localId: 'one'), selection: selection.readOnly, onActivate: activate, channel: 40)));
		expect(FocusManager.instance.primaryFocus, same(focus));
		expect(tester.element(find.byType(KlpFlutterChoice)), same(element));
		expect(selection.value, KlpPlacementId(localId: 'one'));
	});

	testWidgets('choice semantics expose label selection and disabled state once', (tester) async {
		final selection = KlpMutableState<KlpPlacementId?>(KlpPlacementId(localId: 'one'));
		addTearDown(selection.dispose);
		final semantics = tester.ensureSemantics();
		try {
			await tester.pumpWidget(klpRendererHost(klpRendererChoice(id: KlpPlacementId(localId: 'one'), selection: selection.readOnly)));
			expect(find.bySemanticsLabel('Action one'), findsOneWidget);
			final node = tester.getSemantics(find.byType(KlpFlutterChoice));
			expect(node, matchesSemantics(label: 'Action one', isButton: true, hasEnabledState: true, isEnabled: false, hasSelectedState: true, isSelected: true));
			await tester.tap(find.byType(KlpFlutterChoice));
			await tester.pump();
			final detector = tester.widget<FocusableActionDetector>(find.byType(FocusableActionDetector));
			expect(detector.focusNode?.hasFocus, isFalse);
			expect(selection.value, KlpPlacementId(localId: 'one'));
		}
		finally {
			semantics.dispose();
		}
	});

	testWidgets('source replacement cancels old subscription and unmount preserves borrowed source', (tester) async {
		final oldSelection = KlpMutableState<KlpPlacementId?>(null);
		final newSelection = KlpMutableState<KlpPlacementId?>(KlpPlacementId(localId: 'one'));
		addTearDown(oldSelection.dispose);
		addTearDown(newSelection.dispose);
		await tester.pumpWidget(klpRendererHost(klpRendererChoice(id: KlpPlacementId(localId: 'one'), selection: oldSelection.readOnly)));
		await tester.pumpWidget(klpRendererHost(klpRendererChoice(id: KlpPlacementId(localId: 'one'), selection: newSelection.readOnly)));
		oldSelection.dispose();
		await tester.pumpWidget(const SizedBox.shrink());
		newSelection.value = KlpPlacementId(localId: 'two');
		expect(newSelection.isDisposed, isFalse);
		expect(tester.takeException(), isNull);
	});

	testWidgets('tab traversal skips disabled choices', (tester) async {
		final selection = KlpMutableState<KlpPlacementId?>(null);
		addTearDown(selection.dispose);
		final activated = <String>[];
		final content = KlpBoundLinear(KlpAxis.vertical, KlpDistance(4), [
			klpRendererChoice(id: KlpPlacementId(localId: 'one'), selection: selection.readOnly, onActivate: () => activated.add('one')),
			klpRendererChoice(id: KlpPlacementId(localId: 'disabled'), selection: selection.readOnly),
			klpRendererChoice(id: KlpPlacementId(localId: 'two'), selection: selection.readOnly, onActivate: () => activated.add('two')),
		]);
		await tester.pumpWidget(klpRendererHost(content));
		await tester.tap(find.byType(KlpFlutterChoice).first);
		await tester.pump();
		await tester.sendKeyEvent(LogicalKeyboardKey.tab);
		await tester.pump();
		await tester.sendKeyEvent(LogicalKeyboardKey.enter);
		expect(activated, ['one', 'two']);
	});

	testWidgets('selection matches complete scope even when choices share a source and label', (tester) async {
		final first = KlpPlacementId(scope: ['first'], localId: 'same');
		final second = KlpPlacementId(scope: ['second'], localId: 'same');
		final selection = KlpMutableState<KlpPlacementId?>(first);
		addTearDown(selection.dispose);
		final semantics = tester.ensureSemantics();
		try {
			final content = KlpBoundLinear(KlpAxis.vertical, KlpDistance(4), [
				klpRendererChoice(id: first, selection: selection.readOnly),
				klpRendererChoice(id: second, selection: selection.readOnly),
			]);
			await tester.pumpWidget(klpRendererHost(content));
			expect(tester.getSemantics(find.byType(KlpFlutterChoice).first), matchesSemantics(label: 'Action same', isButton: true, hasEnabledState: true, hasSelectedState: true, isSelected: true));
			expect(tester.getSemantics(find.byType(KlpFlutterChoice).last), matchesSemantics(label: 'Action same', isButton: true, hasEnabledState: true, hasSelectedState: true, isSelected: false));
			selection.value = second;
			await tester.pump();
			expect(tester.getSemantics(find.byType(KlpFlutterChoice).first), matchesSemantics(label: 'Action same', isButton: true, hasEnabledState: true, hasSelectedState: true, isSelected: false));
			expect(tester.getSemantics(find.byType(KlpFlutterChoice).last), matchesSemantics(label: 'Action same', isButton: true, hasEnabledState: true, hasSelectedState: true, isSelected: true));
		}
		finally {
			semantics.dispose();
		}
	});
}
