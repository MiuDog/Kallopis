import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';

import 'klp_test_item.dart';
import 'klp_test_menu_item.dart';
import 'klp_test_rail_item.dart';

Matcher _fails(String code) => throwsA(isA<KlpContractError>().having((error) => error.code, 'code', code));

void main() {
	late KlpSlot<KlpTestRailItem> leading;
	late KlpSlot<KlpTestMenuItem> body;
	late KlpRegistry registry;
	setUp(() {
		leading = KlpSlot(owner: 'composite', name: 'leading');
		body = KlpSlot(owner: 'composite', name: 'body');
		registry = KlpRegistry([KlpDefinition<KlpNode>('composite', slots: [leading, body]), KlpDefinition<KlpTestItem>('item')]);
	});

	test('qualified assignments preserve one immutable structure and slot ranges', () {
		final inputs = <KlpTestRailItem>[KlpTestItem('first', 'item')];
		final assignments = <KlpSlotAssignment<KlpNode>>[leading.assign(inputs), body.assign([KlpTestItem('second', 'item')])];
		final children = KlpChildren(assignments);
		inputs.clear();
		assignments.clear();
		final root = _Composite(children);
		final snapshot = registry.validate(root).nodes.first;
		expect(root.reads, 1);
		expect(snapshot.childrenIds, ['first', 'second']);
		expect(snapshot.slotRanges.map((range) => (range.start, range.end)), [(0, 1), (1, 2)]);
		expect(snapshot.slotRanges.first.slot, same(leading));
		expect(() => snapshot.slotRanges.clear(), throwsUnsupportedError);
		expect(() => children.assignments.clear(), throwsUnsupportedError);
		expect(() => children.assignments.first.children.clear(), throwsUnsupportedError);
	});

	test('empty assignments remain mandatory and retain zero length ranges', () {
		final result = registry.validate(_Composite(KlpChildren([leading.assign([]), body.assign([])])));
		expect(result.nodes.single.childrenIds, isEmpty);
		expect(result.nodes.single.slotRanges.map((range) => (range.start, range.end)), [(0, 0), (0, 0)]);
		expect(() => registry.validate(_Composite(KlpChildren([leading.assign([])]))), _fails('slot_assignment_count'));
	});

	test('fake identities duplicate assignments and reordered slots are rejected', () {
		final fake = KlpSlot<KlpTestRailItem>(owner: 'composite', name: 'leading');
		for (final assignments in [
			[fake.assign([]), body.assign([])],
			[leading.assign([]), leading.assign([])],
			[body.assign([]), leading.assign([])],
		]) {
			expect(() => registry.validate(_Composite(KlpChildren(assignments))), _fails('slot_assignment_mismatch'));
		}
		expect(() => registry.validate(_Composite(KlpChildren([leading.assign([]), body.assign([]), fake.assign([])]))), _fails('slot_assignment_count'));
	});

	test('duplicate child placement is rejected even across different qualifications', () {
		final item = KlpTestItem('same', 'item');
		expect(() => registry.validate(_Composite(KlpChildren([leading.assign([item]), body.assign([item])]))), _fails('duplicate_placement'));
	});

	test('widened slot cannot accept a child without its original qualification', () {
		final KlpSlot<KlpNode> widened = leading;
		expect(() => widened.assign(<KlpNode>[_Composite(KlpChildren([]))]), throwsA(isA<TypeError>()));
	});

	test('cardinality is validated and immutable assignment cannot bypass it', () {
		final slot = KlpSlot<KlpTestItem>(owner: 'composite', name: 'required', min: 1, max: 2);
		expect(() => slot.assign([]), _fails('slot_cardinality'));
		expect(() => slot.assign([KlpTestItem('a', 'item'), KlpTestItem('b', 'item'), KlpTestItem('c', 'item')]), _fails('slot_cardinality'));
		expect(slot.assign([KlpTestItem('a', 'item')]).children, hasLength(1));
		expect(() => KlpSlot<KlpNode>(owner: 'composite', name: 'bad', min: -1), _fails('invalid_slot_cardinality'));
		expect(() => KlpSlot<KlpNode>(owner: 'composite', name: 'bad', min: 2, max: 1), _fails('invalid_slot_cardinality'));
	});

	test('slot schema rejects foreign owners repeated names and invalid identifiers', () {
		expect(() => KlpDefinition<KlpNode>('other', slots: [leading]), _fails('slot_owner_mismatch'));
		expect(() => KlpDefinition<KlpNode>('composite', slots: [leading, leading]), _fails('duplicate_slot'));
		expect(() => KlpDefinition<KlpNode>('composite', slots: [leading, KlpSlot<KlpNode>(owner: 'composite', name: 'leading')]), _fails('duplicate_slot'));
		expect(() => KlpSlot<KlpNode>(owner: 'composite', name: ' '), _fails('invalid_slot_id'));
	});

	test('ordinary node cannot impersonate a declared composite schema', () {
		expect(() => registry.validate(KlpTestItem('root', 'composite')), _fails('composite_node_required'));
	});

	test('definition retains immutable slot schema snapshot', () {
		final slots = <KlpSlot<KlpNode>>[leading];
		final definition = KlpDefinition<KlpNode>('composite', slots: slots);
		slots.clear();
		expect(definition.slots, [leading]);
		expect(() => definition.slots.clear(), throwsUnsupportedError);
	});
}

final class _Composite implements KlpCompositeNode {

	final KlpChildren _children;
	int reads = 0;

	_Composite(this._children);

	@override
	String get id => 'root';

	@override
	String get definitionId => 'composite';

	@override
	KlpChildren get children {
		reads++;
		if (reads > 1) throw StateError('Children read more than once.');
		return _children;
	}
}
