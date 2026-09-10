import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/composition/nodes/internal/klp_scope_boundary.dart';
import 'package:kallopis/src/features/navigation/rail/internal/klp_rail_adapter.dart';
import 'package:kallopis/src/features/navigation/rail/internal/klp_rail_placement.dart';
import 'package:kallopis/src/foundation/binding/internal/klp_bound_template.dart';
import 'package:kallopis/src/kernel/lifecycle/internal/klp_frame_lease.dart';
import 'package:kallopis/src/runtime/compilation/internal/klp_component_adapter.dart';
import 'package:kallopis/src/runtime/compilation/internal/klp_scope_boundary_adapter.dart';
import 'package:kallopis/src/runtime/compilation/internal/klp_tree_runtime.dart';

import 'support/klp_component_test_definition.dart';
import 'support/klp_component_test_item.dart';
import 'support/klp_runtime_fixture.dart';
import 'support/klp_test_primitives.dart';

void main() {
	late KlpTreeRuntime runtime;
	late KlpRuntimeFixture rootAdapter;
	var calls = 0;
	setUp(() {
		runtime = KlpTreeRuntime();
		rootAdapter = KlpRuntimeFixture();
		calls = 0;
	});
	tearDown(() => runtime.dispose());

	KlpRail rail({String id = 'rail', String label = 'Item'}) => KlpRail(id: id, center: [KlpComponentTestItem(id: 'item', label: label, action: KlpCallbackAction(() => calls++))]);
	KlpScopeBoundary entry({bool active = true, String label = 'Item'}) => KlpScopeBoundary(id: 'entry', child: rail(label: label), active: active);
	void update(KlpNode root) {
		final definition = klpComponentTestDefinition();
		runtime.update(root: root, adapters: [rootAdapter, const KlpScopeBoundaryAdapter(), const KlpRailAdapter(), KlpComponentAdapter(definition)], components: [definition], primitives: klpTestPrimitives());
	}

	test('inactive scope blocks captured callbacks while retaining resource and selection', () async {
		update(entry());
		final first = _choices(runtime.frame!.content).single;
		await first.onActivate!();
		final identity = KlpPlacementId(scope: ['entry'], localId: 'rail');
		final resource = runtime.resources[identity] as KlpRailPlacement;
		final selected = resource.selection.value;
		update(entry(active: false));
		final hidden = _choices(runtime.frame!.content).single;
		await first.onActivate!();
		await hidden.onActivate!();
		expect(calls, 1);
		expect(runtime.resources[identity], same(resource));
		expect(resource.selection.value, selected);
		expect(resource.isDisposed, isFalse);

		update(entry());
		await hidden.onActivate!();
		expect(calls, 1);
		await _choices(runtime.frame!.content).single.onActivate!();
		expect(calls, 2);
		expect(runtime.resources[identity], same(resource));
	});

	test('inactive ancestor cannot be reenabled by an active descendant', () async {
		KlpScopeBoundary nested(bool outer, bool inner) => KlpScopeBoundary(id: 'outer', child: KlpScopeBoundary(id: 'inner', child: rail(), active: inner), active: outer);
		update(nested(false, true));
		await _choices(runtime.frame!.content).single.onActivate!();
		expect(calls, 0);
		update(nested(true, false));
		await _choices(runtime.frame!.content).single.onActivate!();
		expect(calls, 0);
		update(nested(true, true));
		await _choices(runtime.frame!.content).single.onActivate!();
		expect(calls, 1);
	});

	test('replaced and removed frames revoke all previous scoped callbacks', () async {
		KlpRuntimeNode tree(List<String> ids) => KlpRuntimeNode('root', [for (final id in ids) KlpScopeBoundary(id: id, child: rail())]);
		update(tree(['first', 'second']));
		final old = _choices(runtime.frame!.content).toList();
		update(tree(['second']));
		for (final choice in old) {
			await choice.onActivate!();
		}
		expect(calls, 0);
		final current = _choices(runtime.frame!.content).single;
		await current.onActivate!();
		expect(calls, 1);
		update(tree([]));
		await current.onActivate!();
		expect(calls, 1);
	});

	test('preparation failure keeps the previous active lease usable', () async {
		update(entry());
		final frame = runtime.frame!;
		final choice = _choices(frame.content).single;
		expect(() => update(entry(active: false, label: ' ')), throwsA(isA<KlpContractError>()));
		expect(runtime.frame, same(frame));
		expect(frame.lease.isActive, isTrue);
		await choice.onActivate!();
		expect(calls, 1);
	});

	test('dispose revokes every derived callback', () async {
		update(entry());
		final choice = _choices(runtime.frame!.content).single;
		runtime.dispose();
		await choice.onActivate!();
		expect(calls, 0);
	});

	test('derived leases combine enabled ancestry and share frame revocation', () {
		final root = KlpFrameLease();
		final active = root.derive(enabled: true);
		final inactive = root.derive(enabled: false);
		final nested = inactive.derive(enabled: true);
		expect(active.isActive, isTrue);
		expect(inactive.isActive, isFalse);
		expect(nested.isActive, isFalse);
		nested.run(() => calls++);
		root.revoke();
		active.run(() => calls++);
		expect(active.isActive, isFalse);
		expect(calls, 0);
	});
}

Iterable<KlpBoundChoice> _choices(KlpBoundTemplate content) sync* {
	switch (content) {
		case KlpBoundChoice(): yield content;
		case KlpBoundPlacement(): yield* _choices(content.content);
		case KlpBoundExtent(): yield* _choices(content.child);
		case KlpBoundSurface(): yield* _choices(content.child);
		case KlpBoundLinear():
			for (final child in content.children) {
				yield* _choices(child);
			}
		case KlpBoundRegions():
			yield* _choices(content.leading);
			yield* _choices(content.body);
			yield* _choices(content.trailing);
		default: break;
	}
}
