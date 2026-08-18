import 'package:flutter/widgets.dart';

/// 一個可被切換到的目的地。
///
/// Kallopis **不知道**有哪些目的地存在，也不解讀 [data]——目的地是產品的決定，
/// 這裡只保存產品給的東西並在切換時把它交還。
@immutable
class KlpRoute {
  const KlpRoute({required this.id, required this.builder, this.data});

  /// 產品自訂的識別字串。庫不規定格式，也不預設任何值。
  final String id;

  final WidgetBuilder builder;

  /// 產品要附掛的任意資料（顯示名稱、圖示、權限旗標……）。
  ///
  /// 型別是 `Object?` 而不是某個具名結構，因為一旦庫定義了「路由該有標題和圖示」，
  /// 它就開始替產品決定導覽長什麼樣——那屬於產品外殼，不屬於視覺層。
  final Object? data;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KlpRoute &&
          id == other.id &&
          builder == other.builder &&
          data == other.data;

  @override
  int get hashCode => Object.hash(id, builder, data);
}

/// 找不到目的地時拋出。
///
/// 刻意拋錯而不是回退到某個預設頁：切換到不存在的目的地是**程式錯誤**，
/// 靜默停在原地會讓它一路活到使用者手上，而且沒有任何徵兆。
class KlpRouteNotFound extends Error {
  KlpRouteNotFound(this.id, this.known);

  final String id;
  final Iterable<String> known;

  @override
  String toString() =>
      'KlpRouteNotFound: 沒有註冊 id 為 "$id" 的目的地。'
      '已註冊的有：${known.isEmpty ? '（無）' : known.join('、')}';
}

/// 目的地的登記簿與切換器。**只負責分發。**
///
/// 它不知道有哪些頁、不預設入口、不決定階層、不解析網址、不做深層連結——
/// 那些都是產品外殼的決定，屬於 Kallopis 的拒絕清單。這裡提供的是**機制**：
/// 產品註冊自己的目的地，然後要求切換。
///
/// ```dart
/// final router = KlpRouter(
///   routes: [
///     KlpRoute(id: 'notes', builder: (_) => const NotesPage()),
///     KlpRoute(id: 'search', builder: (_) => const SearchPage()),
///   ],
///   initialId: 'notes',
/// );
///
/// KlpRouterScope(
///   router: router,
///   child: const KlpRouterOutlet(),
/// )
/// ```
class KlpRouter extends ChangeNotifier {
  /// [initialId] 必填且必須已註冊——沒有「未定義的目前位置」這種狀態。
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
    return routes.map((r) => r.id).where((id) => !seen.add(id)).toSet();
  }

  /// 目前所在的目的地。永遠有值。
  KlpRoute get current => _routes[_history.last]!;

  String get currentId => _history.last;

  /// 已註冊的 id，依註冊順序。產品要畫導覽列時讀這個。
  Iterable<String> get ids => _routes.keys;

  Iterable<KlpRoute> get routes => _routes.values;

  bool contains(String id) => _routes.containsKey(id);

  KlpRoute? find(String id) => _routes[id];

  /// 回上一步是否可行。
  bool get canGoBack => _history.length > 1;

  /// 切換到 [id]。未註冊時拋 [KlpRouteNotFound]。
  ///
  /// 切到目前所在的目的地是 no-op，不會在歷史裡堆出重複項。
  void go(String id) {
    if (!_routes.containsKey(id)) throw KlpRouteNotFound(id, _routes.keys);
    if (id == currentId) return;
    _history.add(id);
    notifyListeners();
  }

  /// 回上一步。已在起點時是 no-op，回傳 `false` 讓呼叫端知道沒有動。
  bool goBack() {
    if (!canGoBack) return false;
    _history.removeLast();
    notifyListeners();
    return true;
  }

  /// 切換並清空歷史。用於「回到起點」這類語意。
  void reset(String id) {
    if (!_routes.containsKey(id)) throw KlpRouteNotFound(id, _routes.keys);
    _history = [id];
    notifyListeners();
  }

  /// 動態註冊。**已存在的 id 會拋錯而不是覆蓋**——覆蓋是靜默的行為改變。
  void register(KlpRoute route) {
    if (_routes.containsKey(route.id)) {
      throw ArgumentError('id "${route.id}" 已經註冊過。要換掉請先 unregister。');
    }
    _routes[route.id] = route;
    notifyListeners();
  }

  /// 移除註冊。不能移除目前所在或仍在歷史中的目的地。
  void unregister(String id) {
    if (!_routes.containsKey(id)) throw KlpRouteNotFound(id, _routes.keys);
    if (_history.contains(id)) {
      throw StateError('id "$id" 仍在歷史中，移除後 goBack 會落到不存在的目的地。');
    }
    _routes.remove(id);
    notifyListeners();
  }
}

/// 把 [KlpRouter] 供給子樹。
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

  /// 沒有 scope 時回傳 `null` 而不是拋錯，供「有 router 才顯示」的場合使用。
  static KlpRouter? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<KlpRouterScope>()?.notifier;
}

/// 渲染目前的目的地。
///
/// 它只做一件事：呼叫 `router.current.builder`。**不做轉場動畫**——轉場屬於產品外殼
/// 的決定（有些頁該滑入，有些該直接換），庫替它決定就等於替所有產品決定。
class KlpRouterOutlet extends StatelessWidget {
  const KlpRouterOutlet({super.key});

  @override
  Widget build(BuildContext context) =>
      KlpRouterScope.of(context).current.builder(context);
}

extension KlpRouterContext on BuildContext {
  KlpRouter get klpRouter => KlpRouterScope.of(this);
}
