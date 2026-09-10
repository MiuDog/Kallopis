part of '../klp_navigator_models.dart';

/// 可展開與收合的一組 Navigator 項目。
@immutable
final class KlpNavigatorCategory extends KlpNavigatorItem {
	const KlpNavigatorCategory({
		required super.id,
		required this.label,
		this.items = const [],
		this.expanded = true,
		this.collapsible = true,
		this.trailing,
	});

	final String label;
	final List<KlpNavigatorItem> items;
	final bool expanded;
	final bool collapsible;
	final Widget? trailing;
}
