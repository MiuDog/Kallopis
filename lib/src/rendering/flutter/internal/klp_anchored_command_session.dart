import 'package:kallopis/src/features/editing/presentation/klp_editing_presentation.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_command_anchor.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_command_projection.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_command_reply.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_command_request.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_drawing.dart';
import 'package:kallopis/src/foundation/interaction/klp_roving_index.dart';

/// K03 無畫面的狀態機；開啟入口與選單布局定型後由 renderer 呼叫。
final class KlpAnchoredCommandSession {
	final KlpBoundAnchoredCommands _commands;
	final KlpEditingDrawing Function() _drawing;
	final Future<void> Function() _interrupt;
	KlpCommandProjection? _projection;
	KlpCommandAnchor? _intentAnchor;
	String? _highlightedId;
	bool _opened = false;
	bool _pending = false;
	bool _requiresResync = false;
	bool _disposed = false;
	int _generation = 0;

	KlpAnchoredCommandSession(this._commands, this._drawing, this._interrupt);

	bool get opened => _opened;
	bool get pending => _pending;
	bool get requiresResync => _requiresResync;
	String? get highlightedId => _highlightedId;
	KlpCommandProjection? get projection => _projection;

	Future<bool> open() async {
		if (_disposed || _pending || _opened || _requiresResync) throw StateError('Anchored command session is unavailable');
		_pending = true;
		final generation = _generation;
		try {
			// 開啟只中斷一次 K01；導覽與本地關閉不再觸碰核心。
			await _interrupt();
			if (_disposed || generation != _generation) return false;
			_adoptCurrent();
			_intentAnchor = _projection!.anchor;
			_opened = true;
			return true;
		}
		catch (_) {
			if (!_disposed) _requiresResync = true;
			rethrow;
		}
		finally { _pending = false; }
	}

	void next() => _move(forward: true);
	void previous() => _move(forward: false);
	void home() => _edge(first: true);
	void end() => _edge(first: false);
	void select(String id) {
		final commands = _ready();
		final item = commands.items.where((candidate) => candidate.id == id && candidate.enabled).firstOrNull;
		if (item == null) throw StateError('Anchored command is unavailable');
		_highlightedId = item.id;
		_intentAnchor = commands.anchor;
	}

	Future<KlpCommandReply> confirm() async {
		if (_disposed || !_opened || _pending || _requiresResync) throw StateError('Anchored command confirmation is unavailable');
		final intendedId = _highlightedId;
		final intendedAnchor = _intentAnchor;
		_adoptCurrent(selectFallback: false);
		final commands = _projection!;
		if (intendedAnchor == null || !_sameTarget(intendedAnchor, commands.anchor)) {
			_highlightedId = null;
			throw StateError('Anchored command target changed before confirmation');
		}
		final selected = commands.items.where((item) => item.id == intendedId && item.enabled).firstOrNull;
		if (selected == null) _highlightedId = null;
		if (selected == null) throw StateError('No enabled anchored command is highlighted');
		_pending = true;
		final generation = _generation;
		try {
			final reply = await _commands.actions.submitAnchoredCommand(
				KlpCommandRequest(
					sequence: _commands.actions.issueCommandSequence(),
					expected: commands.stamp,
					commandRevision: commands.revision,
					anchor: commands.anchor,
					commandId: selected.id,
				),
				committedAtMs: DateTime.now().millisecondsSinceEpoch,
			);
			if (!_disposed && generation == _generation) close();
			return reply;
		}
		catch (_) {
			if (!_disposed) {
				_requiresResync = true;
				if (generation == _generation) {
					_opened = false;
					_highlightedId = null;
				}
			}
			rethrow;
		}
		finally { _pending = false; }
	}

	void _move({required bool forward}) {
		final commands = _ready();
		final current = commands.items.indexWhere((item) => item.id == _highlightedId);
		final index = KlpRovingIndex.move(current: current, count: commands.items.length, forward: forward, isEnabled: (index) => commands.items[index].enabled);
		_highlightedId = index < 0 ? null : commands.items[index].id;
		_intentAnchor = commands.anchor;
	}

	void _edge({required bool first}) {
		final commands = _ready();
		final index = first
			? KlpRovingIndex.first(count: commands.items.length, isEnabled: (index) => commands.items[index].enabled)
			: KlpRovingIndex.last(count: commands.items.length, isEnabled: (index) => commands.items[index].enabled);
		_highlightedId = index < 0 ? null : commands.items[index].id;
		_intentAnchor = commands.anchor;
	}

	KlpCommandProjection _ready() {
		if (_disposed || !_opened || _pending || _requiresResync) throw StateError('Anchored command navigation is unavailable');
		_adoptCurrent();
		return _projection!;
	}

	void _adoptCurrent({bool selectFallback = true}) {
		final drawing = _drawing();
		final next = drawing.anchoredCommands ?? (throw StateError('Anchored command projection is unavailable'));
		drawing.projection.stamp.requireExact(next.stamp);
		final prior = _projection;
		if (prior != null) {
			if (!prior.stamp.sameSession(next.stamp) || next.revision < prior.revision) throw StateError('Anchored command projection regressed');
			if (next.revision == prior.revision && !identical(next, prior)) throw StateError('Anchored command revision changed without advancing');
		}
		_projection = next;
		final retained = next.items.where((item) => item.id == _highlightedId && item.enabled).firstOrNull;
		if (retained != null || !selectFallback) return;
		final first = KlpRovingIndex.first(count: next.items.length, isEnabled: (index) => next.items[index].enabled);
		_highlightedId = first < 0 ? null : next.items[first].id;
	}

	void close() {
		if (_disposed) return;
		_generation++;
		_opened = false;
		_highlightedId = null;
		_projection = null;
		_intentAnchor = null;
	}

	void resynchronize() {
		if (_disposed || _pending) throw StateError('Cannot resynchronize an active command session');
		_requiresResync = false;
		_projection = null;
		_intentAnchor = null;
	}

	void dispose() {
		if (_disposed) return;
		close();
		_disposed = true;
	}
}

bool _sameTarget(KlpCommandAnchor left, KlpCommandAnchor right) => switch ((left, right)) {
	(KlpCaretCommandAnchor(:final endpoint), KlpCaretCommandAnchor(endpoint: final other)) => endpoint == other,
	(KlpBlockCommandAnchor(:final blockId), KlpBlockCommandAnchor(blockId: final other)) => blockId == other,
	_ => false,
};
