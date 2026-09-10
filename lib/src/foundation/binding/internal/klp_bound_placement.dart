part of 'klp_bound_template.dart';

/// 已完成的放置內容保存穩定識別，讓同層重排不以索引重建元件。
final class KlpBoundPlacement extends KlpBoundTemplate {

	final KlpPlacementId id;
	final KlpBoundTemplate content;

	const KlpBoundPlacement(this.id, this.content);
}
