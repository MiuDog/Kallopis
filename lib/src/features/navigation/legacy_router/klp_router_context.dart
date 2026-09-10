part of 'klp_router.dart';

/// 從目前 widget context 讀取通用路由分發器。
extension KlpRouterContext on BuildContext {
	KlpRouter get klpRouter => KlpRouterScope.of(this);
}
