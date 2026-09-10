import 'klp_subscription.dart';

/// 借用端只讀取及訂閱資料，不取得更新與釋放權。
///
/// 訂閱不立即回放目前值；呼叫端可透過 [value] 讀取。
abstract interface class KlpState<T> {
  T get value;

  KlpSubscription subscribe(void Function(T value) listener);
}
