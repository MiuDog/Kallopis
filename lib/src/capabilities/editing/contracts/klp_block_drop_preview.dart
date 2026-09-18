import 'klp_editing_stamp.dart';

/// 落點相對於目標區塊的穩定語意，不以快照 index 表示位置。
enum KlpBlockDropPlacement { before, after }

/// 連續區塊拖曳的本地暫態；建立或更新不會修改權威區塊順序。
final class KlpBlockDropPreview {
	final KlpEditingStamp expected;
	final String blockId;
	final String rangeEndId;
	final String targetId;
	final KlpBlockDropPlacement placement;

	KlpBlockDropPreview({required this.expected, required this.blockId, String? rangeEndId, required this.targetId, required this.placement}) : rangeEndId = rangeEndId ?? blockId {
		if (blockId.trim().isEmpty || this.rangeEndId.trim().isEmpty || targetId.trim().isEmpty) throw ArgumentError('Drop identities must not be empty');
		if (blockId == targetId || this.rangeEndId == targetId) throw ArgumentError('A block range endpoint cannot be its own drop target');
	}
}
