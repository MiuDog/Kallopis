import '../../../kernel/diagnostics/klp_contract_error.dart';
import '../../primitives/klp_primitive_set.dart';
import '../../primitives/klp_style_value.dart';
import '../../references/klp_style_ref.dart';
import '../../semantics/klp_semantic_key.dart';
import '../../semantics/klp_semantic_schema.dart';
import '../../semantics/klp_semantic_token.dart';
import 'klp_semantic_resolution.dart';

/// 掛載前編譯完整引用圖；求值只執行本庫封閉的參照規則。
final class KlpSemanticResolver {

	final Map<String, KlpSemanticSchema> _schemas = {};
	final Map<(String, String), KlpSemanticToken<KlpStyleValue>> _tokens = {};
	final List<KlpSemanticToken<KlpStyleValue>> _order = [];

	KlpSemanticResolver(Iterable<KlpSemanticSchema> schemas) {
		for (final schema in schemas) {
			if (_schemas.containsKey(schema.owner)) throw KlpContractError('duplicate_semantic_owner', schema.owner);
			_schemas[schema.owner] = schema;
			for (final token in schema.tokens) {
				_tokens[token.key.identity] = token;
			}
		}
		final completedSchemas = <String>{};
		for (final owner in _schemas.keys) {
			_visitSchema(owner, [], completedSchemas);
		}
		final completedTokens = <(String, String)>{};
		for (final token in _tokens.values) {
			_visitToken(token, [], completedTokens);
		}
	}

	KlpSemanticResolution resolve(KlpPrimitiveSet primitives) {
		final values = <(String, String), KlpStyleValue>{};
		for (final token in _order) {
			final value = switch (token.reference) {
				KlpPrimitiveRef(:final kind, :final index) => primitives.read(kind, index),
				KlpSemanticRef(:final key) => values[key.identity]!,
			};
			values[token.key.identity] = value;
		}
		return KlpSemanticResolution(values);
	}

	/// 模板直接使用 token 時，沿用與 token 引用相同的所有權檢查。
	void validateUsage(String owner, KlpSemanticKey<KlpStyleValue> key) {
		_requireReference(owner, key, '$owner/template');
	}

	void _visitSchema(String owner, List<String> path, Set<String> complete) {
		if (complete.contains(owner)) return;
		if (path.contains(owner)) throw KlpContractError('semantic_dependency_cycle', [...path, owner].join(' -> '));
		final schema = _schemas[owner];
		if (schema == null) throw KlpContractError('unknown_semantic_owner', [...path, owner].join(' -> '));

		path.add(owner);
		for (final dependency in schema.dependencies) {
			_visitSchema(dependency, path, complete);
		}
		path.removeLast();
		complete.add(owner);
	}

	void _visitToken(KlpSemanticToken<KlpStyleValue> token, List<(String, String)> path, Set<(String, String)> complete) {
		final identity = token.key.identity;
		if (complete.contains(identity)) return;
		if (path.contains(identity)) {
			throw KlpContractError('semantic_reference_cycle', [...path, identity].map((key) => '${key.$1}/${key.$2}').join(' -> '));
		}
		path.add(identity);
		final reference = token.reference;
		if (reference is KlpSemanticRef) {
			final target = _requireReference(token.key.owner, reference.key, token.key.path);
			_visitToken(target, path, complete);
		}
		path.removeLast();
		complete.add(identity);
		_order.add(token);
	}

	KlpSemanticToken<KlpStyleValue> _requireReference(String owner, KlpSemanticKey<KlpStyleValue> key, String source) {
		final schema = _schemas[owner];
		if (schema == null) throw KlpContractError('unknown_semantic_owner', owner);
		final target = _tokens[key.identity];
		if (target == null) throw KlpContractError('unknown_semantic', '$source -> ${key.path}');
		// 引用者可建同名假 key，必須核對真正目標，不能只信來源標記。
		if (!identical(key.kind, target.key.kind)) throw KlpContractError('semantic_kind_mismatch', '$source -> ${target.key.path}');
		if (owner != target.key.owner) {
			if (!schema.dependencies.contains(target.key.owner)) throw KlpContractError('undeclared_semantic_dependency', '$source -> ${target.key.path}');
			if (!target.isPublic) throw KlpContractError('private_semantic_reference', '$source -> ${target.key.path}');
		}
		return target;
	}
}
