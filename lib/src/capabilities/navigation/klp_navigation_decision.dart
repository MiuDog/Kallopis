import 'klp_navigation_outcome.dart';

/// 提交後的通知失敗仍帶有 committed，不能誤判為回退。
final class KlpNavigationDecision {
  final bool committed;
  final KlpNavigationOutcome<void> outcome;

  const KlpNavigationDecision(this.committed, this.outcome);
}
