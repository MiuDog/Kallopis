part of 'klp_bound_template.dart';

/// 保留頁只接受已完成的放置快照，作用中識別必須唯一且存在。
final class KlpBoundRetainedStack extends KlpBoundTemplate {

	final List<KlpBoundPlacement> pages;
	final KlpPlacementId activeId;

	KlpBoundRetainedStack({required Iterable<KlpBoundPlacement> pages, required this.activeId}) : pages = List.unmodifiable(pages) {
		final identities = <KlpPlacementId>{};
		for (final page in this.pages) {
			if (!identities.add(page.id)) throw ArgumentError('Duplicate retained page identity.');
		}
		if (!identities.contains(activeId)) throw ArgumentError('Active retained page must exist.');
	}
}
