part of 'klp_advanced_models.dart';

@immutable
class KlpTreeNode {
	const KlpTreeNode({
		required this.id,
		required this.label,
		this.icon,
		this.children = const [],
		this.expanded = true,
		this.selected = false,
		this.hasChildren = false,
		this.deleted = false,
		this.badge,
		this.tone,
	});

	final String id;
	final String label;
	final KlpIconData? icon;
	final List<KlpTreeNode> children;
	final bool expanded;
	final bool selected;
	final bool hasChildren;
	final bool deleted;
	final String? badge;
	final KlpFeedbackTone? tone;
}
