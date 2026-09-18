import 'package:kallopis/src/features/editing/presentation/klp_editing_presentation.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_block_drop_preview.dart';
import 'package:kallopis/src/capabilities/editing/klp_block_drop_target.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_block_item.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_block_projection.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_block_request.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_block_viewport_request.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_drawing.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_reply.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_stamp.dart';
import 'klp_editing_command_sequence.dart';

/// K02 單一區塊命令機制；可見控制位置定型前不自行建立第二份選取狀態。
final class KlpFlutterBlockControlSession {
	final KlpBoundBlockControls _controls;
	final KlpEditingCommandSequence _sequence;
	final KlpEditingDrawing Function() _drawing;
	final Future<void> Function() _interrupt;
	bool _busy = false;
	bool _closed = false;
	bool _dropViewportPending = false;
	_DropStart? _drop;
	KlpBlockDropPreview? _dropPreview;

	KlpFlutterBlockControlSession(this._controls, this._sequence, this._drawing, this._interrupt);

	Future<KlpEditingReply> select(String blockId) => _run(KlpBlockIntent.select, blockId);
	Future<KlpEditingReply> selectRange(String anchorId, String focusId) => _run(KlpBlockIntent.select, anchorId, rangeEndId: focusId);
	Future<KlpEditingReply> moveBefore(String blockId) => _run(KlpBlockIntent.moveBefore, blockId);
	Future<KlpEditingReply> moveAfter(String blockId) => _run(KlpBlockIntent.moveAfter, blockId);
	Future<KlpEditingReply> convert(String blockId, KlpBlockTextKind target) => _run(KlpBlockIntent.convert, blockId, conversion: target);
	Future<KlpEditingReply> convertSelectionToUnorderedList() => _runListOperation(KlpBlockIntent.convertToUnorderedList);
	Future<KlpEditingReply> convertSelectionToOrderedList() => _runListOperation(KlpBlockIntent.convertToOrderedList);
	Future<KlpEditingReply> convertSelectionToParagraph() => _runListOperation(KlpBlockIntent.convertListToParagraph);
	Future<KlpEditingReply> indentSelection() => _runListOperation(KlpBlockIntent.indentList);
	Future<KlpEditingReply> outdentSelection() => _runListOperation(KlpBlockIntent.outdentList);
	Future<KlpEditingReply> toggleTaskChecked(String blockId) => _run(KlpBlockIntent.toggleTaskChecked, blockId);
	Future<KlpEditingReply> toggleCollapsed(String blockId) => _run(KlpBlockIntent.toggleCollapsed, blockId);
	Future<KlpEditingReply> undo() => _history(KlpBlockIntent.undo);
	Future<KlpEditingReply> redo() => _history(KlpBlockIntent.redo);

	/// 指標與鍵盤共用此入口，只保留 stable source 與開始時的完整 stamp。
	void beginDrop(String blockId) {
		if (_closed || _busy || _drop != null) throw StateError('Block drop session is unavailable');
		final drawing = _drawing();
		final projection = drawing.blocks ?? (throw StateError('Block projection is unavailable'));
		final block = _block(projection.blocks, blockId);
		final first = projection.selectionFirst;
		final last = projection.selectionLast;
		if (!block.selected || first == null || last == null || !first.canMoveBefore && !first.canMoveAfter) throw StateError('Block move is unavailable');
		_drop = _DropStart(drawing.projection.stamp, first.id, last.id, block.id);
	}

	/// 更新本地候選落點；不建立 request，也不改動公開投影。
	KlpBlockDropPreview previewDrop(String targetId, KlpBlockDropPlacement placement) {
		final current = _drop ?? (throw StateError('Block drop has not begun'));
		try {
			final drawing = _drawing();
			_drawingStamp(drawing).requireExact(current.expected);
			final blocks = drawing.blocks!.blocks;
			final source = _block(blocks, current.handleId);
			final target = _block(blocks, targetId);
			if (!source.selected || !_rangeMatches(drawing.blocks!, current) || !klpCanDropBlockAt(blocks, current.firstId, target.id, placement, sourceEndId: current.lastId)) throw StateError('Block move is unavailable');
			return _dropPreview = KlpBlockDropPreview(expected: current.expected, blockId: current.firstId, rangeEndId: current.lastId, targetId: target.id, placement: placement);
		}
		catch (_) {
			cancelDrop();
			rethrow;
		}
	}

	/// Esc、失焦與來源失效都只清除本地暫態，絕不反向送出移動。
	void cancelDrop() {
		_drop = null;
		_dropPreview = null;
	}

	/// 指標暫時離開合法落點時只清除指示，拖曳來源仍維持有效。
	void clearDropPreview() {
		if (_drop == null) throw StateError('Block drop has not begun');
		_dropPreview = null;
	}

	Future<bool> scrollDropViewport(double deltaY) async {
		if (_closed || _busy || _dropViewportPending || !deltaY.isFinite || deltaY == 0) throw StateError('Block drop viewport is unavailable');
		final current = _drop ?? (throw StateError('Block drop has not begun'));
		_busy = true;
		_dropViewportPending = true;
		_dropPreview = null;
		try {
			final reply = await _controls.actions.submitBlockViewport(
				KlpBlockViewportRequest(sequence: _sequence.next(), expected: current.expected, blockId: current.handleId, deltaY: deltaY),
				committedAtMs: DateTime.now().millisecondsSinceEpoch,
			);
			if (reply.decision != KlpEditingDecision.accepted) return false;
			final drawing = _drawing();
			final next = _drawingStamp(drawing);
			if (!next.sameSession(current.expected) || next.environmentId != current.expected.environmentId || next.contentRevision != current.expected.contentRevision || next.compositionRevision != current.expected.compositionRevision || next.projectionRevision <= current.expected.projectionRevision || next.layoutRevision <= current.expected.layoutRevision) {
				throw StateError('Block drop viewport changed document authority');
			}
			final source = _block(drawing.blocks!.blocks, current.handleId);
			if (!source.selected || !_rangeMatches(drawing.blocks!, current) || !source.canMoveBefore && !source.canMoveAfter) throw StateError('Block move is unavailable after viewport navigation');
			_drop = _DropStart(next, current.firstId, current.lastId, source.id);
			return true;
		}
		catch (_) {
			cancelDrop();
			rethrow;
		}
		finally {
			_dropViewportPending = false;
			_busy = false;
		}
	}

	bool get dropViewportPending => _dropViewportPending;

	Future<KlpEditingReply> commitDrop() async {
		if (_closed || _busy) throw StateError('Block control session is unavailable');
		final preview = _dropPreview ?? (throw StateError('Block drop has no preview'));
		_busy = true;
		try {
			// 提交前沿 K01 同一中斷流程，避免在組字仍未確認時改動區塊順序。
			await _interrupt();
			if (_closed) throw StateError('Block control session is closed');
			final drawing = _drawing();
			_drawingStamp(drawing).requireExact(preview.expected);
			final blocks = drawing.blocks!.blocks;
			final source = _block(blocks, preview.blockId);
			final target = _block(blocks, preview.targetId);
			if (!source.selected || drawing.blocks!.selectionFirst?.id != preview.blockId || drawing.blocks!.selectionLast?.id != preview.rangeEndId || !klpCanDropBlockAt(blocks, preview.blockId, target.id, preview.placement, sourceEndId: preview.rangeEndId)) throw StateError('Block move is unavailable');
			cancelDrop();
			return await _controls.actions.submitBlock(
				KlpBlockRequest(
					sequence: _sequence.next(),
					expected: preview.expected,
					blockId: source.id,
					rangeEndId: preview.rangeEndId,
					intent: preview.placement == KlpBlockDropPlacement.before ? KlpBlockIntent.moveBefore : KlpBlockIntent.moveAfter,
					targetId: target.id,
				),
				committedAtMs: DateTime.now().millisecondsSinceEpoch,
			);
		}
		catch (_) {
			cancelDrop();
			rethrow;
		}
		finally { _busy = false; }
	}

	KlpBlockDropPreview? get dropPreview {
		final preview = _dropPreview;
		if (preview == null) return null;
		try {
			final drawing = _drawing();
			_drawingStamp(drawing).requireExact(preview.expected);
			final blocks = drawing.blocks!.blocks;
			final source = _block(blocks, preview.blockId);
			final target = _block(blocks, preview.targetId);
			if (!source.selected || drawing.blocks!.selectionFirst?.id != preview.blockId || drawing.blocks!.selectionLast?.id != preview.rangeEndId || !klpCanDropBlockAt(blocks, preview.blockId, target.id, preview.placement, sourceEndId: preview.rangeEndId)) throw StateError('Block move is unavailable');
			return preview;
		}
		catch (_) {
			cancelDrop();
			return null;
		}
	}

	Future<KlpEditingReply> _history(KlpBlockIntent intent) async {
		final projection = _drawing().blocks ?? (throw StateError('Block projection is unavailable'));
		final selected = projection.blocks.where((block) => block.selected).firstOrNull ?? projection.blocks.firstOrNull;
		if (selected == null) throw StateError('Block history has no stable authority identity');
		return _run(intent, selected.id);
	}

	Future<KlpEditingReply> _runListOperation(KlpBlockIntent intent) {
		final projection = _drawing().blocks ?? (throw StateError('Block projection is unavailable'));
		final first = projection.selectionFirst ?? (throw StateError('List operation requires a block selection'));
		final last = projection.selectionLast!;
		if (intent == KlpBlockIntent.indentList && !first.canIndent ||
			intent == KlpBlockIntent.outdentList && !projection.selectedBlocks.every((block) => block.canOutdent)) {
			throw StateError('List depth operation is unavailable');
		}
		return _run(intent, first.id, rangeEndId: last.id);
	}

	Future<KlpEditingReply> _run(KlpBlockIntent intent, String blockId, {String? rangeEndId, KlpBlockTextKind? conversion}) async {
		if (_closed || _busy || _drop != null) throw StateError('Block control session is unavailable');
		_busy = true;
		try {
			// 切換到區塊模式前沿 K01 同一中斷流程等待在途輸入並取消 preview。
			await _interrupt();
			if (_closed) throw StateError('Block control session is closed');
			final drawing = _drawing();
			final projection = drawing.blocks ?? (throw StateError('Block projection is unavailable'));
			if (intent == KlpBlockIntent.undo && !projection.canUndo || intent == KlpBlockIntent.redo && !projection.canRedo) throw StateError('Block history action is unavailable');
			final index = projection.blocks.indexWhere((block) => block.id == blockId);
			if (index < 0) throw StateError('Block identity is stale');
			final block = projection.blocks[index];
			if (intent == KlpBlockIntent.select && rangeEndId != null) _block(projection.blocks, rangeEndId);
			if (intent == KlpBlockIntent.convert && (!block.selected || projection.selectedBlocks.length != 1 || block.textKind == null)) throw StateError('Block conversion requires one selected text block');
			final listOperation = intent == KlpBlockIntent.convertToUnorderedList || intent == KlpBlockIntent.convertToOrderedList || intent == KlpBlockIntent.convertListToParagraph || intent == KlpBlockIntent.indentList || intent == KlpBlockIntent.outdentList;
			if (listOperation && (!block.selected || rangeEndId == null || projection.selectionFirst?.id != block.id || projection.selectionLast?.id != rangeEndId)) throw StateError('List operation requires the current stable selection range');
			if (intent == KlpBlockIntent.toggleTaskChecked && (block.kind != KlpBlockKind.taskListItem || block.taskChecked == null)) throw StateError('Block task state requires one task item');
			if (intent == KlpBlockIntent.toggleCollapsed && (block.kind != KlpBlockKind.toggleListItem || block.toggleCollapsed == null)) throw StateError('Block toggle state requires one toggle item');
			final target = _target(projection, block, intent);
			final moves = intent == KlpBlockIntent.moveBefore || intent == KlpBlockIntent.moveAfter;
			final requestBlock = moves ? projection.selectionFirst!.id : block.id;
			final requestEnd = moves ? projection.selectionLast?.id : rangeEndId;
			return await _controls.actions.submitBlock(
				KlpBlockRequest(
					sequence: _sequence.next(),
					expected: drawing.projection.stamp,
					blockId: requestBlock,
					rangeEndId: requestEnd,
					intent: intent,
					targetId: target,
					conversion: conversion,
				),
				committedAtMs: DateTime.now().millisecondsSinceEpoch,
			);
		}
		finally { _busy = false; }
	}

	String? _target(KlpBlockProjection projection, KlpBlockItem block, KlpBlockIntent intent) => switch (intent) {
		KlpBlockIntent.moveBefore when block.selected && block.canMoveBefore && projection.selectionFirst != null && projection.blocks.indexOf(projection.selectionFirst!) > 0 => projection.blocks[projection.blocks.indexOf(projection.selectionFirst!) - 1].id,
		KlpBlockIntent.moveAfter when block.selected && block.canMoveAfter && projection.selectionLast != null && projection.blocks.indexOf(projection.selectionLast!) + 1 < projection.blocks.length => projection.blocks[projection.blocks.indexOf(projection.selectionLast!) + 1].id,
		KlpBlockIntent.moveBefore || KlpBlockIntent.moveAfter => throw StateError('Block move is unavailable'),
		_ => null,
	};

	bool _rangeMatches(KlpBlockProjection projection, _DropStart drop) => projection.selectionFirst?.id == drop.firstId && projection.selectionLast?.id == drop.lastId;

	KlpBlockItem _block(List<KlpBlockItem> blocks, String id) => blocks.where((block) => block.id == id).firstOrNull ?? (throw StateError('Block identity is stale'));

	KlpEditingStamp _drawingStamp(KlpEditingDrawing drawing) {
		if (drawing.blocks == null) throw StateError('Block projection is unavailable');
		return drawing.projection.stamp;
	}

	void close() {
		_closed = true;
		cancelDrop();
	}
}

final class _DropStart {
	final KlpEditingStamp expected;
	final String firstId;
	final String lastId;
	final String handleId;

	const _DropStart(this.expected, this.firstId, this.lastId, this.handleId);
}
