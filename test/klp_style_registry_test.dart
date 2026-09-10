import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';

import 'klp_test_item.dart';

void main() {
	Matcher failsWith(String code) => throwsA(isA<KlpContractError>().having((error) => error.code, 'code', code));

	test('semantic identifiers are restricted while placement identifiers remain nonempty', () {
		// 定義與用途名稱共用明確識別格式，容許數字與中立分隔字元。
		const owner = 'Owner1_.-';
		final key = KlpSemanticKey(owner, 'Name2_.-', KlpStyleKind.distance);
		final token = KlpSemanticToken(key, const KlpPrimitiveRef(KlpStyleKind.distance, KlpPrimitiveIndex.i0));
		final definition = KlpDefinition<KlpNode>(owner, semantics: KlpSemanticSchema(owner, [token]));
		final registry = KlpRegistry([definition]);
		expect(registry.definition(owner).semantics.tokens.single.key.name, 'Name2_.-');
		for (final invalid in ['1owner', 'owner/name', 'owner name', ' owner', 'owner ', '用途']) {
			expect(() => KlpDefinition<KlpNode>(invalid), failsWith('invalid_semantic_identifier'));
			expect(() => KlpSemanticKey(invalid, 'name', KlpStyleKind.distance), failsWith('invalid_semantic_identifier'));
			expect(() => KlpSemanticKey(owner, invalid, KlpStyleKind.distance), failsWith('invalid_semantic_identifier'));
		}
		for (final empty in ['', ' \t']) {
			expect(() => KlpDefinition<KlpNode>(empty), failsWith('empty_id'));
			expect(() => KlpSemanticKey(empty, 'name', KlpStyleKind.distance), failsWith('empty_id'));
			expect(() => KlpSemanticKey(owner, empty, KlpStyleKind.distance), failsWith('empty_id'));
		}

		// 位置識別保留原有非空契約，不套用語意用途的名稱限制。
		expect(registry.validate(KlpTestItem('位置/1 item', owner)).rootId, '位置/1 item');
		expect(() => registry.validate(KlpTestItem(' \t', owner)), failsWith('empty_id'));
	});

	test('semantic dependencies become definition dependencies automatically', () {
		final baseKey = KlpSemanticKey('base', 'content', KlpStyleKind.color);
		final customKey = KlpSemanticKey('custom', 'badge', KlpStyleKind.color);
		final base = KlpDefinition<KlpNode>('base', semantics: KlpSemanticSchema('base', [KlpSemanticToken(baseKey, const KlpPrimitiveRef(KlpStyleKind.color, KlpPrimitiveIndex.i1), isPublic: true)]));
		final custom = KlpDefinition<KlpNode>('custom', semantics: KlpSemanticSchema('custom', [KlpSemanticToken(customKey, KlpSemanticRef(baseKey))], dependencies: ['base']));
		final registry = KlpRegistry([custom, base]);
		expect(registry.definition('custom').dependencies, ['base']);
		expect(() => KlpRegistry([custom]), failsWith('unknown_definition'));
	});

	test('definition cannot claim another definition semantic owner', () {
		expect(() => KlpDefinition<KlpNode>('custom', semantics: KlpSemanticSchema('base', [])), failsWith('semantic_owner_mismatch'));
	});

	test('registration rejects unresolved style before any placement exists', () {
		final key = KlpSemanticKey('custom', 'badge', KlpStyleKind.color);
		final missing = KlpSemanticKey('custom', 'missing', KlpStyleKind.color);
		final definition = KlpDefinition<KlpNode>('custom', semantics: KlpSemanticSchema('custom', [KlpSemanticToken(key, KlpSemanticRef(missing))]));
		expect(() => KlpRegistry([definition]), failsWith('unknown_semantic'));
	});

	test('registration rejects private target even with definition dependency', () {
		final baseKey = KlpSemanticKey('base', 'private', KlpStyleKind.distance);
		final customKey = KlpSemanticKey('custom', 'gap', KlpStyleKind.distance);
		final base = KlpDefinition<KlpNode>('base', semantics: KlpSemanticSchema('base', [KlpSemanticToken(baseKey, const KlpPrimitiveRef(KlpStyleKind.distance, KlpPrimitiveIndex.i1))]));
		final custom = KlpDefinition<KlpNode>('custom', semantics: KlpSemanticSchema('custom', [KlpSemanticToken(customKey, KlpSemanticRef(baseKey))], dependencies: ['base']));
		expect(() => KlpRegistry([base, custom]), failsWith('private_semantic_reference'));
	});

	test('one owner cannot replace existing registered semantic declarations', () {
		final first = KlpDefinition<KlpNode>('same');
		final second = KlpDefinition<KlpNode>('same');
		expect(() => KlpRegistry([first, second]), failsWith('duplicate_definition'));
	});
}
