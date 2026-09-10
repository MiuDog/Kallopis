import '../nodes/klp_node.dart';
import '../slots/klp_slot.dart';

/// 已驗證插槽在 childrenIds 的半開範圍，不保存消費端子節點。
final class KlpValidatedSlot {

	final KlpSlot<KlpNode> slot;
	final int start;
	final int end;

	const KlpValidatedSlot(this.slot, this.start, this.end);
}
