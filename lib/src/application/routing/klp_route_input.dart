part of '../structure/klp_application.dart';

/// 本庫依目前放置建立的借用輸入，外部不能自行建構或替換操作接線。
final class KlpRouteInput<P, R> {
  final P parameters;
  final _KlpRouteActions _actions;

  const KlpRouteInput._(this.parameters, this._actions);

  /// 建立受目前 entry 綁定的導覽宣告；只有安裝後的本庫 handler 能派送它。
  KlpAction navigate<T>(
    KlpLocation<T> location, {
    void Function(T value)? onResult,
  }) => _KlpPushAction<T>(_actions, location, onResult);

  /// 建立目前 route 的完成宣告；結果型別維持 route 宣告的 R。
  KlpAction finish(R result) => _KlpFinishAction(_actions, result);

  /// 建立目前 route 的返回宣告；根畫面會由導覽核心拒絕。
  KlpAction back() => _KlpBackAction(_actions);
}

abstract interface class _KlpRouteAction implements KlpAction {
  Future<KlpActionActivation> activate(_KlpApplicationActionHandler handler);
}

final class _KlpPushAction<T> implements _KlpRouteAction {
  final _KlpRouteActions actions;
  final KlpLocation<T> location;
  final void Function(T value)? onResult;

  const _KlpPushAction(this.actions, this.location, this.onResult);

  @override
  Future<KlpActionActivation> activate(_KlpApplicationActionHandler handler) =>
      handler.push(this);
}

final class _KlpFinishAction implements _KlpRouteAction {
  final _KlpRouteActions actions;
  final Object? result;

  const _KlpFinishAction(this.actions, this.result);

  @override
  Future<KlpActionActivation> activate(_KlpApplicationActionHandler handler) =>
      handler.finish(this);
}

final class _KlpBackAction implements _KlpRouteAction {
  final _KlpRouteActions actions;

  const _KlpBackAction(this.actions);

  @override
  Future<KlpActionActivation> activate(_KlpApplicationActionHandler handler) =>
      handler.back(this);
}

/// 應用 session 持有 entry 與操作期限；此接點不對消費端公開。
abstract interface class _KlpRouteActions {
  KlpNavigationTicket<T> push<T>(KlpLocation<T> location);
  Future<KlpNavigationDecision> complete(Object? result);
  Future<KlpNavigationDecision> cancel();
}
