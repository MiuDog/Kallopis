part of 'klp_data_state.dart';

/// 資料操作失敗，保留原始錯誤與堆疊供消費端處理。
final class KlpDataFailure<T> extends KlpDataState<T> {
  final Object error;
  final StackTrace stackTrace;

  const KlpDataFailure(this.error, this.stackTrace);
}
