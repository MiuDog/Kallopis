import 'package:flutter/foundation.dart';

import 'package:kallopis/src/features/actions/command_registry/klp_command_registry.dart';

/// 解析 primary modifier 的宿主平台，不偵測或保存全域環境。
enum KlpShortcutPlatform { mac, other }
/// 產品投影的快捷鍵作用域，依焦點鏈決定有效候選。
enum KlpShortcutScope { app, page, region, component }
/// 一次按鍵解析的生命週期結果，不代表產品命令成功與否。
enum KlpShortcutHandlingState { ignored, prefix, executed, cancelled, recording }
/// 區分快捷鍵完整重疊與 chord 前綴重疊。
enum KlpShortcutConflictKind { exact, prefix }

/// 單一步驟的邏輯鍵與 modifier 值，不持有原生鍵盤事件。
@immutable
class KlpShortcutStroke {

	/* key 是 canonical logical key；primary 隨平台投影；四個 explicit modifier 必須精確比對。 */
	final String key;
	final bool primary;
	final bool ctrl;
	final bool alt;
	final bool shift;
	final bool meta;

	const KlpShortcutStroke({
		required this.key,
		this.primary = false,
		this.ctrl = false,
		this.alt = false,
		this.shift = false,
		this.meta = false,
	});
}

/// 單次輸入的邏輯鍵、repeat 與組字狀態，由宿主投影。
@immutable
class KlpShortcutInput extends KlpShortcutStroke {

	/* stroke 欄位沿父類；repeat 控制重複 keydown，composing 保護輸入法。 */
	final bool repeat;
	final bool composing;

	const KlpShortcutInput({
		required super.key,
		super.primary,
		super.ctrl,
		super.alt,
		super.shift,
		super.meta,
		this.repeat = false,
		this.composing = false,
	});
}

/// 當次產品焦點與作用域鏈，不建立或接管產品焦點樹。
@immutable
class KlpShortcutFocus {

	/* focusId 是原生焦點 owner；三個 scope ID 投影有效鏈；editable 避免接管正文輸入。 */
	final String focusId;
	final String? pageId;
	final String? regionId;
	final String? componentId;
	final bool editable;

	const KlpShortcutFocus({
		required this.focusId,
		this.pageId,
		this.regionId,
		this.componentId,
		this.editable = false,
	});
}

/// 註冊 token、命令引用與不可變序列；業務 handler 由 registry 擁有。
@immutable
class KlpShortcutBinding<C> {

	/* id 是 binding owner；commandId 引用唯一 registry；sequence 隔離產品預設組合。 */
	final String id;
	final String commandId;
	final List<KlpShortcutStroke> sequence;
	/* scope／scopeId 限制有效焦點；priority 決定同層排序；兩個 allow 明示輸入例外；when 讀當次產品資料。 */
	final KlpShortcutScope scope;
	final String? scopeId;
	final int priority;
	final bool allowRepeat;
	final bool allowInEditable;
	final bool Function(C)? when;

	KlpShortcutBinding({
		required this.id,
		required this.commandId,
		required List<KlpShortcutStroke> sequence,
		required this.scope,
		this.scopeId,
		this.priority = 0,
		this.allowRepeat = false,
		this.allowInEditable = false,
		this.when,
	}) : sequence = List.unmodifiable(sequence);
}

/// 按鍵是否消費及解析結果，執行時保留原 registry Future。
@immutable
class KlpShortcutHandling {

	/* handled 僅實際消費事件成立；state 描述解析結果；兩 ID／execution 只在適用狀態存在。 */
	final bool handled;
	final KlpShortcutHandlingState state;
	final String? bindingId;
	final String? commandId;
	final Future<KlpCommandExecutionResult>? execution;

	const KlpShortcutHandling._({
		required this.handled,
		required this.state,
		this.bindingId,
		this.commandId,
		this.execution,
	});
}

/// 穩定排序的衝突清單與勝出 binding，不修改產品註冊設定。
@immutable
class KlpShortcutConflict {

	/* kind 區分完整及前綴衝突；bindingIds 為穩定 UTF-16 ID 對；winnerId 由固定順位決定。 */
	final KlpShortcutConflictKind kind;
	final List<String> bindingIds;
	final String winnerId;

	KlpShortcutConflict._(this.kind, List<String> ids, this.winnerId) : bindingIds = List.unmodifiable(ids);
}

class _Candidate<C> {

	/* binding 保留註冊 token；sequence 為目前有效覆寫，僅在當次解析使用。 */
	final KlpShortcutBinding<C> binding;
	final List<KlpShortcutStroke> sequence;

	_Candidate(this.binding, this.sequence);
}

const _namedKeys = {'enter', 'escape', 'tab', 'space', 'backspace', 'delete', 'insert', 'home', 'end', 'pageup', 'pagedown', 'arrowup', 'arrowdown', 'arrowleft', 'arrowright'};
const _modifierNames = ['primary', 'ctrl', 'alt', 'shift', 'meta'];

/// 解析已註冊快捷鍵；產品 registry 仍是條件、handler 與執行結果的唯一權威。
class KlpCommandKeymap<C> {

	/* registry 僅借用公開執行权威；platform／timeout 為不可變選項；_clock／_lastTime 驗證單調性。 */
	final KlpCommandRegistry<C> registry;
	final KlpShortcutPlatform platform;
	final int chordTimeoutMs;
	final double Function() _clock;
	double _lastTime = 0;
	/* _bindings 以物件識別 owner；_overrides 只擁有使用者設定；_closed 不影響產品 registry。 */
	final Map<String, KlpShortcutBinding<C>> _bindings = {};
	Map<String, List<KlpShortcutStroke>?> _overrides = {};
	bool _closed = false;
	/* _pending／_pendingFocus／_started 擁有一步 chord；_recordOwner／_recorded 擁有 explicit 錄製 session。 */
	List<KlpShortcutStroke> _pending = const [];
	KlpShortcutFocus? _pendingFocus;
	double _started = 0;
	String? _recordOwner;
	List<KlpShortcutStroke> _recorded = const [];

	KlpCommandKeymap({
		required this.registry,
		this.platform = KlpShortcutPlatform.other,
		this.chordTimeoutMs = 1000,
		double Function()? now,
	}) : _clock = now ?? _monotonicClock() {
		if (chordTimeoutMs < 1 || chordTimeoutMs > 600000) throw ArgumentError.value(chordTimeoutMs, 'chordTimeoutMs');
	}

	bool get isDisposed => _closed;
	bool get isRecording => _recordOwner != null;
	List<KlpShortcutStroke> get pendingSequence => _pending;
	List<KlpShortcutStroke> get recordedSequence => _recorded;

	VoidCallback register(KlpShortcutBinding<C> binding) {
		_requireOpen();
		final copy = _copyBinding(binding);
		if (_bindings.containsKey(copy.id)) throw StateError('Duplicate binding: ${copy.id}');
		_bindings[copy.id] = copy;
		cancelChord();
		return () {
			if (!identical(_bindings[copy.id], copy)) return;

			_bindings.remove(copy.id);
			_overrides.remove(copy.id);
			cancelChord();
		};
	}

	KlpShortcutHandling handle(KlpShortcutInput input, KlpShortcutFocus focus, C context) {
		if (_closed) return _handling(KlpShortcutHandlingState.ignored);

		// 步驟一：先驗證焦點與 clock，非法資料不部分更新 session。
		_validateFocus(focus);
		final time = _readTime();
		_expireAt(time);
		if (_pendingFocus != null && !_sameFocus(_pendingFocus!, focus)) cancelChord();
		if (_recordOwner != null && _recordOwner != focus.focusId) {
			cancelRecording();
			return _handling(KlpShortcutHandlingState.ignored);
		}
		if (input.composing) {
			cancelChord();
			return _handling(KlpShortcutHandlingState.ignored);
		}
		if (!_canonical(input.key)) return _handling(KlpShortcutHandlingState.ignored);

		// 步驟二：explicit 錄製不接命令；未完成 chord 可用無 modifier Escape 取消。
		final actual = _project(input, platform);
		if (isRecording) return _record(actual, input.repeat);

		if (_pending.isNotEmpty && _plainEscape(actual)) {
			cancelChord();
			return _handling(KlpShortcutHandlingState.cancelled);
		}

		// 步驟三：每次查詢同 registry；續鍵失配只重新解析一次。
		final candidates = _active(focus, context, input.repeat);
		var sequence = [..._pending, actual];
		var selected = _select(candidates, sequence);
		if (selected == null && _pending.isNotEmpty) {
			cancelChord();
			sequence = [actual];
			selected = _select(candidates, sequence);
		}
		if (selected == null) return _handling(KlpShortcutHandlingState.ignored);

		final binding = selected.binding;
		if (selected.sequence.length > sequence.length) {
			_pending = List.unmodifiable(sequence);
			_pendingFocus = focus;
			_started = time;
			return KlpShortcutHandling._(handled: true, state: KlpShortcutHandlingState.prefix, bindingId: binding.id, commandId: binding.commandId);
		}
		cancelChord();
		return KlpShortcutHandling._(
			handled: true,
			state: KlpShortcutHandlingState.executed,
			bindingId: binding.id,
			commandId: binding.commandId,
			execution: registry.execute(binding.commandId, context),
		);
	}

	bool cancelChord() {
		final had = _pending.isNotEmpty;
		_pending = const [];
		_pendingFocus = null;
		return had;
	}

	bool expireChord() {
		if (_closed || _pending.isEmpty) return false;

		return _expireAt(_readTime());
	}

	List<KlpShortcutConflict> conflicts(KlpShortcutFocus focus, C context) {
		if (_closed) return const [];

		_validateFocus(focus);
		final candidates = _active(focus, context, false);
		final result = <KlpShortcutConflict>[];
		for (var first = 0; first < candidates.length; first++) {
			for (var second = first + 1; second < candidates.length; second++) {
				final a = candidates[first];
				final b = candidates[second];
				if (a.binding.scope != b.binding.scope || a.binding.scopeId != b.binding.scopeId) continue;

				final short = a.sequence.length <= b.sequence.length ? a.sequence : b.sequence;
				final long = a.sequence.length <= b.sequence.length ? b.sequence : a.sequence;
				if (!_matches(long, short, platform)) continue;

				final kind = short.length == long.length ? KlpShortcutConflictKind.exact : KlpShortcutConflictKind.prefix;
				final ids = [a.binding.id, b.binding.id]..sort();
				result.add(KlpShortcutConflict._(kind, ids, a.binding.id));
			}
		}
		result.sort(_compareConflicts);
		return List.unmodifiable(result);
	}

	void setOverride(String id, List<KlpShortcutStroke>? sequence) {
		_requireBinding(id);
		final copy = sequence == null ? null : _copySequence(sequence);
		_overrides[id] = copy;
		cancelChord();
	}

	void restore(String id) {
		_requireBinding(id);
		_overrides.remove(id);
		cancelChord();
	}

	Map<String, Object?> exportOverrides() {
		// wire DTO 完全隔離巢狀資料，caller 可序列化但不能改內部設定。
		final bindings = <String, Object?>{};
		for (final entry in _overrides.entries) {
			bindings[entry.key] = entry.value?.map(_strokeData).toList();
		}
		return {
			/* schemaVersion：唯一 wire 版本；bindings：ID 對應使用者覆寫或停用。 */
			'schemaVersion': 1,
			'bindings': bindings,
		};
	}

	void importOverrides(Object? value) {
		_requireOpen();
		final source = _object(value);
		_fields(source, ['schemaVersion', 'bindings']);
		if (source['schemaVersion'] is! int || source['schemaVersion'] != 1) throw ArgumentError('Invalid override version');
		final bindings = _object(source['bindings']);
		final replacement = <String, List<KlpShortcutStroke>?>{};
		for (final entry in bindings.entries) {
			_requireBinding(entry.key);
			final sequence = entry.value;
			if (sequence == null) {
				replacement[entry.key] = null;
				continue;
			}
			if (sequence is! List) throw ArgumentError('Invalid sequence');
			final strokes = sequence.map(_readStroke).toList();
			replacement[entry.key] = _copySequence(strokes);
		}

		// 所有 nested 資料有效後才替換，失敗不清現有 chord 或覆寫。
		_overrides = replacement;
		cancelChord();
	}

	void beginRecording(String focusId) {
		_requireOpen();
		_text(focusId, 'focusId');
		cancelChord();
		_recordOwner = focusId;
		_recorded = const [];
	}

	List<KlpShortcutStroke> finishRecording() {
		_recordOwner = null;
		return _recorded;
	}

	void cancelRecording() {
		_recordOwner = null;
		_recorded = const [];
	}

	void dispose() {
		if (_closed) return;

		_closed = true;
		_bindings.clear();
		_overrides.clear();
		cancelChord();
		cancelRecording();
	}

	void _requireOpen() {
		if (_closed) throw StateError('Keymap is disposed');
	}

	void _requireBinding(String id) {
		_requireOpen();
		if (!_bindings.containsKey(id)) throw ArgumentError.value(id, 'id', 'Unknown binding');
	}

	double _readTime() {
		final value = _clock();
		if (!value.isFinite || value < _lastTime || value < 0) throw ArgumentError('Clock must be finite nonnegative and monotonic');
		_lastTime = value;
		return value;
	}

	bool _expireAt(double time) {
		if (_pending.isNotEmpty && time - _started >= chordTimeoutMs) return cancelChord();

		return false;
	}

	KlpShortcutHandling _record(KlpShortcutStroke stroke, bool repeat) {
		if (_plainEscape(stroke)) {
			cancelRecording();
			return _handling(KlpShortcutHandlingState.cancelled);
		}
		if (repeat || _recorded.length == 4) return _handling(KlpShortcutHandlingState.ignored);

		_recorded = List.unmodifiable([..._recorded, stroke]);
		return _handling(KlpShortcutHandlingState.recording);
	}

	List<_Candidate<C>> _active(KlpShortcutFocus focus, C context, bool repeat) {
		if (registry.isDisposed) return [];

		final result = <_Candidate<C>>[];
		for (final binding in _bindings.values) {
			if (!_scopeActive(binding, focus)) continue;
			if (focus.editable && !binding.allowInEditable || repeat && !binding.allowRepeat) continue;

			final sequence = _overrides.containsKey(binding.id) ? _overrides[binding.id] : binding.sequence;
			if (sequence == null) continue;

			try {
				if (binding.when != null && !binding.when!(context)) continue;
			}
			catch (_) {
				continue;
			}
			final state = registry.getState(binding.commandId, context);
			if (state == null || !state.visible || !state.enabled || state.running) continue;

			result.add(_Candidate(binding, sequence));
		}
		result.sort(_compareCandidates);
		return result;
	}

	_Candidate<C>? _select(List<_Candidate<C>> candidates, List<KlpShortcutStroke> prefix) {
		for (final candidate in candidates) {
			if (_matches(candidate.sequence, prefix, platform)) return candidate;
		}
		return null;
	}
}

double Function() _monotonicClock() {
	// 每個 keymap 自有原生 Stopwatch，避免 wall clock 調整破壞 chord 期限。
	final clock = Stopwatch()..start();
	return () => clock.elapsedMicroseconds / 1000;
}

void _text(String value, String name) {
	if (value.trim().isEmpty) throw ArgumentError.value(value, name);
}

void _validateFocus(KlpShortcutFocus focus) {
	_text(focus.focusId, 'focusId');
	for (final id in [focus.pageId, focus.regionId, focus.componentId]) {
		if (id != null) _text(id, 'scopeId');
	}
}

bool _canonical(String key) {
	if (_namedKeys.contains(key) || RegExp(r'^f([1-9]|1[0-9]|2[0-4])$').hasMatch(key)) return true;

	final scalars = key.runes.toList();
	if (scalars.length != 1 || key.trim().isEmpty || key != key.toLowerCase()) return false;
	return scalars.single < 0xd800 || scalars.single > 0xdfff;
}

List<KlpShortcutStroke> _copySequence(List<KlpShortcutStroke> sequence) {
	if (sequence.isEmpty || sequence.length > 4) throw ArgumentError('Sequence must contain one to four strokes');
	final result = <KlpShortcutStroke>[];
	for (final stroke in sequence) {
		if (!_canonical(stroke.key)) throw ArgumentError.value(stroke.key, 'key');
		result.add(KlpShortcutStroke(key: stroke.key, primary: stroke.primary, ctrl: stroke.ctrl, alt: stroke.alt, shift: stroke.shift, meta: stroke.meta));
	}
	return List.unmodifiable(result);
}

KlpShortcutBinding<C> _copyBinding<C>(KlpShortcutBinding<C> binding) {
	_text(binding.id, 'id');
	_text(binding.commandId, 'commandId');
	if (binding.scope == KlpShortcutScope.app) {
		if (binding.scopeId != null && binding.scopeId!.isNotEmpty) throw ArgumentError('App scope cannot have scopeId');
	}
	else {
		if (binding.scopeId == null) throw ArgumentError('scopeId is required');
		_text(binding.scopeId!, 'scopeId');
	}
	return KlpShortcutBinding<C>(
		id: binding.id,
		commandId: binding.commandId,
		sequence: _copySequence(binding.sequence),
		scope: binding.scope,
		scopeId: binding.scopeId == '' ? null : binding.scopeId,
		priority: binding.priority,
		allowRepeat: binding.allowRepeat,
		allowInEditable: binding.allowInEditable,
		when: binding.when,
	);
}

Map<String, Object?> _object(Object? value) {
	if (value is! Map || value.keys.any((key) => key is! String)) throw ArgumentError('Expected string-key object');
	return Map<String, Object?>.from(value);
}

void _fields(Map<String, Object?> source, List<String> allowed) {
	if (source.keys.any((key) => !allowed.contains(key))) throw ArgumentError('Unknown override field');
}

bool _flag(Map<String, Object?> source, String name) {
	if (!source.containsKey(name)) return false;

	final value = source[name];
	if (value is! bool) throw ArgumentError.value(value, name);
	return value;
}

KlpShortcutStroke _readStroke(Object? value) {
	final source = _object(value);
	_fields(source, ['key', ..._modifierNames]);
	final key = source['key'];
	if (key is! String || !_canonical(key)) throw ArgumentError.value(key, 'key');
	return KlpShortcutStroke(
		key: key,
		primary: _flag(source, 'primary'),
		ctrl: _flag(source, 'ctrl'),
		alt: _flag(source, 'alt'),
		shift: _flag(source, 'shift'),
		meta: _flag(source, 'meta'),
	);
}

Map<String, Object?> _strokeData(KlpShortcutStroke stroke) {
	return {
		/* key 與五 modifier 是完整 wire shape，與註冊 metadata 分離。 */
		'key': stroke.key,
		'primary': stroke.primary,
		'ctrl': stroke.ctrl,
		'alt': stroke.alt,
		'shift': stroke.shift,
		'meta': stroke.meta,
	};
}

KlpShortcutStroke _project(KlpShortcutStroke stroke, KlpShortcutPlatform platform) {
	return KlpShortcutStroke(
		key: stroke.key,
		primary: false,
		ctrl: stroke.ctrl || stroke.primary && platform == KlpShortcutPlatform.other,
		alt: stroke.alt,
		shift: stroke.shift,
		meta: stroke.meta || stroke.primary && platform == KlpShortcutPlatform.mac,
	);
}

bool _sameStroke(KlpShortcutStroke a, KlpShortcutStroke b) {
	return a.key == b.key && a.primary == b.primary && a.ctrl == b.ctrl && a.alt == b.alt && a.shift == b.shift && a.meta == b.meta;
}

bool _matches(List<KlpShortcutStroke> sequence, List<KlpShortcutStroke> prefix, KlpShortcutPlatform platform) {
	if (sequence.length < prefix.length) return false;

	for (var index = 0; index < prefix.length; index++) {
		if (!_sameStroke(_project(sequence[index], platform), _project(prefix[index], platform))) return false;
	}
	return true;
}

bool _sameFocus(KlpShortcutFocus a, KlpShortcutFocus b) {
	return a.focusId == b.focusId && a.pageId == b.pageId && a.regionId == b.regionId && a.componentId == b.componentId && a.editable == b.editable;
}

bool _scopeActive<C>(KlpShortcutBinding<C> binding, KlpShortcutFocus focus) {
	switch (binding.scope) {
		case KlpShortcutScope.app: return true;
		case KlpShortcutScope.page: return binding.scopeId == focus.pageId;
		case KlpShortcutScope.region: return binding.scopeId == focus.regionId;
		case KlpShortcutScope.component: return binding.scopeId == focus.componentId;
	}
}

int _compareCandidates<C>(_Candidate<C> a, _Candidate<C> b) {
	final scope = b.binding.scope.index.compareTo(a.binding.scope.index);
	if (scope != 0) return scope;

	final priority = b.binding.priority.compareTo(a.binding.priority);
	if (priority != 0) return priority;

	return a.binding.id.compareTo(b.binding.id);
}

int _compareConflicts(KlpShortcutConflict a, KlpShortcutConflict b) {
	final first = a.bindingIds[0].compareTo(b.bindingIds[0]);
	return first != 0 ? first : a.bindingIds[1].compareTo(b.bindingIds[1]);
}

bool _plainEscape(KlpShortcutStroke stroke) {
	return stroke.key == 'escape' && !stroke.primary && !stroke.ctrl && !stroke.alt && !stroke.shift && !stroke.meta;
}

KlpShortcutHandling _handling(KlpShortcutHandlingState state) {
	return KlpShortcutHandling._(handled: state != KlpShortcutHandlingState.ignored, state: state);
}
