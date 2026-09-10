import 'dart:async';

import 'klp_destination.dart';
import 'klp_navigation_transition.dart';

/// 非視覺路由政策；畫面宣告由 application 綁定。
final class KlpRoutePolicy {

	final KlpDestination<Object?, Object?> destination;
	final FutureOr<bool> Function(KlpNavigationTransition)? beforeEnter;
	final FutureOr<bool> Function(KlpNavigationTransition)? beforeLeave;

	const KlpRoutePolicy({required this.destination, this.beforeEnter, this.beforeLeave});
}
