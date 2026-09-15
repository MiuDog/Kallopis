import 'dart:async';

import 'klp_placement_id.dart';

/// 規範化樹狀命名空間與型別安全識別碼。
///
/// 內部維護樹狀節點與享元快取（Flyweight Pattern）：
/// - 同一路徑節點在全域保證唯一實例，多處建立相同識別時自動查詢既有節點，避免重複配置。
/// - 嚴格禁止外部隨意使用純字串注入 ID，支援透過 `child()`、`of()`、`from()` 或 `/` 運算子建構。
/// - 提供完整樹狀導覽能力（`parent`、`children`、`root`、`ancestors`）。
final class KlpId {
  /// 當前節點段名稱。
  final String name;

  /// 父節點引用（若為根節點則為 null）。
  final KlpId? parent;

  /// 子節點快取樹：以子名稱為鍵，保證同路徑子實例唯一性。
  final Map<String, KlpId> _children = {};

  /// 完整路徑清單（自根至當前節點）。
  late final List<String> segments = parent == null
      ? List.unmodifiable([name])
      : List.unmodifiable([...parent!.segments, name]);

  /// 點分隔之完整限定字串（例如 `planist.workspace.sidebar`）。
  late final String value = segments.join('.');

  /// 全域根節點快取表。
  static final Map<String, KlpId> _roots = {};

  /// 讀取目前宣告期 Zone 注入的識別範圍；未進入 Scope 時回傳 null。
  static KlpId? get current => Zone.current[#kallopisKlpId] as KlpId?;

  /// 由目前宣告期 Scope 建立子節點；缺少 Scope 時建立根節點。
  static KlpId leaf(String name) => current?.child(name) ?? KlpId.root(name);

  /// 私有建構子：保證節點只能透過樹狀架構或工廠函式生成。
  KlpId._(this.name, [this.parent]) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(
        name,
        'name',
        'KlpId segment cannot be empty or whitespace.',
      );
    }
  }

  /// 建立或自樹狀快取中取得根命名空間識別碼。
  ///
  /// 若該根節點已存在，直接回傳既有唯一實例。
  factory KlpId.root(String namespace) {
    final key = namespace.trim();
    if (key.isEmpty) {
      throw ArgumentError.value(
        namespace,
        'namespace',
        'Root namespace cannot be empty or whitespace.',
      );
    }
    return _roots.putIfAbsent(key, () => KlpId._(key));
  }

  /// 工廠函式：自指定父命名空間建立或取得子節點。
  factory KlpId.of(KlpId parent, String leaf) {
    return parent.child(leaf);
  }

  /// 工廠函式：自多個路徑段解析並取得樹狀節點（保證唯一實例）。
  factory KlpId.from(Iterable<String> segments) {
    final list = segments.map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    if (list.isEmpty) {
      throw ArgumentError.value(
        segments,
        'segments',
        'KlpId segments cannot be empty.',
      );
    }

    var current = KlpId.root(list.first);
    for (var i = 1; i < list.length; i++) {
      current = current.child(list[i]);
    }
    return current;
  }

  /// 工廠函式：自點分隔字串解析並取得樹狀節點（例如 `planist.workspace.router`）。
  factory KlpId.parse(String path) {
    final trimmed = path.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(path, 'path', 'Path cannot be empty.');
    }
    return KlpId.from(trimmed.split('.'));
  }

  /// 建立或自當前節點快取取得子節點（若已存在直接回傳既有物件）。
  KlpId child(String leaf) {
    final key = leaf.trim();
    if (key.isEmpty) {
      throw ArgumentError.value(
        leaf,
        'leaf',
        'Leaf name cannot be empty or whitespace.',
      );
    }
    return _children.putIfAbsent(key, () => KlpId._(key, this));
  }

  /// 支援以語意化 `/` 運算子串接子節點。
  KlpId operator /(String leaf) => child(leaf);

  /// 當前節點段名稱。
  String get segment => name;

  /// 所屬作用域路徑段（排除當前葉節點）。
  List<String> get scope =>
      parent == null ? const [] : parent!.segments;

  /// 取得當前節點之最頂層根節點。
  KlpId get rootNode => parent?.rootNode ?? this;

  /// 是否為根節點。
  bool get isRoot => parent == null;

  /// 取得所有已實例化之直接子節點集合。
  Iterable<KlpId> get directChildren => _children.values;

  /// 取得自根節點至當前節點之所有祖先節點清單（由近至遠）。
  List<KlpId> get ancestors {
    final result = <KlpId>[];
    var current = parent;
    while (current != null) {
      result.add(current);
      current = current.parent;
    }
    return List.unmodifiable(result);
  }

  /// 內部安全轉換為 Kallopis 放置識別碼。
  KlpPlacementId toPlacementId() =>
      KlpPlacementId(scope: scope, localId: segment);

  @override
  bool operator ==(Object other) {
    // 享元模式下通常 identical(this, other) 即為 true
    if (identical(this, other)) return true;
    if (other is! KlpId || segments.length != other.segments.length) {
      return false;
    }
    return value == other.value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
