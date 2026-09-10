part of 'klp_router.dart';

/// 將通用路由分發器注入子樹。
class KlpRouterScope extends InheritedNotifier<KlpRouter> {
  const KlpRouterScope({
    super.key,
    required KlpRouter router,
    required super.child,
  }) : super(notifier: router);

  static KlpRouter of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<KlpRouterScope>();
    if (scope?.notifier == null) {
      throw StateError(
        '這個 context 之上沒有 KlpRouterScope。'
        'Kallopis 不提供預設 router——目的地是產品的決定，庫沒有可以猜的預設值。',
      );
    }
    return scope!.notifier!;
  }

  static KlpRouter? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<KlpRouterScope>()?.notifier;
}
