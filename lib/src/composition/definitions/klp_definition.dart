import '../nodes/klp_node.dart';
import '../slots/klp_slot.dart';
import '../../kernel/diagnostics/klp_contract_error.dart';
import '../../styling/semantics/klp_semantic_schema.dart';

/// 不可變的節點定義；資格只由型別決定，不能注入驗證演算法。
final class KlpDefinition<T extends KlpNode> {

	final String id;
	final List<String> dependencies;
	final KlpSemanticSchema semantics;
	final List<KlpSlot<KlpNode>> slots;

	KlpDefinition(this.id, {Iterable<String> dependencies = const [], KlpSemanticSchema? semantics, Iterable<KlpSlot<KlpNode>> slots = const []}) : semantics = semantics ?? KlpSemanticSchema(id, const []), dependencies = List.unmodifiable({...dependencies, ...?semantics?.dependencies}), slots = List.unmodifiable(slots) {
		// 風格用途與節點定義共用所有者；語意依賴自動納入安裝相依。
		if (this.semantics.owner != id) throw KlpContractError('semantic_owner_mismatch', '$id owns ${this.semantics.owner}');
		final names = <String>{};
		for (final slot in this.slots) {
			if (slot.owner != id) throw KlpContractError('slot_owner_mismatch', '$id owns ${slot.owner}.${slot.name}');
			if (!names.add(slot.name)) throw KlpContractError('duplicate_slot', '$id.${slot.name}');
		}
	}

	bool accepts(KlpNode node) => node is T;
}
