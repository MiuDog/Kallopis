/// 載入通知與復原通知同時失敗時，保留兩者的原始錯誤。
final class KlpDataNotificationException implements Exception {
  final List<({Object error, StackTrace stackTrace})> issues;

  KlpDataNotificationException(
    Iterable<({Object error, StackTrace stackTrace})> issues,
  ) : issues = List.unmodifiable(issues);

  @override
  String toString() => 'KlpDataNotificationException(issues: ${issues.length})';
}
