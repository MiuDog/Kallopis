import '../../kernel/diagnostics/klp_contract_error.dart';
import '../../styling/resolution/internal/klp_semantic_resolver.dart';
import '../definitions/klp_definition.dart';
import '../nodes/klp_node.dart';
import '../validation/klp_tree_validation.dart';
import '../validation/internal/klp_tree_capture.dart';

/// 封存註冊定義，驗證依賴及結構，不能接受渲染回呼。
final class KlpRegistry {

	final List<KlpDefinition<KlpNode>> definitions;
	final Map<String, KlpDefinition<KlpNode>> _byId = {};

	KlpRegistry(Iterable<KlpDefinition<KlpNode>> definitions) : definitions = List.unmodifiable(definitions) {
		for (final definition in this.definitions) {
			_requireId(definition.id);
			if (_byId.containsKey(definition.id)) {
				throw KlpContractError('duplicate_definition', definition.id);
			}
			_byId[definition.id] = definition;
		}
		final active = <String>{};
		final complete = <String>{};
		for (final definition in this.definitions) {
			_validateDependencies(definition.id, active, complete);
		}
		// 掛載前拒絕缺漏、越權及循環引用；求值仍由本庫內部機制負責。
		KlpSemanticResolver(this.definitions.map((definition) => definition.semantics));
	}

	KlpDefinition<KlpNode> definition(String id) {
		final result = _byId[id];
		if (result == null) {
			throw KlpContractError('unknown_definition', id);
		}
		return result;
	}

	KlpTreeValidation validate(KlpNode root) => captureKlpTree(this, root).validation;

	void _validateDependencies(String id, Set<String> active, Set<String> complete) {
		_requireId(id);
		if (complete.contains(id)) return;
		if (!active.add(id)) {
			throw KlpContractError('dependency_cycle', id);
		}
		for (final dependency in definition(id).dependencies) {
			_validateDependencies(dependency, active, complete);
		}
		active.remove(id);
		complete.add(id);
	}

	void _requireId(String id) {
		if (id.trim().isEmpty) {
			throw const KlpContractError('empty_id', 'An identifier cannot be empty.');
		}
	}
}
