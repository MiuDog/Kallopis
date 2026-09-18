import 'package:kallopis/src/features/editing/presentation/klp_editing_presentation.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editor_mode_item.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editor_mode_projection.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editor_mode_reply.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editor_mode_request.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editor_viewport_request.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_drawing.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_viewport.dart';

/// 只讓同一個已排版 viewport 的導覽工具接收平台事件。
bool klpCanRouteEditorViewport(KlpEditingDrawing drawing, KlpEditingViewport viewport, {required bool pending}) {
	if (pending || drawing.width != viewport.width || drawing.height != viewport.height) return false;
	final projection = drawing.editorModes;
	if (projection == null || projection.transition != KlpEditorModeTransition.ready) return false;
	final tool = projection.tools.singleWhere((candidate) => candidate.id == projection.activeToolId);
	return projection.activePurpose == KlpEditorInputPurpose.navigation && tool.controlsViewport && tool.enabled;
}

/// K04 無工具列外觀的排他狀態機；handler 只依來源已確認的 active tool 啟用。
final class KlpEditorModeSession {
	final KlpBoundModeToolbar _toolbar;
	final KlpEditingDrawing Function() _drawing;
	final Future<void> Function() _interrupt;
	final void Function() _onAuthoritySettled;
	bool _pending = false;
	bool _requiresResync = false;
	bool _closed = false;
	int _generation = 0;

	KlpEditorModeSession(this._toolbar, this._drawing, this._interrupt, this._onAuthoritySettled);

	bool get pending => _pending;
	bool get requiresResync => _requiresResync;
	KlpEditorModeProjection get projection => _current();

	Future<KlpEditorModeReply> switchTo(String modeId, String toolId) async {
		_begin();
		final generation = _generation;
		var authorityUnknown = false;
		var authorityKnown = false;
		try {
			// 先完成 K01 中斷，再讀取 fresh stamp，不能沿用按下工具時的舊權威。
			try { await _interrupt(); }
			catch (_) {
				authorityUnknown = true;
				rethrow;
			}
			if (_closed || generation != _generation) throw StateError('Editor mode session closed during interruption');
			authorityUnknown = true;
			final current = _current();
			authorityUnknown = false;
			authorityKnown = true;
			if (current.transition != KlpEditorModeTransition.ready) throw StateError('Editor mode authority is not ready');
			final mode = current.modes.where((candidate) => candidate.id == modeId && candidate.enabled).firstOrNull;
			final tool = current.tools.where((candidate) => candidate.id == toolId && candidate.modeId == modeId && candidate.enabled).firstOrNull;
			if (mode == null || tool == null) throw StateError('Editor mode or tool is unavailable');
			authorityUnknown = true;
			final reply = await _toolbar.actions.submitEditorMode(
				KlpEditorModeRequest(
					sequence: _toolbar.actions.issueCommandSequence(),
					expected: current.stamp,
					modeRevision: current.revision,
					modeId: mode.id,
					toolId: tool.id,
				),
				committedAtMs: DateTime.now().millisecondsSinceEpoch,
			);
			_validateReply(reply);
			authorityUnknown = false;
			return reply;
		}
		catch (_) {
			if (!_closed && authorityUnknown) _requiresResync = true;
			rethrow;
		}
		finally {
			_pending = false;
			if (!_closed && generation == _generation && authorityKnown && !authorityUnknown && !_requiresResync) _onAuthoritySettled();
		}
	}

	Future<KlpEditorModeReply> navigateBy(double deltaY) async {
		if (!deltaY.isFinite || deltaY == 0) throw ArgumentError.value(deltaY, 'deltaY');
		_begin();
		final generation = _generation;
		var authorityUnknown = true;
		var authorityKnown = false;
		try {
			final current = _current();
			authorityUnknown = false;
			authorityKnown = true;
			if (current.transition != KlpEditorModeTransition.ready) throw StateError('Editor mode authority is not ready');
			final mode = current.modes.singleWhere((candidate) => candidate.id == current.activeModeId);
			final tool = current.tools.singleWhere((candidate) => candidate.id == current.activeToolId);
			if (mode.purpose != KlpEditorInputPurpose.navigation || !tool.controlsViewport || !tool.enabled) throw StateError('Viewport handler is not active');
			authorityUnknown = true;
			final reply = await _toolbar.actions.submitEditorViewport(
				KlpEditorViewportRequest(
					sequence: _toolbar.actions.issueCommandSequence(),
					expected: current.stamp,
					modeRevision: current.revision,
					deltaY: deltaY,
				),
				committedAtMs: DateTime.now().millisecondsSinceEpoch,
			);
			_validateReply(reply);
			authorityUnknown = false;
			return reply;
		}
		catch (_) {
			if (!_closed && authorityUnknown) _requiresResync = true;
			rethrow;
		}
		finally {
			_pending = false;
			if (!_closed && generation == _generation && authorityKnown && !authorityUnknown && !_requiresResync) _onAuthoritySettled();
		}
	}

	void _begin() {
		if (_closed || _pending || _requiresResync) throw StateError('Editor mode session is unavailable');
		_pending = true;
	}

	KlpEditorModeProjection _current() {
		if (_closed) throw StateError('Editor mode session is closed');
		return _drawing().editorModes ?? (throw StateError('Editor mode projection is unavailable'));
	}

	void _validateReply(KlpEditorModeReply reply) {
		reply.editing.stamp.requireExact(reply.modes.stamp);
		final source = _drawing().editorModes ?? (throw StateError('Editor mode projection is unavailable'));
		source.stamp.requireExact(reply.modes.stamp);
		if (!identical(source, reply.modes)) throw StateError('Mode reply is not the source current projection');
	}

	void resynchronize() {
		if (_closed || _pending) throw StateError('Cannot resynchronize an active editor mode session');
		_current();
		_requiresResync = false;
	}

	void close() {
		if (_closed) return;
		_closed = true;
		_generation++;
	}
}
