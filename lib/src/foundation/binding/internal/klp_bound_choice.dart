part of 'klp_bound_template.dart';

/// 借用同一選取來源的操作原語；callback 已由本庫附加生命週期檢查。
final class KlpBoundChoice extends KlpBoundTemplate {

	final KlpPlacementId id;
	final String label;
	final KlpState<KlpPlacementId?> selection;
	final FutureOr<void> Function()? onActivate;
	final KlpBoundTemplate child;
	final KlpBoundChoiceStyle style;

	const KlpBoundChoice({
		required this.id,
		required this.label,
		required this.selection,
		required this.onActivate,
		required this.child,
		required this.style,
	});
}
