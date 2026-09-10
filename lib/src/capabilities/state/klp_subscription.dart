/// 可重複取消的訂閱；取消只移除監聽，不釋放資料來源。
final class KlpSubscription {
  void Function()? _onCancel;

  KlpSubscription(void Function() onCancel) : _onCancel = onCancel;

  bool get isCancelled => _onCancel == null;

  void cancel() {
    final callback = _onCancel;
    _onCancel = null;
    callback?.call();
  }
}
