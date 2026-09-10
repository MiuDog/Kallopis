part of 'klp_bound_template.dart';

/// 邊側先配置，中間取得剩餘空間；空間不足時改為整體可捲動流程。
final class KlpBoundRegions extends KlpBoundTemplate {

	final KlpAxis axis;
	final KlpBoundTemplate leading;
	final KlpBoundTemplate body;
	final KlpBoundTemplate trailing;
	final KlpDistance leadingExtent;
	final KlpDistance trailingExtent;
	final KlpDistance minimumBodyExtent;

	const KlpBoundRegions({
		required this.axis,
		required this.leading,
		required this.body,
		required this.trailing,
		required this.leadingExtent,
		required this.trailingExtent,
		required this.minimumBodyExtent,
	});
}
