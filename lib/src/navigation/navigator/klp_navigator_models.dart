import 'package:flutter/widgets.dart';

import '../../foundation/klp_icon.dart';

/// Navigator 可注入資料的共同型別。
///
/// 對外只有 [KlpNavigatorCategory]、[KlpNavigatorElement] 與
/// [KlpNavigatorComponent] 三種具體模型。
@immutable
sealed class KlpNavigatorItem {

	const KlpNavigatorItem({required this.id});

	final String id;
}

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

/// 可在根層或分類內出現，並可遞迴包含子元素的 Navigator 節點。
@immutable
final class KlpNavigatorElement extends KlpNavigatorItem {

	const KlpNavigatorElement({
		required super.id,
		required this.label,
		this.icon,
		this.children = const [],
		this.expandable = false,
		this.expanded = false,
		this.selected = false,
		this.badge,
		this.trailing,
		this.data,
	});

	final String label;
	final KlpIconData? icon;
	final List<KlpNavigatorElement> children;
	final bool expandable;
	final bool expanded;
	final bool selected;
	final String? badge;
	final Widget? trailing;
	final Object? data;

	bool get isBranch => expandable || children.isNotEmpty;
}

/// 不受 Navigator 固定列高限制的任意元件插槽。
///
/// 搜尋框、虛線分隔線、按鈕列表等元件保留自己的高度、狀態與事件。
@immutable
final class KlpNavigatorComponent extends KlpNavigatorItem {

	const KlpNavigatorComponent({required super.id, required this.child});

	final Widget child;
}
