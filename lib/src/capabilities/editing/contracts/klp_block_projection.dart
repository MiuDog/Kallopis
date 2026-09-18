import 'klp_block_item.dart';
import 'klp_editing_stamp.dart';

/// 與 drawing 共用完整 stamp 的有序區塊控制投影。
final class KlpBlockProjection {
	final KlpEditingStamp stamp;
	final double width;
	final double height;
	final bool canUndo;
	final bool canRedo;
	final List<KlpBlockItem> blocks;

	KlpBlockProjection({required this.stamp, required this.width, required this.height, required this.canUndo, required this.canRedo, required Iterable<KlpBlockItem> blocks}) : blocks = List.unmodifiable(blocks) {
		if (!width.isFinite || !height.isFinite || width <= 0 || height <= 0) throw ArgumentError('Invalid block projection viewport');
		final ids = <String>{};
		for (final block in this.blocks) {
			if (!ids.add(block.id)) throw ArgumentError('Duplicate block identity');
		}
		final selected = [for (var index = 0; index < this.blocks.length; index += 1) if (this.blocks[index].selected) index];
		if (selected.isEmpty) return;
		if (selected.last - selected.first + 1 != selected.length) throw ArgumentError('Block selection must be contiguous');
		if (this.blocks.where((block) => block.selectionAnchor).length != 1 || this.blocks.where((block) => block.selectionFocus).length != 1) throw ArgumentError('Block selection requires one anchor and one focus');
	}

	List<KlpBlockItem> get selectedBlocks => List.unmodifiable(blocks.where((block) => block.selected));
	KlpBlockItem? get selectionAnchor => blocks.where((block) => block.selectionAnchor).firstOrNull;
	KlpBlockItem? get selectionFocus => blocks.where((block) => block.selectionFocus).firstOrNull;
	KlpBlockItem? get selectionFirst => blocks.where((block) => block.selected).firstOrNull;
	KlpBlockItem? get selectionLast => blocks.where((block) => block.selected).lastOrNull;
}
