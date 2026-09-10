import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/features/navigation/rail/internal/klp_rail_placement.dart';
import 'package:kallopis/kallopis_declarative.dart';

void main() {
	test('selection belongs to placement and removal clears it', () async {
		final resource = KlpRailPlacement(KlpValidatedNode('rail', 'kallopis.rail', ['a', 'b']));
		addTearDown(resource.dispose);
		final events = <KlpPlacementId?>[];
		resource.selection.subscribe(events.add);
		await resource.activate(KlpPlacementId(localId: 'a'), const KlpCallbackAction(_noop), null, null);
		expect(resource.selection.value, KlpPlacementId(localId: 'a'));
		resource.update(KlpValidatedNode('rail', 'kallopis.rail', ['a']));
		expect(events, [KlpPlacementId(localId: 'a')]);
		resource.update(KlpValidatedNode('rail', 'kallopis.rail', ['b']));
		expect(resource.selection.value, isNull);
		expect(events, [KlpPlacementId(localId: 'a'), null]);
	});

	test('callback failure does not create a local selection', () async {
		final resource = KlpRailPlacement(KlpValidatedNode('rail', 'kallopis.rail', ['a']));
		addTearDown(resource.dispose);
		final events = <String>[];
		final pressedError = StateError('pressed');
		await expectLater(resource.activate(KlpPlacementId(localId: 'a'), KlpCallbackAction(() { events.add('pressed'); throw pressedError; }), null, (_) => events.add('selected')), throwsA(same(pressedError)));
		expect(events, ['pressed']);
		expect(resource.selection.value, isNull);
	});

	test('removed and disposed placements cannot dispatch callbacks', () async {
		final resource = KlpRailPlacement(KlpValidatedNode('rail', 'kallopis.rail', ['a']));
		var calls = 0;
		await resource.activate(KlpPlacementId(localId: 'missing'), KlpCallbackAction(() => calls++), null, (_) => calls++);
		resource.dispose();
		resource.dispose();
		await resource.activate(KlpPlacementId(localId: 'a'), KlpCallbackAction(() => calls++), null, (_) => calls++);
		expect(calls, 0);
		expect(resource.isDisposed, isTrue);
	});

	test('removal commits metadata before failing notification', () async {
		final resource = KlpRailPlacement(KlpValidatedNode('rail', 'kallopis.rail', ['a']));
		addTearDown(resource.dispose);
		await resource.activate(KlpPlacementId(localId: 'a'), const KlpCallbackAction(_noop), null, null);
		final error = StateError('listener');
		resource.selection.subscribe((_) => throw error);
		expect(() => resource.update(KlpValidatedNode('rail', 'kallopis.rail', [])), throwsA(same(error)));
		var calls = 0;
		await resource.activate(KlpPlacementId(localId: 'a'), KlpCallbackAction(() => calls++), null, null);
		expect(calls, 0);
		expect(resource.selection.value, isNull);
	});

	test('equal local items in different scopes never share membership or selection', () async {
		final firstItem = KlpPlacementId(scope: ['entry-one'], localId: 'item');
		final secondItem = KlpPlacementId(scope: ['entry-two'], localId: 'item');
		final first = KlpRailPlacement(KlpValidatedNode.scoped(KlpPlacementId(scope: ['entry-one'], localId: 'rail'), 'kallopis.rail', [firstItem]));
		final second = KlpRailPlacement(KlpValidatedNode.scoped(KlpPlacementId(scope: ['entry-two'], localId: 'rail'), 'kallopis.rail', [secondItem]));
		addTearDown(first.dispose);
		addTearDown(second.dispose);
		final callbacks = <String>[];
		var pressed = 0;
		await first.activate(secondItem, KlpCallbackAction(() => pressed++), null, callbacks.add);
		expect(pressed, 0);
		expect(first.selection.value, isNull);
		await first.activate(firstItem, KlpCallbackAction(() => pressed++), null, callbacks.add);
		expect(first.selection.value, firstItem);
		expect(second.selection.value, isNull);
		expect(callbacks, ['item']);
		await second.activate(secondItem, KlpCallbackAction(() => pressed++), null, callbacks.add);
		expect(second.selection.value, secondItem);
		expect(first.selection.value, firstItem);
		expect(callbacks, ['item', 'item']);
	});
}

void _noop() {}
