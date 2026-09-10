import 'dart:collection';

import 'klp_state.dart';
import 'klp_subscription.dart';

/// 擁有者保留此物件，借用端只能取得 [readOnly]。
///
/// 值應採不可變資料；相等值不通知。通知內的更新依序排入佇列，
/// 新訂閱從下一次通知開始，取消的訂閱不再收到尚未派送的通知。
final class KlpMutableState<T> {
  T _value;
  bool _isDisposed = false;
  bool _isNotifying = false;
  final _listeners = <KlpSubscription, void Function(T)>{};
  final _pending = Queue<T>();
  late final KlpState<T> readOnly = _ReadOnlyState<T>(this);

  KlpMutableState(T value) : _value = value;

  bool get isDisposed => _isDisposed;

  T get value {
    _requireActive();
    return _value;
  }

  set value(T next) {
    _requireActive();
    if (_value == next) return;

    _value = next;
    _pending.add(next);
    _drain();
  }

  void dispose() {
    if (_isDisposed) return;

    _isDisposed = true;
    _pending.clear();
    for (final subscription in _listeners.keys.toList()) {
      subscription.cancel();
    }
  }

  KlpSubscription _subscribe(void Function(T) listener) {
    _requireActive();
    late final KlpSubscription subscription;
    subscription = KlpSubscription(() => _listeners.remove(subscription));
    _listeners[subscription] = listener;
    return subscription;
  }

  void _drain() {
    if (_isNotifying) return;

    // 使用快照與有效性檢查，允許通知途中新增、取消及釋放。
    _isNotifying = true;
    Object? firstError;
    StackTrace? firstStack;
    try {
      while (_pending.isNotEmpty && !_isDisposed) {
        final next = _pending.removeFirst();
        final listeners = _listeners.entries.toList();
        for (final entry in listeners) {
          if (entry.key.isCancelled) continue;

          try {
            entry.value(next);
          } catch (error, stack) {
            firstError ??= error;
            firstStack ??= stack;
          }
        }
      }
    } finally {
      _isNotifying = false;
    }

    // 先完成其他訂閱派送，再把首個錯誤交回更新者。
    if (firstError != null) {
      Error.throwWithStackTrace(firstError, firstStack!);
    }
  }

  void _requireActive() {
    if (_isDisposed) {
      throw StateError('State has been disposed.');
    }
  }
}

final class _ReadOnlyState<T> implements KlpState<T> {
  final KlpMutableState<T> _owner;

  _ReadOnlyState(this._owner);

  @override
  T get value => _owner.value;

  @override
  KlpSubscription subscribe(void Function(T) listener) =>
      _owner._subscribe(listener);
}
