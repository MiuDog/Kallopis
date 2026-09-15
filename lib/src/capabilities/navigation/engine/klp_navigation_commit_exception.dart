/// 轉接層必須明示例外發生在提交前或提交後。
final class KlpNavigationCommitException implements Exception {
  final bool committed;
  final Object cause;
  final StackTrace stackTrace;

  const KlpNavigationCommitException(
    this.committed,
    this.cause,
    this.stackTrace,
  );

  @override
  String toString() =>
      'Navigation commit failed (committed: $committed): $cause';
}
