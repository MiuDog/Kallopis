/// 放置識別分開保存作用域各段與本地識別，不以分隔符串接成查表鍵。
final class KlpPlacementId {
  final List<String> scope;
  final String localId;

  KlpPlacementId({List<String> scope = const [], required this.localId})
    : scope = List.unmodifiable(scope);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! KlpPlacementId ||
        localId != other.localId ||
        scope.length != other.scope.length) {
      return false;
    }
    for (var index = 0; index < scope.length; index++) {
      if (scope[index] != other.scope[index]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(Object.hashAll(scope), localId);

  @override
  String toString() => 'KlpPlacementId(scope: $scope, localId: $localId)';
}
