import '../state/klp_state.dart';

/// 控制器僅借用狀態來源，不快取值，也不替來源擁有者釋放資源。
///
/// 同時只允許一個附接；解除後可重新附接，釋放後不可再使用。
final class KlpStateController<T> {

	KlpState<T>? _state;
	bool _isDisposed = false;

	bool get isDisposed => _isDisposed;
	bool get isAttached => _state != null;

	KlpState<T> get state {
		_requireActive();
		final current = _state;
		if (current == null) {
			throw StateError('Controller is not attached.');
		}

		return current;
	}

	void attach(KlpState<T> source) {
		_requireActive();
		if (_state != null) {
			throw StateError('Controller is already attached.');
		}

		_state = source;
	}

	void detach() {
		_requireActive();
		if (_state == null) {
			throw StateError('Controller is not attached.');
		}

		_state = null;
	}

	void dispose() {
		if (_isDisposed) return;

		_state = null;
		_isDisposed = true;
	}

	void _requireActive() {
		if (_isDisposed) {
			throw StateError('Controller has been disposed.');
		}
	}
}
