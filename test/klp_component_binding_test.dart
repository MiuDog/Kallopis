import 'package:kallopis/src/features/workspace/presentation/klp_workspace_presentation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/composition/definitions/klp_definition.dart';
import 'package:kallopis/src/composition/registry/klp_registry.dart';
import 'package:kallopis/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/runtime/compilation/klp_tree_runtime.dart';
import 'package:kallopis/src/styling/references/klp_style_ref.dart';
import 'package:kallopis/src/styling/resolution/klp_semantic_resolver.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_key.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_schema.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_token.dart';

import 'support/klp_component_test_item.dart';
import 'support/klp_component_test_other_node.dart';
import 'support/klp_test_primitives.dart';

void main() {
	test('style changes preserve placement and existing bound snapshots', () {
		final runtime = KlpTreeRuntime();
		addTearDown(runtime.dispose);
		final styles = [klpTestPrimitives(), klpTestPrimitives(alternate: true)];
		final outputs = <KlpBoundWorkspaceBlock>[];
		for (final style in styles) {
			final block = KlpWorkspaceBlock(id: KlpId.parse('placement'), kind: KlpWorkspaceBlockKind.paper, title: 'First');
			runtime.update(root: block, adapters: KlpWorkspaceBlockAdapter.createAll(), primitives: style);
			final placement = runtime.frame!.content as KlpBoundPlacement;
			expect(placement.id, KlpPlacementId(localId: 'placement'));
			outputs.add(placement.content as KlpBoundWorkspaceBlock);
		}
		for (var index = 0; index < outputs.length; index++) {
			final output = outputs[index];
			final style = styles[index];
			expect(output.title, 'First');
			expect(output.background, same(style.colors[3]));
			expect(output.radius, same(style.radii[2]));
			expect(output.inset, same(style.distances[4]));
			expect(output.gap, same(style.distances[3]));
			expect(output.textStyle.color, same(style.colors[1]));
			expect(output.textStyle.fontFamily, same(style.fontFamilies[0]));
			expect(output.textStyle.fontSize, same(style.fontSizes[2]));
			expect(output.textStyle.fontWeight, same(style.fontWeights[3]));
			expect(output.textStyle.lineHeight, same(style.lineHeights[4]));
			expect(output.textStyle.letterSpacing, same(style.letterSpacings[3]));
			expect(() => output.items.clear(), throwsUnsupportedError);
		}
		expect(outputs[0], isNot(same(outputs[1])));
	});

	test('data updates produce new snapshots and preserve old text', () {
		final runtime = KlpTreeRuntime();
		addTearDown(runtime.dispose);
		final outputs = <KlpBoundWorkspaceContentBlock>[];
		for (final text in ['First', 'Updated']) {
			final node = KlpWorkspaceContentBlock(id: KlpId.parse('text'), kind: KlpWorkspaceContentKind.text, text: text);
			runtime.update(root: node, adapters: KlpWorkspaceBlockAdapter.createAll(), primitives: klpTestPrimitives());
			outputs.add((runtime.frame!.content as KlpBoundPlacement).content as KlpBoundWorkspaceContentBlock);
		}
		expect(outputs.map((output) => output.text), ['First', 'Updated']);
		expect(() => outputs.first.children.clear(), throwsUnsupportedError);
	});

	test('invalid node contracts fail before preparation', () {
		final registry = KlpRegistry([KlpDefinition<KlpComponentTestItem>('fixture')]);
		for (final (node, code) in <(KlpNode, String)>[
			(KlpComponentTestOtherNode(), 'node_type_mismatch'),
			(KlpComponentTestItem(definitionId: 'missing'), 'unknown_definition'),
			(KlpComponentTestItem(definitionId: ' '), 'empty_id'),
		]) {
			expect(() => registry.validate(node), _failure(code));
		}
	});

	test('direct semantic references retain owner public and actual type checks', () {
		final foreign = KlpSemanticKey('shared', 'color', KlpStyleKind.color);
		for (final (key, dependencies, public, code) in <(KlpSemanticKey<KlpColor>, List<String>, bool, String)>[
			(foreign, ['shared'], false, 'private_semantic_reference'),
			(foreign, [], true, 'undeclared_semantic_dependency'),
			(KlpSemanticKey('fixture', 'radius', KlpStyleKind.color), [], true, 'semantic_kind_mismatch'),
			(KlpSemanticKey('fixture', 'missing', KlpStyleKind.color), [], true, 'unknown_semantic'),
		]) {
			final resolver = KlpSemanticResolver([
				_schema(dependencies),
				KlpSemanticSchema('shared', [KlpSemanticToken(foreign, const KlpPrimitiveRef(KlpStyleKind.color, KlpPrimitiveIndex.i2), isPublic: public)]),
			]);
			expect(() => resolver.validateUsage('fixture', key), _failure(code));
		}
	});

	test('declared public foreign semantic reference resolves normally', () {
		final foreign = KlpSemanticKey('shared', 'color', KlpStyleKind.color);
		final resolver = KlpSemanticResolver([
			_schema(['shared']),
			KlpSemanticSchema('shared', [KlpSemanticToken(foreign, const KlpPrimitiveRef(KlpStyleKind.color, KlpPrimitiveIndex.i2), isPublic: true)]),
		]);
		resolver.validateUsage('fixture', foreign);
		final primitives = klpTestPrimitives();
		expect(resolver.resolve(primitives).read(foreign), same(primitives.colors[2]));
	});
}

KlpSemanticSchema _schema(List<String> dependencies) => KlpSemanticSchema('fixture', [KlpSemanticToken(KlpSemanticKey('fixture', 'radius', KlpStyleKind.radius), const KlpPrimitiveRef(KlpStyleKind.radius, KlpPrimitiveIndex.i1))], dependencies: dependencies);

Matcher _failure(String code) => throwsA(isA<KlpContractError>().having((error) => error.code, 'code', code));
