import 'dart:math' as math;

import 'contracts/klp_block_drop_preview.dart';
import 'contracts/klp_block_item.dart';

/// 同幀 hit geometry 推導出的單一合法落點；不包含呈現或提交狀態。
final class KlpBlockDropTarget {
	final String targetId;
	final KlpBlockDropPlacement placement;
	final int destinationIndex;

	const KlpBlockDropTarget(this.targetId, this.placement, this.destinationIndex);
}

bool klpCanDropBlockAt(List<KlpBlockItem> blocks, String sourceId, String targetId, KlpBlockDropPlacement placement, {String? sourceEndId}) {
	final source = _sourceRange(blocks, sourceId, sourceEndId ?? sourceId);
	final targetIndex = blocks.indexWhere((block) => block.id == targetId);
	if (targetIndex < 0) throw StateError('Block drop identity is stale');
	if (targetIndex >= source.start && targetIndex <= source.end || !blocks[source.start].canMoveBefore && !blocks[source.start].canMoveAfter) return false;
	return _destinationIndex(source.start, source.end, targetIndex, placement) != source.start;
}

List<KlpBlockDropTarget> klpBlockDropTargets(List<KlpBlockItem> blocks, String sourceId, {String? sourceEndId}) {
	final source = _sourceRange(blocks, sourceId, sourceEndId ?? sourceId);
	if (!blocks[source.start].canMoveBefore && !blocks[source.start].canMoveAfter) return const [];
	final remaining = [for (var index = 0; index < blocks.length; index += 1) if (index < source.start || index > source.end) blocks[index]];
	return List.unmodifiable([
		for (var destination = 0; destination < remaining.length + 1; destination++)
			if (destination != source.start)
				if (destination < remaining.length)
					KlpBlockDropTarget(remaining[destination].id, KlpBlockDropPlacement.before, destination)
				else
					KlpBlockDropTarget(remaining.last.id, KlpBlockDropPlacement.after, destination),
	]);
}

KlpBlockDropTarget? klpResolveBlockDropTarget({required List<KlpBlockItem> blocks, required String sourceId, String? sourceEndId, required double pointerY, required double viewportHeight}) {
	if (!pointerY.isFinite || !viewportHeight.isFinite || viewportHeight <= 0) throw ArgumentError('Invalid block drop viewport geometry');
	final source = _sourceRange(blocks, sourceId, sourceEndId ?? sourceId);
	KlpBlockItem? target;
	double? distance;
	for (final block in blocks) {
		final index = blocks.indexOf(block);
		if (index >= source.start && index <= source.end || block.hitRect.height <= 0 || block.hitRect.y >= viewportHeight || block.hitRect.y + block.hitRect.height <= 0) continue;
		final current = pointerY < block.hitRect.y
			? block.hitRect.y - pointerY
			: pointerY > block.hitRect.y + block.hitRect.height ? pointerY - block.hitRect.y - block.hitRect.height : 0.0;
		if (distance == null || current < distance) {
			target = block;
			distance = current;
		}
	}
	if (target == null) return null;
	final placement = pointerY < target.hitRect.y + target.hitRect.height / 2 ? KlpBlockDropPlacement.before : KlpBlockDropPlacement.after;
	if (!klpCanDropBlockAt(blocks, sourceId, target.id, placement, sourceEndId: sourceEndId)) return null;
	final targetIndex = blocks.indexWhere((block) => block.id == target!.id);
	return KlpBlockDropTarget(target.id, placement, _destinationIndex(source.start, source.end, targetIndex, placement));
}

int _destinationIndex(int sourceStart, int sourceEnd, int targetIndex, KlpBlockDropPlacement placement) {
	final targetAfterRemoval = targetIndex > sourceEnd ? targetIndex - (sourceEnd - sourceStart + 1) : targetIndex;
	return placement == KlpBlockDropPlacement.before ? targetAfterRemoval : targetAfterRemoval + 1;
}

({int start, int end}) _sourceRange(List<KlpBlockItem> blocks, String firstId, String lastId) {
	final first = blocks.indexWhere((block) => block.id == firstId);
	final last = blocks.indexWhere((block) => block.id == lastId);
	if (first < 0 || last < 0) throw StateError('Block drop source is stale');
	return (start: math.min(first, last), end: math.max(first, last));
}
