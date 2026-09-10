part 'klp_navigation_completed.dart';
part 'klp_navigation_cancelled.dart';
part 'klp_navigation_rejected.dart';
part 'klp_navigation_failed.dart';

/// 正常的空值結果與取消、拒絕、失敗分別表達。
sealed class KlpNavigationOutcome<R> {
  const KlpNavigationOutcome();
}
