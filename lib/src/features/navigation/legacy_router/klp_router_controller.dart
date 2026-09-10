part of 'klp_router.dart';

/// 目的地登記簿與切換器，只負責產品路由分發機制。
class KlpRouter extends ChangeNotifier {
	KlpRouter({required List<KlpRoute> routes, required String initialId})
			: _routes = {for (final route in routes) route.id: route} {
		if (routes.length != _routes.length) {
			throw ArgumentError('routes 有重複的 id：${_duplicateIds(routes).join('、')}');
		}
		if (!_routes.containsKey(initialId)) {
			throw KlpRouteNotFound(initialId, _routes.keys);
		}
		_history = [initialId];
	}

	final Map<String, KlpRoute> _routes;
	late List<String> _history;

	static Iterable<String> _duplicateIds(List<KlpRoute> routes) {
		final seen = <String>{};
		return routes.map((route) => route.id).where((id) => !seen.add(id)).toSet();
	}

	KlpRoute get current => _routes[_history.last]!;
	String get currentId => _history.last;
	Iterable<String> get ids => _routes.keys;
	Iterable<KlpRoute> get routes => _routes.values;
	bool contains(String id) => _routes.containsKey(id);
	KlpRoute? find(String id) => _routes[id];
	bool get canGoBack => _history.length > 1;

	void go(String id) {
		if (!_routes.containsKey(id)) throw KlpRouteNotFound(id, _routes.keys);
		if (id == currentId) return;
		_history.add(id);
		notifyListeners();
	}

	bool goBack() {
		if (!canGoBack) return false;
		_history.removeLast();
		notifyListeners();
		return true;
	}

	void reset(String id) {
		if (!_routes.containsKey(id)) throw KlpRouteNotFound(id, _routes.keys);
		_history = [id];
		notifyListeners();
	}

	void register(KlpRoute route) {
		if (_routes.containsKey(route.id)) {
			throw ArgumentError('id "${route.id}" 已經註冊過。要換掉請先 unregister。');
		}
		_routes[route.id] = route;
		notifyListeners();
	}

	void unregister(String id) {
		if (!_routes.containsKey(id)) throw KlpRouteNotFound(id, _routes.keys);
		if (_history.contains(id)) {
			throw StateError('id "$id" 仍在歷史中，移除後 goBack 會落到不存在的目的地。');
		}
		_routes.remove(id);
		notifyListeners();
	}
}
