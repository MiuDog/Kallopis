import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/features/navigation/rail/internal/klp_rail_adapter.dart';
import 'package:kallopis/src/features/navigation/rail/internal/klp_rail_placement.dart';
import 'package:kallopis/src/foundation/binding/internal/klp_bound_template.dart';
import 'package:kallopis/src/foundation/binding/internal/klp_component_compiler.dart';
import 'package:kallopis/src/kernel/lifecycle/internal/klp_frame_lease.dart';
import 'package:kallopis/src/runtime/compilation/internal/klp_prepare_context.dart';
import 'package:kallopis/src/styling/resolution/internal/klp_semantic_resolver.dart';

import 'support/klp_component_test_item.dart';
import 'support/klp_test_primitives.dart';

void main() {
	test('prepared rail preserves regions and revokes old actions', () async {
		var calls = 0;
		final item = KlpComponentTestItem(action: KlpCallbackAction(() => calls++));
		final top = KlpComponentTestItem(id: 'top');
		final bottom = KlpComponentTestItem(id: 'bottom');
		final rail = KlpRail(id: 'rail', top: [top], center: [item], bottom: [bottom]);
		const adapter = KlpRailAdapter();
		final snapshot = KlpRegistry([adapter.contract, KlpDefinition<KlpComponentTestItem>(item.definitionId)]).validate(rail).nodes.first;
		final primitives = klpTestPrimitives();
		final prepared = adapter.prepare(rail, snapshot, KlpPrepareContext(
			sources: {KlpPlacementId(localId: top.id): top, KlpPlacementId(localId: item.id): item, KlpPlacementId(localId: bottom.id): bottom, snapshot.placementId: rail},
			nodes: {snapshot.placementId: snapshot},
			components: KlpComponentCompiler(const []),
			primitives: primitives,
			style: KlpSemanticResolver([adapter.contract.semantics]).resolve(primitives),
		));
		final resource = prepared.createResource(snapshot) as KlpRailPlacement;
		addTearDown(resource.dispose);
		final lease = KlpFrameLease();
		final child = KlpBoundLinear(KlpAxis.vertical, KlpDistance(0), []);
		final extent = prepared.materialize(resource, [child, child, child], lease) as KlpBoundExtent;
		final surface = extent.child as KlpBoundSurface;
		final regions = surface.child as KlpBoundRegions;
		final choice = (regions.body as KlpBoundLinear).children.single as KlpBoundChoice;
		expect(((regions.leading as KlpBoundLinear).children.single as KlpBoundChoice).onActivate, isNull);
		expect(((regions.trailing as KlpBoundLinear).children.single as KlpBoundChoice).id, KlpPlacementId(localId: bottom.id));
		expect(regions.leadingExtent.value, primitives.distances[6].value);
		expect(choice.child, same(child));
		expect(choice.label, item.label);
		expect(extent.extent, same(primitives.distances[7]));
		expect(choice.style.extent, same(primitives.distances[6]));
		await choice.onActivate!();
		expect(resource.selection.value, KlpPlacementId(localId: item.id));
		expect(calls, 1);
		lease.revoke();
		await choice.onActivate!();
		expect(calls, 1);
	});

	test('blank accessibility label fails during preparation', () {
		final item = KlpComponentTestItem(label: '  ');
		final rail = KlpRail(id: 'rail', center: [item]);
		const adapter = KlpRailAdapter();
		final primitives = klpTestPrimitives();
		expect(() => adapter.prepare(rail, KlpValidatedNode('rail', KlpRail.typeId, [item.id]), KlpPrepareContext(
			sources: {KlpPlacementId(localId: item.id): item},
			nodes: const {},
			components: KlpComponentCompiler(const []),
			primitives: primitives,
			style: KlpSemanticResolver([adapter.contract.semantics]).resolve(primitives),
		)), throwsA(isA<KlpContractError>().having((error) => error.code, 'code', 'invalid_rail_label')));
	});

	test('unsupported action is rejected before a rail placement is installed', () {
		final item = KlpComponentTestItem(action: const _UnsupportedAction());
		final rail = KlpRail(id: 'rail', center: [item]);
		const adapter = KlpRailAdapter();
		final primitives = klpTestPrimitives();
		final snapshot = KlpRegistry([adapter.contract, KlpDefinition<KlpComponentTestItem>(item.definitionId)]).validate(rail).nodes.first;
		expect(() => adapter.prepare(rail, snapshot, KlpPrepareContext(
			sources: {snapshot.placementId: rail, snapshot.childrenPlacements.single: item},
			nodes: {snapshot.placementId: snapshot},
			components: KlpComponentCompiler(const []),
			primitives: primitives,
			style: KlpSemanticResolver([adapter.contract.semantics]).resolve(primitives),
		)), throwsA(isA<KlpContractError>().having((error) => error.code, 'code', 'unsupported_rail_action')));
	});

	test('scoped preparation reads the exact item and emits only its local callback identity', () async {
		final callbacks = <String>[];
		final item = KlpComponentTestItem(id: 'item', label: 'Scoped item', action: const KlpCallbackAction(_noop));
		final other = KlpComponentTestItem(id: 'item', label: 'Other item');
		final rail = KlpRail(id: 'rail', center: [item], onSelected: callbacks.add);
		const adapter = KlpRailAdapter();
		final unscoped = KlpRegistry([adapter.contract, KlpDefinition<KlpComponentTestItem>(item.definitionId)]).validate(rail).nodes.first;
		final railId = KlpPlacementId(scope: ['entry'], localId: 'rail');
		final itemId = KlpPlacementId(scope: ['entry'], localId: 'item');
		final snapshot = KlpValidatedNode.scoped(railId, KlpRail.typeId, [itemId], slotRanges: unscoped.slotRanges);
		final primitives = klpTestPrimitives();
		final prepared = adapter.prepare(rail, snapshot, KlpPrepareContext(
			sources: {railId: rail, itemId: item, KlpPlacementId(scope: ['other'], localId: 'item'): other},
			nodes: {railId: snapshot},
			components: KlpComponentCompiler(const []),
			primitives: primitives,
			style: KlpSemanticResolver([adapter.contract.semantics]).resolve(primitives),
		));
		final resource = prepared.createResource(snapshot) as KlpRailPlacement;
		addTearDown(resource.dispose);
		final child = KlpBoundLinear(KlpAxis.vertical, KlpDistance(0), []);
		final extent = prepared.materialize(resource, [child], KlpFrameLease()) as KlpBoundExtent;
		final regions = (extent.child as KlpBoundSurface).child as KlpBoundRegions;
		final choice = (regions.body as KlpBoundLinear).children.single as KlpBoundChoice;
		expect(choice.id, itemId);
		expect(choice.label, 'Scoped item');
		await choice.onActivate!();
		expect(callbacks, ['item']);
		expect(resource.selection.value, itemId);
	});
}

void _noop() {}

final class _UnsupportedAction implements KlpAction {

	const _UnsupportedAction();
}
