import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/styling/resolution/internal/klp_semantic_resolution.dart';
import 'package:kallopis/src/styling/resolution/internal/klp_semantic_resolver.dart';

import 'support/klp_test_primitives.dart';

KlpSemanticKey<KlpDistance> _key(String owner, String name) => KlpSemanticKey(owner, name, KlpStyleKind.distance);
Matcher _error(String code) => throwsA(isA<KlpContractError>().having((error) => error.code, 'code', code));
KlpSemanticToken<KlpDistance> _primitive(KlpSemanticKey<KlpDistance> key, {bool isPublic = false}) => KlpSemanticToken(key, const KlpPrimitiveRef(KlpStyleKind.distance, KlpPrimitiveIndex.i2), isPublic: isPublic);

void main() {
	test('public cross owner alias resolves with declared dependency independent of input order', () {
		final base = _key('foundation', 'gap');
		final alias = _key('custom', 'spacing');
		final custom = KlpSemanticSchema('custom', [KlpSemanticToken(alias, KlpSemanticRef(base))], dependencies: ['foundation']);
		final foundation = KlpSemanticSchema('foundation', [_primitive(base, isPublic: true)]);
		final resolved = KlpSemanticResolver([custom, foundation]).resolve(klpTestPrimitives());
		expect(resolved.read(alias).value, 8);
		expect(resolved.read(alias), same(resolved.read(base)));
	});

	test('one resolver accepts two complete styles while preserving previous snapshot', () {
		final key = _key('custom', 'spacing');
		final resolver = KlpSemanticResolver([KlpSemanticSchema('custom', [_primitive(key)])]);
		final first = resolver.resolve(klpTestPrimitives());
		final previousValue = first.read(key);
		final second = resolver.resolve(klpTestPrimitives(alternate: true));
		expect(second.read(key).value, 16);
		expect(first.read(key), same(previousValue));
		expect(first.read(key).value, 8);
	});

	test('common base generic cannot mix incompatible primitive kinds', () {
		final KlpSemanticKey<KlpStyleValue> key = _key('custom', 'spacing');
		const KlpStyleRef<KlpStyleValue> reference = KlpPrimitiveRef(KlpStyleKind.color, KlpPrimitiveIndex.i0);
		expect(() => KlpSemanticToken<KlpStyleValue>(key, reference), _error('semantic_kind_mismatch'));
	});

	test('forged semantic target kind is checked against registered target', () {
		final real = KlpSemanticKey('custom', 'target', KlpStyleKind.color);
		final forged = _key('custom', 'target');
		final alias = _key('custom', 'alias');
		final target = KlpSemanticToken(real, const KlpPrimitiveRef(KlpStyleKind.color, KlpPrimitiveIndex.i0));
		final schema = KlpSemanticSchema('custom', [KlpSemanticToken(alias, KlpSemanticRef(forged)), target]);
		expect(() => KlpSemanticResolver([schema]), _error('semantic_kind_mismatch'));
	});

	test('same owner and name cannot coexist with different kinds', () {
		final color = KlpSemanticKey('custom', 'shared', KlpStyleKind.color);
		final token = KlpSemanticToken(color, const KlpPrimitiveRef(KlpStyleKind.color, KlpPrimitiveIndex.i0));
		expect(() => KlpSemanticSchema('custom', [_primitive(_key('custom', 'shared')), token]), _error('duplicate_semantic'));
	});

	test('private semantic cannot be referenced across declared dependency', () {
		final target = _key('base', 'privateGap');
		final base = KlpSemanticSchema('base', [_primitive(target)]);
		final custom = KlpSemanticSchema('custom', [KlpSemanticToken(_key('custom', 'alias'), KlpSemanticRef(target))], dependencies: ['base']);
		expect(() => KlpSemanticResolver([base, custom]), _error('private_semantic_reference'));
	});

	test('public semantic still requires declared owner dependency', () {
		final target = _key('base', 'gap');
		final base = KlpSemanticSchema('base', [_primitive(target, isPublic: true)]);
		final custom = KlpSemanticSchema('custom', [KlpSemanticToken(_key('custom', 'alias'), KlpSemanticRef(target))]);
		expect(() => KlpSemanticResolver([base, custom]), _error('undeclared_semantic_dependency'));
	});

	test('private semantic can be aliased inside its own owner', () {
		final source = _key('custom', 'source');
		final alias = _key('custom', 'alias');
		final schema = KlpSemanticSchema('custom', [KlpSemanticToken(alias, KlpSemanticRef(source)), _primitive(source)]);
		expect(KlpSemanticResolver([schema]).resolve(klpTestPrimitives()).read(alias).value, 8);
	});

	test('unknown schema dependency fails before resolution', () {
		final schema = KlpSemanticSchema('custom', [], dependencies: ['missing']);
		expect(() => KlpSemanticResolver([schema]), _error('unknown_semantic_owner'));
	});

	test('unknown semantic reference fails before resolution', () {
		final token = KlpSemanticToken(_key('custom', 'alias'), KlpSemanticRef(_key('custom', 'missing')));
		expect(() => KlpSemanticResolver([KlpSemanticSchema('custom', [token])]), _error('unknown_semantic'));
	});

	test('semantic reference cycle includes complete traversal path', () {
		final a = _key('custom', 'a');
		final b = _key('custom', 'b');
		final c = _key('custom', 'c');
		final schema = KlpSemanticSchema('custom', [KlpSemanticToken(a, KlpSemanticRef(b)), KlpSemanticToken(b, KlpSemanticRef(c)), KlpSemanticToken(c, KlpSemanticRef(a))]);
		final matcher = isA<KlpContractError>().having((error) => error.code, 'code', 'semantic_reference_cycle').having((error) => error.message, 'path', 'custom/a -> custom/b -> custom/c -> custom/a');
		expect(() => KlpSemanticResolver([schema]), throwsA(matcher));
	});

	test('schema cycle is rejected even without token references', () {
		final a = KlpSemanticSchema('a', [], dependencies: ['b']);
		final b = KlpSemanticSchema('b', [], dependencies: ['a']);
		final matcher = isA<KlpContractError>().having((error) => error.code, 'code', 'semantic_dependency_cycle').having((error) => error.message, 'path', 'a -> b -> a');
		expect(() => KlpSemanticResolver([a, b]), throwsA(matcher));
	});

	test('schema collections are copied and cannot be mutated', () {
		final key = _key('custom', 'gap');
		final tokens = <KlpSemanticToken<KlpStyleValue>>[_primitive(key)];
		final dependencies = <String>['base'];
		final schema = KlpSemanticSchema('custom', tokens, dependencies: dependencies);
		tokens.clear();
		dependencies.add('missing');
		expect(schema.tokens, hasLength(1));
		expect(schema.dependencies, ['base']);
		expect(() => schema.tokens.clear(), throwsUnsupportedError);
		expect(() => schema.dependencies.clear(), throwsUnsupportedError);
		final schemas = [KlpSemanticSchema('base', []), schema];
		final resolver = KlpSemanticResolver(schemas);
		schemas.clear();
		expect(resolver.resolve(klpTestPrimitives()).read(key).value, 8);
	});

	test('resolution copies value map and rejects fake or missing read keys', () {
		final key = _key('custom', 'gap');
		final values = <(String, String), KlpStyleValue>{key.identity: KlpDistance(4)};
		final result = KlpSemanticResolution(values);
		values[key.identity] = KlpDistance(9);
		expect(result.read(key).value, 4);
		final fake = KlpSemanticKey('custom', 'gap', KlpStyleKind.color);
		expect(() => result.read(fake), _error('semantic_kind_mismatch'));
		expect(() => result.read(_key('custom', 'missing')), _error('unknown_semantic'));
	});

	test('duplicate owners and mismatched token owners are rejected', () {
		final schema = KlpSemanticSchema('custom', []);
		expect(() => KlpSemanticResolver([schema, schema]), _error('duplicate_semantic_owner'));
		expect(() => KlpSemanticSchema('custom', [_primitive(_key('other', 'gap'))]), _error('semantic_owner_mismatch'));
	});
}
