part of '../structure/klp_application.dart';

/// 畫面映射只取得型別化資料與受控操作，不取得渲染上下文或風格權限。
final class KlpRoute<P, R> {

	final KlpDestination<P, R> destination;
	final KlpScreen Function(KlpRouteInput<P, R>) _screen;
	final FutureOr<bool> Function(KlpNavigationTransition)? _beforeEnter;
	final FutureOr<bool> Function(KlpNavigationTransition)? _beforeLeave;

	KlpRoute(KlpDestination<P, R> destination, {
		required KlpScreen Function(KlpRouteInput<P, R>) screen,
		FutureOr<bool> Function(KlpNavigationTransition)? beforeEnter,
		FutureOr<bool> Function(KlpNavigationTransition)? beforeLeave,
	}) : this._(destination, screen, beforeEnter, beforeLeave);

	KlpRoute._(this.destination, this._screen, this._beforeEnter, this._beforeLeave);

	KlpRoutePolicy get _policy => KlpRoutePolicy(destination: destination, beforeEnter: _beforeEnter, beforeLeave: _beforeLeave);

	KlpScreen _project(KlpNavigationEntry entry, _KlpRouteActions actions) {
		if (!identical(entry.location.destination, destination)) throw ArgumentError('Route destination identity mismatch.');
		final parameters = entry.location.parameters;
		if (!destination.acceptsParameters(parameters)) throw ArgumentError('Invalid route parameters.');
		// 以原始 P／R 派送，不將窄型別投影函式強制轉為廣型別。
		return _screen(KlpRouteInput<P, R>._(parameters as P, actions));
	}
}
