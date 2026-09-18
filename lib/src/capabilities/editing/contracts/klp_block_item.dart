import 'klp_editing_draw_command.dart';
import 'klp_block_request.dart';

/// 舊正文區塊的呈現種類；結構與內容仍由提供者掌管。
enum KlpBlockKind { paragraph, heading, unorderedListItem, orderedListItem, taskListItem, quote, code, thematicBreak, comment, toggleListItem, math }

/// 同一 core frame 的穩定區塊身分、操作能力與兩種幾何。
final class KlpBlockItem {
	final String id;
	final KlpBlockKind kind;
	final KlpBlockTextKind? textKind;
	final bool? taskChecked;
	final bool? toggleCollapsed;
	final int? nestingDepth;
	final int? listOrdinal;
	final bool canIndent;
	final bool canOutdent;
	final bool selected;
	final bool selectionAnchor;
	final bool selectionFocus;
	final bool canMoveBefore;
	final bool canMoveAfter;
	final KlpEditingRect hitRect;
	final KlpEditingRect visualRect;

	KlpBlockItem({required this.id, required this.kind, required this.textKind, this.taskChecked, this.toggleCollapsed, this.nestingDepth, this.listOrdinal, this.canIndent = false, this.canOutdent = false, required this.selected, bool? selectionAnchor, bool? selectionFocus, required this.canMoveBefore, required this.canMoveAfter, required this.hitRect, required this.visualRect}) : selectionAnchor = selectionAnchor ?? selected, selectionFocus = selectionFocus ?? selected {
		if (id.trim().isEmpty) throw ArgumentError('Block identity must not be empty');
		if (kind == KlpBlockKind.paragraph && textKind != KlpBlockTextKind.paragraph ||
			kind == KlpBlockKind.heading && textKind == KlpBlockTextKind.paragraph ||
			kind != KlpBlockKind.paragraph && kind != KlpBlockKind.heading && textKind != null) {
			throw ArgumentError('Block text kind is inconsistent with its structural kind');
		}
		if (kind == KlpBlockKind.taskListItem && taskChecked == null ||
			kind != KlpBlockKind.taskListItem && taskChecked != null ||
			kind == KlpBlockKind.toggleListItem && toggleCollapsed == null ||
			kind != KlpBlockKind.toggleListItem && toggleCollapsed != null) {
			throw ArgumentError('Block state is inconsistent with its structural kind');
		}
		final isList = kind == KlpBlockKind.unorderedListItem || kind == KlpBlockKind.orderedListItem;
		if (!isList && (nestingDepth != null || listOrdinal != null || canIndent || canOutdent) ||
			isList && (nestingDepth == null || nestingDepth! < 0 || nestingDepth! > 32) ||
			kind == KlpBlockKind.unorderedListItem && listOrdinal != null ||
			kind == KlpBlockKind.orderedListItem && (listOrdinal == null || listOrdinal! <= 0) ||
			canOutdent && (nestingDepth == null || nestingDepth == 0)) {
			throw ArgumentError('Block list information is inconsistent with its structural kind');
		}
		if (!selected && (this.selectionAnchor || this.selectionFocus)) throw ArgumentError('Block selection endpoint must be selected');
		_validate(hitRect);
		_validate(visualRect);
	}

	void _validate(KlpEditingRect rect) {
		if (![rect.x, rect.y, rect.width, rect.height, rect.x + rect.width, rect.y + rect.height].every((value) => value.isFinite) || rect.width < 0 || rect.height < 0) throw ArgumentError('Invalid block geometry');
	}
}
