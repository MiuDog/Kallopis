part of 'klp_data_state.dart';

/// 正在等待目前有效請求，不攜帶先前資料。
final class KlpDataLoading<T> extends KlpDataState<T> {
  const KlpDataLoading();
}
