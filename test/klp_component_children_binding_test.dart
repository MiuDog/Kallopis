import 'package:kallopis/src/features/workspace/presentation/klp_workspace_presentation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/composition/definitions/klp_definition.dart';
import 'package:kallopis/src/composition/registry/klp_registry.dart';
import 'package:kallopis/src/composition/validation/internal/klp_tree_capture.dart';
import 'package:kallopis/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/runtime/compilation/klp_tree_runtime.dart';
import 'package:kallopis/src/styling/resolution/klp_semantic_resolver.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_key.dart';

import 'support/klp_composite_test_definition.dart';
import 'support/klp_composite_test_node.dart';
import 'support/klp_test_primitives.dart';

void main() {
	test('nested qualified children retain capture and materialization order', () {
		KlpWorkspaceContentBlock node(String id, [List<KlpWorkspaceContentBlock> children = const []]) => KlpWorkspaceContentBlock(id: KlpId.parse(id), kind: KlpWorkspaceContentKind.group, text: id, children: children);
		final root = node('root', [node('first', [node('grandchild')]), node('second')]);
		final adapters = KlpWorkspaceBlockAdapter.createAll();
		final captured = captureKlpTree(KlpRegistry(adapters.map((adapter) => adapter.contract)), root);
		expect(captured.validation.nodes.map((node) => node.id), ['root', 'first', 'grandchild', 'second']);
		final snapshot = captured.validation.nodes.first;
		expect(snapshot.childrenIds, ['first', 'second']);
		expect(snapshot.slotRanges.map((range) => (range.slot.name, range.start, range.end)), [('children', 0, 2)]);
		expect(() => snapshot.childrenPlacements.clear(), throwsUnsupportedError);
		expect(() => snapshot.slotRanges.clear(), throwsUnsupportedError);
		final runtime = KlpTreeRuntime();
		addTearDown(runtime.dispose);
		runtime.update(root: root, adapters: adapters, primitives: klpTestPrimitives());
		expect(_textValues(runtime.frame!.content), ['root', 'first', 'grandchild', 'second']);
		final content = (runtime.frame!.content as KlpBoundPlacement).content as KlpBoundWorkspaceContentBlock;
		expect(content.children, hasLength(2));
		expect(() => content.children.clear(), throwsUnsupportedError);
	});

	test('definition preserves explicit slots and rejects owner or duplicate positions', () {
		final definition = klpCompositeTestDefinition();
		expect(definition.slots, [klpCompositeLeading, klpCompositeTrailing]);
		expect(() => KlpDefinition<KlpCompositeTestNode>('fixture', slots: [klpCompositeLeading, klpCompositeLeading]), _failure('duplicate_slot'));
		final foreign = KlpSlot<KlpNode>(owner: 'foreign', name: 'items');
		expect(() => KlpDefinition<KlpCompositeTestNode>('fixture', slots: [foreign]), _failure('slot_owner_mismatch'));
	});

	test('capture rejects missing duplicate or reordered slot assignments', () {
		final registry = KlpRegistry([klpCompositeTestDefinition()]);
		for (final (children, code) in [
			(KlpChildren([]), 'slot_assignment_count'),
			(KlpChildren([klpCompositeLeading.assign([]), klpCompositeLeading.assign([])]), 'slot_assignment_mismatch'),
			(KlpChildren([klpCompositeTrailing.assign([]), klpCompositeLeading.assign([])]), 'slot_assignment_mismatch'),
		]) {
			final node = KlpCompositeTestNode(KlpId.parse('root'), children);
			expect(() => captureKlpTree(registry, node), _failure(code));
		}
		final root = KlpCompositeTestNode(KlpId.parse('root'), klpCompositeChildren());
		final snapshot = captureKlpTree(registry, root).validation.nodes.single;
		expect(snapshot.childrenIds, isEmpty);
		expect(snapshot.slotRanges.map((range) => (range.start, range.end)), [(0, 0), (0, 0)]);
	});

	test('slot semantic references retain ownership validation', () {
		final resolver = KlpSemanticResolver([klpCompositeTestDefinition().semantics]);
		final missing = KlpSemanticKey('fixture', 'missing', KlpStyleKind.distance);
		expect(() => resolver.validateUsage('fixture', missing), _failure('unknown_semantic'));
	});
}

Matcher _failure(String code) => throwsA(isA<KlpContractError>().having((error) => error.code, 'code', code));

Iterable<String> _textValues(KlpBoundTemplate template) sync* {
	switch (template) {
		case KlpBoundPlacement(:final content):
			yield* _textValues(content);
		case KlpBoundWorkspaceContentBlock(:final text, :final children):
			yield text;
			for (final child in children) {
				yield* _textValues(child);
			}
		default:
			throw StateError('Unexpected bound template: ${template.runtimeType}');
	}
}
