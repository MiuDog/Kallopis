import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/styling/resolution/klp_semantic_graph.dart';
import 'package:kallopis/src/styling/references/klp_style_ref.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_key.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_schema.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_token.dart';

void main() {
	// 合法圖只需定義，不提供 primitive 值集合，驗證不可要求求值。
	test('graph validation accepts public cross owner alias before its dependency', () {
		final base = _key('foundation', 'gap');
		final alias = _key('custom', 'spacing');
		final custom = KlpSemanticSchema('custom', [KlpSemanticToken(alias, KlpSemanticRef(base))], dependencies: ['foundation']);
		final token = KlpSemanticToken(base, const KlpPrimitiveRef(KlpStyleKind.distance, KlpPrimitiveIndex.i2), isPublic: true);
		final foundation = KlpSemanticSchema('foundation', [token]);
		expect(() => validateKlpSemanticGraph([custom, foundation]), returnsNormally);
	});

	test('graph validation rejects unknown semantic owner before resolution', () {
		final schema = KlpSemanticSchema('custom', [], dependencies: ['missing']);
		final error = isA<KlpContractError>().having((error) => error.code, 'code', 'unknown_semantic_owner');
		expect(() => validateKlpSemanticGraph([schema]), throwsA(error));
	});

	test('graph validation rejects dependency cycle without token references', () {
		final a = KlpSemanticSchema('a', [], dependencies: ['b']);
		final b = KlpSemanticSchema('b', [], dependencies: ['a']);
		final error = isA<KlpContractError>()
			.having((error) => error.code, 'code', 'semantic_dependency_cycle')
			.having((error) => error.message, 'path', 'a -> b -> a');
		expect(() => validateKlpSemanticGraph([a, b]), throwsA(error));
	});

	test('graph validation preserves complete semantic reference cycle path', () {
		final a = _key('custom', 'a');
		final b = _key('custom', 'b');
		final c = _key('custom', 'c');
		final tokens = [
			KlpSemanticToken(a, KlpSemanticRef(b)),
			KlpSemanticToken(b, KlpSemanticRef(c)),
			KlpSemanticToken(c, KlpSemanticRef(a)),
		];
		final schema = KlpSemanticSchema('custom', tokens);
		final error = isA<KlpContractError>()
			.having((error) => error.code, 'code', 'semantic_reference_cycle')
			.having((error) => error.message, 'path', 'custom/a -> custom/b -> custom/c -> custom/a');
		expect(() => validateKlpSemanticGraph([schema]), throwsA(error));
	});
}

KlpSemanticKey<KlpDistance> _key(String owner, String name) => KlpSemanticKey(owner, name, KlpStyleKind.distance);
