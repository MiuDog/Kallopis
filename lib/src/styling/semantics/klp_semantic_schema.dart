import '../../kernel/diagnostics/klp_contract_error.dart';
import '../primitives/klp_style_value.dart';
import 'internal/klp_semantic_identifier.dart';
import 'klp_semantic_token.dart';

/// 單一定義擁有的不可變用途集合；相依宣告不提供覆寫能力。
final class KlpSemanticSchema {

	final String owner;
	final List<KlpSemanticToken<KlpStyleValue>> tokens;
	final List<String> dependencies;

	KlpSemanticSchema(this.owner, Iterable<KlpSemanticToken<KlpStyleValue>> tokens, {Iterable<String> dependencies = const []}) : tokens = List.unmodifiable(tokens), dependencies = List.unmodifiable(dependencies) {
		requireSemanticIdentifier(owner, 'semantic.owner');
		final names = <String>{};
		for (final token in this.tokens) {
			if (token.key.owner != owner) throw KlpContractError('semantic_owner_mismatch', '$owner contains ${token.key.path}');
			if (!names.add(token.key.name)) throw KlpContractError('duplicate_semantic', token.key.path);
		}
		final unique = <String>{};
		for (final dependency in this.dependencies) {
			requireSemanticIdentifier(dependency, '$owner/dependencies');
			if (!unique.add(dependency)) throw KlpContractError('duplicate_semantic_dependency', '$owner -> $dependency');
		}
	}
}
