/// 一次已接受操作的通知與回呼錯誤；所有錯誤保留原始堆疊。
final class KlpRailActivationException implements Exception {
  final List<({Object error, StackTrace stackTrace})> failures;

  KlpRailActivationException(
    Iterable<({Object error, StackTrace stackTrace})> failures,
  ) : failures = List.unmodifiable(failures);

  @override
  String toString() =>
      'KlpRailActivationException: ${failures.length} failures';
}
