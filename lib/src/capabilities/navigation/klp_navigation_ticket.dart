import 'klp_navigation_decision.dart';
import 'klp_navigation_outcome.dart';

/// 接受結果與畫面返回結果各自完成一次；取消只影響尚未提交的請求。
final class KlpNavigationTicket<R> {

	final Future<KlpNavigationDecision> decision;
	final Future<KlpNavigationOutcome<R>> result;
	final void Function() _cancel;

	const KlpNavigationTicket(this.decision, this.result, void Function() cancel) : _cancel = cancel;

	void cancel() => _cancel();
}
