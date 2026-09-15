import 'klp_editing_stamp.dart';

/// 舊正文區塊操作的請求種類；不在呈現層執行交易或維護 undo。
enum KlpBlockIntent { select, moveBefore, moveAfter, convert, convertToUnorderedList, convertToOrderedList, convertListToParagraph, indentList, outdentList, toggleTaskChecked, toggleCollapsed, undo, redo }

/// 已核准的單一文字區塊語意；不以任意階層或原生常數擴張集合。
enum KlpBlockTextKind { paragraph, heading1, heading2, heading3 }

/// K02-S1 單一區塊命令；target 一律使用 stable ID。
final class KlpBlockRequest {
	final int sequence;
	final KlpEditingStamp expected;
	final String blockId;
	final String? rangeEndId;
	final KlpBlockIntent intent;
	final String? targetId;
	final KlpBlockTextKind? conversion;

	KlpBlockRequest({required this.sequence, required this.expected, required this.blockId, this.rangeEndId, required this.intent, this.targetId, this.conversion}) {
		if (sequence <= 0) throw ArgumentError('Block command sequence must be positive');
		if (blockId.trim().isEmpty) throw ArgumentError('Block identity must not be empty');
		if (rangeEndId?.trim().isEmpty ?? false) throw ArgumentError('Block range identity must not be empty');
		final moves = intent == KlpBlockIntent.moveBefore || intent == KlpBlockIntent.moveAfter;
		final listOperation = intent == KlpBlockIntent.convertToUnorderedList || intent == KlpBlockIntent.convertToOrderedList || intent == KlpBlockIntent.convertListToParagraph || intent == KlpBlockIntent.indentList || intent == KlpBlockIntent.outdentList;
		if (moves != (targetId != null) || (targetId?.trim().isEmpty ?? false)) throw ArgumentError('Only move commands require a target identity');
		if (rangeEndId != null && intent != KlpBlockIntent.select && !moves && !listOperation) throw ArgumentError('This block command does not accept a range');
		if ((intent == KlpBlockIntent.convert) != (conversion != null)) throw ArgumentError('Only convert commands require a text kind');
	}
}
