import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/composition/validation/internal/klp_tree_capture.dart';
import 'package:kallopis/src/foundation/binding/internal/klp_bound_template.dart';
import 'package:kallopis/src/foundation/binding/internal/klp_component_compiler.dart';

import 'support/klp_composite_test_definition.dart';
import 'support/klp_composite_test_node.dart';
import 'support/klp_test_primitives.dart';

void main() {
	test('nested qualified children materialize once in template slot order', () {
		final selected = <String>[];
		final definition = klpCompositeTestDefinition(select: (node) {
			selected.add(node.id);
			return node.id;
		});
		final grandchild = KlpCompositeTestNode('grandchild', klpCompositeChildren());
		final first = KlpCompositeTestNode('first', klpCompositeChildren(trailing: [grandchild]));
		final second = KlpCompositeTestNode('second', klpCompositeChildren());
		final root = KlpCompositeTestNode('root', klpCompositeChildren(leading: [first], trailing: [second]));
		final captured = captureKlpTree(KlpRegistry([definition.contract]), root);
		final compiler = KlpComponentCompiler([definition]);
		final primitives = klpTestPrimitives();
		final prepared = {
			for (final snapshot in captured.validation.nodes) snapshot.placementId: compiler.prepareCaptured(captured.sources[snapshot.placementId]!, snapshot, primitives),
		};
		expect(selected, ['root', 'first', 'grandchild', 'second']);
		final bound = <KlpPlacementId, KlpBoundTemplate>{};
		for (final snapshot in captured.validation.nodes.reversed) {
			bound[snapshot.placementId] = prepared[snapshot.placementId]!.materialize([for (final id in snapshot.childrenPlacements) bound[id]!]).content;
		}
		expect(selected, ['root', 'first', 'grandchild', 'second']);
		expect(_textValues(bound[KlpPlacementId(localId: 'root')]!), ['root', 'first', 'grandchild', 'second']);
		final row = bound[KlpPlacementId(localId: 'root')]! as KlpBoundLinear;
		final leading = row.children[1] as KlpBoundLinear;
		expect(leading.axis, KlpAxis.horizontal);
		expect(leading.gap, same(primitives.distances[1]));
		expect(leading.children.single, same(bound[KlpPlacementId(localId: 'first')]));
		final trailing = (row.children[2] as KlpBoundSurface).child as KlpBoundLinear;
		expect(trailing.children.single, same(bound[KlpPlacementId(localId: 'second')]));
	});

	test('definition derives nested slots and rejects owner or duplicate positions', () {
		final definition = klpCompositeTestDefinition();
		expect(definition.contract.slots, [klpCompositeLeading, klpCompositeTrailing]);
		final row = definition.content as KlpLinearTemplate<KlpCompositeTestNode>;
		final duplicate = KlpLinearTemplate<KlpCompositeTestNode>(axis: row.axis, gap: row.gap, children: [row.children[1], row.children[1]]);
		expect(() => KlpComponentDefinition('fixture', content: duplicate, semantics: definition.contract.semantics), _failure('duplicate_slot'));
		final foreign = KlpChildrenTemplate<KlpCompositeTestNode, KlpNode>(slot: KlpSlot(owner: 'foreign', name: 'items'), axis: row.axis, gap: row.gap);
		expect(() => KlpComponentDefinition('fixture', content: foreign, semantics: definition.contract.semantics), _failure('slot_owner_mismatch'));
	});

	test('standalone binding explicitly requires child context even for empty slots', () {
		final compiler = KlpComponentCompiler([klpCompositeTestDefinition()]);
		final node = KlpCompositeTestNode('root', klpCompositeChildren());
		expect(() => compiler.bind(node, klpTestPrimitives()), _failure('component_requires_child_context'));
	});

	test('bad captured ranges fail before any data selector', () {
		var calls = 0;
		final definition = klpCompositeTestDefinition(select: (_) {
			calls++;
			return 'data';
		});
		final compiler = KlpComponentCompiler([definition]);
		final node = KlpCompositeTestNode('root', klpCompositeChildren());
		final invalid = [
			<KlpValidatedSlot>[],
			[KlpValidatedSlot(klpCompositeLeading, 0, 1), KlpValidatedSlot(klpCompositeTrailing, 0, 0)],
			[KlpValidatedSlot(klpCompositeLeading, 0, 0), KlpValidatedSlot(klpCompositeLeading, 0, 0)],
			[KlpValidatedSlot(klpCompositeTrailing, 0, 0), KlpValidatedSlot(klpCompositeLeading, 0, 0)],
		];
		for (final ranges in invalid) {
			final snapshot = KlpValidatedNode(node.id, node.definitionId, [], slotRanges: ranges);
			expect(() => compiler.validateCaptured(node, snapshot), _failure('component_slot_snapshot_mismatch'));
			expect(() => compiler.prepareCaptured(node, snapshot, klpTestPrimitives()), _failure('component_slot_snapshot_mismatch'));
		}
		final valid = captureKlpTree(KlpRegistry([definition.contract]), node).validation.nodes.single;
		compiler.validateCaptured(node, valid);
		expect(calls, 0);
	});

	test('slot semantic references retain ownership validation', () {
		final definition = klpCompositeTestDefinition();
		final content = KlpChildrenTemplate<KlpCompositeTestNode, KlpRailItem>(slot: klpCompositeLeading, axis: KlpAxis.vertical, gap: KlpSemanticKey('fixture', 'missing', KlpStyleKind.distance));
		final invalid = KlpComponentDefinition('fixture', content: content, semantics: definition.contract.semantics);
		expect(() => KlpComponentCompiler([invalid]), _failure('unknown_semantic'));
	});

	test('materialization cannot omit or append direct child results', () {
		final definition = klpCompositeTestDefinition();
		final child = KlpCompositeTestNode('child', klpCompositeChildren());
		final root = KlpCompositeTestNode('root', klpCompositeChildren(leading: [child]));
		final captured = captureKlpTree(KlpRegistry([definition.contract]), root);
		final prepared = KlpComponentCompiler([definition]).prepareCaptured(root, captured.validation.nodes.first, klpTestPrimitives());
		expect(() => prepared.materialize([]), _failure('component_child_count_mismatch'));
	});
}

Matcher _failure(String code) => throwsA(isA<KlpContractError>().having((error) => error.code, 'code', code));

Iterable<String> _textValues(KlpBoundTemplate template) sync* {
	switch (template) {
		case KlpBoundText(:final text):
			yield text;
		case KlpBoundLinear(:final children):
			for (final child in children) {
				yield* _textValues(child);
			}
		case KlpBoundSurface(:final child):
			yield* _textValues(child);
		default:
			throw StateError('Unexpected bound template: ${template.runtimeType}');
	}
}
