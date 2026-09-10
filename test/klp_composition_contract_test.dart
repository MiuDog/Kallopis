import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';

import 'klp_test_item.dart';
import 'klp_test_menu_item.dart';
import 'klp_test_rail.dart';
import 'klp_test_rail_item.dart';

Matcher failsWith(String code) => throwsA(isA<KlpContractError>().having((error) => error.code, 'code', code));

void main() {
	test('typed slots permit a node with multiple qualifications', () {
		final item = KlpTestItem('item', 'item');
		final rail = KlpTestRail('root', [item]);
		final menuItems = <KlpTestMenuItem>[item];
		final registry = KlpRegistry([KlpDefinition<KlpTestRail>('rail'), KlpDefinition<KlpTestRailItem>('item')]);
		final result = registry.validate(rail);
		expect(result.nodes.map((node) => node.id), ['root', 'item']);
		expect(result.nodes.first.childrenIds, ['item']);
		expect(menuItems.single, same(item));
	});

	test('registry and dependencies keep immutable input snapshots', () {
		final dependencies = <String>['leaf'];
		final definitions = <KlpDefinition<KlpNode>>[KlpDefinition<KlpNode>('root', dependencies: dependencies), KlpDefinition<KlpNode>('leaf')];
		final registry = KlpRegistry(definitions);
		dependencies.clear();
		definitions.clear();
		expect(registry.definition('root').dependencies, ['leaf']);
		expect(registry.definitions, hasLength(2));
		expect(() => registry.definitions.clear(), throwsUnsupportedError);
		expect(() => registry.definition('root').dependencies.clear(), throwsUnsupportedError);
	});

	test('registry rejects duplicate and unknown definitions', () {
		expect(() => KlpRegistry([KlpDefinition<KlpNode>('same'), KlpDefinition<KlpNode>('same')]), failsWith('duplicate_definition'));
		expect(() => KlpRegistry([KlpDefinition<KlpNode>('root', dependencies: ['missing'])]), failsWith('unknown_definition'));
		expect(() => KlpRegistry([]).definition('missing'), failsWith('unknown_definition'));
	});

	test('registry rejects direct and transitive dependency cycles', () {
		expect(() => KlpRegistry([KlpDefinition<KlpNode>('root', dependencies: ['root'])]), failsWith('dependency_cycle'));
		final definitions = [KlpDefinition<KlpNode>('a', dependencies: ['b']), KlpDefinition<KlpNode>('b', dependencies: ['a'])];
		expect(() => KlpRegistry(definitions), failsWith('dependency_cycle'));
	});

	test('shared dependency is valid', () {
		final definitions = [KlpDefinition<KlpNode>('root', dependencies: ['a', 'b']), KlpDefinition<KlpNode>('a', dependencies: ['b']), KlpDefinition<KlpNode>('b')];
		expect(KlpRegistry(definitions).definitions, hasLength(3));
	});

	test('registry rejects empty registration and dependency identifiers', () {
		expect(() => KlpRegistry([KlpDefinition<KlpNode>(' ')]), failsWith('empty_id'));
		expect(() => KlpRegistry([KlpDefinition<KlpNode>('root', dependencies: [''])]), failsWith('empty_id'));
	});

	test('tree rejects empty identifiers and unknown definitions', () {
		final registry = KlpRegistry([KlpDefinition<KlpNode>('item')]);
		expect(() => registry.validate(KlpTestItem('', 'item')), failsWith('empty_id'));
		expect(() => registry.validate(KlpTestItem('node', ' ')), failsWith('empty_id'));
		expect(() => registry.validate(KlpTestItem('node', 'missing')), failsWith('unknown_definition'));
		expect(() => registry.validate(KlpTestItem('node', 'missing')), throwsA(isA<KlpContractError>().having((error) => error.message, 'message', contains('placement=node definition=missing'))));
	});

	test('tree rejects duplicate placements and identity cycles', () {
		final registry = KlpRegistry([KlpDefinition<KlpNode>('item')]);
		final root = KlpTestItem('root', 'item', [KlpTestItem('same', 'item'), KlpTestItem('same', 'item')]);
		expect(() => registry.validate(root), failsWith('duplicate_placement'));
		root.children.clear();
		root.children.add(root);
		expect(() => registry.validate(root), failsWith('node_cycle'));
	});

	test('definition qualification cannot accept an incompatible node', () {
		final registry = KlpRegistry([KlpDefinition<KlpTestRail>('rail')]);
		expect(() => registry.validate(KlpTestItem('node', 'rail')), failsWith('node_type_mismatch'));
	});

	test('validated tree remains frozen when consumer nodes change', () {
		final registry = KlpRegistry([KlpDefinition<KlpNode>('item')]);
		final child = KlpTestItem('child', 'item');
		final root = KlpTestItem('root', 'item', [child]);
		final result = registry.validate(root);
		root.id = 'changed';
		child.id = 'changed-child';
		child.definitionId = 'unknown';
		root.children.clear();
		expect(result.rootId, 'root');
		expect(result.nodes.map((node) => node.id), ['root', 'child']);
		expect(result.nodes.last.definitionId, 'item');
		expect(result.nodes.first.childrenIds, ['child']);
		expect(() => result.nodes.clear(), throwsUnsupportedError);
		expect(() => result.nodes.first.childrenIds.clear(), throwsUnsupportedError);
	});
}
