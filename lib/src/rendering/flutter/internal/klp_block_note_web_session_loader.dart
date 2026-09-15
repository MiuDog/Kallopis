import 'dart:async';

/// 管理首次 Web editor 開啟；成功後不允許重送初始文件。
final class KlpBlockNoteWebSessionLoader {

	final Future<void> Function() _attempt;
	final void Function(Object error, StackTrace stackTrace) onFailure;
	final bool Function()? canOpen;
	Object? _error;
	bool _opened = false;
	Future<void>? _active;

	KlpBlockNoteWebSessionLoader(this._attempt, {required this.onFailure, this.canOpen});

	Object? get error => _error;
	bool get opening => _active != null;
	bool get canRetry => !_opened && !opening && _error != null && (canOpen?.call() ?? true);

	/// 上游開啟成功後立即固定；後續通知失敗不能重播初始文件。
	void markOpened() => _opened = true;

	Future<void> open() {
		if (_opened || !(canOpen?.call() ?? true)) return Future<void>.value();
		final active = _active;
		if (active != null) return active;
		final future = _run();
		_active = future;
		return future.whenComplete(() {
			if (identical(_active, future)) _active = null;
		});
	}

	Future<void> retry() {
		final active = _active;
		if (active != null) return active;
		if (!canRetry) return Future<void>.value();
		return open();
	}

	void reportFailure(Object error) {
		_error = error;
	}

	Future<void> _run() async {
		_error = null;
		try {
			await _attempt();
			_opened = true;
		}
		catch (error, stackTrace) {
			_error = error;
			onFailure(error, stackTrace);
		}
	}
}
