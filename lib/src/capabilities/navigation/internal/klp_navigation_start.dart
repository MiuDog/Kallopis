part of 'klp_navigation_machine.dart';

/// 應用擁有端取得的啟動判定；只有已提交結果才持有可用機器。
final class KlpNavigationStart {

	final KlpNavigationMachine? machine;
	final KlpNavigationDecision decision;

	const KlpNavigationStart._(this.machine, this.decision);
}
