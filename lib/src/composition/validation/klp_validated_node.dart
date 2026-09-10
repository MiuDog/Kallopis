import '../../kernel/identity/klp_placement_id.dart';
import 'klp_validated_slot.dart';

/// 一次驗證取得的放置快照，不再讀取消費端節點 getter。
final class KlpValidatedNode {

	final KlpPlacementId placementId;
	final String definitionId;
	final List<KlpPlacementId> childrenPlacements;
	final List<KlpValidatedSlot> slotRanges;

	KlpValidatedNode(String id, String definitionId, Iterable<String> childrenIds, {Iterable<KlpValidatedSlot> slotRanges = const []}) : this.scoped(KlpPlacementId(localId: id), definitionId, childrenIds.map((child) => KlpPlacementId(localId: child)), slotRanges: slotRanges);

	KlpValidatedNode.scoped(this.placementId, this.definitionId, Iterable<KlpPlacementId> childrenPlacements, {Iterable<KlpValidatedSlot> slotRanges = const []}) : childrenPlacements = List.unmodifiable(childrenPlacements), slotRanges = List.unmodifiable(slotRanges);

	String get id => placementId.localId;
	List<String> get childrenIds => List.unmodifiable(childrenPlacements.map((child) => child.localId));
}
