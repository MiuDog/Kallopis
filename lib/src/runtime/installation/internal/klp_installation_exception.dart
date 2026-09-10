/// 安裝失敗時保留各項錯誤，並明確指出結構是否已提交。
final class KlpInstallationException implements Exception {
  final bool committed;
  final List<({Object error, StackTrace stackTrace})> issues;

  KlpInstallationException(
    this.committed,
    Iterable<({Object error, StackTrace stackTrace})> issues,
  ) : issues = List.unmodifiable(issues);

  @override
  String toString() =>
      'KlpInstallationException(committed: $committed, issues: ${issues.length})';
}
