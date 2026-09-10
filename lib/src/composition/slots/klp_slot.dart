import '../../kernel/diagnostics/klp_contract_error.dart';
import '../../kernel/identity/internal/klp_identifier.dart';
import '../nodes/klp_node.dart';

part 'klp_slot_assignment.dart';

/// 定義期宣告的插槽身分及資格；實例只能交付符合資格的子項。
final class KlpSlot<C extends KlpNode> {

	final String owner;
	final String name;
	final int min;
	final int? max;

	KlpSlot({required this.owner, required this.name, this.min = 0, this.max}) {
		if (!isKlpIdentifier(owner) || !isKlpIdentifier(name)) throw const KlpContractError('invalid_slot_id', 'Slot owner and name must be identifiers.');
		if (min < 0 || (max != null && max! < min)) throw KlpContractError('invalid_slot_cardinality', '$owner.$name');
	}

	bool accepts(KlpNode node) => node is C;

	KlpSlotAssignment<C> assign(List<C> children) {
		final snapshot = List<C>.unmodifiable(children);
		if (snapshot.length < min || (max != null && snapshot.length > max!)) throw KlpContractError('slot_cardinality', '$owner.$name');
		return KlpSlotAssignment<C>._(this, snapshot);
	}
}
