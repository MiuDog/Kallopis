part of 'klp_slot.dart';

/// 只能由原始插槽建立的封閉配置，保存資格與不可變子項快照。
final class KlpSlotAssignment<C extends KlpNode> {

	final KlpSlot<C> slot;
	final List<C> children;

	const KlpSlotAssignment._(this.slot, this.children);
}
