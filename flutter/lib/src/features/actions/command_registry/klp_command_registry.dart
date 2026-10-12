import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../foundation/klp_icon_data.dart';

/// 產品擁有的命令定義；註冊時隔離 metadata，context 與業務仍由產品擁有。
class KlpCommandDefinition<C> {
	const KlpCommandDefinition({
		required this.id,
		required this.label,
		required this.handler,
		this.description,
		this.category,
		this.keywords = const [],
		this.icon,
		this.isVisible,
		this.isEnabled,
		this.isChecked,
	});

	/* id 保留識別；label 為呈現名稱；description/category/keywords 供查詢入口；icon 保持原生引用。 */
	final String id;
	final String label;
	final String? description;
	final String? category;
	final List<String> keywords;
	final KlpIconData? icon;
	/* handler 擁有產品業務；三個 predicate 只讀本次 context，不建立第二份產品狀態。 */
	final FutureOr<Object?> Function(C context) handler;
	final bool Function(C context)? isVisible;
	final bool Function(C context)? isEnabled;
	final bool Function(C context)? isChecked;
}

@immutable
class KlpCommandConditionError {
	const KlpCommandConditionError._(this.error);
	/* error 保留原錯誤；nullable 記錄的存在與否代表條件是否失敗。 */
	final Object error;
}

@immutable
class KlpCommandState {
	const KlpCommandState._({
		required this.id,
		required this.label,
		required this.description,
		required this.category,
		required this.keywords,
		required this.icon,
		required this.visible,
		required this.enabled,
		required this.checked,
		required this.running,
		required this.conditionError,
	});

	/* id/label/description/category/keywords 是隔離的呈現資料；icon 保留產品參照。 */
	final String id;
	final String label;
	final String? description;
	final String? category;
	final List<String> keywords;
	final KlpIconData? icon;
	/* visible/enabled/checked 為最新條件；running 屬於註冊 token；conditionError 保留原診斷。 */
	final bool visible;
	final bool enabled;
	final bool checked;
	final bool running;
	final KlpCommandConditionError? conditionError;
}

enum KlpCommandExecutionStatus { executed, missing, hidden, disabled, busy, disposed, error }
enum KlpCommandErrorPhase { condition, handler }

@immutable
class KlpCommandExecutionResult {
	const KlpCommandExecutionResult._({
		required this.commandId,
		required this.status,
		this.value,
		this.error,
		this.phase,
	});

	/* commandId 保留目標；status 決定結果；value 不複製產品值；error/phase 保留失敗位置與原值。 */
	final String commandId;
	final KlpCommandExecutionStatus status;
	final Object? value;
	final Object? error;
	final KlpCommandErrorPhase? phase;
}

class _KlpCommandEntry<C> {
	_KlpCommandEntry(this.definition);
	/* definition 是註冊時複製的 metadata；running 只由此 owner 的執行生命週期維護。 */
	final KlpCommandDefinition<C> definition;
	bool running = false;
}

class _KlpCommandObserver {
	_KlpCommandObserver(this.listener, this.isNative) : relay = (() => listener());
	/* listener 是 caller callback；relay 的唯一 identity 可精確移除同 callback 的個別 owner。 */
	final VoidCallback listener;
	final VoidCallback relay;
	/* isNative 限制 removeListener 只解除原生 owner，subscribe 的 token 不受同 callback 影響。 */
	final bool isNative;
}

/// 集中命令狀態與執行入口，不擁有產品 context、持久化或業務副作用。
class KlpCommandRegistry<C> extends ChangeNotifier {
	/* _entries 以物件識別註冊 owner；_observers 記錄原生通知的唯一 relay。 */
	final Map<String, _KlpCommandEntry<C>> _entries = {};
	final Set<_KlpCommandObserver> _observers = {};
	/* _version 是公開失效序號；_closed 立即關閉語意；通知深度及兩個 native flag 安全收尾。 */
	int _version = 0;
	bool _closed = false;
	int _notificationDepth = 0;
	bool _nativeDisposePending = false;
	bool _nativeDisposed = false;

	int get version => _version;
	bool get isDisposed => _closed;

	VoidCallback register(KlpCommandDefinition<C> definition) {
		_requireOpen();
		final copy = _copyDefinition(definition);
		if (_entries.containsKey(copy.id)) throw ArgumentError.value(copy.id, 'id', 'Duplicate command');
		final entry = _KlpCommandEntry(copy);
		_entries[copy.id] = entry;
		_emit();
		return () {
			if (!_isCurrent(entry)) return;
			_entries.remove(copy.id);
			_emit();
		};
	}

	KlpCommandState? getState(String id, C context) {
		_requireText(id, 'id');
		final entry = _entries[id];
		return entry == null ? null : _snapshot(entry, context);
	}

	List<KlpCommandState> list(C context) {
		final ids = _entries.keys.toList()..sort();
		final states = <KlpCommandState>[];
		for (final id in ids) {
			final state = getState(id, context);
			if (state != null) states.add(state);
		}
		return List.unmodifiable(states);
	}

	Future<KlpCommandExecutionResult> execute(String id, C context) async {
		_requireText(id, 'id');
		if (_closed) return _outcome(id, KlpCommandExecutionStatus.disposed);
		final entry = _entries[id];
		if (entry == null) return _outcome(id, KlpCommandExecutionStatus.missing);
		final state = _snapshot(entry, context);
		if (_closed) return _outcome(id, KlpCommandExecutionStatus.disposed);
		if (!_isCurrent(entry)) return _outcome(id, KlpCommandExecutionStatus.missing);
		if (state.conditionError != null) return _failure(id, state.conditionError!.error, KlpCommandErrorPhase.condition);
		if (!state.visible) return _outcome(id, KlpCommandExecutionStatus.hidden);
		if (!state.enabled) return _outcome(id, KlpCommandExecutionStatus.disabled);
		if (entry.running) return _outcome(id, KlpCommandExecutionStatus.busy);
		entry.running = true;
		_emit();
		if (_closed) return _outcome(id, KlpCommandExecutionStatus.disposed);
		if (!_isCurrent(entry)) return _outcome(id, KlpCommandExecutionStatus.missing);
		try {
			final value = await entry.definition.handler(context);
			return KlpCommandExecutionResult._(commandId: id, status: KlpCommandExecutionStatus.executed, value: value);
		}
		catch (error) {
			return _failure(id, error, KlpCommandErrorPhase.handler);
		}
		finally {
			if (_isCurrent(entry)) {
				entry.running = false;
				_emit();
			}
		}
	}

	VoidCallback subscribe(VoidCallback listener) {
		final observer = _addObserver(listener, false);
		return () => _removeObserver(observer);
	}

	@override
	void addListener(VoidCallback listener) {
		_addObserver(listener, true);
	}

	@override
	void removeListener(VoidCallback listener) {
		for (final observer in _observers) {
			if (observer.isNative && identical(observer.listener, listener)) {
				_removeObserver(observer);
				return;
			}
		}
	}

	void refresh() {
		_requireOpen();
		_emit();
	}

	@override
	void notifyListeners() {
		if (_nativeDisposed) return;
		_notificationDepth++;
		try {
			super.notifyListeners();
		}
		finally {
			_notificationDepth--;
			if (_notificationDepth == 0 && _nativeDisposePending) {
				_nativeDisposePending = false;
				_nativeDisposed = true;
				super.dispose();
			}
		}
	}

	@override
	void dispose() {
		if (_closed) return;
		_closed = true;
		_entries.clear();
		try {
			_emit();
		}
		finally {
			// 先移除 relay，讓外層通知跳過舊 owner；原生資源只在其 notify 返回後清理。
			for (final observer in _observers.toList()) {
				_removeObserver(observer);
			}
			if (_notificationDepth == 0) {
				_nativeDisposed = true;
				super.dispose();
			}
			else {
				_nativeDisposePending = true;
			}
		}
	}

	void _requireOpen() {
		if (_closed) throw StateError('Command registry is disposed');
	}

	void _requireText(String value, String name) {
		if (value.trim().isEmpty) throw ArgumentError.value(value, name, 'Must contain non-whitespace text');
	}

	KlpCommandDefinition<C> _copyDefinition(KlpCommandDefinition<C> definition) {
		_requireText(definition.id, 'id');
		_requireText(definition.label, 'label');
		if (definition.description != null) _requireText(definition.description!, 'description');
		if (definition.category != null) _requireText(definition.category!, 'category');
		for (final keyword in definition.keywords) {
			_requireText(keyword, 'keyword');
		}
		return KlpCommandDefinition<C>(
			id: definition.id,
			label: definition.label,
			description: definition.description,
			category: definition.category,
			keywords: List.unmodifiable(definition.keywords),
			icon: definition.icon,
			handler: definition.handler,
			isVisible: definition.isVisible,
			isEnabled: definition.isEnabled,
			isChecked: definition.isChecked,
		);
	}

	KlpCommandState _snapshot(_KlpCommandEntry<C> entry, C context) {
		final definition = entry.definition;
		var visible = false;
		var enabled = false;
		var checked = false;
		KlpCommandConditionError? conditionError;
		try {
			visible = definition.isVisible?.call(context) ?? true;
			enabled = definition.isEnabled?.call(context) ?? true;
			checked = definition.isChecked?.call(context) ?? false;
		}
		catch (error) {
			visible = false;
			enabled = false;
			checked = false;
			conditionError = KlpCommandConditionError._(error);
		}
		return KlpCommandState._(
			id: definition.id,
			label: definition.label,
			description: definition.description,
			category: definition.category,
			keywords: definition.keywords,
			icon: definition.icon,
			visible: visible,
			enabled: enabled,
			checked: checked,
			running: entry.running,
			conditionError: conditionError,
		);
	}

	bool _isCurrent(_KlpCommandEntry<C> entry) => !_closed && identical(_entries[entry.definition.id], entry);

	KlpCommandExecutionResult _outcome(String id, KlpCommandExecutionStatus status) => KlpCommandExecutionResult._(commandId: id, status: status);
	KlpCommandExecutionResult _failure(String id, Object error, KlpCommandErrorPhase phase) => KlpCommandExecutionResult._(commandId: id, status: KlpCommandExecutionStatus.error, error: error, phase: phase);

	_KlpCommandObserver _addObserver(VoidCallback listener, bool isNative) {
		_requireOpen();
		final observer = _KlpCommandObserver(listener, isNative);
		_observers.add(observer);
		super.addListener(observer.relay);
		return observer;
	}

	void _removeObserver(_KlpCommandObserver observer) {
		if (_observers.remove(observer)) super.removeListener(observer.relay);
	}

	void _emit() {
		_version++;
		notifyListeners();
	}
}
