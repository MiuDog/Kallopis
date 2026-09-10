import 'klp_navigation_cancellation.dart';
import 'klp_navigation_snapshot.dart';

/// Guard 只能讀取候選交易，不取得引擎或畫面資源。
final class KlpNavigationTransition {
  final KlpNavigationSnapshot? from;
  final KlpNavigationSnapshot to;
  final KlpNavigationCancellation cancellation;

  const KlpNavigationTransition(this.from, this.to, this.cancellation);

  bool get isInitial => from == null;
}
