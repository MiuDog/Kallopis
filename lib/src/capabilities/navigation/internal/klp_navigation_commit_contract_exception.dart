/// 提交接點違約時無法推定資源是否已提交，禁止繼續暴露可能失真的堆疊。
final class KlpNavigationCommitContractException implements Exception {
  final Object cause;
  final StackTrace stackTrace;

  const KlpNavigationCommitContractException(this.cause, this.stackTrace);

  @override
  String toString() =>
      'Navigation commit port threw without declaring commit status: $cause';
}
